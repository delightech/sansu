# frozen_string_literal: true

require_relative '../2digit_kuriagesage_adv'

RSpec.describe ArithmeticProblemGenerator do
  let(:generator) { ArithmeticProblemGenerator.new(10) }

  describe '#initialize' do
    it 'creates a new generator with specified count' do
      expect(generator).to be_a(ArithmeticProblemGenerator)
    end

    it 'accepts shuffle option' do
      generator_with_shuffle = ArithmeticProblemGenerator.new(10, shuffle: true)
      expect(generator_with_shuffle).to be_a(ArithmeticProblemGenerator)
    end
  end

  describe '#generate' do
    let(:problems) { generator.generate }

    it 'generates the specified number of problems' do
      expect(problems.length).to eq(10)
    end

    it 'generates valid problems' do
      problems.each do |problem|
        expect(problem).to have_key(:shiki)
        expect(problem).to have_key(:ans)
      end
    end

    it 'generates both addition and subtraction problems' do
      operations = problems.map { |p| p[:shiki].include?('+') ? :addition : :subtraction }
      expect(operations).to include(:addition)
      expect(operations).to include(:subtraction)
    end
  end

  describe 'problem generation' do
    let(:generator) { ArithmeticProblemGenerator.new(100) }
    let(:problems) { generator.generate }

    context 'addition problems' do
      let(:addition_problems) { problems.select { |p| p[:shiki].include?('+') } }

      it 'generates carry addition problems' do
        carry_problems = addition_problems.select do |p|
          nums = p[:shiki].split('+').map(&:strip).map(&:to_i)
          ones = nums.map { |n| n % 10 }
          ones[0] + ones[1] >= 10
        end
        expect(carry_problems).not_to be_empty
      end

      it 'generates simple addition problems' do
        simple_problems = addition_problems.select do |p|
          nums = p[:shiki].split('+').map(&:strip).map(&:to_i)
          ones = nums.map { |n| n % 10 }
          ones[0] + ones[1] < 10
        end
        expect(simple_problems).not_to be_empty
      end
    end

    context 'subtraction problems' do
      let(:subtraction_problems) { problems.select { |p| p[:shiki].include?('-') } }

      it 'generates borrow subtraction problems' do
        borrow_problems = subtraction_problems.select do |p|
          nums = p[:shiki].split('-').map(&:strip).map(&:to_i)
          ones = nums.map { |n| n % 10 }
          ones[0] < ones[1]
        end
        expect(borrow_problems).not_to be_empty
      end

      it 'generates simple subtraction problems' do
        simple_problems = subtraction_problems.select do |p|
          nums = p[:shiki].split('-').map(&:strip).map(&:to_i)
          ones = nums.map { |n| n % 10 }
          ones[0] > ones[1]
        end
        expect(simple_problems).not_to be_empty
      end
    end
  end

  describe 'problem correctness' do
    let(:problems) { generator.generate }

    it 'calculates correct answers for addition problems' do
      addition_problems = problems.select { |p| p[:shiki].include?('+') }
      addition_problems.each do |problem|
        expected = eval(problem[:shiki])
        expect(problem[:ans]).to eq(expected)
      end
    end

    it 'calculates correct answers for subtraction problems' do
      subtraction_problems = problems.select { |p| p[:shiki].include?('-') }
      subtraction_problems.each do |problem|
        expected = eval(problem[:shiki])
        expect(problem[:ans]).to eq(expected)
      end
    end
  end
end 