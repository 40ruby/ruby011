#!/usr/bin/env ruby
# coding: utf-8
# filename: server.rb
require "socket"
require "json"

class File_JSON
  def read(msg)
    json = []
    JSON.load(msg).each do |list|
      json.push([list['date'],list['avg'],list['max'],list['min']])
    end
    return json
  end
end

# 変数初期化
PORT   = 16383

#
server = TCPServer.open(PORT)

while true
  Thread.start(server.accept) do |client|

    @message = client.read

    @json = File_JSON.new
    p @json.read(@message)

    client.puts "OK"
    client.close
  end
end

server.close
