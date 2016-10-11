require './manage_address.rb'

describe 'ManageAddress クラス' do
  before do
    @localhost = '127.0.0.1'
    @addrs     = ['127.0.0.1','192.168.0.100','172.16.10.1']
    @filename = 'test_db.csv'
    @logfile  = '/tmp/log'
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

  describe '#CheckIP メソッド' do
    describe '一つの文字列を引数として' do
      context '文字列を受け付けた場合は' do
        it '正常に処理が終了する' do
          expect(@hosts.CheckIP('192.168.0.10')).to eq(true)
        end
      end
      context '文字列以外を受け付けた場合' do
        it '引数が数値の場合は異常' do
          expect(@hosts.CheckIP(100)).to eq(false)
        end
        it '引数が配列の場合は異常' do
          expect(@hosts.CheckIP([100,100])).to eq(false)
        end
      end
    end

    describe '"."区切りで4桁で構成' do
      context '全て"."区切りで4桁の場合' do
        it '正常終了する' do
          expect(@hosts.CheckIP('1.0.0.1')).to eq(true)
        end
      end
      context 'フォーマット通りでない場合' do
        it '区切りが"."以外の場合は異常' do
          expect(@hosts.CheckIP('1:0:0:1')).to eq(false)
          expect(@hosts.CheckIP('1/0/0/1')).to eq(false)
        end
      end
    end

    describe 'IPアドレスは1.0.0.1〜239.255.255.254のレンジ' do
      context '指定された範囲内であれば' do
        it '正常終了' do
          expect(@hosts.CheckIP('239.255.255.254')).to eq(true)
        end
      end
      context '指定された範囲外' do
        it '一桁、四桁目が 0 は異常' do
          expect(@hosts.CheckIP('0.0.0.1')).to eq(false)
          expect(@hosts.CheckIP('1.0.0.0')).to eq(false)
          expect(@hosts.CheckIP('0.0.0.0')).to eq(false)
        end
        it '一桁目が240以上は異常' do
          expect(@hosts.CheckIP('240.0.0.1')).to eq(false)
          expect(@hosts.CheckIP('240.255.255.254')).to eq(false)
        end
        it '二、三桁目が256以上は異常' do
          expect(@hosts.CheckIP('0.256.0.1')).to eq(false)
          expect(@hosts.CheckIP('0.0.256.1')).to eq(false)
        end
        it '四桁目が255以上は異常' do
          expect(@hosts.CheckIP('239.255.255.255')).to eq(false)
        end
        it 'いずれかの桁が0より小さければ異常' do
          expect(@hosts.CheckIP('-1.0.0.0')).to eq(false)
          expect(@hosts.CheckIP('0.-1.0.0')).to eq(false)
          expect(@hosts.CheckIP('0.0.-1.0')).to eq(false)
          expect(@hosts.CheckIP('0.0.0.-1')).to eq(false)
        end
      end
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
