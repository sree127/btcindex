//
//  Authentication.swift
//  BTCIndex
//
//  Created by Sreejith N on 13/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

import Foundation
import CryptoSwift

final class Authentication {
    
    private var timeStamp: Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    private var publicKey: String {
        return "OWE3YzJkMzlhNGIxNDllYzk1NWYwMDE1NzQ2NWM2ZTU"
    }
    
    private var secretKey: String {
        return "MmY2YTU2YTY3NDljNDFiOTkzYzY1ODY0MWQ4MzRiNTQwNjhiNTVmZDYyYTg0ZjljYWRjMWE1NGNkNjljYTViZA"
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
