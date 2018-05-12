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
  var size: CGSize?
  var imageData: UIImage?
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
  //MARK: Variables and Outlets
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
       
        if let dataFromString = responseObject.data(using: .utf8, allowLossyConversion: false) {
          let json = try! JSON(data: dataFromString)
         
          let allElements = json["rows"]
          
          self.navigationItem.title = json["title"].string
          
          for item in allElements {
            let thisItem = Element(title:item.1["title"].string,
                                   description:item.1["description"].string,
                                   imageHref:(item.1["imageHref"].string),
                                   size:CGSize(width:0,height:0),
                                   imageData: UIImage(named: "default-image.png"))
            self.elements.append(thisItem)
          }
        }
      }else{
        print("Error Loading Content")
      }
      
      self.CollectionView.reloadData()
    }
  }
  
  //MARK: CollectionView
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.elements.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
    var data : Data?
    if self.elements.count > 0  {
      
      DispatchQueue.global(qos: .background).async {
        // Background Thread
        if(self.elements[indexPath.row].imageHref != nil){
          
          let imageUrl: URL? = URL(string: self.elements[indexPath.row].imageHref!)
          data = try? Data(contentsOf: imageUrl!)

        }
        DispatchQueue.main.async {
          // Run UI Updates or call completion block
          if let imageData = data {
            cell.imageCell.image = UIImage(data: imageData)
           
            if cell.imageCell.image != nil {
              let size = CGSize(width: (cell.imageCell.image?.size.width)!, height: (cell.imageCell.image?.size.height)!)
              print(size)
              self.elements[indexPath.row].size = size
              self.elements[indexPath.row].imageData = UIImage(data:imageData)
            }

          }
          if data == nil {
            cell.imageCell.image = UIImage(named: "default-image.png")
          }
          if(self.elements[indexPath.row].imageHref == nil){
            cell.imageCell.image = UIImage(named: "default-image.png")
          }
        }
        
      }
      
      
      cell.labelCell.text = self.elements[indexPath.row].title
      
      return cell
      
    }
    
    cell.imageCell.image = UIImage(named: "default-image.png")
    cell.labelCell.text = "Canada"
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let mainStoryboard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
    let CollectionDVController = mainStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as! CollectionDetailViewController
    CollectionDVController.imageData = elements[indexPath.row].imageData!
    CollectionDVController.desc = elements[indexPath.row].description!
    CollectionDVController.title = elements[indexPath.row].title!
    self.navigationController?.pushViewController(CollectionDVController, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    return CGSize(width:100, height:150)
  }
  
  
  
}


