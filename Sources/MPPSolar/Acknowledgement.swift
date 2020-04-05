//
//  Acknowledgement.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

/// MPP Solar ACK
public enum Acknowledgement: String, ResponseProtocol {
    
    case acknowledged = "ACK"
    case notAcknowledged = "NAK"
}
