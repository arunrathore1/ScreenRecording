//
//  ViewController.swift
//  ScreenRecordingApp
//
//  Created by Arun Rathore on 26/03/23.
//

import UIKit
import ReplayKit

class ViewController: UIViewController {
  
  var screenRecorder: RPScreenRecorder?
  var previewVC: RPPreviewViewController?

  override func viewDidLoad() {
    super.viewDidLoad()
    screenRecorder = RPScreenRecorder.shared()
  }


  @IBAction func recordScreen(_ sender: UIButton) {
    startRecordingWithSender(sender: sender)
  }

  @IBAction func stopRecording(_ sender: UIButton) {
    stopRecordingWithSender(sender: sender)
    //    AppDelegate.shared.stopRecording()
  }




  private func startRecordingWithSender(sender: UIButton?) {
    screenRecorder?.isMicrophoneEnabled = true
    screenRecorder?.startRecording(handler: {[weak self] (error) in
      guard error == nil else {
        self?.showErrorAlertWithMesage(message: "Sorry!! Your recording couldn't be started. Please try again.")
        return
      }
    })


  }


  private func stopRecordingWithSender(sender: UIButton?) {

    screenRecorder?.stopRecording(handler: {[weak self] (previewViewController, error) in
      DispatchQueue.main.async {
        guard error == nil else {
          self?.showErrorAlertWithMesage(message: "Sorry!! Your recording couldn't be stopped. Please try again.")
          return
        }

        previewViewController?.previewControllerDelegate = self
        self?.previewVC = previewViewController
        if let previewVC = self?.previewVC {
          self?.present(previewVC, animated: true, completion: nil)

        }
      }
    })
  }

  private func showErrorAlertWithMesage(message: String) {

    let alertController = UIAlertController(title: NSLocalizedString("Error", comment: "Camera Capture"), message:NSLocalizedString("This app doesn't have permission to use the camera. Please change the privacy settings", comment: "Camera Capture"), preferredStyle: UIAlertController.Style.alert)

    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
      alertController.addAction(okAction)
      present(alertController, animated: true, completion: nil)
  }

}

extension ViewController : RPPreviewViewControllerDelegate {

  func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {

    previewController.dismiss(animated: true) {

//      self.window?.isHidden = false

    }
  }

}

