//
//  Color.swift
//  MidiTest3
//
//  Created by Nathan Peters on 4/20/25.
//
import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let primaryAction = Color("PrimaryAction")
    let buttonBackground = Color("ButtonBackground")
    let buttonOutline = Color("ButtonOutline")
    let buttonInset = Color("ButtonInset")
    let lightedButtonIdle = Color("LightedButtonIdle")
    let lightedButtonActive = Color("LightedButtonActive")
    let textDisplay = Color("TextDisplay")
    let backgroundSequence = Color("BackgroundSequence")
    let labelBackground1 = Color("LabelBackground1")
    let labelBackground2 = Color("LabelBackground2")
}
