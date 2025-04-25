//
//  Synth.swift
//  MidiTest3
//
//  Created by Nathan Peters on 4/24/25.
//


import AudioKit
import SoundpipeAudioKit
import Foundation

class Synth: ObservableObject {
    let engine = AudioEngine()
    
    //private var osc: Oscillator!
    private var osc: MorphingOscillator!
    private var filter: LowPassFilter!
    private var envelope: AmplitudeEnvelope!

    @Published var cutoff: AUValue = 1000.0 {
        didSet { filter?.cutoffFrequency = cutoff }
    }

    @Published var resonance: AUValue = 0.5 {
        didSet { filter?.resonance = resonance }
    }

    @Published var attack: AUValue = 0.1 {
        didSet { envelope?.attackDuration = attack }
    }

    @Published var decay: AUValue = 0.1 {
        didSet { envelope?.decayDuration = decay }
    }

    @Published var sustain: AUValue = 0.8 {
        didSet { envelope?.sustainLevel = sustain }
    }

    @Published var release: AUValue = 0.5 {
        didSet { envelope?.releaseDuration = release }
    }

    enum Waveform: String, CaseIterable, Identifiable {
        case sine, square, triangle, sawtooth
        var id: String { rawValue }
    }

    @Published var waveform: Waveform = .sine {
        didSet {
            rebuildChain()
        }
    }

    init() {
        rebuildChain()
        
        do {
            try engine.start()
        } catch {
            Log("Audio engine failed to start: \(error)")
        }
    }

    private func rebuildChain() {
        // Stop the engine safely
        engine.stop()

        // Disconnect existing nodes
        engine.output = nil

        // Create new oscillator with selected waveform
        //osc = Oscillator(waveform: waveformTable(for: waveform))
        osc = MorphingOscillator(index:0.75, detuningOffset:0)
        filter = LowPassFilter(osc)
        envelope = AmplitudeEnvelope(filter)

        // Apply stored values
        filter.cutoffFrequency = cutoff
        filter.resonance = resonance

        envelope.attackDuration = attack
        envelope.decayDuration = decay
        envelope.sustainLevel = sustain
        envelope.releaseDuration = release

        engine.output = envelope

        // Start the engine again
        do {
            try engine.start()
        } catch {
            Log("Audio engine failed to restart: \(error)")
        }
    }

    func play(note: MIDINoteNumber) {
        print("Playing")

        osc.frequency = note.midiNoteToFrequency()
        osc.amplitude = 0.6
        osc.start()
        envelope.openGate()
        print("envelope: \(envelope.isStarted)")
    }

    func stop() {
        print("Stopping")
        envelope.closeGate()
        //osc.stop()
    }

    private func waveformTable(for waveform: Waveform) -> Table {
        switch waveform {
        case .sine: return Table(.sine)
        case .square: return Table(.square)
        case .triangle: return Table(.triangle)
        case .sawtooth: return Table(.sawtooth)
        }
    }
}


