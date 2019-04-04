require 'optparse'

module GitChain
  class Command
    class Branch < Command
      def banner_options
        "<start_point> branch"
      end

      def description
        "Start a new branch, adding it to the chain"
      end

      def configure_option_parser(opts, options)
        super

        opts.on("-n", "--name=NAME", "Chain name") do |name|
          options[:chain_name] = name
        end

        opts.on("-i", "--insert", "Insert in the middle of a chain instead of starting a new one") do
          options[:mode] = :insert
        end

        opts.on("--new", "Start a new chain instead of continuing the existing one") do
          options[:mode] = :new
        end
      end

      def run(options)
        case options[:args].size
        when 1
          start_point = Git.current_branch
          raise(AbortError, "You are not currently on any branch") unless start_point
          branch_name = options[:args][0]
        when 2
          start_point, branch_name = options[:args]
        else
          raise(ArgError, "Expected 1 or 2 arguments")
        end

        raise(AbortError, "#{start_point} is not a branch") if Git.exec('branch', '--list', start_point).empty?

        parent_branch = Model::Branch.from_config(start_point)
        chain_name = options[:chain_name]

        if chain_name
          if parent_branch.chain_name && options[:chain_name] != parent_branch.chain_name
            raise(AbortError, "Starting point #{start_point} already belongs to chain #{parent_branch.chain_name}")
          end
        elsif parent_branch.chain_name
          chain_name = parent_branch.chain_name
        else
          chain_name = branch_name
        end

        chain = Model::Chain.from_config(chain_name)
        branch_names = chain.branch_names

        if branch_names.empty?
          raise(AbortError, "Unable to insert, #{chain_name} does not exist yet") if options[:mode] == :insert
          branch_names << start_point << branch_name
        else
          is_last = branch_names.last == start_point
          mode = options[:mode] || (is_last ? :insert : :new)

          case mode
          when :insert
            if is_last
              puts("Appending #{branch_name} at the end of chain #{chain.name}")
              branch_names << branch_name
            else
              puts("Inserting #{branch_name} in chain #{chain.name}")
              index = branch_names.index(start_point)
              branch_names.insert(index + 1, branch_name)
            end
          when :new
            puts("Starting a new chain from #{start_point}")
            branch_names = [start_point, branch_name]
          else
            raise("Invalid mode: #{mode}")
          end
        end

        begin
          Git.exec('checkout', start_point, '-B', branch_name)
        rescue Git::Failure => e
          raise(AbortError, e)
        end

        Setup.new.call(['-n', chain_name, *branch_names])
      end
    end
  end
end
