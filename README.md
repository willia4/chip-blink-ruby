# chip-blink-ruby
The [C.H.I.P. computer from Next Thing Co.][chip] has many IO ports, features, 
and expansion capabilities. It also has a status LED that can be controlled
via software. That means that the LED can be made to blink. 

[fordsfords wrote a much better version of a blink utility][fordsfords]: 
it can use different control buses and even has a feature to flash differently
depending on the current battery level. 

To go above and beyond, fordsfords has an example in both C *and* bash. But I 
don't like writing in C or bash. So this is one in ruby.

[chip]: https://nextthing.co/pages/chip
[fordsfords]: https://github.com/fordsfords/blink

## Installation

### Ruby 
You need to install ruby on your C.H.I.P. I'm too daring to use an unprivileged
user so all commands below are for root. Adjust to taste. 

At the time of writing, the current version of ruby is 2.3.1. Also, adjust to taste. 

#### Install build dependencies. 
Not all of these are needed but I expect to want some of
them later so I'm throwing them all in for now. Adjust to taste.

    apt-get -y install wget curl build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev libxml2-dev  libsqlite3-dev libffi6 libffi-dev

#### Download ruby

    wget http://cache.ruby-lang.org/pub/ruby/ruby-2.3.1.tar.gz

#### Unarchive ruby

    tar -xvf ruby-2.3.1.tar.gz
    cd ruby-2.3.1

#### Build ruby

    ./configure && make && make install
    

### Gems
Ruby has an extensive library available through the gem system. This script
uses [daemons](https://github.com/thuehlinger/daemons) and [i2c-devices](https://github.com/cho45/ruby-i2c-devices)

#### Install daemons

    gem install daemons

#### Install i2c-devices
Unfortunately, the current version of this library (0.0.5) does not support forcing commands over the i2c bus. 
This is a requirement for controlling the LED. 

This feature has been merged into the library; but until a new version is published, you'll need to build the code. 
 
##### Install git

    apt-get -y install git

##### Clone the current i2c-devices code
    cd
    git clone https://github.com/cho45/ruby-i2c-devices.git

##### Build and install the development version of the gem

    cd ruby-i2c-devices
    gem build i2c-devices.gemspec
    gem install --local i2c-devices-0.0.5.gem 

## Install blink.rb
### Get the code
You could download the code directly from github; but you have git installed so why not use it? 

    cd
    git clone https://github.com/willia4/chip-blink-ruby.git
 
### Install the script

    cp chip-blink-ruby/blink.rb /usr/local/bin
    chmod 755 /usr/local/bin/blink.rb

### Install the service

    cp chip-blink-ruby/blink.service /etc/systemd/system/blink.service
    systemctl enable /etc/systemd/system/blink.service

## Start the service

    service blink start

## Stop the service

    service blink stop  

Thanks again to fordsfords for writing the code that I was able to copy.
