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
require "dotfileleader/rsync"

Clamp do

  subcommand ["rsync", "sync"], "sync your files and binaries" do
    option "--src-path", "SRC_PATH", "Where to sync from", :required => true
    option "--dst-path", "DST_PATH", "Where to sync to", :required => true

    def execute
      is_rsync_installed()
      is_ssh = true
      run_rsync(src_path, dst_path, is_ssh)
    end

  end
end

