Gem::Specification.new do |s|
  s.name    = 'csv_builder'
  s.version = '1.3.1'
  s.date    = '2010-11-26'

  s.summary = "CSV template Rails plugin"
  s.description = "CSV template Rails plugin"

  s.authors  = ['Econsultancy']
  s.email    = 'code@econsultancy.com'
  s.homepage = 'http://github.com/mreinsch/csv_builder'

  s.add_runtime_dependency(%q<fastercsv>)

  s.has_rdoc = true
  s.rdoc_options = ["--main", "README.rdoc"]
  s.extra_rdoc_files = %w(README.rdoc CHANGELOG.rdoc MIT-LICENSE)

  s.files = %w(MIT-LICENSE README.rdoc CHANGELOG.rdoc Rakefile rails/init.rb lib/csv_builder.rb lib/csv_builder/railtie.rb lib/csv_builder/template_handler.rb lib/csv_builder/transliterating_filter.rb)
end
