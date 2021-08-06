# frozen_string_literal: true

# 二桁の繰り上がり・繰り下がりの計算（小１〜小２用）の練習問題作成スクリプト
# 繰り上がり、繰り下がりがない簡単な問題を混ぜ込んでいる

require 'optparse'

# commnad line option
params = {}
opt = OptionParser.new
opt.on('-q', 'questions(optional)') { |v| params[:questions] = v }
opt.on('-a', 'answers(optional)') { |v| params[:answers] = v }
opt.on('-s', 'shuffle(optional)') { |v| params[:shuffle] = v }
opt.on('-n VALUE', 'number(optional)') { |v| params[:number] = v }
opt.parse!(ARGV)

# 問題数の指定
num = params[:number].to_i if params.key?(:number) && params[:number] != ''

# デフォルト出題数10問
num ||= 10

arr = []
idx = 0
# 繰り上がりの計算式作成
loop do
  a = rand(1..9)
  b = rand(1..9)
  c = rand(0..9)
  d = rand(0..9)
  next unless ((a + b) >= 10) && ((c + d) >= 10)

  arr.push({ shiki: "#{a}#{c} + #{b}#{d}", ans: Integer("#{a}#{c}") + Integer("#{b}#{d}") })
  idx += 1
  break if idx == (num / 2) * 0.8
end

idx = 0
# 簡単な問題を少し入れる
loop do
  a = rand(1..9)
  b = rand(1..9)
  c = rand(0..9)
  d = rand(0..9)
  next unless ((a + b) < 10) && ((c + d) < 10)

  arr.push({ shiki: "#{a}#{c} + #{b}#{d}", ans: Integer("#{a}#{c}") + Integer("#{b}#{d}") })
  idx += 1
  break if idx == (num / 2) * 0.2
end

idx = 0
# 繰り下がりの計算式作成
loop do
  a = rand(1..9)
  b = rand(1..9)
  c = rand(0..9)
  d = rand(0..9)
  next unless (a > b) && (c < d)

  arr.push({ shiki: "#{a}#{c} - #{b}#{d}", ans: Integer("#{a}#{c}") - Integer("#{b}#{d}") })
  idx += 1
  break if idx == (num / 2) * 0.8
end

idx = 0
# 簡単な問題を少し入れる
loop do
  a = rand(1..9)
  b = rand(1..9)
  c = rand(0..9)
  d = rand(0..9)
  next unless (a > b) && (c > d)

  arr.push({ shiki: "#{a}#{c} - #{b}#{d}", ans: Integer("#{a}#{c}") - Integer("#{b}#{d}") })
  idx += 1
  break if idx == (num / 2) * 0.2
end

arr.shuffle! if params.key?(:shuffle)

if (!params.key?(:questions) && !params.key?(:answers)) || params.key?(:questions)
  puts '問題'
  arr.each_with_index { |o, i| puts "#{i + 1}.   #{o[:shiki]}" }
end

if (!params.key?(:questions) && !params.key?(:answers)) || params.key?(:answers)
  puts '答え'
  arr.each_with_index { |o, i| puts "#{i + 1}. #{o[:ans]}" }
end
