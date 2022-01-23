import SwiftUI
import ISO639
import LanguageList

struct ContentView: View {
    @State var showSheet = false
    @State var language: Language?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Current Selection:")
                Button(language?.official ?? "none") {
                    showSheet.toggle()
                }
            }
            .padding()
            LanguageList { language in
               self.language = language
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .sheet(isPresented: $showSheet) {
            LanguageDialog { language in
                self.language = language
                showSheet = false
            } canceled: {
                showSheet = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
