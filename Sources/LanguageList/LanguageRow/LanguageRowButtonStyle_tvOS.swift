#if os(tvOS)

import SwiftUI

struct LanguageRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(2)
    }
}

#endif
