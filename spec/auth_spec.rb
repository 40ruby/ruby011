# coding: utf-8
# filename: auth_spec.rb
require_relative '../auth'

describe "Auth" do
  describe "#authenticate メソッド" do
    let(:normal) { Auth.new }
    let(:other)  { Auth.new('6996e0d11d644910e921ecc240f3cea8') }

    context "正常に認証された場合" do
      it '標準で登録されている認証コードでコール' do
        expect(normal.authenticate('DEMO', '192.168.0.10')).not_to eq(false)
      end
      it '変更された認証コードでコール' do
        expect(other.authenticate('40ruby', '192.168.0.10')).to eq('067745a1ca5c03b681e5935bb2f87ab7')
      end
    end

    context "異なる認証キーでコール" do
      it '標準で登録されている認証コード以外でコール' do
        expect(normal.authenticate('TEST', '192.168.0.10')).to eq(false)
      end
      it '変更された認証コードに対し、標準コードでコール' do
        expect(other.authenticate('DEMO', '192.168.0.10')).to eq(false)
      end

    end
  end
end
