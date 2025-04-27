//
//  SynthControls.swift
//  MidiTest3
//
//  Created by Nathan Peters on 4/24/25.
//

import SwiftUI
import AudioKit

struct SynthControls: View {
    @ObservedObject var player: SequencePlayer
    @ObservedObject var synth: AltSynth

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Group {
                    Button("Play C4") {
                        synth.play(note: 60)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            self.synth.stop(note: 60)
                        }
                    }
                    Button("Stop") { synth.stop(note:60) }
                }

                // Cutoff & Resonance
                SliderWithLabel(title: "Cutoff", value: $synth.cutoff, range: 200...5000)
                //SliderWithLabel(title: "Resonance", value: $synth.resonance, range: 0...1)

                // ADSR
                SliderWithLabel(title: "Attack", value: $synth.env.attackDuration, range: 0...2)
                SliderWithLabel(title: "Decay", value: $synth.env.decayDuration, range: 0...2)
                SliderWithLabel(title: "Sustain", value: $synth.env.sustainLevel, range: 0...1)
                SliderWithLabel(title: "Release", value: $synth.env.releaseDuration, range: 0...3)
                
                Button(action: {
                    player.toggleSynth()
                }) {
                    Text("Toggle Synth")
                        .font(.headline)
                        .padding()
                        .background(Color.theme.buttonBackground)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

struct SliderWithLabel: View {
    let title: String
    @Binding var value: AUValue
    let range: ClosedRange<AUValue>

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title): \(String(format: "%.2f", value))")
            Slider(value: $value, in: range)
        }
    }
}

