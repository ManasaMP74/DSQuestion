import UIKit

class TrieNode {
    var children: [Character: TrieNode] = [:]
    var countEnd: Int = 0 // to keep the end with count
    var parentNode: TrieNode? = nil
    var countPrefix: Int = 0 // to keep the number of the letter have the prefix before this character
    var count: Int = 0 // to keep the number of times the word is appeared in string
    var isEnding: Bool = false
}

var root = TrieNode()

// O(length of the word)
func insertWord(_ word: String) {
   var cur = root
    for i in word {
        if let t = cur.children[i] {
            t.count += 1
            cur = t
        }else {
            let new = TrieNode()
            new.count = 1
            cur.children[i] = new
            cur = new
        }
    }
    // it helps to keep the count of how many times the string is repeated - frequency of word
    cur.isEnding = true
}

func search(_ word: String) -> Bool {
    var node = root
    for i in word {
        if let t = node.children[i] {
            node = t
        }else {
            return false
        }
    }
    return node.isEnding
}

func logestCommonPrefix(_ array: [String]) -> String {
    var node: TrieNode  = root
    for i in array {
        insertWord(i)
    }
    
    var str = ""
    while node.children.count == 1,
          let (char, child) = node.children.first,
          //this is used to check the element is commpon in all the string
          child.count == array.count {
        print(child.count, char)
        str.append(char)
        node = child
    }
    return str
}

func startsWith(_ prefix: String) -> Bool {
    var node = root
    for i in prefix {
        if let child = node.children[i] {
            node = child
        }else {
            return false
        }
    }
    return true
}

func wordBreakProblem(_ array: [String], str: String) {
    /*
     here it gives the array of words and string "A" need to find out A is segmented into space separated sequence of words
     
     this can be solved using check for the prefix first
     
     e.g: [a, ab, abc, de, cde] - for A = "abcde" first check for a the check for bcde. if it is there check for b then check for c else check for bc.
     */
    var node = root
    for i in array {
        insertWord(i)
    }
    
    var res = [String]()
    let t = wordBreakHelper(str, root: node)
    print(t, res)
    
    //let str = "manasa"
    //let startIndex = str.index(str.startIndex, offsetBy: 0)
    //let endIndex = str.index(str.startIndex, offsetBy: 2)
    //
    //print(String(str[startIndex..<endIndex])) // return ma bcz start from 0 and print until index 2
    
    func wordBreakHelper(_ str: String, root: TrieNode) -> Bool {
        if str.isEmpty {
            return true
        }
        
        for i in 1...str.count {
            var startIndex = str.index(str.startIndex, offsetBy: 0)
            var endIndex = str.index(str.startIndex, offsetBy: i)
            let searchText = String(str[startIndex..<endIndex])
            
            startIndex = str.index(str.startIndex, offsetBy: i)
            endIndex = str.index(str.startIndex, offsetBy: str.count)
            let nextSegmentText = String(str[startIndex..<endIndex])
            
            if search(root, word: searchText),
               wordBreakHelper(nextSegmentText, root: root) {
                    return true
                }
        }
        return false
    }
    
    func search(_ root: TrieNode, word: String) -> Bool {
        var cur = root
        for i in word {
            if let child = cur.children[i] {
                cur = child
            }else {
                return false
            }
        }
        return cur.isEnding
    }
}


func wordBreakWithInGrid(_ board: [[Character]], words: [String]) {
    /*
     Given an m x n board of characters and a list of strings words, return all words on the board.
     
     Input: board = [["o","a","a","n"],["e","t","a","e"],["i","h","k","r"],["i","f","l","v"]], words = ["oath","pea","eat","rain"]
     Output: ["eat","oath"]
     */
    var node = root
    for i in words {
        insertWord(i)
    }
    
    // check for outofBound in arry of board
    func isOutOfBound(_ board: [[Character]], i: Int, j: Int) -> Bool {
        if i < 0 || j < 0 || i >= board.count || j >= board[0].count { return true }
        return false
    }
    
    findWords(board, root: root)
    
    func findWords(_ board: [[Character]], root: TrieNode) {
        var result = Set<String>()
        var visited = Array(repeating: Array(repeating: false, count: board[0].count), count: board.count)
        
        for i in 0..<board.count {
            for j in 0..<board[i].count {
                findWordsDFS(board, currentNode: root, i: i, j: j, currentWord: "", result: &result, visited: &visited)
            }
        }
        
        print(result)
    }
    
    func findWordsDFS(_ board: [[Character]], currentNode: TrieNode, i: Int, j: Int, currentWord: String, result: inout Set<String>, visited: inout [[Bool]]) {
        if currentNode.isEnding {
            result.insert(currentWord)
        }
        
        if isOutOfBound(board, i: i, j: j) { return }
        
        let char = board[i][j]
        if let child = currentNode.children[char] {
            visited[i][j] = true
            findWordsDFS(board, currentNode: child, i: i, j: j+1, currentWord: "\(currentWord)\(char)", result: &result, visited: &visited)
            findWordsDFS(board, currentNode: child, i: i, j: j-1, currentWord: "\(currentWord)\(char)", result: &result, visited: &visited)
            findWordsDFS(board, currentNode: child, i: i+1, j: j, currentWord: "\(currentWord)\(char)", result: &result, visited: &visited)
            findWordsDFS(board, currentNode: child, i: i-1, j: j, currentWord: "\(currentWord)\(char)", result: &result, visited: &visited)
            visited[i][j] = false
        }
    }
}

func isPalindrome(_ string: String) -> Bool {
    var i = 0, j = string.count-1
    while i < j {
        if string[string.index(string.startIndex, offsetBy: i)] == string[string.index(string.startIndex, offsetBy: j)] {
            i += 1
            j -= 1
        }else {
            return false
        }
    }
    return true
}


func findIndexPairInString(_ str: String, words: [String]) {
    /*
     input findIndexPairInString("ababa", words: ["aba","ab"])
     output:- [[0, 1], [0, 2], [2, 3], [2, 4]]
     */
    class TrieNodeIndex {
        var children: [Character: TrieNodeIndex] = [:]
        var isEnd: Bool = false
        var indices: Set<Int> = Set<Int>()
    }
    var root = TrieNodeIndex()
    
    
    for (i, word) in words.enumerated() {
        insertWord(word, index: i)
    }
    
    var result = [[Int]]()
    for i in 0..<str.count {
        let startIndex = str.index(str.startIndex, offsetBy: i)
        result.append(contentsOf: search(String(str[startIndex...]), index: i))
    }
    
    print(result)
    
    func insertWord(_ word: String, index: Int) {
        var cur = root
        for (_, char) in word.enumerated() {
            if let child = cur.children[char] {
                cur = child
            } else {
                let new = TrieNodeIndex()
                cur.children[char] = new
                cur = new
            }
        }
        cur.isEnd = true
    }
    
    func search(_ word: String, index: Int) -> [[Int]] {
        var cur = root
        var result = [[Int]]()
        for (i, char) in word.enumerated() {
            if var child = cur.children[char] {
                cur = child
                if child.isEnd {
                    result.append([index, index+i])
                }
            } else {
                return result
            }
        }
        return result
    }
}

