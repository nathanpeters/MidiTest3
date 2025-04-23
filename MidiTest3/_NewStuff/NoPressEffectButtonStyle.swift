//
//  NoPressEffectButtonStyle.swift
//  MidiTest3
//
//  Created by Nathan Peters on 4/21/25.
//


import SwiftUI

struct NoPressEffectButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(1.0)
            .animation(.easeInOut(duration: 0.4), value: configuration.isPressed)
    }
}