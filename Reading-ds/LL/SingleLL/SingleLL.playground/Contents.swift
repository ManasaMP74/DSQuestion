import UIKit

class Node<T: Equatable>: Equatable {
    var d: T?
    var next: Node?
    
    init(_ d: T?) {
        self.d = d
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.d! == rhs.d!
    }
}

func createSingleLL<T: Equatable>(_ array: [T]) -> Node<T>? {
    var dummyNode = Node<T>(nil), cur: Node<T>? = dummyNode
    for i in array {
        cur?.next = Node(i)
        cur = cur?.next
    }
    return dummyNode.next
}

func getLegthOfLL<T>(_ node: Node<T>?) -> Int {
    //1->2->3 // print 3
    var cur = node, count = 0
    while cur != nil {
        count += 1
        cur = cur?.next
    }
    return count
}

func printNode<T>(_ node: Node<T>?) {
    var cur = node, str = "\(cur?.d)->"
    print("Node-----")
    while cur?.next != nil {
        str = str.appending("\(cur?.next?.d)->")
        cur = cur?.next
    }
    print(str)
}


func printMiddleElement<T: Equatable>(_ array: [T]) {
    //1->2->3 // print 2
    //1->2->3->4 output = 3
    var head: Node<T>? = createSingleLL(array), slow = head, fast = head
    while fast != nil && fast?.next != nil {
        slow = slow?.next
        fast = fast?.next?.next
    }
    print(slow?.d)
}

func deleteMiddleElement<T: Equatable>(_ array: [T]) {
    //1->2->3 // output 1->3
    //1->2->3->4 output = 1->2->4
    var head: Node<T>? = createSingleLL(array), slow = head, fast = head, prev_Slow: Node<T>? = nil
    
    while fast != nil && fast?.next != nil {
        prev_Slow = slow
        slow = slow?.next
        fast = fast?.next?.next
    }
    
    if prev_Slow == nil || slow == nil {
        print("there is no middle element")
    } else {
        prev_Slow?.next = slow?.next
    }
    
    printNode(head)
}

func removeDuplicateElementsFromSortedLL(_ array: [Int]) {
    //1->1->3
    //output = 1->3
    var head: Node<Int>? = createSingleLL(array)
    guard head != nil else {
        print("nothing to remove")
        return
    }
    var prev_cur = head, cur = head?.next
    while cur != nil {
        if cur!.d! == prev_cur!.d! {
            prev_cur?.next = cur?.next
        }else {
            prev_cur = cur
        }
        cur = cur?.next
    }
    printNode(head)
}

func reverseLL<T: Equatable>(_ array: [T]) -> Node<T>? {
    //1->2->3
    //output = 3->2->1
    var head: Node<T>? = createSingleLL(array)
    guard head != nil || head?.next != nil else {
        printNode(head)
        return head
    }
    print("before reverse")
    printNode(head)
    var cur: Node<T>? = head, prev: Node<T>? = nil
    
    while cur != nil {
        var next = cur?.next
        head  = cur
        head?.next = prev
        prev = cur
        cur = next
    }
    print("after reverse")
    printNode(head)
    return head
}

func reverseLL<T: Equatable>(_ node: Node<T>?) -> Node<T>? {
    //1->2->3
    //output = 3->2->1
    guard node != nil else { return node }
    var cur: Node<T>? = node, head: Node<T>? = node, prev: Node<T>? = nil
    
    while cur != nil {
        var next = cur?.next
        head = cur
        head?.next = prev
        prev = cur
        cur = next
    }
    return head
}

func reverseLLBetweenTwoPoints<T: Equatable>(_ array: [T], l: Int, r: Int) {
    //a->b->c->d->e->f->g->h, left = 4, right = 7
    //out put = a->b->c->g->f->e->d->h
    //reverse ll betweeen two points
    var head: Node<T>? = createSingleLL(array)
    guard head != nil else {
        return printNode(head)
    }
    
    var leftNode: Node<T>? = head, leftBeforeNode: Node<T>? = nil, c = 1
    
    while c < l {
        c += 1
        leftBeforeNode = leftNode
        leftNode = leftNode?.next
    }
    
    let (rightNode, rightNodeAfter) = reverse(list: leftNode, count: r-l+1)

    if leftBeforeNode != nil {
        leftBeforeNode?.next = rightNode
    }else {
        head = rightNode
    }

    leftNode?.next = rightNodeAfter
    
    printNode(head)
    
    func reverse(list: Node<T>?, count: Int) -> (headNode: Node<T>?, rightNode: Node<T>?) {
        var cur: Node<T>? = list, head: Node<T>? = list, prev: Node<T>? = nil, count = count
        while count > 0 {
            count -= 1
            var next = cur?.next
            head = cur
            head?.next = prev
            prev = cur
            cur = next
        }
        return (headNode: head, rightNode: cur)
    }
}


func reverseLLInGroupOfSize<T: Equatable>(_ array: [T], size: Int) {
    //input:- (["a", "b", "c", "d", "e", "f", "g", "h"], size: 3)
    //output "c"->"b"->"a"->"f"->"e"->"d"->"g"->"h"->
    var head: Node<T>? = createSingleLL(array)
    guard head != nil else {
        return printNode(head)
    }
    
    let length = getLegthOfLL(head)
    
    var beforeLeftNode: Node<T>? = nil, leftNode: Node<T>? = head
    
    for i in 0..<length/size {
        let (rightNode, rightAfterNode) = reverseLL(leftNode, size: size)
        if i == 0 {
            head = rightNode
        }else {
            beforeLeftNode?.next = rightNode
        }
        leftNode?.next = rightAfterNode
        beforeLeftNode = leftNode
        leftNode = rightAfterNode
    }
    printNode(head)
    
    func reverseLL(_ node: Node<T>?, size: Int) -> (head: Node<T>?, next: Node<T>?) {
        guard node != nil else {
            return (nil, nil)
        }
        var size = size, cur = node, prev: Node<T>? = nil, head = node
        while size > 0 {
            size -= 1
            let next = cur?.next
            head = cur
            head?.next = prev
            prev = cur
            cur = next
        }
        printNode(head)
        return (head: head, next: cur)
    }
}

func add1ToLL(_ array: [Int], num: Int) {
   //input 1->2->3, num = 1
    //output = 1->2->4
    var head: Node<Int>? = createSingleLL(array)
    guard head != nil else { return }
    head = reverseLL()
    printNode(head)
    var carry = num, cur = head
    
    while cur != nil {
        cur!.d! += carry
        if cur!.d! >= 10 {
            carry = cur!.d! / 10
            cur!.d! %= 10
        }
        cur = cur?.next
    }

    printNode(reverseLL())
    func reverseLL() -> Node<Int>? {
        var cur: Node<Int>? = head, prev: Node<Int>? = nil
        while cur != nil {
            let next = cur?.next
            head = cur
            head?.next = prev
            prev = cur
            cur = next
        }
        return head
    }
}

