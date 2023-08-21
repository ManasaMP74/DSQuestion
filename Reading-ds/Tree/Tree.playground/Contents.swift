import UIKit

class Tree<T: Equatable> {
    var d: T?
    var left: Tree<T>?
    var right: Tree<T>?
    var id: String
    
    static func ==(_ lhs: Tree<T>, rhs: Tree<T>) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(_ d: T?) {
        self.d = d
        self.id = UUID().uuidString
    }
}


func preOrder<T: Equatable>(_ tree: Tree<T>?) {
    guard tree != nil else { return }
    print(tree!.d!)
    preOrder(tree?.left)
    preOrder(tree?.right)
}

func inOrder<T: Equatable>(_ tree: Tree<T>?) {
    guard tree != nil else { return }
    inOrder(tree?.left)
    print(tree!.d!)
    inOrder(tree?.right)
}

func postOrder<T: Equatable>(_ tree: Tree<T>?) {
    guard tree != nil else { return }
    postOrder(tree?.left)
    postOrder(tree?.right)
    print(tree!.d!)
}


func levelOrder<T: Equatable>(_ tree: Tree<T>?) {
    // store every node into queue
    // here i'm cosidering array as my queue
    // first insert root node to queue
    // while queue is not empty take first node from the array and insert all it's child node to queue
    // again iterate this untill all nodes are visited
    //here i'm assuming tree is binary tree i.e it contains max of two child. If need we can create the tree with array of child
    guard let t = tree else { return }
    var queue: [Tree<T>?] = [t]
    var result: [[T?]] = []
    
    while !queue.isEmpty {
        let levelSize = queue.count
        var currentLevel: [T?] = []
        for _ in 0..<levelSize {
            let t = queue.removeFirst()
            if t == nil {
                currentLevel.append(nil)
            } else {
                currentLevel.append(t?.d)
                queue.append(t?.left)
                queue.append(t?.right)
            }
        }
        result.append(currentLevel)
    }
    print(result)
}

func checkTwoTreeIsIdentical<T: Equatable>(_ tree1: Tree<T>?, tree2: Tree<T>?) -> Bool {
    if tree1 == nil && tree2 == nil {
        return true
    }
    
    if tree1 != nil && tree2 != nil {
        return (tree1!.d! == tree2!.d!) && checkTwoTreeIsIdentical(tree1?.left, tree2: tree2?.left) && checkTwoTreeIsIdentical(tree1?.right, tree2: tree2?.right)
    }
    
    return false
}


func checkBinaryTreeIsMirror<T: Equatable>(_ tree1: Tree<T>?, tree2: Tree<T>?) -> Bool {
    if tree1 == nil && tree2 == nil {
        return true
    }
    
    if tree1 != nil && tree2 != nil {
        return (tree1!.d! == tree2!.d!) && checkBinaryTreeIsMirror(tree1?.left, tree2: tree2?.right) && checkBinaryTreeIsMirror(tree1?.right, tree2: tree2?.left)
    }
    return false
}

func checkBinaryTreeIsMirrorInSymmetric<T: Equatable>(_ tree1: Tree<T>?) {
    /*
     it can be done using level order traversal by keeping queue to check the symentric
     */
    if tree1 == nil {
        return print("not mirror")
    }
    
    var queue: [Tree<T>] = [tree1!]
    while !queue.isEmpty {
        let levelsize = queue.count
        var currentValue: [T] = []
        for i in 0..<levelsize {
            let node = queue.removeFirst()
            if levelsize == 1 {
                
            }else if i < levelsize/2 {
                currentValue.append(node.d!)
            }else {
                if currentValue.removeLast() != node.d! {
                    return print("not mirror")
                }
            }
            if node.left != nil { queue.append(node.left!) }
            if node.right != nil { queue.append(node.right!) }
        }
    }
    
   print("mirror")
}

func findDepthOfTree<T: Equatable>(_ tree1: Tree<T>?) {
    // to find depth keep the levelorder of tree.
    // for that keep queue to track
    // o(n) is time complexity and o(n) for space complexity
    if tree1 == nil {
        return print("Depth is 0")
    }
    
    var queue: [Tree<T>] = [tree1!]
    var depth = 0
    while !queue.isEmpty {
        let levelSize = queue.count
        for i in 0..<levelSize {
            let t = queue.removeFirst()
            if t.left != nil { queue.append(t.left!) }
            if t.right != nil { queue.append(t.right!) }
        }
        depth += 1
    }
    print("depth is", depth)
}

func findNumberOfNodes<T: Equatable>(_ tree1: Tree<T>?) -> Int {
    guard tree1 != nil else { return 0 }
    var count = 0
    if tree1!.left != nil { count +=  findNumberOfNodes(tree1!.left) }
    if tree1!.right != nil { count +=  findNumberOfNodes(tree1!.right) }
    return count+1
}

func findSumOfAllNodes(_ tree1: Tree<Int>?) -> Int {
    guard tree1 != nil else { return 0 }
    var sum = findSumOfAllNodes(tree1!.left)
    sum += findSumOfAllNodes(tree1!.right)
    return sum+tree1!.d!
}

func findHeightOrDepthOfTree<T: Equatable>(_ tree1: Tree<T>?) -> Int {
    guard tree1 != nil  else { return 0 }
    let leftHeight = findHeightOrDepthOfTree(tree1!.left)
    let rightHeight =  findHeightOrDepthOfTree(tree1!.right)
    return max(leftHeight, rightHeight)+1
}


class TreeInfo {
    var height = 0
    var daimeter = 0
    
    init(_ height: Int, _ daimeter: Int) {
        self.height = height
        self.daimeter = daimeter
    }
}

func findDiameterOfTree<T: Equatable>(_ tree1: Tree<T>?) -> TreeInfo {
    // check daimeter of left subtree and daimeter of right subtree and daimeter from root i.e height of left subtree+height of right subtree+1
    // take max of above three to find the largest daimeter of tree
    // if we calculate the height of subtree using above recursive method it take O(n2) so while iterating the daimeter save the height as well.
    
    guard tree1 != nil else { return TreeInfo(0, 0) }
    var leftTreeInfo: TreeInfo = findDiameterOfTree(tree1!.left)
    var rightTreeInfo: TreeInfo = findDiameterOfTree(tree1!.right)
    let daimeter1 = leftTreeInfo.daimeter
    let daimeter2 = rightTreeInfo.daimeter
    let daimeter3 = leftTreeInfo.height+rightTreeInfo.height+1
    
    let daimeter = max(daimeter1, daimeter2, daimeter3)
    let height = max(leftTreeInfo.height, rightTreeInfo.height)+1
    return TreeInfo(height, daimeter)
}


func checkChildrenSumInBinaryTree(_ tree1: Tree<Int>?) -> Bool {
    if tree1 == nil || (tree1!.left == nil && tree1!.right == nil) {
        return true
    }
    var sum = 0
    let t = checkChildrenSumInBinaryTree(tree1?.left) && checkChildrenSumInBinaryTree(tree1?.right)
    if tree1!.left != nil {
        sum += tree1!.left!.d!
    }
    if tree1!.right != nil {
        sum += tree1!.right!.d!
    }
    
    return (tree1!.d! == sum) && checkChildrenSumInBinaryTree(tree1?.left) && checkChildrenSumInBinaryTree(tree1?.right)
}

func checkTwoTreeOrIdentical<T: Equatable>(_ tree1: Tree<T>?, _ tree2: Tree<T>?) -> Bool {
    if tree1 == nil && tree2 == nil { return true }
    if tree1 == nil || tree2 == nil { return false }
    var queue1: [Tree<T>] = [tree1!]
    var queue2: [Tree<T>] = [tree2!]
    
    while !queue1.isEmpty && !queue2.isEmpty {
        let t = queue1.removeFirst()
        let t1 = queue2.removeFirst()
        if t.d! != t1.d! {
            return false
        }
        if t.left != nil { queue1.append(t.left!) }
        if t.right != nil  { queue1.append(t.right!) }
        if t1.left != nil  { queue2.append(t1.left!) }
        if t1.right != nil  { queue2.append(t1.right!) }
    }
       
    if !queue1.isEmpty || !queue2.isEmpty {
        return false
    }
            
    return true
}

func checkTreeIsHeightBalanced<T: Equatable>(_ tree1: Tree<T>?) -> Bool {
    if tree1 == nil { return true }
    
    let leftHeight = getHeightOfSubtree(tree1?.left)
    let rightHeight = getHeightOfSubtree(tree1?.right)
    
    if abs(leftHeight-rightHeight) <= 1 && checkTreeIsHeightBalanced(tree1?.left) && checkTreeIsHeightBalanced(tree1?.right) {
        return true
    }
    
    return false
    
    func getHeightOfSubtree(_ tree1: Tree<T>?) -> Int {
        if tree1 == nil { return 0 }
        var height = 0
        if tree1?.left != nil {
            height = max(height, getHeightOfSubtree(tree1?.left))
        }
        if tree1?.right != nil {
            height = max(height, getHeightOfSubtree(tree1?.right))
        }
        return height+1
    }
}

func checkForBinarySearchTree(_ tree1: Tree<Int>?) -> Bool {
    if tree1 == nil ||  (tree1?.left == nil && tree1?.right == nil) { return true }
    if tree1?.left == nil {
        return tree1!.right!.d! >= tree1!.d!
    }
    
    if tree1?.right == nil {
        return tree1!.left!.d! <= tree1!.d!
    }
    
    return tree1!.left!.d! <= tree1!.d! && tree1!.right!.d! >= tree1!.d! && checkForBinarySearchTree(tree1?.left) && checkForBinarySearchTree(tree1?.right)
}

class ConnectTree<T: Equatable> {
    var d: T?
    var left: ConnectTree<T>?
    var right: ConnectTree<T>?
    var next: ConnectTree<T>?
    
    init(_ d: T?) {
        self.d = d
    }
}

func connectNodesAtSameLevel<T: Equatable>(_ tree1: ConnectTree<T>?) {
    /*
     connect each node to next node in the same level. so use level traversal to link the node
     
     input :-
     
     
     let t = ConnectTree<Int>(5)
     t.left = ConnectTree<Int>(1)
     t.right = ConnectTree<Int>(4)
     
     output:-
     Optional(5) -> nil
     Optional(1) -> Optional(4)
     Optional(4) -> nil
     */
    if tree1 == nil { return }
    var queue: [ConnectTree<T>] = [tree1!]
    
    while !queue.isEmpty {
        var prev: ConnectTree<T>? = nil, levelsize = queue.count
        for _ in 0..<levelsize {
            let t = queue.removeFirst()
            if prev == nil {
                prev = t
            }else {
                prev?.next = t
                prev = t
            }
            if t.left != nil {
                queue.append(t.left!)
            }
            if t.right != nil {
                queue.append(t.right!)
            }
        }
    }
    
    //printing value
    queue = [tree1!]
    while !queue.isEmpty {
        let t = queue.removeFirst()
        print(t.d,"->", t.next?.d)
        if t.left != nil {
            queue.append(t.left!)
        }
        if t.right != nil {
            queue.append(t.right!)
        }
    }
}

func checkSubTree<T: Equatable>(_ tree1: Tree<T>?, _ subtree: Tree<T>?) -> Bool {
    /*
     let t = Tree<Int>(26)
     t.left = Tree<Int>(10)
     t.left?.left = Tree<Int>(4)
     t.left?.right = Tree<Int>(6)
     t.left?.left?.right = Tree<Int>(30)


     let t1 = Tree<Int>(10)
     t1.left = Tree<Int>(4)
     t1.right = Tree<Int>(6)
     t1.left?.right = Tree<Int>(30)

     print(checkSubTree(t, t1))
     */
    if subtree == nil { return true }
    if tree1 == nil { return false }
    
    if tree1!.d! == subtree!.d! {
        return isIdentical(tree1, subtree)
    }else {
        return checkSubTree(tree1?.left, subtree) || checkSubTree(tree1?.right, subtree)
    }
    
    func isIdentical<T: Equatable>(_ tree1: Tree<T>?, _ subtree: Tree<T>?) -> Bool {
        if tree1 == nil && subtree == nil { return true }
        if tree1 == nil || subtree == nil { return false }
        if tree1!.d! == subtree!.d! {
           return isIdentical(tree1?.left, subtree?.left) && isIdentical(tree1?.right, subtree?.right)
        }
        return false
    }
}



