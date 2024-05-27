
# Approach-1 usual way to looping words
# Timeout or stack level too deep (SystemStackError)
# def longest_constructible_words(file_name)
#     words = File.readlines(file_name, chomp: true).map(&:downcase).uniq.sort
#     constructible_words = []
#     longest_word = ""
#     second_longest_word = ""
#     memo = {}
  
#     words.each do |word|
#       if can_be_constructed(word, words - [word])
#         constructible_words << word
#         if word.length > longest_word.length
#             second_longest_word = longest_word
#             longest_word = word
#         elsif word.length == longest_word.length
#             # do nothing, we already have a word of this length
#         elsif word.length > second_longest_word.length && word.length < longest_word.length
#             second_longest_word = word
#         end
#       end
#     end
  
#     puts "longest_constructible_words: Longest word: #{longest_word}"
#     puts "longest_constructible_words: Second longest word: #{second_longest_word}"
#     puts "longest_constructible_words: Count of constructible words: #{constructible_words.size}"
#   end
  
#   def can_be_constructed(word, words, memo = {})
#     return true if word.empty?
#     return memo[word] if memo.key?(word)
  
#     words.any? do |other_word|
#       if word.start_with?(other_word) && can_be_constructed(word[other_word.length..-1], words, memo)
#         memo[word] = true
#         return true
#       end
#     end
  
#     memo[word] = false
#     false
#   end
  
#   # filename = '/Users/ujwalabheema/Downloads/catdog.txt'
#   filename = '/Users/ujwalabheema/Downloads/wordsforproblem.txt'
  
#   longest_constructible_words(filename)


#   def find_longest_words(list_of_words)
#     return if list_of_words.nil?
#     sorted_words = list_of_words.sort_by(&:length).reverse
#     dict = sorted_words.to_set
#     sorted_words.find { |word| is_made_of_words(word, dict) }
#   end
  
#   def is_made_of_words(word, dict)
#     return false if word.empty?
#     return dict.include?(word) if word.length == 1
#     (1...word.length).each do |i|
#       prefix, suffix = word[0, i], word[i, word.length - i]
#       return true if dict.include?(prefix) && (dict.include?(suffix) || is_made_of_words(suffix, dict))
#     end
#     false
#   end
  
require 'set'

# Function to find the longest and second longest concatenated words in a list
def find_longest_words(list_of_words)
  return if list_of_words.nil? || list_of_words.empty?

  # Sort the words by length in descending order
  sorted_words = list_of_words.sort_by(&:length).reverse
  dict = sorted_words.to_set
  longest_word = ""
  second_longest_word = ""
  concatenated_words = []

  sorted_words.each do |word|
    if is_made_of_words(word, dict, true)
      concatenated_words << word
      if longest_word.empty?
        longest_word = word
      elsif second_longest_word.empty? || word.length > second_longest_word.length
        second_longest_word = word
      end
    end
  end

  [longest_word, second_longest_word]
end

# Function to check if a word can be made up of other words in the dictionary
def is_made_of_words(word, dict, is_original)
  return false if word.empty?

  current_length = word.length

  # Memoization hash
  @memo ||= {}

  # Check if the word is already calculated
  return @memo[word] if @memo.key?(word)

  (1...current_length).each do |i|
    prefix, suffix = word[0, i], word[i, current_length - i]
    if dict.include?(prefix) && (dict.include?(suffix) || is_made_of_words(suffix, dict, false))
      @memo[word] = true
      return true
    end
  end

  @memo[word] = !is_original && dict.include?(word)
end
#   file_name = '/Users/ujwalabheema/Downloads/wordsforproblem.txt'
  file_name = '/Users/ujwalabheema/Downloads/catdog.txt'
  words = File.readlines(file_name, chomp: true).map(&:downcase).uniq.sort
  @memo ||= {}
#   list_of_words = %w(ala ma kota aa aabbb bbb cccc aabbbmacccc aabbbmaxxcccc)
  puts find_longest_words(words)
  puts @memo
#   list_of_words2 = %w(cat cats catsdogcats catxdogcatsrat dog dogcatsdog hippopotamuses rat ratcatdogcat)
#   puts find_longest_words(list_of_words2)