//
//  Journal.swift
//  Journali
//

import Foundation
import SwiftData

// MARK: - Journal

/// One journal entry, saved on the device with SwiftData.
@Model
final class Journal {

    /// A unique id that never changes, even when the journal is edited.
    @Attribute(.unique) var id: UUID
    var title: String
    var content: String
    var date: Date
    var isBookmarked: Bool

    /// Creates a journal. Only the title and content are required.
    init(
        id: UUID = UUID(),
        title: String,
        content: String,
        date: Date = .now,
        isBookmarked: Bool = false
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.date = date
        self.isBookmarked = isBookmarked
    }
}

// MARK: - Sort Option

/// The ways the journals list can be sorted.
enum SortOption {
    case bookmark
    case date
}
