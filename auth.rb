# coding: utf-8
# filename: auth.rb
require "digest/md5"

class Auth
  # サーバの認証キーを定義する
  # == パラメータ
  # auth_code:: MD5 でハッシュ化されたキーを指定する
  # == 返り値
  # 特になし。@key_list 配列を初期化
  def initialize(auth_code = 'bd6dbd063f5ab7394879e3c08781cd72')
    @auth_code = auth_code
    # @key_list  = {}
  end

  # クライアント認証を行う
  # 接続元が要求してきたキーが、サーバ側で設定されているハッシュ値と比較する
  # == パラメータ
  # key:: ハッシュ化される前のキー
  # ip:: 接続元のIPアドレス
  # == 返り値
  # 認証:: ハッシュ化されたクライアント固有の識別キー
  # 否認:: false
  def authenticate(key, ip)
    auth_key   = Digest::MD5.hexdigest(key)
    return false unless @auth_code == auth_key

    client_key = Digest::MD5.hexdigest(auth_key+ip)
    # @key_list[client_key] = ip
    # return client_key
  end

  # クライアントの識別を行う
  # 要求されたクライアント固有の識別キーが登録されているものか判断する
  # == パラメータ
  # key:: クライアント固有の識別キー
  # == 返り値
  # 識別された場合:: 登録されているIPアドレス
  # 否認された場合:: false
#  def varid(key)
#    @key_list[key] if @key_list.has_key?(key)
#  end
end
