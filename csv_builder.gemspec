Gem::Specification.new do |s|
  s.name    = 'csv_builder'
  s.version = '0.1.3'
  s.date    = '2009-06-27'
  
  s.summary = "CSV template Rails plugin"
  s.description = "CSV template Rails plugin"
  
  s.authors  = ['Econsultancy']
  s.email    = 'code@econsultancy.com'
  s.homepage = 'http://github.com/mreinsch/csv_builder'
  
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README.rdoc"]
  s.extra_rdoc_files = %w(README.rdoc CHANGELOG.rdoc MIT-LICENSE)

  s.files = %w(MIT-LICENSE README.rdoc CHANGELOG.rdoc Rakefile rails/init.rb lib/csv_builder.rb)
end
