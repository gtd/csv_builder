require 'csv_streamer'

ActionView::Template.register_template_handler 'csvbuilder', CsvBuilder::StreamingTemplateHandler
