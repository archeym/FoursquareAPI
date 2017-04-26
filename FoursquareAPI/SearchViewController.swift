//
//  SearchViewController.swift
//  FoursquareAPI
//
//  Created by Arkadijs Makarenko on 25/04/2017.
//  Copyright © 2017 ArchieApps. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self

    }

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        if let  viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController{
            guard let text = searchTextField.text?.lowercased() else {
                return
            }
            viewController.cat = text
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
