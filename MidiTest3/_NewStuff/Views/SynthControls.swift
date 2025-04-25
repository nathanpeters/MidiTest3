//
//  SynthControls.swift
//  MidiTest3
//
//  Created by Nathan Peters on 4/24/25.
//

import SwiftUI

struct SynthControls: View {
    
    @ObservedObject var synth: Synth
    
    var body: some View {
        VStack {
            Button("Play C4") {
                synth.play(note: 60)
            }
            
            Button("Stop") {
                synth.stop()
            }
            
            Slider(value: $synth.cutoff, in: 200...5000, step: 1) {
                Text("Cutoff")
            }
            .padding()
            
            Text("Cutoff: \(Int(synth.cutoff)) Hz")
        }
    }
}
