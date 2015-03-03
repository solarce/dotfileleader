#--
# Author:: Brandon Burton (<brandon@inatree.org>)
# Copyright:: Copyright (c) 2015, Brandon Burton.
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
#

require 'clamp'

require "dotfileleader"
require "dotfileleader/config"
require "dotfileleader/hosts_sync"

Clamp do

  # Global Options
  option ["-c", "--config" ], "CONFIG_FILE", "Path to the config file"
  option "--verbose", :flag, "Provide verbose output"

  # Syncs a host group, based on filesets and servers in config
  # - Uses --hosts on CLI to determine which hostgroup to use
  subcommand [ "sync"], "sync the files and binaries for a hosts group" do
    option "--hosts", "HOSTS", "The set of hosts to sync", :required => true

    def execute
      config = load_config()
      sync_options = {
        :is_ssh => true,
        :config => config,
        :hosts => hosts
      }

      if verbose?
        sync_options[:verbose] = true
        fprint("Verbose output on")
      end
      hosts_sync(config, options = sync_options)
    end

  end

  # Reads and outputs the config file.
  # - Assumes the file is in ~/.dotfileleader.rc unless
  #   -c or --config is included on the command line
  subcommand "show_config", "shows the current config" do

    def execute
      options = { :show_config => true }
      if config != nil
        p "loading #{config}"
        options[:config_file] = config_file
        load_config(options = options)
      else
        p "using default config"
        load_config(options = options)
      end
    end
  end
end

