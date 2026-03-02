//
//  PGUApp.swift
//  PGU
//
//  Created by Bryan Arambula on 11/21/23.
//

import SwiftUI
import FirebaseCore
import UserNotifications
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseMessaging
import FirebaseAnalytics
import CoreData
import MapKit
import CoreLocation
import AVFoundation
import MediaPlayer
import AppTrackingTransparency
import AdSupport




@main
struct PGUApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    
    let navigationState = NavigationState() // The NavigationState instance


    let locationManager = CLLocationManager()

    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenceController.persistentContainer.viewContext)
                .environmentObject(AudioPlayerManager.shared)
                .environmentObject(ViewState.shared) // Add this line to share ViewState across your views.
                .environmentObject(NavigationState.shared) // Provide NavigationState to the environment
        }
    }
}



// Define the AppDelegate class to configure Firebase
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    


    //NOT SURE WHAT THIS CODE IF USED FOR ⬇️
    let gcmMessageIDKey = "gcm.message_id"



//    var navigationState: NavigationState?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        print("Application didFinishLaunchingWithOptions called")
        
        FirebaseApp.configure()
        Firestore.firestore()
        
        Analytics.logEvent("app_launch", parameters: nil)

        
        Installations.installations().installationID { (installationID, error) in
          if let error = error {
            print("Error fetching installation ID: \(error)")
            return
          }
          print("Installation ID: \(installationID ?? "None")")
        }
        
        
        // Request notification authorization
        let center = UNUserNotificationCenter.current()
         center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
             if let error = error {
                 print("Authorization request error: \(error)")
             } else {
                 print("Authorization granted: \(granted)")
                 if granted {
                     DispatchQueue.main.async {
                         application.registerForRemoteNotifications()
                     }
                 } else {
                     print("User denied notification permissions")
                     // Handle the denial of permissions here
                 }
             }
         }
        
        
         center.delegate = self


        // Set up FIRMessaging's delegate
        Messaging.messaging().delegate = self
      
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
        
        Analytics.logEvent("on_foreground", parameters: nil)

        
        application.registerForRemoteNotifications()

        
        return true
     
    }
    
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Analytics.logEvent("on_foreground", parameters: nil)
    }

    
//    func requestTrackingAuthorizationIfNeeded() {
//        // Check if the authorization status is not determined
//        if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
//            // Request user's permission
//            ATTrackingManager.requestTrackingAuthorization { status in
//                switch status {
//                case .authorized:
//                    // Permission granted by the user
//                    print("Tracking authorized by the user")
//                case .denied, .restricted, .notDetermined:
//                    // Permission denied or restricted by the user or system
//                    print("Tracking not authorized")
//                @unknown default:
//                    // Handle future enum cases
//                    print("Unknown tracking authorization status")
//                }
//            }
//        } else {
//            print("Tracking authorization status already determined: \(ATTrackingManager.trackingAuthorizationStatus)")
//        }
//    }
    
    @objc func handleInterruption(notification: Notification) {
        guard let info = notification.userInfo,
              let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                  return
              }

        if type == .began {
            // Interruption began, pause the audio
        } else if type == .ended {
            // Interruption ended, resume the audio
            try? AVAudioSession.sharedInstance().setActive(true)
            // Resume playback if necessary
        }
    }
    
    // Remember to remove the observer when it's no longer needed
    deinit {
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("APNs device token retrieved: \(deviceToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }


    // MARK: LOGIC FOR RETREIVING THE FCM TOKEN AND PRINTING IT
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("FCM Token received: \(fcmToken ?? "nil")")
      // Rest of your token handling code...
        
        if let token = fcmToken {
               saveTokenToFirestore(token)
           }
        
    }
    
    func saveTokenToFirestore(_ token: String) {
        // Assuming you have a `userId` to associate with the token
        let userId = "someUserId" // Replace with actual user ID
        let db = Firestore.firestore()
        db.collection("user_tokens").document(userId).setData(["fcmToken": token]) { error in
            if let error = error {
                print("Error saving token to Firestore: \(error)")
            } else {
                print("Token successfully saved to Firestore")
            }
        }
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("hello world")
  
    }




    //MARK: LOGIC FOR SAVING THE FCM NOTIFICATION TO COREDATA
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        completionHandler([.alert, .badge, .sound])


        let userInfo = notification.request.content.userInfo
        
        if let notificationDict = userInfo["aps"] as? [String: AnyObject],
           let alertDict = notificationDict["alert"] as? [String: AnyObject],
           let title = alertDict["title"] as? String,
           let body = alertDict["body"] as? String {
            saveNotificationToCoreData(title: title, body: body)
        }
        
        saveNotificationToFirestore(userInfo)

    }
    

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        if let notificationDict = userInfo["aps"] as? [String: AnyObject],
           let alertDict = notificationDict["alert"] as? [String: AnyObject],
           let title = alertDict["title"] as? String,
           let body = alertDict["body"] as? String {
            saveNotificationToCoreData(title: title, body: body)
        }
 
        saveNotificationToFirestore(userInfo)
        
        DispatchQueue.main.async {
            NavigationState.shared.showInbox = true
        }
        
        completionHandler()
    }

    
    func saveNotificationToFirestore(_ userInfo: [AnyHashable: Any]) {
        guard let aps = userInfo["aps"] as? [String: AnyObject],
              let alert = aps["alert"] as? [String: String],
              let title = alert["title"],
              let body = alert["body"] else {
            print("Invalid notification content")
            return
        }

        let db = Firestore.firestore()
        let notificationData: [String: Any] = [
            "title": title,
            "body": body,
            "timestamp": FieldValue.serverTimestamp(),
            // You can add more fields if necessary
        ]
        
        // Save the notification in a separate 'notifications' collection
        db.collection("notifications").addDocument(data: notificationData) { error in
            if let error = error {
                print("Error saving notification to Firestore: \(error)")
            } else {
                print("Notification successfully saved to Firestore")
            }
        }
        

    }


    func saveNotificationToCoreData(title: String, body: String) {
        let context = PersistenceController.shared.persistentContainer.viewContext
        let newNotification = Notifi(context: context)
        newNotification.title = title
        newNotification.body = body

        do {
            try context.save()
        } catch {
            print("Failed to save notification: \(error)")
        }
        
        printAllNotifications()
    }
    
    
    func printAllNotifications() {
        let context = PersistenceController.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Notifi> = Notifi.fetchRequest()

        do {
            let notifications = try context.fetch(fetchRequest)
            for notification in notifications {
                print("Title: \(notification.title ?? "Unknown Title"), Body: \(notification.body ?? "No Body")")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

}


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var lastLocation: CLLocation?
    @Published var userLocation: Location?


    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        print("Access to location granted successfully")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Received location update: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            self.userLocation = Location(title: "My Location", coordinate: location.coordinate, isUserLocation: true)
            self.lastLocation = location
        } else {
            print("Received location update but no location available")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}




