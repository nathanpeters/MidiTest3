//
//  Sequencer.swift
//  MidiTest3
//
//  Created by Nathan Peters on 4/21/25.
//


import SwiftUI

struct Sequencer: View {
    var synth: Synth
    
    enum Mode {
        case control
        case details
    }

    @State private var mode: Mode = .details
    @StateObject private var model = SequenceModel()
    @StateObject var deviceManager = MIDIDeviceManager()
    @StateObject private var player: SequencePlayer
    
    @State private var tempo: Double = 120 // State for tempo


    init(synth: Synth) {
            self.synth = synth
            let sequenceModel = SequenceModel()
            _model = StateObject(wrappedValue: sequenceModel)
            _player = StateObject(wrappedValue: SequencePlayer(model: sequenceModel, synth: synth))
        }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                SequenceControls(tempo: $player.tempo, player: player, model: model)
                SequenceDetails(mode: $mode, model: model, deviceManager: deviceManager, player: player)
                    .offset(x: mode == .details ? -geo.size.width * 0.02 : -geo.size.width * 0.805)
                    .animation(.easeInOut(duration: 0.4), value: mode)
            }
        }
        .background(Color.theme.backgroundSequence)
//        .onChange(of: tempo) { newTempo, _ in
//            player.updateTempo(newTempo)
//        }
        
    }
}
