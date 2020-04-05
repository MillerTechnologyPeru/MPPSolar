//
//  Bool.swift
//  
//
//  Created by Alsey Coleman Miller on 4/5/20.
//

internal extension Bool {
    
    init?(solar character: Character) {
        switch character {
        case "0": self = false
        case "1": self = true
        default: return nil
        }
    }
}
