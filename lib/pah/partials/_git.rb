puts "Initializing new Git repo ...".magenta

copy_static_file '.gitignore'

git :init
git add: "--all"
git_commit 'Initial commit.'

puts "\n"