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
    @Published var steps: [Step]
    @Published var stepCount: Int {
        didSet {
            regenerateSteps()
        }
    }

    init(initialStepCount: Int = 16) {
        self.stepCount = initialStepCount
        self.steps = []
        regenerateSteps()
    }

    private func regenerateSteps(noteRange: ClosedRange<UInt8> = 60...72) {
        steps = (0..<stepCount).map { _ in
            Step(note: UInt8.random(in: noteRange), isActive: true)
        }
    }

    func generateRandomSequence(noteRange: ClosedRange<UInt8> = 60...96) {
        regenerateSteps(noteRange: noteRange)
    }
}

