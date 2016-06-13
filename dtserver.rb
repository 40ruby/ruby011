#!/usr/bin/env ruby
# coding: utf-8
# filename: dbserver.rb

# 1-1. "socket" ライブラリの読込
require "socket"

# 変数初期化
PORT  = 16383
CTIME = 5

# 1-2. サーバポートオープン
dtserver = TCPServer.new(PORT)

loop do
  print(Time.now, " : 受信開始\n")

# 1-3. 受信開始
  s = dtserver.accept
  print(Time.now, " : ", s, " メッセージを受信しました\n")

# 1-4. クライアントからのデータ受信と送信
  buf = s.gets
  print(Time.now, " : 受信したメッセージ:", buf)
  s.puts(Time.now.to_s + "\n")
  print(Time.now, " : ", s, " ソケットを閉じます\n")
  s.close

# 1-5. 複数同時接続を確認するための一時停止
  sleep CTIME
end
