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

#if os(iOS)

import SwiftUI
import ISO639

internal struct LanguageRow: View, Equatable {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let action: () -> Void
    @ObservedObject var rowModel: LanguageRowModel

    public init(rowModel: LanguageRowModel, action: @escaping () -> Void) {
        self.rowModel = rowModel
        self.action = action
    }

    @ViewBuilder
    public var body: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(rowModel.title)
                    .foregroundColor(Color.list.primary)
                    .font(.body.weight(rowModel.isSelected ? .semibold : .medium))
                if let subtitle = rowModel.subtitle {
                    Text(subtitle)
                        .foregroundColor(Color.list.secondary)
                        .font(.subheadline)
                }
            }
            Spacer()
            if rowModel.isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundColor(.accentColor)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            rowModel.isSelected
                ? Color.accentColor.opacity(0.1)
                : Color.clear,
            in: RoundedRectangle(cornerRadius: 14, style: .continuous)
        )
        .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .padding(.horizontal, 12)
        .animation(reduceMotion ? nil : .smooth(duration: 0.2), value: rowModel.isSelected)
        .onTapGesture {
            rowModel.select()
            action()
        }
        .id(rowModel.language.id)
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
