
https://leetcode.com/discuss/study-guide/1212004/Binary-Trees-study-guide



- Binary trees have many applications in computer science, including data storage and retrieval, expression evaluation, network routing, and game AI.
- Priority Queue is another application of binary tree that is used for searching maximum or minimum in O(1) time complexity.

- Binary Tree Traversals:
- Tree Traversal algorithms can be classified broadly into two categories:
1. Depth-First Search (DFS) Algorithms
2. Breadth-First Search (BFS) Algorithms

Tree Traversal using Depth-First Search (DFS) algorithm can be further classified into three categories:- 

1. Preorder Traversal (current-left-right): Visit the current node before visiting any nodes inside the left or right subtrees. Here, the traversal is root – left child – right child. It means that the root node is traversed first then its left child and finally the right child.

2. Inorder Traversal (left-current-right): Visit the current node after visiting all nodes inside the left subtree but before visiting any node within the right subtree. Here, the traversal is left child – root – right child.  It means that the left child is traversed first then its root node and finally the right child.

3. Postorder Traversal (left-right-current): Visit the current node after visiting all the nodes of the left and right subtrees.  Here, the traversal is left child – right child – root.  It means that the left child has traversed first then the right child and finally its root node.

- Tree Traversal using Breadth-First Search (BFS) algorithm can be further classified into one category:-

1. Level Order Traversal:  Visit nodes level-by-level and left-to-right fashion at the same level. Here, the traversal is level-wise. It means that the most left child has traversed first and then the other children of the same level from left to right have traversed. 


Binary tree-
- The maximum number of nodes at level ‘l’ of a binary tree is  2^l:
- The Maximum number of nodes in a binary tree of height ‘h’ is 2^h – 1



Complete Binary tree- 
- it should have 2^h-1 nodes
- In a complete binary tree number of nodes at de
- In a  complete binary tree with n nodes height of the tree is log(n+1). All the levels except the last level are completely full.pth d is 2d. 
- all nodes should be stored from left to right
- It can be represented using an array. If the parent is it index i so the left child is at 2i+1 and the right child is at 2i+2.

Application of the Complete binary tree:
- Heap Sort
- Heap sort-based data structure


Perfect Binary tree- 
- it should have 2^(h+1)-1 nodes
- all nodes should be stored from left to right
- nodes in all level should have 0 or 2 child

Full Binary tree
- every node has either 2 children or 0 children.

- AVL trees are height balancing binary search tree. It is named after Adelson-Velsky and Landis, the inventors of the AVL tree. AVL tree checks the height of the left and the right sub-trees and assures that the difference is not more than 1. This difference is called the Balance Factor. This allows us to search for an element in the AVL tree in O(log n), where n is the number of elements in the tree.

- A binary tree is symmetric if the root node’s left subtree is a mirror reflection of the right subtree

- Tree problems will always can be solved by using recursive and divide the problem to subproblem
 - Inorder of binary search is sorted

- Do ignorer traversal to get the minimum difference of any two node.

- any tree problem is solved using traversal, recursion or else using LCA - Lowest common ancestor 

- if we want to solve any problem the think traversal, recursive method first. Do logic change with that 

- If anything we need to start with left node first the do the inorder traversal
- If anything we need to start with parent node first the do the preorder traversal
- If anything we need to start with right node first the do the postOder traversal
- if with level then level order traversal.
- problem need to solved with solving as subtree

Cartesian tree is a min-heap, the smallest element of the sequence must be the root of the Cartesian tree.

- cartesian tree is min or max heap