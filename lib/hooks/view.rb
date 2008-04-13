module Hooks
  module View
    class << self
      ##
      # This adds a callback method for the view hook, with optional identifier
      def register_view(id = rand(1000000).to_s, &block)
        @view_hooks ||= {}
        @view_hooks[id] = block
      end
      
      ##
      # This removes any view hooks registered with the specified ID
      def deregister_view(id)
        @view_hooks.delete(id)
      end

      def plugin_views
        plugin_views = []
        unless @view_hooks.nil? || @view_hooks.values.nil?
          @view_hooks.keys.each do |key|
            hook = @view_hooks[key]
            if Hooks::is_hook_valid?(hook)
              begin
                result = hook.call
                result = [result] if result.is_a?(Hash)
                result.each { |r| plugin_views << r.merge({:plugin => Hooks::get_plugin(hook)}) }
              rescue
              end
            end
          end
        end
        plugin_views.sort { |a, b| a[:plugin].name <=> b[:plugin].name }
      end
    end
  end
end