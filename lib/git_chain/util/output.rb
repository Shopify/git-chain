module GitChain
  module Util
    module Output
      def puts(text)
        GitChain::Logger.info(text)
      end

      def puts_warning(text)
        GitChain::Logger.warn(text)
      end

      def puts_error(text)
        GitChain::Logger.error('{{x}} ' + text)
      end

      def puts_question(text)
        GitChain::Logger.info("{{?}} {{blue:#{text}}}")
      end

      def puts_info(text)
        GitChain::Logger.info('{{i}} ' + text)
      end

      def puts_success(text)
        GitChain::Logger.info("{{v}} {{green:#{text}}}")
      end

      def puts_skip(text)
        GitChain::Logger.info("{{*}} {{green:#{text}}}")
      end

      def puts_debug(text)
        GitChain::Logger.debug('{{>}} ' + text)
      end

      def puts_debug_git(*args)
        puts_debug(['git', *args].join(" "))
      end
    end
  end
end
