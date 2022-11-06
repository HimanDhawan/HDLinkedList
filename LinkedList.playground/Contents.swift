import UIKit

class Node : NSObject, NSCopying {
    var value : String
    var next : Node?
    
    init(value : String, next : Node? = nil) {
        self.value = value
        self.next = next
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        
        let node = Node.init(value: self.value, next: self.next)
        return node
   }

}

struct HDLinkedList {
    var head : Node?
    var tail : Node?
    init () {
        
    }
    mutating func push(node : String) {
        if head == nil {
            self.head = Node.init(value: node, next: head)
            self.tail = head
        } else {
           
            self.tail?.next = Node.init(value: node, next: nil)
            self.tail = tail?.next
        }
    }
    
    mutating func push(node : Node) {
        if head == nil {
            self.head = node
            self.tail = head
        } else {
           
            self.tail?.next = node
            self.tail = tail?.next
        }
    }
    
    func checkIfLinkedListIsCircular() -> Bool {
        
        if tail?.next == head {
            return true
        }
        return false
    }
    
    func findMiddleInCircularLinkedList() -> String? {
        var slow = self.head
        var fast = self.head
        
        if self.head == nil {
            return nil
        }
        
        while fast?.next != self.head, fast?.next?.next != self.head {
            fast = fast?.next?.next
            slow = slow?.next
        }
        
        return slow?.value
    }
    
    func findMiddleInSinglyLinkedList() -> String? {
        var slow = self.head
        var fast = self.head
        
        if self.head == nil {
            return nil
        }
        
        while fast?.next != nil {
            fast = fast?.next?.next
            slow = slow?.next
        }
        
        return slow?.value
    }
    
    func findMiddle() -> String? {
        if self.checkIfLinkedListIsCircular() {
            return self.findMiddleInCircularLinkedList()
        }
        return self.findMiddleInSinglyLinkedList()
    }
    
    func findFromLast(fromLast : Int) -> String? {
        var length = 0
        var node = self.head
        while node != nil {
            length += 1
            node = node?.next
        }
        
        let fromStart = length - fromLast + 1
        var flag = false
        length = 1
        var nodeFromStart = self.head
        while nodeFromStart != nil {
            if length == fromStart {
                flag = true
                break;
            }
            nodeFromStart = nodeFromStart?.next
            length += 1
        }
        return flag ? nodeFromStart?.value : nil
    }
    
    mutating func reverse() {
        
        var previous : Node? = nil
        var current = self.head
        var next = current?.next
        
        while next != nil {
            
            current?.next = previous
            previous = current
            current = next
            next = current?.next
            
        }
        current?.next = previous
        self.head = current
        print("Reversed")
    }
    
    func description() {
        var nodeToCheck : Node? = nil
        let isCircular = self.detectALoop()
        var lastElement = "nil"
        if isCircular {
            nodeToCheck = self.tail
            lastElement = "Pointing to \(self.detectStartingALoop() ?? "Head")"
        }
        var node = self.head
        var string = ""
        
        repeat {
            string = string + (node?.value ?? "") + " > "
            node = node?.next
        } while node != nodeToCheck
        
        if isCircular {
            string = string + (node?.value ?? "") + " > "
        }
        
        string = string + lastElement
        print(string)
    }
    
    func count() -> Int {
        var node = self.head
        var count = 0
        while node != nil {
            count = count + 1
            node = node?.next
        }
        return count
    }
    
    mutating func rotate(index : Int) {
        var itIndex = index
        let count = self.count()
        if count < index {
            itIndex = index%count
        }
        
        while itIndex != 0 {
            self.tail?.next = head?.copy() as? Node
            self.tail = self.tail?.next
            self.tail?.next = nil
            head = head?.next
            itIndex = itIndex - 1
        }
    }
    
