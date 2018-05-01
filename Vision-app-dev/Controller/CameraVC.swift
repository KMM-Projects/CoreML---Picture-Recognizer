//
//  ViewController.swift
//  Vision-app-dev
//
//  Created by Patrik Kemeny on 1/5/18.
//  Copyright © 2018 Patrik Kemeny. All rights reserved.
//

import UIKit
import AVFoundation // camera Acces, AudioVisual Assets of camera


class CameraVC: UIViewController {

    //Vars
    
    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    
    
    //Outlets
    
    @IBOutlet weak var roundedLblView: RoundedShadowView!
    @IBOutlet weak var captureImage: RoundedShadowImageView!
    @IBOutlet weak var flashBtn: RoundedShadowButton!
    @IBOutlet weak var identificationLbl: UILabel!
    @IBOutlet weak var confidenceLbl: UILabel!
    @IBOutlet weak var cameraView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer.frame = cameraView.bounds //fit the camera to view
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //camera Sesssions
        captureSession = AVCaptureSession() //start session
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080 // set session as full image
        //default device = back Camera
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video) //we cana capture the whole Screen of device
        //start according
        do {
            let input = try AVCaptureDeviceInput(device: backCamera!)
            if captureSession.canAddInput(input) == true {
                captureSession.addInput(input)
            }
            
            
        }
    }

}
















