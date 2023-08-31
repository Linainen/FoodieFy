//
//  ChefCollectionViewCell.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 22.08.23.
//

import UIKit
import FirebaseStorage
import ProgressHUD
import FirebaseStorageUI

class ChefCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: ChefCollectionViewCell.self)
    let storage = Storage.storage().reference()

    @IBOutlet var chefImageView: UIImageView!
    @IBOutlet var chefTitleLbl: UILabel!
    @IBOutlet var chefDescriptionLabel: UILabel!
    @IBOutlet var chefCaloriesLbl: UILabel!
    
    func setup(plate: DishFS) {
        chefTitleLbl.text = plate.name
        let imageRef = storage.child("/images/\(plate.name ?? "noimage").jpg")
        chefImageView.sd_setImage(with: imageRef)
        chefCaloriesLbl.text = plate.priceDescription
        chefDescriptionLabel.text = plate.description
    }
    
}
