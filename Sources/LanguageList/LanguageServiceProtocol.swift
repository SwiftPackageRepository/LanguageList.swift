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
import ISO639

public protocol LanguageServiceProtocol {
    func load(identifier: String, initial: ISO639Alpha1?, enabled: [ISO639Alpha1]?)
    func load(identifier: String)
    
    func selection(identifier: String, initial: ISO639Alpha1?) -> Language
    func selection(identifier: String) -> Language

    var selections: CurrentValueSubject<[String:Language], Never> { get }
    var enabledLanguages: CurrentValueSubject<[String:[Language]], Never> { get }

    func set(_ language: Language, for identifier: String)
    func set(_ alpha1Code: ISO639Alpha1, for identifier: String)
}
