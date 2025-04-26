import SwiftUI

struct MegaView: View {
    @StateObject private var synth = Synth()
    @StateObject private var model = SequenceModel()
    @StateObject private var player: SequencePlayer

    init() {
        let synth = Synth()
        _synth = StateObject(wrappedValue: synth)
        
        let sequenceModel = SequenceModel()
        _model = StateObject(wrappedValue: sequenceModel)
        
        _player = StateObject(wrappedValue: SequencePlayer(model: sequenceModel, synth: synth))
    }

    var body: some View {
        TabView {
            Tab("Sequencer", systemImage: "pianokeys") {
                ZStack {
                    Color(.systemBackground).ignoresSafeArea()
                    Sequencer(model: model, synth: synth, player: player)
                }
            }
            Tab("Synthesizer", systemImage: "testtube.2") {
                ZStack {
                    Color(.systemBackground).ignoresSafeArea()
                    SynthControls(player: player, synth: synth)
                }
            }
            Tab("Settings", systemImage: "gearshape") {
                ZStack {
                    Color(.systemBackground).ignoresSafeArea()
                    MIDISettingsView()
                }
            }
        }
    }
}


#Preview{
    MegaView()
}

