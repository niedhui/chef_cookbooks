package 'git-core'

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
rbenv_ruby '2.0.0-p247'

user node[:user][:name] do
  password node[:user][:password]
  gid 'admin'
  home "/home/#{node[:user][:name]}"
  supports manage_home: true
  shell "/bin/bash"
end

