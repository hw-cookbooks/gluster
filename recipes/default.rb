#
# Cookbook Name:: gluster
# Recipe:: default
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

apt_repository "gluster" do
  uri "http://ppa.launchpad.net/semiosis/ubuntu-glusterfs-3.4/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  key "774BAC4D"
  keyserver "keyserver.ubuntu.com"
  action :add
  notifies :run, "execute[apt-get update]", :immediately
end

package "glusterfs-client"
package "glusterfs-server"

# ensure instances has ephemeral storage for gluster use
# format ephemeral storage if needed (to ext4)
# mkfs.ext4 -m 1 -L gluster /path/to/ephemeral-blockdev
# add to fstab
#  echo -e "LABEL=gluster\t/export\text4\tnoatime\t0\t2" >> /etc/fstab

# start the service
service "glusterfs-server" do
  action [:enable, :start]
end

# join the pool and start volume?
# maybe:
# gluster peer probe $SERVERNAME
# gluster volume create <volume> replica 2 transport tcp $SERVER1:/export $SERVER2:/export
# gluster volume start <volume>

#gluster_volume "webs"

# permissions - LWRP
# gluster volume set <volume> auth.allow '*'
# gluster volume set <volume> performance.cache-size 256MB

# gluster_volume "name" do
#   key "auth.allow"
#   value "*"
#   action :set
# end
