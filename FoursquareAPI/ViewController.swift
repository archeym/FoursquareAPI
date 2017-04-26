//
//  ViewController.swift
//  FoursquareAPI
//
//  Created by Arkadijs Makarenko on 25/04/2017.
//  Copyright © 2017 ArchieApps. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var venues = [Venue]()
    var cat = "all"
    var filterdVenues = [Venue]()
    let lat = 3.1374262
    let lng = 101.6328546
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        mapView.delegate = self
        segmentedControl.selectedSegmentIndex = 0
        mapView.isHidden = true
        findPlace()
    }
    
    func findOnMap(){
        
        for venue in venues{
            let lat = venue.lat
            let lng = venue.lng
        let venueAnnotation = MKPointAnnotation()
        venueAnnotation.title = venue.name
        venueAnnotation.subtitle = venue.address
        venueAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        mapView.addAnnotation(venueAnnotation)
        mapView.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: lng), animated: true)
    }
}
    @IBAction func segmentControllTapped(_ sender: Any) {
        if self.segmentedControl.selectedSegmentIndex == 1{
            tableView.isHidden = true
            mapView.isHidden = false
            findOnMap()
        }else{
            tableView.isHidden = false
            mapView.isHidden = true
        }
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

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      
            let annotationView = MKAnnotationView()
            annotationView.image = UIImage(named: "pin")
            annotationView.canShowCallout = true
            annotationView.leftCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if let detailController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController{
            for venue in venues{
                if venue.name == (view.annotation?.title)!{
                detailController.selectedVenue = venue
            }
            }
            navigationController?.pushViewController(detailController, animated: true)
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let coord = view.annotation?.coordinate else {
            return
        }
    
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coord, span: span)
        mapView.setRegion(region, animated: true)
    }
}

