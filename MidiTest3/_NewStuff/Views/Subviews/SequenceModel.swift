//
//  SequenceModel.swift
//  MidiTest3
//
//  Created by Nathan Peters on 4/20/25.
//
import SwiftUI

struct Step: Identifiable {
    var id = UUID()
    var note: UInt8
    var isActive: Bool
}

class SequenceModel: ObservableObject {
    @Published var steps: [Step] // each step represents one note
    let stepsCount = 16

    init() {
        self.steps = (0..<stepsCount).map { _ in
            Step(note: UInt8(40 + Int.random(in: 0..<12)), isActive: true) // random note
        }
    }
}