func longestWordPrefix(_ array: [String]) {
    /*
     Input: words = ["w","wo","wor","worl","world"]
     Output: "world"
     Explanation: The word "world" can be built one character at a time by "w", "wo", "wor", and "worl".
     
     
     Input: words = ["a","banana","app","appl","ap","apply","apple"]
     Output: "apple"
     Explanation: Both "apply" and "apple" can be built from other words in the dictionary. However, "apple" is lexicographically smaller than "apply".
     */
    let root = TrieNode()
    
    for i in array {
        insert(i)
    }
    
    var str = ""
    for i in array {
        let curStr = isItCompleteString(i)
        str = curStr.count > str.count ? curStr : (str < curStr ? str : curStr)
    }
    
    print(str)
    
    func insert(_ word: String) {
        var cur = root
        for i in word {
            if let child = cur.children[i] {
                cur = child
            }else {
                let new = TrieNode()
                cur.children[i] = new
                cur = new
            }
        }
        cur.isEnding = true
    }
    
    func isItCompleteString(_ word: String) -> String {
        var cur = root
        for i in word {
            if let child = cur.children[i],
                child.isEnding {
                cur = child
            }else {
                return ""
            }
        }
        return word
    }
}
 

func searchSuggestionSystem(_ array: [String], prefix: String) {
    /*
     Design a system that suggests at most three product names from products after each character of searchWord is typed. Suggested products should have common prefix with searchWord. If there are more than three products with a common prefix return the three lexicographically minimums products.

     Return a list of lists of the suggested products after each character of searchWord is typed.
     
     Input: products = ["mobile","mouse","moneypot","monitor","mousepad"], searchWord = "mouse"
     Output: [["mobile","moneypot","monitor"],["mobile","moneypot","monitor"],["mouse","mousepad"],["mouse","mousepad"],["mouse","mousepad"]]
     
     Explanation: products sorted lexicographically = ["mobile","moneypot","monitor","mouse","mousepad"].
     After typing m and mo all products match and we show user ["mobile","moneypot","monitor"].
     After typing mou, mous and mouse the system suggests ["mouse","mousepad"].
     */
    let root = TrieNode()
    
    for i in array {
        insert(i)
    }
    
    let suggestion = search(prefix)
    
    print(suggestion)
    
    func insert(_ word: String) {
        var cur = root
        for i in word {
            if let child = cur.children[i] {
                cur = child
            }else {
                let child = TrieNode()
                cur.children[i] = child
                cur = child
            }
        }
        cur.isEnding = true
    }
    
    /*
     when we searching we need to return the words which starts with the prefix
     
     Brout force approach
     need to print almost 3 words even if it is many word. We can ask that array is sorted or not. if it is albhabetically order we can keep two pointer to check for the string
     
     */
    func search(_ prefix: String) -> [String] {
        var array = [String]()
        var cur = root
        for i in prefix {
            if let child = cur.children[i] {
                cur = child
            }else {
                return array
            }
        }
        return findWordsFromNode(cur, currentWord: prefix)
    }
    
    
    func findWordsFromNode(_ node: TrieNode, currentWord: String) -> [String] {
        var suggestion = [String]()
        
        if node.isEnding {
            suggestion.append(currentWord)
        }
        
        for (char, child) in node.children {
            let childSuggestions = findWordsFromNode(child, currentWord: currentWord + String(char))
            suggestion.append(contentsOf: childSuggestions)
        }
        return suggestion
    }
}


func removeSubFolder(_ array: [String], removeFolderPath: String) {
    class TrieNodeWithString {
        var children: [String: TrieNodeWithString] = [:]
        var isEnding: Bool = false
        var isRemoved: Bool = false
    }
    
    /*
     
     print("/home/user/documents".split(separator: "/").map { String($0) })
     
     output: print("/home/user/documents".split(separator: "/").map { String($0) })
     */
    let root = TrieNodeWithString()
    
    for i in array {
        insert(i)
    }
    
    print("before removing folder details")
    print(listFolder(root, currentPath: ""))
    
    
    removeFolder(removeFolderPath)
    
    print("after removing folder details")
    print(listFolder(root, currentPath: ""))
    
    func insert(_ folderPath: String) {
        var cur = root
        let folders = folderPath.split(separator: "/").map{ String($0) }
        for i in folders {
            if let child = cur.children[i] {
                cur = child
            }else {
                let new = TrieNodeWithString()
                cur.children[i] = new
                cur = new
            }
        }
        cur.isEnding = true
    }
    
    func removeFolder(_ path: String) {
        var node = root
        let folders = path.components(separatedBy: "/").map { String($0) }
        for folder in folders {
            if let child = node.children[folder] {
                node = child
            }else {
                print("nothing to remove")
            }
        }
        node.isRemoved = true
    }
    
    
    func listFolder(_ node: TrieNodeWithString, currentPath: String) -> [String] {
        var folders = [String]()
        
        if node.isEnding {
            folders.append(currentPath)
        }
        
        for (folder, child) in node.children {
            let path = currentPath.isEmpty ? folder : currentPath+"/"+folder
            if !child.isRemoved {
               let childPath = listFolder(child, currentPath: path)
                folders.append(contentsOf: childPath)
            }
        }
        return folders
    }
}


func numberOfDistinctSubstring(_ str: String) {
    /*
     Input:
      S1= “ababa”
     Output: Total number of distinct substrings : 10
     Explanation: All the substrings of the string are a, ab, aba, abab, ababa, b, ba, bab, baba, a, ab, aba, b, ba, a. Many of the substrings are duplicated. The distinct substrings are a, ab, aba, abab, ababa, b, ba, bab, baba. Total Count of the distinct substrings is 9 + 1(for empty string) = 10.
     */
    
    let root = TrieNode()
    
    for i in 0..<str.count {
        let startIndex = str.index(str.startIndex, offsetBy: i)
        insert(String(str[startIndex...]))
    }
    
    let distinctSubStrs = getDistictSubString(root, subStr: "")
    
    print("distict sub strings are = \(distinctSubStrs), count = \(distinctSubStrs.count)")
    
    
    func insert(_ subStr: String) {
        var cur = root
        for i in subStr {
            if let child = cur.children[i] {
                cur = child
            }else {
                let new = TrieNode()
                cur.children[i] = new
                cur = new
            }
        }
        cur.isEnding = true
    }
    
    func getDistictSubString(_ root: TrieNode, subStr: String) -> [String] {
        var array = [String]()
        array.append(subStr)
        for (char, child) in root.children {
            let subString = subStr+String(char)
            let childSubArray = getDistictSubString(child,subStr: subString)
            array.append(contentsOf: childSubArray)
        }
        
        return array
    }
}

func replaceWords(_ dictionary: [String], sentence: String) {
    /*
     Given a dictionary consisting of many roots and a sentence consisting of words separated by spaces, replace all the successors in the sentence with the root forming it. If a successor can be replaced by more than one root, replace it with the root that has the shortest length.

     Input: dictionary = ["cat","bat","rat"], sentence = "the cattle was rattled by the battery"
     Output: "the cat was rat by the bat"
     
     */
    
    let root = TrieNode()
    
    for i in dictionary {
        insert(i)
    }
    
    replace()
    
    
    func insert(_ word: String) {
        var cur = root
        
        for i in word {
            if let child = cur.children[i] {
                cur = child
            }else {
                let new = TrieNode()
                cur.children[i] = new
                cur = new
            }
        }
        cur.isEnding = true
    }
    
    func replace() {
        /*
         "the cattle was rattled by the battery".split(separator: " ").map { String($0) }
         
         output: ["the", "cattle", "was", "rattled", "by", "the", "battery"]
         */
        let subStrs = sentence.split(separator: " ").map { String($0) }
        var replacedString = ""
        
        for i in subStrs {
            replacedString += searchAndReplace(i)+" "
        }
        
        print(replacedString)
    }
    
    
    func searchAndReplace(_ word: String) -> String {
        var cur = root
        var subStr = ""
        for i in word {
            if let child = cur.children[i] {
                cur = child
                subStr += String(i)
                if child.isEnding {
                    return subStr
                }
            }else {
                return word
            }
        }
        return word
    }
}

