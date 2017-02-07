# encoding: utf-8
# filename: operate_client.rb

class OperateClient
  # クライアントとの接続
  # == パラメータ
  # hostname:: 接続先クライアントのホスト名、またはIPアドレス
  # port:: 接続先クライアントのTCPポート番号。通常は 24368
  # == 返り値
  # 接続された通信用のソケットオブジェクト
  def initialize(hostname = '127.0.0.1', port = 24368)
    begin
      @s = TCPSocket.open(hostname, port)
    rescue => e
      notify(e)
    end
  end

  # クライアントとの死活確認
  # == パラメータ
  # 特になし
  # == 返り値
  # true:: 生存確認
  # false:: クライアントが停止、またはネットワーク上に問題あり
  def connect
    begin
      true
    rescue => e
      notify(e)
    end
  end

  def notify(error)
    raise(StandardError, 'Not Connect')
  end

  def disconnect
    @s.close
  end
end
