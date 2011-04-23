# CSV Builder

The CSV Builder Rails plugin provides a simple templating system for serving
dynamically generated CSV files from your application.

## Requirements

CSV Builder works with:

* Ruby 1.8.6/7 and Rails 2.1 or higher
* Ruby 1.9.x and Rails 2.3.6
* JRuby 1.4.0 and Rails 2.1 or higher

If you run Ruby 1.8.6/7 or JRuby it also depends upon the FasterCSV gem, which you can install with

  $ sudo gem install fastercsv

Encoding conversions are done with Iconv, so make sure you have it on your
development/production machine.

## Install

### Install as a gem (recommended)

    $ gem install csv_builder

Then add the gem dependency in your config:

    # config/environment.rb
    config.gem "csv_builder"
  
### Install as a plugin
  
    $ script/plugin install git://github.com/vidmantas/csv_builder.git

## Example

CSV template files are suffixed with `.csv.csvbuilder`, for example `index.csv.csvbuilder`

Add rows to your CSV file in the template by pushing arrays of columns into the
csv object.

     # First row
     csv << [ 'cell 1', 'cell 2' ]
     # Second row
     csv << [ 'another cell value', 'and another' ]
     # etc...

You can set the default filename for that a browser will use for 'save as' by
setting `@filename` instance variable in your controller's action method
e.g.

    @filename = 'report.csv'

You can set the input encoding and output encoding by setting
`@input_encoding` and `@output_encoding` instance variables.
These default to 'UTF-8' and 'LATIN1' respectively. e.g.

    @output_encoding = 'UTF-8'

You can set `@csv_options` instance variable to define options for FasterCSV 
generator. For example: 

    @csv_options = { :force_quotes => true, :col_sep => ';' }

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


== Troubleshooting

There's a known bug of encoding error in Ruby 1.9

For more details see https://rails.lighthouseapp.com/projects/8994/tickets/2188-i18n-fails-with-multibyte-strings-in-ruby-19-similar-to-2038


Copyright (c) 2008 Econsultancy.com and 2009 Vidmantas Kabošis, released under the MIT license
