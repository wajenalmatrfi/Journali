//
//  JournalViewModel.swift
//  Journali
//
//  Created by WajenN on 01/06/1448 AH.
//

import Foundation
import Combine
import SwiftData

/// The brain of the main screen: reads, filters, sorts, and changes journals.
@MainActor
final class JournalViewModel: ObservableObject {

    // MARK: - State

    /// All journals from the database, newest first.
    @Published private(set) var journals: [Journal] = []

    /// What the person typed in the search bar.
    @Published var searchText = ""

    /// How the list is sorted.
    @Published var sortOption: SortOption = .date

    /// The connection to the database. Set once by ``configure(with:)``.
    private var modelContext: ModelContext?

    // MARK: - What the screen shows

    /// The journals to show: filtered by search, then sorted.
    var visibleJournals: [Journal] {
        // Keep only journals whose title or text contains the search words.
        let filtered = searchText.isEmpty
            ? journals
            : journals.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }

        switch sortOption {
        case .date:
            return filtered.sorted { $0.date > $1.date }
        case .bookmark:
            // Bookmarked first, the rest below; newest first inside each group.
            return filtered.sorted {
                if $0.isBookmarked != $1.isBookmarked { return $0.isBookmarked }
                return $0.date > $1.date
            }
        }
    }

    // MARK: - Setup

    /// Connects to the database and loads the journals. Call once when the screen appears.
    func configure(with context: ModelContext) {
        guard modelContext == nil else { return }
        modelContext = context
        fetch()
    }

    // MARK: - Actions

    /// Adds a new journal.
    func add(_ journal: Journal) {
        modelContext?.insert(journal)
        save()
    }

    /// Saves an edited journal. The editor already changed it, so this only saves.
    func update(_ journal: Journal) {
        save()
    }

    /// Removes a journal.
    func delete(_ journal: Journal) {
        modelContext?.delete(journal)
        save()
    }

    /// Bookmarks a journal, or removes its bookmark.
    func toggleBookmark(_ journal: Journal) {
        journal.isBookmarked.toggle()
        save()
    }

    // MARK: - Database

    /// Reads all journals from the database, newest first.
    private func fetch() {
        guard let modelContext else { return }
        let descriptor = FetchDescriptor<Journal>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        journals = (try? modelContext.fetch(descriptor)) ?? []
    }

    /// Writes changes to the device, then refreshes the list.
    private func save() {
        try? modelContext?.save()
        fetch()
    }
}
