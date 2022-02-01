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

#if os(tvOS)

import ISO639
import SwiftUI
import SearchField

public struct LanguageDialog: View {

    @ObservedObject var listModel: LanguageListModel
    internal var selected: ((Language) -> Void)
    internal var canceled: (() -> Void)
    
    public init(identifier: String, defaultLanguage: Language, selected: @escaping (Language) -> Void, canceled: @escaping () -> Void) {
        self.listModel = LanguageListModel(identifier: identifier, defaultLanguage: defaultLanguage)
        self.selected = selected
        self.canceled = canceled
    }

    public init(identifier: String, selected: @escaping (Language) -> Void, canceled: @escaping () -> Void) {
        self.listModel = LanguageListModel(identifier: identifier)
        self.selected = selected
        self.canceled = canceled
    }

    public init(selected: @escaping (Language) -> Void, canceled: @escaping () -> Void) {
        self.listModel = LanguageListModel()
        self.selected = selected
        self.canceled = canceled
    }

    @ViewBuilder
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 8) {
                SearchField(text: $listModel.searchText)
                ToolbarButton {
                    Text(LanguageListModel.Localized.cancel)
                        .foregroundColor(.accentColor)
                        .font(.body)
                } action: {
                    canceled()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            LanguageList(listModel) { language in
                selected(language)
            }
            .padding(0)
        }
    }
}

#if DEBUG

struct LanguageList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LanguageList(language: .constant(Language.from(with: .en)!)) {
            }
            .environment(\.colorScheme, .light)
            LanguageList(language: .constant(Language.from(with: .en)!)) {
            }
            .environment(\.colorScheme, .dark)
            LanguageList(language: .constant(Language.from(with: .en)!)) {
            }
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            NavigationView {
                LanguageList(language: .constant(Language.from(with: .en)!)) {
                }
            }
        }
    }
}

#endif

#endif
