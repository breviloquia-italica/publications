require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'citeproc'
  gem 'citeproc-ruby'
  gem 'csl-styles'
  gem 'bibtex-ruby'
end

require 'bibtex'
require 'citeproc'
require 'csl/styles'

# Usage: ruby render.rb bi.bib apa-no-ampersand >> README.md

cp = CiteProc::Processor.new style: ARGV[1], format: 'html'
cp.import BibTeX.open(ARGV[0]).to_citeproc
items = cp.render(:bibliography, cp.data)

items.each do |item|
    item.tr!('{}', '')
    item.gsub!(/<i>(.*?)<\/i>/, '_\1_')
    item.gsub!(URI.regexp(['http','https','ftp']), '[\0](\0)')
end

puts items.map { |item| "- #{item}\n" }
