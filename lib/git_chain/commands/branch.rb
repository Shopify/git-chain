# frozen_string_literal: true
require "optparse"

module GitChain
  module Commands
    class Branch < Command
      def banner_options
        "<start_point> branch"
      end

      def description
        "Start a new branch, adding it to the chain"
      end

      def configure_option_parser(opts, options)
        super

        opts.on("-c", "--chain=NAME", "Chain name") do |name|
          options[:chain_name] = name
        end

        opts.on("-i", "--insert", "Insert in the middle of a chain instead of starting a new one") do
          options[:mode] = :insert
        end

        opts.on("--new", "Start a new chain instead of continuing the existing one") do
          options[:mode] = :new
        end
      end

      def parse_branch_options(options)
        case options[:args].size
        when 1
          start_point = Git.current_branch
          raise(Abort, "You are not currently on any branch") unless start_point
          branch_name = options[:args][0]
        when 2
          start_point, branch_name = options[:args]
        else
          raise(ArgError, "Expected 1 or 2 arguments")
        end

        raise(Abort, "#{start_point} is not a branch") if Git.exec("branch", "--list", start_point).empty?

        [start_point, branch_name]
      end

      def detect_chain(options, start_point, branch_name)
        return Models::Chain.from_config(options[:chain_name]) if options[:chain_name]

        return Models::Chain.from_config(branch_name) if options[:mode] == :new

        # mode is nil or :insert

        parent_branch = Models::Branch.from_config(start_point)

        return Models::Chain.from_config(branch_name) unless parent_branch.chain_name

        parent_chain = Models::Chain.from_config(parent_branch.chain_name)
        if parent_chain.branch_names.last == start_point
          parent_chain
        elsif options[:mode] == :insert
          parent_chain
        else
          # mode is nil, which will default to :new because we are in the middle of the chain
          Models::Chain.from_config(branch_name)
        end
      end

      def run(options)
        start_point, branch_name = parse_branch_options(options)

        chain = detect_chain(options, start_point, branch_name)
        branch_names = chain.branch_names

        if branch_names.empty?
          raise(Abort, "Unable to insert, #{options[:chain_name]} does not exist yet") if options[:mode] == :insert
          branch_names << start_point << branch_name
        else
          is_last = branch_names.last == start_point
          mode = options[:mode] || (is_last ? :insert : :new)

          case mode
          when :insert
            if is_last
              puts_info("Appending {{info:#{branch_name}}} at the end of chain {{info:#{chain.name}}}")
              branch_names << branch_name
            else
              puts_info("Inserting {{info:#{branch_name}}} after {{info:#{start_point}}} in chain #{chain.name}")
              index = branch_names.index(start_point)
              branch_names.insert(index + 1, branch_name)
            end
          when :new
            puts_info("Starting a new chain {{info:#{chain.name} from #{start_point}")
            branch_names = [start_point, branch_name]
          else
            raise("Invalid mode: #{mode}")
          end
        end

        begin
          Git.exec("checkout", start_point, "-B", branch_name)
        rescue Git::Failure => e
          raise(Abort, e)
        end

        Setup.new.call(["--chain", chain.name, *branch_names])
      end
    end
  end
end
