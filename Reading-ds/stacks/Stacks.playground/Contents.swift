import UIKit

class Stack<T: Any> {
    var array = [T]()
    
    
    func push(_ item: T) {
        array.append(item)
    }
    
    func pop() -> T? {
        return array.removeLast()
    }
    
    func isEmpty() -> Bool {
        return array.isEmpty
    }
    
    func top() -> T? {
        return array.last
    }
    
    func size() -> Int {
        return array.count
    }
}


func returnMinimumElementWithConstantTime( ) {
    /*
     this can be achived using two stack one stack to hold the values another stack to check the value if next pushing value is less than the current value then pop all values from stack a to stack b and push the value then again push other data from stack b to stack a
     
     
     This can be achivied without using auxiliary stack as follows
     */
    let stack = Stack<Int>()
    var min = Int.min
    
    func push(_ val: Int) {
        if stack.isEmpty() {
            stack.push(val)
            min = val
        }else if  val > min {
            stack.push(val)
        }else {
            stack.push(2*val-min)
            min = val
        }
    }
    
    
    func pop() {
        if stack.isEmpty() { return }
        if stack.top()! < min {
            min = 2*min - stack.top()!
        }
        stack.pop()
    }
    
    func getMin() -> Int {
        return min
    }
}

func checkIfExpressionIsBalanced(_ str: String) {
    let stack = Stack<Character>()
    
    for i in str {
        if i == "(" || i == "{" || i == "[" {
            stack.push(i)
        }else {
            if stack.isEmpty() {
                print("not balanced")
                return
            }
            let t = stack.top()!
            if (t == "(" && i != ")") || (t == "{" && i != "}") || (t == "[" && i != "]") {
                print("not balanced")
                return
            }
            stack.pop()
        }
    }
    if stack.isEmpty() {
        print("balanced")
    }else {
        print("un balanced")
    }
   
}

func checkDuplicateParanthesis(_ str: String) {
    // for duplicate atleast it should have 4 characters
    /*
     Input:  ((x+y))+z
     Output: true
     Explanation: Duplicate () found in subexpression ((x+y))
     
     Input:  (x+y)
     Output: false
     Explanation: No duplicate () is found
     
     assuming only one paranthesis type for now and it is balnced parathesis
     */
    let stack = Stack<Character>()
    
    if str.count <= 3 {
        print("no duplicate")
        return
    }
    
    for i in str {
        if i != ")" {
            stack.push(i)
        }else {
            if stack.top() == "(" {
                print("duplicate")
                return
            }
            
            while stack.top() != "(" {
                stack.pop()
            }
            stack.pop()
        }
    }
    
    print("no duplicate")
}

func evaluatePostFix(_ str: String) {
    /*
     input: evaluatePostFix("82/")
     output : 4
     */
    let stack = Stack<Character>()
    
    for i in str {
        if i != "+" && i != "-" && i != "/" && i != "*" {
            stack.push(i)
        }else {
            let t = stack.pop()!
            let t1 = stack.pop()!
            switch i {
            case "+":
                let res = Int("\(t)")!+Int("\(t1)")!
                stack.push(Character("\(res)"))
            case "-":
                let res = Int("\(t1)")!-Int("\(t)")!
                stack.push(Character("\(res)"))
            case "*":
                let res = Int("\(t)")!*Int("\(t1)")!
                stack.push(Character("\(res)"))
            case "/":
                let res = Int("\(t1)")!/Int("\(t)")!
                stack.push(Character("\(res)"))
            default: break
            }
        }
    }
    print(stack.top()!)
}


func decodeGiveSequence(_ str: String) {
    /*
     Given a sequence of length <= 8 consisting of I and D, where I denotes the increasing sequence and D denotes the decreasing sequence, decode the sequence to construct a minimum number without repeated digits.
     
     IIDDIDID  ——>  125437698
     IDIDII    ——>  1325467
     DDDD      ——>  54321
     IIII      ——>  12345
     */
    
    var res = ""
    
    let stack = Stack<Int>()
    for i in 0...str.count {
        stack.push(i+1)
        if i == str.count || str[str.index(str.startIndex, offsetBy: i)] == "I" {
            while !stack.isEmpty() {
                res.append("\(stack.top()!)")
                _ = stack.pop()
            }
        }
    }
    print(res)
}


