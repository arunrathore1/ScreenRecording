//
//  AppDelegate.swift
//  ScreenRecordingApp
//
//  Created by Arun Rathore on 26/03/23.
//

import UIKit
import ReplayKit

@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var screenRecorder: RPScreenRecorder!
  var previewViewController: RPPreviewViewController?
  var window: UIWindow?

  static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {



    // Override point for customization after application launch.
   let window = UIWindow(frame: UIScreen.main.bounds)
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
    let navigationController = UINavigationController(rootViewController: vc)
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    self.window = window
    self.screenRecorder = RPScreenRecorder.shared()
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


  func recordScreen() {
    if self.screenRecorder.isAvailable {
      self.screenRecorder.isMicrophoneEnabled = false
//      self.screenRecorder.cameraPreviewView


      self.screenRecorder.startRecording(handler: { [weak self] (error) in
        if let error = error {
          print("Recording failed to start: \(error.localizedDescription)")
        } else {
          print("Recording started.")
        }
      })




//      self.screenRecorder.startRecording { error in
//
//      }
    }
  }

  func stopRecording() {
   self.screenRecorder.stopRecording { [self] (previewViewController, error) in
     if let error = error {
       print("Recording failed to stop: \(error.localizedDescription)")
     } else if let previewViewController = previewViewController {
       self.previewViewController = previewViewController
       previewViewController.previewControllerDelegate = self
       previewViewController.modalPresentationStyle = .fullScreen


       if var topController = UIApplication.shared.keyWindow?.rootViewController {
           while let presentedViewController = topController.presentedViewController {
               topController = presentedViewController
           }
         topController.present(previewViewController, animated: true, completion: nil)
       }
     }
   }
 }


}

@available(iOS 13.0, *)
extension AppDelegate: RPPreviewViewControllerDelegate {
  func previewControllerDidFinish(_ previewController: RPPreviewViewController) {

  }

  func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
    if activityTypes.contains("com.apple.UIKit.activity.SaveToCameraRoll") {
      print("Recording saved to camera roll.")
    }
  }
}
