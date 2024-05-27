# Approach-1 usual way to looping words
# Timeout or stack level too deep (SystemStackError) for wordproblem
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

# Approach2 - reference https://linux.thai.net/~thep/datrie/
# Trie data structure
class Node
  attr_accessor :children, :is_end
  
  # Initialize a new node
  # Create a hash to store the node's children, where each key is a character and each value is a child node
  # Initialize a flag to indicate whether this node represents the end of a word
  def initialize
    @children = {}
    @is_end = false
  end
end


class Trie
  attr_accessor :root

  def initialize
    # Initialize a new trie(root node)
    @root = Node.new
  end

  # Params: word (String)
  # Description: Inserts a word into the Trie by traversing the nodes and setting the is_end flag for the last node
  # Returns none
  def insert(word)
    # Start at the root node
    current = @root
    
    word.each_char do |char|
      # If the current node doesn't have a child with the current character, create a new child node
      current.children[char] ||= Node.new
      # Move to the child node
      current = current.children[char]
    end
    # Set the is_end flag for the last node
    current.is_end = true
  end

  # Params: words (Array<String>)
  # Returns: Array<String>, Array<String>, Array<String>, Array<String>, Array<String>>
  # Description: Finds the longest and second longest concatenated words in the Trie. 
  # It sorts the input list of words by length and then iterates through the list.
  # For each word, it checks if the word can be constructed from other words in the Trie. 
  # If yes, it adds the word to a list of concatenated words and updates the longest and second longest words if necessary.

  def find_longest_concatenated_words(words)
    # If the input words array is empty, return an empty array
    return [] if words.empty?
  
    # If the input words array contains only one word, return an array containing that word as the longest and second longest concatenated words, and an empty array for the contributing words
    return [words[0], "", [words[0]], [], []] if words.length == 1
  
    # Sort the words in descending order of length and then alphabetically
    words.sort_by! { |word| [-word.length, word] }
    # Initialize variables to store the longest and second longest concatenated words
    longest_word = ""
    second_longest_word = ""
    concatenated_words = []
    words_contributing_to_longest = []
    sec_words_contributing_to_longest = []
  
    words.each do |word|
      # Skip empty words
      next if word.empty?
  
      # Check if the word can be constructed from other words in the list
      if can_construct?(word, 0, true)
        # Add the word to the list of concatenated words
        concatenated_words << word
        # If this is the first concatenated word or it's longer than the current longest word
        # Update the longest word and its contributing words
        # If this word is longer than the current second longest word or the second longest word is empty
        # Update the second longest word and its contributing words
        if longest_word.empty?
          longest_word = word
          words_contributing_to_longest = find_contributing_words(word)
        elsif second_longest_word.empty? || word.length > second_longest_word.length
          second_longest_word = word
          sec_words_contributing_to_longest = find_contributing_words(word)
        end
      end
    end
  
    # If there are no concatenated words, return an empty array
    return [] if concatenated_words.empty?
  
    # If there is only one concatenated word, return an array containing that word as the longest and second longest concatenated words, and an empty array for the contributing words
    return [longest_word, "", [longest_word], words_contributing_to_longest, []] if concatenated_words.length == 1
  
    # If there are multiple longest or second longest concatenated words, return an array containing all the longest and second longest concatenated words, and the contributing words for those words
    longest_words = concatenated_words.select { |word| word.length == longest_word.length }
    second_longest_words = concatenated_words.select { |word| word.length == second_longest_word.length }
    longest_words_contributing_words = longest_words.map { |word| find_contributing_words(word) }
    second_longest_words_contributing_words = second_longest_words.map { |word| find_contributing_words(word) }
    
    [longest_words, second_longest_words, concatenated_words, longest_words_contributing_words, second_longest_words_contributing_words]
  end

  private

  # Params: word (String), index=0 (Integer), is_original=true(Boolean)
  # Description: Checks if a word can be constructed from other words in the Trie. 
  # It recursively traverses the Trie and returns true if the word can be constructed.
  # Returns: Boolean
  def can_construct?(word, index, is_original)
    # Base case: if reached the end of the word, return true if it's the original word or if it's a valid word in the trie
    return true if index == word.length

    # Start at the root of the trie
    current = @root
    (index...word.length).each do |i|
      # If the current character is not in the trie, return false
      return false unless current.children.key?(word[i])

      # Move to the next node in the trie
      current = current.children[word[i]]
      # If reached the end of a word in the trie and there are more characters left in the original word
      if current.is_end && (i < word.length - 1)
        # Recursively search for a way to construct the rest of the word
        return true if can_construct?(word, i + 1, false)
      end
    end

    # If reached the end of the word and it's a valid word in the trie, return true if it's not the original word
    current.is_end && !is_original
  end

  # Params: word (String), index=0 (Integer), path=[](Array)
  # Description: Finds all contributing words for a given word in the Trie. Returns an array of contributing words
  # Returns: Array<String>
  def find_contributing_words(word, index=0, path=[])
    # Base case: if reached the end of the word, return the current path
    return path if index == word.length

    current = @root
    (index...word.length).each do |i|
      # If the current character is not in the trie, return an empty array
      return [] unless current.children.key?(word[i])

      # Move to the next node in the trie
      current = current.children[word[i]]
      # If reached the end of a word in the trie and there are more characters left in the original word
      if current.is_end && (i < word.length - 1)
        # Recursively search for contributing words in the remaining part of the original word
        result = find_contributing_words(word[i + 1..-1], 0, path + [word[0..i]])
        # if found a contributing word, return it
        return result unless result.empty?
      end
    end
    # If reached the end of the word and it's a valid word in the trie, add it to the path
    current.is_end ? path + [word] : []
  end