func mergingOverLappingIntervals(_ intervals: [(Int, Int)]) {
    /*
     Given a set of intervals, print all non-overlapping intervals after merging the overlapping intervals.
     
     Input:  {1, 5}, {2, 3}, {4, 6}, {7, 8}, {8, 10}, {12, 15}
      
     Output: Intervals after merging overlapping intervals are {1, 6}, {7, 10}, {12, 15}.
     
     
     approach:-
     
     - the idea is to sort the intervals in increasing order of their starting time.
     -then create an empty stack and for each interval,
     - If the stack is empty or the top interval in the stack does not overlap with the current interval, push it into the stack.
     - If the top interval of the stack overlaps with the current interval, merge both intervals by updating the end of the top interval at the ending of the current interval.
     
     assuming intervals are sorted with start
     */
    
    let stack = Stack<(Int, Int)>()
    
    for i in intervals {
        if stack.isEmpty() {
            stack.push(i)
        }else {
            let top = stack.top()!
            if i.0 <= top.1 {
                if i.1 > top.1 {
                    _ = stack.pop()
                    stack.push((top.0, i.1))
                }
            }else {
                stack.push(i)
            }
        }
    }
    
    while !stack.isEmpty() {
        print(stack.top()!)
        _ = stack.pop()
    }
}

func findNextGreaterElement(_ array: [Int]) {
    /*
     Input:  [2, 7, 3, 5, 4, 6, 8]
     Output: [7, 8, 5, 6, 6, 8, -1]
     */
    
    let stack = Stack<(Int, Int)>()
    var res = Array(repeating: -1, count: array.count)
    
    for (index, ele) in array.enumerated() {
        if stack.isEmpty() || stack.top()!.1 >= ele {
            stack.push((index,ele))
        }else {
            while !stack.isEmpty() && stack.top()!.1 < ele {
                let t = stack.pop()!
                res[t.0] = ele
            }
            stack.push((index,ele))
        }
    }
    
    print(res)
}

func findNextGreaterElementInCircular(_ array: [Int]) {
    /*
     Input:  [3, 5, 2, 4]
     Output: [5, -1, 4, 5]
      
     Input:  [7, 5, 3, 4]
     Output: [-1, 7, 4, 7]
     
     idea:
     Use same idea to get the next greater elemt in array. But check in the circular motion
     */
    
    // here we used tuple to get the index of that element to keep the next value in result array
    let stack = Stack<(Int, Int)>()
    var res = Array(repeating: -1, count: array.count)
    
    
    for i in 0...array.count {
        if i == array.count {
            var index = 0
            while index+1 != i {
                if array[index] > stack.top()!.1 {
                    res[stack.top()!.0] = array[index]
                    break
                }
                index += 1
            }
            
        }else {
            if stack.isEmpty() || stack.top()!.1 >= array[i] {
                stack.push((i, array[i]))
            }else {
                while !stack.isEmpty() && stack.top()!.1 < array[i] {
                    let t = stack.pop()!
                    res[t.0] = array[i]
                }
                stack.push((i, array[i]))
            }
        }
    }
    
    print(res)
}


func computeBuildingWithSunSetView(_ array: [Int]) {
    /*
     You are given with a series of buildings that have windows facing west. The buildings are in a straight line, and any building which is to the east of a building of equal or greater height cannot view the sunset. Design an algorithm that processes buildings in east-to-west order and returns the set of buildings which view the sunset. Each building is specified by its height.
     
     Input : arr[] = {7, 4, 8, 2, 9}
     Output: 3
     Explanation: As 7 is the first element, it can
     see the sunset.
     4 can't see the sunset as 7 is hiding it.
     8 can see.
     2 can't see the sunset.
     9 also can see the sunset.
     
     only max value so far can view the sun
     */
    var max = Int.min
    for i in array {
        if i > max {
            print("\(i) can view")
        }else {
            print("\(i) cann't view")
        }
        max = i
    }
}

