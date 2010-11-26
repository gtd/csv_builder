Gem::Specification.new do |s|
  s.name    = 'mreinsch-csv_builder'
  s.version = '1.3.0'
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

  s.files = %w(MIT-LICENSE README.rdoc CHANGELOG.rdoc Rakefile rails/init.rb lib/csv_builder.rb lib/transliterating_filter.rb)
end
