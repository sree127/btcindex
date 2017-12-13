//
//  Authentication.swift
//  BTCIndex
//
//  Created by Sreejith N on 13/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

import Foundation
import CryptoSwift

/// Authentication
/// Computes the digest value --> HMAC
/// Uses CryptoSwift for HMAC computation
/// Inital payload created using timestamp in epoch & the public key
/// Public Key and Secret Key are defined in Constants
/// Ultimately the signature header is created using the digest and the payload

class Authentication {
    
    private var timeStamp: Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    private var publicKey: String {
        return Constants.Keys.publicKey
    }
    
    private var secretKey: String {
        return Constants.Keys.secretkey
    }
    
    private var payload: String {
        return String(timeStamp) + "." + publicKey
    }
    
    private var digest: String {
        let hmac: Array<UInt8> = try! HMAC(key: secretKey, variant: .sha256).authenticate([UInt8](payload.utf8))
        return hmac.toHexString()
    }
    
    var signatureHeader: String {
        return payload + "." + digest
    }
} 