func convertInfixToPostfix(_ infix: String) {
    
    /*
     Input:  A*B+C
     Output: AB*C+
     
     Input:  A*(B*C+D*E)+F
     Output: ABC*DE*+*F+
     
     
     Input:  (A+B)*C+(D-E)/F+G
     Output: AB+C*DE-F/+G+
     
     If the current token is an opening bracket, '(', push it into the stack.
     If the current token is a closing bracket, ')', pop tokens from the stack until the corresponding opening bracket ‘(‘ is removed. Append each operator at the end of the postfix expression.
     If the current token is an operand, append it at the end of the postfix expression.
     If the current token is an operator, push it on the top of the stack. Before doing that, first pop from the stack till we have a lower precedence operator on top, or the stack becomes empty. Append each operator at the end of the postfix expression.
     
     */
    
    func getPrece(_ i: Character) -> Int {
        if i == "*" || i == "/" {
            return 3
        }
        
        if i == "+" || i == "-" {
            return 4
        }
        
        if i == "&" {
            return 8
        }
        
        if i == "^" {
            return 9
        }
        
        if i == "|" {
            return 10
        }
        
        return Int.max
    }
    
    func checkIsOperand(_ i: Character) -> Bool {
        return (String(i).range(of: "^[0-9]*$", options: .regularExpression) != nil) || (String(i).range(of: "^[a-zA-Z]*$", options: .regularExpression) != nil)
    }
    
    var str = "", stack = Stack<Character>()
    
    getPostFix()
    
    func getPostFix() {
        for i in infix {
            if i == "(" {
                stack.push(i)
            }else if i == ")" {
                while !stack.isEmpty() && stack.top()! != "(" {
                    str.append(stack.pop()!)
                }
                stack.pop()
            }else if checkIsOperand(i) {
                str.append(i)
            }else {
                while !stack.isEmpty() && getPrece(i) >= getPrece(stack.top()!) {
                    str.append(stack.pop()!)
                }
                stack.push(i)
            }
        }
        
        while (!stack.isEmpty())
        {
            str.append(stack.pop()!)
        }
        print(str)
    }
}


func findPreviousSmaller(_ array: [Int]) {
    /*
     Input:  [2, 5, 3, 7, 8, 1, 9]
     Output: [-1, 2, 2, 3, 7, -1, 1]
      
      
     Input:  [5, 7, 4, 9, 8, 10]
     Output: [-1, 5, -1, 4, 4, 8]
     */
    
    let stack = Stack<Int>()
    var res = Array(repeating: -1, count: array.count)
    
    for (ind, ele) in array.enumerated() {
        if stack.isEmpty() {
            stack.push(ele)
        }else if ele > stack.top()! {
            res[ind] = stack.top()!
            stack.push(ele)
        }else {
            while !stack.isEmpty() && stack.top()! >= ele {
                _ = stack.pop()
            }
            if !stack.isEmpty() {
                res[ind] = stack.top()!
            }
            stack.push(ele)
        }
    }
    
    print(res)
}

func printAllbinarystringsThatFormedFromWildCard(_ str: String) {
    /*
     for wildcard pattern 1?11?00?1?, the possible combinations are: 1011000010
     1011000011
     1011000110
     1011000111
     1011100010
     1011100011
     1011100110
     1011100111
     1111000010
     1111000011
     1111000110
     1111000111
     1111100010
     1111100011
     1111100110
     1111100111
     
     this can be done using recursive method or stack
     */
    var str = str
    recursivePrint(&str, index: 0)
    
    func recursivePrint(_ str: inout String, index: Int) {
        if index == str.count {
            print(str)
            return
        }
        let startInd = str.index(str.startIndex, offsetBy: index)
        if str[startInd] == "?" {
            for i in 0..<2 {
                str.replaceSubrange(startInd...startInd, with: "\(i)")
                recursivePrint(&str, index: index+1)
                str.replaceSubrange(startInd...startInd, with: "?")
            }
        }else {
            recursivePrint(&str, index: index+1)
        }
    }
}

func maximumNestingDepthOfParentheses(_ str: String) {
    /*
     Input: s = "(1+(2*3)+((8)/4))+1"
     Output: 3
     Explanation: Digit 8 is inside of 3 nested parentheses in the string.
     
     Input: s = "(1)+((2))+(((3)))"
     Output: 3
     */
   
   var maxCount = 0
   var count = 0
    for i in str {
        if i == "(" {
            count += 1
        }else if i == ")" {
            maxCount = max(maxCount, count)
            count -= 1
        }
    }
    print(maxCount)
}