func countSingleValuedSubtree<T: Equatable>(_ tree1: Tree<T>?, count: inout Int) -> Bool {
    /*
     every subtree data should be same
     
     let t1 = Tree<Int>(5)
     t1.left = Tree<Int>(4)
     t1.right = Tree<Int>(5)
     t1.left?.right = Tree<Int>(4)
     t1.left?.left = Tree<Int>(4)
     t1.right?.right = Tree<Int>(5)
     
     output:- 5
     */
    if tree1 == nil  { return true }
    let t = countSingleValuedSubtree(tree1?.left, count: &count)
    let t2 = countSingleValuedSubtree(tree1?.right, count: &count)
    
    if t == false || t2 == false {
        return false
    }
    if tree1?.left != nil && (tree1!.left!.d! != tree1!.d!) {
       return false
    }
    
    if tree1?.right != nil && (tree1!.right!.d! != tree1!.d!) {
       return false
    }
    
    count += 1
    return true
}


func checkInorderSuccessorOrPredecessor(_ tree1: Tree<Int>?, _ k: Int) -> Tree<Int>? {
    /*
     BST always give the sorted list if we print it in inOrder
     
     - This can be solved by using store all the value in array using the inorder travesal and check the index of k then next index value is successor
     
     Time complxity with this is o(n) and space is o(n)
     */
    
    /*
     this will take O(h) h is height of tree and the space is O(1)
     */
    
    /*
     input let t1 = Tree<Int>(20)
     t1.left = Tree<Int>(8)
     t1.right = Tree<Int>(22)
     t1.left?.right = Tree<Int>(12)
     t1.left?.left = Tree<Int>(4)
     t1.left?.right?.left = Tree<Int>(10)
     t1.left?.right?.right = Tree<Int>(14)

     print(checkInorderSuccessorOrPredecessor(t1, 8)?.d)
     
     output: 10
     */
    if tree1 == nil { return nil }
    var successor: Tree<Int>? = nil
    
    /*
     through recurssive way
     */
    
//    if k  >= tree1!.d! {
//        // move to right bcz my next successor is always the greater than the current
//        successor = checkInorderSuccessorOrPredecessor(tree1?.right, k)
//    } else {
//        // move to left bcz my next successor is always the lesser than the current
//        successor = tree1
//        successor = checkInorderSuccessorOrPredecessor(tree1?.left, k) ?? successor
//    }

    /*
     through iterration
     */
    
    var root = tree1
    while root != nil {
        if k  >= root!.d! {
            root = root?.right
        }else {
            successor = root
            root = root?.left
        }
    }
    
    return successor
}

class TreeNext<T: Equatable> {
    var d: T?
    var left: TreeNext<T>?
    var right: TreeNext<T>?
    var next: TreeNext<T>?
    
    init(_ d: T) {
        self.d = d
    }
}

func checkInorderSuccessorOrPredecessorForEveryNode(_ tree1: TreeNext<Int>?, _ prev: inout TreeNext<Int>?) {
    /*
     
     let t1 = TreeNext<Int>(20)
     t1.left = TreeNext<Int>(8)
     t1.right = TreeNext<Int>(22)
     t1.left?.right = TreeNext<Int>(12)
     t1.left?.left = TreeNext<Int>(4)
     t1.left?.right?.left = TreeNext<Int>(10)
     t1.left?.right?.right = TreeNext<Int>(14)
     var prev: TreeNext<Int>? = nil
     checkInorderSuccessorOrPredecessorForEveryNode(t1, &prev)
     printOrder(t1)
     
     To print the data
     
     func printOrder(_ tree1: TreeNext<Int>?) {
         if tree1 == nil { return }
         printOrder(tree1?.left)
         print(tree1?.d, tree1?.next?.d)
         printOrder(tree1?.right)
     }
     
     output:- Optional(4) Optional(8)
     Optional(8) Optional(10)
     Optional(10) Optional(12)
     Optional(12) Optional(14)
     Optional(14) Optional(20)
     Optional(20) Optional(22)
     Optional(22) nil
     */
    if tree1 == nil { return }
    checkInorderSuccessorOrPredecessorForEveryNode(tree1?.left, &prev)
    
    if prev != nil {
        prev?.next = tree1
    }
    prev = tree1
    checkInorderSuccessorOrPredecessorForEveryNode(tree1?.right, &prev)
}

func constructBinaryTreeFromArrayWhereArrayIndexIsValue(_ array: [Int]){
    /*
     -1 represent the root node.
     
     input:- {-1,0,0,1,1,3,5}
     leveloredr traversal output:- 0 1 2 3 4 5 6
     
     -1 is root it is at index 0 so root value is 0
     
     
     take a array to store newly created node. If -1 is there then create root node.
     Get parent node from the array index. if parent node is there attach left and right node else create new parent node and store it in array
     
     assuming it is binary tree
     */
    
    var root: Tree<Int>? = nil
    var nodeArray: [Tree<Int>?] = Array(repeating: nil, count: array.count)
    
    for i in 0..<array.count {
        if array[i] == -1 {
            if let parentNode = nodeArray[i] {
                root = parentNode
            }else {
                root = Tree<Int>(i)
                nodeArray[i] = root
            }
        }else if let parentNode = nodeArray[array[i]] {
            let node = Tree<Int>(i)
            if parentNode.left == nil {
                parentNode.left = node
            }else {
                parentNode.right = node
            }
            nodeArray[i] = node
        }else {
            let parentNode = Tree<Int>(array[i])
            let cur = Tree<Int>(i)
            nodeArray[array[i]] = parentNode
            parentNode.left = cur
            nodeArray[i] = cur
        }
    }
    
    //print levelordertravesal
    levelOrder(root)
}

func convertBinaryTreeToDoubleLinkedList<T: Equatable>(_ tree1: Tree<T>?) {
    //To convert tree into linked list do the inorder traversal and store the first node as the root node
    // in the same tree use left pointer to previous and right to next pointer
    /*
     let t1 = Tree<Int>(10)
     t1.left = Tree<Int>(12)
     t1.right = Tree<Int>(15)
     t1.left?.right = Tree<Int>(30)
     t1.left?.left = Tree<Int>(25)
     
     t1.left is t1 pointing to prev
     t1.right is pointing to next
     
     output:- Optional(25)
     Optional(12)
     Optional(30)
     Optional(10)
     Optional(36)
     Optional(15)

     */
    if tree1 == nil { return }
    var head: Tree<T>?  = nil, prev: Tree<T>? = nil
    convertToDLL(tree1: tree1)
    printNode(head)
    
    func convertToDLL(tree1: Tree<T>?) {
        if tree1 == nil { return }
        
        convertToDLL(tree1: tree1?.left)
        if head == nil {
            head = tree1
        }else {
            tree1?.left = prev
            prev?.right = tree1
        }
        prev = tree1
        convertToDLL(tree1: tree1?.right)
    }
    
    func printNode(_ head: Tree<T>?) {
        var cur = head
        while cur != nil {
            print(cur!.d)
            cur = cur?.right
        }
    }
}

func flattenBinaryTreeIntoLinkedList<T: Equatable>(_ tree1: Tree<T>?) {
    if tree1 == nil { return }
    var prev: Tree<T>? = nil
    flatten(tree1)
    printNode(tree1)
    
    func flatten(_ tree1: Tree<T>?) {
        if tree1 == nil { return }
        flatten(tree1?.right)
        flatten(tree1?.left)
        tree1?.right = prev
        tree1?.left = nil
        prev = tree1
    }
    
    func printNode(_ head: Tree<T>?) {
        var cur = head
        while cur != nil {
            print(cur!.d)
            cur = cur?.right
        }
    }
    
    /*
     this can be done using iterative method with O(1) space complexity
     cur = tree1
     var prev: Tree<T>? = nil
     while cur != nil {
     if cur.left != nil {
     prev = cur.left
     while prev.right != nil {
     prev = prev.right
     }
     prev?.right = cur?.right
     cur?.right = cur?.left
     }
     cur = cur?.right
     }
     */
}


func constructABinaryTreeFromLinkedList<T: Equatable>(_ head: Tree<T>?) {
    /*
     Need to check whether it is a complete binary tree or not if it is complete binary tree then every root node at position i and left child at 2*i+1 and right child at 2*i+2
     This can be done using level order.
     
     e.g: - 10->12->15->25->30->36 is the linked list then root will be 10 in output
     
     consider right will be as next node in the linked list
     */
    
    // this is linked list
    var head = head
    if head == nil { return }
    
    // this is binary tree
    var root: Tree<T>? = head
    
    //level oredr to convert inkedlist to binary tree
    var queue: [Tree<T>?] = [root]
    
    head = head?.right
    while head != nil  {
        print(queue.count)
        let parent = queue.removeFirst()
       
        var leftNode = head
        parent?.left = leftNode
        
        //move to next node
        head = head?.right
        
        var rightNode = head
        parent?.right = head
        
        //move head counter to next to point next nodes in ll
        head = head?.right
        
        
        // this we assigning due to keeping both linked list and tree with same node so.
        // else we can create Tree with new node using linked list data i.e Tree(head!.d!)
        leftNode?.left = nil
        leftNode?.right = nil
        rightNode?.left = nil
        rightNode?.right = nil
        
        queue.append(leftNode)
        queue.append(rightNode)
    }
    
    // print in leveloredr
    levelOrder(root)
}


class TreeWithParentPointer<T: Equatable>: Hashable {
    var d: T
    var left: TreeWithParentPointer?
    var right: TreeWithParentPointer?
    var parent: TreeWithParentPointer?
    
    static func == (lhs: TreeWithParentPointer, rhs: TreeWithParentPointer) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var identifier: String
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    init(_ d: T) {
        self.d = d
        self.identifier = UUID().uuidString
    }
}

func findAllNodesAtDistanceKDistance<T: Equatable>(_ tree1: TreeWithParentPointer<T>?, _ k: Int, _ target: TreeWithParentPointer<T>?) {
    /*
     find all the node which is k distance from the target node
     
     //input:- k = 1 target is t1.right?.right
     let t1 = Tree<Int>(10)
     t1.right = Tree<Int>(12)
     t1.right?.right = Tree<Int>(15)
     
     // output it has one node 1 distance away from target node i.e t1.right
     
     to solve this we need upward and the bottom ward direction to check the distance
     
     we know tree has only downward pointer i.e left and right. It doesn't have pointer to root. we need to some how connect every node points to it's parent node .
     
     // to achive this we need BF traversal i.e level order traversal.
     
     // here they can give target node address or they can give the value for the target node. what ever they give we need to find the target node in tree.
     */
    if tree1 == nil { return }
    var queue: [TreeWithParentPointer<T>] = [tree1!]
    
    /*
     this helps to add parent pointer to the tree...
     */
    while !queue.isEmpty {
        let t = queue.removeFirst()
        let left = t.left
        let right = t.right
        
        left?.parent = t
        right?.parent = t
        if left != nil { queue.append(left!) }
        if right != nil { queue.append(right!) }
    }
    
    /*
     find the target node in binary tree. If target node address is given the start using that node
     else search in binary tree with target data and get the address of target node.
     
     use dict to store the visited node list if we already visited then we shouldn't use that node
     */
    
    var dict:[String: Bool] = [:], distance = 0
    queue.removeAll()
    if target == nil { return }
    queue.append(target!)
    dict[target!.identifier] = true
    
    while !queue.isEmpty && distance < k {
        let level = queue.count
        for _ in 0..<level {
            let t = queue.removeFirst()
            if let left = t.left,
               dict[left.identifier] == nil {
                dict[left.identifier] = true
                queue.append(left)
            }
            
            if let right = t.right,
               dict[right.identifier] == nil {
                dict[right.identifier] = true
                queue.append(right)
            }
            
            if let parent = t.parent,
               dict[parent.identifier] == nil {
                dict[parent.identifier] = true
                queue.append(parent)
            }
        }
        distance += 1
    }
    for t in queue {
        print(t.d)
    }
}


