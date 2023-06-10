//
//  String.swift
//  CryptoAppSwiftUI
//
//  Created by MacBook Air on 06.06.2023.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>",
                                         with: "",
                                         options: .regularExpression,
                                         range: nil)
    }
}
