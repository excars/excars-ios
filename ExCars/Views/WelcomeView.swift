//
//  RoleView.swift
//  ExCars
//
//  Created by Леша on 28/11/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit


class WelcomeView: XibView {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var officePicker: UIPickerView!

    private let user: User
    
    var onRoleSelect: ((Role, Destination) -> Void)?
    
    private let offices = [
        Destination(name: "Eleftherias", latitude: 34.674297, longitude: 33.039742),
        Destination(name: "Porto Bello", latitude: 34.6709681, longitude: 33.0396582),
        Destination(name: "Ellinon", latitude: 34.673039, longitude: 33.039255),
    ]

    init(currentUser: User, frame: CGRect = CGRect.zero) {
        self.user = currentUser
        
        super.init(nibName: "WelcomeView", frame: frame)
        
        officePicker.dataSource = self
        officePicker.delegate = self
        officePicker.selectRow(1, inComponent: 0, animated: true)
        
        welcomeLabel.text = "Welcome, \(currentUser.name)!"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func drive() {
        let destination = officePicker.selectedRow(inComponent: 0)
        onRoleSelect?(Role.driver, offices[destination])
    }

    @IBAction func hitchhike() {
        let destination = officePicker.selectedRow(inComponent: 0)
        onRoleSelect?(Role.driver, offices[destination])
    }

}


extension WelcomeView: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return offices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return offices[row].name
    }

}
