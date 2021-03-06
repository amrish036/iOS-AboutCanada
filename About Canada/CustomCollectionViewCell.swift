//
//  CustomCollectionViewCell.swift
//  About Canada
//
//  Created by Amrish Mahesh on 12/5/18.
//  Copyright © 2018 Amrish Mahesh. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
  //MARK: IBOutlets and Variables
  @IBOutlet weak var imageCell: UIImageView!
  @IBOutlet weak var labelCell: UILabel!
  
  //MARK: Methods
  override func prepareForReuse() {
    
    imageCell.image = nil
    labelCell.text = nil
    super.prepareForReuse()
    
  }
  
}

