//
//  ViewController.swift
//  Vision-app-dev
//
//  Created by Patrik Kemeny on 1/5/18.
//  Copyright © 2018 Patrik Kemeny. All rights reserved.
//

import UIKit
import AVFoundation // camera Acces, AudioVisual Assets of camera
import CoreML
import Vision


class CameraVC: UIViewController {

    //Vars
    
    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var photoData: Data?
    
    
    
    
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCameraView))
        tap.numberOfTapsRequired = 1
        
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
            //crate a camera output and i we can add it to captureSession Do so
            cameraOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddOutput(cameraOutput) == true {
                captureSession.addOutput(cameraOutput!)
            
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect // set a content mode and maintain aspect ratio
                previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait //app is using portraid mode
                
                //put this whole session into CameraView / this is the sublayer
                cameraView.layer.addSublayer(previewLayer!)
                cameraView.addGestureRecognizer(tap)
                captureSession.startRunning()
                
            }
            //now convert the captureSession Output into layer what we can deiplay on the Screen
            
        } catch {
            debugPrint(error)
            
        }
    }

    //when you tap Save camera Image to view
    @objc func didTapCameraView(){
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType, kCVPixelBufferWidthKey as String: 160, kCVPixelBufferHeightKey as String: 160]
        settings.previewPhotoFormat = previewFormat
        
        cameraOutput.capturePhoto(with: settings, delegate: self) //missing delegate is in extension below.
        
    }
    // for comnpletion hadnler
    func resultsMethod(request: VNRequest, error: Error?){
        //handler the results
        guard let results = request.results as? [VNClassificationObservation] else {return}
        
        for classification in results {
            if classification.confidence < 0.5 {
                self.identificationLbl.text = "I'm not sure what this is. Please Try Again."
                self.confidenceLbl.text = ""
                break //leave for loop
            } else {
                self.identificationLbl.text = classification.identifier // what the model send back what it thinks it see
                self.confidenceLbl.text = "CONFIDENCE : \(classification.confidence * 100 )%"
                break
            }
        }
    }
}

extension CameraVC: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            debugPrint(error )
        } else {
            //what we get from screen we image and past that in into our imageview
            photoData = photo.fileDataRepresentation()
            
            //put photo intp CoreML Model
            do {
                let model = try VNCoreMLModel(for: SqueezeNet().model) //usign sqeeznet passing true vision
                //now we have the brain the model and we are truing to pass him a request
                let request = VNCoreMLRequest(model: model, completionHandler: resultsMethod ) //we put the things what we get back
                let handler = VNImageRequestHandler(data: photoData!)
                //this handler is working on our request
                try handler.perform([request])
                
            }
            catch {
                //hanle error
                debugPrint(error)
            }
            
            let image = UIImage(data: photoData!)
            self.captureImage.image = image
        }
    }
}















