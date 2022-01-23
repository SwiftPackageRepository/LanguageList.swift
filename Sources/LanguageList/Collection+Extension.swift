//
//  File.swift
//  
//
//  Created by Sascha Müllner on 07.01.22.
//

import Foundation

internal extension Collection where Indices.Iterator.Element == Index {
   subscript(safe index: Index) -> Iterator.Element? {
     return (startIndex <= index && index < endIndex) ? self[index] : nil
   }
}
