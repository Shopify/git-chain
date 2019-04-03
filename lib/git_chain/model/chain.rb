module GitChain
  class Model
    class Chain < Model
      attr_reader :name, :branches

      def initialize(name:, branches:)
        @name = name
        @branches = branches
      end

      class << self
        def all
          branch_by_name = {}

          branch_config_lines = <<~EOS
            branch.master.chain default
            branch.a.chain default
            branch.a.parentbranch master
            branch.a.branchpoint 8fd7c8bf2f643d47785f4726ca39bdb913eb576b
            branch.b.chain default
            branch.b.parentbranch a
            branch.b.branchpoint 3a3e22180a111603a693ba38716370c38ee1f8a1
            branch.c.chain default
            branch.c.parentbranch b
            branch.c.branchpoint 71ce39ca6742084319b3362f64a26a6e1cbf639a
          EOS

          branch_config_lines.split("\n").each do |line|
            key, value = line.split(" ")
            key = key["branch.".length..-1]

            key_parts = key.split(".")
            branch_name = key_parts.first
            attribute = key_parts[1]

            branch_by_name[branch_name] ||= {}
            branch_by_name[branch_name][attribute] = value
          end

          branch_by_name.map { |name, attributes| Branch.new(name: name, parent: attributes["parentbranch"], point: attributes["branchpoint"]) }
        end

        def sort(branches)
          sorted = []
          remaining = branches.clone

          current_parent = nil
          while !remaining.empty?
            node = remaining.find { |branch| branch.parent == current_parent }
            puts "node: #{node}"
            sorted << node
            remaining.delete(node)
            current_parent = node
          end

          sorted
        end
      end
    end
  end
end
