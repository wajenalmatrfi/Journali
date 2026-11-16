//
//  JournalEditorView.swift
//  Journali
//
//  Created by WajenN on 05/06/1448 AH.
//

import SwiftUI

struct JournalEditorView: View {
    @Environment(\.dismiss) private var dismiss

    /// The editor's brain: holds the text and builds the journal to save.
    @StateObject var viewModel: JournalEditorViewModel

    /// Called with the finished journal when the person taps ✓.
    let onSave: (Journal) -> Void
    /// Whether the "discard changes?" question is showing.
    @State private var isShowingDiscardDialog = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {
                TextField("Title", text: $viewModel.title)
                    .font(.system(size: 34, weight: .bold))

                Text(viewModel.date.formatted(date: .numeric, time: .omitted))
                    .font(.system(size: 14))
                    .foregroundStyle(Color(.textSecondary))

                TextField(
                    "Type your thoughts...",
                    text: $viewModel.content,
                    axis: .vertical
                )
                .font(.system(size: 18))
                .padding(.top, 12)

                Spacer()
            }
            .padding(.horizontal, 20)

            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        // Only ask when there's something to lose.
                        if viewModel.hasChanges {
                            isShowingDiscardDialog = true
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .confirmationDialog(
                        "Are you sure you want to discard changes on this journal?",
                        isPresented: $isShowingDiscardDialog,
                        titleVisibility: .visible
                    ) {
                        Button("Discard Changes", role: .destructive) {
                            dismiss()
                        }
                        Button("Keep Editing") {}
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        // Hand the journal back first, then close the screen.
                        onSave(viewModel.makeJournal())
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    // Uses the app's AccentColor for the purple glass look.
                    .buttonStyle(.glassProminent)
                    .disabled(!viewModel.canSave)
                }

            }
            // Don't let a swipe down throw away unsaved changes.
            .interactiveDismissDisabled(viewModel.hasChanges)

        }
        .preferredColorScheme(.dark)
    }
}


