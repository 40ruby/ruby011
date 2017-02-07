# coding: utf-8
require 'spec_helper'
require 'socket'
require './operate_client'

describe 'OperateClient' do
  before { @server = TCPServer.new(24368) }
  after  { @server.close }
  let(:client) { OperateClient.new }
  describe '#connect' do
    context '正常接続' do
      subject { client.connect }
      it 'successfully connect to client' do
        allow(client).to receive(:connect).and_return(true)
        is_expected.to eq(true)
      end
    end
    context '接続不可' do
      it { expect{ OperateClient.new('127.0.0.1', 65000) }.to raise_error 'Not Connect' }
      it 'クライアントが停止していたら' do
        allow(client).to receive(:connect).and_return(false)
        expect(client.connect).to eq(false)
      end
    end
  end

end
