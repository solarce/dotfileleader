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

def make_executable(file)
  File.chmod(01755, file)
end

def create_symlink(src, dst, options = {})

  if options[:auto_exec] == true
    if File.executable?(src) == false
      make_executable(src)
    end
  end

  if File.exist?(dst) == true and File.symlink?(dst) != true
    puts "ERROR: #{dst} exists and is not a symlink, cannot make symlink"
  elsif File.symlink?(dst) == true and File.readlink(dst) != src
    puts "ERROR: #{dst} already points to #{File.readlink(dst)}"
  elsif File.symlink?(dst) == true and File.readlink(dst) == src
    nil
  else
    puts "Creating symlink #{src} -> #{dst}"
    File.symlink(src, dst)
  end
end

def manage_symlinks(config, options = {})
  hosts_list = []
  symlink_sets = {}
  auto_exec = false
  source_root = ENV['HOME']

  # Run through some sanity checking of the mode and hosts arguments
  if config["symlinks"] == nil
    puts "The configuration file does not contain a symlink section"
    exit 1
  elsif options[:mode] == "local" && options[:hosts] != nil
    puts "You don't need --hosts with local mode, it will be ignored"
  elsif options[:mode] == "remote" && options[:hosts] == nil
    puts "You need to include a --hosts argument with a hosts block from your config"
    exit 1
  elsif options[:mode] == "remote" && options[:hosts] != nil
    hosts_list = options[:hosts]
  end

  if config["symlinks"]["auto_make_exec"] == true
    auto_exec = true
  end

  puts "Managing symlinks"
  config["symlinks"].each do |item|
    destination = nil
    if item[0] != "auto_make_exec"
      if item[0] == "home_bin"
        destination = item[0].gsub(/home/, ENV['HOME']).gsub(/_/,"\/")
      else
        destination = "/#{item[0].gsub(/_/,"\/")}"
      end
      symlink_sets[destination] = item[1]
    end
  end

  #p symlink_sets

  symlink_sets.each do | dest, sources |
    options = {
      :auto_exec => auto_exec
    }
    sources["sources"].each do | source |
      source_path = "#{source_root}/#{source}"
      if File.directory?(source_path) == true
        directory_path = nil
        if source_path.end_with? "/"
          directory_path = source_path
        else
          directory_path = "#{source_path}/"
        end

        Dir["#{directory_path}*"].each do | dir_source |
          item_name = dir_source.split("/").last
          create_symlink(dir_source, "#{dest}/#{item_name}", options = options)
        end
      else
        item_name = source_path.split("/").last
        create_symlink(source_path, "#{dest}/#{item_name}", options = options)
      end
    end
  end

end

