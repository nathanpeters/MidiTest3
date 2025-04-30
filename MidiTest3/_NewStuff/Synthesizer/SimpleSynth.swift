//
//  SimpleSynth.swift
//  MidiTest3
//
//  Created by Nathan Peters on 4/27/25.
//

import SwiftUI
import AudioKit
import SoundpipeAudioKit

class SimpleSynth: ObservableObject {
    let engine = AudioEngine()
    
    private let osc: MorphingOscillator
    private let filter: MoogLadder
    //private let envelope: AmplitudeEnvelope
    
    @Published var env: AmplitudeEnvelope
    @Published var attack: AUValue = 0.1 {
        didSet {
            env.setParameter(index: 0, value: attack)
        }
    }

    @Published var decay: AUValue = 0.1 {
        didSet {
            env.setParameter(index: 1, value: decay)
        }
    }

    @Published var sustain: AUValue = 0.8 {
        didSet {
            env.setParameter(index: 2, value: sustain)
        }
    }

    @Published var release: AUValue = 0.5 {
        didSet {
            env.setParameter(index: 3, value: release)
        }
    }
    @Published var cutoff = AUValue(20_000) {
        didSet { filter.cutoffFrequency = cutoff }
    }
    
    init() {
        // 1. Create oscillator
        osc = MorphingOscillator(index: 0.75)
        
        // 2. Build audio chain
        filter = MoogLadder(osc)
        env = AmplitudeEnvelope(filter,
                                     attackDuration: 0.01,
                                     decayDuration: 0.3,
                                     sustainLevel: 0.5,
                                     releaseDuration: 0.5)
        
        // 3. Set output and start engine
        engine.output = env
        try? engine.start()
    }
    
    func play(note: MIDINoteNumber) {
        if !osc.isStarted {
            osc.start()
        }
        osc.$frequency.ramp(to: note.midiNoteToFrequency(), duration: 0.0)
        osc.$amplitude.ramp(to: 0.5, duration: 0.0)
        env.openGate()
    }
    
    func stop() {
        env.closeGate()
        osc.$amplitude.ramp(to: 0.0, duration: 0.01)
    }
}

extension Node {
    func setParameter(index: Int, value: AUValue) {
        guard parameters.indices.contains(index) else {
            print("Parameter at index \(index) not found")
            return
        }
        parameters[index].value = value
    }
}
