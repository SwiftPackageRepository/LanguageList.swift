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
import SwiftUI

public class LanguageListModel: ObservableObject, Equatable {

    private var identifier: String

    private var languages: [Language]?

    private var filterCancelables: Set<AnyCancellable> = []
    @Published public var searchText: String = ""

    public init(identifier: String) {
        self.identifier = identifier
        load()
    }

    public convenience init() {
        self.init(identifier: "language.alpha1")
    }

    deinit {
    }

    public func load() {
        LanguageService.shared.load(identifier: identifier)
        var languagesCancelable: AnyCancellable?
        languagesCancelable = LanguageService
            .shared
            .languages
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] (languages: [Language]) in
                self?.load(languages: languages)
                languagesCancelable?.cancel()
                languagesCancelable = nil
            })
    }

    public func subscribe() {
        $searchText
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
            .removeDuplicates()
            .map({ [weak self] (string) -> String? in
                if string.count < 1 {
                    self?.resetFilter()
                    return nil
                }

                return string
            })
            .compactMap { $0 }
            .sink { (_) in
                //
            } receiveValue: { [weak self] (str) in
                self?.filter(with: str)
            }
            .store(in: &filterCancelables)
    }

    public func unsubscribe() {
        filterCancelables.forEach({ $0.cancel() })
        filterCancelables.removeAll()
    }

    @Published internal private(set) var rows: [LanguageRowModel] = []

    internal func row(for index: Int) -> LanguageRowModel? {
        return rows[safe: index]
    }
    
    private func load(languages: [Language]) {
        self.languages = languages
        rows = Self.rows(
            identifier: self.identifier,
            languages: languages
        )
    }

    private func resetFilter() {
        guard let languages = self.languages else { return }
        guard rows.count != languages.count else { return }
        rows = Self.rows(
            identifier: self.identifier,
            languages: languages
        )
    }

    private func filter(with searchText: String) {
        guard let languages = self.languages else { return }
        let filteredLanguages = filter(with: searchText, languages: languages)
        rows = Self.rows(
            identifier: self.identifier,
            languages: filteredLanguages
        )
    }

    private func filter(with searchText: String, languages: [Language]) -> [Language] {
        if searchText.isEmpty == false {
            return languages.filter {
                $0.official.range(of: searchText, options: .caseInsensitive) != nil
                    || $0.name.range(of: searchText, options: .caseInsensitive) != nil
                    || $0.alpha1.rawValue.range(of: searchText, options: .caseInsensitive) != nil
                    || $0.alpha2.rawValue.range(of: searchText, options: .caseInsensitive) != nil
            }
        } else {
            return languages
        }
    }

    private static func rows(identifier: String, languages: [Language]) -> [LanguageRowModel] {
        let rows = languages.map { (language) -> LanguageRowModel in
            LanguageRowModel(
                identifier: identifier,
                language: language
            )
        }
        return rows
    }

    public static func == (lhs: LanguageListModel, rhs: LanguageListModel) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.searchText == rhs.searchText
    }

    // MARK: Localization
    public struct Localized {
        static let cancel = NSLocalizedString("Cancel", comment: "DialogCancel: e.g. Cancel")
        static let navigationTitle = NSLocalizedString("Language", comment: "LanguageViewNavigationTitle: e.g. Language")
    }
}

#if DEBUG

internal class MockLanguageListModel: LanguageListModel {

    init() {
        super.init(identifier: "language.alpha1")
    }

    override var rows: [LanguageRowModel] {
        return [
            LanguageRowModel.english,
            LanguageRowModel.french,
            LanguageRowModel.german
        ]
    }
}

#endif
