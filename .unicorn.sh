#!/bin/bash
# This file is meant to be executed via systemd.
source /usr/local/rvm/scripts/rvm
source /etc/profile.d/rvm.sh

export CONFIGURED=yes
export TIMEOUT=50
export APP_ROOT=/home/rails/BadgerNet
export RAILS_ENV="production"
PATH=/usr/local/rvm/rubies/ruby-2.4.0/bin:/usr/local/sbin:/usr/bin:/bin:/sbin:/usr/local/rvm/bin:/usr/local/rvm/gems/ruby-2.4.0@global/bin:/usr/local/rvm/gems/ruby-2.4.0/bin/
export GEM_HOME="/home/rails/BadgerNet/vendor/bundle"
export GEM_PATH="/home/rails/BadgerNet/vendor/bundle:/usr/local/rvm/gems/2.4.0:/usr/local/rvm/gems/2.4.0@global"
export PATH="/home/rails/rails_project/vendor/bundle/bin:/usr/local/rvm/gems/2.4.0/bin:${PATH}"

# Passwords
export SECRET_KEY_BASE=7aad3b84148bc92b77be068f2dd3c5c8924e6565a7a6586aa0b2d3b4bf413538282d247bcbdce8e4ebe00bc9dca97c8778871ecfa459421324fba9a2f9217236

# Execute the unicorn process
/home/rails/BadgerNet/vendor/bundle/bin/unicorn \
        -c /etc/unicorn.conf -E production --debug
