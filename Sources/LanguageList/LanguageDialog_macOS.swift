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

#if os(macOS)

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
        LanguageList(listModel) { language in
            selected(language)
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .navigationTitle(LanguageListModel.Localized.navigationTitle)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                SearchField(text: $listModel.searchText)
                    .frame(minWidth: 100, idealWidth: 200, maxWidth: .infinity)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button(LanguageListModel.Localized.cancel, action: {
                    canceled()
                })
                .keyboardShortcut(.cancelAction)
            }
        }
        .frame(minWidth: 320, maxWidth: .infinity, minHeight: 320, maxHeight: .infinity)
    }
}

#endif
