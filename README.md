# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Boostrap related articles
- https://dev.to/coorasse/rails-7-bootstrap-5-and-importmaps-without-nodejs-4g8

# Jobs and Ques
- https://gorails.com/episodes/solid-queue-rails
- https://gorails.com/episodes/mission-control-jobs-rails?autoplay=1

# PDF generation
- https://prawnpdf.org/manual.pdf

# Debuggin
- binding.break

# Articles
- https://rubyhero.dev/good-practices-with-active-record

# Domain name
- SchoolGate

### For postgres issues when it crashes on development when computer was not put off.
- delete the postmaster.pid file in the directory ls ~/../../usr/local/var/postgresql@14 using the command
`rm ~/../../usr/local/var/postgresql@14/postmaster.pid`
- Also make sure port number in ls ~/../../usr/local/var/postgresql@14/postgresql.conf is set to 5432 or the default value.
- Restart postgres server.

### stimulus commands
- stimulus generate command
`bin/rails generate stimulus contraller_name_in_plural`

## UI repo
- https://github.com/fonkwe/SchoolGate-

## google location implementation
- https://www.youtube.com/watch?v=J39KJ5jzH3E

## import maps article
- https://www.theodinproject.com/lessons/ruby-on-rails-importmaps#importmap-considerations

## performance inspection tools
- honeybadger

- https://www.reddit.com/r/rails/comments/blqc5i/generating_a_pdf_on_disk_using_prawn_and/

## loader feature
- https://www.youtube.com/watch?v=ZcXJCBe1UZU

## starting solid queue
- bundle exec rake solid_queue:start

## Starting Ngronk
- ngrok http --domain=square-suddenly-sole.ngrok-free.app 3000

## Profile and solid_queue heroku setups
- https://devcenter.heroku.com/articles/getting-started-with-rails7#create-a-procfile
- https://devcenter.heroku.com/articles/background-jobs-queueing#process-model
- http://stuff-things.net/2024/01/27/using-solid-queue-in-development-with-docker-and-on-heroku/

## Figaro
- figaro heroku:set -e production

## Puma configs
- WEB_CONCURRENCY: "2" # this configuration constrols the number of puma instances to be created
- RAILS_MAX_THREADS: "5" # This configuration constrols the maximum number of threads per a puma instance
- RAILS_MAX_THREADS: "2"
- https://justin.searls.co/posts/brand-new-rails-7-apps-exceed-heroku-s-memory-quotas/

## Heroku commmands
- heroku run bash

## Gradien
- https://cssgradient.io/

## Notes on facebook / whatsapp api
- To have a permanent user token i had to create a system user calledd schoolgate_system_user. I also gave permissions to the schoolgate app. Meta business suits calls these permissions assests. visit this link to learn more about facebook business suits system users: https://developers.facebook.com/docs/whatsapp/business-management-api/get-started#1--acquire-an-access-token-using-a-system-user-or-facebook-login
- In order to send whatsapp messages to any number, i had to register a phone number to business whatsapp that i then added to the from list of numbers that can send messages. this registration is done on https://developers.facebook.com/ or https://developers.facebook.com/apps/775709887968266/whatsapp-business/wa-dev-console/?business_id=147061361252910.
- Adding a registered phone number to the list of to numbers is on step 5 of the API setup page.
- the registered phone number should not originally have a whatsapp account associated to it. I used my orange number.
- Every registered phone number or to number has it's own Phone number ID which is added on the API base url to make request.
- Every registered phone number also have it's own templates.