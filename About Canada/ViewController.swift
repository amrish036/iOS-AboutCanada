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

struct Element {
  let title: String?
  let description: String?
  let imageHref: String?
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.elements.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
    
    if self.elements.count > 0  {
      
      if(self.elements[indexPath.row].imageHref != nil){
        let imageUrl: URL? = URL(string: self.elements[indexPath.row].imageHref!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
          cell.imageCell.image = UIImage(data: imageData)
        }
      }else{
        cell.imageCell.image = UIImage(named: "default-image.png")
      }
      
      
      cell.labelCell.text = self.elements[indexPath.row].title
      
      return cell
      
    }
    
    cell.imageCell.image = UIImage(named: "default-image.png")
    cell.labelCell.text = "Canada"
    
    return cell
  }
  
  var elements = [Element]()
  
  @IBOutlet weak var CollectionView: UICollectionView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    CollectionView.delegate = self
    CollectionView.dataSource = self
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
          let allElements = json["rows"]
          
          for item in allElements {
            let thisItem = Element(title:item.1["title"].string,
                                   description:item.1["description"].string,
                                   imageHref:(item.1["imageHref"].string))
            self.elements.append(thisItem)
          }
        }
      }else{
        print("Error Loading Content")
      }
      self.CollectionView.reloadData()
    }
  }
  
  
}

