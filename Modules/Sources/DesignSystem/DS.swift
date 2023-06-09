import Foundation
import SharedExtensions
import SwiftUI

public struct DS {
    public struct Spacing {
        /// 4
        public static let xxs: CGFloat = 4
        /// 8
        public static let xs: CGFloat = 8
        /// 12
        public static let s: CGFloat = 12
        /// 16
        public static let m: CGFloat = 16
        /// 24
        public static let xm: CGFloat = 24
        /// 32
        public static let l: CGFloat = 32
        /// 64
        public static let xl: CGFloat = 64
    }
    
    public struct FontSize {
        /// 8
        public static let small8: CGFloat = 8
        /// 10
        public static let small10: CGFloat = 10
        /// 12
        public static let small12: CGFloat = 12
        /// 16
        public static let medium: CGFloat = 16
        /// 24
        public static let xm: CGFloat = 24
        // 32
        public static let l: CGFloat = 32
    }

    public struct CornerRadius {
        /// 4
        public static let xxs: CGFloat = 4
        /// 8
        public static let xs: CGFloat = 8
        /// 12
        public static let s: CGFloat = 12
        /// 16
        public static let m: CGFloat = 16
    }

    public struct Colors {
        /// Background of list and detail views
        public static let mainBackground: Color? = Color(hex: "161621")
        /// Background of rows in list
        public static let rowBackground: Color? = Color(hex: "272639")
        /// Background of topTrailing rectangle in list view to show time of the match
        public static let timeRectangle: Color? = Color(hex: "FAFAFA")
        /// White Color
        public static let white: Color = .white
        /// Placeholder image color
        public static let placeholder: Color? = Color(hex: "C4C4C4")
    }

    public struct Frame {
        
    }
}
