//
//  TutorialCell.swift
//  Cutiepie
//
//  Created by Appinventiv Mac on 17/04/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit

class TutorialCell: UICollectionViewCell {

    // IBOUTLETS
    //==========
    @IBOutlet weak var cellImageView: UIImageView!
    
    
    // LIFE CYCLE METHODS
    //===================
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }

}
extension TutorialCell{
    
    // FUNCTION
    //=========
    
    private func initialSetUp(){
        self.cellImageView.layer.cornerRadius = 12
    }
}
