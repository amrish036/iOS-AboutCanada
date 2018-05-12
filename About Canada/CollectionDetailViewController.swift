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
  var desc = ""
  
  override func viewDidLoad() {
        super.viewDidLoad()
        image.image = imageData
        descriptionLabel.text = desc
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
