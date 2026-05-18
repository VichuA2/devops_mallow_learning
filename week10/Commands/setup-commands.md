# Ruby on Rails AWS Hosting Setup

# EC2 Setup

sudo yum update -y

sudo yum install git -y

# Ruby Installation

sudo yum install -y gcc gcc-c++ make openssl-devel libyaml-devel readline-devel zlib-devel libffi-devel nodejs yarn

git clone https://github.com/rbenv/rbenv.git ~/.rbenv

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc

echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc

source ~/.bashrc

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

rbenv install 3.0.4

rbenv global 3.0.4

ruby -v

# Rails Setup

gem install rails -v 6.1.5

rails -v

bundle install

# Database Setup

bundle exec rails db:create

bundle exec rails db:migrate

# Puma Setup

bundle add puma

bundle exec puma -b tcp://0.0.0.0:3000

# Nginx Setup

sudo amazon-linux-extras install nginx1 -y

sudo systemctl start nginx

sudo systemctl enable nginx

sudo nginx -t

sudo systemctl restart nginx

# Systemd Service Setup

sudo nano /etc/systemd/system/rorapp.service

sudo systemctl daemon-reload

sudo systemctl enable rorapp

sudo systemctl start rorapp

sudo systemctl status rorapp

# Terraform Setup

terraform init

terraform validate

terraform plan

terraform apply

# sudo yum install stress -y

sudo yum install stress -y

stress --cpu 4 --timeout 300

# Rails Logger Fix

gem install logger

export RUBYOPT="-rlogger"

# MySQL Client Setup

sudo rpm -Uvh https://dev.mysql.com/get/mysql80-community-release-el7-11.noarch.rpm

sudo yum install mysql-community-client -y

# Webpacker Fix

yarn add webpack@4 webpack-cli@3

yarn install --ignore-engines

bundle exec rails webpacker:compile

# Process Management

pkill -f puma

rm -f tmp/pids/server.pid

lsof -i :3000

# RDS SSL Connectivity Test

mysql -h <RDS-ENDPOINT> -u admin -p --ssl-mode=REQUIRED

