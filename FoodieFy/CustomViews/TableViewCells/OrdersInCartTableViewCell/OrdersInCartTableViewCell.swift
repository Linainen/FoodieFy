//
//  OrdersInCartTableViewCell.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 27.08.23.
//

import UIKit
import FirebaseStorage
import ProgressHUD
import FirebaseStorageUI
import Firebase

class OrdersInCartTableViewCell: UITableViewCell {

    static let identifier = String(describing: OrdersInCartTableViewCell.self)
    let storage = Storage.storage().reference()
    let dataBase = Firestore.firestore()
    var order: OrderFS? = nil
    
    @IBOutlet var orderImageView: UIImageView!
    @IBOutlet var orderNameLbl: UILabel!
    @IBOutlet var orderPlateQuantityLbl: UILabel!
    @IBOutlet var plateSumLbl: UILabel!
    
    @IBAction func deletePlateFromOrderList(_ sender: UIButton) {
        if let order = order, let docID = order.documentID {
            dataBase.collection(K.FirestoreCollections.order).document(docID).delete() {error in
                if let err = error {
                    ProgressHUD.showError(err.localizedDescription)
                } else {
                    ProgressHUD.showSucceed("The plate's been removed!")
                }
            }
        }
    }
    
    func setup(order: OrderFS){
        orderNameLbl.text = order.name
        let imageRef = storage.child("/images/\(order.name ?? "noimage").jpg")
        orderImageView.sd_setImage(with: imageRef)
        if let dishQuantity = order.quantity, let dishPrice = order.price {
            let sum = Double(dishQuantity) * dishPrice
            orderPlateQuantityLbl.text = "\(Int(dishQuantity))"
            let sumStr = String(format: "%.1f", sum)
            plateSumLbl.text = "\(sumStr) BYN"
        }
    }
}
