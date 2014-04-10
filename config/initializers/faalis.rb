Faalis::Engine.setup do |config|
  # Logger settings for Faalis.
  # Default value is the rails logger
  # config.logger = Logger.new(STDOUT)

  # Add your models which want to manage their permissions
  config.models_with_permission = []

  # Url prefix for dashboard section. default is '/dashboard'
  # config.dashboard_namespace = :dashboard
  config.dashboard_modules =
    {
     :newsletter =>
      {
       :icon => "fa fa-paperclip",
       :sidemenu => true,
       :title => _("Newsletters"),
      },
     :auth => {
      :icon => "fa fa-group",
      :title => _("Authentication"),
      :sidemenu => true,
      :model => "Faalis::Permissions::Auth"
    },

    }
end