func removeOuterMostParanthesis(_ str: String) {
    /*
     Input: s = "(()())(())"
     Output: "()()()"
     Explanation:
     The input string is "(()())(())", with primitive decomposition "(()())" + "(())".
     After removing outer parentheses of each part, this is "()()" + "()" = "()()()".
     
     Input: s = "(()())(())(()(()))"
     Output: "()()()()(())"
     Explanation:
     The input string is "(()())(())(()(()))", with primitive decomposition "(()())" + "(())" + "(()(()))".
     After removing outer parentheses of each part, this is "()()" + "()" + "()(())" = "()()()()(())".
     
     Input: s = "()()"
     Output: ""
     Explanation:
     The input string is "()()", with primitive decomposition "()" + "()".
     After removing outer parentheses of each part, this is "" + "" = "".
     */
    
    var sb = "", stack = Stack<Character>()
    for i in str {
        if i == "(" {
            if stack.size() > 0 {
                sb.append(i)
            }
            stack.push(i)
        }else {
            stack.pop()
            if stack.size() > 0 {
                sb.append(i)
            }
        }
    }
    print(sb)
}


func findFinalPriceWithSpecialDiscountInShop(_ array: [Int]) {
    /*
     Input: prices = [8,4,6,2,3]
     Output: [4,2,4,2,3]
     Explanation:
     For item 0 with price[0]=8 you will receive a discount equivalent to prices[1]=4, therefore, the final price you will pay is 8 - 4 = 4.
     For item 1 with price[1]=4 you will receive a discount equivalent to prices[3]=2, therefore, the final price you will pay is 4 - 2 = 2.
     For item 2 with price[2]=6 you will receive a discount equivalent to prices[3]=2, therefore, the final price you will pay is 6 - 2 = 4.
     For items 3 and 4 you will not receive any discount at all.
     */
    
    let stack = Stack<(Int, Int)>()
    var res = Array(repeating: 0, count: array.count)
    
    for (i,j) in array.enumerated() {
        if stack.isEmpty() {
            stack.push((i,j))
        }else if stack.top()!.1 < j {
            stack.push((i,j))
        }else {
            while !stack.isEmpty() && stack.top()!.1 > j {
                let t = stack.pop()!
                res[t.0] = t.1-j
            }
            stack.push((i,j))
        }
    }
    
    while !stack.isEmpty() {
        let t = stack.pop()!
        res[t.0] = t.1
    }
    
    print(res)
}

func baseBallGame(_ array: [String]) {
    /*
     Input: ops = ["5","2","C","D","+"]
     Output: 30
     Explanation:
     "5" - Add 5 to the record, record is now [5].
     "2" - Add 2 to the record, record is now [5, 2].
     "C" - Invalidate and remove the previous score, record is now [5].
     "D" - Add 2 * 5 = 10 to the record, record is now [5, 10].
     "+" - Add 5 + 10 = 15 to the record, record is now [5, 10, 15].
     The total sum is 5 + 10 + 15 = 30.

     Input: ops = ["5","-2","4","C","D","9","+","+"]
     Output: 27
     Explanation:
     "5" - Add 5 to the record, record is now [5].
     "-2" - Add -2 to the record, record is now [5, -2].
     "4" - Add 4 to the record, record is now [5, -2, 4].
     "C" - Invalidate and remove the previous score, record is now [5, -2].
     "D" - Add 2 * -2 = -4 to the record, record is now [5, -2, -4].
     "9" - Add 9 to the record, record is now [5, -2, -4, 9].
     "+" - Add -4 + 9 = 5 to the record, record is now [5, -2, -4, 9, 5].
     "+" - Add 9 + 5 = 14 to the record, record is now [5, -2, -4, 9, 5, 14].
     The total sum is 5 + -2 + -4 + 9 + 5 + 14 = 27.
     */
    
    var stack = Stack<Int>()
    
    for i in array {
        if i == "C" {
            stack.pop()
        }else if i == "D" {
            if !stack.isEmpty() {
                let t = Int(stack.top()!)
                stack.push(t*2)
            }
        }else if i == "+" {
            if stack.size() >= 2 {
                let t = Int(stack.pop()!)
                let t1 = Int(stack.top()!)
                let res = t+t1
                stack.push(t)
                stack.push(res)
            }
        }else {
            stack.push(Int(i)!)
        }
    }
    
    var sum = 0
    while !stack.isEmpty() {
        print(stack.top()!)
        sum += stack.pop()!
    }
    print(sum)
}

func crawlerLog(_ array: [String]) {
    /*
     
     "../" : Move to the parent folder of the current folder. (If you are already in the main folder, remain in the same folder).
     "./" : Remain in the same folder.
     "x/" : Move to the child folder named x (This folder is guaranteed to always exist)
     
     
     Input: logs = ["d1/","d2/","../","d21/","./"]
     Output: 2
     Explanation: Use this change folder operation "../" 2 times and go back to the main folder.
     
     Input: logs = ["d1/","d2/","./","d3/","../","d31/"]
     Output: 3
     
     Input: logs = ["d1/","../","../","../"]
     Output: 0
     */
    let stack = Stack<String>()
    
    for i in array {
        if i == "./" {
            
        }else if  i == "../" {
            if !stack.isEmpty() { stack.pop() }
        }else {
            stack.push(i)
        }
    }
    
    var count = 0
    while !stack.isEmpty() {
        count += 1
        stack.pop()
    }
    
    print(count)
}

