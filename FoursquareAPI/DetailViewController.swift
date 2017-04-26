//
//  DetailViewController.swift
//  FoursquareAPI
//
//  Created by Arkadijs Makarenko on 25/04/2017.
//  Copyright © 2017 ArchieApps. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var reviewText = [String]()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var selectedVenue : Venue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if selectedVenue == nil {
            return
        }
        nameLabel.text = selectedVenue.name
        phoneLabel.text = selectedVenue.phone
        addressLabel.text = "\(selectedVenue.address), \(selectedVenue.city)"
        urlLabel.text = selectedVenue.url
        categoryLabel.text = selectedVenue.categoryName
        findReview()
    }
    
    func findReview(){
        let urlString = "https://api.foursquare.com/v2/venues/\(selectedVenue.id)?client_id=APAVEFQV0VQCR1DJFA05K1OXUEWWEIC2PBBBFJPOKL20C3TK&client_secret=DESPA21MBYVBDPH03COSKZXEZI0NPCLPJBWKFWPIENJGQJCU&v=20130815&ll=3.135394,101.629894&query=sushi"
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, responce, error) in
            if let err = error {
                print("Error \(err.localizedDescription)")
                return
            }
            guard let data = data
                else{
                    print("data error")
                    return
            }
            
            do{
                if let dictData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    self.populateReview(dictData)
                }
            }catch{
                print("Error when converting JSON")
            }
            
        }
        task.resume()
    }
    
    func populateReview(_ dict: [String: Any]){
        if let responseDict = dict["response"] as? [String : Any]{
            if let venuesDict = responseDict["venue"] as? [String:Any]{
                
                if let tipsDict = venuesDict["tips"] as? [String:Any]{
                    if let groupDict = tipsDict["groups"] as? [[String:Any]]{
                        for group in groupDict{
                            
                            if let itemDict = group["items"] as? [[String:Any]]{
                                for txt in itemDict{
                                    reviewText.append(txt["text"] as! String)
                                    
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        //  }
                    }
                }
            }
        }
    }
    
    @IBAction func urlTapped(_ sender: Any){
        UIApplication.shared.open(URL(string: selectedVenue.url)!, options: [:], completionHandler: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "review") else { return UITableViewCell()
        }
        cell.detailTextLabel?.text = reviewText[indexPath.row]
        return cell
    }
}
