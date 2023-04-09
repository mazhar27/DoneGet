//
//  UIFont-Extension.swift
//  Done
//
//  Created by Mazhar Hussain on 6/9/22.
//

import Foundation
import UIKit

extension UIFont {

    public enum PoppinsType: String {
        case semibold = "-Semibold"
        case regular = "-Regular"
        case light = "-Light"
        case bold = "-Bold"
    }

    static func Poppins(_ type: PoppinsType = .regular, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "Poppins\(type.rawValue)", size: size)!
    }

    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }

    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }

}
