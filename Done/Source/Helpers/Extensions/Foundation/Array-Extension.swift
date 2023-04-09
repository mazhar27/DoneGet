//
//  Array-Extension.swift
//  Done
//
//  Created by Mazhar Hussain on 5/30/22.
//

import Foundation

extension Array {
    
    ///Safe Array access with custom subscripts
    ///let values = ["A", "B", "C"]
    ///values[safe: 2] // "C"
    //values[safe: 3] // nil
    subscript (safe index: Int) -> Element? {
        guard index >= 0 && index < self.count else {
            return nil
        }
        return self[index]
    }
    
    /// returns the unique list of objects based on a given key
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
    }

    //Generic function for applying ascending sort on an array based on a particular property
    mutating func ascendingSort<T: Comparable>(by property: (Element) -> T) {
        self.sort(by: { property($0) < property($1) })
    }

    //Returns a list sorted in ascending order
    func ascendingSort<T: Comparable>(_ property: (Element) -> T) -> [Element] {
        return sorted(by: {property($0) < property($1)})
    }

    //Generic function for applying descending sort on an array based on a particular property
    mutating func descendingSort<T: Comparable>(by property: (Element) -> T) {
        self.sort(by: { property($0) > property($1) })
    }

    //Returns a list sorted in descending order
    func descendingSort<T: Comparable>(_ property: (Element) -> T) -> [Element] {
        return sorted(by: { property($0) > property($1) })
    }
    
}

