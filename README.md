# CSV Builder

The CSV Builder Rails plugin provides a simple templating system for serving dynamically generated CSV files from your
application.

![Ruby](https://github.com/gtd/csv_builder/workflows/Ruby/badge.svg)

## Requirements

The current version of CSV Builder has been tested (manually at least, not all via CI) with:

* Rails 4.2.x, 5.2.x, 6.1.x
* Ruby 2.5.x, 2.6.x, 2.7.x

It should be compatible for all ruby >= 2.0 and rails >= 3.0 (not all combos tested)

For ruby 1.8 and 1.9, use version 2.1.2.

The legacy version (1.1.x) was originally developed and tested for Rails 2.1.  See [the legacy
docs](https://github.com/econsultancy/csv_builder) for more details.



## Install

### Install as a gem (recommended)

    $ gem install csv_builder

If you are using Bundler then [you know what to do](http://gembundler.com).



## Example

CSV template files are suffixed with `.csv.csvbuilder`, for example `index.csv.csvbuilder`

Add rows to your CSV file in the template by pushing arrays of columns into the csv object.

     # First row
     csv << [ 'cell 1', 'cell 2' ]
     # Second row
     csv << [ 'another cell value', 'and another' ]
     # etc...

You can set the default filename for that a browser will use for 'save as' by setting `@filename` instance variable in
your controller's action method e.g.

    @filename = 'report.csv'

You can set the input encoding and output encoding by setting `@input_encoding` and `@output_encoding` instance
variables.  These default to 'UTF-8' and 'ISO-8859-1' respectively. e.g.

    @output_encoding = 'UTF-8'

You can set `@csv_options` instance variable to define options for FasterCSV generator. For example: 

    @csv_options = { :force_quotes => true, :col_sep => ';' }

You can optionally stream your results line by line as they are generated. Results will stream if the underlying Rack server supports streaming, otherwise the results will be buffered and sent when the template finishes rendering. Just set `@streaming` to true:

    @streaming = true

You can respond with csv in your controller as well:

    respond_to do |format|
      format.html
      format.csv # make sure you have action_name.csv.csvbuilder template in place
    end 

You can also attach a csv file to mail sent out by your application by
including a snippet like the following in your mailer method

    attachment "text/csv" do |attachment|
      attachment.body = render(:file => 'example/index.csv.csvbuilder')
      attachment.filename = 'report.csv'
    end

## Streaming Support

Many csv files are quite large, and need to be streamed rather than return in a single shot. Csv stream handling is based on [an epic answer on stackoverflow about rails and streaming.](http://stackoverflow.com/questions/3507594/ruby-on-rails-3-streaming-data-through-rails-to-client). Streaming requires configuration of your rails app - you need to use a Rack that supports streaming. I've tested with Unicorn, and created [a separate sample](https://github.com/fawce/test_csv_streamer) project to facilitate testing on Heroku. (ed: *this note is very old and streaming support has not been updated lately*)


## Testing

The test harness here is a little unusual in that it wires in a standard rails app and then monkeypatches it in the
specs.  Because there is a standard rails app, it has its own Gemfile which is modified to refer back to the gemspec so
that you can use the standard workflow:

     bundle install && rake spec

Note that this means there are multiple `Gemfile.lock` files generated.  Per gem development best practices, those files
are not committed, and it can be easy to forget to remove all of them when you want to try a clean build after updating
some dependency.  Suggestion is to do:

     rm ./**/Gemfile.lock && bundle install && rake spec

## Troubleshooting

There's a known bug of encoding error in Ruby 1.9

For more details see https://rails.lighthouseapp.com/projects/8994/tickets/2188-i18n-fails-with-multibyte-strings-in-ruby-19-similar-to-2038


Original content Copyright (c) 2008 Econsultancy.com, 2009 Vidmantas Kabošis & 2011 Gabe da Silveira released under the MIT license
Updated content for streaming, Copyright (c) 2011 John Fawcett released under the MIT license
