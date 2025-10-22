//
//  String+Ext.swift
//  Helpers
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
import CryptoKit

public extension String {
    func MD5() -> String {
        let digest = Insecure.MD5.hash(data: Data(self.utf8))
        return digest.map {
            String(format: "%02hhx", $0)
        }
        .joined()
    }
}
