package 'git-core'
package 'vim'

# create deployer user
user node[:user][:name] do
  password node[:user][:password]
  gid 'admin'
  home "/home/#{node[:user][:name]}"
  supports manage_home: true
  shell "/bin/bash"
end

template "/home/#{node[:user][:name]}/.gemrc" do
  source "gemrc"
  owner node[:user][:name]
end


# install rbenv
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

rbenv_ruby '2.0.0-p247' do
  global true
end
rbenv_gem 'ruby-shadow' do
  source 'http://ruby.taobao.org'
end
rbenv_gem 'bundler' do
  source 'http://ruby.taobao.org'
end

execute "gem sources --remove http://rubygems.org"
execute "gem sources --add http://ruby.taobao.org"

# install nginx
include_recipe "nginx::source"
