//
//  Synth.swift
//  MidiTest3
//
//  Created by Nathan Peters on 4/24/25.
//


import SwiftUI
import AudioKit
import SoundpipeAudioKit

class Synth: ObservableObject {
    let engine = AudioEngine()
    let osc = Oscillator()
    let filter: LowPassFilter

    @Published var cutoff: AUValue = 1000.0 {
        didSet {
            filter.cutoffFrequency = cutoff
        }
    }

    init() {
        filter = LowPassFilter(osc)
        filter.cutoffFrequency = cutoff
        engine.output = filter

        do {
            try engine.start()
        } catch {
            Log("Audio engine failed to start: \(error)")
        }
    }

    func play(note: MIDINoteNumber) {
        osc.frequency = note.midiNoteToFrequency()
        osc.amplitude = 0.6
        osc.start()
    }

    func stop() {
        osc.stop()
    }
}

