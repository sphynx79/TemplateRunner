# Welcome to RailsComposer

## Descrizione
Questo è un application template che uso per i miei progetti in Rails 4.2.
Come sviluppatore freelance ho la neccessità di avviare nuovi progetti in modo rapido e con un buon set di default.
Ho assemblato questo modello nel corso degli anni, per adattarlo alle mie esigenze, pur aderendo alla "Rails way".


## Prerequisiti
Questo template lavoro con:
* Ruby 2.2
* Rails 4.2x
* Mysql

## Installation

To make this the default Rails application template on your system, create a `~/.railsrc` file with these contents:

```
-d postgresql
-m https://raw.githubusercontent.com/mattbrictson/rails-template/master/template.rb
```

## Utilizzo
This template assumes you will store your project in a remote git repository (e.g. Bitbucket or GitHub) and that you will deploy using Capistrano to staging and production environments. It will prompt you for this information in order to pre-configure your app, so be ready to provide:

1. The git URL of your (freshly created and empty) Bitbucket/GitHub repository
2. The hostname of your staging server
3. The hostname of your production server

To generate a Rails application using this template, pass the `-m` option to `rails new`, like this:

```
rails new blog \
  -d postgresql \
  -m https://raw.githubusercontent.com/mattbrictson/rails-template/master/template.rb
```

*Remember that options must go after the name of the application.* The only database supported by this template is `postgresql`.

If you’ve installed this template as your default (using `~/.railsrc` as described above), then all you have to do is run:

```
rails new blog
```

## Che cosa fa?
Il template esegue i seguenti step:
1. Genera la struttura base della mia applicazione Rails.
2. Si assicura che bundle sia installato
3. Create the development and test databases
4. Commit everything to git
5. Check out a development branch
6. Push the project to the remote git repository you specified

## Che cosa è incluso?
#### Alcune vengono installate come gems, ma dove possibile vengono scaricati i file necessari e integrati all'interno dell'applicazione
* Core
    * [active_type][] – for building simple and effective form/service objects
    * [sidekiq][] – Redis-based job queue implementation for Active Job
* Configuration
    * [dotenv][] – in place of the Rails `secrets.yml`







## TODO
- [ ] Aggiungere integrazione con database
- [ ] Aggiungere supporto github