func sumOfOddAndEvenLevel(_ tree: Tree<Int>?) {
    /*
     Get the sum of all node for every level oredr keep two different sum for even level and odd level
     finally get the difference of both the sum
     */
    if tree == nil { return }
    var oddSum = 0, evenSum = 0
    var queue: [Tree<Int>] = [tree!], level = 1
    
    while !queue.isEmpty {
        let levelSize = queue.count
        for _ in 0..<levelSize {
            let t = queue.removeFirst()
            if level%2 == 0 {
                evenSum += t.d!
            }else {
                oddSum += t.d!
            }
            if let left = t.left {
                queue.append(left)
            }
            if let right = t.right {
                queue.append(right)
            }
        }
        level += 1
    }
    print("difference", abs(oddSum-evenSum))
}

func printReverseLevelOrderTraversal(_ tree: Tree<Int>?) {
    // take queue to store level order detail and stack to store in the reverse order
    if tree == nil { return }
    var queue: [Tree<Int>] = [tree!], stack: [[Int]] = []
    
    while !queue.isEmpty {
        let size = queue.count
        var current: [Int] = []
        for _ in 0..<size {
            let t = queue.removeFirst()
            current.insert(t.d!, at: 0)
            if t.right != nil {
                queue.append(t.right!)
            }
            if t.left != nil {
                queue.append(t.left!)
            }
        }
        stack.insert(current, at: 0)
    }
    
    while !stack.isEmpty {
        print(stack.removeFirst())
    }
}

func findMinimumAbsoluteDifference(_ tree: Tree<Int>?) {
    /*
     do a inorder traversal to get the minmum difference between two nodes
     */
    var prev: Tree<Int>? = nil, minDiff = Int.max
    func findDiff(_ tree: Tree<Int>?) {
        if tree == nil { return }
        findDiff(tree?.left)
        if prev != nil {
            minDiff = min(minDiff, (tree!.d!-prev!.d!))
        }else {
            minDiff = min(minDiff, (tree!.d!))
        }
        prev = tree
        findDiff(tree?.right)
    }
    print(minDiff)
}

func maximumWidthOfBinaryTree<T: Equatable>(_  tree: Tree<T>?) {
    if tree == nil { return }
    var queue: [Tree<T>] = [], maxNodes = 1
    while !queue.isEmpty {
        let size = queue.count
        for _ in queue {
            let t = queue.removeFirst()
            if let left = t.left {
                queue.append(left)
            }
            if let right = t.right {
                queue.append(right)
            }
        }
        maxNodes = max(maxNodes, size*2)
    }
    print("maximum width is \(maxNodes)")
}

func reverseTheAlternativeLevelsInBinaryTree<T: Equatable>(_  tree: Tree<T>?) {
    /*
     reverse alternative level using level order traversal
     
     input:- [["a"], ["b", "c"], ["d", "e", "f", "g"], ["h","i", "j", "k", "l", "m", "n", "o"]]
     output: [["a"], ["c", "b"], ["d", "e", "f", "g"], ["o", "n", "m", "l", "k", "j", "i", "h"]]
     */
    if tree == nil { return }
    var queue: [Tree<T>] = [tree!], level = 0
    
    while !queue.isEmpty {
        let levelCount = queue.count
        var currentQueue: [Tree<T>] = []
        for i in 0..<levelCount {
            let t = queue.removeFirst()
            if level%2 == 0 || levelCount == 1 {
                
            }else {
                if i < levelCount/2 {
                    currentQueue.append(t)
                }else {
                    let rev = currentQueue.removeLast()
                    let temp = t.d!
                    t.d! = rev.d!
                    rev.d! = temp
                }
            }
            if let left = t.left {
                queue.append(left)
            }
            if let right = t.right {
                queue.append(right)
            }
        }
        level += 1
    }
    
    levelOrder(tree)
}

func addOneRowToTree(_ tree: Tree<Int>?, _ depth: Int, _ val: Int) -> Tree<Int>? {
    /*
     note that the root node is at depth 1.
     in the depth of the node add value as another row
     
     Input: root = [4,2,6,3,1,5], val = 1, depth = 2
     Output: [4,1,1,2,null,null,6,3,1,5]
     in the above example add 1 to the level 2
     
     cur's original left subtree should be the left subtree of the new left subtree root.
     cur's original right subtree should be the right subtree of the new right subtree root.
     */
    if tree == nil && depth > 1 { return nil }
    if tree == nil { return Tree(val) }
    // if level is one create new node as root and add tree as child and return the tree
    if depth == 1 {
        let t = Tree(val)
        t.left = tree
        return t
    }
    var queue: [Tree<Int>] = [tree!], levelSize = 1
    while !queue.isEmpty {
        for _ in 0..<queue.count {
            let t = queue.removeFirst()
            if levelSize == depth-1 {
                let newLeft = Tree(val)
                newLeft.left = t.left
                
                let newright = Tree(val)
                newright.right = t.right
                if let left = t.left {
                    queue.append(left)
                }
                
                if let right = t.right { queue.append(right) }
                t.left = newLeft
                t.right = newright
            }else {
                if let left = t.left { queue.append(left) }
                if let right = t.right { queue.append(right) }
            }
        }
        levelSize += 1
    }
    
    levelOrder(tree)
    return tree
}

func findSmallestSubtreeWithDeepestNodes<T: Equatable>(_ tree: Tree<T>?, _ cur: inout Tree<T>?) -> Tree<T>? {
    /*
     find height of each tree with left node and right node. Get the max height. If left subtree has max height go to max side else go to right side
     
     keep the node as current max node.
     Traverse the Binary Tree recursively using DFS .
     For every node, find the depth of its left and right subtrees.
     If depth of the left subtree > depth of the right subtree: Traverse the left subtree.
     If depth of the right subtree > depth of the left subtree: Traverse the right subtree.
     Otherwise, return the current node.
     */
    if tree == nil { return tree }
    if tree?.left == nil && tree?.right == nil { return tree }
    let leftHeight = getHeightOfNode(tree?.left)
    let rightHeight = getHeightOfNode(tree?.right)
    if leftHeight > rightHeight {
        findSmallestSubtreeWithDeepestNodes(tree?.left, &cur)
    }else if leftHeight < rightHeight {
        findSmallestSubtreeWithDeepestNodes(tree?.right, &cur)
    }else {
        cur = tree
    }
    
    return cur
    func getHeightOfNode(_ tree: Tree<T>?) -> Int {
        if tree == nil { return 0 }
        let leftHeight = getHeightOfNode(tree?.left)
        let rightHeight = getHeightOfNode(tree?.right)
        return max(leftHeight, rightHeight)+1
    }
}


func printZigZagLevelOrder<T: Equatable>(_ tree: Tree<T>?) {
    if tree == nil { return }
    var queue: [Tree<T>?] = [tree], result: [[T?]] = [], level = 0
    while !queue.isEmpty {
        var current: [T?] = [], levelSize = queue.count
        for _ in 0..<levelSize {
            let t = queue.removeFirst()
            if level%2 == 0 {
                if t?.right != nil {queue.append(t?.right) }
                if t?.left != nil {queue.append(t?.left) }
            }else {
                if t?.left != nil {queue.append(t?.left) }
                if t?.right != nil {queue.append(t?.right) }
            }
            current.append(t?.d)
        }
        level += 1
        result.append(current)
    }
    print(result)
}

func topViewOfBinaryTree<T: Equatable>(_ tree: Tree<T>?) {
    if tree == nil { return }
    /*
     for tree with level order i.e [[1] [2 ,3] [4, 5, nil, 7] [nil, 6, nil, nil, nil]]
     
     output:- [4, 2, 1, 3, 7]
     
     // for every level print the first and last node for top view to print in a order keep the map with index of level.
     */
    var queue: [(Tree<T>, Int)] = [(tree!, 0)], dict: [Int: T] = [0:tree!.d!]
    while !queue.isEmpty {
        let t = queue.removeFirst()
        if dict[t.1] == nil {
            dict[t.1] = t.0.d!
        }
        if let left = t.0.left { queue.append((left, t.1-1)) }
        if let right = t.0.right { queue.append((right, t.1+1)) }
    }
    
    print(dict)
}

func sumOfEvenValuedGrandParent(_ tree: Tree<Int>?) {
    /*
     check the sum of all nodes if that node grand parent is even
     consider all node are distict
     sending -1 bcz root doesn't have grandParent
     */
    let sum = getSubSum(tree, -1, -1)
    print(sum)
    func getSubSum(_ tree: Tree<Int>?, _ parent: Int, _ grandParent: Int) -> Int {
        if tree == nil { return 0 }
        var sum = 0
        if grandParent%2 == 0 {
            sum += tree!.d!
        }
        let leftSum = getSubSum(tree?.left, tree!.d!, parent)
        let rightSum = getSubSum(tree?.right, tree!.d!, parent)
        return sum+leftSum+rightSum
    }
}

func kSumPathInBinaryTreePathSum(_ tree: Tree<Int>?, k: Int) {
    /*
     find the K sum path i.e print every path whose sum is equal to k.
     
     for this we need to travers array and find the sum for every path while traversing. if sum is equal to k print that path
     */
    var paths: [Tree<Int>] = [], result: [[Int]] = []
    kSumPath(tree, k: k, paths: &paths, result: &result)
    print(result)
    
    // paths is used to store the visited node list
    func kSumPath(_ tree: Tree<Int>?, k: Int, paths: inout [Tree<Int>], result: inout [[Int]]) {
        if tree == nil { return }
        paths.append(tree!)
        kSumPath(tree?.left, k: k, paths: &paths, result: &result)
        kSumPath(tree?.right, k: k, paths: &paths, result: &result)
        
        // loop to check the sum in the paths
        print(paths.count)
        var sum = 0
        for i in stride(from: paths.count-1, to: -1, by: -1) {
            print(i, paths[i].d!)
            sum += paths[i].d!
            if sum == k {
                // it is used to print the paths
                var cur: [Int] = []
                for j in i..<paths.count {
                    cur.append(paths[j].d!)
                }
                result.append(cur)
            }
        }
        // remove last item from path bcz we calculated the sum path from that node
        paths.removeLast()
    }
}


func printPathFromRootToNode(_ tree: Tree<Int>?, k: Int) {
    if tree == nil {
        return
    }
    var vector: [Int] = []
    let t = hasPath(tree, k: k, vector: &vector)
    print(vector, t)
    
    func hasPath(_ tree: Tree<Int>?, k: Int, vector: inout [Int]) -> Bool {
        if tree == nil { return false }
        vector.append(tree!.d!)
        if tree!.d! == k {
            return true
        }
        if hasPath(tree?.left, k: k, vector: &vector) || hasPath(tree?.right, k: k, vector: &vector) {
            return true
        }
        vector.removeLast()
        return false
    }
}

