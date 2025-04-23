import CoreMIDI
import Foundation
import Combine

class MIDIDeviceManager: ObservableObject {
    static let shared = MIDIDeviceManager()
    
    @Published var destinations: [(ref: MIDIEndpointRef, name: String)] = []
    @Published var selectedDestination: MIDIEndpointRef? {
        didSet {
            saveSelection()
        }
    }

    private var midiClient = MIDIClientRef()
    
    public var midiClientRef: MIDIClientRef {
        midiClient
    }

    public init() {
        MIDIClientCreate("MIDIDeviceManager" as CFString, nil, nil, &midiClient)
        loadSelection()
        updateDestinations()
    }

    func updateDestinations() {
        destinations.removeAll()
        let count = MIDIGetNumberOfDestinations()
        for i in 0..<count {
            let dest = MIDIGetDestination(i)
            var nameRef: Unmanaged<CFString>?
            MIDIObjectGetStringProperty(dest, kMIDIPropertyName, &nameRef)
            if let name = nameRef?.takeRetainedValue() as String? {
                destinations.append((ref: dest, name: name))
            }
        }

        if let saved = selectedDestination, destinations.contains(where: { $0.ref == saved }) {
            selectedDestination = saved
        } else {
            selectedDestination = destinations.first?.ref
        }
    }

    private func saveSelection() {
        if let dest = selectedDestination {
            UserDefaults.standard.set(Int(dest), forKey: "selectedMIDIDestination")
        }
    }

    private func loadSelection() {
        let raw = UserDefaults.standard.integer(forKey: "selectedMIDIDestination")
        if raw != 0 {
            selectedDestination = MIDIEndpointRef(raw)
        }
    }
}
