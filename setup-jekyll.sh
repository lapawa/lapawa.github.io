#!/bin/bash

sudo apt-get install ruby-execjs
sudo gem install rb-gsl

sudo gem install bundler
sudo bundle install
bundle exec jekyll serve 