func printPathBetweenTwoNode(_ tree: Tree<Int>, node1: Int, node2: Int) {
    /*
     consider all elements are distict if we pass the value of node else pass the address of node to compare
     */
    var vector1: [Int] = [], vector2: [Int] = []
    hasPath(tree, node: node1, vector: &vector1)
    hasPath(tree, node: node2, vector: &vector2)
    
    print("vector1", vector1, "vector2", vector2)
    // Get intersection point
    var i = 0, j = 0, intersectionPoint = -1
    while i != vector1.count || j != vector2.count {
        if i == j && i < vector1.count && j < vector2.count && vector1[i] == vector2[j] {
            i += 1
            j += 1
        }else {
            intersectionPoint = i
            break
        }
    }
    
    // print the path between two node. start with i which we got from above that is the place where the node is common for both
    i = vector1.count-1
    while i >= 0 {
        print(vector1[i])
        i -= 1
    }
    
    // print next vector value from i+1 till the node 2
    i = intersectionPoint
    while i < vector2.count  {
        print(vector2[i])
        i += 1
    }
    
    func hasPath(_ tree: Tree<Int>?, node: Int, vector: inout [Int]) -> Bool {
        if tree == nil { return false }
        vector.append(tree!.d!)
        if tree!.d! == node {
            return true
        }
        if hasPath(tree?.left, node: node, vector: &vector) || hasPath(tree?.right, node: node, vector: &vector) {
            return true
        }
        vector.removeLast()
        return false
    }
}

func lowestCommonAncestorLCA(_ tree: Tree<Int>?, x: Int, y: Int) {
    if tree == nil { return }
    
    print(findLCA(tree, x: x, y: y)?.d)
    
    func findLCA(_ tree: Tree<Int>?, x: Int, y: Int) -> Tree<Int>? {
        if tree == nil { return tree }
        if tree!.d! == x || tree!.d! == y { return tree }
        let left = findLCA(tree?.left, x: x, y: y)
        let right = findLCA(tree?.right, x: x, y: y)
        
        if left == nil {
            return right
        }else if right == nil {
            return left
        }else {
            return tree
        }
    }
    
    /*
     this can be done by finding the path between two nodes
     
     find path from root to x
     find path from root to y
     
     find the first intersection point from both the path.
     for (i = 0; i < path1.size() && i < path2.size(); i++) {
              if (path1[i] != path2[i])
               break
     }
     return path1[i - 1];
     */
}

func findAllNodesFromLeafNodeAtKdistance<T: Equatable>(_ tree: TreeWithParentPointer<T>?, k: Int) {
    if tree == nil { return }
    var leafQueue: [TreeWithParentPointer<T>] = []
    attachParentNode(tree, leafQueue: &leafQueue)
    findAllNodesFromLeaveNodesAtDistanceK(tree, k: k, leafQueue: &leafQueue)
    
    func attachParentNode(_ tree: TreeWithParentPointer<T>?, leafQueue: inout [TreeWithParentPointer<T>]) {
        if tree == nil { return }
        var queue: [TreeWithParentPointer<T>] = [tree!]
        
        while !queue.isEmpty {
            let t = queue.removeFirst()
            if let left = t.left {
                left.parent = t
                queue.append(left)
            }
            
            if let right = t.right {
                right.parent = t
                queue.append(right)
            }
            
            // this is the leaf node store it in leafQueue
            if t.left == nil && t.right == nil {
                leafQueue.append(t)
            }
        }
    }
    
    func findAllNodesFromLeaveNodesAtDistanceK(_ tree: TreeWithParentPointer<T>?, k: Int, leafQueue: inout [TreeWithParentPointer<T>]) {
        if tree == nil, k < 0 { return }
        var visited: [String: Bool] = [:], result: [T] = []
        while !leafQueue.isEmpty {
            var queue: [TreeWithParentPointer<T>] = [], distance = 0
            queue.append(leafQueue.removeFirst())
            while !queue.isEmpty {
                let t = queue.removeFirst()
                if distance < k {
                    if t.parent != nil { queue.append(t.parent!) }
                }else {
                    if visited[t.identifier] == nil {
                        visited[t.identifier] = true
                        result.append(t.d)
                    }
                }
                distance += 1
            }
        }
        print(result)
    }
}

func findMinimumDistanceBetweenTwoNodesInBinaryTree<T: Equatable>(_ tree: Tree<T>?, a: T, b: T) {
    /*
     in this example i'm assuming every element is distinct
     if we need to match node then pass the address
     
     solution
     1. first find common ancestor for the both value.
     2. after finding common anscestor find the path from root to node has value a and path from root to b
     3. get the total path this is equal to distance
     */
    if tree == nil { return }
    let lca = findLCA(tree, a: a, b: b)
    var vector1: [T] = []
    var vector2: [T] = []
    findPath(tree, a: a, vector: &vector1)
    findPath(tree, a: b, vector: &vector2)
    print("vector1", vector1)
    print("vector2", vector2)
    // we need to minus 2 because we need to count the edges between the node for calculating minimum distance
    print(vector1.count+vector2.count-2)
    
    func findLCA(_ tree: Tree<T>?, a: T, b: T) -> Tree<T>? {
        if tree == nil { return tree }
        if tree!.d! == a || tree!.d! == b { return tree }
        let left = findLCA(tree?.left, a: a, b: b)
        let right = findLCA(tree?.right, a: a, b: b)
        if left == nil { return right }
        else if right == nil { return left }
        else { return tree }
    }
    
    func findPath(_ tree: Tree<T>?, a: T, vector: inout [T]) -> Bool {
        if tree == nil { return false }
        vector.append(tree!.d!)
        if tree!.d! == a {
            return true
        }
        if findPath(tree?.left, a: a, vector: &vector) || findPath(tree?.right, a: a, vector: &vector) {
            return true
        }
        
        vector.removeLast()
        return false
    }
}

func findSumOfDistanceOfEveryNode<T: Equatable>(_ tree: Tree<T>?, target: T) {
    /*
     we can solve this by finding path for every node from every node return the sum for all
     
     but this can be achived by efficient way i.e
     1. find the totalCount of node in the tree for each sub tree
     2. find the distance sum of all node from root
     3. then iterate over every node and find sum using nodeDostanceSum = RootTotalSum-subTreeLength+(totalCount-subTreeLength)
     
     the following relation gives the sum of distances of all nodes from a node, say u:
     
     sumDists(u)= sumDists(parent(u)) – (Nodes in the left and right subtree of u) + (N – Nodes in the left and right subtree of u)

     where,
     sumDists(u): Sum of distances of all nodes from the node u
     sumDists(parent(u)): Sum of distances of all nodes from the parent node of u
     */
    if tree == nil { return }
    
    
    /*
     this we tried for target node 3 same we can use for all the nodes. efficient way for storing all nodes is keep traversal one time and store all the subtree count in array and the calculate the total node and store the edges for parent
     */
    
    let totalNodes = findNumberOfNodes(tree)
    let distanceRoot = sumofdepth(tree, l: 0)
    var sum = 0
    
    findDistanceOfAllNodeFromTargetNode(tree, target: target, distanceSum: distanceRoot, totalNodes: totalNodes)
    
    print(sum)
    
    func sumofdepth(_ tree: Tree<T>?, l: Int) -> Int {
        if tree == nil { return 0 }
        return l+sumofdepth(tree?.left, l: l+1)+sumofdepth(tree?.right, l: l+1)
    }
    
    func findNumberOfNodes(_ tree: Tree<T>?) -> Int {
        if tree == nil { return 0 }
        return findNumberOfNodes(tree?.left)+findNumberOfNodes(tree?.right)+1
    }
    
    //we can pass target as the node address also
   
    func findDistanceOfAllNodeFromTargetNode(_ tree: Tree<T>?, target: T, distanceSum: Int, totalNodes: Int) {
        if tree == nil || tree!.d! == target {
            sum = distanceSum
            return
        }
        
        if let left = tree?.left {
            //sumDists(u)= sumDists(parent(u)) – (Nodes in the left and right subtree of u) + (N – Nodes in the left and right subtree of u)
            let nodes = findNumberOfNodes(left)
            let tempSum = distanceSum-nodes+(totalNodes-nodes)
            findDistanceOfAllNodeFromTargetNode(left, target: target, distanceSum: tempSum, totalNodes: totalNodes)
        }
        
        if let right = tree?.right {
            let nodes = findNumberOfNodes(right)
            let tempSum = distanceSum-nodes+(totalNodes-nodes)
            findDistanceOfAllNodeFromTargetNode(right, target: target, distanceSum: tempSum, totalNodes: totalNodes)
        }
    }
}

func LowestCommonAncestorLCAforBinarySearchTreeBST(_ tree: Tree<Int>?, a: Int, b: Int) {
    if tree == nil { return }
    let t = findLCA(tree, a: a, b: b)
    print("ancestor is \(t!.d!)")
    
    func findLCA(_ tree: Tree<Int>?, a: Int, b: Int) -> Tree<Int>?  {
        if tree == nil || tree!.d! == a || tree!.d! == b { return tree }
        
        var ancestor: Tree<Int>? = nil
        if a < tree!.d! && b < tree!.d! {
            ancestor = findLCA(tree?.left, a: a, b: b)
        }else if a > tree!.d! && b > tree!.d! {
            ancestor = findLCA(tree?.right, a: a, b: b)
        }else {
            ancestor = tree
        }
        return ancestor
    }
}

func checkCousinsInBinaryTree(_ tree: Tree<Int>, a: Int, b: Int) {
    /*
     find the level of both a, b. If both Nodes are in same level then check there parent if there parent are different then return true else return false
     */
    print(isCousin(tree, a: a, b: b))
    
    
    
    func isCousin(_ tree: Tree<Int>, a: Int, b: Int) -> Bool {
        if checkLevelOfBothTheNode(tree, a: a, b: b)  {
            // isSibling will check both the node have same parent or not
            if isSibling(tree, a: a, b: b) {
                return false
            } else {
                return true
            }
        }else {
            return false
        }
    }
    
    func isSibling(_ tree: Tree<Int>?, a: Int, b: Int) -> Bool {
        if tree == nil { return false }
        if tree?.left != nil && tree?.right != nil {
            if tree!.left!.d == a && tree!.right!.d == b {
                return true
            }else if tree!.right!.d == a && tree!.left!.d == b {
                return true
            }else {
                return isSibling(tree?.left, a: a, b: b) || isSibling(tree?.right, a: a, b: b)
            }
        }
        return false
    }
    
    func checkLevelOfBothTheNode(_ tree: Tree<Int>?, a: Int, b: Int) -> Bool {
        if tree == nil { return false }
        var queue: [Tree<Int>] = [tree!], levelOfA: Int = -1, levelOfB: Int = -1, level = 0
        
        while !queue.isEmpty {
            let size = queue.count
            for _ in 0..<size {
                let t = queue.removeFirst()
                if t.d! == a {
                    levelOfA = level
                }
                if t.d! == b {
                    levelOfB = level
                }
                if let left = t.left { queue.append(left) }
                if let right = t.right { queue.append(right) }
            }
            level += 1
            if levelOfA != levelOfB {
                return false
            }else if levelOfA != -1 && levelOfB != -1 && levelOfA == levelOfB {
                return true
            }
        }
        return false
    }
}

func sumOfCoveredAndUnCoveredNodes(_ tree: Tree<Int>?) {
    /*
     1.uncovered nodes or one in each level which if at first and last nodes to get the sum of all uncovered nodes
     2. get the total sum
     3. minus the uncovered sum with total sum to get sum of covered nodes
     4. return true if both covered and uncovered sum is same else false
     */
    if tree == nil { return }
    let totalSum = getTotalSum(tree)
    let uncoveredSum = getUncoveredLeftSum(tree?.left)+getUncoveredRightSum(tree?.right)+tree!.d!
    let coveredSum = totalSum-uncoveredSum
    
    print("coveredSum == uncoveredSum", coveredSum == uncoveredSum, "coveredSum =", coveredSum, "uncoveredSum =", uncoveredSum, "totalSum =", totalSum)
    
    func getUncoveredLeftSum(_ tree: Tree<Int>?) -> Int {
        if tree == nil { return 0 }
        let t = getUncoveredLeftSum(tree?.left)
        return t+tree!.d!
    }
    
    func getUncoveredRightSum(_ tree: Tree<Int>?) -> Int {
        if tree == nil { return 0 }
        var sum = 0
        if tree?.right != nil {
            sum += getUncoveredRightSum(tree?.right)
        }else {
            sum += getUncoveredRightSum(tree?.left)
        }
        return sum+tree!.d!
    }
    
    func getTotalSum(_ tree: Tree<Int>?) -> Int {
        /*
         traverse with level order to get the sum
         */
        if tree == nil { return 0 }
        var queue: [Tree<Int>] = [tree!], totalSum = 0
        
        while !queue.isEmpty {
            let t = queue.removeFirst()
            totalSum += t.d!
            if let left = t.left { queue.append(left) }
            if let right = t.right { queue.append(right) }
        }
        return totalSum
    }
}

