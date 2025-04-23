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
    
    var body: some View {
        
        GeometryReader { geo in
            HStack {
                Spacer()
                VStack() {
                    Text("Sequence Controls")
                        .font(.headline)
                        .padding(.top)
                    
                    // Tempo Slider
                    VStack {
                        Text("Tempo: \(Int(tempo)) BPM")
                            .font(.subheadline)

                        Slider(value: $tempo, in: 90...480, step: 1)
                            .onChange(of: tempo) { oldValue, newValue in
                                player.updateTempo(newValue)
                            }
                        .accentColor(Color.theme.primaryAction)
                        .padding(.horizontal)
                    }
                }
                .padding()
                .frame(width: geo.size.width * 0.85)
            }
        }
        
    }
}
#Preview {
    SequenceControls(tempo: .constant(120), player: .init(model: SequenceModel()))
}
