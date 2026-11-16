//
//  MainView.swift
//  Journali
//
//  Created by WajenN on 30/05/1448 AH.
//

import SwiftUI
import SwiftData

/// The home screen: shows the journals, or an empty state when there are none.
struct MainView: View {

    // MARK: - Properties

    /// The app's brain for the journals list.
    @StateObject private var viewModel = JournalViewModel()

    /// The database connection, provided by `.modelContainer` in JournaliApp.
    @Environment(\.modelContext) private var modelContext

    /// Whether the editor is open for writing a new journal.
    @State private var isShowingEditor = false

    /// The journal being edited. When it isn't `nil`, the editor opens filled with it.
    @State private var journalToEdit: Journal?

    /// The journal waiting for delete confirmation.
    @State private var journalToDelete: Journal?

    /// Whether the "Delete Journal?" alert is showing.
    @State private var isShowingDeleteAlert = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            // Group lets every state share the same modifiers below.
            Group {
                if viewModel.journals.isEmpty {
                    EmptyStateView()
                } else if viewModel.visibleJournals.isEmpty {
                    // There are journals, but none match the search.
                    ContentUnavailableView.search(text: viewModel.searchText)
                } else {
                    List(viewModel.visibleJournals) { journal in
                        JournalCardView(journal: journal) {
                            viewModel.toggleBookmark(journal)
                        }
                        .onTapGesture {
                            journalToEdit = journal
                        }
                        // Swipe left to reveal the red trash button, like the design.
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                journalToDelete = journal
                                isShowingDeleteAlert = true
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                            .tint(Color(.destructive))
                            .accessibilityLabel("Delete")
                        }
                        // Remove the default List styling to match the design.
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.backgroundPrimary))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Journal")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(Color(.textPrimary))
                        .fixedSize()
                }
                // Keep the title as plain text, without a glass capsule.
                .sharedBackgroundVisibility(.hidden)

                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Sort by Bookmark") { viewModel.sortOption = .bookmark }
                        Button("Sort by Entry Date") { viewModel.sortOption = .date }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingEditor = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search")
            // New journal: the editor starts empty.
            .sheet(isPresented: $isShowingEditor) {
                JournalEditorView(viewModel: JournalEditorViewModel()) { journal in
                    viewModel.add(journal)
                }
            }
            // Edit journal: the editor starts filled with the tapped journal.
            .sheet(item: $journalToEdit) { journal in
                JournalEditorView(viewModel: JournalEditorViewModel(journal: journal)) { updated in
                    viewModel.update(updated)
                }
            }
            // Delete: ask first, because it can't be undone.
            .alert("Delete Journal?", isPresented: $isShowingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let journal = journalToDelete {
                        viewModel.delete(journal)
                    }
                }
            } message: {
                Text("Are you sure you want to delete this journal?")
            }
        }
        .preferredColorScheme(.dark)
        // Hand the database connection to the view model, then load the journals.
        .onAppear {
            viewModel.configure(with: modelContext)
        }
    }
}

// MARK: - Empty State

/// Shown when there are no journals yet.
private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(.emptyStateIllustration)
                .resizable()
                .scaledToFit()
                .frame(width: 140)

            Text("Begin Your Journal")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(.textAccent))

            Text("Craft your personal diary, tap the plus icon to begin")
                .font(.system(size: 18, weight: .light))
                .foregroundStyle(Color(.textPrimary))
                .multilineTextAlignment(.center)
        }
        // Narrows the text so the line breaks like the design.
        .padding(.horizontal, 56)
    }
}

// MARK: - Journal Card

/// One journal in the list: title, date, bookmark, and text.
private struct JournalCardView: View {
    let journal: Journal

    /// Called when the bookmark icon is tapped.
    let onToggleBookmark: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(journal.title)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(Color(.textAccent))

                    Text(journal.date.formatted(date: .numeric, time: .omitted))
                        .font(.system(size: 14))
                        .foregroundStyle(Color(.textSecondary))
                }

                Spacer()

                Button(action: onToggleBookmark) {
                    Image(systemName: journal.isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 22))
                        .foregroundStyle(Color(.textAccent))
                }
                // Keeps the tap on the icon only, so it doesn't open the editor.
                .buttonStyle(.plain)
                .accessibilityLabel(journal.isBookmarked ? "Remove bookmark" : "Bookmark")
            }

            Text(journal.content)
                .font(.system(size: 18))
                .foregroundStyle(Color(.textPrimary))
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.surfaceCard), in: .rect(cornerRadius: 28))
    }
}
