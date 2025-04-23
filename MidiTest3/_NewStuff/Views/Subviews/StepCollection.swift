//
//  StepCollection.swift
//  MidiTest3
//
//  Created by Nathan Peters on 4/21/25.
//

import SwiftUI

struct StepCollection: View {
    @ObservedObject var model: SequenceModel
    let layout: StepLayout
    let currentStepIndex: Int?

    var body: some View {
        VStack(spacing: layout.spacing) {
            ForEach(model.steps.indices, id: \.self) { index in
                StepRow(
                    step: $model.steps[index],
                    layout: layout,
                    //isPlaying: index == currentStepIndex,
                    isCurrentStep: index == currentStepIndex
                )
            }
        }
        .padding(.vertical, layout.spacing)
    }
}
struct StepRow: View {
    @Binding var step: Step
    let layout: StepLayout
    //let isPlaying: Bool
    let isCurrentStep: Bool

    var body: some View {
        HStack(spacing: layout.spacing) {
            NoteSlider(noteValue: $step.note)

            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    //.fill(isPlaying ? Color.orange : Color.theme.buttonBackground)
                    .stroke(Color.theme.buttonInset, lineWidth: 2)
                    .strokeBorder(Color.theme.buttonOutline, lineWidth: 1)
                    .frame(width: layout.width*1.3, height: layout.height)

                HStack(spacing: 0) {
                    DecrementButton(step: $step, layout: layout, width: layout.width * 0.65)
                    Divider()
                        .frame(height: layout.height)
                        .background(Color.theme.buttonOutline)
                    IncrementButton(step: $step, layout: layout, width: layout.width * 0.65)
                }
            }

            HStack(spacing: 0) {
                NoteLabel(note: step.note, layout: layout)
                StepToggle(isActive: $step.isActive, layout: layout, isCurrentStep: isCurrentStep)
                    .padding(.leading, layout.width * 0.32)
            }
        }
        .padding(.horizontal, layout.width * 0.32)
    }
}