func lexicographicalNumbers(_ num: Int) {
    /*
     Given an integer n, return all the numbers in the range [1, n] sorted in lexicographical order.
     
     Input: n = 13
     Output: [1,10,11,12,13,2,3,4,5,6,7,8,9]
     */
    
    class DigitTrie {
        var children: [Int: DigitTrie] = [:]
        var isEnd: Bool = false
    }
    
    let root = DigitTrie()
    
    for i in 0...num {
        insert(i)
    }
    
    var array = [Int]()
    print("lexicographicalNumbers")
    generateNumbers(root, cur: 0, array: &array)
    print(array)
    
    
    func generateNumbers(_ node: DigitTrie, cur: Int, array: inout [Int]) {
        if node.isEnd {
            array.append(cur)
        }
        
        for i in 1...num {
            if let child = node.children[i] {
                generateNumbers(child, cur: cur*10+i, array: &array)
            }
        }
    }
    
    
    func insert(_ num: Int) {
        /*
         here we need to divide the num with the 10 to get the division value and store that value as root node and remainder as child node
         */
        var cur = root
        let digits = Array(String(num))
        for i in digits {
            let digit = Int(String(i))!
            if let child = cur.children[digit] {
                cur = child
            }else {
                let child = DigitTrie()
                cur.children[digit] = child
                cur = child
            }
        }
        cur.isEnd = true
    }
}

func disignFileSystem(_ command: [String], path: [[Any]]) {
    /*
     Input:
     ["FileSystem","createPath","get"]
     [[],["/a",1],["/a"]]
     Output:
     [null,true,1]
     Explanation:
     FileSystem fileSystem = new FileSystem();

     fileSystem.createPath("/a", 1); // return true
     fileSystem.get("/a"); // return 1
     
     
     Input:
     ["FileSystem","createPath","createPath","get","createPath","get"]
     [[],["/leet",1],["/leet/code",2],["/leet/code"],["/c/d",1],["/c"]]
     Output:
     [null,true,true,2,false,-1]
     Explanation:
     FileSystem fileSystem = new FileSystem();

     fileSystem.createPath("/leet", 1); // return true
     fileSystem.createPath("/leet/code", 2); // return true
     fileSystem.get("/leet/code"); // return 2
     fileSystem.createPath("/c/d", 1); // return false because the parent path "/c" doesn't exist.
     fileSystem.get("/c"); // return -1 because this path doesn't exist.
     */
    
    
    class FileTrie {
        var child: [String: FileTrie] = [:]
        var isEnd = false
    }
    
    var root: FileTrie?
    
    designFileSystem()
    
    func designFileSystem() {
        var outPut = [Any?]()
        if command.count != path.count {
            print("can't do")
            return
        }
        for (index, commandStr) in command.enumerated() {
            switch commandStr {
            case "FileSystem":
                outPut.append(nil)
                createFileSystem()
            case "createPath":
                createPath(path[index][0] as! String, count: path[index][1] as! Int, outPut: &outPut)
            case "get":
                get(path[index][0] as! String, outPut: &outPut)
            default: break
            }
        }
        print(outPut)
    }
    
    func createFileSystem() {
        root = FileTrie()
    }
    
    func get(_ path: String, outPut: inout [Any?]) {
        let pathComponents = path.split(separator: "/").map { String($0) }
        var cur = root, count = -1
        if cur == nil {
            outPut.append(count)
            print("file is not there")
            return
        }
        
        for i in pathComponents {
            if let child = cur?.child[i] {
                count += 1
                cur = child
            }else {
                outPut.append(count)
                return
            }
        }
        outPut.append(count+1)
        print("file is there")
    }
    
    func createPath(_ path: String, count: Int, outPut: inout [Any?]) {
        let pathComponents = path.split(separator: "/").map { String($0) }
        var cur = root
        
        if pathComponents.count != count || cur == nil {
            outPut.append(false)
            return
        }
        
        for i in pathComponents {
            if let child = cur?.child[i] {
                cur = child
            }else {
                let new = FileTrie()
                cur?.child[i] = new
                cur  = new
            }
        }
        outPut.append(true)
        cur?.isEnd = true
    }
}


func extraCharacterInAString(_ words: [String], s: String) {
    /*
     Input: s = "leetscode", dictionary = ["leet","code","leetcode"]
     Output: 1
     Explanation: We can break s in two substrings: "leet" from index 0 to 3 and "code" from index 5 to 8. There is only 1 unused character (at index 4), so we return 1.
     
     Input: s = "sayhelloworld", dictionary = ["hello","world"]
     Output: 3
     Explanation: We can break s in two substrings: "hello" from index 3 to 7 and "world" from index 8 to 12. The characters at indices 0, 1, 2 are not used in any substring and thus are considered as extra characters. Hence, we return 3.
     */
    
    for i in words {
        insertWord(i)
    }
    
    search(s)
    
    func search(_ s: String) {
        var cur = root, count = 0, index = 0
        while cur != nil && index < s.count {
            let char =  s[s.index(s.startIndex, offsetBy: index)]
            if let child = cur.children[char] {
                cur = child
                index += 1
                if child.isEnding {
                    cur = root
                }
            }else {
                count += 1
                cur = root
                index += 1
            }
        }
        
        print(count)
    }
}

func implementMagicDictionary(_ command: [String], exec: [[Any]]) {
    /*
     implementMagicDictionary(["MagicDictionary", "buildDict", "search", "search", "search", "search"], exec: [[], [["enjoy","maths"]], ["eajoy"], ["ennjoy"], ["enjo"], ["secret"]])
     
     one character replaces will give the correct ans
     */
    class TrieNodeString {
        var children: [Character: TrieNodeString] = [:]
        var isEnding = false
    }
    
    var root: TrieNodeString?, output: [Any] = []
    build(command, exec: exec)
    
    func build(_ command: [String], exec: [[Any]]) {
        for (i, command) in command.enumerated() {
            switch command {
            case "MagicDictionary":
                root = TrieNodeString()
                output.append("null")
            case "buildDict":
                let items = exec[i] as! [[String]]
                for subItems in items  {
                    for item in subItems {
                        insert(item)
                    }
                }
                output.append("null")
            case "search":
                let item = exec[i] as! [String]
                for i in item {
                    search(i)
                }
            default: break
            }
        }
    }
    
    print(output)
    
    func insert(_ word: String) {
        if root == nil {
            output.append("null")
            return
        }
    
        var cur = root
        for i in word {
            if let child = cur?.children[i] {
                cur = child
            }else {
                let new = TrieNodeString()
                cur?.children[i] = new
                cur = new
            }
        }
        cur?.isEnding = true
    }
    
    func search(_ word: String) {
        if root == nil {
            return
        }
        var cur = root, index = 0, count = 0
        
        
        for i in 0..<word.count {
            let startIndex = word.index(word.startIndex, offsetBy: index)
            let ch = word[startIndex]
            if let child = cur?.children[ch] {
                cur = child
            }else {
                if cur!.children.isEmpty {
                    output.append(false)
                    return
                }
                count += 1
                /*
                 it gives the value to loop through a-z
                 */
                for scalarValue in UnicodeScalar("a").value...UnicodeScalar("z").value {
                    if let character = UnicodeScalar(scalarValue) {
                        var str = word
                        str = str.replacingCharacters(in: startIndex...startIndex, with: String(character))
                        if searchHelper(str, root: root) {
                            output.append(true)
                            return
                        }
                    }
                }
                output.append(false)
                return
            }
            index += 1
        }
        output.append(false)
    }
    
    func searchHelper(_ word: String, root: TrieNodeString?) -> Bool {
        print(word)
        var cur = root
        
        for i in word {
            if let child = cur?.children[i] {
                cur = child
            }else {
                return false
            }
        }
        
        return cur?.isEnding ?? false
    }
}

