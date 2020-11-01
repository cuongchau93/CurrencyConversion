//
//  EmotionViewController.swift
//  SimpleSwiftApp
//
//  Created by Chau, Cuong | DCMS on 2020/11/01.
//  Copyright © 2020 Chau, Cuong | DCMS. All rights reserved.
//

import UIKit

class EmotionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destination;
        if let faceVC = destinationVC as? FacialViewController,
            let identifier = segue.identifier,
            let expression = emotionalFaces[identifier] {
            faceVC.expression = expression
        }
             
    }

    private let emotionalFaces: Dictionary<String, FacialExpression> = [
        "sad": FacialExpression(eyes: .close, mouth: .frown),
        "happy": FacialExpression(eyes: .open, mouth: .smile),
        "worried": FacialExpression(eyes: .open, mouth: .smirk)
    ]
}
