# frozen_string_literal: true

task default: ['build', 'test:run']

# ------------------------------ #
# Dependencies
# ------------------------------ #

desc 'Install all the dependencies'
task install: ['bundle:unset_deployment_mode', 'bundle:unset_without'] do
  Rake::Task['bundle:install'].execute
  Rake::Task['yarn:install'].execute
end

desc 'Install only the production dependencies'
task install_prod: ['bundle:set_deployment_mode', 'bundle:without_non_prod'] do
  Rake::Task['bundle:install'].execute
  Rake::Task['yarn:install_prod'].execute
end

desc 'Upgrade all the dependencies'
task :upgrade do
  Rake::Task['bundle:update'].execute
  Rake::Task['yarn:upgrade'].execute
end

namespace :bundle do
  desc 'Install Ruby dependencies using Bundler'
  task :install do
    sh 'bundle install'
  end

  desc 'Update Ruby dependencies using Bundler'
  task :update do
    sh 'bundle update'
  end

  desc 'Enable deployment mode in Bundler'
  task :set_deployment_mode do
    sh 'bundle config set deployment \'true\''
  end

  desc 'Disable deployment mode in Bundler'
  task :unset_deployment_mode do
    sh 'bundle config unset deployment'
  end

  desc 'Set the \'without\' option in Bundler for non-production ' \
       'dependencies'
  task :without_non_prod do
    sh 'bundle config set without \'deployment test\''
  end

  desc 'Unset the \'without\' option in Bundler'
  task :unset_without do
    sh 'bundle config unset without'
  end
end

namespace :yarn do
  desc 'Install all the JavaScript dependencies using Yarn'
  task :install do
    sh 'yarn install'
  end

  desc 'Install only the production JavaScript dependencies using Yarn'
  task :install_prod do
    sh 'yarn install --production'
  end

  desc 'Upgrade the JavaScript dependencies using Yarn'
  task :upgrade do
    sh 'yarn upgrade'
  end
end

# ------------------------------ #
# Build
# ------------------------------ #

desc 'Build the website'
task build: ['install'] do
  Rake::Task['jekyll:build'].execute
end

desc 'Build the production-ready website'
task deploy: ['install_prod'] do
  Rake::Task['jekyll:build'].execute
end

namespace :jekyll do
  desc 'Build the Jekyll website'
  task :build do
    sh 'bundle exec jekyll build'
  end

  desc 'Clean the Jekyll website'
  task :clean do
    sh 'bundle exec jekyll clean'
  end

  desc 'Serve the Jekyll website locally'
  task :serve do
    sh 'bundle exec jekyll serve --future --drafts --incremental'
  end
end

# ------------------------------ #
# Test
# ------------------------------ #

namespace :test do
  desc 'Run all tests'
  task :run do
    Rake::Task['test:check_html'].execute
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
end

# ------------------------------ #
# Clean up
# ------------------------------ #

desc 'Delete the build artifacts'
task :cleanup do
  Rake::Task['jekyll:clean'].execute
end
