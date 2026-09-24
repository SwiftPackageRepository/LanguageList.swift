#if DEBUG

internal class MockLanguageListModel: LanguageListModel {
    override var rows: [LanguageRowModel] {
        [
            LanguageRowModel.english,
            LanguageRowModel.french,
            LanguageRowModel.german
        ]
    }
}

#endif
