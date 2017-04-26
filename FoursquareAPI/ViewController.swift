//
//  ViewController.swift
//  FoursquareAPI
//
//  Created by Arkadijs Makarenko on 25/04/2017.
//  Copyright © 2017 ArchieApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var venues = [Venue]()
    var cat = "all"
    var filterdVenues = [Venue]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        findPlace()
    }
    func findPlace(){
        let urlString = "https://api.foursquare.com/v2/venues/search?client_id=APAVEFQV0VQCR1DJFA05K1OXUEWWEIC2PBBBFJPOKL20C3TK&client_secret=DESPA21MBYVBDPH03COSKZXEZI0NPCLPJBWKFWPIENJGQJCU&v=20130815&ll=3.135394,101.629894&query=\(cat)"
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
            print(data)
            do{
                if let dictData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
                    print(dictData)
                    self.populateData(dictData)
                }
            }catch{
                print("Error when converting JSON")
            }

        }
        task.resume()
    }
    
    func populateData(_ dict: [String: Any]){
        
        if let responseDict = dict["response"] as? [String : Any]{
            if let venuesDict = responseDict["venues"] as? [[String:Any]]{
                for venue in venuesDict {
                    let newVenue = Venue(dict: venue)
                    venues.append(newVenue)
                    
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell()}
        cell.textLabel?.text = venues[indexPath.row].name
        cell.detailTextLabel?.text = "\(venues[indexPath.row].address), \(venues[indexPath.row].city)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController{
            detailController.selectedVenue = venues[indexPath.row]
            navigationController?.pushViewController(detailController, animated: true)
        }
    }

}//end



