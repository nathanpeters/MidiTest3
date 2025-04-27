////
////  Synth.swift
////  MidiTest3
////
////  Created by Nathan Peters on 4/24/25.
////
//
//
//import AudioKit
//import SoundpipeAudioKit
//import Foundation
//
//extension Comparable {
//    func clamped(to limits: ClosedRange<Self>) -> Self {
//        return min(max(self, limits.lowerBound), limits.upperBound)
//    }
//}
//
//class Synth: ObservableObject {
//    let engine = AudioEngine()
//    
//    private var osc: Oscillator!
//    private var filter: LowPassFilter!
//    private var envelope: AmplitudeEnvelope!
//
//    @Published var cutoff: AUValue = 1000.0 {
//        didSet { filter?.cutoffFrequency = cutoff }
//    }
//
//    @Published var resonance: AUValue = 0.5 {
//        didSet { filter?.resonance = resonance }
//    }
//
//    @Published var attack: AUValue = 0.1 {
//        didSet { envelope?.attackDuration = max(0.0, attack) }
//    }
//    @Published var decay: AUValue = 0.1 {
//        didSet { envelope?.decayDuration = max(0.0, decay) }
//    }
//    @Published var sustain: AUValue = 0.8 {
//        didSet { envelope?.sustainLevel = sustain.clamped(to: 0.0...1.0) }
//    }
//    @Published var release: AUValue = 0.5 {
//        didSet { envelope?.releaseDuration = max(0.0, release) }
//    }
//
//    enum Waveform: String, CaseIterable, Identifiable {
//        case sine, square, triangle, sawtooth
//        var id: String { rawValue }
//    }
//
//    @Published var waveform: Waveform = .square {
//        didSet {
//            rebuildChain()
//        }
//    }
//
//    init() {
//        rebuildChain()
//        
//    }
//
//    private func rebuildChain() {
//        // Stop the engine
//        engine.stop()
//
//        // Disconnect everything
//        engine.output = nil
//
//        // Build the chain
//        osc = Oscillator(waveform: waveformTable(for: waveform))
//        filter = LowPassFilter(osc)
//        envelope = AmplitudeEnvelope(filter)
//
//        // Set properties
//        filter.cutoffFrequency = cutoff
//        filter.resonance = resonance
//        envelope.attackDuration = attack
//        envelope.decayDuration = decay
//        envelope.sustainLevel = sustain
//        envelope.releaseDuration = release
//
//        // Set final output
//        engine.output = envelope
//
//        // Now that everything is ready, start the engine!
//        do {
//            try engine.start()
//        } catch {
//            Log("Audio engine failed to restart: \(error)")
//        }
//    }
//
//
//    func play(note: MIDINoteNumber) {
//        guard (0...127).contains(note) else {
//            print("Invalid MIDI note: \(note)")
//            return
//        }
//        print("Playing note: \(note)")
//
//        osc.frequency = note.midiNoteToFrequency()
//        osc.amplitude = 0.6
//        osc.start()
//        //envelope.start()
//        envelope.openGate()
//    }
//
//    func stop() {
//        print("Stopping")
//        //envelope.stop()
//        envelope.closeGate()
// 
//    }
//
//    private func waveformTable(for waveform: Waveform) -> Table {
//        switch waveform {
//        case .sine: return Table(.sine)
//        case .square: return Table(.square)
//        case .triangle: return Table(.triangle)
//        case .sawtooth: return Table(.sawtooth)
//        }
//    }
//}
//
//
