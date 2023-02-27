//
//  OptionSet.swift
//  
//
//  Created by Alsey Coleman Miller on 2/27/23.
//

extension OptionSet where Self: Hashable, Self.Element == Self {
    
    func description(_ allCases: [Self: String]) -> String {
        "[" + allCases
            .lazy
            .filter { self.contains($0.key) }
            .reduce("", { $0 + ($0.isEmpty ? "" : ", ") + "." + $1.value })
        + "]"
    }
}