func checkIsPalindrome(_ tree: Tree<Int>?) {
    if tree == nil { return }
    /*
     1. do the preorder traversal when we reach the leaf node
     2. check the path from root to leaf node as palindrome or not
     3. if it is palindrome return the path else return false
     */
    var paths: [Int] = []
    preOrderTree(tree, paths: &paths)
    
    func isPalindrome(_ array: [Int]) -> Bool {
        var low = 0, heigh = array.count-1
        while low <= heigh {
            if array[low] != array[heigh] {
                return false
            }
            low += 1
            heigh -= 1
        }
        print("paths is \(array)")
        return true
    }
    
    func preOrderTree(_ tree: Tree<Int>?, paths: inout [Int]) {
        if tree == nil { return }
        paths.append(tree!.d!)
        preOrderTree(tree?.left, paths: &paths)
        if tree?.left == nil && tree?.right == nil {
            isPalindrome(paths)
            paths.removeLast()
            return
        }else if tree?.right != nil {
            preOrderTree(tree?.right, paths: &paths)
        }
        paths.removeLast()
    }
}

func NumberNodesInSubTreeWithSameLabel(_ edges: [[Int]], label: String) {
    /*
     You are given a tree (i.e. a connected, undirected graph that has no cycles) consisting of n nodes numbered from 0 to n - 1 and exactly n - 1 edges. The root of the tree is the node 0, and each node of the tree has a label which is a lower-case character given in the string labels (i.e. The node with the number i has the label labels[i]).

     The edges array is given on the form edges[i] = [ai, bi], which means there is an edge between nodes ai and bi in the tree.
     
     
     Input: n = 7, edges = [[0,1],[0,2],[1,4],[1,5],[2,3],[2,6]], labels = "abaedcd"
     Output: [2,1,1,1,1,1,1]
     Explanation: Node 0 has label 'a' and its sub-tree has node 2 with label 'a' as well, thus the answer is 2. Notice that any node is part of its sub-tree.
     Node 1 has a label 'b'. The sub-tree of node 1 contains nodes 1,4 and 5, as nodes 4 and 5 have different labels than node 1, the answer is just 1 (the node itself).
     */
    var labelArray = Array(label)
    let tree = createTree(edges)
    var output = Array(repeating: 1, count: 7)
    findLabelWithInTheSubTree(tree, label: labelArray, output: &output)
    print(output)
    
    func findLabelWithInTheSubTree(_ tree: Tree<Int>?, label: [Character], output: inout [Int]) {
        if tree == nil { return }
        var queue: [Tree<Int>] = [tree!]
        while !queue.isEmpty {
            let t = queue.removeFirst()
            var count = 0
            getLabelCount(t, parentLabel: label[t.d!], label: label, count: &count)
            output[t.d!] = count
            if t.left != nil {
                queue.append(t.left!)
            }
            if t.right != nil {
                queue.append(t.right!)
            }
        }
    }
    
    func getLabelCount(_ tree: Tree<Int>?, parentLabel: Character, label: [Character], count: inout Int) {
        if (tree == nil) { return }
        getLabelCount(tree?.left, parentLabel: parentLabel, label: label, count: &count)
        getLabelCount(tree?.right, parentLabel: parentLabel, label: label, count: &count)
        if parentLabel == label[tree!.d!] {
            count += 1
        }
    }
    
    func createTree(_ edges: [[Int]])  -> Tree<Int>? {
        if edges.isEmpty { return nil }
        
        var root: Tree<Int>? = nil, dict: [Int: Tree<Int>] = [:]
        
        for i in edges {
            if let parent = dict[i.first!],
               let child = dict[i.last!] {
                if parent.left == nil {
                    parent.left = child
                }else {
                    parent.right = child
                }
            }else if let parent = dict[i.first!] {
                let child = Tree(i.last!)
                if parent.left == nil {
                    parent.left = child
                }else {
                    parent.right = child
                }
                dict[i.last!] = child
            }else if let child = dict[i.last!] {
                let parent = Tree(i.first!)
                parent.left = child
                dict[i.first!] = parent
            }else {
                let parent = Tree(i.first!)
                let child = Tree(i.last!)
                parent.left = child
                dict[i.last!] = child
                dict[i.first!] = parent
                if i.first! == 0 {
                    root = parent
                }
            }
        }
        return root
    }
    
}

func findMinimumDepthOfTree<T: Equatable>(_ tree: Tree<T>?) {
    if tree == nil  { return }
    
    /*
     to find the minimu depth find the path of all leaves from the root and return the minimum path this is the result
     */
    print(getMinDepth(tree))
    func getMinDepth(_ tree: Tree<T>?) -> Int {
        if tree == nil  { return 0 }
        if tree?.left == nil && tree?.right == nil { return 1 }
        let left = getMinDepth(tree?.left)
        let right = getMinDepth(tree?.right)
        return 1+min(left, right)
    }
}

func findMaximumDepthOfTree<T: Equatable>(_ tree: Tree<T>?) {
    if tree == nil  { return }
    
    /*
     to find the minimu depth find the path of all leaves from the root and return the minimum path this is the result
     */
    print(getMaxDepth(tree))
    func getMaxDepth(_ tree: Tree<T>?) -> Int {
        if tree == nil  { return 0 }
        if tree?.left == nil && tree?.right == nil { return 1 }
        let left = getMaxDepth(tree?.left)
        let right = getMaxDepth(tree?.right)
        return 1+max(left, right)
    }
}


func findMaxDifferenceBetweenNodeAndAncestor(_ tree: Tree<Int>?) {
    /*
     idea is to return the minimum value from each node and get the max value
     
     Recursively traverse every node (say t) of the tree:
     If t = NULL return INT_MAX
     If the current node is the leaf node then just return the node’s value.
     Recursively calling for left and right subtree for minimum value
     Update res if node value – minimum value from subtree is bigger than res i.e res = max(*res, t->key – val).
     Return minimum value got so far i.e. return min(val, t->key);
     */
    var ans = 0
    maxDifference(tree, ans: &ans)
    print(ans)
    
    func maxDifference(_ tree: Tree<Int>?, ans: inout Int) -> Int {
        if tree == nil { return Int.max }
        if tree!.left == nil && tree!.right == nil { return tree!.d! }
        let left = maxDifference(tree?.left, ans: &ans)
        let right = maxDifference(tree?.right, ans: &ans)
        
        let value = min(left, right)
        ans = max(tree!.d!-value, ans)
        return min(value, tree!.d!)
    }
}

func printKthAnscestor(_ tree: Tree<Int>?, target: Int, k: Int) {
    if tree == nil { return }
    /*
     travers through array and strore the value in the vector untill we reach the target node
     then travel through vector and return the kth node which is the ancestor of the node
     */
    var vector: [Int] = []
    findAnscestorPath(tree, target: target, vector: &vector)
    // to remove the matched target value from the vector
    vector.removeLast()
    
    // to get the kth ancestor vectorcount-k
    let kth = ((vector.count-k) < vector.count && (vector.count-k) > 0) ? vector[vector.count-k] : -1
    print(vector, "kth anscestor is \(kth)" )
    
    func findAnscestorPath(_ tree: Tree<Int>?, target: Int, vector: inout [Int]) -> Bool {
        if tree == nil { return false }
        vector.append(tree!.d!)
        if tree!.d! == target {
            return true
        }
        if findAnscestorPath(tree?.left, target: target, vector: &vector) || findAnscestorPath(tree?.right, target: target, vector: &vector) {
            return true
        }
        vector.removeLast()
        return false
    }
}


func findLCAForDeepestLeavesLCA<T: Equatable>(_ tree: Tree<T>?) {
    if tree == nil { return }
    let leaveQueue = findDeepestLeaves(tree!)
    let t = findLCA(tree, leaveQueue: leaveQueue)
    print(t?.d, leaveQueue)
    
    func findLCA(_ tree: Tree<T>?, leaveQueue: [T]) -> Tree<T>? {
        if tree == nil { return nil }
        if leaveQueue.contains(tree!.d!) {
            return tree
        }
        let left = findLCA(tree?.left, leaveQueue: leaveQueue)
        let right = findLCA(tree?.right, leaveQueue: leaveQueue)
        if left == nil {
            return right
        }else if right == nil {
            return left
        }else {
            return tree
        }
    }
    
    func findDeepestLeaves(_ tree: Tree<T>) -> [T]{
        var queue: [Tree<T>] = [tree], leaveQueue: [T] = []
        while !queue.isEmpty {
            let size = queue.count
            leaveQueue.removeAll()
            for _ in 0..<size {
                let t = queue.removeFirst()
                if t.left == nil && t.right == nil {
                    leaveQueue.append(t.d!)
                }
                if t.left != nil { queue.append(t.left!) }
                if t.right != nil { queue.append(t.right!) }
            }
        }
        return leaveQueue
    }
}

func findSmallestStringFromLeafNode(_ tree: Tree<String>?) {
    if tree == nil { return }
    let t = findSmallestString(tree)
    print(t)
    
    func findSmallestString(_ tree: Tree<String>?) -> String? {
        if tree == nil { return nil }
        if tree?.left == nil && tree?.right == nil { return tree?.d ?? "" }
        let left = findSmallestString(tree?.left)
        let right = findSmallestString(tree?.right)
        if left == nil {
            return right!+tree!.d!
        }else if right == nil {
            return left!+tree!.d!
        }else {
            let value = left!.count < right!.count ? left : right
            return value!+tree!.d!
        }
    }
}

func  increasingOrderSearchTree(_ tree: Tree<Int>?) {
    /*
     brute force approach is do inorder traversal and store all the data in the array and using array data do a skew tree and arrange all node connected to right node
     */
    
    /*
     brute force approach
     
     var array: [Tree<Int>] = []
     
     for i in 1..<array.count {
         array[i-1].right = array[i]
         array[i-1].left = nil
     }
     array[0].left = nil
     array[array.count-1].left = nil
     array[array.count-1].right = nil
     
     func inorder(_ tree: Tree<Int>?, _ array: inout [Tree<Int>]) {
         if tree == nil { return }
         inorder(tree?.left, &array)
         array.append(tree!)
         inorder(tree?.right, &array)
     }
     */
    
    if tree == nil { return }
    // create dummy node
    var root: Tree<Int>? = Tree(-1), rootNext: Tree<Int>? = root
    inOrder(tree)
    //print the nodes
    levelOrder(root?.right)
    
    func inOrder(_ tree: Tree<Int>?) {
        if tree == nil { return }
        inOrder(tree?.left)
        tree?.left = nil
        rootNext?.right = tree
        rootNext = tree
        inOrder(tree?.right)
    }
}

