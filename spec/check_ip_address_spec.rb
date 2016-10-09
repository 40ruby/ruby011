require_relative '../check_ip_address'

describe 'CheckIPAddress' do
  describe '一つの文字列を引数として' do
    context '文字列を受け付けた場合は' do
      it '正常に処理が終了する' do
        expect(CheckIPAddress('192.168.0.10')).to eq(true)
      end
    end
    context '文字列以外を受け付けた場合' do
      it '引数が数値の場合は異常' do
        expect(CheckIPAddress(100)).to eq(false)
      end
      it '引数が配列の場合は異常' do
        expect(CheckIPAddress([100,100])).to eq(false)
      end
    end
  end

  describe '"."区切りで4桁で構成' do
    context '全て"."区切りで4桁の場合' do
      it '正常終了する' do
        expect(CheckIPAddress('1.0.0.1')).to eq(true)
      end
    end
    context 'フォーマット通りでない場合' do
      it '区切りが"."以外の場合は異常' do
        expect(CheckIPAddress('1:0:0:1')).to eq(false)
        expect(CheckIPAddress('1/0/0/1')).to eq(false)
      end
    end
  end

  describe 'IPアドレスは1.0.0.1〜239.255.255.254のレンジ' do
    context '指定された範囲内であれば' do
      it '正常終了' do
        expect(CheckIPAddress('239.255.255.254')).to eq(true)
      end
    end
    context '指定された範囲外' do
      it '一桁、四桁目が 0 は異常' do
        expect(CheckIPAddress('0.0.0.1')).to eq(false)
        expect(CheckIPAddress('1.0.0.0')).to eq(false)
        expect(CheckIPAddress('0.0.0.0')).to eq(false)
      end
      it '一桁目が240以上は異常' do
        expect(CheckIPAddress('240.0.0.1')).to eq(false)
        expect(CheckIPAddress('240.255.255.254')).to eq(false)
      end
      it '二、三桁目が256以上は異常' do
        expect(CheckIPAddress('0.256.0.1')).to eq(false)
        expect(CheckIPAddress('0.0.256.1')).to eq(false)
      end
      it '四桁目が255以上は異常' do
        expect(CheckIPAddress('239.255.255.255')).to eq(false)
      end
      it 'いずれかの桁が0より小さければ異常' do
        expect(CheckIPAddress('-1.0.0.0')).to eq(false)
        expect(CheckIPAddress('0.-1.0.0')).to eq(false)
        expect(CheckIPAddress('0.0.-1.0')).to eq(false)
        expect(CheckIPAddress('0.0.0.-1')).to eq(false)
      end
    end
  end
end
