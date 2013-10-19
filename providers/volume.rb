#
# Cookbook Name:: gluster
# Provider:: volume_set
#
# Copyright 2013, Heavy Water Ops, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

def whyrun_supported?
  true
end

use_inline_resources

def load_current_resource
  @name = new_resource.name
  @key = new_resource.key
  @value = new_resource.value
end

action :start do
  if stopped?
    execute "gluster volume start #{@name} force"
  end
end

action :stop do
  if started?
    # probably still requires user input
    execute "gluster volume stop #{@name} force"
  end
end

action :set do
  if set? do
      execute "gluster volume set #{@name} #{@key} #{value}"
    end
  end
end

def set?
  true
end

def started?
  `gluster volume info #{@new_resource.name} | grep -i started`
end

def stopped?
  `gluster volume info #{@new_resource.name} | grep -ci stopped`
end