func makeStringGreat(_ str: String) {
    /*
     Input: s = "leEeetcode"
     Output: "leetcode"
     Explanation: In the first step, either you choose i = 1 or i = 2, both will result "leEeetcode" to be reduced to "leetcode".
     
     Input: s = "abBAcC"
     Output: ""
     Explanation: We have many possible scenarios, and all lead to the same answer. For example:
     "abBAcC" --> "aAcC" --> "cC" --> ""
     "abBAcC" --> "abBA" --> "aA" --> ""
     
     Input: s = "s"
     Output: "s"
     
     s[i] is a lower-case letter and s[i + 1] is the same letter but in upper-case or vice-versa.
     
     To make the string good, you can choose two adjacent characters that make the string bad and remove them. You can keep doing this until the string becomes good.
     */
    let stack = Stack<Character>()
    for i in str {
        if !i.isUppercase {
            stack.push(i)
        }
        var cur: Character = i
        while !stack.isEmpty() && cur.isUppercase && stack.top()! == Character(cur.lowercased()) {
            stack.pop()
            if !stack.isEmpty() { cur = stack.top()! }
        }
    }
    
    var str = ""
    while !stack.isEmpty() {
        str.append(stack.pop()!)
    }
    
    print(String(str.reversed()))
}

func backSpaceStringCompare(_ str1: String, str2: String) {
    /*
     Input: s = "ab#c", t = "ad#c"
     Output: true
     Explanation: Both s and t become "ac".
     
     Input: s = "ab##", t = "c#d#"
     Output: true
     Explanation: Both s and t become "".
     
     Input: s = "a#c", t = "b"
     Output: false
     Explanation: s becomes "c" while t becomes "b".
     */
    let stack1 = Stack<Character>()
    let stack2 = Stack<Character>()
    
    for i in str1 {
        if i == "#" {
            stack1.pop()
        }else {
            stack1.push(i)
        }
    }
    
    for i in str2 {
        if i == "#" {
            stack2.pop()
        }else {
            stack2.push(i)
        }
    }
    
    var str = "", str1 = ""
     
    while !stack1.isEmpty() {
        str.append(stack1.pop()!)
    }
    
    while !stack2.isEmpty() {
        str1.append(stack2.pop()!)
    }
    
    print(str == str1)
}


func minimumAddToMakeParanthesesValid(_ str: String) {
    /*
     considering parenthese is of only (
     
     Input: s = "())"
     Output: 1
     
     Input: s = "((("
     Output: 3
     */
    var stack = Stack<Character>(), count = 0
    
    for i in str {
        if i == "(" {
            stack.push(i)
        }else if i == ")" && !stack.isEmpty() && stack.top()! == "(" {
            stack.pop()
        }else {
            count += 1
        }
    }
    
    while !stack.isEmpty() {
        count += 1
        stack.pop()
    }
    
    print(count)
}


func removingStarsFromString(_ str: String) {
    /*
     Input: s = "leet**cod*e"
     Output: "lecoe"
     Explanation: Performing the removals from left to right:
     - The closest character to the 1st star is 't' in "leet**cod*e". s becomes "lee*cod*e".
     - The closest character to the 2nd star is 'e' in "lee*cod*e". s becomes "lecod*e".
     - The closest character to the 3rd star is 'd' in "lecod*e". s becomes "lecoe".
     There are no more stars, so we return "lecoe".
     
     Input: s = "erase*****"
     Output: ""
     Explanation: The entire string is removed, so we return an empty string.
     */
    let stack = Stack<Character>()
    
    for i in str {
        if i != "*" {
            stack.push(i)
        }else if !stack.isEmpty() {
            stack.pop()
        }
    }
    
    var str = ""
    while !stack.isEmpty() {
        str.append(stack.pop()!)
    }
    print(String(str.reversed()))
}