func substractLL(_ array: [Int], num: Int) {
    //input 1->2->3, num = 1
     //output = 1->2->2
    
    //reverse linked list and the keep barrow
    // first substract barrow with value. If the value is less than the number get barrow again
    //cur!.d! -= barrow
    //if cur!.d! < num { barrow += 1;   cur!.d! = cur!.d!+10-num }
    //else cur!.d! -= num
    var head: Node<Int>? = createSingleLL(array)
    guard head != nil else { return }
    
    head = reverse()
    
    var barrow = 0, cur: Node<Int>? = head, num = num
    
    while cur != nil {
        cur!.d! -= barrow
        let digit = num%10
        num /= 10
        barrow = 0
        if cur!.d! < digit {
            cur!.d! = (cur!.d!+10)-digit
            barrow += 1
        }else {
            cur!.d! -= digit
        }
        cur = cur?.next
    }
    
    printNode(reverse())

    func reverse() -> Node<Int>? {
        var cur: Node<Int>? = head, prev: Node<Int>? = nil
        
        while cur != nil {
            let next = cur?.next
            head = cur
            head?.next = prev
            prev = cur
            cur = next
        }
        return head
    }
}

func findLoopInLL() {
    //1->2->3->4->5 again 5 pointing to 3
    // output :- loop present
    // if slow pointer and fast pointer in same place the loop present
    // start slow and fast with head
    // while fast and fast next is not nil move slow to next and fast to fat?.next?.next
    //inside while loop check slow == fast to check the loop
    var head: Node<Int>? = Node(1)
    head?.next = Node(2)
    head?.next?.next = Node(3)
    head?.next?.next?.next = Node(4)
    head?.next?.next?.next?.next = Node(5)
    head?.next?.next?.next?.next?.next = head?.next?.next
    
    
    guard head != nil, head?.next != nil else { return  print("loop not found") }
    
    var slow: Node<Int>? = head, fast: Node<Int>? = head
    
    while fast != nil && fast?.next != nil && slow != fast {
        slow = slow?.next
        fast = fast?.next?.next
    }
    
    if slow == fast {
        print("loop found")
    }else {
        print("loop not found")
    }
}


func removeLoopInLL() {
    // first check loop then remove loop
    var head: Node<Int>? = Node(1)
    head?.next = Node(2)
    head?.next?.next = Node(3)
    head?.next?.next?.next = Node(4)
    head?.next?.next?.next?.next = Node(5)
   head?.next?.next?.next?.next?.next = head?.next?.next
    guard head != nil else { return }
    
    var slow: Node<Int>? = head, fast: Node<Int>? = head
    checkloop()
    removeLoop()
    
    func checkloop() {
        while fast != nil && fast?.next != nil {
            slow = slow?.next
            fast = fast?.next?.next
            if slow == fast {
                break
            }
        }
        
        if slow == fast {
            print("loop found")
        }else {
            print("loop not found")
        }
    }
    
    // If we want to remove loop we need to know the node where the loop start so first detect loop present or not
    // if loop found fast and slow pointer will be in same place
    // then start cur from head and slow pointer from the same place where slow and fast met
    // if cur.next != slow.next then move both cur and slow to next node
    // else that is the place where loop start so remove slow.next = nil
    func removeLoop() {
        // to remove loop
        var cur: Node<Int>? = head
        
        while cur?.next != slow?.next {
            cur = cur?.next
            slow = slow?.next
        }
        
        if cur?.next == slow?.next {
            print("removed pointer \(cur?.next?.d!)")
            slow?.next = nil
        }
    }
    
    printNode(head)
}

func checkPalindromeOfLL<T: Equatable>(_ array: [T]) {
    // get middle element of the LL
    // keep the previous of middle element
    //If previous of middle is nil  then not a pallindrome
    // reverse the middle element i.e slow pointer
    // attach the reversed linked list to slow_prev
    //change slow = slow_prev.next, cur = head
    //start comparing slow == cur if all the element matches then pallindrome else not
    var head: Node<T>? = createSingleLL(array)
    guard head != nil else { return }
    
    var slow: Node<T>? = head, fast: Node<T>? = head, slow_prev: Node<T>? = nil
    
    while fast != nil || fast?.next != nil {
        slow_prev = slow
        slow = slow?.next
        fast = fast?.next?.next
    }
    
    if slow_prev == nil {
        print("it's not Palindrome")
        return
    }
    
    slow_prev?.next = reverseNode(slow)
    
    slow = slow_prev?.next
    var cur: Node<T>? = head
    
    while slow != nil && cur != nil {
        if slow!.d! != cur!.d! {
            print(" not pallindrome")
            return
        }
        slow = slow?.next
        cur = cur?.next
    }
    
    print("pallindrome")
    
    func reverseNode(_ node: Node<T>?) -> Node<T>? {
        var head: Node<T>? = node
        guard node != nil else { return node }
        
        var cur: Node<T>? = node, prev: Node<T>? = nil
        
        while cur != nil {
            let next = cur?.next
            head = cur
            head?.next = prev
            prev = cur
            cur = next
        }
        return head
    }
}


func findNthNodeFromEnd<T: Equatable>(_ array: [T], n: Int) {
    // get length of ll
    // if n is more than ll length then no data
    // else reverse the ll
    //cur = head and n = n-1, start while with cur = cur?.next
    // decrese nth node until zero to get the node
    var head: Node<T>? = createSingleLL(array)
    guard head != nil, n > 0 else { return }
    let length = getLegthOfLL(head)
    guard n <= length else { return }
    head = reverse()
    
    var n = n-1, cur: Node<T>? = head
    while n > 0 {
        n -= 1
        cur = cur?.next
    }
    
    print(cur!.d!)
    
    func reverse() -> Node<T>? {
        var cur: Node<T>? = head, prev: Node<T>? = nil
        while cur != nil {
            let next = cur?.next
            head = cur
            head?.next = prev
            prev = cur
            cur = next
        }
        return head
    }
}

func removeLastOccurenceOfItem<T: Equatable>(_ array: [T], k: Int) {
    // to remove last node of occurence
    //check length of ll if length is less than k then nothing to do
    // else reverse the ll
    // if k == 1 move head to head.next bcz we need to remove first element. reverse the list to get the final ll
    //else cur = head, k = k-1
    //loop until k > 0 or cur != nil, keep cur_pre reference
    // change the cur_prev?.next = cur?.next
    
    //input 1->2->3->4 k = 1
    //output: 1->2->3
    
    
    //input 1->2->3->4 k = 2
    //output: 1->2->4
    
    var head: Node<T>? = createSingleLL(array)
    guard head != nil, k > 0 else { return }
    let length = getLegthOfLL(head)
    guard k <= length  else { return }
    
    reverse()
    
    if k == 1 {
        head = head?.next
    } else {
        var n = k-1, cur: Node<T>? = head, cur_prev: Node<T>? = nil
        while n > 0 && cur != nil {
            cur_prev = cur
            cur = cur?.next
            n -= 1
        }
        
        cur_prev?.next = cur?.next
    }
    
    reverse()
    printNode(head)
    
    func reverse() {
        var cur: Node<T>? = head, pre: Node<T>? = nil
        while cur != nil {
            let next = cur?.next
            head = cur
            head?.next = pre
            pre = cur
            cur = next
        }
    }
}

