require 'set'

class Node
  attr_accessor :children, :is_end

  def initialize
    @children = {}
    @is_end = false
  end
end

class Trie
  def initialize
    @root = Node.new
    @memo = {}
  end

  def insert(word)
    current = @root
    word.each_char do |char|
      current.children[char] ||= Node.new
      current = current.children[char]
    end
    current.is_end = true
  end

  def can_construct?(word, is_original)
    return false if word.empty?
    return @memo[word] if @memo.key?(word)
    current = @root
    word.each_char.with_index do |char, i|
      return false unless current.children.key?(char)
      current = current.children[char]
      if current.is_end
        suffix = word[i + 1..-1]
        if !suffix.empty? && (suffix_in_dict?(suffix) || can_construct?(suffix, false))
          @memo[word] = true
          return true
        end
      end
    end
    @memo[word] = current.is_end && !is_original
  end

  private

  def suffix_in_dict?(suffix)
    current = @root
    suffix.each_char do |char|
      return false unless current.children.key?(char)
      current = current.children[char]
    end
    current.is_end
  end
end

def find_longest_words(filename)
  list_of_words = File.readlines(filename).map(&:chomp)
  trie = Trie.new
  list_of_words.each { |word| trie.insert(word) }
  list_of_words.sort_by!(&:length).reverse!
  longest_word = ""
  second_longest_word = ""
  concatenated_words = []

  list_of_words.each do |word|
    next if word.empty?
    if trie.can_construct?(word, true)
      concatenated_words << word
      if longest_word.empty?
        longest_word = word
      elsif second_longest_word.empty? || word.length > second_longest_word.length
        second_longest_word = word
      end
    end
  end

  [longest_word, second_longest_word, concatenated_words.size]
end

filename = '/Users/ujwalabheema/Downloads/wordsforproblem.txt'
longest_word, second_longest_word, concatenated_count = find_longest_words(filename)

puts "Number of words that can be constructed of other words: #{concatenated_count}"
puts "Longest word made of other words: #{longest_word}"
puts "Second longest word made of other words: #{second_longest_word}"


filename = '/Users/ujwalabheema/Downloads/catdog.txt'
longest_word, second_longest_word, concatenated_count = find_longest_words(filename)

puts "Number of words that can be constructed of other words: #{concatenated_count}"
puts "Longest word made of other words: #{longest_word}"
puts "Second longest word made of other words: #{second_longest_word}"
