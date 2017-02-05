#!/usr/bin/env ruby
# coding: utf-8
# filename: client.rb
require "socket"
require "optparse"

host = 'localhost'
comm = 'add'
opt  = ''
PORT = 16383

# 2-1. 制御コードの追加
parms = ARGV.getopts('alc:h:u:d:')

comm = 'add'      if parms["a"]
comm = 'list'     if parms["l"]
comm = parms["c"] if parms["c"]
host = parms["h"] if parms["h"]

# 2-2. 今回の追加コマンド
comm = 'update'   if parms["u"]
opt  = parms["u"] if parms["u"]
comm = 'delete'   if parms["d"]
opt  = parms["d"] if parms["d"]

s = TCPSocket.open(host, PORT)

# 2-3. オプション制御の追加
s.puts(comm + " " + opt + "\n")
print s.read

s.close
