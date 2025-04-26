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
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.theme.labelBackground1)
                            .frame(height: 30)
                        
                        Text("GENERATE")
                            .foregroundColor(Color.white)
                            .font(Font.custom("NanumGothicCoding", size: 16))
                            .padding(.leading, 8) // Add a little padding if you want
                    }
                    HStack{
                        
                        SequenceLengthStepper(model: model, width: geo.size.width*0.16, height: 80, maxSteps: 32)
                        ZStack{
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.theme.buttonBackground)
                                .stroke(Color.theme.buttonInset)
                                .frame(width: geo.size.width*0.24, height: 80)
                            Text("\(model.stepCount)")
                                .foregroundColor(Color.theme.textDisplay)
                                .font(Font.custom("NanumGothicCoding", size: 40))
                                .frame(width: 50, height: 60)
                        }
                        Spacer()
                        Button(action: {
                            let pool = notePool(forKey: keyBaseSelection, scale: scaleSelection.rawValue)
                            player.model.generateSteps(using: pool)
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                        .frame(width: geo.size.width*0.3, height: 80)
                        .foregroundColor(Color.theme.primaryAction)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.theme.buttonInset, lineWidth: 2)
                                .strokeBorder(Color.theme.buttonOutline, lineWidth: 1)
                        )
                        //.background(Color.theme.buttonBackground)
                        
                    }
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.theme.labelBackground2)
                            .frame(height: 30)
                        
                        Text("REFINE")
                            .foregroundColor(Color.white)
                            .font(Font.custom("NanumGothicCoding", size: 16))
                            .padding(.leading, 8) // Add a little padding if you want
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
                                Text("\(Int(tempo/2))")
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
                .frame(width: geo.size.width * 0.84)
            }
        }
    }
}

struct SequenceLengthStepper: View {
    
    @ObservedObject var model: SequenceModel
    let width: CGFloat
    let height: CGFloat
    let maxSteps: Int
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.theme.buttonInset, lineWidth: 2)
                .strokeBorder(Color.theme.buttonOutline, lineWidth: 1)
                .frame(width: width, height: height)
            
            VStack(spacing: 0) {
                Button(action: {
                    if model.stepCount < maxSteps {
                        model.stepCount += 1
                    }
                }) {
                    Image(systemName: "arrowtriangle.up.fill")
                        .resizable()
                        .frame(width: width * 0.2, height: height * 0.1)
                        .foregroundColor(Color.theme.primaryAction)
                }
                .frame(width: width, height: height / 2)
                
                Divider()
                    .background(Color.theme.buttonOutline)
                Divider()
                    .background(Color.theme.buttonOutline)
                
                Button(action: {
                    model.stepCount = max(1, model.stepCount - 1) // Make sure it doesn't go below 1
                }) {
                    Image(systemName: "arrowtriangle.down.fill")
                        .resizable()
                        .frame(width: width * 0.2, height: height * 0.1)
                        .foregroundColor(Color.theme.primaryAction)
                }
                .frame(width: width, height: height / 2)
            }
            .frame(width: width, height: height)
        }
    }
}

func stepup(){
    //test
}

#Preview {
    let model = SequenceModel()
    let synth = Synth()
    let player = SequencePlayer(model: model, synth: synth)
    
    return SequenceControls(
        tempo: .constant(120.0),
        player: player,
        model: model
    )
}
