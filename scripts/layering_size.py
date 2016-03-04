#!/usr/bin/python -Es
# Copyright (C) 2016 Red Hat
# AUTHOR: Brent Baude <bbaude@redhat.com>
# see file 'COPYING' for use and warranty information
#
# layering_size allows you to see the size of each layer that make
# up an image.
#
#    This program is free software; you can redistribute it and/or
#    modify it under the terms of the GNU General Public License as
#    published by the Free Software Foundation; either version 2 of
#    the License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
#    02110-1301 USA.
#
#

import sys
try:
    import docker
except Exception:
    sys.exit("The docker-py package is not installed.  Install it")

c = docker.Client()

if len(sys.argv) < 2:
    sys.exit("Pass an image name")
image = sys.argv[1]

outputs = []
def get_parent_info(image):
    global outputs
    inspect_info = c.inspect_image(image)
    parent = inspect_info['Parent']
    iid = inspect_info['Id']
    size = inspect_info['Size']
    cmd = " ".join(inspect_info['ContainerConfig']['Cmd']).replace("/bin/sh -c ","")
    if len(parent) > 0:
        get_parent_info(parent)
    outputs.append({'id': iid, 'parent': parent, 'size': size, 'cmd': cmd})

    return inspect_info['VirtualSize']



total_size = str(round(float(get_parent_info(image)) / (1000 * 1000), 2))
print("")
col_out = "{:30}  {:10} {:20}"
print(col_out.format("Id", "Size(MB)", 'Command'))
print(col_out.format("-" * 20, "-" * 8, "-" * 10))

for image in outputs:
    mb = float(image['size']) / (1000 * 1000)
    print(col_out.format(image['id'][:30], str(round(mb, 2)), image['cmd'][:60]))

print("")
print(col_out.format("", "-" * 6, ""))
print(col_out.format("", total_size, ""))
