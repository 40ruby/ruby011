#!/usr/bin/env ruby
# coding: utf-8
# filename: dbserver.rb
require "socket"

# 変数初期化
PORT = 16383

# サーバポートオープン
dtserver = TCPServer.new(PORT)

loop do
  s = dtserver.accept
  print(s, " is accepted\n")
  buf = s.read
  print("received message:", buf)
  s.write(Time.now)
  print(s, " is gone\n")
  s.close
end