func toprequentWord(_ words: [String], K: Int) {
    /*
     Input: words = ["i","love","leetcode","i","love","coding"], k = 2
     Output: ["i","love"]
     Explanation: "i" and "love" are the two most frequent words.
     Note that "i" comes before "love" due to a lower alphabetical order.
     */
    
    var root = TrieNode()
    
    for i in words {
        insert(i)
    }
    
    var reslt = [(String, Int)]()
    
    getMostFrequestUsedWords(root, subStr: "")
    
    print(reslt)
    
    func insert(_ word: String) {
        var cur = root
        
        for i in word {
            if let child = cur.children[i] {
                cur = child
            }else {
                let new = TrieNode()
                cur.children[i] = new
                cur = new
            }
        }
        cur.isEnding = true
        cur.count += 1
    }
    
   
    
    func getMostFrequestUsedWords(_ root: TrieNode, subStr: String)  {
        if root.isEnding {
            print(subStr)
            if reslt.isEmpty {
                reslt.append((subStr, root.count))
            }else if reslt[0].1 < root.count {
                reslt.insert((subStr, root.count), at: 0)
            }else if reslt[0].1 > root.count {
                reslt.append((subStr, root.count))
            }else {
                subStr < reslt[0].0 ? reslt.insert((subStr, root.count), at: 0) : reslt.insert((subStr, root.count), at: 1)
            }
        }

        for (char, child) in root.children {
            let subString = subStr+String(char)
           getMostFrequestUsedWords(child, subStr: subString)
        }
    }
}

func shortEncodingWord(_ words: [String]) {
    /*
     
     Input: words = ["time", "me", "bell"]
     Output: 10
     Explanation: A valid encoding would be s = "time#bell#" and indices = [0, 2, 5].
     words[0] = "time", the substring of s starting from indices[0] = 0 to the next '#' is underlined in "time#bell#"
     words[1] = "me", the substring of s starting from indices[1] = 2 to the next '#' is underlined in "time#bell#"
     words[2] = "bell", the substring of s starting from indices[2] = 5 to the next '#' is underlined in "time#bell#"
     
     
     for this reverse the string and store the value in trie
     */
    var root = TrieNode()
    
    for i in words {
        inser(i)
    }
    
    let t = geShortEncoding(root, cur: "")
    print(t, t.count)
    
    func inser(_ word: String) {
        var cur = root
        
        for i in word.reversed() {
            if let child = cur.children[i] {
                cur = child
            }else {
                let new = TrieNode()
                cur.children[i] = new
                cur = new
            }
        }
        cur.isEnding = true
    }
    
    func geShortEncoding(_ root: TrieNode, cur: String) -> String {
        var str = ""
        if root.isEnding,
           root.children.isEmpty {
            return cur.reversed()+"#"
        }
        
        for (char,child) in root.children {
            let subChildStr = geShortEncoding(child, cur: cur+String(char))
            str.append(subChildStr)
        }
        return str
    }
}

func sumOfPrefixes(_ array: [String]) {
    /*
     Input: words = ["abc","ab","bc","b"]
     Output: [5,4,3,2]
     Explanation: The answer for each string is the following:
     - "abc" has 3 prefixes: "a", "ab", and "abc".
     - There are 2 strings with the prefix "a", 2 strings with the prefix "ab", and 1 string with the prefix "abc".
     The total is answer[0] = 2 + 2 + 1 = 5.
     - "ab" has 2 prefixes: "a" and "ab".
     - There are 2 strings with the prefix "a", and 2 strings with the prefix "ab".
     The total is answer[1] = 2 + 2 = 4.
     - "bc" has 2 prefixes: "b" and "bc".
     - There are 2 strings with the prefix "b", and 1 string with the prefix "bc".
     The total is answer[2] = 2 + 1 = 3.
     - "b" has 1 prefix: "b".
     - There are 2 strings with the prefix "b".
     The
     
     total is answer[3] = 2.
     */
    
    var root = TrieNode()
    
    for i in array {
        insert(i)
    }
    
    var scores = [Int]()
    for i in array {
        let t = getScore(i)
        scores.append(t)
    }
    
    print(scores)
    
    func getScore(_ word: String) -> Int {
        var cur = root, score = 0
        for i in word {
            if let child = cur.children[i] {
                score += child.count
                cur = child
            }else {
                return score
            }
        }
        return score
    }
    
    func insert(_ word: String) {
        var cur = root
        for i in word {
            if let child = cur.children[i] {
                cur = child
                cur.count += 1
            }else {
                let new = TrieNode()
                new.count = 1
                cur.children[i] = new
                cur = new
            }
        }
        cur.isEnding = true
    }
}

func numberOfMatchingSubSequence(_ words: [String], seq: String) {
    /*
     numberOfMatchingSubSequence(["ahjpjau","ja","ahbwzgqnuk","tnmlanowax"], seq: "dsahjpjauf")
     
     ["ahjpjau", "ja"] 2
     */
    for i in words {
        insertWord(i)
    }
    
    let t = search(root, seq: seq, index: 0, cur: "")
    print(Set(t), Set(t).count)
    
    func search(_ root: TrieNode, seq: String, index: Int, cur: String) -> [String] {
        var array = [String]()
        if root.isEnding {
            array.append(cur)
        }
        if index >= seq.count {
            return array
        }
        
        var nextIndex = index
        
        while nextIndex < seq.count {
            let startIndex = seq.index(seq.startIndex, offsetBy: nextIndex)
            let char = seq[startIndex]
            if let child = root.children[char] {
                let childArray = search(child, seq: seq, index: nextIndex+1, cur: cur+String(char))
                array.append(contentsOf: childArray)
                nextIndex += 1
            }else {
                nextIndex += 1
            }
        }
        
        return array
    }
}

func camelcaseMatching(_ words: [String], query: String) {
    /*
     Input: queries = ["FooBar","FooBarTest","FootBall","FrameBuffer","ForceFeedBack"], pattern = "FB"
     Output: [true,false,true,true,false]
     Explanation: "FooBar" can be generated like this "F" + "oo" + "B" + "ar".
     "FootBall" can be generated like this "F" + "oot" + "B" + "all".
     "FrameBuffer" can be generated like this "F" + "rame" + "B" + "uffer".
     */
    
    for i in words {
        insert(i)
    }
    
    let t = camelcaseMatching(query)
    
    print(t)
    
    func insert(_ word: String) {
        var cur = root
        for i in word {
            if let child = cur.children[i] {
                cur = child
            }else {
                let new = TrieNode()
                cur.children[i] = new
                cur = new
            }
        }
        cur.isEnding = true
    }
    
    func camelcaseMatching(_ query: String) -> [String] {
        var cur = root
        var array = [String](), str = ""
        
        for (i, char) in query.enumerated() {
            if i > 0 && char.isUppercase {
                let childArry = searchHelper(cur, queryIndex: i, query: query, curElem: str)
                array.append(contentsOf: childArry)
                return array
            }else if let child = cur.children[char] {
                str.append(char)
                cur = child
            }
        }
        
        return array
    }
    
    
    func searchHelper(_ root: TrieNode, queryIndex: Int, query: String, curElem: String) -> [String] {
        var array = [String]()
        if root.isEnding && queryIndex >= query.count {
            array.append(curElem)
        }
        
        for (char, child) in root.children {
            if queryIndex < query.count {
                let queryChar = query[query.index(query.startIndex, offsetBy: queryIndex)]
                if queryChar == char && queryChar.isUppercase == char.isUppercase  {
                    let childArry = searchHelper(child, queryIndex: queryIndex+1, query: query, curElem: curElem+String(char))
                    array.append(contentsOf: childArry)
                }else if char.isUppercase {
                    return array
                }else {
                    let childArry = searchHelper(child, queryIndex: queryIndex, query: query, curElem: curElem+String(char))
                    array.append(contentsOf: childArry)
                }
            }else if char.isUppercase {
                return array
            }else {
                let childArry = searchHelper(child, queryIndex: queryIndex, query: query, curElem: curElem+String(char))
                array.append(contentsOf: childArry)
            }
        }
       return array
    }
}