func serializeAndDeSerialize(_ tree: Tree<Int>?) {
    /*
     1. we can use any traversal to create our own serialize and deserialize method
     2. in serialize function send the array to get string
     3. same string i need to pass to deserialize to get the tree back.
     
     here i'm using level traversal to get the string in serializer method and # for null node
     this is assumed that tree is binary tree
     */
    
    if tree == nil { return }
    print("before serializer and deserializer")
    levelOrder(tree)
    let str = serialize(tree)
    print("serialized string is \(str)")
    let t = deSerialize(str)
    print("after serializer and deserializer")
    levelOrder(t)
    
    func serialize(_ tree: Tree<Int>?) -> String? {
        if tree == nil { return nil }
        var queue: [Tree<Int>?] = [tree], str = ""
        
        while !queue.isEmpty {
            let t = queue.removeFirst()
            if t != nil {
                str.append("\(t!.d!),")
            }else {
                str.append("#,")
            }
            if t != nil {
                queue.append(t?.left)
                queue.append(t?.right)
            }
        }
        return str
    }
    
    
    func deSerialize(_ str: String?) -> Tree<Int>? {
        if str == nil || str!.isEmpty { return nil }
        // this return array or string separated with , and empty ""
        let components = str!.components(separatedBy: CharacterSet(charactersIn: ","))
        
        let root = Tree(Int(components[0]))
        var queue: [Tree<Int>] = [root], i = 0
        dump(components)
        while !queue.isEmpty {
            let t = queue.removeFirst()
            if t.left == nil {
                i += 1
                t.left = components[i] == "#" ? nil : Tree(Int(components[i]))
                if t.left != nil { queue.append(t.left!) }
            }
            if t.right == nil {
                i += 1
                t.right = components[i] == "#" ? nil : Tree(Int(components[i]))
                if t.right != nil { queue.append(t.right!) }
            }
        }
        return root
    }
}

func serializeAndDeSerializeBinaryTreeWithPreOrder(_ tree: Tree<Int>?) {
    /*
     1. we can use any traversal to create our own serialize and deserialize method
     2. in serialize function send the array to get string
     3. same string i need to pass to deserialize to get the tree back.
     
     here i'm using level traversal to get the string in serializer method and # for null node
     this is assumed that tree is binary tree
     */
    
    if tree == nil { return }
    print("before serializer and deserializer")
    levelOrder(tree)
    var str = ""
    serializeWithPreOrder(tree, str: &str)
    print("serialized string is \(str)")
    let t = deSerialize(str)
    print("after serializer and deserializer")
    levelOrder(t)
    
    func serializeWithPreOrder(_ tree: Tree<Int>?, str: inout String) {
        if tree == nil {
            str.append("#,")
            return
        }
        str.append("\(tree!.d!),")
        serializeWithPreOrder(tree?.left, str: &str)
        serializeWithPreOrder(tree?.right, str: &str)
    }
    
    
    func deSerialize(_ str: String?) -> Tree<Int>? {
        if str == nil || str!.isEmpty { return nil }
        let components = str!.components(separatedBy: CharacterSet(charactersIn: ","))
        var i = 0
        return preorderDesirialize()
        
        func preorderDesirialize() -> Tree<Int>? {
            if components[i] == "#" {
                i += 1
                return nil
            }
            let node = Tree(Int(components[i]))
            i += 1
            node.left = preorderDesirialize()
            node.right = preorderDesirialize()
            return node
        }
    }
}

func binarySearchTreeToGreaterSumTree(_ tree: Tree<Int>?) {
    if tree == nil { return }
    /*
     every node is replaced with the value of it's sum and the subtree sum.
     and replace tree data with the sum data.
     
     - this needs a inorder traversal but first start with the right side
     */
    if tree == nil { return }
    var sum = 0
    
    print("before")
    levelOrder(tree)
    orderSum(tree)
    print("after")
    levelOrder(tree)
    
    func orderSum(_ tree: Tree<Int>?) {
        if tree == nil { return }
        orderSum(tree?.right)
        tree!.d! += sum
        sum = tree!.d!
        print(sum)
        orderSum(tree?.left)
    }
}

func allElementsFromTwoBST(_ root: Tree<Int>?, _ root2: Tree<Int>?) {
    if root == nil && root2 == nil { return }
    var array: [Int] = []
    BSTMerge(root, root2, array: &array)
    print(array)
    
    func BSTMerge(_ root: Tree<Int>?, _ root2: Tree<Int>?, array: inout [Int]) {
        if root == nil && root2 == nil { return }
        BSTMerge(root?.left, root2?.left, array: &array)
        if root == nil {
            array.append(root2!.d!)
        }else if root2 == nil {
            array.append(root!.d!)
        }else if root!.d! < root2!.d! {
            array.append(root!.d!)
            array.append(root2!.d!)
        }else {
            array.append(root2!.d!)
            array.append(root!.d!)
        }
        BSTMerge(root?.right, root2?.right, array: &array)
    }
}

func RangeSumBST(_ root: Tree<Int>?, low: Int, heigh: Int) {
    if root == nil { return }
    /*
     range sum bst is one find all the nodes within the range of low and heigh and calculate the sum
     */
    
    func range(_ root: Tree<Int>?, low: Int, heigh: Int, sum: inout Int) {
        if root == nil { return }
        if low < root!.d!  {
            range(root?.left, low: low, heigh: heigh, sum: &sum)
        }
        if root!.d! >= low  && root!.d! <= heigh {
            sum += root!.d!
        }
        if heigh > root!.d!  {
            range(root?.right, low: low, heigh: heigh, sum: &sum)
        }
    }
}

func removeAllHalfNodes(_ root: Tree<Int>?) {
    if root == nil { return }
    /*
     Given A binary Tree, how do you remove all the half nodes (which has only one child)? Note leaves should not be touched as they have both children as NULL.
     
     solution
     do a post order traversal and remove the left and right child if it only one
     */
    levelOrder(root)
    let t = removeNode(root)
    levelOrder(t)
    func removeNode(_ root: Tree<Int>?) ->  Tree<Int>? {
        if root == nil { return nil }
        removeNode(root?.left)
        removeNode(root?.right)
        if root?.left == nil && root?.right == nil { return root }
        if root?.left == nil {
            root?.d! = root!.right!.d!
            root?.left = root?.right?.left
            root?.right = root?.right?.right
            return root
        }
        if root?.right == nil {
            root?.d! = root!.left!.d!
            root?.left = root?.left?.left
            root?.right = root?.left?.right
            return root
        }
        return root
    }
}

class RandomTree: Hashable {
    static func == (lhs: RandomTree, rhs: RandomTree) -> Bool {
        return lhs === rhs
    }
    
    var identifier: String
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    var d: Int = 0
    var left: RandomTree?
    var right: RandomTree?
    var random: RandomTree?
    
    init (_ d: Int) {
        self.d = d
        self.identifier = UUID().uuidString
    }
}

func cloneBinaryTreeWithRandomPointer(_ tree: RandomTree?) {
    if tree == nil { return }
    // used to keep tarck of the random pointer Nodes
    var dict: [RandomTree: RandomTree] = [:]
    let clone = cloneLeftRight(tree)
    cloneRandom(tree, clone: clone)
    
    func cloneLeftRight(_ tree: RandomTree?) -> RandomTree? {
        if tree == nil { return nil }
        let clone = RandomTree(tree!.d)
        dict[tree!] = clone
        clone.left = cloneLeftRight(tree?.left)
        clone.right = cloneLeftRight(tree?.right)
        return clone
    }
    
    func cloneRandom(_ tree: RandomTree?, clone:  RandomTree?) {
        if clone == nil || tree == nil { return }
        if let t = tree?.random, let rand = dict[t] { clone?.random = rand  }
        cloneRandom(tree?.left, clone: clone?.left)
        cloneRandom(tree?.right, clone: clone?.right)
    }
}

func createBSTFromArraySortedArray(_ array: [Int]) {
    
    let t = binarySearchTreeFromArray(array, start: 0, end: array.count-1)
    levelOrder(t)
    
    func binarySearchTreeFromArray(_ array: [Int], start: Int, end: Int) -> Tree<Int>? {
        if array.isEmpty { return nil }
        if start > end { return nil }
        let mid = (start+end)/2
        let root = Tree(array[mid])
        root.left = binarySearchTreeFromArray(array, start: start, end: mid-1)
        root.right = binarySearchTreeFromArray(array, start: mid+1, end: end)
        return root
    }
}

func flipBinaryTreeToMatchPreOrder<T: Equatable>(_ tree: Tree<T>?, preOrder: [T]) {
    if tree == nil || preOrder.isEmpty { return }
    /*
     if first element is the root node if root node is not equal then there is no way to flip the binary tree so return -1
     */
    
    
    var result = 0, i = 0, arra: [T] = []
    
    if flip(tree, preOrder: preOrder) {
        print("can be fliped with result \(result) with node \(arra)")
    }else {
        print("can't flip")
    }
    
    func flip(_ tree: Tree<T>?, preOrder: [T]) -> Bool {
        if tree == nil { return true }
        if tree!.d! != preOrder[i] {
            i += 1
            return false
        }
        if let left = tree?.left,
           left.d! !=  preOrder[i] {
            result += 1
            arra.append( left.d!)
            return flip(tree?.right, preOrder: preOrder) && flip(tree?.left, preOrder: preOrder)
        }else {
            return flip(tree?.left, preOrder: preOrder) && flip(tree?.right, preOrder: preOrder)
        }
    }
}

func daigonalTraversalOfBinaryTree<T: Equatable>(_ tree: Tree<T>?) {
    /*
     go with level oreder traversal and have a dict to store the node with the daigonal node value as key and data as value then at finally print the dictionary
     
     every node whose right node will have same daigonal but the left node will have the daiognalvalueOfParent+1
     */
    
    printDaigonalOrder(tree)
    
    func printDaigonalOrder(_ tree: Tree<T>?) {
        if tree == nil { return }
        // queue should store the tree and the daigonal of that node
        var queue: [(Tree<T>, Int)] = [(tree!, 0)], dict: [Int: [T]] = [:]
        
        while !queue.isEmpty {
            let levelSize = queue.count
            for _ in 0..<levelSize {
                let t = queue.removeFirst()
                if var values = dict[t.1] {
                    values.append(t.0.d!)
                    dict[t.1] = values
                }else {
                    dict[t.1] = [t.0.d!]
                }
                if t.0.left != nil { queue.append((t.0.left!, t.1+1)) }
                if t.0.right != nil { queue.append((t.0.right!, t.1)) }
            }
        }
        print(dict.values)
    }
}

func minimumSwapsRequiredToConvertBinaryTreeToBinarySearchTree(_ tree: Tree<Int>?) {
    if tree == nil { return }
    /*
     for this we can store the binary tree data into the array the we can do swap of that array to get the minimum number of swaps required
     
     we can use the inorder traversal here bcz inorder traversal of gives the ascending order for BST
     */
    
    var array = [Int]()
    inorder(tree)
    minSwapRequired()
    
    func inorder(_ tree: Tree<Int>?) {
        if tree == nil { return }
        inorder(tree?.left)
        array.append(tree!.d!)
        inorder(tree?.right)
    }
    
    func minSwapRequired() {
        var i = 0, j = array.count-1, swapRequired = 0
        
        while i<j {
            if array[i] < array[j] {
                i += 1
            }else {
                swapRequired += 1
                let t = array[i]
                array[i] = array[j]
                array[j] = t
            }
        }
        print(swapRequired)
    }
}

func largestBSTInBinaryTree(_ tree: Tree<Int>?) {
    if tree == nil { return }
    
    /*
     this is brue force approach to check isBST for subnode for every node. it takes O(n2)
     
     func isBST(_ tree: Tree<Int>?) -> Bool {
         if tree == nil || (tree?.left == nil && tree?.right == nil) { return true }
         if tree?.left == nil {
             return tree!.d! >= tree!.left!.d!
         }
         if tree?.right == nil {
             return tree!.d! <= tree!.right!.d!
         }
         return tree!.d! >= tree!.left!.d! && tree!.d! <= tree!.right!.d! && isBST(tree?.left) && isBST(tree?.right)
     }
     */
    
    /*
     efficient solution is like get the largest from all node in left side and smallest from right side
     */
    
    let largestSubtree = getLargestBSTCount(tree)
    print(largestSubtree.count, largestSubtree.treeData)
    
    // do a post order
    func getLargestBSTCount(_ tree: Tree<Int>?) -> (count: Int, min: Int, max: Int, treeData: String) {
        if tree == nil { return (0, Int.max, Int.min, "") }
        let left = getLargestBSTCount(tree?.left)
        let right = getLargestBSTCount(tree?.right)
        
        if left.max < tree!.d! && tree!.d! < right.min {
            let str = "\(left.treeData), \(right.treeData), \(tree!.d!)"
            let min = min(left.min, tree!.d!)
            let max = max(right.max, tree!.d!)
            let count = (1+left.count+right.count)
            return (count,min, max, str)
        }else {
            var str = left.count > right.count ? left.treeData : right.treeData
            let count = max(left.count, right.count)
            return (count, Int.min, Int.max, str)
        }
    }
}

