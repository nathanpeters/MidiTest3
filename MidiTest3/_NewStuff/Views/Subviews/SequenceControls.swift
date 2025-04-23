//
//  SequenceControls.swift
//  MidiTest3
//
//  Created by Nathan Peters on 4/21/25.
//
import SwiftUI

struct SequenceControls: View {
    
    @Binding var tempo: Double
    var player: SequencePlayer
    @ObservedObject var model: SequenceModel
    @State private var keyBaseSelection = "C"
    let keyBases: [String] = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    @State private var scaleSelection: MusicalScale = .major
    
    var body: some View {
        
        GeometryReader { geo in
            HStack {
                Spacer()
                VStack(alignment: .leading) {
                    ZStack{
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.theme.buttonBackground)
                            .frame(height: 30);
                        Text("GENERATE")
                            .font(.headline)
                    }
                    HStack{
                        Stepper(value: $model.stepCount, in: 1...64) {
                            Text("\(model.stepCount)")
                        }
                        
                        Button(action: {
                            let pool = notePool(forKey: keyBaseSelection, scale: scaleSelection.rawValue)
                            player.model.generateSteps(using: pool)
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                        .frame(width: 60, height: 60)
                        .background(Color.theme.buttonBackground)
                        
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.theme.buttonBackground)
                            .frame(height: 30);
                        Text("REFINE")
                            .font(.headline)
                    }
                    
                    // Tempo Slider
                    VStack {
                        Text("Key")
                            .font(.subheadline)
                        HStack{
                            Picker("Base", selection: $keyBaseSelection) {
                                ForEach(keyBases, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
                            Picker("Scale", selection: $scaleSelection) {
                                ForEach(MusicalScale.allCases) { scale in
                                    Text(scale.rawValue).tag(scale)
                                }
                            }
                            .pickerStyle(.menu)
                            
                        }
                        Text("Tempo")
                            .font(.subheadline)
                        HStack{
                            Slider(value: $tempo, in: 120...640, step: 1)
                                .onChange(of: tempo) { oldValue, newValue in
                                    player.updateTempo(newValue)
                                }
                                .accentColor(Color.theme.primaryAction)
                            VStack{
                                Text("\(Int(tempo))")
                                Text("BPM")
                            }
                        }
                    }
                    Text("Note Range")
                        .font(.subheadline)

                    HStack {
                        VStack(alignment: .leading) {
                            Text("Min: \(model.noteRangeLower)")
                            Slider(value: Binding(
                                get: { Double(model.noteRangeLower) },
                                set: { model.noteRangeLower = UInt8($0) }
                            ), in: 0...127, step: 1)
                        }

                        VStack(alignment: .leading) {
                            Text("Max: \(model.noteRangeUpper)")
                            Slider(value: Binding(
                                get: { Double(model.noteRangeUpper) },
                                set: { model.noteRangeUpper = UInt8($0) }
                            ), in: 0...127, step: 1)
                        }
                    }

                }
                .padding()
                .frame(width: geo.size.width * 0.85)
            }
        }
        
    }
}
#Preview {
    SequenceControls(tempo: .constant(120), player: .init(model: SequenceModel()), model: SequenceModel())
}
