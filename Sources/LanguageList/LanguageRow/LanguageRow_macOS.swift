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

import SwiftUI
import ISO639

internal struct LanguageRow: View, Equatable {

    let action: () -> Void
    @ObservedObject var rowModel: LanguageRowModel

    public init(rowModel: LanguageRowModel, action: @escaping () -> Void) {
        self.rowModel = rowModel
        self.action = action
    }

    @ViewBuilder
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(rowModel.title)
                    .foregroundColor(Color.list.primary)
                    .fontWeight(.light)
                    .font(.headline.bold())
                if let subtitle = rowModel.subtitle {
                    Text(subtitle)
                        .foregroundColor(Color.list.secondary)
                        .fontWeight(.light)
                        .font(.caption)
                }
            }
            Spacer()
            if rowModel.isSelected {
                Image(systemName: "checkmark")
                    .imageScale(.medium)
                    .font(Font.system(.body).bold())
                    .foregroundColor(.accentColor)
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(Rectangle())
        .contentShape(Rectangle())
        .onTapGesture {
            rowModel.select()
            action()
        }
        .id(rowModel.language.id)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(rowModel.language.id)
    }

    public static func == (lhs: LanguageRow, rhs: LanguageRow) -> Bool {
        return lhs.rowModel == rhs.rowModel
    }
}

#if DEBUG

struct LanguageRow_Previews: PreviewProvider {
    static var previews: some View {
        LanguageRow(
            rowModel: LanguageRowModel.english,
            action: {

        })
    }
}

#endif

#endif
