import SwiftUI
import CoreMIDI

struct MIDISettingsView: View {
    @ObservedObject var deviceManager = MIDIDeviceManager.shared

    var body: some View {
        Form {
            Section(header: Text("MIDI Output")) {
                Picker("Destination", selection: $deviceManager.selectedDestination) {
                    ForEach(deviceManager.destinations, id: \.ref) { dest in
                        Text(dest.name).tag(dest.ref as MIDIEndpointRef?)
                    }
                }
                Button("Refresh") {
                    deviceManager.updateDestinations()
                }
            }
        }
        .navigationTitle("MIDI Settings")
    }
}
