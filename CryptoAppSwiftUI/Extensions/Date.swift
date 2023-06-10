//
//  Date.swift
//  CryptoAppSwiftUI
//
//  Created by MacBook Air on 06.06.2023.
//

import Foundation

extension Date {
    init(coinGekoString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinGekoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
}
