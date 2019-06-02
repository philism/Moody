//
//  CameraViewController.swift
//  Moody
//
//  Created by Philip Smith on 5/26/19.
//  Copyright © 2019 Philip Smith. All rights reserved.
//
import UIKit


protocol CameraViewControllerDelegate: class {
    func didCapture(_ image: UIImage)
}


class CameraViewController: UIViewController {
    
    @IBOutlet weak var cameraView: CameraView!
    weak var delegate: CameraViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session = CaptureSession(delegate: self)
        #if !IOS_SIMULATOR
        cameraView?.setup(for: session.createPreviewLayer())
        #endif
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(snap))
        cameraView?.addGestureRecognizer(recognizer)
        updateAuthorizationStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        session.stop()
        super.viewDidDisappear(animated)
    }
    
    @IBAction func snap(_ recognizer: UITapGestureRecognizer) {
        #if IOS_SIMULATOR
        self.showImagePicker()
        #else
        session.captureImage()
        #endif
    }
    
    
    // MARK: Private
    
    fileprivate var session: CaptureSession!
    fileprivate var imagePicker: UIImagePickerController?
    
    fileprivate var readyToSnap: Bool {
        return session.isAuthorized
    }
    
    fileprivate func showImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        present(imagePicker!, animated: true, completion: nil)
    }
    
    fileprivate func updateAuthorizationStatus() {
        cameraView?.authorized = readyToSnap
    }
    
}


extension CameraViewController: CaptureSessionDelegate {
    
    func captureSessionDidCapture(_ image: UIImage?) {
        guard let image = image else { return }
        self.delegate.didCapture(image)
    }
    
    
    func captureSessionDidChangeAuthorizationStatus(authorized: Bool) {
        updateAuthorizationStatus()
    }
    
}


extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            delegate.didCapture(image)
        }
        dismiss(animated: true, completion: nil)
        imagePicker = nil
    }
    
}

