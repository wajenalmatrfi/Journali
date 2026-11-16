//
//  JournalViewModel.swift
//  Journali
//

import Foundation
import Combine
import SwiftData

/// The brain of the main screen: reads and changes journals in the database.
@MainActor
final class JournalViewModel: ObservableObject {

    // MARK: - State

    /// All journals, newest first. Views can read it but not change it.
    @Published private(set) var journals: [Journal] = []

    /// The connection to the database. Set once by ``configure(with:)``.
    private var modelContext: ModelContext?

    // MARK: - Setup

    /// Connects the view model to the database and loads the journals.
    /// Call this once when the screen appears.
    func configure(with context: ModelContext) {
        guard modelContext == nil else { return }
        modelContext = context
        fetch()
    }

    // MARK: - Actions
    /// Adds a new journal to the database.
    func add(_ journal: Journal) {
        modelContext?.insert(journal)
        save()
    }

    /// Saves an edited journal.
    /// The editor already changed the journal itself, so this only saves.
    func update(_ journal: Journal) {
        save()
    }

    /// Removes a journal from the database.
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
