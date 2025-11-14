//
//  NumberFormatter.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 07. 12..
//

import Foundation

struct NumberFormatterHelper {
    
    static func format(_ value: Double, maximumFractionDigits: Int = 1) -> String {
        let absValue = abs(value)
        let sign = value < 0 ? "-" : ""
        
        let formatted: String
        switch absValue {
        case 1_000_000_000...:
            formatted = formatValue(value / 1_000_000_000, suffix: "B", digits: maximumFractionDigits)
        case 1_000_000...:
            formatted = formatValue(value / 1_000_000, suffix: "M", digits: maximumFractionDigits)
        case 1_000...:
            formatted = formatValue(value / 1_000, suffix: "K", digits: maximumFractionDigits)
        default:
            formatted = formatValue(value, suffix: "", digits: maximumFractionDigits)
        }
        
        return sign + formatted
    }

    private static func formatValue(_ number: Double, suffix: String, digits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = digits
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
        return (formatter.string(from: NSNumber(value: number)) ?? "\(number)") + suffix
    }
}
