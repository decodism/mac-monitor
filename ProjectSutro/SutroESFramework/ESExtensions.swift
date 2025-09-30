//
//  ESExtensions.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 2/15/25.
//

import Foundation


extension es_string_token_t {
    func toString() -> String? {
        guard length > 0 else { return nil }
        return String(cString: data)
    }
}

func sha256HexString(_ digest: es_sha256_t) -> String {
    withUnsafeBytes(of: digest) { rawBuf in
        rawBuf.map { String(format: "%02x", $0) }.joined()
    }
}

func cdhashToString(cdhash: es_cdhash_t) -> String {
    withUnsafeBytes(of: cdhash) { $0.map { String(format: "%02x", $0) }.joined() }
}
