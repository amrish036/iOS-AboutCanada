//
//  ViewController.swift
//  About Canada
//
//  Created by Amrish Mahesh on 12/5/18.
//  Copyright © 2018 Amrish Mahesh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    getJSONData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: Network Calls
  func getJSONData(){
    
    let requestURL = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json/get"
    
    Alamofire.request(requestURL).responseString { response in
      
      if let responseObject = response.result.value {
        print(responseObject)
        if let dataFromString = responseObject.data(using: .utf8, allowLossyConversion: false) {
          let json = try! JSON(data: dataFromString)
          print(json)
        }
      }else{
        print("Error Loading Content")
      }
    }
  }
  
  
}

