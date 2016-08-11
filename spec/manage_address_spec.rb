require './manage_address.rb'

describe 'ManageAddress クラス' do
  before do
    @localhost = '127.0.0.1'
    @addrs     = ['127.0.0.1','192.168.0.100','172.16.10.1']
    @filename = 'test_db.csv'
    @hosts = ManageAddress.new(@filename)
  end
  describe '#initialize メソッド' do
    it 'ファイルが作成されている' do
      expect(File.exist?(@filename)).to eq(true)
    end
    it '内容は空' do
      expect(@hosts.empty?).to eq(true)
    end
  end

  describe '#create メソッド' do
    it '新規に1つの場合は成功' do
      expect(@hosts.create('127.0.0.1')).to eq(true)
    end
    it '同じアドレスを二度追加すると失敗' do
      @hosts.create(@localhost)
      expect(@hosts.create(@localhost)).to eq(false)
    end
  end

  describe '#read メソッド' do
    it '未登録時は空' do
      expect(@hosts.read).to eq([])
      expect(@hosts.addrs).to eq([])
    end
    it 'localhost を1つ登録した場合は 127.0.0.1を1つだけ返す' do
      @hosts.create(@localhost)
      expect(@hosts.read).to eq([@localhost])
      expect(@hosts.addrs).to eq([@localhost])
    end
    it '複数のアドレスを登録した場合は、それらを返す' do
      @addrs.each { |host| @hosts.create(host) }
      expect(@hosts.read).to eq(@addrs)
      expect(@hosts.addrs).to eq(@addrs)
    end
  end

  describe '#update メソッド' do
    before do
      @hosts.create(@localhost)
    end
    it 'localhostを"192.168.0.1"へ更新する' do
      expect(@hosts.update(@localhost, '192.168.0.1')).to eq(true)
      expect(@hosts.read).to eq(['192.168.0.1'])
    end
    it '更新元のアドレスがない場合は失敗' do
      expect(@hosts.update('192.168.0.1','172.16.0.1')).to eq(false)
      expect(@hosts.read).to eq([@localhost])
    end
    it '更新後のアドレスが既にある場合は失敗' do
      expect(@hosts.update('192.168.0.1',@localhost)).to eq(false)
    end
  end

  describe '#delete メソッド' do
    before do
      @hosts.create(@localhost)
    end
    it '既に登録済みのアドレスを削除すると、そのアドレスが返る' do
      expect(@hosts.delete(@localhost)).to eq(@localhost)
    end
    it '未登録のアドレスを削除した場合はnil' do
      expect(@hosts.delete('192.168.0.1')).to eq(nil)
    end
  end
end
