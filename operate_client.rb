# encoding: utf-8
# filename: operate_client.rb

class OperateClient
  def initialize(hostname = '127.0.0.1', port = 24368)
    @s = TCPSocket.open(hostname, port)
  end

  def connect
    true
  end
end
