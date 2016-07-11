#!/usr/bin/env ruby
# coding: utf-8
# filename: server.rb
require "socket"

# 待受ポート
PORT    = 16383

# 保管先ファイル名
db_file = "40ruby.txt"

class ManageAddress
  # 登録済みアドレスリスト
  attr_reader :addrs

  # データベースの読込・初期化
  # ファイルが存在していれば内容を読込、なければファイルを新規に作成
  # == パラメータ
  # filename:: 読込・または保管先のファイル名
  # == 返り値
  # 特になし。但し、@addrs インスタンス変数へ、データベースの内容を保持
  def initialize(filename)
    @filename = filename
    begin
      if File.exist?(filename)
        fp = File.open(filename)
      else
        fp = File.open(filename, "w+")
      end
    rescue => e
      abort "#{e.class} => #{e.message}"
    end

    @addrs = fp.each_line.map { |addr|
      addr.chomp
    }
    fp.close
  end

  # メモリ上のアドレスリストを、ファイルへ保管する
  # == パラメータ
  # filename:: 保管先ファイル名。指定がない場合は、初期化時に採用したファイル名
  def store(filename = @filename)
    begin
      fp = File.open(filename, "w")
    rescue => e
      abort "#{e.class} => #{e.message}"
    end

    @addrs.each do |addr|
      fp.puts(addr)
    end
    fp.close
  end

  # アドレスを新規に登録する。既に登録済みのものであれば登録しない。
  # == パラメータ
  # addr:: 登録する IPアドレス
  # == 返り値
  # true::  登録できた
  # false:: 既に同じアドレスあり、登録せず
  def create(addr)
    unless @addrs.include?(addr) then
      @addrs << addr
      return true
    else
      return false
    end
  end

  # 登録済みアドレスリストを、配列で返す
  # == 返り値
  # array: 登録済みのアドレスリスト
  def read
    return @addrs
  end

  # 登録済みのアドレスを、他のアドレスへ変更する
  # もし、変更前のものが登録されていなければ、変更前のものも登録する
  # ただし、変更後のアドレスが既に登録されている場合はエラーを返す
  # == パラメータ
  # before:: 既に登録済みのアドレス
  # after::  変更後のアドレス
  def update(before, after)
    if @addrs.include?(after) then
      return false
    elsif i = @addrs.index(before) then
      @addrs[i] = after
      return true
    else
      @addrs << before
      @addrs << after
      return true
    end
  end

  # 登録済みのアドレスを削除する
  # == パラメータ
  # addr: 削除対象のアドレス
  # == 返り値
  # string:: 削除された要素
  # nil::    削除すべき要素が見つからなかったとき
  def delete(addr)
    return @addrs.delete(addr)
  end

  # まだアドレスが登録されていないかどうか
  # == 返り値
  # true::  アドレス未登録
  # false:: 1つ以上のアドレスが登録済み
  def empty?
    return @addrs.empty?
  end
end

hosts  = ManageAddress.new(db_file)
server = TCPServer.new(PORT)

# メインルーチン
loop do
  begin
    Thread.start(server.accept) do |client|

      addr = client.peeraddr[3]
      comm = client.gets.chomp

# 1-1. コマンドごとにメソッドを実行
      case comm
      when /^(add|create).*/ then
        status = hosts.create(addr) ? "OK" : "NG"
        print Time.now, ": add ", status, "\n"
        client.puts status

      when /^list/ then
        status = hosts.empty? ? "NG" : "OK"
        print Time.now, ": list ", status, "\n"
        client.puts status
        hosts.read.each do |host|
          client.puts host
        end

# 1-2. 'update' と 'remove'コマンドを追加
      when /^update.*/ then
        command, options = comm.split
        before, update   = options.split(',')
        status = hosts.update(before, update)
        print Time.now, ": update ", status, "\n"
        client.puts status

      when /^delete.*/ then
        command, options = comm.split
        p command, options
        target = options ? options : addr
        status = hosts.delete(target)
        print Time.now, ": delete ", status, "\n"
        client.puts status

      else
        print Time.now, ": Command not Found \n"
        client.puts "NG"
      end

      client.close
    end

  # 1-3. ctrl+c が押された場合に、終了処理を入れる
  rescue Interrupt => e
    print Time.now, ": server halt...\n"
    hosts.store
    server.close
    exit
  end
end
