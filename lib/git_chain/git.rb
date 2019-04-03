require 'open3'

module GitChain
  class Git
    class Failure < StandardError
      def initialize(args, err)
        super("git #{args} failed: \n#{err}")
      end
    end

    class << self
      def capture3(*args, dir: nil)
        cmd = %w(git)
        cmd += ['-C', dir] if dir
        cmd += args
        Open3.capture3(*cmd)
      end

      def exec(*args, dir: nil)
        out, err, stat = capture3(*args, dir: dir)
        raise(Failure.new(args, err)) unless stat.success?
        out
      end
    end
  end
end
