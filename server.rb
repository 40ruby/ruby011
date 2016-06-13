#!/usr/bin/env ruby
# coding: utf-8
# filename: server.rb
require "socket"

# 変数・定数初期化
PORT    = 16383
CTIME   = 5
clients = []

# 3-1. サーバポートオープン
server = TCPServer.new(PORT)

loop do
# 3-2. スレッドおよび受信開始
  Thread.start(server.accept) do |client|

# 3-3. クライアントからの情報を受信
    addr = client.peeraddr[3]
    comm = client.gets.chop

# 3-4. コマンド毎の処理
    case comm

# 3-5. クライアントの追加
    when "add" then
      unless clients.include?(addr) then
        clients << addr
        print Time.now, " : added ", addr, "\n"
        client.puts "OK"
      else
        print Time.now, " : already added \n"
        client.puts "ERROR"
      end

# 3-6. 登録済みアドレスリストの表示
    when "list" then
      print Time.now, " : print hosts \n"
      client.puts "OK"
      clients.each do |host|
        client.puts host
      end
    else
      print Time.now, " : Command not Found \n"
      client.puts "Command not Found"
    end

    client.close

# 3-7. 試しに待たせてみる
    sleep CTIME
  end
end
