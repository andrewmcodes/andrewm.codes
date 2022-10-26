require "bridgetown"

Bridgetown.load_tasks

# Run rake without specifying any command to execute a deploy build by default.
task default: :deploy

#
# Standard set of tasks, which you can customize if you wish:
#
desc "Build the Bridgetown site for deployment"
task deploy: [:clean, "frontend:build"] do
  Bridgetown::Commands::Build.start
end

desc "Build the site in a test environment"
task :test do
  ENV["BRIDGETOWN_ENV"] = "test"
  Bridgetown::Commands::Build.start
end

desc "Runs all of the linters"
task lint: ["lint:standard", "lint:prettier", "lint:stylelint", "lint:html"]

desc "Runs all of the formatters"
task format: ["format:package_json", "format:prettier", "format:stylelint", "format:standard"]

desc "Runs Storybook in development mode"
task :storybook do
  sh "yarn storybook:start"
rescue Interrupt
end

desc "Runs the clean command"
task :clean do
  Bridgetown::Commands::Clean.start
end

namespace :frontend do
  desc "Build the frontend with esbuild for deployment"
  task :build do
    sh "touch frontend/styles/jit-refresh.css"
    sh "yarn run esbuild"
  end

  desc "Watch the frontend with esbuild during development"
  task :dev do
    sh "touch frontend/styles/jit-refresh.css"
    sh "yarn run esbuild-dev"
  rescue Interrupt
  end
end

namespace :torchlight do
  desc "Run torchlight on the site output"
  task :build do
    sh("yarn torchlight") if ENV["BRIDGETOWN_ENV"] == "production"
  end

  desc "Watch the output with torchlight during development"
  task :dev do
    sh("yarn torchlight --watch") if ENV["TORCHLIGHT_TOKEN"]
  rescue Interrupt
  end
end

namespace :format do
  desc "Format the package.json file"
  task :package_json do
    sh "yarn package-json:fix"
  end
  desc "Format with Prettier"
  task :prettier do
    sh "yarn prettier:fix"
  end

  desc "Format with Stylelint"
  task :stylelint do
    sh "yarn stylelint:fix"
  end

  desc "Format with Standard"
  task :standard do
    sh "bin/standardrb --fix --format progress"
  end
end

namespace :lint do
  desc "Lint with LintHTML"
  task :html do
    sh "yarn html:lint"
  end

  desc "Lint with Prettier"
  task :prettier do
    sh "yarn prettier:lint"
  end

  desc "Lint with Stylelint"
  task :stylelint do
    sh "yarn stylelint:lint"
  end

  desc "Lint with Standard"
  task :standard do
    sh "bin/standardrb --format progress"
  end
end

#
# Add your own Rake tasks here! You can use `environment` as a prerequisite
# in order to write automations or other commands requiring a loaded site.
#
# task :my_task => :environment do
#   puts site.root_dir
#   automation do
#     say_status :rake, "I'm a Rake tast =) #{site.config.url}"
#   end
# end
