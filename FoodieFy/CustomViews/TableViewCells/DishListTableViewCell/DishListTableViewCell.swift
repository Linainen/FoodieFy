//
//  DishListTableViewCell.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 22.08.23.
//

import UIKit
import FirebaseStorage
import ProgressHUD
import FirebaseStorageUI

class DishListTableViewCell: UITableViewCell {

    static let identifier = String(describing: DishListTableViewCell.self)
    let storage = Storage.storage().reference()

    @IBOutlet var dishImageView: UIImageView!
    @IBOutlet var dishTitleLbl: UILabel!
    @IBOutlet var dishDescriptionLbl: UILabel!
    @IBOutlet var dishPriceLbl: UILabel!
    
    func setup(plate: DishFS) {
        dishTitleLbl.text = plate.name
        let imageRef = storage.child("/images/\(plate.name ?? "noimage").jpg")
//        let imageRef2 = storage.child("/images/noimage.jpg")
        dishImageView.sd_setImage(with: imageRef)
        dishDescriptionLbl.text = plate.description
        dishPriceLbl.text = plate.priceDescription
    }
    
}