    mutating func reverseWithKthElement(kIndex : Int) {
        
        var previous : Node? = nil
        var current = self.head
        var next = current?.next
        var index = 1
        
        var startingIndex = self.head
        var startingIndexPrevious : Node? = nil
        
        while next != nil {
            
            if index < kIndex {
                current?.next = previous
                previous = current
                current = next
                next = current?.next
            } else if index%kIndex == 1 {
                previous = current
                current = current?.next
                next = current?.next
            } else if index > kIndex, index%kIndex != 0 {
                current?.next = previous
                previous = current
                current = next
                next = current?.next
            } else if index%kIndex == 0 {
                startingIndex?.next = current?.next
                current?.next = previous
                previous = current
                current = next
                next = current?.next
                
                if startingIndexPrevious == nil {
                    self.head = previous
                }
                startingIndexPrevious?.next = previous
                startingIndexPrevious = startingIndex
                startingIndex = current
            }
            
            index = index + 1
        }
        current?.next = previous
        startingIndexPrevious?.next = current
        startingIndex?.next = nil
        
        print("Reversed")
    }
    
    func detectALoop() -> Bool {
        var slowPointer = self.head
        var fastPointer = self.head
        
        if self.head == nil {
            return false
        }
        
        if self.checkIfLinkedListIsCircular() {
            return true
        }
        var flag = false
        while (slowPointer != nil) && (fastPointer != nil) {
            fastPointer = fastPointer?.next?.next
            slowPointer = slowPointer?.next
            if slowPointer == fastPointer {
                flag = true
                break;
            }
        }
       
        
        return flag
    }
    
    func detectStartingALoop() -> String? {
        var slowPointer = self.head
        var fastPointer = self.head
        
        if self.head == nil {
            return nil
        }
        
        if self.checkIfLinkedListIsCircular() {
            return head?.value
        }
        while (slowPointer != nil) && (fastPointer != nil) {
            fastPointer = fastPointer?.next?.next
            slowPointer = slowPointer?.next
            if slowPointer == fastPointer {
                break;
            }
        }
        slowPointer = self.head
        
        while slowPointer != fastPointer {
            slowPointer = slowPointer?.next
            fastPointer = fastPointer?.next
        }
        
        return slowPointer?.value
    }
    
    func removeLoop() {
        var slowPointer = self.head
        var fastPointer = self.head
        
        if self.checkIfLinkedListIsCircular() {
            self.tail?.next = nil
            return
        }
        while (slowPointer != nil) && (fastPointer != nil) {
            fastPointer = fastPointer?.next?.next
            slowPointer = slowPointer?.next
            if slowPointer == fastPointer {
                break;
            }
        }
        slowPointer = self.head
        
        while slowPointer?.next != fastPointer?.next {
            slowPointer = slowPointer?.next
            fastPointer = fastPointer?.next
        }
        fastPointer?.next = nil
    }
    
    mutating func sortZeroOneTwoLinkedList() {
        var middlePointer = self.head

        var endPointer = self.head
        
        
        while (endPointer != nil) && (endPointer?.next != nil) {
            endPointer = endPointer?.next?.next
            middlePointer = middlePointer?.next
        }
        
        var startPointer = self.head
        var current = self.head
        var previousCurrent : Node? = nil
        var counter = 0
        let countOfLinkedList = self.count()
        while current != nil, counter != countOfLinkedList {
            
            if current?.value == "0" {
                previousCurrent?.next = current?.next
                self.head = Node.init(value: "0", next: startPointer)
                startPointer = self.head
                current = current?.next
            } else if current?.value == "2" {
                if previousCurrent == nil {
                    self.head = self.head?.next
                    current = current?.next
                } else {
                    previousCurrent?.next = current?.next
                }
                current = previousCurrent?.next
                endPointer?.next = Node.init(value: "2", next: nil)
                endPointer = endPointer?.next
            } else {
                previousCurrent = current
                current = current?.next
            }
            counter = counter + 1
        }
                
    }
    
    
    
}
