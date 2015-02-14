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

# Helper functions for using rsync

require "rsync"

def is_rsync_installed()
  rsync_installed = Mixlib::ShellOut.new("/usr/bin/env which rsync")
  rsync_installed.run_command
  if rsync_installed.exitstatus == 1
    print "You need to install rsync to use dotfileleader"
  end
end
