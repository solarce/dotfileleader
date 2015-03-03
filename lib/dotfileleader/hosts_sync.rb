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

require "dotfileleader/rsync"

# For all the servers in the hosts block provided
# by --hosts, this method will sync sync all the
# files/folders in the fileset(s) to each server
# - currently just supports rsync
# - assumes remote servers
# - assumes the source of any dotfiles is in $HOME
def hosts_sync(config, options = {})

  file_base = ENV['HOME']
  hostgroup_info = get_hostgroup_info(config, options[:hosts])

  fprint("syncing hostgroup: #{hostgroup_info["name"]}")
  for server in hostgroup_info["servers"]
    fprint("syncing server: #{server}", depth = 5)

    for fileset in hostgroup_info["filesets"]
      fprint("syncing fileset: #{fileset[0]}", depth = 10)
      dotfilesets = fileset[1]

      for dotfiles in dotfilesets
        fprint("syncing dotfileset: #{dotfiles[0]}", depth = 15)
        dotfiles = dotfiles[1]

        for dotfile in dotfiles
          fprint("syncing dotfile: #{dotfile}")
          rsync_options = {
            :is_ssh => true,
            :src_path => "#{file_base}/#{dotfile}",
            :dst_path => "#{server}:#{dotfile}"
          }
          if options[:verbose] == true
            rsync_options[:verbose] = true
          end
          run_rsync(options = rsync_options)
        end
      end
    end
  end

end
