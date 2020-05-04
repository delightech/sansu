# 二桁の繰り上がりの計算（小１〜小２用）の練習問題作成スクリプト
require 'optparse'

# commnad line option
params = {}
opt = OptionParser.new
opt.on('-q', 'questions(optional)') { |v| params[:questions] = v }
opt.on('-a', 'answers(optional)') { |v| params[:answers] = v }
opt.parse!(ARGV)

arr = []
idx = 0
while true
  a = rand(10);
  b = rand(10);
  c = rand(10);
  d = rand(10);
  if ((a + b) >= 10) && ((c + d) >= 10)
    shiki = "#{a}#{c} + #{b}#{d}"
    arr.push({ shiki: shiki, ans: Integer("#{a}#{c}") + Integer("#{b}#{d}") })
    idx += 1
    break if idx == 100
  end
end

if (!params.key?(:questions) && !params.key?(:answers)) || params.key?(:questions)
  puts "問題"
  arr.each_with_index {|o,i| puts "#{i+1}. #{o[:shiki]}"}
end

puts

if (!params.key?(:questions) && !params.key?(:answers)) || params.key?(:answers)
  puts "答え"
  arr.each_with_index {|o,i| puts "#{i+1}. #{o[:ans]}"}
end
