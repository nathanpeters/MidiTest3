import SwiftUI

struct NoteSelectorView: View {
    @Binding var note: Double // Binding to update midiNote
    @Binding var playedNotes: [UInt8] // Binding to track played notes
    
    // Correct MIDI note-to-letter mapping for the first few octaves
    let notes = [
        "C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"
    ]
    
    // Calculate the string representation of the note including the octave number
    private var noteLabel: String {
        let noteIndex = Int(note) % notes.count
        let octave = (Int(note) / notes.count) - 1
        return "\(notes[noteIndex])\(octave)"
    }
    
    // Determine if this note is currently being played
    private var isNotePlaying: Bool {
        playedNotes.contains(UInt8(note))
    }
    
    // Define colors and styles in variables for better readability and performance
    private var noteBackgroundColor: Color {
        isNotePlaying ? Color.blue.opacity(0.2) : Color.white.opacity(0.5)
    }
    
    private var noteOutlineColor: Color {
        isNotePlaying ? Color.blue.opacity(0.4) : Color.gray.opacity(0.05)
    }
    
    private var buttonColor: Color {
        Color.blue.opacity(0.5)
    }

    var body: some View {
        HStack {
            Button(action: decrementNote) {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundColor(buttonColor)
            }
            
            Text(noteLabel)
                .font(Font.custom("NanumGothicCoding", size: 16))                .frame(minWidth: 50)
                .padding(10) // Add padding around the text
                .background(noteBackgroundColor) // Use computed background color
                .cornerRadius(10) // Rounded corners
                .overlay( // Outline
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(noteOutlineColor, lineWidth: 2) // Use computed outline color
                )
            
            Button(action: incrementNote) {
                Image(systemName: "chevron.right")
                    .font(.title)
                    .foregroundColor(buttonColor)
            }
        }
        .font(.largeTitle)
        .frame(minWidth: 40)
        .padding(10) // Add padding around the text
        .background(Color.gray.opacity(0.1)) // Background color for the whole HStack
        .cornerRadius(15) // Rounded corners
        .overlay( // Outline for the entire HStack
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.1), lineWidth: 2)
        )
        .padding()
    }
    
    // Function to increment the note
    private func incrementNote() {
        note += 1
    }
    
    // Function to decrement the note
    private func decrementNote() {
        note -= 1
    }
}

struct NoteSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        NoteSelectorView(note: .constant(36), playedNotes: .constant([36])) // Preview with MIDI note C2 (36)
    }
}
