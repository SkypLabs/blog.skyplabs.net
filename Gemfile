# frozen_string_literal: true

source 'https://rubygems.org'

# Fix CVE-2020-7595.
# https://github.com/advisories/GHSA-7553-jr98-vx47
gem 'nokogiri', '>= 1.10.8'

group :production do
  # Latest version available:
  # https://pages.github.com/versions/
  gem 'github-pages', '~> 218', group: :jekyll_plugins
end

group :development do
  gem 'rake', group: :test
end

group :test do
  gem 'html-proofer', '~> 3.18'
end
