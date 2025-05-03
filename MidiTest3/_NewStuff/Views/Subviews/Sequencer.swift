//
//  Sequencer.swift
//  MidiTest3
//
//  Created by Nathan Peters on 4/21/25.
//


import SwiftUI

struct Sequencer: View {

    enum Mode {
        case control
        case details
    }

    @State private var mode: Mode = .control
    @ObservedObject var model: SequenceModel
    @ObservedObject var synth: SimpleSynth
    @ObservedObject var player: SequencePlayer
    @StateObject var deviceManager = MIDIDeviceManager()
    
    @State private var tempo: Double = 120 // State for tempo

    
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
        .toolbarBackgroundVisibility(.visible, for: .tabBar)
        .toolbarBackground(Color.theme.backgroundSequence, for: .tabBar)
        
    }
}
