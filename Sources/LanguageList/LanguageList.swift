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


#if os(iOS) || os(tvOS)

import ISO639
import SwiftUI

public struct LanguageList: View, Equatable, Identifiable {

    @ObservedObject var listModel: LanguageListModel

    public var id = UUID()
    internal var selected: ((Language) -> Void)?

    public init(identifier: String, style: LanguageRowStyle, initial: ISO639Alpha1, enabled: [ISO639Alpha1], selected: @escaping (Language) -> Void) {
        self.listModel = LanguageListModel(identifier: identifier, style: style, initial: initial, enabled: enabled)
        self.selected = selected
    }

    public init(identifier: String, style: LanguageRowStyle, selected: @escaping (Language) -> Void) {
        self.listModel = LanguageListModel(identifier: identifier, style: style)
        self.selected = selected
    }

    public init(style: LanguageRowStyle, selected: @escaping (Language) -> Void) {
        self.listModel = LanguageListModel(style: style)
        self.selected = selected
    }

    public init(_ listModel: LanguageListModel, selected: @escaping (Language) -> Void) {
        self.listModel = listModel
        self.selected = selected
    }

    @ViewBuilder
    private func languageRow(for rowModel: LanguageRowModel) -> some View {
        LanguageRow(
            rowModel: rowModel,
            action: {
                selected?(rowModel.language)
            })
            .padding(0)
            .clipShape(Rectangle())
    }

    @ViewBuilder
    public var body: some View {
        List() {
            ForEach(listModel.rows, id: \.self) { row in
                languageRow(for: row)
            }
        }
        .id(id)
    }

    public static func == (lhs: LanguageList, rhs: LanguageList) -> Bool {
        return lhs.listModel == rhs.listModel
    }
}


#if DEBUG

struct LanguageList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LanguageList(style: .localizedAndOfficial) { language in
            }
            LanguageList(style: .officialAndName) { language in
            }
            .environment(\.colorScheme, .light)
            LanguageList(style: .official) { language in
            }
            .environment(\.colorScheme, .dark)
            LanguageList(style: .localized) { language in
            }
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            NavigationView {
                LanguageList(style: .localizedAndOfficial) { language in
                }
            }
        }
    }
}

#endif


#endif
