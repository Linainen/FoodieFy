//
//  DishDetailsViewController.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 22.08.23.
//

import UIKit
import ProgressHUD
import FirebaseAuth
import FirebaseStorageUI

class DishDetailsViewController: UIViewController {

    @IBOutlet var dishImageView: UIImageView!
    @IBOutlet var dishTitleLbl: UILabel!
    @IBOutlet var dishCaloriesLbl: UILabel!
    @IBOutlet var dishDescriptionLbl: UILabel!
    @IBOutlet var quantityLbl: UILabel!
    
    let storage = Storage.storage().reference()
    let dishDetailsModel = DishDetailsModel()
    var plate: DishFS!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tuneUI()
    }
    
    private func tuneUI(){
        let imageRef = storage.child("/images/\(plate.name ?? "noimage").jpg")
        dishImageView.sd_setImage(with: imageRef)
        dishTitleLbl.text = plate.name
        dishCaloriesLbl.text = plate.priceDescription
        dishDescriptionLbl.text = plate.description
    }
    
    @IBAction func quantityChanged(_ sender: UIStepper) {
        let plateQuantity = Int(sender.value)
        quantityLbl.text = "\(plateQuantity)"
    }
    
    @IBAction func placeOrderPressed(_ sender: UIButton) {
        let userPhone = Auth.auth().currentUser?.phoneNumber ?? ""
        guard let plateName = plate.name, let platePrice = plate.price, let plateQuantity = quantityLbl.text else {
            ProgressHUD.showError("Sorry, there was an error")
            return
        }
        dishDetailsModel.addOrderToFirestore(plateName: plateName, platePrice: platePrice, userPhone: userPhone, plateQuantity: plateQuantity)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
