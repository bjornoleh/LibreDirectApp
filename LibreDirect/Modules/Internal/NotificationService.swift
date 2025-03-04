//
//  NotificationCenterService.swift
//  LibreDirect
//

import AVFoundation
import Foundation
import UIKit
import UserNotifications

class NotificationService {
    // MARK: Lifecycle

    private init() {}

    // MARK: Internal

    static let shared = NotificationService()

    func isPlaying() -> Bool {
        if let player = player {
            return player.isPlaying
        }

        return false
    }

    func stopSound() {
        guard let player = player else {
            return
        }

        if player.isPlaying {
            player.stop()
        }
    }

    func playSilentSound() {
        playSound(named: "silent")
    }

    func playAlarmSound() {
        playSound(named: "alarm")
    }

    func playExpiringSound() {
        playSound(named: "expiring")
    }

    func playNegativeSound() {
        playSound(named: "negative")
    }

    func playPositiveSound() {
        playSound(named: "positive")
    }

    func add(identifier: String, content: UNMutableNotificationContent) {
        let center = UNUserNotificationCenter.current()
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)

        Log.info("NotificationCenter, identifier: \(identifier)")
        Log.info("NotificationCenter, content: \(content)")

        center.removeDeliveredNotifications(withIdentifiers: [identifier])
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        center.add(request)
    }

    func ensureCanSendNotification(_ completion: @escaping (_ canSend: Bool) -> Void) {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    // MARK: Private

    private var player: AVAudioPlayer?

    private func playSound(named: String) {
        guard let soundURL = FrameworkBundle.main.url(forResource: named, withExtension: "aiff") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            Log.error("NotificationCenter, could not set AVAudioSession category to playback and mixwithOthers, error = \(error.localizedDescription)")
        }

        do {
            let player = try AVAudioPlayer(contentsOf: soundURL)
            player.volume = 0.5
            player.play()

            self.player = player
        } catch {
            Log.error("NotificationCenter, exception while trying to play sound, error = \(error.localizedDescription)")
        }
    }
}
