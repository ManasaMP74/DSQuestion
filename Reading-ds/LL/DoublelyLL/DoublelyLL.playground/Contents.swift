import UIKit

class Node<T: Equatable>: Equatable {
    static func == (lhs: Node<T>, rhs: Node<T>) -> Bool {
        return lhs.d == rhs.d
    }
    
    var d: T
    var next: Node<T>?
    var prev: Node<T>?
    
    init(_ d: T) {
        self.d = d
    }
}


func printDoublyLL<T: Equatable>(_ node: Node<T>?) {
    var str = "⇋⇋⇋", cur: Node<T>? = node
    
    while cur != nil {
        print("prev = \(cur?.prev?.d) cur = \(cur?.d)  next = \(cur?.next?.d)")
        str = str.appending("\(cur?.d)⇋⇋⇋")
        cur = cur?.next
    }
    
    print(str)
}

func createDoublyLL<T: Equatable>(_ array: [T]) -> Node<T>? {
    var head: Node<T>? = nil, cur: Node<T>? = nil
    for i in array {
        let new = Node(i)
        if head == nil {
            head = new
            cur = head
        }else {
            cur?.next = new
            new.prev = cur
            cur = cur?.next
        }
    }
    return head
}

func reverseDDLL<T: Equatable>(_ array: [T]) {
    var head: Node<T>? = createDoublyLL(array)
    guard head != nil && head?.next != nil else { return printDoublyLL(head) }
    
    var cur: Node<T>? = head, prev: Node<T>? = nil
    
    while cur != nil {
        let temp = cur?.next
        head = cur
        head?.next = prev
        head?.prev = temp
        prev = cur
        cur = temp
    }
    
    printDoublyLL(head)
}

func getLength<T: Equatable>(_ node: Node<T>?) -> Int {
    var count = 0, cur: Node<T>? = node
    while cur != nil {
        count += 1
        cur = cur?.next
    }
    return count
}

func reverseDoublyLLInSize<T: Equatable>(_ array: [T], k: Int) {
    var head: Node<T>? = createDoublyLL(array)
    guard head != nil && head?.next != nil else { return }
    var leftPrevious: Node<T>? = nil, leftNode: Node<T>? = head
    let length = getLength(head)
    for i in 0..<length/k {
        let (right, rightAfter) = reverseDDl(leftNode, k: k)
        if i == 0 {
            head = right
            printDoublyLL(right)
        }else {
            leftPrevious?.next = right
        }
        leftNode?.next = rightAfter
        leftPrevious = leftNode
        leftNode = rightAfter
    }
    
    //printDoublyLL(head)
    
    func reverseDDl(_ node: Node<T>?, k: Int) -> (Node<T>?, Node<T>?) {
        var head: Node<T>? = node
        guard head != nil else { return (nil, nil) }
        var cur: Node<T>? = head, k = k
        
        while cur != nil && k > 0 {
            let temp = cur?.next
            head = cur
            head?.next = cur?.prev
            head?.prev = temp
            k -= 1
            cur = temp
        }
        return (head, cur)
    }
}

func createLRUorLFU() {
    var head: Node<Int>? = nil, tail: Node<Int>? = nil
    var dict: [Int: Node<Int>?] = [:], max_capacity = 5, capacity = 0
    /*
     LRU used with doubly linked list for frequent requested unit and use dictionary to store the nodes in the list
     */
    
    func get(_ value: Int) {
        if t = dict[value] {
            print("t present")
            t.prev = t.next
            t.next?.prev = t.prev
            t.next = head
            t.prev = nil
            head = t
        }else {
            print("not there")
        }
    }
    
    func put(_ value: Int) {
        let newNode = Node(value)
        if head == nil {
            head = newNode
            cur_ptr = head
            tail = head
            capacity += 1
        }else if t = dict[value] {
            if t === head {
                
            }else {
                t.prev = t.next
                t.next?.prev = t.prev
                t.next = head
                head = t
            }
        }else if capacity < max_capacity {
            newNode?.next = head
            head = newNode
            capacity += 1
        }else {
            let prev = tail.prev
            prev?.next = nil
            tail = prev
        }
        dict[value] = newNode
    }
}

