import SwiftUI

class SequencePlayer: ObservableObject {
    @Published var currentStepIndex: Int? = nil
    private let midiSender = MIDISender()
    private var currentStep = 0
    private var timerActive = false
    var model: SequenceModel
    @Published var tempo: Double = 420
    @Published var isPlaying = false
    @Published var midiActive: Bool = true
    @Published var synthActive: Bool = true
    private let synth: SimpleSynth
    
    init(model: SequenceModel, synth: SimpleSynth) {
        self.model = model
        self.synth = synth
    }
    
    func playMIDINote(note: UInt8, duration: TimeInterval) {
        midiSender.send(noteOn: note, velocity: 100)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.stopMIDINote(note: note)
        }
    }
    
    func playSynthNote(note: UInt8, duration: TimeInterval) {
        synth.play(note: note)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.synth.stop()
        }
    }
    
    func stopMIDINote(note: UInt8) {
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
            stopMIDINote(note: step.note)
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
            if midiActive {playMIDINote(note: step.note, duration: noteLength)}
            if synthActive {playSynthNote(note: step.note, duration: noteLength)}
        }
        
        currentStep += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + beatDuration) {
            self.playNextNote()
        }
    }
    
    func updateTempo(_ newTempo: Double) {
        tempo = newTempo
    }
    
    func toggleMIDI() {
        midiActive.toggle()
    }
    
    func toggleSynth() {
        synthActive.toggle()
    }
}
