import SwiftUI

/// All notes with filters (place, date, type)
struct NotesListView: View {
    let env: AppEnvironment

    @State private var notes: [Note] = []
    @State private var placeFilter = ""
    @State private var isLoading = false

    var body: some View {
        List {
            Section("Filters") {
                TextField("Filter by place", text: $placeFilter)
                    .textContentType(.addressCity)
            }

            Section("Notes") {
                if notes.isEmpty {
                    Text("No notes")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(notes) { note in
                        NavigationLink {
                            NoteDetailView(note: note, env: env)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(note.content)
                                    .lineLimit(2)
                                HStack {
                                    if let place = note.placeName {
                                        Text(place)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Text(note.createdAt, style: .relative)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("All Notes")
        .task { await loadNotes() }
        .onChange(of: placeFilter) { _, _ in
            Task { await loadNotes() }
        }
        .onChange(of: env.notesVersion) { _, _ in
            Task { await loadNotes() }
        }
    }

    private func loadNotes() async {
        isLoading = true
        defer { isLoading = false }
        do {
            if placeFilter.isEmpty {
                notes = try await env.noteRecallService.recentNotes(limit: 100)
            } else {
                notes = try await env.noteRecallService.notes(byPlace: placeFilter)
            }
        } catch {
            notes = []
        }
    }
}
