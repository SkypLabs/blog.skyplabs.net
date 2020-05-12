# frozen_string_literal: true

# ------------------------------ #
# Dependencies
# ------------------------------ #

desc 'Install all dependencies'
task :install do
  Rake::Task['install_gems'].execute
  Rake::Task['install_js'].execute
end

desc 'Install Ruby dependencies using Bundler'
task :install_gems do
  sh 'bundle install'
end

desc 'Install JavaScript dependencies using Yarn'
task :install_js do
  sh 'yarn install'
end

# ------------------------------ #
# Build
# ------------------------------ #

desc 'Build the Jekyll website'
task :build => :install do
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
