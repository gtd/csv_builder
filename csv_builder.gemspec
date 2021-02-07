Gem::Specification.new do |s|
  s.name = %q{csv_builder}
  s.version = "2.1.3"

  s.authors = [%q{Econsultancy}, %q{Vidmantas Kabosis}, %q{Gabe da Silveira}]
  s.email = %q{gabe@websaviour.com}
  s.homepage = %q{https://github.com/gtd/csv_builder}
  s.summary = %q{CSV template handler for Rails}
  s.description = %q{CSV template handler for Rails.  Enables :format => 'csv' in controllers, with templates of the form report.csv.csvbuilder.}
  s.licenses = [%q{MIT}]
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    "CHANGELOG.rdoc",
    "Gemfile",
    "MIT-LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "csv_builder.gemspec",
    "lib/csv_builder.rb",
    "lib/csv_builder/railtie.rb",
    "lib/csv_builder/template_handler.rb",
    "lib/csv_builder/transliterating_filter.rb",
    "rails/init.rb"
  ]

  s.required_ruby_version = '>= 2.0'

  s.add_runtime_dependency(%q<actionpack>, [">= 3.0.0"])
  s.add_development_dependency(%q<rails>, [">= 5.0.0", "< 6.0"])
  s.add_development_dependency(%q<rspec>, ["~> 3.0"])
  s.add_development_dependency(%q<rspec-rails>, ["~> 3.0"])
  s.add_development_dependency(%q<rack>, [">= 0"])
  s.add_development_dependency(%q<sqlite3>, [">= 0", "< 1.4"])
end
