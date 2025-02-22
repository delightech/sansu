# frozen_string_literal: true

# 二桁の繰り上がり・繰り下がりの計算（小１〜小２用）の練習問題作成スクリプト
# 繰り上がり、繰り下がりがない簡単な問題を混ぜ込んでいる

require 'optparse'

class ArithmeticProblemGenerator
  EASY_RATIO = 0.2
  HARD_RATIO = 0.8

  def initialize(total_count, shuffle: false)
    @total_count = total_count
    @shuffle = shuffle
    @problems = []
  end

  def generate
    addition_count = @total_count / 2
    subtraction_count = @total_count - addition_count
    
    generate_addition_problems(addition_count)
    generate_subtraction_problems(subtraction_count)
    
    @problems.shuffle! if @shuffle
    @problems
  end

  private

  def generate_addition_problems(count)
    hard_count = (count * HARD_RATIO).ceil
    easy_count = count - hard_count

    while @problems.count { |p| p[:shiki].include?('+') && is_carry_problem?(p) } < hard_count
      problem = generate_carry_addition
      @problems << problem if problem
    end

    while @problems.count { |p| p[:shiki].include?('+') && !is_carry_problem?(p) } < easy_count
      problem = generate_simple_addition
      @problems << problem if problem
    end
  end

  def generate_subtraction_problems(count)
    hard_count = (count * HARD_RATIO).ceil
    easy_count = count - hard_count

    while @problems.count { |p| p[:shiki].include?('-') && is_borrow_problem?(p) } < hard_count
      problem = generate_borrow_subtraction
      @problems << problem if problem
    end

    while @problems.count { |p| p[:shiki].include?('-') && !is_borrow_problem?(p) } < easy_count
      problem = generate_simple_subtraction
      @problems << problem if problem
    end
  end

  def is_carry_problem?(problem)
    return false unless problem[:shiki].include?('+')
    nums = problem[:shiki].split('+').map(&:strip).map(&:to_i)
    ones = nums.map { |n| n % 10 }
    ones[0] + ones[1] >= 10
  end

  def is_borrow_problem?(problem)
    return false unless problem[:shiki].include?('-')
    nums = problem[:shiki].split('-').map(&:strip).map(&:to_i)
    ones = nums.map { |n| n % 10 }
    ones[0] < ones[1]
  end

  def generate_carry_addition
    a, b, c, d = generate_random_digits
    return unless ((a + b) >= 10) && ((c + d) >= 10)

    create_problem("#{a}#{c} + #{b}#{d}")
  end

  def generate_simple_addition
    a, b, c, d = generate_random_digits
    return unless ((a + b) < 10) && ((c + d) < 10)

    create_problem("#{a}#{c} + #{b}#{d}")
  end

  def generate_borrow_subtraction
    a, b, c, d = generate_random_digits
    return unless (a > b) && (c < d)

    create_problem("#{a}#{c} - #{b}#{d}")
  end

  def generate_simple_subtraction
    a, b, c, d = generate_random_digits
    return unless (a > b) && (c > d)

    create_problem("#{a}#{c} - #{b}#{d}")
  end

  def generate_random_digits
    [rand(1..9), rand(1..9), rand(0..9), rand(0..9)]
  end

  def create_problem(expression)
    { shiki: expression, ans: eval(expression) }
  end
end

# コマンドラインオプションの処理
params = {}
opt = OptionParser.new
opt.on('-q', 'questions(optional)') { |v| params[:questions] = v }
opt.on('-a', 'answers(optional)') { |v| params[:answers] = v }
opt.on('-s', 'shuffle(optional)') { |v| params[:shuffle] = v }
opt.on('-n VALUE', 'number(optional)') { |v| params[:number] = v }
opt.parse!(ARGV)

# 問題数の設定（デフォルト10問）
num = params[:number].to_i if params.key?(:number) && params[:number] != ''
num ||= 10

# 問題の生成
generator = ArithmeticProblemGenerator.new(num, shuffle: params.key?(:shuffle))
problems = generator.generate

# 結果の出力
if (!params.key?(:questions) && !params.key?(:answers)) || params.key?(:questions)
  puts '問題'
  problems.each_with_index { |p, i| puts "#{i + 1}.   #{p[:shiki]}" }
end

if (!params.key?(:questions) && !params.key?(:answers)) || params.key?(:answers)
  puts '答え'
  problems.each_with_index { |p, i| puts "#{i + 1}. #{p[:ans]}" }
end
