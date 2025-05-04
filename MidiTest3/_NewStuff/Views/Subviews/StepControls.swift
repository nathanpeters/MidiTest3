//
//  Untitled.swift
//  MidiTest3
//
//  Created by Nathan Peters on 4/21/25.
//
import SwiftUI

struct NoteLabel: View {
    let note: UInt8
    let layout: StepLayout

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.theme.buttonBackground)
                .stroke(Color.theme.buttonInset)
                .frame(width: layout.width * 0.75, height: layout.height)

            Text(noteName(for: note))
                .font(Font.custom("NanumGothicCoding", size: layout.fontSize))
                .foregroundColor(Color.theme.textDisplay)
        }
    }

    func noteName(for note: UInt8) -> String {
        let names = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
        let octave = Int(note) / 12 - 1
        let name = names[Int(note) % 12]
        return "\(name)\(octave)"
    }
}


struct NoteSlider: View {
    @Binding var noteValue: UInt8

    var body: some View {
        Slider(
            value: Binding(
                get: { Double(noteValue) },
                set: { noteValue = UInt8($0) }
            ),
            in: 1...127,
            step: 1
        )
        .accentColor(Color.theme.lightedButtonIdle)
    }
}

struct NoteStepperControl: View {
    @Binding var step: Step
    let layout: StepLayout
    let width: CGFloat

    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                if step.note < 127 { step.note -= 1 }
            }) {
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 16 * layout.scale, height: 10 * layout.scale)
                    .foregroundColor(Color.theme.primaryAction)
            }
            .frame(width: width/2)
            Divider()
                .frame(height: layout.height)
                .background(Color.theme.buttonBackground)
            Button(action: {
                if step.note > 0 { step.note += 1 }
            }) {
                Image(systemName: "arrowtriangle.up.fill")
                    .resizable()
                    .frame(width: 16 * layout.scale, height: 10 * layout.scale)
                    .foregroundColor(Color.theme.primaryAction)
            }
            .frame(width: width/2)
        }
        .frame(width: width)
    }
}

struct StepToggle: View {
    @Binding var isActive: Bool
    let layout: StepLayout
    let isCurrentStep: Bool

    var body: some View {
        Button(action: {
            isActive.toggle()
        }) {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(isCurrentStep ? Color.theme.lightedButtonActive : (isActive ? Color.theme.lightedButtonIdle : Color.theme.buttonBackground))
                    //.fill(Color.theme.lightedButtonIdle.gradient)
                    .stroke(Color.theme.buttonInset, lineWidth: 2)
                    .strokeBorder(Color.theme.buttonOutline, lineWidth: 1)
                    .frame(width: layout.width, height: layout.height)
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.white.opacity(0.40))
                    .frame(width: layout.width*0.93, height: layout.height*0.84)
            }
        }
    }
}
