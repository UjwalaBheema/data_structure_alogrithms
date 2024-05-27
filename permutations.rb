# [1, 2, 2]

def get_permutations(arr)
    # Write your code here.
    result = []

    helper(arr, result, 0)
    return result
end

def helper(arr, result, index)
    return result if arr.length == index
    
    result << result.rotate
    
    helper(arr, result, index+1)
end

words = ['cat',
'cats',
'catsdogcats',
'catxdogcatsrat',
'dog',
'dogcatsdog',
'hippopotamuses',
'rat',
'ratcatdogcat']


def longest_word_made_of_other_words(words)
  # words = File.readlines(file_name).map(&:chomp)
  word_set = Set.new(words)
  longest_word = ""
  second_longest_word = ""
  max_length = 0
  count = 0

  words.each do |word|
    count += 1 if can_construct_other_words?(word, word_set)
    if word.length > max_length
      second_longest_word = longest_word
      max_length = word.length
      longest_word = word
    elsif word.length > second_longest_word.length
      second_longest_word = word
    end
  end

  puts "Longest word made of other words: #{longest_word}"
  puts "Second longest word: #{second_longest_word}"
  puts "Number of words that can be constructed of other words: #{count}"
end

def can_construct_other_words?(word, word_set)
  (1...word.length).each do |i|
    prefix = word[0...i]
    suffix = word[i..-1]
    return true if word_set.include?(prefix) && (word_set.include?(suffix) || can_construct_other_words?(suffix, word_set))
  end
  false
end



def longest_word(words)
  words_set = Set.new(words)
  longest = ""

  words.each do |word|
    next if word.length < longest.length || (word.length == longest.length && word > longest)
    (1...word.length).each do |i|
      prefix = word[0...i]
      longest = word if words_set.include?(prefix) && i == word.length - 1
      # break unless words_set.include?(prefix)
    end
  end

  longest
end



### working1
def longest_constructible_word(file_name)
  words = File.readlines(file_name, chomp: true).map(&:downcase).uniq.sort
  words = words
  longest_words = []

  words.each do |word|
    if can_be_constructed(word, words - [word])
      if longest_words.empty? || word.length > longest_words.first.length
        longest_words = [word]
      elsif word.length == longest_words.first.length
        longest_words << word
      end
    end
  end

  longest_words.max_by(&:length)
end

def can_be_constructed(word, words)
  return true if word.empty?
  words.any? do |other_word|
    if word.start_with?(other_word) && can_be_constructed(word[other_word.length..-1], words)
      return true
    end
  end
  false
end

words = ['cat',
'cats',
'catsdogcats',
'catxdogcatsrat',
'dog',
'dogcatsdog',
'hippopotamuses',
'rat',
'ratcatdogcat',
'catratdogdogcats']

puts longest_constructible_word(words)  # Replace with your file name




### working ?
