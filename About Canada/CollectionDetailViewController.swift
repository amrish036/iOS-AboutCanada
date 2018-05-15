//
//  CollectionDetailViewController.swift
//  About Canada
//
//  Created by Amrish Mahesh on 13/5/18.
//  Copyright © 2018 Amrish Mahesh. All rights reserved.
//

import UIKit

class CollectionDetailViewController: UIViewController {

  @IBOutlet weak var image: UIImageView!
  @IBOutlet weak var descriptionLabel: UITextView!
  
  var imageData = UIImage() 
  var descriptionText = ""
  
  override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view.
        image.image = imageData
        descriptionLabel.text = descriptionText
        descriptionLabel.textAlignment = NSTextAlignment.center
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
