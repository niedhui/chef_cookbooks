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

rbenv_ruby File.expand_path('../../../../ruby-2.0.0-p247', __FILE__) do
  global true
end

rbenv_gem 'ruby-shadow' do
  source 'http://ruby.taobao.org'
end

rbenv_gem 'bundler' do
  source 'http://ruby.taobao.org'
end

#TODO: permissions
execute "gem sources --remove https://rubygems.org/"
execute "gem sources --add http://ruby.taobao.org"

# install nginx
include_recipe "nginx::source"

## iptables
include_recipe "simple_iptables::default"

simple_iptables_policy "INPUT" do
  policy "DROP"
end

# http://serverfault.com/questions/356282/cannot-ping-outside-network-with-these-ip-rules
simple_iptables_rule "system" do
  rule "-m state --state ESTABLISHED,RELATED "
  jump "ACCEPT"
end

# Allow all traffic on the loopback device
simple_iptables_rule "system" do
  rule "--in-interface lo"
  jump "ACCEPT"
end

simple_iptables_rule "ssh" do
  rule "--proto tcp --dport 22"
  jump "ACCEPT"
end

simple_iptables_rule "http" do
  rule [ "--proto tcp --dport 80",
         "--proto tcp --dport 443" ]
  jump "ACCEPT"
end

# ulimit
include_recipe "ulimit::default"

ulimit_domain "*" do
  filename 'all.conf'
  rule do
    item :nofile
    type :hard
    value 51200
  end
  rule do
    item :nofile
    type :soft
    value 51200
  end
end
