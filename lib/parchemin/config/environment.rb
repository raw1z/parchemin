# coding: utf-8
module Parchemin
  class Application
    # Rails-style request params hash
    before do
      new_params = {}
      params.each_pair do |full_key, value|
        this_param = new_params
        split_keys = full_key.split(/\]\[|\]|\[/)
        split_keys.each_index do |index|
          break if split_keys.length == index + 1
          this_param[split_keys[index]] ||= {}
          this_param = this_param[split_keys[index]]
       end
       this_param[split_keys.last] = value
      end
      request.params.replace new_params
    end

    # Partial implementation
    helpers do
      def partial(template, *args)
        options = args.last.is_a?(::Hash) ? args.pop : {}
        options.merge!(:layout => false)
        if collection = options.delete(:collection) then
          collection.inject([]) do |buffer, member|
            buffer << haml(template, options.merge(:layout => false, :locals => {template.to_sym => member}))
          end.join("\n")
        else
          haml(template, options)
        end
      end
    end

    # Flash implementation
    use Rack::Session::Cookie

    helpers do
      def flash
        @_flash ||= {}
      end

      def redirect(uri, *args)
        session[:_flash] = flash unless flash.empty?
        status 302
        response['Location'] = uri
        halt(*args)
      end
    end

    before do
      @_flash, session[:_flash] = session[:_flash], nil if session[:_flash]
    end
  end
end
