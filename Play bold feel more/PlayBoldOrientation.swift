import UIKit

/// Manages the current orientation mask for the application window scenes.
final class PlayBoldOrientationManager {
    static let shared = PlayBoldOrientationManager()

    private init() {}

    private(set) var currentMask: UIInterfaceOrientationMask = .allButUpsideDown

    func updateAllowedOrientations(_ mask: UIInterfaceOrientationMask) {
        DispatchQueue.main.async {
            guard self.currentMask != mask else { return }
            self.currentMask = mask

            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .forEach { $0.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations() }

            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}

/// App delegate bridge so SwiftUI asks us for the current orientation mask.
final class PlayBoldAppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        PlayBoldOrientationManager.shared.currentMask
    }
}
