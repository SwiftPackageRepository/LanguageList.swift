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

public class LanguageService: LanguageServiceProtocol {

    public private(set) static var shared = LanguageService()

    private init() {
    }

    public private(set) var selections = CurrentValueSubject<[String:Language], Never>([:])
    public private(set) var enabledLanguages = CurrentValueSubject<[String:[Language]], Never>([:])

    deinit {
    }

    public func load(identifier: String, initial: ISO639Alpha1?, enabled: [ISO639Alpha1]?) {
        if selections.value[identifier] == nil {
            var selections = selections.value
            selections[identifier] = selection(identifier: identifier, initial: initial)
            self.selections.send(selections)
        }
        if enabledLanguages.value[identifier] == nil {
            if let languages = enabled?.languages {
                var enabledLanguages = enabledLanguages.value
                enabledLanguages[identifier] = languages
                self.enabledLanguages.send(enabledLanguages)
            } else {
                var enabledLanguages = enabledLanguages.value
                enabledLanguages[identifier] = Language.all
                self.enabledLanguages.send(enabledLanguages)
            }
        }
    }

    public func load(identifier: String) {
        load(identifier: identifier, initial: nil, enabled: nil)
    }

    public func selection(identifier: String, initial: ISO639Alpha1?) -> Language {
        if selections.value.contains(where: { $0.key == identifier }),
            let selection = selections.value[identifier] {
            return selection
        } else if let alpha1 = UserDefaults.standard.string(forKey: identifier),
           let language = Language.from(with: alpha1) {
            return language
        } else if let initial = initial,
                  let language = Language.from(with: initial) {
            return language
        } else if let language = Language.from(with: Locale.current) {
            return language
        } else {
            return Language.from(with: .en)!
        }
    }

    public func selection(identifier: String) -> Language {
        selection(identifier: identifier, initial: nil)
    }

    public func set(_ language: Language, for identifier: String) {
        var selection = selections.value
        selection[identifier] = language
        self.selections.send(selection)
        DispatchQueue.global().async {
            UserDefaults.standard.set(language.alpha1.rawValue, forKey: identifier)
        }
    }

    public func set(_ alpha1Code: ISO639Alpha1, for identifier: String) {
        guard let language = Language.from(with: alpha1Code) else { return }
        set(language, for: identifier)
    }
}
