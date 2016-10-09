# IPアドレスのチェック
# IPアドレスとおぼしき文字列を検査し、IPアドレスっぽいかどうかを調査
# == パラメータ
# ip:: チェックしたいIPアドレス文字列
# == 返り値
# true:: IPアドレスと思われる場合
# false:: IPアドレスではないと思われる場合

def CheckIPAddress(ip)
  # 引数は文字列のみを受け付けることとする
  return false unless ip.is_a?(String)

  # 正規表現で、各数値を入手
  /^([0-9]*)\.([0-9]*)\.([0-9]*)\.([0-9]*)$/ =~ ip

  return false unless (1..239).cover?($1.to_i)
  return false unless (0..255).cover?($2.to_i)
  return false unless (0..255).cover?($3.to_i)
  return false unless (1..254).cover?($4.to_i)

  return true
end
