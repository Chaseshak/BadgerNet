# BadgerNet

[![Build Status](https://travis-ci.com/Chaseshak/BadgerNet.svg?token=y8dTrJkpQLTEPjpNhoQh&branch=master)](https://travis-ci.com/Chaseshak/BadgerNet)
[![Coverage Status](https://coveralls.io/repos/github/Chaseshak/BadgerNet/badge.svg?branch=master)](https://coveralls.io/github/Chaseshak/BadgerNet?branch=master)

BadgerNet is a software that was developed for UW Athletics teams as a platform for coaches
to share information with their athletes and communicate effectively. The current system
works so poorly that most teams have abandoned the tool entirely in favor of easier to use sites
such as SharePoint, Google Docs or just using email. The only team currently using the platform
is the rowing team. Head coach Bebe Bryans continually expresses frustration for the tool since
it is frequently down, causing both athletes and coaches to not have access to crucial material,
and the difficulty of conducting simple tasks such as uploading a document and sending
emails/texts. The athletes on the team also dislike its lack of intuitive interface and the inability
to access most things on a phone. Creating a new BadgerNet would not only streamline the
process for the rowing team, but also have the potential to be used as intended, for multiple D1
teams across campus.


## [Requirements and Specifications](https://docs.google.com/a/wisc.edu/document/d/1gAdPAkvaDNVE49o0RkAB2j4luDTL61acY2U5jiWcgZk/edit?usp=sharing)

## [Design and Planning](https://docs.google.com/a/wisc.edu/document/d/1-rnstvInLwo8RdqzL6lavmdT60eLwlRIv4vweOJ0ilY/edit?usp=sharing)

## Versions
- Ruby: 2.4.0
- Rails: 5.1.4
- PostgreSQL: 9.5+

*Runs on Linux or Mac OSX machines*

## Project Setup

**Note**: This section assumes you have the above versions of the specified softwares installed on your machine.

**Note for CS 506 Instructors**:
This project cannot be built on the CSL machines. This is because:
1. The Ruby version on the CSL machines is installed to the `var/*/**` directory, so we are not able to install necessary gems (not even Rails (⌣\_⌣”) ) due to permissions errors.

2. Our project requires a (local) PostgreSQL database server. The CSL machines are not setup to allow you to run a database server.

You can find the most recent iteration build at: `http://badgernet.me`. There is a test user with the following credentials that will allow you to use the website. This is an admin, or 'Coach' user:

**email**: coach@example.com

**password**: CS5062017!

### Database Setup

Create a role using the configuration information from the [database config file](config/database.yml).

```
# Access the default postgres user account
$ sudo -i -u postgres
$ psql
# Now you're at the postgres console
postgres=# create role badgernet with createdb login password 'BadgerNet2017!';
# Quit the console
postgres=# \q
# Return to your user
$ exit
```

### Rails Project Setup Commands

Now we must get the rails application ready to go. Head to the project root, `cd path/to/BadgerNet/`.

```
# Install necessary gems
$ bundle install
# Setup database
$ bundle exec rake db:create
$ bundle exec rake db:migrate
$ bundle exec rake db:seed
# Run the project server on http://localhost:3000
$ bundle exec rails s
```

## Testing

[RSpec](https://github.com/rspec/rspec) is the chosen framework of automated tests that allows us to perform both unit and integration tests.

### Run entire test suite
`$ bundle exec rspec`

### Coverage Data

Code coverage data can be viewed on [coveralls](https://coveralls.io/github/Chaseshak/BadgerNet)! This will give you line by line coverage information for each file.

### Test Structure

All tests are contained in the `spec/` folder. There are several folders nested underneath this directory. 

`controllers/` contains unit tests for all application controllers

`factories/` contains model 'factories' or fake data sets. Derived from the [factory_girl_rails gem](https://github.com/thoughtbot/factory_bot) which allows us to easily create fake test data

`features/` contains integration tests. Integration tests are performed with RSpec and Capybara. Capybara allows us to automatically perform user actions through simple commands like "click on 'button'" using the selenium web driver

`helpers/` contains unit tests for helpers

`models/` contains unit tests for models

`support/` contains test helpers which are used to abstract common actions into support modules, such as logging in a user.


## Things we may want to cover in the future:

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
