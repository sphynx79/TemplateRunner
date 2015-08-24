require "ap"


@prefs = {}


def say_custom(tag, text); say "\033[1m\033[36m" + tag.to_s.rjust(10) + "\033[0m" + "  #{text}" end
def say_loud(tag, text); say "\033[1m\033[36m" + tag.to_s.rjust(10) + "  #{text}" + "\033[0m" end
def say_recipe(name); say "\033[1m\033[36m" + "recipe".rjust(10) + "\033[0m" + "  Running #{name} recipe..." end
def say_wizard(text); say_custom(@current_recipe || 'composer', text) end

def ask_wizard(question)
  ask "\033[1m\033[36m" + ("option").rjust(10) + "\033[1m\033[36m" + "  #{question}\033[0m"
end

def whisper_ask_wizard(question)
  ask "\033[1m\033[36m" + ("choose").rjust(10) + "\033[0m" + "  #{question}"
end

def yes_wizard?(question)
  answer = ask_wizard(question + " \033[33m(y/n)\033[0m")
  case answer.downcase
    when "yes", "y"
      true
    when "no", "n"
      false
    else
      yes_wizard?(question)
  end
end


def multiple_choice(question, choices)
  say_custom('option', "\033[1m\033[36m" + "#{question}\033[0m")
  values = {}
  choices.each_with_index do |choice,i|
    values[(i + 1).to_s] = choice[1]
    say_custom( (i + 1).to_s + ')', choice[0] )
  end
  answer = whisper_ask_wizard("Enter your selection:") while !values.keys.include?(answer)
  values[answer]
end


say_wizard("\033[1m\033[36m" + "" + "\033[0m")
say_wizard("\033[1m\033[36m" + ' _____       _ _' + "\033[0m")
say_wizard("\033[1m\033[36m" + "|  __ \\     \(_\) |       /\\" + "\033[0m")
say_wizard("\033[1m\033[36m" + "| |__) |__ _ _| |___   /  \\   _ __  _ __  ___" + "\033[0m")
say_wizard("\033[1m\033[36m" + "|  _  /\/ _` | | / __| / /\\ \\ | \'_ \| \'_ \\/ __|" + "\033[0m")
say_wizard("\033[1m\033[36m" + "| | \\ \\ (_| | | \\__ \\/ ____ \\| |_) | |_) \\__ \\" + "\033[0m")
say_wizard("\033[1m\033[36m" + "|_|  \\_\\__,_|_|_|___/_/    \\_\\ .__/| .__/|___/" + "\033[0m")
say_wizard("\033[1m\033[36m" + "                             \| \|   \| \|" + "\033[0m")
say_wizard("\033[1m\033[36m" + "                             \| \|   \| \|" + "\033[0m")
say_wizard("\033[1m\033[36m" + '' + "\033[0m")







# >-------------------------- Scelta preferenze utente --------------------------start<
# ################################################################################### #

# Scelta frameork css da utilizzare
@prefs[:css_framework] = multiple_choice "Choose a starter framework.",
          [["bootstrap", "bootstrap"],
          ["foundation", "foundation"],
          ["none", "none"]]

# Scelta generazione controller
@prefs[:controller] = yes_wizard? 'Do I need a root controller?'
if @prefs[:controller]
   answer = ask_wizard("What is my root controllers name?")
   @prefs[:controller] = answer 
end

# ################################################################################### #
# >-------------------------- Scelta preferenze utente --------------------------end


ap @prefs

exit



require_relative 'lib/utils'
# Prendo il path del template
path = File.expand_path File.dirname(__FILE__)

# Mi chiede se voglio generare un controller e il nome del controller

root_controller = yes? 'Do I need a root controller?'.green
if root_controller
   root_controller_name = ask("What is my root controllers name?".green).underscore
end

# Iniziallizza git
git :init

# Bootstrap: install from https://github.com/twbs/bootstrap
# Note: This is 3.0.0
# ==================================================
if yes?("Download bootstrap?".green)
  run "curl -s -L https://github.com/twbs/bootstrap/releases/download/v3.3.5/bootstrap-3.3.5-dist.zip -o bootstrap.zip", :verbose => false
  run "unzip bootstrap.zip -d bootstrap > NUL && rm bootstrap.zip", :verbose => false
  run "cp bootstrap/bootstrap-3.3.5-dist/css/bootstrap.css vendor/assets/stylesheets/", :verbose => false
  run "cp bootstrap/bootstrap-3.3.5-dist/js/bootstrap.js vendor/assets/javascripts/", :verbose => false
  run "cp -r bootstrap/bootstrap-3.3.5-dist/fonts vendor/assets/fonts/", :verbose => false
  run "rm -rf bootstrap", :verbose => false
  insert_into_file "app/assets/stylesheets/application.css", "*= require bootstrap\n ", :before => "*= require_tree .", :verbose => false
  insert_into_file "app/assets/javascripts/application.js", "//= require bootstrap\n", :before => "//= require turbolinks", :verbose => false
  append_to_file "app/assets/stylesheets/application.css", <<-EOF
   @font-face {
      font-family: 'Glyphicons Halflings';
      src: url('../assets/glyphicons-halflings-regular.eot');
      src: url('../assets/glyphicons-halflings-regular.eot?#iefix') format('embedded-opentype'), 
      url('../assets/glyphicons-halflings-regular.woff') format('woff'), 
      url('../assets/glyphicons-halflings-regular.ttf') format('truetype'), 
      url('../assets/glyphicons-halflings-regular.svg#glyphicons_halflingsregular') format('svg');
   }

  EOF
end

# rimuovo index.html
remove_file "README.rdoc", :verbose => false
remove_file "public/index.html", :verbose => false



#Add root controller
if root_controller
  generate :controller, "#{root_controller_name} index", :verbose => false
  route "root to: '#{root_controller_name}\#index'", :verbose => false
end
