//
//  NSRegularExpression.swift
//  
//
//  Created by Alsey Coleman Miller on 7/27/20.
//

import Foundation

internal extension NSRegularExpression {
    
    func matches(in string: String, options: NSRegularExpression.MatchingOptions) -> [[Substring]] {
        let range = NSRange(string.startIndex ..< string.endIndex, in: string)
        let matches = self.matches(in: string, options: options, range: range)
        return matches.map { (match) in
            return (0 ..< match.numberOfRanges)
                .compactMap { Range(match.range(at: $0), in: string) }
                .map { string[$0] }
        }
    }
}
