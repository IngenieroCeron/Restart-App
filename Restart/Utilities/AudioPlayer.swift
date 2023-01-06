//
//  AudioPlayer.swift
//  Restart
//
//  Created by Eduardo Ceron on 08/02/22.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        }catch {
            print("No se pudo reproducir sonido")
        }
    }
}
