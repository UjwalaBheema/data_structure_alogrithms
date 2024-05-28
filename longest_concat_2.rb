class TrieNode
    attr_accessor :children, :is_end
  
    def initialize
      @children = {}
      @is_end = false
    end
  end

  class Trie
    attr_accessor :root
  
    def initialize
      @root = TrieNode.new
    end
  
    def insert(word)
      current = @root
      word.each_char do |char|
        current.children[char] ||= TrieNode.new
        current = current.children[char]
      end
      current.is_end = true
    end
  
    def can_construct?(word, index = 0, is_original = true)
      return true if index == word.length
      current = @root
      (index...word.length).each do |i|
        return false unless current.children.key?(word[i])
        current = current.children[word[i]]
        return true if current.is_end && can_construct?(word, i + 1, false)
      end
      current.is_end && !is_original
    end
  
    def find_longest_concatenated_words(words)
      words.sort_by! { |word| [-word.length, word] }
      longest_word = ""
      second_longest_word = ""
      constructible_words = 0
  
      words.each do |word|
        next if word.empty?
        if can_construct?(word, 0, true)
          constructible_words += 1
          if longest_word.empty?
            longest_word = word
          elsif word.length > longest_word.length
            second_longest_word = longest_word
            longest_word = word
          elsif word.length > second_longest_word.length
            second_longest_word = word
          end
        end
      end
  
      [longest_word, second_longest_word, constructible_words]
    end
  end
  
  def report_longest_concatenated_words(filename)
    trie = Trie.new
    File.foreach(filename) do |line|
      word = line.chomp
      trie.insert(word)
    end
    words = File.readlines(filename).map(&:chomp)
    longest_word, second_longest_word, constructible_words = trie.find_longest_concatenated_words(words)
  
    puts "Longest word made of other words: #{longest_word}"
    puts "Second longest word made of other words: #{second_longest_word}"
    puts "Number of words that can be constructed of other words: #{constructible_words}"
  end
  
  filename = 'catdog.txt'
  report_longest_concatenated_words(filename)