//
//  ContentView.swift
//  Melo
//
//  Created by Bacho on 22.03.26.
//

import SwiftUI
import AudioKit
import AudioKitEX
import SoundpipeAudioKit

struct ContentView: View {
    let engine = AudioEngine()
    let sampler = AppleSampler()
    @State var name: String = ""
    
    var body: some View {
        
        VStack {
            
            TextField("Enter name", text: $name)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
            
            Button("Play My Name") {
                playName(name)
                
            }
        }
        .onAppear {
            engine.output = sampler
            try? engine.start()
            try? sampler.loadMelodicSoundFont("piano", preset: 0)
        }
    }
    
    func playName(_ name: String) {
        let scaleNotes: [UInt8] = [
            60, 62, 64, 65, 67, 69, 71,
            72, 74, 76, 77, 79, 81, 83,
            84, 86, 88, 89, 91, 93, 95,
            96, 98, 100, 101, 103
        ]
        
        let notes = name.uppercased()
            .filter { $0.isLetter }
            .map { scaleNotes[Int($0.asciiValue! - 65)] }
        
        for (i, note) in notes.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.35) {
                self.sampler.play(noteNumber: note, velocity: 100, channel: 0)
            }
        }
    }
}