func deleteDuplicateFileFolder(_ words: [[Character]]) {
    /*
     For example, ["one", "two", "three"] represents the path "/one/two/three".
     Two folders (not necessarily on the same level) are identical if they contain the same non-empty set of identical subfolders and underlying subfolder structure. The folders do not need to be at the root level to be identical. If two or more folders are identical, then mark the folders as well as all their subfolders.

     For example, folders "/a" and "/b" in the file structure below are identical. They (as well as their subfolders) should all be marked:
     /a
     /a/x
     /a/x/y
     /a/z
     /b
     /b/x
     /b/x/y
     /b/z
     However, if the file structure also included the path "/b/w", then the folders "/a" and "/b" would not be identical. Note that "/a/x" and "/b/x" would still be considered identical even with the added folder.
     */
    
    /*
     Input: paths = [["a"],["c"],["d"],["a","b"],["c","b"],["d","a"]]
     Output: [["d"],["d","a"]]
     Explanation: The file structure is as shown.
     Folders "/a" and "/c" (and their subfolders) are marked for deletion because they both contain an empty
     folder named "b".
     */
    class TrieNodeFile {
        var children: [Character: TrieNodeFile] = [:]
        var nextDict = ""
        var isEnd = false
        var isRemoved = true
    }
    
    var root = TrieNodeFile()
    for word in words {
        insert(word)
    }
    let t = removeDuplicate(root)
    var res = [[String]]()
    printValues(t, key: "", res: &res)
    print(res)
    
    
    func printValues(_ root: TrieNodeFile, key: String, res: inout [[String]]) {
        for (char, child) in root.children {
            if child.isEnd {
                key.isEmpty ?  res.append([String(char)]) :  res.append([key, String(char)])
            }
            printValues(child, key: String(char), res: &res)
        }
    }
    
    
    func insert(_ words: [Character]) {
        var cur = root
        
        for word in words {
            if let child = cur.children[word] {
                cur = child
            }else {
                let new = TrieNodeFile()
                cur.children[word] = new
                cur = new
            }
        }
        cur.isEnd = true
    }
    
    func removeDuplicate(_ root: TrieNodeFile) -> TrieNodeFile {
        var root = root
        var children = root.children
        var dict: [String: Character] = [:]
        
        for (char, child) in children {
            let t = searchHelper(child)
            if let value = dict[t] {
                root.children.removeValue(forKey: char)
                root.children.removeValue(forKey: value)
            }else {
                dict[t] = char
            }
        }
        
        return root
    }
    
    func searchHelper(_ root: TrieNodeFile) -> String {
        var str = ""
        for (char, child) in root.children {
            str += String(char)
            str += searchHelper(child)
        }
        return str
    }
}

func prefixAndSuffixSearch(_ command: [String], query: [Any]) {
    /*
     Input
     ["WordFilter", "f"]
     [[["apple"]], ["a", "e"]]
     Output
     [null, 0]
     Explanation
     WordFilter wordFilter = new WordFilter(["apple"]);
     wordFilter.f("a", "e"); // return 0, because the word at index 0 has prefix = "a" and suffix = "e".
     */
    
    class SufixPrefixTrie {
        var children: [Character: SufixPrefixTrie] = [:]
        var index = Set<Int>()
        var isEnding = false
    }
    
    var root = SufixPrefixTrie()
    var res = [Any?]()
    build()
    
    print(res)
    
    func build() {
        for (i, comm) in command.enumerated() {
            switch comm {
            case "WordFilter":
                let array = query[i] as! [String]
                for item in array {
                    insert(item, index: i)
                    insert(String(item.reversed()), index: i)
                }
                res.append(nil)
            case "f":
                let array = query[i] as! [String]
                let prefixSet = serch(array[0])
                let suffixSet = serch(array[1])
                print("prefixSet = \(prefixSet)", "suffixSet = \(suffixSet)")
                // get the largest index and print that value here
                let intersect = prefixSet.intersection(suffixSet).first!
                res.append(intersect)
            default: break
            }
        }
    }
    
    func insert(_ word: String, index: Int) {
        var cur = root
        for i in word {
            if let child = cur.children[i] {
                cur = child
            }else {
                let new = SufixPrefixTrie()
                cur.children[i] = new
                cur = new
            }
            cur.index.insert(index)
        }
        cur.isEnding = true
    }
    
    func serch(_ item: String) -> Set<Int> {
        var cur = root
        for i in item {
            if let child = cur.children[i] {
                cur = child
            }else {
                return []
            }
        }
        return cur.index
    }
}

func designMemoryFileSystem(_ command: [String], query: [[String]]) {
    /*
     Example:
     Input:
     ["FileSystem","ls","mkdir","addContentToFile","ls","readContentFromFile"]
     [[],["/"],["/a/b/c"],["/a/b/c/d","hello"],["/"],["/a/b/c/d"]]

     Output:
     [null,[],null,null,["a"],"hello"]
     */
    class FileSystemNode {
        var children: [String: FileSystemNode] = [:]
        var isEnd = false
        var conten = ""
    }
    
    var root: FileSystemNode?
    var res = [Any?]()
    build()
    
    print(res)
    
    func build() {
        for (i,com) in command.enumerated() {
            switch com {
            case "FileSystem":
                res.append(nil)
                root = FileSystemNode()
            case "ls":
                ls(query[i][0])
            case "mkdir":  makeDir(query[i][0])
            case "addContentToFile":  addContentToFile(query[i][0], con: query[i][1])
            case "readContentFromFile": readContentToFile(query[i][0])
            default: break
            }
        }
    }
    
    func readContentToFile(_ path: String) {
        var cur = root
        let components = path.split(separator: "/").map{ String($0) }
        for i in components {
            if let child = cur?.children[i] {
                cur = child
            }else {
                res.append(nil)
                return
            }
        }
        res.append(cur?.conten)
    }
    
    func addContentToFile(_ path: String, con: String) {
        var cur = root
        let components = path.split(separator: "/").map{ String($0) }
        for i in components {
            if let child = cur?.children[i] {
                cur = child
            }else {
                let new = FileSystemNode()
                cur?.children[i] = new
                cur = new
            }
        }
        res.append(nil)
        cur?.conten = con
    }
    
    func ls(_ path: String) {
        var cur = root
        let components = path.split(separator: "/").map{ String($0) }
        print(components)
        if components.isEmpty {
            var array = [String]()
            for (char,child) in cur!.children {
                array.append(char)
            }
            res.append(array)
        } else {
            for i in components {
                if let child = cur?.children[i] {
                    cur = child
                }else {
                    res.append("[]")
                    return
                }
            }
            
            for (char, _) in cur!.children {
                res.append(String(char))
            }
        }
    }
    
    func makeDir(_ path: String) {
        var cur = root
        let components = path.split(separator: "/").map{ String($0) }
        for i in components {
            if let child = cur?.children[i] {
                cur = child
            }else {
                let new = FileSystemNode()
                cur?.children[i] = new
                cur = new
            }
        }
        res.append(nil)
        cur?.isEnd = true
    }
    
    func lsOfRootNode() {
        res.append(["/"])
    }
}

