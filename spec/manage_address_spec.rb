# coding: utf-8
require 'spec_helper'
require './manage_address.rb'

describe 'ManageAddress' do
  let(:filename)  { 'test_db.csv' }
  let(:hosts)     { ManageAddress.new(filename) }
  let(:localhost) { '127.0.0.1' }
  let(:addrs)     { [localhost,'192.168.0.100','172.16.10.1'] }
  let(:correct)   { ['192.168.0.10','1.0.0.1','239.255.255.254'] }
  let(:incorrect) { ['100','[100,100]','1:0:0:1','1/0/0/1','0.0.0.1','1.0.0.0','0.0.0.0','240.0.0.1','240.255.255.254','0.256.0.1','0.0.256.1','239.255.255.255','-1.0.0.0','0.-1.0.0','0.0.-1.0','0.0.0.-1'] }

  describe '#initialize' do
    it 'ファイルが作成されている' do
      expect(File.exist?(filename)).to eq(true)
    end
    it '内容は空' do
      expect(hosts.empty?).to eq(true)
    end
  end

  describe '#create' do
    context '新規作成の場合' do
      subject { hosts.create(localhost) }
      it '新規に1つの場合は成功' do
        is_expected.to eq(true)
      end
      it '同じアドレスを二度追加すると失敗' do
        hosts.create(localhost)
        is_expected.to eq(false)
      end
    end
    context '追加されたアドレスの検証' do
      subject { hosts.read }
      it '有効なIPアドレスの登録は成功' do
        correct.each { |addr| hosts.create(addr) }
        is_expected.to match_array(correct)
      end
      it '有効範囲外のIPアドレスの登録は失敗' do
        incorrect.each { |addr| hosts.create(addr) }
        is_expected.to match_array([])
      end
    end
  end

  describe '#read' do
    subject { hosts.read }
    it '未登録時は空' do
      is_expected.to eq([])
    end
    it 'localhost を1つ登録した場合は 127.0.0.1を1つだけ返す' do
      hosts.create(localhost)
      is_expected.to eq([localhost])
    end
    it '複数のアドレスを登録した場合は、それらを返す' do
      addrs.each { |host| hosts.create(host) }
      is_expected.to match_array(addrs)
    end
  end

  describe '#update' do
    before { hosts.create(localhost) }
    it '有効なIPアドレスへ変更すると成功' do
      before_addr = localhost
      correct.each do |addr|
        expect { hosts.update(before_addr, addr) }.to change { hosts.read }.from([before_addr]).to([addr])
        before_addr  = addr
      end
    end
    it '有効範囲外のIPアドレスへ変更すると失敗' do
      incorrect.each do |addr|
        expect(hosts.update(localhost, addr)).to eq(false)
      end
    end
    it '更新元のアドレスがない場合は失敗' do
      expect(hosts.update('192.168.0.1','172.16.0.1')).to eq(false)
    end
    it '更新後のアドレスが既にある場合は失敗' do
      expect(hosts.update('192.168.0.1',localhost)).to eq(false)
    end
  end

  describe '#delete' do
    subject { hosts.delete(localhost) }
    it '既に登録済みのアドレスを削除すると、そのアドレスが返る' do
      hosts.create(localhost)
      is_expected.to eq(localhost)
    end
    it '未登録のアドレスを削除した場合はnil' do
      is_expected.to eq(nil)
    end
  end
end
