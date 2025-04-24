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

enum MusicalScale: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }

    case chromatic = "Chromatic"
    case major = "Major"
    case minor = "Minor"
    case pentatonic = "Pentatonic"
    case minorPentatonic = "Minor Pentatonic"
    case lydian = "Lydian"
    case mixolydian = "Mixolydian"
    case dorian = "Dorian"
    case phrygian = "Phrygian"
    case locrian = "Locrian"
}

class SequenceModel: ObservableObject {
    @Published var steps: [Step]
    @Published var stepCount: Int
    @Published var noteRangeLower: UInt8 = 24
    @Published var noteRangeUpper: UInt8 = 64

    init(initialStepCount: Int = 16) {
        self.stepCount = initialStepCount
        self.steps = []
        generateSteps()
    }

    func generateSteps(using pool: [UInt8]? = nil) {
        let effectiveRange = noteRangeLower...noteRangeUpper

        // If pool is provided, filter it to be within range. Otherwise, use default range.
        let sourcePool = (pool ?? Array(effectiveRange)).filter { note in
            effectiveRange.contains(note)
        }

        steps = (0..<stepCount).map { _ in
            Step(note: sourcePool.randomElement() ?? noteRangeLower, isActive: true)
        }
    }
}

func notePool(forKey key: String, scale: String) -> [UInt8] {
    let keyIndex = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"].firstIndex(of: key) ?? 0

    let intervals: [MusicalScale: [Int]] = [
        .chromatic: Array(0...11),
        .major: [0, 2, 4, 5, 7, 9, 11],
        .minor: [0, 2, 3, 5, 7, 8, 10],
        .pentatonic: [0, 2, 4, 7, 9],
        .minorPentatonic: [0, 3, 5, 7, 10],
        .lydian: [0, 2, 4, 6, 7, 9, 11],
        .mixolydian: [0, 2, 4, 5, 7, 9, 10],
        .dorian: [0, 2, 3, 5, 7, 9, 10],
        .phrygian: [0, 1, 3, 5, 7, 8, 10],
        .locrian: [0, 1, 3, 5, 6, 8, 10]
    ]

    guard let pattern = intervals[MusicalScale(rawValue: scale) ?? .chromatic] else { return [] }

    // Return MIDI notes in range 40...96 that match the scale
    return (40...96).filter { note in
        let relative = Int(note) % 12
        let adjusted = (relative - keyIndex + 12) % 12
        return pattern.contains(adjusted)
    }
}
