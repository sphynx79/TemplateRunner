
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

def prefer(key, value); @prefs[key].eql? value end

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
#######################################################################################

# Scelta framework css da utilizzare
@prefs[:frontend] = multiple_choice "Choose a starter frontend.", [["no", "no"], ["bootstrap", "bootstrap"],["foundation", "foundation"]]
@prefs.delete(:frontend) if @prefs[:frontend] == "no"

# Scelta generazione controller
@prefs[:controller] = yes_wizard? 'Do I need a root controller?'
if @prefs[:controller]
   answer = ask_wizard("What is my root controllers name?")
   @prefs[:controller] = answer 
end
@prefs.delete(:controller) if @prefs[:controller] == false

#####################################################################################
# >-------------------------- Scelta preferenze utente --------------------------end



# >-------------------------- Start Action --------------------------start<
###########################################################################

def init_bootstrap
   say_wizard "init bootstrap"

   run "curl -s -k -L https://github.com/twbs/bootstrap/releases/download/v3.3.5/bootstrap-3.3.5-dist.zip -o bootstrap.zip"
   run "unzip bootstrap.zip -d bootstrap > NUL && rm bootstrap.zip"
   run "cp bootstrap/bootstrap-3.3.5-dist/css/bootstrap.css vendor/assets/stylesheets/"
   run "cp bootstrap/bootstrap-3.3.5-dist/js/bootstrap.js vendor/assets/javascripts/"
   run "cp -r bootstrap/bootstrap-3.3.5-dist/fonts vendor/assets/fonts/"
   run "rm -rf bootstrap"
   insert_into_file "app/assets/stylesheets/application.css", "*= require bootstrap\n ", :before => "*= require_tree ."
   insert_into_file "app/assets/javascripts/application.js", "//= require bootstrap\n", :before => "//= require turbolinks"
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

def init_foundation
   say_wizard "init foundation"
   run "curl -s -k -L http://foundation.zurb.com/cdn/releases/foundation-5.5.2.zip -o foundation.zip"
   run "unzip foundation.zip -d foundation > NUL && rm  foundation.zip"
   run "cp foundation/css/foundation.css vendor/assets/stylesheets/"
   run "cp -r foundation/js/foundation vendor/assets/javascripts/foundation"
   run "rm -rf foundation"
   insert_into_file "app/assets/stylesheets/application.css", "*= require foundation\n ", :before => "*= require_tree ."
   insert_into_file "app/assets/javascripts/application.js", "//= require_tree ../../../vendor/assets/javascripts/foundation\n", :before => "//= require turbolinks"
   append_to_file "app/assets/javascripts/application.js", "$(document).foundation();"
end

def init_controller(value)
   say_wizard "init controller #{value}"
   generate :controller, "#{value} index"
   route "root to: '#{value}\#index'"
end



########################################################################
# >-------------------------- Start Action --------------------------end



# >-------------------------- Init Action --------------------------start<
###########################################################################


def init_frontend(value)
   case value
   when "bootstrap"
      init_bootstrap
   when "foundation"
      init_foundation
   end
end




########################################################################
# >-------------------------- Init Action --------------------------end



# >-------------------------- Parse Option --------------------------start<
############################################################################

@prefs.each { |pref, value|
   case pref.to_s
   when "frontend" 
      @current_recipe = "frontend"
      say_recipe("frontend")
      init_frontend(value)
   when "controller"
      @current_recipe = "controller"
      say_recipe("controller")
      init_controller(value)
   else
      ""
   end
}
exit 1

#########################################################################
# >-------------------------- Parse Option --------------------------end

####################COSE DA FARE###########################
# Installare better_errors
# Installare quiet_assets
