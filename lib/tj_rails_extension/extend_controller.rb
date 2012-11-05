module TjRailsExtension
  module Controller
    extend ActiveSupport::Concern

    protected

    def set_header
      record_class = controller_name.classify.constantize
      @header = case action_name
      when "index" then record_class.model_name.human
      when "show" then
        record = instance_variable_get("@#{controller_name.singularize}")
        record.respond_to?(:name) ? record.name : record.id
      when "new" then t("helpers.submit.create", :model => record_class.model_name.human)
      when "edit" then t("helpers.submit.update", :model => record_class.model_name.human)
      end
    end

    def save_record! record, options = {}
      options[:notice] ||= t("succeeded")
      options[:alert] ||= t("failed")
      options[:success_url] ||= url_for(record)
      if record.save
        flash[:notice] = options[:notice]
        redirect_to options[:success_url]
      else
        flash[:alert] = options[:alert]
        render case action_name
        when "create" then "new"
        when "update" then "edit"
        end
      end
    end

    # filters
    def find! options = {}
      options[:alert] ||= t("not_found")
      options[:fail_url] ||= send("#{controller_name}_path")
      options[:id_symbol] ||= :id
      record_class = controller_name.classify.constantize
      unless instance_variable_set("@#{controller_name.singularize}", record_class.find_by_id(params[options[:id_symbol]]))
        flash[:alert] = options[:alert]
        redirect_to options[:fail_url]
      end
    end

    def resource! options = {}
      options[:save_options] ||= {}
      options[:find_options] ||= {}
      options[:index] ||= {}

      record_class = controller_name.classify.constantize
      singular_string = controller_name.singularize
      plural_string = controller_name
      options[:index][:records] ||= record_class.paginate(:page => params[:page])
      case action_name
      when "index"
        instance_variable_set('@' + plural_string, options[:index][:records])
        set_header
      when "show"
        find!(options[:find_options])
        set_header unless response_body
      when "new"
        instance_variable_set('@' + singular_string, record_class.new)
        set_header
      when "create"
        record = instance_variable_set('@' + singular_string, record_class.new(params[singular_string]))
        save_record!(record, options[:save_options])
      when "edit"
        find!(options[:find_options])
        set_header unless response_body
      when "update"
        find!(options[:find_options])
        unless response_body
          record = instance_variable_get('@' + singular_string)
          record.assign_attributes params[singular_string]
          save_record!(record, options[:save_options])
        end
      when "destroy"
        find!(options[:find_options])
        unless response_body
          record = instance_variable_get('@' + singular_string)
          record.destroy
          flash[:notice] = t("succeeded")
          redirect_to send("#{controller_name}_path")
        end 
      end
    end
  end
end
::ActionController::Base.send :include, TjRailsExtension::Controller