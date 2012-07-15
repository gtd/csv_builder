Gem::Specification.new do |s|
  s.name = %q{csv_builder}
  s.version = "2.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Econsultancy}, %q{Vidmantas Kabosis}, %q{Gabe da Silveira}]
  s.date = %q{2012-05-24}
  s.description = %q{CSV template handler for Rails.  Enables :format => 'csv' in controllers, with templates of the form report.csv.csvbuilder.}
  s.email = %q{gabe@websaviour.com}
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
  s.homepage = %q{http://github.com/dasil003/csv_builder}
  s.licenses = [%q{MIT}]
  s.require_paths = [%q{lib}]
  s.requirements = [%q{iconv or Ruby 1.9}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{CSV template handler for Rails}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionpack>, [">= 3.0.0"])
      s.add_runtime_dependency('fastercsv') if RUBY_VERSION.to_f < 1.9
      s.add_development_dependency(%q<rails>, [">= 3.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.5"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.5"])
      s.add_development_dependency(%q<rack>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<actionpack>, [">= 3.0.0"])
      s.add_dependency('fastercsv') if RUBY_VERSION.to_f < 1.9
      s.add_dependency(%q<rails>, [">= 3.0.0"])
      s.add_dependency(%q<rspec>, ["~> 2.5"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.5"])
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<actionpack>, [">= 3.0.0"])
    s.add_dependency('fastercsv') if RUBY_VERSION.to_f < 1.9
    s.add_dependency(%q<rails>, [">= 3.0.0"])
    s.add_dependency(%q<rspec>, ["~> 2.5"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.5"])
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end

