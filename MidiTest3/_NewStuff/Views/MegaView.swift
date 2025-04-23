import SwiftUI

struct MegaView: View {
    
    //MAIN TAB NAV
    var body: some View {
        TabView {
            Tab("Sequencer", systemImage: "pianokeys") {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    Sequencer()
                }
            }
            Tab("Prototype", systemImage: "testtube.2") {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    PrototypeView()
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