func deleteMNodeAfterNNode<T: Equatable>(_ array: [T], m: Int, n: Int) {
    // keep Mnode then delete N node and again keep m node and delete n node
    
    /*
     Input:
     M = 3, N = 2
     Linked List: 1->2->3->4->5->6->7->8->9->10
     Output:
     Linked List: 1->2->3->6->7->8
     
     
     Input:
     M = 1, N = 1
     Linked List: 1->2->3->4->5->6->7->8->9->10
     Output:
     Linked List: 1->3->5->7->9
     
     
     Input:
     M = 2, N = 2
     Linked List: 1->2->3->4->5->6->7->8
     Output:
     Linked List: 1->2->5->6
     */
    
    // if m == 0 then ll need to delete completely
    // else get mth nodes
    
    var head: Node<T>? = createSingleLL(array)
    guard head != nil  else { return print("Nothing to delete") }
    var mthNode = head
    
    if m == 0 {
        head = nil
    }
    
    while mthNode != nil {
        mthNode = getMthNode(mthNode, m: m)
        mthNode?.next = deleteNNode(mthNode?.next, n: n)
        mthNode = mthNode?.next
    }
   
    
    printNode(head)
    func getMthNode(_ node: Node<T>?, m: Int) -> Node<T>? {
        var m = m-1, cur: Node<T>? = node
        while m > 0 && cur != nil {
            m -= 1
            cur = cur?.next
        }
        return cur
    }
    
    func deleteNNode(_ node: Node<T>?, n: Int ) -> Node<T>? {
        guard node != nil else { return node }
        var n = n-1, cur: Node<T>? = node
        while n > 0 && cur != nil {
            n -= 1
            cur = cur?.next
        }
        return cur?.next
    }
}

func deleteLL<T: Equatable>(_ array: [T], num: T) {
    // keep the refernce of the previous node of the node which you want to delete
    // set previous_node.next = previous_node.next.next
    //considering no value is repeated
    var head: Node<T>? = createSingleLL(array)
    
    guard head != nil else { return }
    var cur: Node<T>? = head, prev: Node<T>? = nil
    
    while cur != nil && cur!.d! == num {
        prev = cur
        cur = cur?.next
    }
    
    if prev == nil {
        head = head?.next
    } else {
        prev?.next = prev?.next?.next
    }
    
    printNode(head)
}

func searchAnElement<T: Equatable>(_ array: [T], num: T) {
    // linear search by comparing node data with search to check it's exist or not
    var head: Node<T>? = createSingleLL(array)
    
    guard head != nil else { return }
    var cur: Node<T>? = head
    
    while cur != nil {
        if cur!.d! == num {
            print("item found")
            return
        }
        cur = cur?.next
    }
    
    print("not found")
}

func insertToLL<T: Equatable>(_ array: [T], num: T, pos: Int) {
    //if position is 1 insert at head else look for position by having cur = head and pos = pos-1, keep cur-prev for previous node.
    //once we reach at the position. add new node and link to prev_cur
    var head: Node<T>? = createSingleLL(array)
    guard head != nil && pos > 1 else {
        let next = head
        head = Node(num)
        head?.next = next
        printNode(head)
        return
    }
    
    var cur: Node<T>? = head, cur_prev: Node<T>? = nil, pos = pos-1
    while cur != nil && pos > 0 {
        cur_prev = cur
        pos -= 1
        cur = cur?.next
    }
    let new = Node(num)
    cur_prev?.next = new
    new.next = cur
    printNode(head)
}

func deleteLLAtGivePosition<T: Equatable>(_ array: [T], pos: Int) {
    //keep prev node and cur node
    // go on to the list untill reach the position link the previous of current node to prev.next.next node
    var head: Node<T>? = createSingleLL(array)
    guard head != nil else { return print("nothing to delete ") }
    let length = getLegthOfLL(head)
    guard pos < length else { return print("nothing to delete ") }
    
    if pos == 0 {
        head = head?.next
    }else {
        var cur: Node<T>? = head, prev: Node<T>? = nil, pos = pos-1
        
        while pos >= 0 {
            prev = cur
            pos -= 1
            cur = cur?.next
        }
        prev?.next = cur?.next
    }
    printNode(head)
}

func findLegthOfLoopInLL() {
    // check the loop is there or not
    // if loop is detected both slow and fast pointer in same position.
    // point current to head
    //move both slow pointer from where slow and fast meets to next and current to next untill cur == slow
    //where cur == slow that is the loop start point
    // calculate count with slow pointer moving using while loop untill slow again meets the cur.
    var head: Node<Int>? = Node(1)
    head?.next = Node(2)
    head?.next?.next = Node(3)
    head?.next?.next?.next = Node(4)
    head?.next?.next?.next?.next = Node(5)
    head?.next?.next?.next?.next?.next = head?.next?.next
    
    var slow: Node<Int>? = head, fast: Node<Int>? = head
    
    findLoopExist()
    
    if slow == fast {
        print("loopExist")
        let start = findLoopStartNode(slow)
        print("found loop start node \(slow!.d!)")
        findLegth(start)
    }
    
    func findLegth(_ start: Node<Int>?) {
        var count = 1, next = start?.next
        while start != slow {
            next = next?.next
            count += 1
        }
        
        print("length of loop", count)
    }
    
    func findLoopStartNode(_ meetNode: Node<Int>?) -> Node<Int>? {
        var cur: Node<Int>? = head, meetNode = meetNode
        
        while meetNode != cur {
            meetNode = slow?.next
            cur = cur?.next
        }
        return cur
    }
    
    func findLoopExist() {
        while fast != nil && fast?.next != nil {
            fast = fast?.next?.next
            slow = slow?.next
            if slow == fast {
                return
            }
        }
    }
}

func removeNodeWithoutKnowingHead<T: Equatable>(_ node: Node<T>) {
    // change the value of node with the next node value to delete the node
    var cur: Node<T>? = node
    while cur != nil {
        cur?.d = cur?.next?.d
        cur = cur?.next
    }
}

func addTwoLinkedList(_ array1: [Int], array2: [Int]) {
    // take two list
    // reverse two list
    // add list with every digit untill both values are null
    //then reverse the resultant list
    //value = (nodevalue+carry)
    // carry = (node Value)/10
    // nodeValue = (NodeVALUE)%10
    var head1: Node<Int>? = createSingleLL(array1)
    var head2: Node<Int>? = createSingleLL(array2)
    
    guard head1 != nil else { return printNode(head2) }
    guard head2 != nil else { return printNode(head2) }
    
    head1 = reverse(head1)
    head2 = reverse(head2)
    
    var cur1: Node<Int>? = head1, cur2: Node<Int>? = head2, carry = 0, prev_cur1: Node<Int>? = nil
    
    while cur1 != nil && cur2 != nil {
        let value = cur2!.d!+carry+cur1!.d!
        prev_cur1 = cur1
        cur1!.d! = value%10
        carry = value/10
        cur1 = cur1?.next
        cur2 = cur2?.next
    }
    while cur1 != nil {
        let value = cur1!.d!+carry
        print(value)
        cur1!.d! = value%10
        carry = value/10
        prev_cur1 = cur1
        cur1 = cur1?.next
    }

    while cur2 != nil {
        let value = cur2!.d!+carry
        cur2!.d! = value%10
        carry = value/10
        prev_cur1?.next = cur2
        prev_cur1 = cur2
        cur2 = cur2?.next
    }
    
    if carry > 0 {
        prev_cur1?.next = Node(carry)
    }

    func reverse(_ node: Node<Int>?) -> Node<Int>? {
        var head: Node<Int>? = node, cur: Node<Int>? = head, prev: Node<Int>? = nil
        
        while cur != nil {
            let next = cur?.next
            head = cur
            head?.next = prev
            prev = cur
            cur = next
        }
        return head
    }
    
   printNode(reverse(head1))
}

