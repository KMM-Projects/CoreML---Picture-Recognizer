//
//  RoundedShadowImageView.swift
//  Vision-app-dev
//
//  Created by Patrik Kemeny on 1/5/18.
//  Copyright © 2018 Patrik Kemeny. All rights reserved.
//

import UIKit

class RoundedShadowImageView: UIImageView {

    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.75
        self.layer.cornerRadius = 15
        
        
    }

}
