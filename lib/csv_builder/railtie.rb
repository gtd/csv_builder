class CsvBuilder::Railtie < Rails::Railtie
  initializer "csv_builder.register_template_handler.action_view" do
    ActionView::Template.register_template_handler 'csvbuilder', CsvBuilder::TemplateHandler
  end
end