func maximumNumberOfSwapsRequiredToMakeStringBalance(_ str: String) {
    /*
     Input: s = "][]["
     Output: 1
     Explanation: You can make the string balanced by swapping index 0 with index 3.
     The resulting string is "[[]]".
     
     Input: s = "]]][[["
     Output: 2
     Explanation: You can do the following to make the string balanced:
     - Swap index 0 with index 4. s = "[]][][".
     - Swap index 1 with index 5. s = "[[][]]".
     The resulting string is "[[][]]".

     Input: s = "[]"
     Output: 0
     Explanation: The string is already balanced.
     */
    
    let stack = Stack<Character>()
    var str = str
    var end = str.count-1, count = 0
    
    for (index,i) in str.enumerated() {
        if i == "[" {
            stack.push(i)
        }else if !stack.isEmpty() && stack.top()! == "[" {
            stack.pop()
        }else {
            count += 1
            let startIndex = str.index(str.startIndex, offsetBy: index)
            let endIndex = str.index(str.startIndex, offsetBy: end)
            str.replaceSubrange(startIndex...startIndex, with: "\(str[endIndex])")
            str.replaceSubrange(endIndex...endIndex, with: "\(i)")
            end = end-1
            stack.push(str[startIndex])
        }
    }
   
    print(count)
}

func dailyTemp(_ array: [Int]) {
    /*
     Input: temperatures = [73,74,75,71,69,72,76,73]
     Output: [1,1,4,2,1,1,0,0]
     
     Input: temperatures = [30,40,50,60]
     Output: [1,1,1,0]
     
     Input: temperatures = [30,60,90]
     Output: [1,1,0]
     */
    let stack = Stack<(Int, Int)>()
    var res = Array(repeating: 0, count: array.count)
    
    for (i,j) in array.enumerated() {
        if stack.isEmpty() {
            stack.push((i,j))
        }else if j > stack.top()!.1 {
            while !stack.isEmpty() && stack.top()!.1 < j {
                res[stack.top()!.0] = i-stack.top()!.0
                stack.pop()
            }
            stack.push((i,j))
        }else {
            stack.push((i,j))
        }
    }
    
    print(res)
}


func reverseSubStringBetweenTwoPairOfParanthesis(_ str: String) {
    /*
     Input: s = "(abcd)"
     Output: "dcba"
     
     Input: s = "(u(love)i)"
     Output: "iloveu"
     Explanation: The substring "love" is reversed first, then the whole string is reversed.
     
     Input: s = "(ed(et(oc))el)"
     Output: "leetcode"
     Explanation: First, we reverse the substring "oc", then "etco", and finally, the whole string.
     
     */
    
    let stack = Stack<String>()
    
    for i in str {
        if i != ")" {
            stack.push("\(i)")
        }else {
            var newStr = ""
            while !stack.isEmpty() && stack.top()! != "(" {
                newStr.append(stack.pop()!)
            }
            stack.pop()
            for j in newStr {
                stack.push("\(j)")
            }
        }
    }

    var str = ""
    while !stack.isEmpty() {
        str.append(stack.pop()!)
    }
    print(String(str.reversed()))
}

func minimumRemoveToMakeParthesisValid(_ str: String) {
    /*
     Input: s = "lee(t(c)o)de)"
     Output: "lee(t(c)o)de"
     Explanation: "lee(t(co)de)" , "lee(t(c)ode)" would also be accepted.
     
     Input: s = "a)b(c)d"
     Output: "ab(c)d"
     
     Input: s = "))(("
     Output: ""
     Explanation: An empty string is also valid.
     */
    
    let stack = Stack<String>()
    var newStr = ""
    
    for i in str {
        if stack.isEmpty() && i != "(" && i != ")" {
            newStr.append(i)
        }else {
            if i != ")" {
                stack.push("\(i)")
            }else if !stack.isEmpty() {
                var new = "\(i)"
                while !stack.isEmpty() && stack.top()! != "(" {
                    new.append(stack.pop()!)
                }
                new.append(stack.pop()!)
                if stack.isEmpty() {
                    newStr.append(String(new.reversed()))
                }else {
                    stack.push(new)
                }
                print(new, stack.isEmpty(), String(new.reversed()), newStr)
            }
        }
    }
    
    var cur = ""
    while !stack.isEmpty() {
        if stack.top()! == "(" || stack.top()! == ")" {
            stack.pop()
        }else {
            cur.append(stack.pop()!)
        }
    }
    
    print(newStr.appending(String(cur.reversed())))
}

minimumRemoveToMakeParthesisValid("lee(t(c)o)de)")
