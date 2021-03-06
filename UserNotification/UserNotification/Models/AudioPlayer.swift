//
//  AudioPlayer.swift
//  UserNotification
//
//  Created by κΉνν on 2022/02/22.
//

import Foundation
import AVFoundation
import CoreHaptics

struct AudioPlayer {
    let audioPlayer: AVAudioPlayer
    let soundPlayer: SoundPlayer = SoundPlayer()
    let identifier: String
    let startDate: Date
}
