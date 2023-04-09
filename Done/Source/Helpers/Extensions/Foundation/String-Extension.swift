//
//  String-Extension.swift
//  Done
//
//  Created by Mazhar Hussain on 5/30/22.
//

import Foundation

extension String {

    var localized: String {
        return self.localize()
    }

    var notEmpty: Bool {
        return !self.isEmpty
    }

    func localize(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }

    func floatValue() -> Float {
        return Float(self.replacingOccurrences(of: ",", with: ""))!
    }

    func intValue() -> Int {
        return Int(self) ?? 0
    }

    func doubleValue() -> Double {
        if let value = (self as NSString?)?.doubleValue {
            return value
        }
        return 0.0
    }

    func asData() -> Data {
        return String(self).data(using: .utf8) ?? Data()
    }

    func caseInsensitiveEqual(to other: String) -> Bool {
        return self.localizedCaseInsensitiveCompare(other) == .orderedSame
    }

    func byReplacingDoubleQuotes() -> String {
        // replacing latin char of double quotes with standard double quotes using escape sequence
        return self.replacingOccurrences(of: "”", with: "\"")
    }

    /// A function that removes leading and trailing white space characters from the string
    /// - Returns: Updated string without white space characters
    func byRemovingWhiteSpaces() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func containsValue(_ value: String) -> Bool {
        return self.localizedCaseInsensitiveContains(value)
    }
    
    
    // MARK: - RegexType
    enum RegexType {
        case none
        case mobileNumberWithItalianCode    // Example: "+39 3401234567"
        case email                          // Example: "foo@example.com"
        case minLetters(_ letters: Int)     // Example: "Al"
        case minDigit(_ digits: Int)        // Example: "0612345"
        case onlyLetters                    // Example: "ABDEFGHILM"
        case onlyNumbers                    // Example: "132543136"
        case noSpecialChars                 // Example: "Malago'": OK - "Malagò": KO
        
        fileprivate var pattern: String {
            switch self {
            case .none:
                return ""
            case .mobileNumberWithItalianCode:
                return #"^(\+39 )\d{9,}$"#
            case .email:
                return #"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$"#
            case .minLetters(let letters):
                return #"^\D{"# + "\(letters)" + #",}$"#
            case .minDigit(let digits):
                return #"^(\d{"# + "\(digits)" + #",}){1}$"#
            case .onlyLetters:
                return #"^[A-Za-z]+$"#
            case .onlyNumbers:
                return #"^[0-9]"#
            case .noSpecialChars:
                return #"^[A-Za-z0-9\s+\\\-\/?:().,']+$"#
            }
        }
    }
    
    // MARK: - Validation
    /// Perform a regex falidation of the string
    /// - Parameter regexType: enum type of the regex to use
    /// - Returns: the result of the test
    func isValidWith(regexType: RegexType) -> Bool {
        
        switch regexType {
        case .none : return true
        default    : break
        }
        
        let pattern = regexType.pattern
        guard let gRegex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        
        let range = NSRange(location: 0, length: self.utf16.count)
        
        if gRegex.firstMatch(in: self, options: [], range: range) != nil {
            return true
        }
        
        return false
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
