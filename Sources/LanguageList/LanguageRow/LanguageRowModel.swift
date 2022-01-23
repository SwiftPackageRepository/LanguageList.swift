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

import Combine
import Foundation
import ISO639

internal class LanguageRowModel: ObservableObject, Identifiable, Hashable, Equatable {

    public var id = UUID()
    internal let identifier: String
    internal let language: Language
    @Published var title: String
    @Published var subtitle: String?
    @Published var style: LanguageRowStyle
    @Published var isSelected: Bool = false

    private var selectionCancelable: AnyCancellable?

    public convenience init(identifier: String, language: Language) {
        self.init(identifier: identifier, language: language, style: .officialAndName)
    }

    public  init(identifier: String, language: Language, style: LanguageRowStyle) {    self.identifier = identifier
        self.language = language
        self.style = style
        switch style {
            case .official:
                self.title = language.official.capitalized
            case .name:
                self.title = language.name.capitalized
            case .officialAndName:
                self.title = language.official.capitalized
                self.subtitle = language.name.capitalized
        }
        self.subscribe()
    }

    deinit {
        unsubscribe()
    }

    func update() {
        self.title = language.official.localizedCapitalized

    }

    func select() {
        LanguageService.shared.set(language, for: identifier)
    }

    private func subscribe() {
        selectionCancelable = LanguageService
            .shared
            .selections
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] (selections: [String:Language]) in
                guard let identifier = self?.identifier else { return }
                guard let language = self?.language else { return }
                if selections.contains(where: { $0.key == identifier }),
                   let selection = selections[identifier],
                   selection == language {
                    self?.isSelected = true
                } else {
                    self?.isSelected = false
                }
            })
    }

    private func unsubscribe() {
        selectionCancelable?.cancel()
        selectionCancelable = nil
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: LanguageRowModel, rhs: LanguageRowModel) -> Bool {
        lhs.language == rhs.language && lhs.isSelected == rhs.isSelected
    }
}

#if DEBUG

extension LanguageRowModel {
    static var english: LanguageRowModel {
        LanguageRowModel(
            identifier: UUID().uuidString,
            language: Language.from(with: .en)!
        )
    }
    static var french: LanguageRowModel {
        LanguageRowModel(
            identifier: UUID().uuidString,
            language: Language.from(with: .fr)!
        )
    }
    static var german: LanguageRowModel {
        LanguageRowModel(
            identifier: UUID().uuidString,
            language: Language.from(with: .de)!
        )
    }
}

#endif