func minimalWordAbbreviation(_ array: [String]) {
    /*
     Input: ["like", "god", "internal", "me", "internet", "interval", "intension", "face", "intrusion"]
     Output: ["l2e","god","internal","me","i6t","interval","inte4n","f2e","intr4n"]
     */
    
    class Node {
        var children = [Character: Node]()
        var isEnd = false
        var childInfo = [Int: [Character: Int]]()
        var frequency = 0 // to keep the frequency of
    }
    
    var root = Node()
    
    let t = generateMinimalAbbreviations(array)
    print(t)
    
    func generateMinimalAbbreviations(_ words: [String]) -> [String] {
        for word in words {
            insert(word)
        }
        
        var result: [String] = []
        for word in words {
            if word.count > 3 {
                let abbreviation = getAbbreviation(word)
                result.append(abbreviation)
            }else {
                result.append(word)
            }
        }
        return result
    }
    
    func insert(_ word: String) {
        var cur = root
        for i in word {
            if let child = cur.children[i] {
                cur = child
                cur.frequency += 1
                if let info = cur.childInfo[word.count] {
                    if let lastInfo = info[word.last!] {
                        cur.childInfo[word.count]?[word.last!] = lastInfo + 1
                    } else {
                        cur.childInfo[word.count]?[word.last!] = 1
                    }
                }else {
                    cur.childInfo[word.count] = [word.last!: 1]
                }
            }else {
                let new = Node()
                new.childInfo = [word.count: [word.last!: 1]]
                new.frequency = 1
                cur.children[i] = new
                cur = new
            }
        }
        cur.isEnd = true
    }
    
    func getAbbreviation(_ word: String) -> String {
        var cur = root
        var prefix = "", count = 0
        for (i, char) in word.enumerated() {
            if i == 0,
               let child = cur.children[char] {
                prefix.append(char)
                cur = child
            }else if cur.frequency > 1,
                     let child = cur.children[char] {
                prefix.append(char)
                cur = child
            }else {
                if let info = cur.childInfo[word.count],
                   let fre = info[word.last!],
                   fre != 1,
                   cur.frequency > 1 {
                    prefix.append(char)
                }else {
                    if cur.children.count == 1 {
                        count += 1
                    }else {
                        prefix.append(char)
                    }
                }
            }
        }
        if count > 2 {
            return "\(prefix)\(count-1)\(word.last!)"
        }
        return word
    }
}


func concatinatingWords(_ words: [String]) {
    /*
     Input: words = ["cat","cats","catsdogcats","dog","dogcatsdog","hippopotamuses","rat","ratcatdogcat"]
     Output: ["catsdogcats","dogcatsdog","ratcatdogcat"]
     Explanation: "catsdogcats" can be concatenated by "cats", "dog" and "cats";
     "dogcatsdog" can be concatenated by "dog", "cats" and "dog";
     "ratcatdogcat" can be concatenated by "rat", "cat", "dog" and "cat".
     */
    
    for word in words {
        insertWord(word)
    }
    
    var array = [String]()
    
    for word in words {
        if dfs(root, word: word, index: 0, count: 0) {
            array.append(word)
        }
    }
    
    print(array)
    
    /*
     count is used to check the multiple strings added to get a word or not
     */
    func dfs(_ root: TrieNode, word: String, index: Int, count: Int) -> Bool {
        if index == word.count {
            return count >= 2
        }
        
        var cur = root
        for i in index..<word.count {
            let char = word[word.index(word.startIndex, offsetBy: i)]
            if let child = cur.children[char] {
                cur = child
                if cur.isEnding {
                    if dfs(root, word: word, index: i+1, count: count+1) {
                        return true
                    }
                }
            }else {
                return false
            }
        }
        return false
    }
}

func encryptAndDecryptStrings(_ command: [String], array: [Any]) {
    /*
     Input
     ["Encrypter", "encrypt", "decrypt"]
     [[['a', 'b', 'c', 'd'], ["ei", "zf", "ei", "am"], ["abcd", "acbd", "adbc", "badc", "dacb", "cadb", "cbda", "abad"]], ["abcd"], ["eizfeiam"]]
     Output
     [null, "eizfeiam", 2]

     Explanation
     Encrypter encrypter = new Encrypter([['a', 'b', 'c', 'd'], ["ei", "zf", "ei", "am"], ["abcd", "acbd", "adbc", "badc", "dacb", "cadb", "cbda", "abad"]);
     encrypter.encrypt("abcd"); // return "eizfeiam".
                                // 'a' maps to "ei", 'b' maps to "zf", 'c' maps to "ei", and 'd' maps to "am".
     encrypter.decrypt("eizfeiam"); // return 2.
                                   // "ei" can map to 'a' or 'c', "zf" maps to 'b', and "am" maps to 'd'.
                                   // Thus, the possible strings after decryption are "abad", "cbad", "abcd", and "cbcd".
                                   // 2 of those strings, "abad" and "abcd", appear in dictionary, so the answer is 2.
     */
    
    /*
     assuming we have two fords minimum for every encryption key.
     */
    class EncryptTrie {
        var children: [String: EncryptTrie] = [:]
        var isEnd = false
        var key = Set<String>()
    }
    
    var root = EncryptTrie()
    var res = [Any]()
    build()
    print(res)
    
    func build() {
        for (i, com) in command.enumerated() {
            switch com {
            case "Encrypter":
                let item = (array[i] as! [[String]])[2]
                for i in item {
                    insert(i)
                }
                let keys = (array[i] as! [[String]])[0]
                let values = (array[i] as! [[String]])[1]
                for i in 0..<keys.count {
                    if let child = root.children[keys[i]] {
                        child.key.insert(values[i])
                    }else {
                        let new = EncryptTrie()
                        new.key.insert(values[i])
                        root.children[keys[i]] = new
                    }
                }
                
                for i in 0..<values.count {
                    if let child = root.children[values[i]] {
                        child.key.insert(keys[i])
                    }else {
                        let new = EncryptTrie()
                        new.key.insert(keys[i])
                        root.children[values[i]] = new
                    }
                }
                res.append("nil")
                
            case "encrypt" :
                let item = array[i] as! [String]
                for i in item {
                    encrypt(i)
                }
            case "decrypt":
                let item = array[i] as! [String]
                for i in item {
                    let t = decrypt(i, index: 0, decryptedText: "", node: root)
                    res.append((t.count, t))
                }
            default: break
            }
        }
    }
    
    func decrypt(_ word: String, index: Int, decryptedText: String, node: EncryptTrie) -> [String] {
        var array = [String]()
        if index >= word.count {
            return array
        }
        
        let stratIndex = word.index(word.startIndex, offsetBy: index)
        let endIndex = word.index(word.startIndex, offsetBy: index+1)
        let sub = String(word[stratIndex...endIndex])
        if let rootChild = root.children[sub] {
            for key in rootChild.key {
                if let child = node.children[key] {
                    let childSubArray = decrypt(word, index: index+2, decryptedText: decryptedText+key, node: child)
                    if child.isEnd {
                        array.append(decryptedText+key)
                    }
                    array.append(contentsOf: childSubArray)
                }
            }
        }
        return array
    }
    
    func encrypt(_ word: String) {
        var str = ""
        for i in word {
            if let child = root.children[String(i)] {
                str.append(child.key.first!)
            }
        }
        res.append(str)
    }
    
    func insert(_ word: String) {
        var cur = root
        for i in word {
            if let child = cur.children[String(i)] {
                cur = child
            }else {
                let new = EncryptTrie()
                cur.children[String(i)] = new
                cur = new
            }
        }
        cur.isEnd = true
    }
}


