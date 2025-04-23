import SwiftUI

struct PrototypeView: View {
    private let midiSender = MIDISender()

    // Pass the midiNote bindings to each NoteSelectorView
    @State private var midiNote1: Double = 33
    @State private var midiNote2: Double = 36
    @State private var midiNote3: Double = 40
    @State private var midiNote4: Double = 45
    @State private var midiNote5: Double = 48
    @State private var midiNote6: Double = 52
    @State private var midiNote7: Double = 57
    @State private var midiNote8: Double = 60
    @State private var playedNotes: [UInt8] = [] // Store the notes currently being played
    @State private var isPlaying: Bool = false // Track if sequence is playing
    @State private var sliderValue: Double = 330
    @State private var tempo: Double = 330 // Initial tempo in BPM
    @State private var noteDuration: Double = 0.1 // Initial tempo in BPM

    var body: some View {
        VStack {
            HStack {
                Slider(value: $sliderValue, in: 90...480, step: 1)
                    .padding()
                    .onChange(of: sliderValue) { oldValue, newValue in
                        tempo = newValue // Update tempo directly based on slider value
                    }
                Text("\(Int(tempo)) BPM")
                    .font(.headline)
                    .padding()
            }
            HStack(spacing:0) {
                VStack(spacing:0) {
                    // Pass midiNotes as bindings to NoteSelectorViews
                    NoteSelectorView(note: $midiNote1, playedNotes: $playedNotes)
                    NoteSelectorView(note: $midiNote2, playedNotes: $playedNotes)
                    NoteSelectorView(note: $midiNote3, playedNotes: $playedNotes)
                    NoteSelectorView(note: $midiNote4, playedNotes: $playedNotes)
                }
                VStack(spacing:0) {
                    NoteSelectorView(note: $midiNote5, playedNotes: $playedNotes)
                    NoteSelectorView(note: $midiNote6, playedNotes: $playedNotes)
                    NoteSelectorView(note: $midiNote7, playedNotes: $playedNotes)
                    NoteSelectorView(note: $midiNote8, playedNotes: $playedNotes)
                }
            }
            HStack {
                Button(action: {
                    startSequence()
                }) {
                    Text("Start")
                        .padding()
                        .background(isPlaying ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(isPlaying) // Disable if already playing
                
                Button(action: {
                    stopSequence()
                }) {
                    Text("Stop")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
    }
    
    func playNote(note: Double) {
        let noteToPlay = UInt8(note)
        
        if !playedNotes.contains(noteToPlay) {
            playedNotes.append(noteToPlay) // Add to the list of played notes
            print("Sending MIDI Note On for note: \(noteToPlay)")
            midiSender.send(noteOn: noteToPlay, velocity: 100)

            // Schedule automatic note stop after `noteDuration` seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + noteDuration) {
                stopNote(note: noteToPlay)
            }
        } else {
            print("Note \(noteToPlay) is already playing.")
        }
    }

    // Function to send the MIDI Note Off message for a specific note
    func stopNote(note: UInt8) {
        if let index = playedNotes.firstIndex(of: note) {
            playedNotes.remove(at: index) // Remove the note from the array
            print("Sending MIDI Note Off for note: \(note)")
            midiSender.send(noteOff: note)
        } else {
            print("Note \(note) is not currently playing.")
        }
    }
    
    func startSequence() {
        isPlaying = true
        playNextNote(index: 0) // Start playing from the first note
    }

    // Recursive function to play each note one after the other
    func playNextNote(index: Int) {
        guard isPlaying else { return } // Stop if sequence has been stopped

        let beatDuration = 60.0 / tempo // Convert BPM to seconds per beat

        // Dynamically get note values from sliders
        let currentNote: Double
        switch index {
        case 0: currentNote = midiNote1
        case 1: currentNote = midiNote2
        case 2: currentNote = midiNote3
        case 3: currentNote = midiNote4
        case 4: currentNote = midiNote5
        case 5: currentNote = midiNote6
        case 6: currentNote = midiNote7
        case 7: currentNote = midiNote8
        default: return
        }

        playNote(note: currentNote) // Play the current note

        // Schedule the next note
        DispatchQueue.main.asyncAfter(deadline: .now() + beatDuration) {
            let nextIndex = (index + 1) % 8 // Loop back to the first note after the fourth
            playNextNote(index: nextIndex) // Play the next note
        }
    }

    // Function to stop the sequence
    func stopSequence() {
        isPlaying = false // Stop the loop
        for note in playedNotes {
            stopNote(note: note)
        }
        playedNotes.removeAll() // Clear played notes
    }
}
#Preview {
    PrototypeView()
}
