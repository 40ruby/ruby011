#!/usr/bin/env ruby
# coding: utf-8
# filename: server.rb
require "socket"

# 初期化
PORT    = 16383         # 待受ポート番号
db_file = "40ruby.txt"  # 保管先ファイル名

require "./manage_address.rb"

hosts  = ManageAddress.new(db_file)
server = TCPServer.new(PORT)

# メインルーチン
loop do
  begin
    Thread.start(server.accept) do |client|

      addr = client.peeraddr[3]
      comm = client.gets.chomp

# 1-1. コマンドごとにメソッドを実行
      case comm
      when /^(add|create).*/ then
        status = hosts.create(addr) ? "OK" : "NG"
        print Time.now, ": add ", status, "\n"
        client.puts status

      when /^list/ then
        status = hosts.empty? ? "NG" : "OK"
        print Time.now, ": list ", status, "\n"
        client.puts status
        hosts.read.each do |host|
          client.puts host
        end

# 1-2. 'update' と 'remove'コマンドを追加
      when /^update.*/ then
        command, options = comm.split
        before, update   = options.split(',')
        status = hosts.update(before, update)
        print Time.now, ": update ", status, "\n"
        client.puts status

      when /^delete.*/ then
        command, options = comm.split
        p command, options
        target = options ? options : addr
        status = hosts.delete(target)
        print Time.now, ": delete ", status, "\n"
        client.puts status

      else
        print Time.now, ": Command not Found \n"
        client.puts "NG"
      end

      client.close
    end

  # 1-3. ctrl+c が押された場合に、終了処理を入れる
  rescue Interrupt => e
    print Time.now, ": server halt...\n"
    hosts.store
    server.close
    exit
  end
end
