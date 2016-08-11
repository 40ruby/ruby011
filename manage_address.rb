# filename: manage_address.rb

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
      mode = File.exist?(filename) ? "r" : "w"
      fp   = File.open(filename, mode)
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
  # ただし、変更後のアドレスが既に登録されている場合や、登録済みアドレスが見つからない場合はエラーを返す
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
