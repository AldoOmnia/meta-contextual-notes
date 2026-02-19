import SwiftUI
import MapKit
import CoreLocation

/// View/edit note, triggers, location on map
struct NoteDetailView: View {
    let note: Note
    let env: AppEnvironment

    var body: some View {
        List {
            Section("Content") {
                Text(note.content)
            }

            Section("Context") {
                LabeledContent("Created", value: note.createdAt.formatted())
                if let place = note.placeName {
                    LabeledContent("Place", value: place)
                }
                if let lat = note.latitude, let lon = note.longitude {
                    LabeledContent("Location", value: String(format: "%.4f, %.4f", lat, lon))
                    Map(initialPosition: .region(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ))) {
                        Marker("Note", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                    }
                    .frame(height: 150)
                }
            }

            if let trigger = note.trigger, trigger.type != .none {
                Section("Trigger") {
                    Text(trigger.type.rawValue.capitalized)
                    if let place = trigger.placeName {
                        Text(place)
                    }
                    if let fireAt = trigger.fireAt {
                        Text(fireAt.formatted())
                    }
                }
            }
        }
        .navigationTitle("Note")
    }
}