func mergeTwoListAlernatively<T: Equatable>(_ array: [T], array2: [T])  {
    let head1: Node<T>? = createSingleLL(array)
    let head2: Node<T>? = createSingleLL(array2)
    
    guard head1 != nil else { return printNode(head2) }
    guard head2 != nil else { return printNode(head1) }
    
    var cur1: Node<T>? = head1, cur2: Node<T>? = head2
   
    while cur1 != nil && cur2 != nil {
        let cur1_next = cur1?.next
        let cur2_next = cur2?.next
        cur1?.next = cur2
        cur2?.next = cur1_next
        
        cur1 = cur1_next
        cur2 = cur2_next
    }
    
    printNode(head1)
}

func swapTwoNodeWithoutSwappingData(_ array: [Int], x: Int, y: Int) {
    /*
     the problem has the following cases to be handled:

     x and y may or may not be adjacent.
     Either x or y may be a head node.
     Either x or y may be the last node.
     x and / or y may not be present in the linked list.
     */
  /*
input: 10->15->12->13->20->14,  x = 10, y = 20
Output: 20->15->12->13->10->14
   */
    
    // first search two pointer value and keep reference of exact value node and previous node of the value
    var head: Node<Int>? = createSingleLL(array)
    guard head != nil && head?.next != nil else { return }
    
    let (px, prevX) = searchPoint(head!, value: x)
    let (py, prevY) = searchPoint(head!, value: y)
    
    if px == nil || py == nil {
        print("nothing to swap")
        return
    }
    
    
    swap()
    printNode(head)
    func swap() {
        let temp = py?.next
        py?.next = px?.next
        px?.next = temp
        
        // in case x is head then we need to change py to head
        if prevX == nil {
            head = py
            prevY?.next = px
        }
        
        // in case y is head then we need to change py to head
        if prevY == nil {
            head = px
            prevX?.next = py
        }
        
        //in case x and y are in between or in tail position
        
        if prevX != nil && prevY != nil {
            prevX?.next = py
            prevY?.next = px
        }
    }
    
    func searchPoint(_ node: Node<Int>, value: Int) -> (Node<Int>?, Node<Int>?) {
        var cur: Node<Int>? = node, prev: Node<Int>? = nil
        
        while cur != nil && cur!.d! != value {
            prev = cur
            cur = cur?.next
        }
        return (cur, prev)
    }
}

func swapNodePairWiseWithoutLink(_ array: [Int]) {
    var head: Node<Int>? = createSingleLL(array)
    guard head != nil && head?.next != nil else { return }
    
    /*
     Input : 1->2->3->4->5->6->NULL
     Output : 2->1->4->3->6->5->NULL

     Input : 1->2->3->4->5->NULL
     Output : 2->1->4->3->5->NULL

     Input : 1->NULL
     Output : 1->NULL
     */
    
    var cur: Node<Int>? = head
    
    while cur != nil && cur?.next != nil {
        let temp = cur!.d!
        cur!.d = cur!.next!.d
        cur!.next!.d = temp
        
        cur = cur?.next?.next
    }
    printNode(head)
}

func swapNodesInPairWithLink(_ array: [Int]) {
    var head: Node<Int>? = createSingleLL(array)
    guard head != nil && head?.next != nil else { return }
    
    /*
     Input : 1->2->3->4->5->6->NULL
     Output : 2->1->4->3->6->5->NULL

     Input : 1->2->3->4->5->NULL
     Output : 2->1->4->3->5->NULL

     Input : 1->NULL
     Output : 1->NULL
     */
    
    
    // create a dummy node to keep the head reference
    let dummy = Node(-1)
    dummy.next = head
    
    // create 3 pointer
    // pointer a, b which needs to swap, 1 for pointing first node
    
    var poin1: Node<Int>? = dummy
    while poin1?.next != nil && poin1?.next?.next != nil {
        var swap1 = poin1?.next, swap2 = poin1?.next?.next
        swap1?.next = swap2?.next
        swap2?.next = swap1
        
        //prepare for next iteration
        poin1?.next = swap2
        poin1 = swap1
    }
    
    printNode(dummy.next)
}

func mergeTwoSortedList(_ node1: Node<Int>?, node2: Node<Int>?) {
    var cur1: Node<Int>? = node1, cur2: Node<Int>? = node2
    
    guard cur1 != nil else { return printNode(cur2) }
    guard cur2 != nil else { return printNode(cur1) }
    
    var result = Node(-1), resultCur: Node<Int>? = result
    
    while cur1 != nil && cur2 != nil {
        if cur1!.d! < cur2!.d! {
            resultCur?.next = cur1
            resultCur = resultCur?.next
            cur1 = cur1?.next
        }else {
            resultCur?.next = cur2
            resultCur = resultCur?.next
            cur2 = cur2?.next
        }
    }
    
    while cur1 != nil {
        resultCur?.next = cur1
        resultCur = resultCur?.next
        cur1 = cur1?.next
    }
    
    while cur2 != nil {
        resultCur?.next = cur2
        resultCur = resultCur?.next
        cur2 = cur2?.next
    }
    
    printNode(result.next)
}

func sortLLWithActualValue(_ array: [Int]) {
    //sort the linked list using merge sort. Time complexity of this solution is O(n Log n).
    
    //An efficient solution can work in O(n) time. An important observation is, all negative elements are present in reverse order. So we traverse the list, whenever we find an element that is out of order, we move it to the front of the linked list.
    
    // this list is already sorted with absolute values we need to sort with actual value. so only negative values which is higher than positive will be in middle.
    // -ve value we need to sort so moving all negative to front will sort the list
    
    /*
     Input :  1 -> -10
     output: -10 -> 1

     Input : 1 -> -2 -> -3 -> 4 -> -5
     output: -5 -> -3 -> -2 -> 1 -> 4

     Input : -5 -> -10
     Output: -10 -> -5

     Input : 5 -> 10
     output: 5 -> 10
     */
    var head: Node<Int>? = createSingleLL(array)
    
    // take prev node as head and cur as head.next
    //loop untill cur != nil
    // if cur value is less the prev then need to swap else change prev to cur
    // move cur to cur?.next
    
    /*
     for swapping cur with prev
     1. move prev next pointer to curent next
     2. curr?.next point to head
     3. head to cur
     */
    guard head != nil && head?.next != nil else { return printNode(head) }
    var prev: Node<Int>? = head, cur: Node<Int>? = head?.next
    
    while cur != nil {
        if cur!.d! < prev!.d! {
            // Detach curr from linked list
            prev?.next = cur?.next
            // Move current node to beginning
            cur?.next = head
            head = cur
            // Update current
            cur = prev
        }else {
            prev = cur
        }
        cur = cur?.next
    }
    printNode(head)
}

func moveLastElementToFirst(_ array: [Int]) {
    /*
     Input: 1->2->3->4->5
     Output: 5->1->2->3->4

     Input: 3->8->1->5->7->12
     Output: 12->3->8->1->5->7
     */
    var head: Node<Int>? = createSingleLL(array)
    guard head != nil && head?.next != nil else { return printNode(head) }
    var prev: Node<Int>? = nil, cur: Node<Int>? = head
    
    while cur?.next != nil {
        prev = cur
        cur = cur?.next
    }
    
    cur?.next = head
    head = cur
    prev?.next = nil
    
    printNode(head)
}

func moveFirstElementTolast(_ array: [Int]) {
    /*
     Input: 1 -> 2 -> 3 -> 4 -> 5 -> NULL
     Output: 2 -> 3 -> 4 -> 5 -> 1 -> NULl
     */
    var head: Node<Int>? = createSingleLL(array)
    guard head != nil && head?.next != nil else { return printNode(head) }
    var cur: Node<Int>? = head
    
    while cur?.next != nil {
        cur = cur?.next
    }
    let t = head?.next
    cur?.next = head
    head?.next = nil
    head = t
    printNode(head)
}