func distinctEchoSubstrings(_ string: String) {
    /*
     Input: text = "abcabcabc"
     Output: 3
     Explanation: The 3 substrings are "abcabc", "bcabca" and "cabcab".
     
     
     approach we need to find the echo string i.e if we have "a" then next letter also be "a" i.e "aa" is called as echo, "bb" is called echo
     "abab" is also echo that means every substring should have its repetation
     
     bcz of this we can iterate the string untill half legth and we can store this in tree
     */
    // for easy calulation of index currently i used array
    var array = Array(string)
    var count = 0, dict = [String: Int]() // use dict or trie to calculate the total distinct count
    
    // it gives the total count
    for len in 1...string.count/2 {
        //here we used 2*i bcz we need to check for next repeated item
        for i in 0...(string.count-2*len) {
            let subString = String(array[i..<i+len])
            let subStringRepetation = String(array[i+len..<(i+2*len)])
            if subString == subStringRepetation {
                if dict[subString] == nil {
                    count += 1
                }
                dict[subString] = 1
                print(subString)
               
            }
        }
    }
    print(count)
}

func palindromePair(_ words: [String]) {
    /*
     Input: words = ["abcd","dcba","lls","s","sssll"]
     Output: [[0,1],[1,0],[3,2],[2,4]]
     Explanation: The palindromes are ["abcddcba","dcbaabcd","slls","llssssll"]
     
     approach:
     store every character in reverse order of trie and store the index in every character again traverse through the array and check for palindrome
     */
    class PalindromeTrie {
        var children = [Character: PalindromeTrie]()
        var index = Set<Int>()
        var isEnding = false
    }
    
    let root = PalindromeTrie()
    var res = [Any]()
    
    for (i, word) in words.enumerated() {
        insert(word, index: i)
    }
    
    for (i, word) in words.enumerated() {
        checkPalindromePair(word, index: i)
    }
    
    print(res)
    
    func insert(_ word: String, index: Int) {
        var cur = root
        for i in word {
            if let child = cur.children[i] {
                cur = child
            }else {
                let new = PalindromeTrie()
                cur.children[i] = new
                cur = new
            }
        }
        cur.index.insert(index)
        cur.isEnding = true
    }
    
    func checkPalindromePair(_ word: String, index: Int) {
        var root = root.children[word.last!]
        if root == nil || (root!.index.count == 1 && root!.index.contains(index)) {
            return
        }
        _ = dfsSearch(root!, index: index, words: words)
    }
    
    func dfsSearch(_ root: PalindromeTrie, index: Int, words: [String]) -> Bool {
        if root.isEnding {
            for value in root.index {
                print("words[index] = \(words[index]) root.isEnding = \(root.isEnding) root.index = \(root.index) words[value] = \(words[value]) index= \(index)")
                if value != index {
                    if isPalindrome(words[index]+words[value]) {
                        res.append([index, value])
                    }else if isPalindrome(words[value]+words[index]) {
                        res.append([value, index])
                    }
                    
                    return true
                }
            }
        }
        
        for (_, child) in root.children {
            if dfsSearch(child, index: index, words: words) {
                return true
            }
        }
        return false
    }
    
    func isPalindrome(_ word: String) -> Bool {
        var i = 0, j = word.count-1
        while i < j {
            // compare first and last element of string
            if word[word.index(word.startIndex, offsetBy: i)] == word[word.index(word.startIndex, offsetBy: j)] {
                
            }else {
                return false
            }
            i += 1
            j -= 1
        }
        return true
    }
}

func maximumXOROfArray(_ array: [Int]) {
    /*
     Input: nums = [3,10,5,25,2,8]
     Output: 28
     Explanation: The maximum result is 5 XOR 25 = 28.
     
     approach
     for every array item convert integer to 32bit and store it in trie and the loop through the array item to get the maximum xor value
     
     to find maximum xor value of `01010` then we need to find some value whose bit is opposito to the given number. Might be 10101 or 00101 or 01101 or 01011. maximum difference in bit gives max result. 0 xor 1 = 1 or 1 xor 0 = 1
     
     stor trie in bit of 0 or 1
     */
    
    class XorTrie {
        var children = [Int: XorTrie]()
        var isEnding = false
    }
    
    let root = XorTrie()
    for i in array {
        insert(i)
    }
    let max = findMaxXOR(array)
    print(max)
    
    func insert(_ num: Int) {
        var cur = root
        // to get the 32 bit of number
        for i in (0..<32).reversed() {
            // get the bit for number
            let bit = (num >> i) & 1
            
            if let child = cur.children[bit] {
                cur = child
            }else {
                let new = XorTrie()
                cur.children[bit] = new
                cur = new
            }
        }
        cur.isEnding = true
    }
    
    func findMaxXOR(_ nums: [Int]) -> Int {
        var maxXOR = 0
        
        for num in nums {
            var currentNode = root
            var currentXOR = 0
            
            for i in (0..<32).reversed() {
                let bit = (num >> i) & 1
                let oppositeBit = 1 - bit
                
                if let child = currentNode.children[oppositeBit] {
                    currentXOR = currentXOR | (1 << i)
                    currentNode = child
                } else if let child = currentNode.children[bit] {
                    currentNode = child
                } else {
                    break
                }
            }
            
            maxXOR = Swift.max(maxXOR, currentXOR)
        }
        
        return maxXOR
    }
}

func findMaxXorForTheQuery(_ array: [Int], queries: [[Int]]) {
    /*
     
     queries[i] = [xi, ai].
     
     Input: nums = [0,1,2,3,4], queries = [[3,1],[1,3],[5,6]]
     Output: [3,3,7]
     Explanation:
     1) 0 and 1 are the only two integers not greater than 1. 0 XOR 3 = 3 and 1 XOR 3 = 2. The larger of the two is 3.
     2) 1 XOR 2 = 3.
     3) 5 XOR 2 = 7.
     
     
     brute for approach is
     
     for query in queries {
     xi = query[0]
     mi = query[1]
     for j in array {
     if j <= mi {
     let value = xi^j
     }
     }
     }
     then get the max value
     */
    
    /*
     this can be optimised by using trie. First check wheter the array is sorted or not if not please sort
     and queries in the format of[xi,ai]. we need to sort query with respect to ai and store the index as well of the query. to store the result in order
     */
    class XorTrie {
        var children = [Int: XorTrie]()
        var isEnding = false
    }
    
    let root = XorTrie()
    
   
    getMaxValueForQuery()
    
    func getMaxValueForQuery() {
        //consider array is not sorted sor the array
        var sortedArray = array.sorted()
        
        //consider query with ai is not sorted
        // we need to sort query bcz we need to get the maximum xor only from the items present in array which is lesser than the ai value of query
        // need to get xor for array item with xi in query
        
        // keep the query with index as well this method is called offlinequery
        var querySorted = [[Int]]()
        for (i, item) in queries.enumerated() {
            querySorted.append([item[0], item[1], i])
        }
        
        querySorted = querySorted.sorted { item1, item2 in
            return item1[1] < item2[1]
        }
        
        print("querySorted = \(querySorted)")
        var result = Array(repeating: -1, count: queries.count)
        
        var arrayIndex = 0
        for query in querySorted {
            while arrayIndex < sortedArray.count && sortedArray[arrayIndex] <= query[1]  {
                insert(sortedArray[arrayIndex])
                arrayIndex += 1
            }
            
            if arrayIndex == 0 {
                result[query[2]] = -1
            }else {
                result[query[2]] = findMaximumXOR(query[0])
            }
        }
        
        print(result)
    }
   
    
    func insert(_ num: Int) {
        var currentNode = root
        
        for i in (0..<32).reversed() {
            let bit = (num >> i) & 1
            if currentNode.children[bit] == nil {
                currentNode.children[bit] = XorTrie()
            }
            currentNode = currentNode.children[bit]!
        }
    }
    
    func findMaximumXOR(_ num: Int) -> Int {
        var currentNode = root
        var result = 0
        
        for i in (0..<32).reversed() {
            let bit = (num >> i) & 1
            let oppositeBit = 1 - bit
            
            if let child = currentNode.children[oppositeBit] {
                result |= (1 << i)
                currentNode = child
            } else if let child = currentNode.children[bit] {
                currentNode = child
            }
        }
        
        return result
    }
}


