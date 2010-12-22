# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.plugin :git # `gem install hoe-git`
Hoe.plugins.delete :rubyforge

Hoe.spec 'horo' do
  developer('Aaron Patterson', 'aaron@tenderlovemaking.com')
  self.readme_file   = 'README.rdoc'
  self.history_file  = 'CHANGELOG.rdoc'
  self.extra_rdoc_files  = FileList['*.rdoc']
  self.extra_deps     << ['rdoc', '>= 2.5'] # Tested with RDoc 3
  self.extra_dev_deps << ['nokogiri', '>= 1.4.2']
end

# vim: syntax=ruby
