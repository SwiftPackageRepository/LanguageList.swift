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

public struct LanguageList: View, Equatable, Identifiable {

    @ObservedObject var listModel: LanguageListModel

    public var id = UUID()
    internal var selected: ((Language) -> Void)?

    public init(identifier: String, selected: @escaping (Language) -> Void) {
        self.listModel = LanguageListModel(identifier: identifier)
        self.selected = selected
    }

    public init(selected: @escaping (Language) -> Void) {
        self.listModel = LanguageListModel()
        self.selected = selected
    }

    public init(_ listModel: LanguageListModel, selected: @escaping (Language) -> Void) {
        self.listModel = listModel
        self.selected = selected
    }

    public func enableLanguages(_ alpha1Codes: [ISO639Alpha1]) -> LanguageList {
        LanguageService.shared.enableLanguages(with: alpha1Codes)
        return self
    }

    @ViewBuilder
    public func languageRow(by index: Int) -> some View {
        if let rowModel = listModel.row(for: index) {
            LanguageRow(
                rowModel: rowModel,
                action: {
                    selected?(rowModel.language)
                })
                .frame(height: 42)
                .padding(0)
                .clipShape(Rectangle())
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    public var body: some View {
        List() {
            ForEach(listModel.rows.indices, id: \.self) { index in
                let background = Color.list.row(index: index)
                languageRow(by: index)
                    .background(background)
            }
            .listRowInsets(EdgeInsets())
        }
        .id(id)
        .onAppear {
            listModel.subscribe()
        }
        .onDisappear {
            listModel.unsubscribe()
        }
    }

    public static func == (lhs: LanguageList, rhs: LanguageList) -> Bool {
        return lhs.listModel == rhs.listModel
    }
}


#if DEBUG

struct LanguageList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LanguageList() { language in
            }
            LanguageList() { language in
            }
            .environment(\.colorScheme, .light)
            LanguageList() { language in
            }
            .environment(\.colorScheme, .dark)
            LanguageList() { language in
            }
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            NavigationView {
                LanguageList() { language in
                }
            }
        }
    }
}

#endif

#endif
