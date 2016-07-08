#!/usr/bin/env ruby
# coding: utf-8
# filename: server.rb
require "socket"

# 変数・定数初期化
PORT    = 16383
clients = []

class ManageClients
  attr_reader :addrs

  def initialize(filename)
    @filename = filename
    begin
      if File.exist?(filename)
        fp = File.open(filename)
      else
        fp = File.open(filename, "w+")
      end
    rescue => e
      abort "#{e.class} => #{e.message}"
    end

    @addrs = fp.each_line.map { |addr|
      addr.chomp
    }
    fp.close
  end

  def store(filename = @filename)
    begin
      fp = File.open(filename, "w")
    rescue => e
      abort "#{e.class} => #{e.message}"
    end

    @addrs.each do |addr|
      fp.puts(addr)
    end
    fp.close
  end

  def create(addr)
    unless @addrs.include?(addr) then
      @addrs << addr
      return true
    else
      return false
    end
  end

  def read
    return @addrs
  end

  def update(before, after)
    if i = @addrs.index(before) then
      @addrs[i] = after
    else
      @addrs << before
      @addrs << after
    end
  end

  def delete(addr)
    return @addrs.delete(addr)
  end
end

a = ManageClients.new("40ruby.txt")
p a.create("test06")
a.update("test02","test05")
a.delete("test05")

p a.read
p a.addrs

a.store


=begin
# 3-1. サーバポートオープン
server = TCPServer.new(PORT)

loop do
# 3-2. スレッドおよび受信開始
Thread.start(server.accept) do |client|

# 3-3. クライアントからの情報を受信
addr = client.peeraddr[3]
comm = client.gets.chomp

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
end
end

=end
