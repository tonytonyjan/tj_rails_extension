module BootstrapHelper
  def error_message *params
    options = params.extract_options!.symbolize_keys
    error_messages_for(*params, {:class=>"alert alert-block alert-error", :header_tag=>"h4"}.merge(options))
  end

  def nav_li *args, &block
    options = (block_given? ? args.first : args.second) || {}
    url = url_for(options)
    active = "active" if url == request.path || url == request.url
    content_tag :li, :class => active do
      link_to *args, &block
    end
  end
  
  def notice_message
    flash_messages = []
    flash.each do |type, message|
      type = case type
      when :notice then :success
      when :alert then :error
      end
      content = content_tag :div, :class => "alert fade in alert-#{type}" do
        button_tag("x", :class => "close", "data-dismiss" => "alert") + message
      end
      flash_messages << content if message.present?
    end
    flash_messages.join("\n").html_safe
  end

  def page_header title, options = {}
    options[:summary] ||= nil
    options[:header_tag] ||= :h1
    content_tag :div, :class => "page-header" do
      content_tag options[:header_tag] do
        title += content_tag(:small, options[:summary]) unless options[:summary].blank?
        title
      end
    end
  end
end