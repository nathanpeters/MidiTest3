//
//  AltSynth.swift
//  MidiTest3
//
//  Created by Nathan Peters on 4/26/25.
//

import SwiftUI
import AudioKit
import SoundpipeAudioKit

struct MorphingOscillatorData {
    var frequency: AUValue = 440
    var octaveFrequency: AUValue = 440
    var amplitude: AUValue = 0.2
}

class AltSynth: ObservableObject {
    let engine = AudioEngine()
    
    var osc = [
        MorphingOscillator(index: 0.75, detuningOffset: -0.1),
        MorphingOscillator(index: 0.75, detuningOffset: 0.1),
        MorphingOscillator(index: 2.75)
    ]
    
    let filter: MoogLadder
    @Published var env: AmplitudeEnvelope
    @Published var octave = 1
    var notes = Array(repeating: 0, count: 11)
    
    @Published var cutoff = AUValue(20_000) {
        didSet { filter.cutoffFrequency = cutoff }
    }
    
    init() {
        // 1. Start oscillators
        osc = [
            MorphingOscillator(index: 0.75, detuningOffset: -0.1),
            MorphingOscillator(index: 0.75, detuningOffset: 0.1),
            MorphingOscillator(index: 2.75)
        ]
        
        // 2. Build the audio chain
        let mixer = Mixer(osc[0], osc[1], osc[2])
        filter = MoogLadder(mixer, cutoffFrequency: 20_000)
        env = AmplitudeEnvelope(filter,
                                 attackDuration: 0.01,
                                 decayDuration: 1.0,
                                 sustainLevel: 0.25,
                                 releaseDuration: 0.25)
        
        // 3. Set engine output
        engine.output = env
        
        // 4. Start engine
        do {
            try engine.start()
        } catch {
            Log("Audio engine failed to start: \(error)")
        }
    }
    
    @Published var data = MorphingOscillatorData() {
        didSet {
            for i in 0...2 {
                osc[i].start()
                osc[i].$amplitude.ramp(to: data.amplitude, duration: 0)
            }
            osc[0].$frequency.ramp(to: data.frequency, duration: 0.01)
            osc[1].$frequency.ramp(to: data.frequency, duration: 0.01)
            osc[2].$frequency.ramp(to: data.octaveFrequency, duration: 0.01)
        }
    }
    
    func play(note: MIDINoteNumber) {
        data.frequency = AUValue(note).midiNoteToFrequency()
        data.octaveFrequency = AUValue(note-12).midiNoteToFrequency()
        for num in 0...10 {
            if notes[num] == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    self.env.openGate()
                }
                notes[num] = Int(note)
                break
            }
        }
    }
    
    func stop(note: MIDINoteNumber) {
        for num in 0...10 {
            if notes[num] == note {
                notes[num] = 0
            }
            if Set(notes).count <= 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    self.env.closeGate()
                }
            }
        }
    }
}

