source 'https://rubygems.org'

# Fix CVE-2020-7595.
# https://github.com/advisories/GHSA-7553-jr98-vx47
gem 'nokogiri', '>= 1.10.8'

group :github_pages do
  # Latest version available:
  # https://pages.github.com/versions/
  gem 'github-pages', '~> 204', group: :jekyll_plugins
end

group :test, optional: true do
  gem 'html-proofer', '~> 3.15'
end
