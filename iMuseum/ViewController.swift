//
//  ViewController.swift
//  iMuseum
//
//  Created by Himaja Motheram on 4/10/17.
//  Copyright © 2017 Sriram Motheram. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let hostName = "https://data.imls.gov/resource/et8i-mnha.json"
    //var reachability :Reachability?
    
    @IBOutlet weak var MuseumTableView: UITableView!
    
     var MuseumArray = [Museum]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MuseumArray.count    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "museumcell", for: indexPath)
        let currentMuseum = MuseumArray[indexPath.row]
       
        cell.textLabel!.text = "Name: \(currentMuseum.name ?? "")"
       
        cell.detailTextLabel!.text = "\(currentMuseum.street!), \(currentMuseum.city!),\(currentMuseum.state!)"
        
     //   print("here1")
        return cell
    }
    
    
    
    
    @IBAction func searchPressed(button: UIBarButtonItem) {
        
        
        MuseumSearch ()
    }

    
    
    func MuseumSearch( )
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let urlString = hostName
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.timeoutInterval = 30
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let recvData = data else {
                print("No Data")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                return
            }
            if recvData.count > 0 && error == nil {
                print("Got Data:\(recvData)")
                let dataString = String.init(data: recvData, encoding: .utf8)
                print("Got Data String:\(dataString)")
                self.parseJson(data: recvData)
            } else {
                print("Got Data of Length 0")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        task.resume()
        
    }
    
    
    func parseJson(data: Data) {
       
        do {
            
let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) 
           
            
            let resultsArray = jsonResult as! [[String:Any]]
            
             MuseumArray .removeAll()
            
            for resultDictionary in resultsArray {
                
                
                    guard let Name = resultDictionary["commonname"] as? String else {
                        continue
                    }
                    guard let Street = resultDictionary["location_1_address"] as? String else {
                        continue
                    }
                    guard let City = resultDictionary["location_1_city"] as? String else {
                        continue
                    }
                    guard let State = resultDictionary["location_1_state"] as? String else {
                        continue
                    }
                
                    let Museum_New = Museum(name: Name, street: Street, city: City, state: State )
                
                   MuseumArray.append(Museum_New)
               // print("\(Museum_New.name)")
                
            }
            
            
                self.MuseumTableView.reloadData()
            
        } catch {
            print("JSON Parsing Error")
            
        }
        
       self.MuseumTableView.reloadData()
        DispatchQueue.main.async {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }


    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

}

