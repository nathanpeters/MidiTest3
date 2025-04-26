import SwiftUI

struct MegaView: View {
    @ObservedObject var synth = Synth()
    
    //MAIN TAB NAV
    var body: some View {
        TabView {
            Tab("Sequencer", systemImage: "pianokeys") {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    Sequencer(synth: synth)
//                        .font(.custom("NanumGothicCoding", size: 16))

                }
            }
            Tab("Synthesizer", systemImage: "testtube.2") {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    SynthControls(synth: synth)
                    
                }
            }
            Tab("Settings", systemImage: "gearshape") {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    MIDISettingsView()
                }
            }
        }
    }
}

#Preview{
    MegaView()
}

