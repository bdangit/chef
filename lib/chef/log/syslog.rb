#
# Author:: Lamont Granquist (<lamont@chef.io>)
# Author:: SAWANOBORI Yukihiko (<sawanoboriyu@higanworks.com>)
# Copyright:: Copyright (c) 2015 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'logger'
require 'syslog-logger'

class Chef
  class Log
    #
    # Chef::Log::Syslog class.
    # usage in client.rb:
    #  log_location Chef::Log::Syslog.new("chef-client", ::Syslog::LOG_DAEMON)
    #
    class Syslog < Logger::Syslog
      attr_accessor :sync, :formatter

      def initialize(program_name = 'chef-client', facility = ::Syslog::LOG_DAEMON, logopts=nil)
        super
        return if defined? ::Logger::Syslog::SYSLOG
        ::Logger::Syslog.const_set :SYSLOG, SYSLOG
      end

      def write(message)
        data = message.match(/(\[.+?\]) ([\w]+):(.*)$/)
        self.send(data[2].downcase.to_sym, data[3].strip)
      rescue NoMethodError
        self.send(:info, message)
      end

      def close
      end
    end
  end
end

