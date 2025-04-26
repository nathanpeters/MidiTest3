//
//  SynthControls.swift
//  MidiTest3
//
//  Created by Nathan Peters on 4/24/25.
//

import SwiftUI
import AudioKit

struct SynthControls: View {
    @ObservedObject var synth: Synth
    //@ObservedObject var player: SequencePlayer


    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Group {
                    Button("Play C4") {
                        synth.play(note: 60)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            self.synth.stop()
                        }
                    }
                    Button("Stop") { synth.stop() }
                }

                // Cutoff & Resonance
                SliderWithLabel(title: "Cutoff", value: $synth.cutoff, range: 200...5000)
                SliderWithLabel(title: "Resonance", value: $synth.resonance, range: 0...1)

                // ADSR
                SliderWithLabel(title: "Attack", value: $synth.attack, range: 0...2)
                SliderWithLabel(title: "Decay", value: $synth.decay, range: 0...2)
                SliderWithLabel(title: "Sustain", value: $synth.sustain, range: 0...1)
                SliderWithLabel(title: "Release", value: $synth.release, range: 0...3)

                // Waveform Picker
                Picker("Waveform", selection: $synth.waveform) {
                    ForEach(Synth.Waveform.allCases) { wave in
                        Text(wave.rawValue.capitalized).tag(wave)
                    }
                }
                
//                Button(action: {
//                    player.toggleSynth()
//                }){
//                    Image(systemName: player.synthActive ? "pianokeys" : "nosign")
//                        .resizable()
//                        .frame(width: 18, height: 18)
//                }
                .pickerStyle(.segmented)
                .padding()
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
//#Preview {
//    let synth = Synth()
//    let model = SequenceModel()
//    let player = SequencePlayer(model: model, synth: synth)
//    SynthControls(synth: synth, player: player)
//}

