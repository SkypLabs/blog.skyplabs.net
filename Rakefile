# frozen_string_literal: true

# ------------------------------ #
# Build
# ------------------------------ #

desc 'Build the Jekyll website'
task :build do
  sh 'bundle exec jekyll build'
end

# ------------------------------ #
# Test
# ------------------------------ #

desc 'Run tests'
task :test do
  Rake::Task['check_html'].execute
end

desc 'Check the HTML syntax'
task :check_html do
  require 'html-proofer'

  options = {
    assume_extension: true,
    check_favicon: true,
    check_opengraph: true,
    only_4xx: true
  }

  HTMLProofer.check_directory('./_site', options).run
end

# ------------------------------ #
# Clean up
# ------------------------------ #

desc 'Delete build artifacts'
task :cleanup do
  rm_rf './_site'
end