func checkLLisListed(_ array: [Int]) {
    var head: Node<Int>? = createSingleLL(array)
    guard head != nil && head?.next != nil else { return printNode(head) }
    
    var cur: Node<Int>? = head
    
    while cur?.next != nil {
        if cur!.d! > cur!.next!.d! {
            print("not sorted")
            return
        }
        cur = cur?.next
    }
    print("sorted")
}

func interSectionOfTwoLL() {
    /*
     Brute Force:-
     A simple approach is to, traverse every node of the linked list B, for each node of A and simply check if any of the nodes is present in the list B.
     */
    
    /*
     better than previous but takes 0(n)
    we can simply keep track of a hashmap that stores each node of B. Now simply traverse list A, and check if any of the nodes is already present in the hashmap
    */
    
    /*
     it can be done in O(1) using a two-pointer approach
     if the two linked lists contain a common point, the length from that intersection point to the tail will be the same.
     */
    
    /*
     1. keep two pointer 1 is point head1
     2. second pointer point to head2
     3. if two pointer address is not equal iterate
     4. if first pointer == nil assign first pointer = head of second list i.e cur1 = cur1 == nil ? head2 : cur1.next else move to next
     5. if second pointer == nil assign secon pointer = head of first list i.e cur2 = cur2 == nil ? head1 : cur2.next else move to next
     6. return cur1 to get the intersection node.
     */
    
    /*
     Determine if two linked lists intersect and find the intersection point.
     Find the point where two linked lists merge (if they merge).
     Find the length of the intersection of two linked lists.
     */
    
    var head1: Node<Int>? = Node(4)
    head1?.next = Node(1)
    
    var head2: Node<Int>? = Node(5)
    head2?.next = Node(0)
    head2?.next?.next = Node(1)
    
    //common node
    let node1 = Node(8)
    let node2 = Node(4)
    let node3 = Node(5)
    
    head1?.next?.next = node1
    head1?.next?.next?.next = node2
    head1?.next?.next?.next?.next = node3
    
    head2?.next?.next?.next = node1
    head2?.next?.next?.next?.next = node2
    head2?.next?.next?.next?.next?.next = node3
    
    
    guard head1 != nil else { return print("no intersection") }
    guard head2 != nil else {return print("no intersection")  }
    
    var cur1: Node<Int>? = head1, cur2: Node<Int>? = head2
    
    // === for checking the address of the nodes
    while cur1 !== cur2 {
        cur1 = cur1 == nil ? head2 : cur1?.next
        cur2 = cur2 == nil ? head1 : cur2?.next
    }
    printNode(cur1)
    
    var count = 0
    while cur1 != nil {
        count += 1
        cur1 = cur1?.next
    }
    
    print(count)
}



func moveOccurenceToLast(_ array: [Int], k: Int) {
    var head: Node<Int>? = createSingleLL(array)
    guard head != nil else { return }
    
    
    /*
     It helps to count the number of occurences and remove the occurence node
     at last create new node and attach to the tail node
     
     creating new node in worst case it take time complexity of o(n) and space complexity o(n)
     */
    
    /*
     var count = 0, cur: Node<Int>? = head, prev: Node<Int>? = nil
     
     while cur != nil {
         if k == cur!.d! {
             count += 1
             if prev == nil {
                 head = cur?.next
             }else {
                 prev?.next = cur?.next
                 cur = prev
             }
         }else {
             prev = cur
         }
         cur = cur?.next
     }
     
     while count > 0 {
         count -= 1
         prev?.next = Node(k)
         prev = prev?.next
     }
     */
    
    /*
     better approach is to interchange the node
     */
    
    var tail: Node<Int>? = head, cur: Node<Int>? = head, prev: Node<Int>?  = nil, tailPtr: Node<Int>?
    
    while tail?.next != nil {
        tail = tail?.next
    }
    
    tailPtr = tail

    while cur !== tail {
        if cur!.d! == k {
            if prev == nil {
                tailPtr?.next = head
                head = cur?.next
                tailPtr = tailPtr?.next
            }else {
                prev?.next = cur?.next
                tailPtr?.next = cur
                tailPtr = tailPtr?.next
                cur = prev
            }
            
        }else {
            prev = cur
        }
        cur = cur?.next
        tailPtr?.next = nil
    }
    
   
    
    printNode(head)
}


func deleteAlterNativeNodeOfLL(_ array: [Int]) {
    var head: Node<Int>? = createSingleLL(array)
    guard head != nil, head?.next != nil else { return }
    
    var cur: Node<Int>? = head
    
    while cur != nil {
        cur?.next = cur?.next?.next
        cur = cur?.next
    }
    
    printNode(head)
}
 
func rearrangeLLWithAllOddAndEvenPositionedNumberTogether(_ array: [Int]) {
    var head: Node<Int>? = createSingleLL(array)
    
    /*
     Rearrange a linked list in such a way that all odd position nodes are together and all even positions node are together,
     
     Input:   1->2->3->4
     Output:  1->3->2->4
     */
    
    
    /*
     The important thing in this question is to make sure that all below cases are handled

     Empty linked list
     A linked list with only one node
     A linked list with only two nodes
     A linked list with an odd number of nodes
     A linked list with an even number of nodes
     */
    
    /*
     Approcat
     Have 4 Pointers
     1. odd, evenStart, evenPointer, cur.
     2. point odd?.next = cur?.next
     3. point even?.next = cur?.next?.next
     4. move cur = cur?.next?.next
     5. untill cur != nil
     6. finall combine odd with even list
     7. Mark the Even List End as NULL.
     */
    guard head != nil else { return }
    
    var oddPtr: Node<Int>? = head, evenPtr: Node<Int>? = head?.next, cur: Node<Int>? = head?.next?.next, evenPtr_start = evenPtr
    
    while cur != nil {
        oddPtr?.next = cur
        evenPtr?.next = cur?.next
        cur = cur?.next?.next
        oddPtr = oddPtr?.next
        evenPtr = evenPtr?.next
    }
    
    oddPtr?.next = evenPtr_start
    evenPtr?.next = nil
    
    printNode(head)
}

func checkForPrimeNumber(_ n: Int) -> Bool {
    /*
     var i = 2
     while i < n/2 {
     if n %i == 0 {
     return false
     }
     i += 1
     }
     return true
     Time Complexity: O(n1/2), as we need to iterate only till n1/2
     
     */
    
    /*
     time complexity for bellow code is Time complexity: O(sqrt(N)), Where n is the number.
     */
    if (n <= 1) { return false }
    if n <= 3 { return true }
    if n%2 == 0 || n%3 == 0 { return false }
    
    // Check from 5 to square root of n
    // Iterate i by (i+6)
     var i = 5
    while i*i < n {
        if (n%i == 0) || (n%(i+2) == 0) {
            return false
        }
        i += 6
    }
    return true
    
    /*
     we can check prime number with o(n) time complexity using factorial method
     prime number p completely divides ((p – 1)! + 1), i.e. ((p – 1)! + 1) % p == 0.
     If the remainder is zero, then N is a prime number.
     If the remainder is not zero, then N is not prime.
     
     func getFact(_ n: Int) -> Int {
         var fact = 1
         for i in 2...n {
             fact *= i
         }
         return fact
     }

     func checkPrime(_ n: Int) {
         let fact = getFact(n-1)
         
         if (fact+1)%n == 0 {
             print("prime")
         }else {
             print("not prime")
         }
     }
     checkPrime(25)
     */
}


