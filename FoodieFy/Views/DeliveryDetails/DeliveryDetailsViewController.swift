//
//  DeliveryDetailsViewController.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 29.08.23.
//

import UIKit
import ProgressHUD
import Firebase

class DeliveryDetailsViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var adressTextField: UITextField!
    
    let deliveryModel = DeliveryDetailsModel()
    var orders: [OrderFS] = []
    var delegate: DeliveryDetailsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        guard let userName = nameTextField.text, let userPhone = Auth.auth().currentUser?.phoneNumber ,let userAdress = adressTextField.text, !userName.isEmpty, !userAdress.isEmpty else {
            ProgressHUD.showError("Please, fill all the fields")
            return
        }
        
        let user = userName.trimmingCharacters(in: .whitespaces)
        let adress = userAdress.trimmingCharacters(in: .whitespaces)
        
        guard !user.isEmpty, !adress.isEmpty else {
            ProgressHUD.showError("Please, fill all the fields")
            return
        }
        
        deliveryModel.fetchDelivery(userName: user, userAdress: adress, userPhoneNumber: userPhone, orders: self.orders)
        self.dismiss(animated: true)
        self.delegate?.orderCompleted()
    }
}
