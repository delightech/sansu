# 二桁の繰り上がりの計算（小１〜小２用）の練習問題作成スクリプト
arr = []
idx = 0
while true
  a = rand(10);
  b = rand(10);
  c = rand(10);
  d = rand(10);
  if ((a + b) >= 10) && ((c + d) >= 10)
    shiki = "#{a}#{c} + #{b}#{d}"
    puts "#{idx}. #{shiki}"
    arr.push({ shiki: shiki, ans: Integer("#{a}#{c}") + Integer("#{b}#{d}") })
    idx += 1
    break if idx == 100
  end
end

arr.each_with_index {|o,i| puts "#{i+1}. #{o[:ans]}"}
