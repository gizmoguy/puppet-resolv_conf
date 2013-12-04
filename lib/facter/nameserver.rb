#!/usr/bin/env ruby
#
# Adds a machine's nameservers as both individual facts and a single fact
# that contains a list of all nameservers.
#

Facter.add("nameserver_list") do
  setcode do
    nameserver = false

    # Find all the nameserver values in /etc/resolv.conf
    File.open("/etc/resolv.conf", "r").each_line do |line|
      if line =~ /^nameserver\s*(\S*)/
        if nameserver
          nameserver = nameserver + " " + $1
        else
          nameserver = $1
        end
      end
    end

    nameserver
  end
end

nameserver_count = 0

File.open("/etc/resolv.conf", "r").each_line do |line|
  if line =~ /^nameserver\s*(\S*)/
    nameserver = $1
    Facter.add("nameserver" + nameserver_count.to_s) do
      setcode do
        nameserver
      end
    end
    nameserver_count += 1
  end
end
