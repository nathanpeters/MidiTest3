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
    
    private let fullwidth: CGFloat = 8
    
    var body: some View {
        
        GeometryReader { geo in
            HStack {
                Spacer()
                VStack(alignment: .leading, spacing: 12) {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.theme.labelBackground1)
                            .frame(height: 30)
                        
                        Text("GENERATE")
                            .foregroundColor(Color.white)
                            .font(Font.custom("NanumGothicCoding", size: 16))
                            .padding(.leading, 8) // Add a little padding if you want
                    }
                    VStack(spacing: 20){
                        HStack(spacing: 16){
                            VStack{
                                HStack{
                                    Rectangle()
                                        .fill(Color.theme.textDisplay.opacity(0.4))
                                        .frame(maxWidth: .infinity, maxHeight: 1)
                                    Text("BEATS")
                                        .font(Font.custom("NanumGothicCoding", size: 12))
                                        .foregroundStyle(Color.theme.textDisplay)
                                    Rectangle()
                                        .fill(Color.theme.textDisplay.opacity(0.4))
                                        .frame(maxWidth: .infinity, maxHeight: 1)
                                }
                                HStack{
                                    SequenceLengthStepper(model: model, width: geo.size.width*fullwidth*0.02, height: 80, maxSteps: 32)
                                    ZStack{
                                        InsetContainer(maxWidth: geo.size.width*0.24, maxHeight: 80)
                                        
                                        Text("\(model.stepCount)")
                                            .foregroundColor(Color.theme.textDisplay)
                                            .font(Font.custom("NanumGothicCoding", size: 40))
                                            .frame(width: 50, height: 60)
                                    }
                                }
                            }
                            VStack{
                                HStack{
                                    Rectangle()
                                        .fill(Color.theme.textDisplay.opacity(0.4))
                                        .frame(maxWidth: .infinity, maxHeight: 1)
                                    Text("NEW SEQUENCE")
                                        .font(Font.custom("NanumGothicCoding", size: 12))
                                        .foregroundStyle(Color.theme.textDisplay)
                                        .lineLimit(1)
                                        .layoutPriority(1)
                                    Rectangle()
                                        .fill(Color.theme.textDisplay.opacity(0.4))
                                        .frame(maxWidth: .infinity, maxHeight: 1)
                                }
                                Button(action: {
                                    let pool = notePool(forKey: keyBaseSelection, scale: scaleSelection.rawValue)
                                    player.model.animateSequenceReplacement(using: pool)
                                }) {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                }
                                .frame(maxWidth: .infinity ,maxHeight: 80)
                                .foregroundColor(Color.theme.primaryAction)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.theme.buttonInset, lineWidth: 2)
                                        .strokeBorder(Color.theme.buttonOutline, lineWidth: 1)
                                )
                                .background(Color.theme.buttonBackground)
                            }
                            
                        }
                        
                        
                        HStack(spacing: 15){
                            VStack{
                                HStack{
                                    Text("SCALE")
                                        .font(Font.custom("NanumGothicCoding", size: 12))
                                        .foregroundStyle(Color.theme.textDisplay)
                                    Rectangle()
                                        .fill(Color.theme.textDisplay.opacity(0.4))
                                        .frame(maxWidth: .infinity, maxHeight: 1)
                                }
                                
                                
                                ZStack{
                                    InsetContainer(maxWidth: geo.size.width*0.5, maxHeight: 40)
                                    Picker("Base", selection: $keyBaseSelection) {
                                        ForEach(keyBases, id: \.self) {
                                            Text($0)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .accentColor(Color.theme.textDisplay)
                                    
                                }
                                
                            }
                            .frame(width: geo.size.width*0.24)
                            VStack{
                                HStack{
                                    Text("MODE")
                                        .font(Font.custom("NanumGothicCoding", size: 12))
                                        .foregroundStyle(Color.theme.textDisplay)
                                    Rectangle()
                                        .fill(Color.theme.textDisplay.opacity(0.4))
                                        .frame(maxWidth: .infinity, maxHeight: 1)
                                }
                                ZStack{
                                    InsetContainer(maxWidth: geo.size.width*0.46, maxHeight: 40)
                                    Picker("Scale", selection: $scaleSelection) {
                                        ForEach(MusicalScale.allCases) { scale in
                                            Text(scale.rawValue).tag(scale)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .accentColor(Color.theme.textDisplay)
                                }
                            }
                            
                        }
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
                    .padding(.top)
                    
                    
                    // Tempo Slider
                    VStack {
                        HStack{
                            Rectangle()
                                .fill(Color.theme.textDisplay.opacity(0.4))
                                .frame(maxWidth: .infinity, maxHeight: 1)
                            Text("TEMPO")
                                .font(Font.custom("NanumGothicCoding", size: 12))
                                .foregroundStyle(Color.theme.textDisplay)
                                .lineLimit(1)
                                .layoutPriority(1)
                            Rectangle()
                                .fill(Color.theme.textDisplay.opacity(0.4))
                                .frame(maxWidth: .infinity, maxHeight: 1)
                        }
                        HStack{
                            Slider(value: $tempo, in: 120...640, step: 1)
                                .onChange(of: tempo) { oldValue, newValue in
                                    player.updateTempo(newValue)
                                }
                                .accentColor(Color.theme.primaryAction)
                            VStack{
                                Text("\(Int(tempo/2))")
                                    .font(Font.custom("NanumGothicCoding", size: 14))
                                    .foregroundStyle(Color.theme.textDisplay)
                                Text("BPM")
                                    .font(Font.custom("NanumGothicCoding", size: 10))
                                    .foregroundStyle(Color.theme.textDisplay)
                            }
                        }
                    }
                        
                    VStack{
                        HStack{
                            Rectangle()
                                .fill(Color.theme.textDisplay.opacity(0.4))
                                .frame(maxWidth: .infinity, maxHeight: 1)
                            Text("NOTE RANGE")
                                .font(Font.custom("NanumGothicCoding", size: 12))
                                .foregroundStyle(Color.theme.textDisplay)
                                .lineLimit(1)
                                .layoutPriority(1)
                            Rectangle()
                                .fill(Color.theme.textDisplay.opacity(0.4))
                                .frame(maxWidth: .infinity, maxHeight: 1)
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                HStack{

                                    Text("MIN: \(model.noteRangeLower)")
                                        .font(Font.custom("NanumGothicCoding", size: 12))
                                        .foregroundStyle(Color.theme.textDisplay)
                                        .lineLimit(1)
                                        .layoutPriority(1)
                                    Rectangle()
                                        .fill(Color.theme.textDisplay.opacity(0.4))
                                        .frame(maxWidth: .infinity, maxHeight: 1)
                                }
                
                                Slider(value: Binding(
                                    get: { Double(model.noteRangeLower) },
                                    set: { newValue in
                                        let clamped = min(newValue, Double(model.noteRangeUpper)) // Clamp to upper bound
                                        model.noteRangeLower = UInt8(clamped)
                                    }
                                ), in: 20...111, step: 1)
                            }
                            
                            
                            VStack(alignment: .leading) {
                                HStack{
                                    Rectangle()
                                        .fill(Color.theme.textDisplay.opacity(0.4))
                                        .frame(maxWidth: .infinity, maxHeight: 1)
                                    Text("MAX: \(model.noteRangeUpper)")
                                        .font(Font.custom("NanumGothicCoding", size: 12))
                                        .foregroundStyle(Color.theme.textDisplay)
                                        .lineLimit(1)
                                        .layoutPriority(1)

                                }
                                Slider(value: Binding(
                                    get: { Double(model.noteRangeUpper) },
                                    set: { newValue in
                                        let clamped = max(newValue, Double(model.noteRangeLower)) // Clamp to lower bound
                                        model.noteRangeUpper = UInt8(clamped)
                                    }
                                ), in: 20...111, step: 1)
                            }
                        }
                    }
                    .padding(.top)
                    
                    
                    
                }
                .padding()
                .frame(width: geo.size.width * (fullwidth/10))
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
                        .frame(width: width * 0.2, height: height * 0.17)
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
                        .frame(width: width * 0.2, height: height * 0.17)
                        .foregroundColor(Color.theme.primaryAction)
                }
                .frame(width: width, height: height / 2)
                
            }
            .frame(width: width, height: height)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.theme.buttonInset, lineWidth: 2)
                    .strokeBorder(Color.theme.buttonOutline, lineWidth: 1)
            )
            .background(Color.theme.buttonBackground)
        }
    }
}

#Preview {
    let model = SequenceModel()
    let synth = SimpleSynth()
    let player = SequencePlayer(model: model, synth: synth)
    
    SequenceControls(tempo: .constant(120), player: player, model: model)
}
