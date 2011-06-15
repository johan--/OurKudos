class Devise::Mailer < ActionMailer::Base

  include Devise::Controllers::ScopedViews
  attr_accessor :scope_name, :resource

  def host
    "http://#{OurKudosMainSite::Application.config.action_mailer.default_url_options[:host]}"
  end

  def reset_password_instructions(record, identity)
    initialize_from_record(record, identity)
    mail headers_for(:reset_password_instructions, identity)
  end

  def initialize_from_record(record, identity)

    @scope_name = ::Devise::Mapping.find_scope!(record)
    @resource   = instance_variable_set("@#{devise_mapping.name}", record)
    @email      = @resource.email if identity.blank?
    @email      = identity unless identity.blank?
    @host       = host
  end

   def devise_mapping
    @devise_mapping ||= Devise.mappings[scope_name]
   end

  def headers_for(action, identity)
    headers = {
      :subject       => I18n.t('devise.mailer.reset_password_instructions.subject'),
      :from          => mailer_sender(devise_mapping),
      :to            => (identity || resource.email),
      :template_path => template_paths
    }

    if resource.respond_to?(:headers_for)
      headers.merge!(resource.headers_for(action))
    end

    unless headers.key?(:reply_to)
      headers[:reply_to] = headers[:from]
    end

    headers
  end

  def mailer_sender(mapping)
    if ::Devise.mailer_sender.is_a?(Proc)
      ::Devise.mailer_sender.call(mapping.name)
    else
      ::Devise.mailer_sender
    end
  end

  def template_paths
    template_path = [self.class.mailer_name]
    template_path.unshift "#{@devise_mapping.scoped_path}/mailer" if self.class.scoped_views?
    template_path
  end


end