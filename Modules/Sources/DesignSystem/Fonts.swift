//
//  File.swift
//
//
//  Created by Pedro Vargas on 28/04/23.
//

import Foundation
import SwiftUI

public extension SwiftUI.Text {
    func setCustomFontTo(_ customFont: CustomFont) -> Self {
        switch customFont {
            case let .regular(size: size):
                return self.font(Font.custom("Roboto-Regular", fixedSize: size))
            case let .bold(size: size):
                return self.font(Font.custom("Roboto-Bold", fixedSize: size))
        }
    }
}

public enum CustomFont {
    case regular(size: CGFloat)
    case bold(size: CGFloat)
}
