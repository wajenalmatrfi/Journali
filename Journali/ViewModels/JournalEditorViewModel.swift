//
//  JournalEditorViewModel.swift
//  Journali
//
//  Created by WajenN on 06/06/1448 AH.
//

import Foundation
import Combine

/// Holds the text being written in the editor and decides how to save it.
/// Use one instance per editor screen. Pass `nil` to write a new journal,
/// or pass an existing ``Journal`` to edit it.
@MainActor
final class JournalEditorViewModel: ObservableObject {
    /// The title the person is typing. The body text the person is typing.
    @Published var title: String
    @Published var content: String
    
    /// The journal being edited, or `nil` when writing a new one.
    private let original: Journal?

    /// Creates an editor for a new journal, or for an existing one. - Parameter journal: The journal to edit. Leave it `nil` to start empty.
    init(journal: Journal? = nil) {
            original = journal
            title = journal?.title ?? ""
            content = journal?.content ?? ""
        }

    
    // MARK: - Rules

    /// The date to show: the journal's own date, or today for a new one.
        var date: Date {
            original?.date ?? .now
        }
    /// Whether the journal can be saved.
       ///
       /// A title made of spaces only doesn't count.
       var canSave: Bool {
           !title.trimmingCharacters(in: .whitespaces).isEmpty
       }
    /// Whether the person changed anything since the editor opened.
    var hasChanges: Bool {
        title != (original?.title ?? "") || content != (original?.content ?? "")
    }
    // MARK: - Build

        /// Returns the journal to save.
        ///
        /// When editing, it keeps the same `id`, date, and bookmark so the list
        /// replaces the old journal instead of adding a second one.
        ///
        /// - Returns: The edited journal, or a brand new one.
    /// Returns the journal to save: the edited one, or a brand new one.
    func makeJournal() -> Journal {
        if let existing = original {
            // Journal is a class, so this changes the saved journal itself.
            existing.title = title
            existing.content = content
            return existing
        }
        return Journal(title: title, content: content)
    }
    }
