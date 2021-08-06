# 割り切れる割り算
#

require 'optparse'

# commnad line option
params = {}
opt = OptionParser.new
opt.on('-a', 'answers(optional)') { |v| params[:answers] = v }
opt.on('-n VALUE', 'number(optional)') { |v| params[:number] = v }
opt.parse!(ARGV)

# 問題数の指定
num = params[:number].to_i if params.key?(:number) && params[:number] != ''
num = 90 if num > 90

# デフォルト出題数10問
num ||= 10

qa = {}
while qa.size < num
  a = rand(10)
  b = rand(10)

  b = 1 if b == 0
  qa["#{a * b} ÷ #{b}"] = a
end


idx = 1
qa.each do |q,a|
  if params[:answers]
    puts"#{idx}.  #{q} = #{a}"
  else
    puts"#{idx}.  #{q}"
  end
  idx += 1
end
