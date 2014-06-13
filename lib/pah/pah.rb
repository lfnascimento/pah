require File.expand_path(File.join('..', 'pah', 'version.rb'), File.dirname(__FILE__))

%w{colored}.each do |component|
  if Gem::Specification.find_all_by_name(component).empty?
    run "gem install #{component}"
    Gem.refresh
    Gem::Specification.find_by_name(component).activate
  end
end

require "rails"
require "colored"
require "bundler"

def template_root
  File.expand_path(File.join('..', 'pah'), File.dirname(__FILE__))
end

def partials
  File.join(template_root, 'partials')
end

def static_files
  File.join(template_root, 'files')
end

# Copy a static file from the template into the new application
def copy_static_file(path)
  remove_file path
  file path, File.read(File.join(static_files, path))
end

def apply_n(partial_name, message='')
  puts message.magenta

  in_root do
    Bundler.with_clean_env do
      apply "#{partials}/_#{partial_name}.rb"
    end
  end

  puts "\n"
end

def will_you_like_to?(question)
  answer = ask("Will you like to #{question} [y,n]".red)
  case answer.downcase
    when "yes", "y"
      true
    when "no", "n"
      false
    else
      will_you_like_to?(question)
  end
end

def ask_unless_test(*params)
  ask(*params)
end

def git_commit(message)
  message = "#{message}\n\nGenerated by pah version #{Pah::VERSION}"
  git commit: "-qm '#{message}'"
end