func checkBinaryTreeContainsDuplicateSubtrees<T: Equatable>(_ tree: Tree<T>?) {
    /*
     we pick every node of tree and try to find is any sub-tree of given tree is present in tree which is identical with that sub-tree. using the subtree check in tree
     
     efficient way using tree serialization. Tree serialisation is converting tree into the string using some order and The idea is to serialize subtrees as strings  store the string in hash table
     */
    
    var dict: [String: Int] = [:]
    _ = isDuplicate(tree)
    
    dict.filter({ $0.value >= 2 })
    
    print(dict, !dict.isEmpty)
    
    func isDuplicate(_ tree: Tree<T>?) -> String {
        // this act as delimiter
        if tree == nil { return "$" }
        if tree?.left == nil && tree?.right == nil { return "\(tree!.d!)" }
        var s = ""
        let left = isDuplicate(tree?.left)
        let right = isDuplicate(tree?.right)
        s += left+right
        if var val = dict[s] {
            val += 1
            dict[s] = val
        }else {
            dict[s] = 1
        }
        return s
    }
}


func recoverBSTByCorrectingTwoNodes(_ tree: Tree<Int>?) {
    if tree == nil { return }
    /*
     this can be done using inorder traversal keep all elements in array then swap the elements with the next smaller element to get the BST
     this can be achivied within the tree as well the problem says only 2 nodes needs to swap to correct tree to BST so use thre pointer prev, mid and last
     */
    var prev: Tree<Int>? = nil, mid: Tree<Int>? = nil, last: Tree<Int>? = nil, first: Tree<Int>? = nil
    recover(tree)
    if last != nil, first != nil {
        let t = last!.d!
        last!.d! = first!.d!
        first!.d! = t
    }else if first != nil, mid != nil {
        let t = mid!.d!
        first!.d! = mid!.d!
        mid!.d! = t
    }
    
    func recover(_ tree: Tree<Int>?) {
        if tree == nil { return }
        recover(tree?.left)
        if prev != nil,
           tree!.d! < prev!.d! {
            if first == nil {
                first = prev
                mid = tree
            }else {
                last = tree
            }
        }
        prev = tree
        recover(tree?.right)
    }
}

func trimBinarySearchTree (_ tree: Tree<Int>? , low: Int, heigh: Int) {
    /*
     remove the tree whose value is less than the low and heigher than the height
     Trimming the tree should not change the relative structure of the elements that will remain in the tree
     */
    if tree == nil { return }
    let t = trimBinaryTree(tree)
    levelOrder(tree)
    
    func trimBinaryTree(_ tree: Tree<Int>?) -> Tree<Int>? {
        if tree == nil { return nil }
        if tree!.d! >= low && tree!.d! <= heigh {
            tree?.left = trimBinaryTree(tree?.left)
            tree?.right = trimBinaryTree(tree?.right)
            return tree
        }else if tree!.d! > heigh {
            return trimBinaryTree(tree?.left)
        }else {
            return trimBinaryTree(tree?.right)
        }
    }
}

func findKthSmallestElementInBst(_ tree: Tree<Int>?, k: Int) {
    if tree == nil { return }
    
    /*
     inorder travesal to get the kth element
     */
    var val = Int.max, i = 0
    kthSmallestElementInBST(tree)
    print(val)
    func kthSmallestElementInBST(_ tree: Tree<Int>?) {
        if tree == nil { return }
        kthSmallestElementInBST(tree?.left)
        if i < k {
            val = tree!.d!
            i += 1
        }
        kthSmallestElementInBST(tree?.right)
    }
}

func findKthlargestElementInBst(_ tree: Tree<Int>?, k: Int) {
    if tree == nil { return }
    
    /*
     inorder travesal to get the kth element
     */
    var val = Int.max, i = 0
    kthLargetElementInBST(tree)
    print(val)
    func kthLargetElementInBST(_ tree: Tree<Int>?) {
        if tree == nil { return }
        kthLargetElementInBST(tree?.right)
        if i < k {
            val = tree!.d!
            i += 1
        }
        kthLargetElementInBST(tree?.left)
    }
}

func deleteLeavesWithGivenValue(_ tree: Tree<Int>?, target: Int) {
    /*
     remove only leaf node which is equal to target node. If parent become leave then remove parent as well
     */
    deleteLeaves(tree)
    levelOrder(tree)
    func deleteLeaves(_ tree: Tree<Int>?) -> Tree<Int>? {
        if tree == nil { return nil }
        let left = deleteLeaves(tree?.left)
        let right = deleteLeaves(tree?.right)
        tree?.left = left
        tree?.right = right
        if tree?.left == nil && tree?.right == nil && tree!.d! == target {
            return nil
        }else {
            return tree
        }
    }
}

func deleteNodesAndReturnForset(_ tree: Tree<Int>?, to_delete: [Int]) {
    if tree  == nil || to_delete.isEmpty { return }
    
    var array = [Tree<Int>]()
    delete(tree)
    func delete(_ tree: Tree<Int>?) -> Tree<Int>? {
        if tree == nil { return nil }
        tree?.left = delete(tree?.left)
        tree?.right = delete(tree?.right)
        if to_delete.contains(tree!.d!) {
            if tree?.left != nil {
                array.append(tree!.left!)
            }
            if tree?.right != nil {
                array.append(tree!.right!)
            }
            return nil
        }else {
            array.append(tree!)
        }
        return tree
    }
}

func validateBinaryTree(_ n: Int, leftChild: [Int], rightChild: [Int]) {
    /*
     You have n binary tree nodes numbered from 0 to n - 1 where node i has two children leftChild[i] and rightChild[i]
     Input: n = 4, leftChild = [1,-1,3,-1], rightChild = [2,-1,-1,-1]
     
     input is given as array we need to find whether it is valid binary tree or not using the input.
     1. if node has two parent then it is not valid binary tree
     2. if node has cycle then it is not binary tree.
     
     this can be achived by
     1. construct a tree using the input
     2. validate the tree
     validate by following
     1. while validating check for cycle
     2. check for multiple parent
     3. if node is there but not connected then it is not valid
     4. multiple root
     */
    
    print(validate())
    
    func validate() -> Bool {
        var queue = [Int]()
        var hashSet = [Int]()
        // bcz node starts from 0..n-1
        queue.append(0)
        while !queue.isEmpty {
            let i = queue.first!
            // bcz it is already visited or it has more pointing node
            if hashSet.contains(i) {
                return false
            }
            hashSet.append(i)
            if leftChild[i] != -1 {
                queue.append(leftChild[i])
            }
            if rightChild[i] != -1 {
                queue.append(rightChild[i])
            }
        }
        return hashSet.count == n
    }
}

func constructBinaryTreeFromPreOrderAndPostOrder(_ pre: [Int], post: [Int]) {
    /*
     using pre order and post order we can't construct unique binary tree but we can create the full unique binary tree
     
     preorder first element will have root node
     
     find the next element in preorder and find the position of that in post order all the value before that will be in left child and after in right child
     */
    var preIndex = 0
    let t = construct(0, heigh: pre.count-1)
    levelOrder(t)
    
    func construct(_ low: Int, heigh: Int) -> Tree<Int>? {
        if low > heigh  || preIndex >= pre.count { return nil }
        var root = Tree(pre[preIndex])
        preIndex += 1
        
        if low == heigh {
            return root
        }
        
        //find the index of next element in post order
        let index = post.firstIndex(of: pre[preIndex])!
        
        if index < heigh {
            root.left = construct(low, heigh: index)
            root.right = construct(index+1, heigh: heigh-1)
        }
        return root
    }
}

func constructBinarySearchBSTFromPreOrderTraversal(_ pre: [Int]) {
    /*
     1. we can construct the tree using naview approach by traversing each element and iterate throgh the node to insert. but this will take time complexity of O(n2)
     
     2nd approach is we can sort preorder to get inorder list the construct binary tree from preOrder and inorder list
     
     3rd approach without inorder travers through the list with binary tree search property
     */
    
    
    var index = 0
    let t = construct(pre, upperBound: Int.max)
    levelOrder(t)
    
    func construct(_ pre: [Int], upperBound: Int) -> Tree<Int>? {
        if pre.count <= index || pre[index] > upperBound { return nil }
        let root = Tree(pre[index])
        
        index += 1
        root.left = construct(pre, upperBound: root.d!)
        root.right = construct(pre, upperBound: upperBound)
        return root
    }
}

func constructBinaryTreeFromPreOrderAndInorder(_ pre: [Int], inOrder: [Int]) {
    
    var preindex = 0
    let t = construct(low: 0, heigh: pre.count-1)
    levelOrder(t)
    
    func construct(low: Int, heigh: Int) -> Tree<Int>? {
        if preindex >= pre.count { return nil }
        let root = Tree(pre[preindex])
        preindex += 1
        
        if low == heigh {
            return root
        }
        
        let index = inOrder.firstIndex(of: root.d!)!
        print(index)
        root.left = construct(low: low, heigh: index-1)
        root.right = construct(low: index+1, heigh: heigh)
        return root
    }
}


func constructTreeFromAncestorMatrix(_ matrix: [[Int]]) {
    
    let t = construct()
    levelOrder(t)
    
    func construct() -> Tree<Int>? {
        var dict: [Int: (cur: Tree<Int>?, parent: Tree<Int>?)] = [:]
        var root: Tree<Int>? = nil, maxCount = Int.min
        for i in 0..<matrix.count {
            var cur = 0
            for j in 0..<matrix.count {
                let parent = dict[i]?.cur ?? Tree(i)
                dict[i] = (parent, dict[i]?.parent)
                if matrix[i][j] == 1 {
                    cur += 1
                    if dict[j] != nil && dict[j]?.parent != nil {
                        
                    }else {
                        let child = dict[j]?.cur ?? Tree(j)
                        dict[j] = (child, parent)
                        if parent.left == nil {
                            parent.left = child
                        }else {
                            parent.right = child
                        }
                    }
                }
            }
            if cur > maxCount { root = dict[i]?.cur }
            maxCount = max(cur, maxCount)
        }
        return root
    }
}

func removeNodesFromPathWhoseSumIsLessThank(_ tree: Tree<Int>?, k:  Int) {
    var sumFromRootToChild = 0
    let t = removeNodes(tree)
    levelOrder(t)
    
    func removeNodes(_ tree: Tree<Int>?) -> Tree<Int>? {
        if tree == nil { return nil }
        //it helps to keep the sum value from path to cur node
        sumFromRootToChild += tree!.d!
        tree?.left = removeNodes(tree?.left)
        tree?.right = removeNodes(tree?.right)
        if sumFromRootToChild < k {
            sumFromRootToChild -= tree!.d!
            if tree?.left != nil ||  tree?.right != nil {
                return tree
            }else {
                return nil
            }
        }else {
            sumFromRootToChild -= tree!.d!
            return tree
        }
    }
}

func RecoverTreeFromPreorderTraversal(_ pre: String) {
    
    var components = Array(pre), preIndex = 0
    let t = constructTree(0)
    levelOrder(t)
    
    func constructTree(_ level: Int) -> Tree<Character>? {
        /*
         input "1-2--3--4-5--6--7"
         output [1,2,5,3,4,6,7]
         
         At each node in this traversal, we output D dashes (where D is the depth of this node)
         - is the depth of the tree
         */
        if preIndex >= components.count || level > components.count  { return nil }
        var dashCount = 0
        for i in preIndex..<components.count {
            if components[i] == "-" {
                dashCount += 1
            }else {
                break
            }
        }
        if dashCount != level {
            return nil
        }else {
            preIndex += dashCount
        }
        
        let tree = Tree<Character>(components[preIndex])
        preIndex += 1
        tree.left =  constructTree(level+1)
        tree.right =  constructTree(level+1)
        return tree
    }
}

