module TjRailsExtension
  module Controller
    extend ActiveSupport::Concern

    included do
      class_eval do
        def self.default_resource_actions options = {}
          before_filter :find!, only: [:show, :edit, :update, :destroy]
          before_filter :set_header, only: [:index, :show, :new, :edit]
          @@options = options
          @@record_class = controller_name.classify.constantize
          @@singular_string = controller_name.singularize
          @@plural_string = controller_name
          
          class_eval do
            def index
              @@options[:index] ||= {}
              @@options[:index][:paginate] = (@@options[:index][:paginate] || {}).merge({page: params[:page]})
              instance_variable_set('@' + @@plural_string, @@record_class.paginate(@@options[:index][:paginate]))
            end

            def show
            end

            def new
              instance_variable_set('@' + @@singular_string, @@record_class.new)
            end

            def create
              record = instance_variable_set('@' + @@singular_string, @@record_class.new(params[@@singular_string]))
              save_record!(record, @@options[:create])
            end

            def edit
            end

            def update
              record = instance_variable_get('@' + @@singular_string)
              record.assign_attributes params[@@singular_string]
              save_record!(record, @@options[:update])
            end

            def destroy
              @@options[:destroy] ||= {}
              @@options[:destroy][:notice] ||= t("tj.destroy_successful")
              @@options[:destroy][:redirect] ||= send("#{controller_name}_path")

              record = instance_variable_get('@' + @@singular_string)
              record.destroy
              flash[:notice] = @@options[:destroy][:notice]
              redirect_to @@options[:destroy][:redirect]
            end
          end
        end
      end
    end

    protected

    def set_header
      record_class = controller_name.classify.constantize
      @header = case action_name
      when "index" then record_class.model_name.human
      when "show" then
        record = instance_variable_get("@#{controller_name.singularize}")
        if record.respond_to?(:name) then record.name
        elsif record.respond_to?(:title) then record.title
        else record.id
        end
      when "new" then t("helpers.submit.create", :model => record_class.model_name.human)
      when "edit" then t("helpers.submit.update", :model => record_class.model_name.human)
      end
    end

    def save_record! record, options = {}
      options ||= {}
      options[:notice] ||= t("tj.save_successful")
      options[:alert] ||= t("tj.save_failed")
      options[:redirect] ||= url_for(record)
      if record.save
        flash[:notice] = options[:notice]
        redirect_to options[:redirect]
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
      options ||= {}
      options[:alert] ||= t("tj.not_found")
      options[:redirect] ||= send("#{controller_name}_path")
      options[:id_symbol] ||= :id
      record_class = controller_name.classify.constantize
      unless instance_variable_set("@#{controller_name.singularize}", record_class.find_by_id(params[options[:id_symbol]]))
        flash[:alert] = options[:alert]
        redirect_to options[:redirect]
      end
    end
  end
end
::ActionController::Base.send :include, TjRailsExtension::Controller