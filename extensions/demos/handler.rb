#
# Copyright (c) 2006-2025 Wade Alcorn - wade@bindshell.net
# Browser Exploitation Framework (BeEF) - https://beefproject.com
# See the file 'doc/COPYING' for copying permission
#
module BeEF
  module Extension
    module Demos
      class Handler < BeEF::Core::Router::Router
        set :public_folder, File.expand_path(File.dirname(__FILE__)) + '/html/'
      end
    end
  end
end
