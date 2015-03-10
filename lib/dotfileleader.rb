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

require "mixlib/shellout"
require 'pp'

require "dotfileleader/cli"
require "dotfileleader/config"
require "dotfileleader/rsync"
require "dotfileleader/symlink_manager"

# Easily print the contents of an object
def pprint(object)
  PP.pp(object)
end

# Print strings with variable indentation
def fprint(object, depth = 0)
  #puts "%10s" % ["foo"]
  puts "%10s" % [object.to_s]
end

