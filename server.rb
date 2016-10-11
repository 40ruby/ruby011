#!/usr/bin/env ruby
# coding: utf-8
# filename: server.rb
require "socket"
require "./manage_address.rb"

# 初期化
PORT    = 16383               # 待受ポート番号
db_file = "40ruby.txt"        # 保管先ファイル名
logfile = "./logs/server.log" # ログファイル名
hosts   = ManageAddress.new(db_file, logfile)

server  = TCPServer.new(PORT)

# メインルーチン
loop do
  begin
    Thread.start(server.accept) do |client|

      addr = client.peeraddr[3]
      comm = client.gets.chomp

      # 1-1. コマンドごとにメソッドを実行
      case comm
      when /^(add|create).*/ then
        client.puts hosts.create(addr) ? "OK" : "NG"

      when /^list/ then
        unless hosts.empty? then
          hosts.read.each do |host|
            client.puts host
          end
        end

        # 1-2. 'update' と 'remove'コマンドを追加
      when /^update.*/ then
        command, options = comm.split
        before, update   = options.split(',')
        client.puts hosts.update(before, update) ? "OK" : "NG"

      when /^delete.*/ then
        command, options = comm.split
        target = options ? options : addr
        client.puts hosts.delete(target) ? "OK" : "NG"
      end

      client.close
    end

    # 1-3. ctrl+c が押された場合に、終了処理を入れる
  rescue Interrupt => e
    p e
    hosts.store()
    server.close
    exit
  end
end
