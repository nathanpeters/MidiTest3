//
//  Styles.swift
//  MidiTest3
//
//  Created by Nathan Peters on 4/26/25.
//
import SwiftUI

struct InsetContainer: View {
    let width: CGFloat
    let height: CGFloat
    var body: some View{
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.theme.buttonBackground)
            .stroke(Color.theme.buttonInset, lineWidth: 2)
            .strokeBorder(Color.theme.buttonOutline, lineWidth: 1)                                .frame(width: width, height: height)
    }
}
