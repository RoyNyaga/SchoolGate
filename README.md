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

###
- stimulus generate command
`bin/rails generate stimulus contraller_name_in_plural`

Hey guys, still working on SchoolGate ~> A school management application. The goal for this app is business-oriented and to showcase our systematic approach to developing SAAS applications while paying attention to business needs and requirements. Given that we can't expose the development process of the application of our clients, we decided to build from scratch this app so as to share our experience with our community.



Early this month, we completed an MVP with the following features though not polished.

- User Registration and Authentication.

- Creation of Schools.

- Creation of classes.

- Creation of subjects.

- Filling of sequential marks.

- Grouping results into terms.

- Generating and downloading of report cards.

- Inviting Teachers to collaborate with a school through virtual contracts.



All of the above features were developed at a very basic level as we needed to see how some of our prospects would react to the app.



After encouraging feedback from our clients, we decided to put in more resources to make sure that we realize this app before the beginning of the next academic year.



Last week, we worked on optimizing the report card generation future by moving from HTML screenshot download to using Prawn(a ruby gem for generating PDFs). This gives us a lot of flexibility as to what we can do during and after generating a report card. Prawn seems to be a very good solution but we easily hit a performance problem as the time taken to generate report cards is directly proportional to the number of students. So the user experience would not be the best for schools with many students.