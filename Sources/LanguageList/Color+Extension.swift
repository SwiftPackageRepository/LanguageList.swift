///
/// MIT License
///
/// Copyright (c) 2022 Sascha Müllner
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
///
/// Created by Sascha Müllner on 07.01.22.


import SwiftUI

internal extension Color {
    struct Component {
        internal let foreground: Color
        internal let background: Color
    }

    struct List {
        internal let background: Color
        internal let primary: Color
        internal let secondary: Color
        internal let selected: Color
        internal let rows: [Color]
        internal func row(index: Int) -> Color {
            if rows.isEmpty {
                return background
            }
            let modulo = index % rows.count
            return rows[modulo]
        }
    }

    static let list = List(
        background: Color.background,
        primary: Color.primary,
        secondary: Color.secondary,
        selected: Color.accentColor,
        rows: Color.alternatingContentBackgroundColors
    )

    static let navigationBar = Component(
        foreground: Color.primary,
        background: Color.navigationBarBackground
    )

    #if os(macOS)

    static let background = Color(NSColor.windowBackgroundColor)
    static let navigationBarBackground = Color(NSColor.controlBackgroundColor)
    static let separator = Color(NSColor.separatorColor)
    static var alternatingContentBackgroundColors = NSColor.alternatingContentBackgroundColors.map({Color($0)})

    #elseif os(tvOS)

    static let background = Color(UIColor.systemBackground)
    static let navigationBarBackground = Color(UINavigationBar.appearance().backgroundColor ?? UIColor.systemGray)
    static let separator = Color(UIColor.separator)
    static var alternatingContentBackgroundColors = [ Color(UIColor.systemBackground) ]

    #else

    static let background = Color(UIColor.systemBackground)
    static var navigationBarBackground: Color {
        if #available(iOS 13, *) {
            return Color(UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 0.0714, green: 0.0768, blue: 0.0768, alpha: 1)
                } else {
                    return UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)
                }
            })
        } else {
            return Color(UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1))
        }
    }
    static let separator = Color(UIColor.separator)
    static var alternatingContentBackgroundColors = [ Color(UIColor.systemBackground) ]

    #endif
}
