//
//  PopularDishesCollectionViewCell.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 22.08.23.
//

import UIKit
import FirebaseStorage
import ProgressHUD
import FirebaseStorageUI

class PopularDishesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: PopularDishesCollectionViewCell.self)
    let storage = Storage.storage().reference()

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var dishImageView: UIImageView!
    @IBOutlet var caloriesLbl: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    
    func setup(plate: DishFS) {
        titleLbl.text = plate.name
        let imageRef = storage.child("/images/\(plate.name ?? "noimage").jpg")
        dishImageView.sd_setImage(with: imageRef)
        caloriesLbl.text = plate.priceDescription
        descriptionLbl.text = plate.description
    }
}
