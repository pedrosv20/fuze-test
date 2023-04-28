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
        self.font(Font.custom("", fixedSize: <#T##CGFloat#>))
    }
}
