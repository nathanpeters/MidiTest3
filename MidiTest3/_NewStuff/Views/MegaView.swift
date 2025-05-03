import SwiftUI

struct MegaView: View {
    @StateObject private var synth = SimpleSynth()
    @StateObject private var model = SequenceModel()
    @StateObject private var player: SequencePlayer

    init() {
        let synth = SimpleSynth()
        _synth = StateObject(wrappedValue: synth)
        
        let sequenceModel = SequenceModel()
        _model = StateObject(wrappedValue: sequenceModel)
        
        _player = StateObject(wrappedValue: SequencePlayer(model: sequenceModel, synth: synth))
    }

    var body: some View {
        ZStack{
            TabView {
                Group{
                    Tab("Sequencer", systemImage: "pianokeys") {
                        Sequencer(model: model, synth: synth, player: player)
                    }
                    Tab("Synthesizer", systemImage: "testtube.2") {
                        SynthControls(player: player, synth: synth)
                    }
                    Tab("Settings", systemImage: "gearshape") {
                            MIDISettingsView()
                    }
                }
            }
        }
    }
}


#Preview{
    MegaView()
}

