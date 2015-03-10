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

require "toml"

# Loads TOML formatted config file
# - Assumes a default location of
#   $HOME/.dotfileleader.rc
# - This can be overridden with -c or
#   --config on the command line
def load_config(options = {})
  # Assume the default location if no
  # command-line location is provided
  if options[:config_file] == nil
    home = ENV['HOME']
    config_file = "#{home}/.dotfileleader.rc"
    puts "Loading default config #{config_file}"
    config = TOML.load_file(config_file)
  else
    puts "Loading #{options[:config_file]}"
    config = TOML.load_file(options[:config_file])
  end

  # If the show_config command is run, print out
  # the config file.
  if options[:show_config] == true
    PP.pp(config)
  end

  return config
end

# Gathers info about the hostgroup, including
# - hostgroup_name
# - hostgroup_servers
# - hostgroup_filesets
# Used mainly for hosts_sync()
def get_hostgroup_info(config, hosts)
  hostgroup_info = {}

  # Set the name based on hosts named passed in on the cli
  hostgroup_name = hosts

  # Get the config info for the host group from the
  # current config
  hostgroup_configs = config["hosts"][hostgroup_name]

  hostgroup_info["name"] = hostgroup_name
  hostgroup_info["servers"] = hostgroup_configs["servers"]
  hostgroup_info["filesets"] = {}

  # Since a hostgroup can have multiple filesets, we need
  # to loop through any and look up any dotfile sets in them
  for fileset_name in hostgroup_configs["filesets"]
    fileset_contents = get_fileset_contents(config, fileset_name)
    hostgroup_info["filesets"][fileset_name] = fileset_contents
  end

  return hostgroup_info
end

# Looks up the contents of a fileset, from the
# current config, based on the fileset_name
def get_fileset_contents(config, fileset_name)
  fileset_dotfile_contents = {}
  fileset_list = config["filesets"][fileset_name]

  # A fileset has one or more lists of dotfiles in it
  # so we'll get the dotfiles in each fileset
  for fileset in fileset_list
    dotfiles_list = get_dotfiles_list(config, fileset)
    fileset_dotfile_contents[fileset] = dotfiles_list
  end

  return fileset_dotfile_contents
end

# Gets a list of the dotfiles listed in a fileset
# based on the current config
def get_dotfiles_list(config, fileset_name)
  dotfiles_list = config["dotfiles"][fileset_name]

  return dotfiles_list
end
