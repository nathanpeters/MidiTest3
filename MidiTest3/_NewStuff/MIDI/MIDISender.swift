import CoreMIDI

class MIDISender {
    private var outputPort = MIDIPortRef()
    private let deviceManager = MIDIDeviceManager.shared

    init() {
        MIDIOutputPortCreate(deviceManager.midiClientRef, "Output" as CFString, &outputPort)
    }

    func send(noteOn note: UInt8, velocity: UInt8) {
        guard let dest = deviceManager.selectedDestination else { return }

        let message: [UInt8] = [0x90, note, velocity]
        sendMessage(message, to: dest)
    }

    func send(noteOff note: UInt8, velocity: UInt8 = 0) {
        guard let dest = deviceManager.selectedDestination else { return }
        
        let message: [UInt8] = [0x80, note, velocity]
        sendMessage(message, to: dest)
    }

    private func sendMessage(_ bytes: [UInt8], to destination: MIDIEndpointRef) {
        let packetList = UnsafeMutablePointer<MIDIPacketList>.allocate(capacity: 1)
        var packet = MIDIPacketListInit(packetList)
        packet = MIDIPacketListAdd(packetList, 1024, packet, 0, bytes.count, bytes)
        MIDISend(outputPort, destination, packetList)
        packetList.deallocate()
    }
}