func boldTagInString(_ str: String, array: [String]) {
    /*
     For example, given that words = ["ab", "bc"] and S = "aabcd", we should return "a<b>abc</b>d". Note that returning "a<b>a<b>b</b>c</b>d" would use more tags, so it is incorrect.
     */
    var isBold = Array(repeating: false, count: str.count)
    
    findBoldTags()
    
    print(isBold)
    addBoldTags()
    
    
    func findBoldTags() {
        for item in array {
            var start = str.startIndex
            while let range = str.range(of: item, range: start..<str.endIndex) {
                let startIdx = str.distance(from: str.startIndex, to: range.lowerBound)
                let endIndx = str.distance(from: str.startIndex, to: range.upperBound)
                
                for i in startIdx..<endIndx {
                    isBold[i] = true
                }
                start = str.index(start, offsetBy: 1)
            }
        }
    }
    
    func addBoldTags() {
        var result = ""
        var isTagOpen = false
        
        for (index,char) in str.enumerated() {
            if isBold[index] {
                if !isTagOpen {
                    result.append("<b>")
                    isTagOpen = true
                }
            }else {
                if isTagOpen {
                    result.append("</b>")
                    isTagOpen = false
                }
            }
            result.append(char)
        }
        
        if isTagOpen {
            result.append("</b>")
        }
        
        print(result)
    }
}


func countPairsWithXor(_ array: [Int], low: Int, heigh: Int) {
    /*
     Input: nums = [1,4,2,7], low = 2, high = 6
     Output: 6
     Explanation: All nice pairs (i, j) are as follows:
         - (0, 1): nums[0] XOR nums[1] = 5
         - (0, 2): nums[0] XOR nums[2] = 3
         - (0, 3): nums[0] XOR nums[3] = 6
         - (1, 2): nums[1] XOR nums[2] = 6
         - (1, 3): nums[1] XOR nums[3] = 3
         - (2, 3): nums[2] XOR nums[3] = 5
     */
    class XorTrie {
        var children = [Int: XorTrie]()
        var isEnding = false
        var count = 0
    }
    
    let root = XorTrie()
    
    for i in array {
        insert(i)
    }
    
    var result = 0
    for i in array {
        result += findBitCount(i, low: low, heigh: heigh)
    }
    
    print(result)
    
    func insert(_ num: Int) {
        var cur = root
        for i in (0..<32).reversed() {
            let bit = (num >> i) & 1
            
            if cur.children[bit] == nil {
                cur.children[bit] = XorTrie()
            }
            cur = cur.children[bit]!
            cur.count += 1
        }
    }
    
    func findBitCount(_ num: Int, low: Int, heigh: Int) -> Int {
        var currentNode = root, count = 0
        
        for i in (0..<32).reversed() {
            let bit = (num >> i) & 1
            let lowBit = (low >> i) & 1
            let heighBit = (heigh >> i) & 1
            
            if lowBit == 0 && heighBit == 0 {
                // Move to the same branch for the next iteration
                if let nextNode = currentNode.children[bit] {
                    currentNode = nextNode
                } else {
                    return count
                }
            }else if lowBit == 1 && heighBit == 1 {
                // Include all nodes from the opposite branch
                let oppositeBit = 1-bit
                if let child = currentNode.children[oppositeBit] {
                    currentNode = child
                }else if let child = currentNode.children[bit] {
                    currentNode = child
                }else {
                    return count
                }
            }else if lowBit == 0 && heighBit == 1 {
                // XOR is in the range [0, upperBound]
                if let child = currentNode.children[bit] {
                    count += child.count
                }
                
                // Move to the opposite branch for the next iteration
                if let nextNode = currentNode.children[1 - bit] {
                    currentNode = nextNode
                } else {
                    return count
                }
            }else if lowBit == 1 && heighBit == 0 {
                // XOR is in the range [lowerBound, 1]
                // Include all nodes from the opposite branch
                if let child = currentNode.children[1 - bit] {
                    count += child.count
                }
                
                // Move to the opposite branch for the next iteration
                if let nextNode = currentNode.children[1 - bit] {
                    currentNode = nextNode
                } else {
                    return count
                }
            }else {
                // Move to the same branch for the next iteration
                if let nextNode = currentNode.children[bit] {
                    currentNode = nextNode
                } else {
                    return count
                }
            }
        }
        return count
    }
}

func countPairsWithXorOnlyWithHeigherBound(_ array: [Int], heigh: Int) {
    /*
     Input: nums = [1,4,2,7], low = 2, high = 6
     Output: 6
     Explanation: All nice pairs (i, j) are as follows:
         - (0, 1): nums[0] XOR nums[1] = 5
         - (0, 2): nums[0] XOR nums[2] = 3
         - (0, 3): nums[0] XOR nums[3] = 6
         - (1, 2): nums[1] XOR nums[2] = 6
         - (1, 3): nums[1] XOR nums[3] = 3
         - (2, 3): nums[2] XOR nums[3] = 5
     */
    class XorTrie {
        var children = [Int: XorTrie]()
        var isEnding = false
        var count = 0
    }
    
    let root = XorTrie()
    
    for i in array {
        insert(i)
    }
    
    var result = 0
    for i in array {
        result += findBitCount(i, heigh: heigh)
    }
    
    print(result)
    
    func insert(_ num: Int) {
        var currentNode = root
        
        for i in (0..<32).reversed() {
            let bit = (num >> i) & 1
            if currentNode.children[bit] == nil {
                currentNode.children[bit] = XorTrie()
            }
            currentNode = currentNode.children[bit]!
            currentNode.count += 1
        }
    }
    
    func findBitCount(_ num: Int, heigh: Int) -> Int {
        var currentNode = root, count = 0
        
        for i in (0..<32).reversed() {
            let bit = (num >> i) & 1
            let heighBit = (heigh >> i) & 1
            
            if heighBit == 1 {
                // Include all nodes from the opposite branch
                let oppositeBit = 1-bit
                if let child = currentNode.children[oppositeBit] {
                    currentNode = child
                }else if let child = currentNode.children[bit] {
                    currentNode = child
                }else {
                    return count
                }
            }else {
                // Move to the same branch for the next iteration
                if let nextNode = currentNode.children[bit] {
                    currentNode = nextNode
                } else {
                    return count
                }
            }
        }
        return count
    }
}

countPairsWithXor([1,4,2,7], low: 2, heigh: 6)