func segregateEvenAndOddLL(_ array: [Int]) {
    var head: Node<Int>? = createSingleLL(array)
    
    /*
     Input: 17->15->8->12->10->5->4->1->7->6->NULL
     Output: 8->12->10->4->6->17->15->5->1->7->NULL

     Input: 8->12->10->5->4->1->6->NULL
     Output: 8->12->10->4->6->5->1->NULL
     */

    guard head != nil else { return printNode(head) }
    
    var oddPointerStart: Node<Int>?, evenPointer: Node<Int>?, evenStart: Node<Int>?, oddPointerEnd: Node<Int>?
   
    var cur: Node<Int>? = head
    while cur != nil {
        if cur!.d!%2 == 0 {
            if evenStart == nil {
                evenStart = cur
                evenPointer = cur
            }else {
                evenPointer?.next = cur
                evenPointer = evenPointer?.next
            }
        }else {
            if oddPointerStart == nil {
                oddPointerStart = cur
                oddPointerEnd = cur
            }else {
                oddPointerEnd?.next = cur
                oddPointerEnd = oddPointerEnd?.next
            }
        }
        cur = cur?.next
    }
    
    evenPointer?.next = oddPointerStart
    oddPointerEnd?.next = nil
    
    printNode(evenStart)
}


func createPolynomialNode() {
    class PolyNode {
        var co_efficient: Int
        var power: Int
        var next: PolyNode?
        
        init(co_efficient: Int, power: Int ) {
            self.co_efficient = co_efficient
            self.power = power
        }
    }
    
    var head1: PolyNode? = PolyNode(co_efficient: 5, power: 6)
    head1?.next = PolyNode(co_efficient: 6, power: 4)
    head1?.next?.next = PolyNode(co_efficient: 2, power: 3)
    
    
    var head2: PolyNode? = PolyNode(co_efficient: 8, power: 6)
    head2?.next = PolyNode(co_efficient: 3, power: 2)
    head2?.next?.next = PolyNode(co_efficient: 4, power: 1)
    head2?.next?.next?.next = PolyNode(co_efficient: 5, power: 0)
    
    
    var result: PolyNode? = PolyNode(co_efficient: -1, power: -1), result_ptr: PolyNode? = result
    var cur1 = head1, cur2 = head2
    
    while cur1 != nil && cur2 != nil {
        if cur1!.power == cur2!.power {
            cur1!.co_efficient += cur2!.co_efficient
            result_ptr?.next = cur1
            result_ptr = result_ptr?.next
            cur1 = cur1?.next
            cur2 = cur2?.next
        }else if cur1!.power > cur2!.power {
            result_ptr?.next = cur1
            result_ptr = result_ptr?.next
            cur1 = cur1?.next
        }else {
            result_ptr?.next = cur2
            result_ptr = result_ptr?.next
            cur2 = cur2?.next
        }
    }
    
    while cur1 != nil {
        result_ptr?.next = cur1
        result_ptr = result_ptr?.next
        cur1 = cur1?.next
    }
    
    while cur2 != nil {
        result_ptr?.next = cur2
        result_ptr = result_ptr?.next
        cur2 = cur2?.next
    }
    
    var cur = result?.next, str = ""
    while cur != nil {
        str = str.appending("\(cur!.co_efficient)x^\(cur!.power)->")
        cur = cur?.next
    }
    
    print(str)
}

func liknedListPartitionedAroundValueKeepingOrder(_ array: [Int], x: Int) {
    var head: Node? = createSingleLL(array)
    
    guard head != nil else { return }
    
    var greter_ptrStart: Node<Int>?, less_PtrStart: Node<Int>?, equal_ptrStart: Node<Int>?, cur: Node<Int>? = head, greter_ptrEnd: Node<Int>?, less_PtrEnd: Node<Int>?, equal_ptrEnd: Node<Int>?
    
    while cur != nil {
        if cur!.d! < x {
            if less_PtrStart == nil {
                less_PtrStart = cur
                less_PtrEnd = cur
            }else {
                less_PtrEnd?.next = cur
                less_PtrEnd = less_PtrEnd?.next
            }
        }else if cur!.d! > x {
            if greter_ptrStart == nil {
                greter_ptrStart = cur
                greter_ptrEnd = cur
            }else {
                greter_ptrEnd?.next = cur
                greter_ptrEnd = greter_ptrEnd?.next
            }
        }else {
            if equal_ptrStart == nil {
                equal_ptrStart = cur
                equal_ptrEnd = cur
            }else {
                equal_ptrEnd?.next = cur
                equal_ptrEnd = equal_ptrEnd?.next
            }
        }

        cur = cur?.next
    }
    
    less_PtrEnd?.next = nil
    greter_ptrEnd?.next = equal_ptrStart
    equal_ptrEnd?.next = less_PtrStart
    
    printNode(greter_ptrStart)
}

func splitLinkedListInParts(_ array: [Int], k: Int) {
    /*
     Input:- 1->2->3->4->5 , k = 3
     output
                1->2->
                3->4->
                5->
     */
    /*
     problem statement
     1.Divide the linked list into k sub list
     2. legth of each sublist difference should not be more than 1
     */
    
    /*
     solution:-
     1. divide the length of list by k -> gives the number of sublist which we need to create
     2. each sublist legth is equal to = ((legth_of_list)/k)
     3. If the list length is more than the k then we need to take the module of list and distribute 1 item for each sublist to keep the difference is not more than one
     4. if k is more than the list legth then assign the empty nodes....
     */
     
    
    var head: Node<Int>? = createSingleLL(array)
    
    guard head != nil else { return }
    var array: [Node<Int>?] = Array(repeating: nil, count: k)
    
    var cur: Node<Int>? = head, prev: Node<Int>? = nil
    let length = getLegthOfLL(head)
    var subListLength = length/k
    var distributionleft = length%k
    
    var i = 0
    while cur != nil && i < k {
        array[i] = cur
        let value = subListLength+(distributionleft > 0 ? 1 : 0)
        for _ in 0..<(value) {
            prev = cur
            cur = cur?.next
        }
        distributionleft -= 1
        prev?.next = nil
        i += 1
    }
    
    for i in array {
        printNode(i)
    }
}

func findLengthOfLongestPalindromeInLL<T: Equatable>(_ array: [T]) {
    /*
     Input  : List = 2->3->7->3->2->12->24
     Output : 5
     The longest palindrome list is 2->3->7->3->2
     */
    var head: Node<T>? = createSingleLL(array)
    
    guard head != nil else { return print("length", 0) }
    guard head?.next != nil else { return print("length", 1) }
    
    
    getMaxPalindrome()
    
    // Take first element and compare first with the next element in the list to check the palindrom
    func getMaxPalindrome() {
        var result = 0, cur: Node<T>? = head, prev: Node<T>? = nil
        
        while cur != nil {
            let next = cur?.next
            cur?.next = prev
            
            // check for odd length palindrome
            // by finding longest common list elements
            // beginning from prev and from next (We
            // exclude curr)
            // we multiply by 2 bcz number of elements in palindrome will be count*2 odd is common for both so +1
            result = max(result, 2*compareCommonNode(prev, next)+1)
            
            // check for even length palindrome
            // by finding longest common list elements
            // beginning from curr and from next
            result = max(result, 2*compareCommonNode(cur, next))
            
            prev = cur
            cur = next
        }
        
        print("length is \(result)")
    }
    
    /*
     take two node and count = 0
     loop untill both nodes have common dvalue and increase the count
     */
    
    func compareCommonNode(_ node1: Node<T>?, _ node2: Node<T>?) -> Int {
        var cur1: Node<T>? = node1, cur2: Node<T>? = node2, count = 0
        while cur1 != nil && cur2 != nil {
            if cur1!.d! == cur2!.d! {
                count += 1
            }else {
               break
            }
            cur1 = cur1?.next
            cur2 = cur2?.next
        }
        return count
    }
}