end

# Params: filename/path <String>
# Description: reads the input file, inserts all the words into the Trie
# Returns: Array<String>, Array<String>, Array<String>, Array<String>, Array<String>>
def report_longest_concatenated_words(filename)
  if filename.nil? || filename.empty?
     puts "File name cannot be empty"
     return
  end

  begin
    trie = Trie.new
    File.foreach(filename) do |line|
      word = line.chomp
      trie.insert(word)
    end

    words = File.readlines(filename).map(&:chomp)

    longest_word, second_longest_word, concatenated_words, words_contributing_to_longest, sec_words_contributing_to_longest = trie.find_longest_concatenated_words(words)
    [longest_word, second_longest_word, concatenated_words, words_contributing_to_longest, sec_words_contributing_to_longest]
  rescue Errno::ENOENT => e
    # Handle file not found error
    puts "Error: File not found - #{e.message}"
    []
    # Can handle multiple error types
  rescue => e
    # errors
    puts "Error: #{e.message}"
    []
  end
end

puts "\n \n \n ********** -------- catdog ---------- **********\n\n"
filename = '/Users/ujwalabheema/Downloads/catdog.txt'
longest_words, second_longest_words, concatenated_words, words_contributing_to_longest, sec_words_contributing_to_longest = report_longest_concatenated_words(filename)
puts "Longest word in the catdog"
puts "Number of words that can be constructed of other words: #{concatenated_words.size}"
puts "Longest word made of other words: #{longest_words}"


puts "Longest word in the wordsforproblem"
puts "Number of words that can be constructed of other words: #{concatenated_words.size}"
puts "Longest word made of other words: #{longest_words}"
puts "Words in the list can be constructed of other words to the longest word: #{words_contributing_to_longest}"
longest_words.each_with_index do |word, index|
  puts "\n \n Longest word #{index+1}.#{word}"
  puts "Total count of words that can be constructed from longest word: #{sec_words_contributing_to_longest[index].size}"
  puts "Words in the list can be constructed of other words to the longest word: #{words_contributing_to_longest[index]}"
  
end

puts "\n Second Longest word in the wordsforproblem"
puts "Second longest word made of other words: #{second_longest_words} "
second_longest_words.each_with_index do |word, index|
  puts "\nSecond Longest word #{index+1}.#{word}"
  puts "Total count of words that can be constructed from second longest word: #{sec_words_contributing_to_longest[index].size}"
  puts "Words in the list can be constructed of other words to the second longest word: #{sec_words_contributing_to_longest[index]}"
  
end
puts " \n ********** -------- catdog end ---------- **********"

puts "\n \n ********** -------- wordsforproblem ---------- **********\n\n"
filename = '/Users/ujwalabheema/Downloads/wordsforproblem.txt'
longest_words, second_longest_words, concatenated_words, words_contributing_to_longest, sec_words_contributing_to_longest = report_longest_concatenated_words(filename)

puts "Longest word in the wordsforproblem"
puts "Number of words that can be constructed of other words: #{concatenated_words.size}"
puts "Longest word made of other words: #{longest_words}"
longest_words.each_with_index do |word, index|
  puts "\n \n Longest word #{index+1}.#{word}"
  puts "Total count of words that can be constructed from longest word: #{sec_words_contributing_to_longest[index].size}"
  puts "Words in the list can be constructed of other words to the longest word: #{words_contributing_to_longest[index]}"
  
