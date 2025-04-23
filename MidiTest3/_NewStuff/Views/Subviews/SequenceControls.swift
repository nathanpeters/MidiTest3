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
    @State private var scaleSelection = "Major"
    let scales: [String] = ["Major", "Minor", "Pentatonic"]
    
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
                            player.model.generateRandomSequence()
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
                            Picker("Base", selection: $scaleSelection) {
                                ForEach(scales, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
                            
                        }
                        Text("Tempo")
                            .font(.subheadline)
                        HStack{
                            Slider(value: $tempo, in: 90...480, step: 1)
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
