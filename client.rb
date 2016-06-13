#!/usr/bin/env ruby
# coding: utf-8
# filename: server.rb
require "socket"
require "optparse"

# 変数初期化
host = 'localhost'
comm = 'add'
PORT = 16383

# 4-1. 引数解析
parms = ARGV.getopts('alc:h:')

# 4-2. 入力内容から割り当て
comm = 'add'      if parms["a"]
comm = 'list'     if parms["l"]
comm = parms["c"] if parms["c"]
host = parms["h"] if parms["h"]

# 4-3. サーバへ送信&受信
s = TCPSocket.open(host, PORT)

s.puts(comm + "\n")
print s.read

s.close