end

puts "\n Second Longest word in the wordsforproblem"
puts "Second longest word made of other words: #{second_longest_words} "
second_longest_words.each_with_index do |word, index|
  puts "\nSecond Longest word #{index+1}.#{word}"
  puts "Total count of words that can be constructed from second longest word: #{sec_words_contributing_to_longest[index].size}"
  puts "Words in the list can be constructed of other words to the second longest word: #{sec_words_contributing_to_longest[index]}"
end

puts " \n ********** -------- wordsforproblem end ---------- **********"

# Output
# ********** -------- catdog ---------- **********

# Longest word in the catdog
# Number of words that can be constructed of other words: 3
# Longest word made of other words: ["ratcatdogcat"]
# Longest word in the wordsforproblem
# Number of words that can be constructed of other words: 3
# Longest word made of other words: ["ratcatdogcat"]
# Words in the list can be constructed of other words to the longest word: [["rat", "cat", "dog", "cat"]]

 
#  Longest word 1.ratcatdogcat
# Total count of words that can be constructed from longest word: 3
# Words in the list can be constructed of other words to the longest word: ["rat", "cat", "dog", "cat"]

#  Second Longest word in the wordsforproblem
# Second longest word made of other words: ["catsdogcats"] 

# Second Longest word 1.catsdogcats
# Total count of words that can be constructed from second longest word: 3
# Words in the list can be constructed of other words to the second longest word: ["cats", "dog", "cats"]
 
#  ********** -------- catdog end ---------- **********

 
#  ********** -------- wordsforproblem ---------- **********

# Longest word in the wordsforproblem
# Number of words that can be constructed of other words: 97107
# Longest word made of other words: ["ethylenediaminetetraacetates"]

 
#  Longest word 1.ethylenediaminetetraacetates
# Total count of words that can be constructed from longest word: 7
# Words in the list can be constructed of other words to the longest word: ["ethylene", "diamine", "tetra", "ace", "tat", "es"]

#  Second Longest word in the wordsforproblem
# Second longest word made of other words: ["electroencephalographically", "ethylenediaminetetraacetate"] 

# Second Longest word 1.electroencephalographically
# Total count of words that can be constructed from second longest word: 7
# Words in the list can be constructed of other words to the second longest word: ["electro", "en", "cep", "ha", "lo", "graphic", "ally"]

# Second Longest word 2.ethylenediaminetetraacetate
# Total count of words that can be constructed from second longest word: 5
# Words in the list can be constructed of other words to the second longest word: ["ethylene", "diamine", "tetra", "ace", "tate"]
 
#  ********** -------- wordsforproblem end ---------- **********



#  When catdog i/p changed:
# cat
# cats
# catsdogcats
# catxdogcatsrat
# dog
# dogcatsdograt
# dogcatsdogcat
# hippopotamuses
# rat
# ratcatdograt 
# ratcatdogcat

# O/p
# ********** -------- catdog ---------- **********

# Longest word in the catdog
# Number of words that can be constructed of other words: 4
# Longest word made of other words: ["dogcatsdogcat", "dogcatsdograt"]
# Longest word in the wordsforproblem
# Number of words that can be constructed of other words: 4
# Longest word made of other words: ["dogcatsdogcat", "dogcatsdograt"]
# Words in the list can be constructed of other words to the longest word: [["dog", "cats", "dog", "cat"], ["dog", "cats", "dog", "rat"]]

 
#  Longest word 1.dogcatsdogcat
# Total count of words that can be constructed from longest word: 4
# Words in the list can be constructed of other words to the longest word: ["dog", "cats", "dog", "cat"]

 
#  Longest word 2.dogcatsdograt
# Total count of words that can be constructed from longest word: 4
# Words in the list can be constructed of other words to the longest word: ["dog", "cats", "dog", "rat"]

#  Second Longest word in the wordsforproblem
# Second longest word made of other words: ["dogcatsdogcat", "dogcatsdograt"] 

# second Longest word 1.dogcatsdogcat
# Total count of words that can be constructed from second longest word: 4
# words in the list can be constructed of other words to the second longest word: ["dog", "cats", "dog", "cat"]

# second Longest word 2.dogcatsdograt
# Total count of words that can be constructed from second longest word: 4
# words in the list can be constructed of other words to the second longest word: ["dog", "cats", "dog", "rat"]
