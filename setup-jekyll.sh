#!/bin/bash

sudo apt-get install -y ruby-execjs ruby-dev ruby-gsl
sudo gem install rb-gsl

sudo gem install bundler
sudo bundle install
bundle exec jekyll serve 