func getDecimalNumberFromBinary(_ array: [Int]) {
    var head: Node< Int>? = createSingleLL(array)
    guard head != nil else { return }
    var cur: Node<Int>? = head, res = 0
    while cur != nil {
        res = (res<<1)+cur!.d!
        cur = cur?.next
    }
    print(res)
}

class NodeDown {
    var d: Int
    var next: NodeDown?
    var down: NodeDown?
    
    init(_ d: Int) {
        self.d = d
    }
}

func flattenLinkedList() {
    /*
                    5 -> 10 -> 19 -> 28
                   |        |         |        |
                  V       V       V       V
                  7      20      22     35
                   |                 |        |
                  V               V       V
                  8               50     40
                  |                          |
                 V                        V
                30                       45
     */
    var head: NodeDown? = NodeDown(5)
    head?.down = NodeDown(7)
    head?.down?.down = NodeDown(8)
    head?.down?.down?.down = NodeDown(30)
    
    head?.next = NodeDown(10)
    head?.next?.down = NodeDown(20)
    

    head?.next?.next = NodeDown(19)
    head?.next?.next?.down = NodeDown(22)
    head?.next?.next?.down?.down = NodeDown(50)
    
    
    head?.next?.next?.next = NodeDown(28)
    head?.next?.next?.next?.down = NodeDown(35)
    head?.next?.next?.next?.down?.down = NodeDown(40)
    head?.next?.next?.next?.down?.down?.down = NodeDown(45)
    
    
    var resl = head

    while head?.next != nil {
        print("-----")
        head = head?.next
        resl = mergeTwoLL(resl, node2: head)
       
    }
    
    var cur = resl
    while cur != nil {
        print(" \(cur?.d)")
        cur = cur?.down
    }
    
    func mergeTwoLL(_ node1: NodeDown?, node2: NodeDown?) -> NodeDown? {
        var res: NodeDown? = NodeDown(-1), reslCur: NodeDown? = res, cur1: NodeDown? = node1, cur2: NodeDown? = node2
        
        while cur1 != nil && cur2 != nil {
            if cur1!.d < cur2!.d {
                reslCur?.down = cur1
                reslCur = reslCur?.down
                cur1 = cur1?.down
            }else {
                reslCur?.down = cur2
                reslCur = reslCur?.down
                cur2 = cur2?.down
            }
        }
        
        while cur1 != nil {
            reslCur?.down = cur1
            reslCur = reslCur?.down
            cur1 = cur1?.down
        }
        
        while cur2 != nil {
            reslCur?.down = cur2
            reslCur = reslCur?.down
            cur2 = cur2?.down
        }
        
        return res?.down
    }
}

func createALinkedListFromMatrix(_ array: [[Int]]) {
    let numRows = array.count
    let numCols = array[0].count
    
    var dummy: NodeDown? = NodeDown(array[0][0]), cur: NodeDown? = dummy
    
    for row in 0..<numRows {
        for col in 0..<numCols {
            let value = array[row][col]
            let newNode = NodeDown(value)
            
            cur?.next = newNode
            cur = newNode
        }
    }
    
    var currentNode = dummy?.next
    while currentNode != nil {
        print(currentNode!.d)
        currentNode = currentNode!.next
    }
}

func createLLFromMatrixWithEveryNodeConnected(_ array: [[Int]]) {
    var dummyNode: NodeDown? = NodeDown(array[0][0]), cur: NodeDown? = dummyNode
    let numRows = array.count
    var arrayll: [NodeDown?] = Array(repeating: nil, count: numRows), right: NodeDown? = nil
    
    // Create a linked list for each row.
    for i in 0..<numRows {
        arrayll[i] = nil
        for j in 0..<array[i].count {
            let new = NodeDown(array[i][j])
            if arrayll[i] == nil {
                arrayll[i] = new
            } else {
                right?.next = new
            }
            right = new
        }
    }
    
    print(arrayll)
    // Connect each node to the node below it.
    for i in 0..<numRows-1 {
        var first = arrayll[i]
        var sec = arrayll[i+1]
        
        while first != nil && sec != nil {
            first?.down = sec
            first = first?.next
            sec = sec?.next
        }
    }
    
    //print nodes
    // arrayll[0] is the header node----
    cur = arrayll[0]
    var nextPtr: NodeDown?
    
    while cur != nil {
        nextPtr = cur
        while nextPtr != nil {
            print(nextPtr?.d)
            nextPtr = nextPtr?.next
        }
        cur = cur?.down
    }
}

func findNextGreaterElementInLL(_ array: [Int]) {
    // to find next greater element reverse the ll and start storing the greatest element
    // if stack is empty store the vale and return next greater element as nil
    // else if the top element of stack is greater than the cur element return the top element and store current to stack
    // if top element is less than curr elemet then remove stack untill stack is empty or top element is greater than the cur
    //if stack empty return as nil and store cur.
    //repeat this untill all node is visited
    var head: Node<Int>? = createSingleLL(array)
    guard head != nil else { return }
    
    //consider the array as stack now
    var array = [Int]()
  
    head = reverseLL(head)
    var cur: Node<Int>? = head
    
    while cur != nil {
        if array.isEmpty {
            print("\(cur?.d) -> next greater element is nil")
            array.append(cur!.d!)
        }else if let t = array.last,
                 t > cur!.d! {
            print("\(cur?.d) -> next greater element is \(t)")
            array.append(cur!.d!)
        }else {
            while !array.isEmpty {
                if let t = array.last,
                   cur!.d! >= t  {
                    array.removeLast()
                }else {
                   break
                }
            }
            print("\(cur?.d) -> next greater element is \(array.last ?? nil)")
            array.append(cur!.d!)
        }
        cur = cur?.next
    }

    func reverseLL(_ node: Node<Int>?) -> Node<Int>? {
        var head: Node<Int>? = node, cur: Node<Int>? = head, prev: Node<Int>?
        while cur != nil {
            let next = cur?.next
            head = cur
            head?.next = prev
            prev = cur
            cur = next
        }
        return head
    }
}

func mergeBetweenZero(_ array: [Int]) {
    /*
     Input: head = [0,3,1,0,4,5,2,0]
     Output: [4,11]
     Explanation:
     The above figure represents the given linked list. The modified list contains
     - The sum of the nodes marked in green: 3 + 1 = 4.
     - The sum of the nodes marked in red: 4 + 5 + 2 = 11.
     
     merge all the values between the zero
     */
    var head: Node<Int>? = createSingleLL(array), cur: Node<Int>? = head, count = 0, zeroStart: Node<Int>?, prev_zeroStart: Node<Int>? = nil
    
    
    while cur != nil {
        if cur!.d! == 0 {
            prev_zeroStart = zeroStart
            if zeroStart == nil {
                zeroStart = cur
            }else {
                zeroStart?.d = count
                zeroStart?.next = cur
                zeroStart = cur
            }
            count = 0
        }else if zeroStart != nil {
            count = count+cur!.d!
        }
        cur = cur?.next
    }
    
    if zeroStart != nil {
        prev_zeroStart?.next = nil
    }
    
    printNode(head)
}

