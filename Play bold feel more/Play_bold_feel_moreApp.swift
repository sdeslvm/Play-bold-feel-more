//
//  Play_bold_feel_moreApp.swift
//  Play bold feel more

import SwiftUI

@main
struct Play_bold_feel_moreApp: App {
    @UIApplicationDelegateAdaptor(PlayBoldAppDelegate.self) private var appDelegate
    var body: some Scene {
        WindowGroup {
            PlayBoldGameInitialView()
        }
    }
}
