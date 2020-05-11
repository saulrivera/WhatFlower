//
//  ViewController.swift
//  WhatFlower
//
//  Created by Saul Rivera on 10/05/20.
//  Copyright © 2020 Saul Rivera. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    private var imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func predict(from image: CIImage) {
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            fatalError("Error loading the model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Error loading the results")
            }
            
            if let firstResult = results.first {
                self.navigationItem.title = firstResult.identifier.capitalized
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicked = info[.editedImage] as? UIImage {
            imageView.image = imagePicked
            
            guard let ciimage = CIImage(image: imagePicked) else {
                fatalError("Error converting to CIImage")
            }
            
            predict(from: ciimage)
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
}

