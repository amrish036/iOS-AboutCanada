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
  
  @IBOutlet weak var CollectionView: UICollectionView!
  var refresher: UIRefreshControl!
  var elements = [Element]()
  let requestURL = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json/get"
  let defaultSize = CGSize(width:100,height:150)
  let defaultImage = UIImage(named: "default-image.png")
  
  let reachabilityManager = Alamofire.NetworkReachabilityManager(host:"www.google.com")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    CollectionView.delegate = self
    CollectionView.dataSource = self
    
    (reachabilityManager?.isReachable)! ? getJSONData() :  alert(title: "📵", message: "No Internet Connection 😢")
    
    refresher = UIRefreshControl()
    refresher.attributedTitle = NSAttributedString(string:"Pull to refresh")
    refresher.addTarget(self, action: #selector(ViewController.refresh), for: UIControlEvents.valueChanged)
    CollectionView.addSubview(refresher)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: Network Calls
  func getJSONData(){

    Alamofire.request(self.requestURL).responseString { response in
      
      if let responseObject = response.result.value {
        
        if let dataFromString = responseObject.data(using: .utf8, allowLossyConversion: false) {
          let json = try! JSON(data: dataFromString)
          
          let allElements = json["rows"]
          
          self.navigationItem.title = json["title"].string
          
          for item in allElements {
            
            let thisItem = Element(title:item.1["title"].string,
                                   description:item.1["description"].string,
                                   imageHref:(item.1["imageHref"].string),
                                   size: self.defaultSize,
                                   imageData: self.defaultImage)
            
            self.elements.append(thisItem)
          }
        }
      } else {
        self.alert(title: "Error", message: "Error Loading Content")
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
    cell.imageCell.image = self.defaultImage
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
            
            if self.elements.count > 0 {
              if cell.imageCell.image != nil {
                let size = CGSize(width: (cell.imageCell.image?.size.width)!, height: (cell.imageCell.image?.size.height)!)
                self.elements[indexPath.row].size = size
                self.elements[indexPath.row].imageData = UIImage(data:imageData)
                self.elements[indexPath.row].size = self.elements[indexPath.row].imageData?.size
                self.CollectionView.collectionViewLayout.invalidateLayout()
              } else {
                self.elements[indexPath.row].size = CGSize(width:100,height:100)
                cell.imageCell.image = self.defaultImage
              }
              
              if(self.elements[indexPath.row].imageHref == nil || data == nil){
                self.elements[indexPath.row].size = CGSize(width:100,height:100)
                cell.imageCell.image = self.defaultImage
              }
              cell.setNeedsLayout()
            } else {
              print("0 elements")
            }
          }
        }
        
      }
      
      if(self.elements[indexPath.row].title != nil){
        cell.labelCell.text = self.elements[indexPath.row].title
      } else {
        cell.labelCell.text = "No Title!"
      }
      return cell
    }
    
    cell.imageCell.image = self.defaultImage
    cell.labelCell.text = "Canada"
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let mainStoryboard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
    let CollectionDVController = mainStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as! CollectionDetailViewController
    if self.elements.count > 0 {
      CollectionDVController.imageData = elements[indexPath.row].imageData!
      
      if(elements[indexPath.row].description != nil){
        CollectionDVController.desc = elements[indexPath.row].description!
      }
      if (elements[indexPath.row].title != nil){
        CollectionDVController.title = elements[indexPath.row].title!
      }
      self.navigationController?.pushViewController(CollectionDVController, animated: true)
    } else {
      alert(title: "Error!", message: "No Content")
    }
    
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return self.elements[indexPath.row].size!
  }
  
  // MARK: Methods
  
  @objc func refresh(){
    refresher.endRefreshing()
    self.elements.removeAll()
    (reachabilityManager?.isReachable)! ? getJSONData() :  alert(title: "📵", message: "No Internet Connection 😢")
    
  }
  
  func alert(title:String,message:String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
}