class ExpressionTree {
    var d: Any
    var left: ExpressionTree?
    var right: ExpressionTree?
    init(_ d: Any) {
        self.d = d
    }
}

func evaluateExpression(_ tree: ExpressionTree?) {
    let symbols = ["+", "-", "*", "/"]
    let t = evaluate(tree: tree)
    print(t)
                     
    func getValue(_ t: Int, t1: Int, symbol: String) -> Int {
        switch symbol {
        case "+": return t+t1
        case "-": return t-t1
        case "*": return t*t1
        default: return t/t1
        }
    }
    
    func evaluate(tree: ExpressionTree?) -> Int {
        if tree == nil { return 0 }
        if tree?.right == nil && tree?.left == nil { return tree!.d as! Int }
        let left = evaluate(tree: tree?.left)
        let right = evaluate(tree: tree?.right)
        let t = getValue(left, t1: right, symbol: tree!.d as! String)
        return t
    }
}

func checkRemovingEdgeCanDivideBinaryTreeIntoTwoHalfWithEqualSize(_ tree: Tree<Int>?) {
    
    let count = getCount(tree)
    let t = check(tree, count: count)
    
    func getCount(_ tree: Tree<Int>?) -> Int {
        if tree == nil { return 0 }
        let leftCount = getCount(tree?.left)
        let rightCount = getCount(tree?.right)
        return leftCount+rightCount+1
    }
    
    func check(_ tree: Tree<Int>?, count: Int) -> Bool {
        if tree == nil { return false }
        let left = check(tree?.left, count: getCount(tree?.left))
        let right = check(tree?.right, count: getCount(tree?.right))
        
        let subTreeCount = getCount(tree)
        if subTreeCount == count-subTreeCount {
            return true
        }
        
        return check(tree?.left, count: count) || check(tree?.right, count: count)
    }
}

func constructUniqueBinarySearchTree(_ n: Int) {
    /*
     1. decide root node
     2. call the function again and again to make possible trees for left and right subtree
     3. use combination of all tree to make trees and return it
     
     */
    print("number of unique tree is \(countUniqueTree(1, end: n))")
    let t = construct(1, end: n)
    print("tree count \(t.count)")
    for i in t {
        levelOrder(i)
        print("------")
    }

    func countUniqueTree(_ start: Int, end: Int) -> Int {
        if start >= end { return 1 }
        var count = 0
        for i in start...end {
            count += countUniqueTree(start, end: i-1)*countUniqueTree(i+1, end: end)
        }
        return count
    }

    func construct(_ start: Int, end: Int) -> [Tree<Int>?] {
        var trees = [Tree<Int>?]()
        if start > end || start < 1 {
            trees.append(nil)
            return trees
        }
        
        if start == end {
            var node = Tree(start)
            node.left = nil
            node.right = nil
            trees.append(node)
            return trees
        }
        
        for root in start...end {
            for left in  construct(start, end: root-1) {
                for right in construct(root+1, end: end) {
                    var node = Tree(root)
                    node.left = left
                    node.right = right
                    trees.append(node)
                }
            }
        }
        return trees
    }
}

func printFullBinaryTree(_ n: Int) {
    /*
     Given an integer n, return a list of all possible full binary trees with n nodes. Each node of each tree in the answer must have Node.val == 0.
     
     we need to print the tree with n nodes array which should be full binary tree need to print all the nodes will have the value of n
     
     full binary tree is one which has no child or it should have both child
     
     we can create full binary tree only when we have odd number of nodes.
     */
    
    if n%2 == 0 {
        print("can't do")
        return
    }
    
    let t = construct(n)
    for i in t {
        levelOrder(i!)
    }
    
    func construct(_ n: Int) -> [Tree<Int>?] {
        if n == 1 {
            return [Tree(0)]
        }
        if n == 0 {
            return []
        }
        
        var trees = [Tree<Int>?](), i = 1
        while i < n {
            for left in construct(i) {
                for right in construct(n-i-2) {
                    var node = Tree(0)
                    node.left = left
                    node.right = right
                    trees.append(node)
                }
            }
            
            i += 2
        }
        return trees
    }
}


func timeTakenToBurnTree<T: Equatable>(_ tree: TreeWithParentPointer<T>?, target: TreeWithParentPointer<T>) {
    /*
     this question can be used to burn tree from any node or leaf node if they as use leaf node to check to bur the tree
     
     have parent pointer to the everyNode
     
     if they gave target node use the target node else search for the node
     */
    
    var queue = [tree!]
    while !queue.isEmpty {
        let t = queue.removeFirst()
        if let left = t.left {
            left.parent = t
            queue.append(left)
        }
        if let right = t.right {
            right.parent = t
            queue.append(right)
        }
    }
    
    var visitedTree: [TreeWithParentPointer<T>: Bool] = [:], minTimeToBurn = 0
    
    queue = [target]
    visitedTree[target] = true
    var level = 0
    while !queue.isEmpty {
        let size = queue.count
        for _ in 0..<size {
            let t = queue.removeFirst()
            if visitedTree[t]  == nil {
                minTimeToBurn += level
            }
            if let left = t.left {
                queue.append(left)
            }
            if let right = t.right {
                queue.append(right)
            }
            if let parent = t.parent {
                queue.append(parent)
            }
            visitedTree[t] = true
        }
        level += 1
    }
}

func findAllPossibleBinaryTreeFromInOrderTraversal(_ array: [Int]) {
    let t = construct(array, 0, array.count-1)
    
    for i in t {
        levelOrder(i!)
    }
    
    func construct(_ array: [Int], _ start: Int, _ end: Int) -> [Tree<Int>?] {
        if start > end {
            return [nil]
        }
        if start == end {
            return [Tree(array[start])]
        }
        
        var trees = [Tree<Int>?]()
        for i in start..<end {
            let left = construct(array, start, i-1)
            let right = construct(array, i+1, end)
            
            for j in 0..<left.count {
                for k in 0..<right.count {
                    let t = Tree(array[i])
                    t.left = Tree(array[j])
                    t.right = Tree(array[k])
                    trees.append(t)
                }
            }
        }
        return trees
    }
}

func minimumSwapRequiredToConvertFullBinaryTreeToBinarySearchTree(_ array: [Int]) {
    /*
     the value is given in the level order format i.e
     if index i is the parent, index 2*i + 1 is the left child and index 2*i + 2 is the right child.
     
     first find the inorder of the above array then find the minimum swap required to get BST
     */
    
    var inOrderArray = [Int]()
    print("give array is \(array)")
    inOrder(array, index: 0)
    print("inorder array is \(inOrderArray)")
    
    minimumSwapRequired(&inOrderArray, array: array)
    
    func inOrder(_ array: [Int], index: Int) {
        if index >= array.count { return }
        inOrder(array, index: 2*index+1)
        inOrderArray.append(array[index])
        inOrder(array, index: 2*index+2)
    }
    
    func minimumSwapRequired(_ inOrderArray: inout [Int], array: [Int]) {
        var swap = 0
        /*
         if given array is in sorted then we can compare the array with the inorder array list else sorth the inorder list and compare the value
         */
        for i in 0..<inOrderArray.count {
            if array[i] != inOrderArray[i] {
                let index = inOrderArray.firstIndex(of:  array[i])
                inOrderArray[index!] = inOrderArray[i]
                inOrderArray[i] = array[i]
                swap += 1
            }
        }
        
        print("minimum swap required is \(swap)")
    }
}


func findGCDOfSiblingOfTree() {
    
    
    func gcd(_ a: Int, _ b: Int) -> Int {
        if b == 0 { return a }
        if a == 0 { return b }
        return gcd(b, a%b)
    }
    
    var max_gcd = Int.min
    func maxGCD(_ tree: Tree<Int>?) -> Int {
        if tree == nil { return 0 }
        let left = maxGCD(tree?.left)
        let right = maxGCD(tree?.right)
        if left != 0 && right != 0 {
            let gcd = gcd(left, right)
            max_gcd = max(max_gcd, gcd)
        }
        
        return tree?.left != nil ? gcd(tree!.d!, left) : tree!.d!
    }
}

func searchElementTOBST(_ tree: Tree<Int>?, k: Int) {
    /*
     iterative method
     while (root != null) {
                if ((int) root.data == value)
                    return true;

                if (value < (int) root.data)
                    root = root.left;

                else
                    root = root.right;
            }

            return false;
     
     */
    let t = search(tree)
    print(t)
    func search(_ tree: Tree<Int>?) -> Bool {
        if tree == nil { return false }
        if tree!.d! == k { return true }
        if k < tree!.d! {
            return search(tree?.left)
        }
        return search(tree?.right)
    }
}

func insertionInBST(_ tree: Tree<Int>?, k: Int) {
    
    levelOrder(insertion(tree))
    
    func insertion(_ tree: Tree<Int>?) -> Tree<Int>? {
        if tree == nil {
            return Tree(k)
        }
        if k < tree!.d! {
            tree?.left = insertion(tree?.left)
        }else {
            tree?.right = insertion(tree?.right)
        }
        return tree
    }
}

func removeNodeInBST(_ tree: Tree<Int>?, k: Int) {
    levelOrder(remove(tree, k))
    
    func remove(_ tree: Tree<Int>?, _ k: Int) -> Tree<Int>? {
        if tree == nil { tree }
        if k < tree!.d! {
            tree?.left = remove(tree?.left, k)
        }else if k > tree!.d! {
            tree?.right = remove(tree?.right, k)
        }else {
            if tree?.left == nil {
                return tree?.right
            }else if tree?.left == nil && tree?.right == nil {
                return nil
            }else {
                /* find the inorder predecer or successor to change the node with that value and delete that node
                 
                 to get inorder predecer search the element in the left subtree to get the greater element
                  
                 to get inorder successor search the element in the right subtree to get the smaller element
                 */
                tree?.d = inOrderSuccessor(tree?.right)
                tree?.right = remove(tree?.right, tree!.d!)
                return tree
            }
        }
        return tree
    }
    
    func inOrderSuccessor(_ tree: Tree<Int>?) -> Int {
        if tree == nil { return 0}
        var min = tree!.d!
        var root = tree
        while root?.left != nil {
            min = root!.left!.d!
            root = root?.left
        }
        return min
    }
}


func mergeTwoBinarySearchTree(_ tree1: Tree<Int>?, tree2: Tree<Int>?) {
    /*
     Approach 1
     get inorder traversal of both the tree and use merge sort on those array
     and then use result array to build the result tree
     
     Approach 2
     flatten the both tree to sorted LL using inorder traversal.
     then merge both the array using merge for both the list
     */
}



func morrisTraversal(_ tree: Tree<Int>?) {
    var cur = tree
    while cur != nil {
        if cur?.left == nil {
            // inorder traversal
            print(cur!.d!)
        }else {
            var prev = cur?.left
            while prev?.right != nil && prev?.right !== cur {
                prev = prev?.right
            }
            if prev?.right == nil {
                prev?.right = cur
                cur = cur?.left
            }else {
                prev?.right = nil
                print(cur!.d!)
                cur = cur?.right
            }
        }
    }
}

let t1 = Tree<Int>(1)
t1.left = Tree<Int>(2)
t1.left?.left = Tree<Int>(4)
t1.left?.left?.right = Tree<Int>(9)
t1.left?.left?.right?.left = Tree<Int>(13)
t1.left?.left?.right?.right = Tree<Int>(14)
t1.left?.left?.right?.right?.left = Tree<Int>(15)



t1.right = Tree<Int>(3)
t1.right?.right = Tree<Int>(7)
t1.right?.right?.left = Tree<Int>(10)
t1.right?.right?.left?.right = Tree<Int>(11)






