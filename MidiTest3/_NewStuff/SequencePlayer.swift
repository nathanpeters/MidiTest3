import SwiftUI

class SequencePlayer: ObservableObject {
    @Published var currentStepIndex: Int? = nil
    private let midiSender = MIDISender()
    private var currentStep = 0
    private var timerActive = false
    var model: SequenceModel
    @Published var tempo: Double = 120
    @Published var isPlaying = false

    init(model: SequenceModel) {
        self.model = model
    }

    func playNote(note: UInt8, duration: TimeInterval) {
        midiSender.send(noteOn: note, velocity: 100)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.stopNote(note: note)
        }
    }

    func stopNote(note: UInt8) {
        midiSender.send(noteOff: note)
    }

    func startSequence() {
        guard !model.steps.isEmpty else { return }
        isPlaying = true
        currentStep = 0
        currentStepIndex = nil
        timerActive = true
        playNextNote()
    }

    func stopSequence() {
        isPlaying = false
        timerActive = false
        currentStepIndex = nil
        for step in model.steps {
            stopNote(note: step.note)
        }
    }

    private func playNextNote() {
        guard isPlaying, !model.steps.isEmpty else { return }

        let beatDuration = 60.0 / tempo
        let noteLength = beatDuration * 0.8 // Play 80% of the beat

        let index = currentStep % model.steps.count
        let step = model.steps[index]
        currentStepIndex = index

        if step.isActive {
            playNote(note: step.note, duration: noteLength)
        }

        currentStep += 1

        DispatchQueue.main.asyncAfter(deadline: .now() + beatDuration) {
            self.playNextNote()
        }
    }

    func updateTempo(_ newTempo: Double) {
        tempo = newTempo
    }
}
