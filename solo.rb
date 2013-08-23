# sudo chef-solo -c /fullpath/solo.rb
cookbook_path File.expand_path('../cookbooks', __FILE__)
json_attribs File.expand_path('../node.json', __FILE__)
