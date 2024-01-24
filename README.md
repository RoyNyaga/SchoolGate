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

# PDF generation
- https://prawnpdf.org/manual.pdf

# Debuggin
- binding.break

# Articles
- https://rubyhero.dev/good-practices-with-active-record

# Domain name
- SchoolGate

### For postgres issues when it crashes on development when computer was not put off.
- delete the postmaster.pid file in the directory ls ~/../../usr/local/var/postgresql@14
- Also make sure port number in ls ~/../../usr/local/var/postgresql@14/postgresql.conf is set to 5432 or the default value.
- Restart postgres server.

### stimulus commands
- stimulus generate command
`bin/rails generate stimulus contraller_name_in_plural`

## UI repo
- https://github.com/fonkwe/SchoolGate-