# filename: manage_address.rb
require 'logger'
require './lib/ip_address.rb'

class ManageAddress
  # 登録済みアドレスリスト
  attr_reader :addrs
  include IPAddress

  # データベースの読込・初期化
  # ファイルが存在していれば内容を読込、なければファイルを新規に作成
  # == パラメータ
  # filename:: 読込・または保管先のファイル名
  # == 返り値
  # 特になし。但し、@addrs インスタンス変数へ、データベースの内容を保持
  def initialize(filename, logfile = "/tmp/log")
    @filename = filename
    @log = Logger.new(logfile)
    begin
      mode = File.exist?(filename) ? "r" : "w+"
      fp   = File.open(filename, mode)
    rescue => e
      @log.fatail(e.message)
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
      @log.fatal(e.message)
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
  # false:: 既に同じアドレスまたはIPアドレスではないため、登録せず
  def create(addr)
    if CheckIP(addr) then
      unless @addrs.include?(addr) then
        @addrs << addr
        @log.info("#{addr} を追加しました.")
        return true
      else
        @log.error("#{addr} は既に登録されています.")
        return false
      end
    else
      @log.error("#{addr} は登録可能なIPアドレスではありません.")
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
  # ただし、変更後のアドレスが既に登録されている場合や、登録済みアドレスが見つからない場合はエラーを返す
  # == パラメータ
  # before:: 既に登録済みのアドレス
  # after::  変更後のアドレス
  def update(before, after)
    if @addrs.include?(after) || !CheckIP(after) then
      @log.error("#{after} は既に登録済みか、有効なIPアドレスではありません.")
      return false
    elsif i = @addrs.index(before) then
      @log.info("#{before} から #{after} へ変更しました.")
      @addrs[i] = after
      return true
    else
      @log.error("変更元の #{before} が見つかりません.")
      return false
    end
  end

  # 登録済みのアドレスを削除する
  # == パラメータ
  # addr: 削除対象のアドレス
  # == 返り値
  # string:: 削除された要素
  # nil::    削除すべき要素が見つからなかったとき
  def delete(addr)
    if @addrs.delete(addr) == addr then
      @log.info("#{addr} を削除しました.")
      return addr
    else
      @log.warn("#{addr} が見つかりません.")
      return nil
    end
  end

  # まだアドレスが登録されていないかどうか
  # == 返り値
  # true::  アドレス未登録
  # false:: 1つ以上のアドレスが登録済み
  def empty?
    return @addrs.empty?
  end
end
