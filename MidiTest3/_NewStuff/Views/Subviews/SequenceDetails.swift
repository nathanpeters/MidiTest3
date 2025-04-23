//
//  SequenceDetails.swift
//  MidiTest3
//
//  Created by Nathan Peters on 4/21/25.
//

import SwiftUI

struct SequenceDetails: View {
    @Binding var mode: Sequencer.Mode
    @State private var noteValue: Double = 20
    @State private var zoomFactor: CGFloat?
    @GestureState private var magnifyBy = CGFloat(1.0)
    @ObservedObject var model: SequenceModel
    @ObservedObject var deviceManager: MIDIDeviceManager
    @ObservedObject var player: SequencePlayer

    var body: some View {
        GeometryReader { geo in
            let availableHeight: CGFloat = geo.size.height
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: true) {
                    let targetHeight = geo.size.height * 0.85
                    let rowCount: CGFloat = 16
                    let spacingRatio: CGFloat = 0.5
                    let baseRowHeight = targetHeight / (rowCount + spacingRatio * (rowCount - 1))
                    let idealZoom = 1.0
                    let effectiveZoom = min(max((zoomFactor ?? 1.0) * magnifyBy, 1.0), 2.0)

                    let layout = StepLayout(
                        width: geo.size.width * 0.122,
                        height: baseRowHeight * effectiveZoom,
                        spacing: geo.size.width * 0.02,
                        fontSize: geo.size.height * 0.02,
                        scale: geo.size.height * 0.001
                    )

                    ZStack {
                        Color.theme.backgroundSequence
                        StepCollection(model: model, layout: layout, currentStepIndex: player.currentStepIndex)
                    }
                    .onAppear {
                        if zoomFactor == nil {
                            zoomFactor = idealZoom
                        }
                    }
                    .highPriorityGesture(
                        MagnificationGesture()
                            .updating($magnifyBy) { current, gestureState, _ in
                                gestureState = current
                            }
                            .onEnded { finalScale in
                                zoomFactor = min(max((zoomFactor ?? idealZoom) * finalScale, 1.0), 2.0)
                            }
                    )
                }
                .frame(height: availableHeight * 0.85)

                HStack {
                    Text("test\(player.isPlaying)")
                    Spacer()
                    VStack(spacing: availableHeight * 0.015) {
                        let localHeight = availableHeight * 0.15
                        Spacer()

                        Button(action: {
                            if player.isPlaying {
                                player.stopSequence()
                            } else {
                                player.startSequence()
                            }
                        }) {
                            Image(systemName: player.isPlaying ? "stop.fill" : "arrowtriangle.right.fill")
                                .resizable()
                                .frame(width: 18, height: 18)
                        }
                        .frame(width: geo.size.width * 0.122, height: localHeight * 0.38)
                        .foregroundColor(Color(red: 0.48, green: 0.75, blue: 0.78))
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color.white.opacity(1), lineWidth: 2)
                                .strokeBorder(Color.gray.opacity(1), lineWidth: 1)
                        )

                        Button(action: {
                            mode = (mode == .details) ? .control : .details
                        }) {
                            Image(systemName: "arrow.left.and.line.vertical.and.arrow.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                        }
                        .buttonStyle(NoPressEffectButtonStyle())
                        .frame(width: geo.size.width * 0.122, height: localHeight * 0.18)
                        .foregroundColor(Color.gray)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color.white.opacity(1), lineWidth: 2)
                                .strokeBorder(Color.gray.opacity(1), lineWidth: 1)
                        )
                        .padding(.horizontal, geo.size.width * 0.122 * 0.32)
                        Spacer()
                        Spacer()
                    }
                }
                .frame(width: geo.size.width, height: availableHeight * 0.15)
                .background(Color.theme.backgroundSequence)
            }
            .padding(.top)
        }
    }
}