func removeNeighbourPointsFromLLLineSegmentRemoveMiddleLine() {
    class NodeXY {
        var x: Int
        var y: Int
        var next: NodeXY?
        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }
    }
    let head: NodeXY? = NodeXY(4,3)
    head?.next = NodeXY(7,3)
    head?.next?.next = NodeXY(10,3)
    head?.next?.next?.next = NodeXY(10,4)
    head?.next?.next?.next?.next = NodeXY(10,7)
    head?.next?.next?.next?.next?.next = NodeXY(10,8)
    
    var cur: NodeXY? = head?.next, prev:NodeXY? = head, start: NodeXY? = nil
    
    while cur != nil {
        if cur!.x == prev!.x {
            start = prev
            prev = cur
            cur = cur?.next
            while cur != nil && cur!.x == prev!.x {
                start?.next = cur
                prev = cur
                cur = cur?.next
            }
        }else if cur!.y == prev!.y {
            start = prev
            prev = cur
            cur = cur?.next
            while cur != nil && cur!.y == prev!.y {
                start?.next = cur
                prev = cur
                cur = cur?.next
            }
        }else {
            prev = cur
            cur = cur?.next
        }
    }
    
    cur = head
    var str = ""
    while cur != nil {
        str = str.appending("(\(cur?.x) \(cur?.y)->")
        cur = cur?.next
    }
    print(str)
}

func deleteContinuousNodeOfSumK(_ array: [Int], k: Int) {
    //use dummy node when ever required to keep the head reference
    var head: Node<Int>? = createSingleLL(array)
    var cur: Node<Int>? = head, count = 0, prev: Node<Int>? = nil
    
    while cur != nil {
        count += cur!.d!
        if count == k {
            if prev == nil {
                head = cur?.next
            }else {
                prev?.next = cur?.next
            }
            count = 0
        }else if count < k {
            
        }else {
            prev = cur
            count = 0
        }
        
        cur = cur?.next
    }
   printNode(head)
}

func findTheTwinOfSumOfLL(_ array: [Int]) {
    /*
     In a linked list of size n, where n is even, the ith node (0-indexed) of the linked list is known as the twin of the (n-1-i)th node, if 0 <= i <= (n / 2) - 1.

     For example, if n = 4, then node 0 is the twin of node 3, and node 1 is the twin of node 2. These are the only nodes with twins for n = 4.
     
     
     Input: head = [5,4,2,1]
     Output: 6
     Explanation:
     Nodes 0 and 1 are the twins of nodes 3 and 2, respectively. All have twin sum = 6.
     There are no other nodes with twins in the linked list.
     Thus, the maximum twin sum of the linked list is 6.
     */
    
    var head: Node<Int>? = createSingleLL(array)
    var slow: Node<Int>? = head, fast: Node<Int>? = head
    
    while fast != nil && fast?.next != nil {
        slow = slow?.next
        fast = fast?.next?.next
    }
    
    slow = reverseLL(slow)
    var sum = 0, cur: Node<Int>? = head
    
    while slow !== nil {
        sum = max(sum, slow!.d!+cur!.d!)
        print("twin \(slow!.d!) \(cur!.d!)")
        slow = slow?.next
        cur = cur?.next
    }
    print(sum)
}

func cloneLLwithRandom() {
    class RandomNode {
        var d: Int?
        var next: RandomNode?
        var rand: RandomNode?
        init(_ d: Int) {
            self.d = d
        }
    }
    
    var head: RandomNode?
    var cur: RandomNode? = head
    
    while cur != nil {
        let t = RandomNode(cur!.d!)
        t.next = cur?.next
        cur?.next = t
        cur = t.next
    }
    
    cur = head
    while cur != nil {
        if cur?.rand != nil {
            cur?.next?.rand =  cur?.rand?.next
        }
        cur = cur?.next?.next
    }
}


func binarySerachInLL(_ array: [Int], mid: Int) {
    var node = createSingleLL(array)
    guard node != nil else { return }
    searchMid(node, mid: mid)
    
    func searchMid(_ node: Node<Int>?, mid: Int) {
        guard node != nil else { return print("value not found") }
        
        var slow: Node<Int>? = node, fast: Node<Int>? = node, slow_prev: Node<Int>? = nil
        
        while fast != nil && fast?.next != nil {
            slow_prev = slow
            slow = slow?.next
            fast = fast?.next?.next
        }
        
        if slow != nil && slow!.d! == mid {
            print("value found")
        }else if slow != nil && mid < slow!.d! {
            searchMid(slow_prev, mid: mid)
        }else {
            searchMid(slow?.next, mid: mid)
        }
    }
}

func findSubListInList(_ array1: [Int], array2: [Int]) {
    // considering list2 is small and list2 is big
    var head: Node<Int>? = createSingleLL(array1), head2: Node<Int>? = createSingleLL(array2)

    var ptr1: Node<Int>? = head
    var ptr2: Node<Int>? = head2
    
    while ptr1 != nil {
        ptr2 = head2
        while ptr2 != nil {
            if ptr1 == nil { break }
            if ptr1!.d! == ptr2!.d {
                ptr2 = ptr2?.next
                ptr1 = ptr1?.next
            }else {
                break
            }
        }
        if ptr2 == nil {
            return print("found")
        }
        ptr1 = ptr1?.next
    }
    return print("not found")
}


func mergeSortOfLL(_ array: [Int]) {
    var node: Node<Int>? = createSingleLL(array)
    guard node != nil else { return }
    
    let t = mergeSort(node)
    printNode(t)
    
    func mergeSort(_ node: Node<Int>?) -> Node<Int>? {
        var aNode: Node<Int>?, bNode: Node<Int>?
        guard node != nil, node?.next != nil else { return node }
        (aNode, bNode) = divideNode(node)
        aNode = mergeSort(aNode)
        bNode = mergeSort(bNode)
        return merge(aNode, bNode: bNode)
        
        func divideNode(_ node: Node<Int>?) -> (Node<Int>?, Node<Int>?) {
            var slow: Node<Int>? = node, fast: Node<Int>? = node, slow_prev: Node<Int>?
            
            while fast != nil && fast?.next != nil {
                slow_prev = slow
                slow = slow?.next
                fast = fast?.next
            }
            slow_prev?.next = nil
            return (node, slow)
        }
    }
    
    func merge(_ aNode: Node<Int>?, bNode: Node<Int>?) -> Node<Int>? {
        var result: Node<Int>? = Node(-1), cur1: Node<Int>? = aNode, cur2: Node<Int>? = bNode, resultCur: Node<Int>? = result
        
        while cur1 != nil && cur2 != nil {
            if cur1!.d! < cur2!.d! {
                resultCur?.next = cur1
                resultCur = resultCur?.next
                cur1 = cur1?.next
            }else {
                resultCur?.next = cur2
                resultCur = resultCur?.next
                cur2 = cur2?.next
            }
        }
        
        while cur1 != nil {
            resultCur?.next = cur1
            resultCur = resultCur?.next
            cur1 = cur1?.next
        }
        
        while cur2 != nil {
            resultCur?.next = cur2
            resultCur = resultCur?.next
            cur2 = cur2?.next
        }
        
        return result?.next
    }
}

mergeSortOfLL([1,0, -1])
