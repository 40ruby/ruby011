#!/usr/bin/env ruby
# coding: utf-8
# filename: server.rb
require "socket"

# 変数初期化
HOST = 'localhost' # localhost 宛先の場合
PORT = 16383

# 2-1. サーバへ接続
s = TCPSocket.open(HOST, PORT)

s.print("Hello\n")
print s.gets

s.close
