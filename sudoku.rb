# {
# "board": [
# [8, 4, 9, 0, 0, 3, 5, 7, 0],
# [0, 1, 0, 0, 0, 0, 0, 0, 0],
# [7, 0, 0, 0, 9, 0, 0, 8, 3],
# [0, 0, 0, 9, 4, 6, 7, 0, 0],
# [0, 8, 0, 0, 5, 0, 0, 4, 0],
# [0, 0, 6, 8, 7, 2, 0, 0, 0],
# [5, 7, 0, 0, 1, 0, 0, 0, 4],
# [0, 0, 0, 0, 0, 0, 0, 1, 0],
# [0, 2, 1, 7, 0, 0, 8, 6, 5]
# ]
# }

def solve_sudoku_puzzle(board)
    solve(board)
    return board
  end
  
  def solve(board)
    row, col = find_empty_location(board)
    return true if row.nil? # If no empty location found, the puzzle is solved
    (1..9).each do |num|
      if is_safe?(board, row, col, num)
        board[row][col] = num
        if solve(board)
          return true
        end
        board[row][col] = 0 # Backtrack
      end
    end
    return false # If no number can be placed, backtrack
  end
  
def find_empty_location(board)
  board.each_with_index do |row, i|
    row.each_with_index do |val, j|
      return [i, j] if val == 0
    end
  end
  return nil
end
  
def is_safe?(board, row, col, num)
  return !used_in_row?(board, row, num) &&
          !used_in_col?(board, col, num) &&
          !used_in_box?(board, row - row % 3, col - col % 3, num)
end
  
def used_in_row?(board, row, num)
  return board[row].include?(num)
end

def used_in_col?(board, col, num)
  return board.transpose[col].include?(num)
end

def used_in_box?(board, start_row, start_col, num)
  (0..2).each do |i|
    (0..2).each do |j|
      return true if board[start_row + i][start_col + j] == num
    end
  end
  return false
end
  