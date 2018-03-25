#!/usr/bin/env rake

require_relative 'tasks/maintainers'

$stdout.sync = true

# Style tests. cookstyle (rubocop) and Foodcritic
namespace :style do
  begin
    require 'cookstyle'
    require 'rubocop/rake_task'

    desc 'Run Ruby style checks'
    RuboCop::RakeTask.new(:ruby)
  rescue LoadError => e
    puts ">>> Gem load error: #{e}, omitting style:ruby" unless ENV['CI']
  end

  begin
    require 'foodcritic'

    desc 'Run Chef style checks'
    FoodCritic::Rake::LintTask.new(:chef) do |t|
      t.options = {
        fail_tags: ['any'],
        progress: true
      }
    end
  rescue LoadError
    puts ">>> Gem load error: #{e}, omitting style:chef" unless ENV['CI']
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

# ChefSpec
begin
  require 'rspec/core/rake_task'

  desc 'Run ChefSpec examples'
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.rspec_opts = [].tap do |a|
      a.push('--color')
      a.push('--format progress')
    end.join(' ')
  end
rescue LoadError => e
  puts ">>> Gem load error: #{e}, omitting unit" unless ENV['CI']
end

# Integration tests. Kitchen.ci
namespace :integration do
  desc 'List current local kitchen environments'
  task :list do
    # The use of Popen allows us to flush stdout and print the lines as we go.
    # If the KITCHEN_YAML env was set, then we need to clear it first.
    IO.popen('unset KITCHEN_YAML; kitchen list') do |f|
      puts f.gets until f.eof?
    end
  end

  begin
    require 'kitchen/rake_tasks'

    desc 'Run kitchen integration tests'
    Kitchen::RakeTasks.new
  rescue StandardError => e
    puts ">>> Kitchen error: #{e}, omitting #{task.name}" unless ENV['CI']
  end
end
desc 'Run all kitchen suites'
task integration: ['integration:kitchen:all']

if File.exist?('.kitchen.cloud.yml') || File.exist?('.kitchen.cloud.local.yml')
  # Cloud Integration tests. Kitchen.ci
  namespace :cloud do
    ENV['KITCHEN_YAML'] = '.kitchen.cloud.yml'
    ENV['KITCHEN_YAML'] = '.kitchen.cloud.local.yml' if File.exist?('.kitchen.cloud.local.yml')

    desc 'List current cloud kitchen environments'
    task :list do
      # The use of Popen allows us to flush stdout and print the lines as we go.
      IO.popen('kitchen list') do |f|
        puts f.gets until f.eof?
      end
    end

    desc 'Test all cloud kitchen environments concurrently'
    task :test do
      # The use of Popen allows us to flush stdout and print the lines as we go.
      # -c 999 triggers the test to run up to 999 instance concurrently.
      IO.popen('kitchen test -c 999') do |f|
        puts f.gets until f.eof?
      end
    end
    begin
      require 'kitchen/rake_tasks'

      desc 'Run kitchen integration tests'
      Kitchen::RakeTasks.new
    rescue StandardError => e
      puts ">>> Kitchen error: #{e}, omitting #{task.name}" unless ENV['CI']
    end
  end
  desc 'Run all cloud kitchen suites'
  task cloud: ['cloud:kitchen:all']
end

# TODO: Enable publishing to the Supermarket
# namespace :supermarket do
#   begin
#     require 'stove/rake_task'

#     desc 'Publish cookbook to Supermarket with Stove'
#     Stove::RakeTask.new
#   rescue LoadError => e
#     puts ">>> Gem load error: #{e}, omitting #{task.name}" unless ENV['CI']
#   end
# end

# Default
task default: %w(style unit)

desc 'Run Local Development tests: Style, Foodcritic, Maintainers, Unit Tests, and Test-Kitchen'
task local: %w(style unit integration)
