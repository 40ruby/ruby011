# encoding: utf-8
require 'spec_helper'
require 'socket'
require './operate_client'

describe 'OperateClient' do
  let(:client) { OperateClient.new }
  describe '#connect' do
    subject { client.connect }
    it '接続できることを確認する' do
      server = TCPServer.new(24368)
      is_expected.to eq(true)
      server.close
    end
  end
end
