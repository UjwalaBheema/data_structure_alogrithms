def quick_sort(arr)
  return arr if arr.length <= 1

  pivot = arr.sample
  less_than_pivot = arr.select { |x| x < pivot }
  equal_to_pivot = arr.select { |x| x == pivot }
  greater_than_pivot = arr.select { |x| x > pivot }

  quick_sort(less_than_pivot) + equal_to_pivot + quick_sort(greater_than_pivot)
end

# Example usage:
arr = [5, 3, 210, 232, 121, 45]
sorted_arr = quick_sort(arr)
puts sorted_arr


def merge_sort(arr)
  return arr if arr.length <= 1

  mid = arr.length / 2
  left_half = arr[0...mid]
  right_half = arr[mid..]

  merge(merge_sort(left_half), merge_sort(right_half))
end

def merge(left, right)
  sorted = []

  until left.empty? || right.empty?
    if left.first % 2 <= right.first % 2
      sorted << left.shift
    else
      sorted << right.shift
    end
  end

  sorted.concat(left).concat(right)
end

# Example usage:
arr = [5, 3, 210, 232, 121, 45]
sorted_arr = merge_sort(arr)
puts sorted_arr
