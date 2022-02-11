require "bridgetown"

Bridgetown.load_tasks

# Run rake without specifying any command to execute a deploy build by default.
task default: :deploy

#
# Standard set of tasks, which you can customize if you wish:
#
desc "Build the Bridgetown site for deployment"
task deploy: [:clean, "tailwind:build", "frontend:build"] do
  Bridgetown::Commands::Build.start
end

desc "Build the site in a test environment"
task :test do
  ENV["BRIDGETOWN_ENV"] = "test"
  Bridgetown::Commands::Build.start
end

desc "Runs the clean command"
task :clean do
  Bridgetown::Commands::Clean.start
end

namespace :frontend do
  desc "Build the frontend with esbuild for deployment"
  task :build do
    ENV["BRIDGETOWN_ENV"] = "production"

    Rake::Task["tailwind:build"].execute
    sh "yarn run esbuild"
  end

  desc "Watch the frontend with esbuild during development"
  task :dev do
    ENV["BRIDGETOWN_ENV"] = "development"
    server_pid = fork { Rake::Task["tailwind:dev"].execute }
    sh "yarn run esbuild-dev"
    Process.kill "SIGTERM", server_pid
    sleep 1 # give processes time to clean up
    puts
  rescue Interrupt
  end
end

namespace :tailwind do
  desc "Build the CSS with Tailwind"
  task :build do
    ENV["NODE_ENV"] = "production"
    sh "yarn tailwindcss -i ./frontend/styles/main.css -o ./frontend/styles/index.css --minify"
  end

  desc "Watch the frontend with esbuild during development"
  task :dev do
    ENV["NODE_ENV"] = "development"
    sh "yarn tailwindcss -i ./frontend/styles/main.css -o ./frontend/styles/index.css --watch"
  rescue Interrupt
  end
end

desc "Runs the format commands"
task format: ["format:standard", "format:prettier"]

namespace :format do
  desc "Format with Standard"
  task :standard do
    sh "bin/standardrb"
  end

  desc "Format with Prettier"
  task :prettier do
    sh "yarn prettier --write ."
  rescue Interrupt
  end
end

desc "Runs the update commands"
task update: ["update:cssdb", "update:yarn"]

namespace :update do
  desc "Update browserlists db"
  task :cssdb do
    sh "npx browserslist@latest --update-db"
  end

  desc "Update yarn dependencies"
  task :yarn do
    sh "yarn upgrade-interactive --latest && yarn upgrade"
  rescue Interrupt
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
