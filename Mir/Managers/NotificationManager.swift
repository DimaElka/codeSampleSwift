//
//  NotificationManager.swift
//  Mir
//
//  Created by Dmitry Rogov on 08.12.2021.
//

import Foundation
import Firebase

class NotificationManager: NSObject {
    
    static let shared = NotificationManager()

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
    }
}

//MARK: - Notifications
extension NotificationManager: UNUserNotificationCenterDelegate {
    func registerForNotifications() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        guard let deeplinkString = userInfo["screen"] as? String,
              let deeplink = Deeplink(deeplinkString: deeplinkString) else {
                  return
              }
        
        AppCoordinator.shared.showDeeplink(deeplink)
        completionHandler()
    }
}

//MARK: - Messaging
extension NotificationManager: MessagingDelegate {
    func updateApnsToken(_ token: Data) {
        Messaging.messaging().apnsToken = token
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {
            return
        }

        let deviceName = UIDevice.current.name
        NetworkManager.shared.pushProvider
            .request(.sendPushToken(token: fcmToken, deviceName: deviceName)) { _ in
            }
    }
}
