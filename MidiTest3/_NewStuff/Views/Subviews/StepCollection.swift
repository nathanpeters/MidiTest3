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
                    isCurrentStep: index == currentStepIndex
                )
                .opacity(model.steps[index].isVisible ? 1 : 0)
                .animation(.easeIn(duration: 0.2), value: model.steps[index].isVisible)
            }
        }
        .padding(.vertical, layout.spacing)
    }
}
struct StepRow: View {
    @Binding var step: Step
    let layout: StepLayout
    let isCurrentStep: Bool
    
    var body: some View {
        HStack(spacing: layout.spacing) {
            NoteSlider(noteValue: $step.note)
            
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.theme.buttonInset, lineWidth: 2)
                    .strokeBorder(Color.theme.buttonOutline, lineWidth: 1)
                    .frame(width: layout.width*1.3, height: layout.height)

                NoteStepperControl(step: $step, layout: layout, width: layout.width * 1.3)
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

#Preview {
    let layout = StepLayout(width: 80, height: 80, spacing: 8, fontSize: 16, scale: 1)
    let model = SequenceModel()
//    let step: Step = .init(note: 60, isActive: true)
//    let isCurrentStep: Bool = false
    
    
    StepCollection(model: model, layout: layout, currentStepIndex: 2)
}

