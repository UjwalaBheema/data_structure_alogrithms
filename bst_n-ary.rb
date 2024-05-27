
# N-ary-tree-level-order-traversal
# Input
# [1,null,3,2,4,null,5,6]
#o/p
# [[1],[3,2,4],[5,6]]
# https://leetcode.com/problems/n-ary-tree-level-order-traversal/
# Time complexity 0(N)
def level_order(root)
    return [] if root.nil?

    q = [root]
    result = []

    until q.empty? do
        len = q.length
        temp = []
        q.size.times do
            node = q.shift
            temp << node.val
            node_children = node.children
            
            node_children.size.times do |child_index|
                q << node.children[child_index]
            end

        end
        result << temp
    end
    result
end

# https://leetcode.com/problems/binary-tree-level-order-traversal-ii/description/
# I/P: [3,9,20,null,null,15,7]
# Expected
# [[15,7],[9,20],[3]]
# BST Level order
# Just reverse of the level_order traverse 
# Iterate from n to 1 
# Time complexity 0(N)
def level_order_bottom(root)
    return [] if root.nil?

    result = []
    q = [root]
    
    until q.empty? do
        temp = []
        q.size.times do
            node = q.shift
            temp << node.val
            q << node.left if node.left
            q << node.right if node.right
        end
        result << temp
    end

    result.reverse
end

# https://leetcode.com/problems/binary-tree-zigzag-level-order-traversal/description/
# Input: root = [3,9,20,null,null,15,7]
# Output: [[3],[20,9],[15,7]]
# Example 2:

# Input: root = [1]
# Output: [[1]]
# Example 3:

# Input: root = []
# Output: []

def zigzag_level_order(root)
    return [] if root.nil?

    result = []
    q = [root]
    level = 0

    until q.empty? do
        temp = []
        
        q.size.times do |i|
            node = q.shift
            temp << node.val
            q << node.left if node.left 
            q << node.right if node.right
        end
        
        temp = temp.reverse if level.odd?
        level += 1
        result << temp
    end

    result
end 

# https://leetcode.com/problems/binary-tree-right-side-view/
# Input: root = [1,2,3,null,5,null,4]
# Output: [1,3,4]
# Example 2:

# Input: root = [1,null,3]
# Output: [1,3]
# Example 3:

# Input: root = []
# Output: []

def right_side_view(root)
    return [] if root.nil?

    q = [root]
    result = []

    until q.empty? do
        temp = nil
        q.size.times do 
            node = q.shift
            temp = node.val
            q << node.left if node.left 
            q << node.right if node.right
        end

        result << temp
    end
    result
end

def all_paths_of_a_binary_tree(root)
    # Write your code here.
    result = []
    helper(root, [], result)
    return result
end

# https://uplevel.interviewkickstart.com/resource/submissions/rc-codingproblem-759899-1199406-1042-6382

def helper(node, sub_res, result)
    return [] if node.nil?
    
    if !node.left && !node.right
        sub_res << node.value
        result  << sub_res.dup
        sub_res.pop
        return
    end
    
    sub_res << node.value
    
    helper(node.left, sub_res, result) if node.left
    helper(node.right, sub_res, result) if node.right
    sub_res.pop
end
