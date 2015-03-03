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

# Detects if rsync is present and exits with an error
# if it is not
def is_rsync_installed()
  rsync_installed = Mixlib::ShellOut.new("/usr/bin/env which rsync")
  rsync_installed.run_command
  if rsync_installed.exitstatus == 1
    puts "You need to install rsync to use dotfileleader"
    exit(1)
  end
end

# Syncs the source and destination using rsync
# - assumes that the destination is remote
# - Will give additional output if --verbose is included
#   on the command line
# - has error handling
def run_rsync(options = {})

  # Ensure the rsync binary is present
  is_rsync_installed()

  if options[:is_ssh] == true
    args = "-e ssh -vaP"
  else
    args = "-vaP"
  end
  src_path = options[:src_path]
  dst_path = options[:dst_path]
  rsync_cmd = Mixlib::ShellOut.new("rsync #{args} #{src_path} #{dst_path}")
  rsync_cmd.run_command()

  #pprint(rsync_cmd)
  if rsync_cmd.exitstatus == 0
    if options[:verbose] == true
      puts "----\nrsync output:"
      puts rsync_cmd.stdout
      puts "----"
    end
    puts "Successfully synced #{src_path} to #{dst_path}"
  else
      puts rsync_cmd.exitstatus
      pprint(rsync_cmd.stdout)
  end

end
