# Big Cartel Theme Fonts [![Build Status](https://travis-ci.org/bigcartel/bigcartel-theme-fonts.png?branch=master)](https://travis-ci.org/bigcartel/bigcartel-theme-fonts) [![Gem Version](https://badge.fury.io/rb/bigcartel-theme-fonts.png)](http://badge.fury.io/rb/bigcartel-theme-fonts)

A simple class for working with Big Cartel's supported theme fonts. Used internally by [Big Cartel](http://bigcartel.com) and [Dugway](https://github.com/bigcartel/dugway).

## Install

Add this line to your application's Gemfile:

```ruby
gem 'bigcartel-theme-fonts'
```

And then execute:

```ruby
bundle
```

Or install it yourself as:

```ruby
gem install bigcartel-theme-fonts
```

## Usage

```ruby
georgia = ThemeFont.find_by_name('Georgia')
georgia.name #=> 'Georgia'
georgia.family #=> 'Georgia, "Times New Roman", Times, serif'
georgia.collection #=> 'default'
```

```ruby
ThemeFont.google_font_url_for_all_fonts #=> "//fonts.googleapis.com/css?family=One|Two"
```

## Rubygems Update

To update at rubygems run `gem push` and it should prompt you for a UN/PW. Use
rubygems credentials in BC 1password vault. Additionally, you'll need to also
increment the version number in the bigcartel-theme-fonts.gemspec and commit
that. Once that’s done there is a rake task `rake release` that builds and
pushes the gem to rubygems.
