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
import SwiftUIPlus

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
        background: AppTheme.treasureChest.colors.list.background,
        primary: AppTheme.treasureChest.colors.label.primary,
        secondary: AppTheme.treasureChest.colors.label.tertiary,
        selected: AppTheme.treasureChest.colors.list.selected,
        rows: AppTheme.treasureChest.colors.list.rows
    )

    static let navigationBar = Component(
        foreground: AppTheme.treasureChest.colors.navigationBar.foreground,
        background: AppTheme.treasureChest.colors.navigationBar.background
    )

    #if os(macOS)

    static let background = AppTheme.treasureChest.colors.background.primary
    static let navigationBarBackground = AppTheme.treasureChest.colors.navigationBar.background
    static let separator = AppTheme.treasureChest.colors.list.separator
    static let alternatingContentBackgroundColors = AppTheme.treasureChest.colors.list.rows

    #elseif os(tvOS)

    static let background = AppTheme.treasureChest.colors.background.primary
    static let navigationBarBackground = AppTheme.treasureChest.colors.navigationBar.background
    static let separator = AppTheme.treasureChest.colors.list.separator
    static let alternatingContentBackgroundColors = AppTheme.treasureChest.colors.list.rows

    #else

    static let background = AppTheme.treasureChest.colors.background.primary
    static let navigationBarBackground = AppTheme.treasureChest.colors.navigationBar.background
    static let separator = AppTheme.treasureChest.colors.list.separator
    static let alternatingContentBackgroundColors = AppTheme.treasureChest.colors.list.rows

    #endif
}
