//
//  CategoryCollectionViewCell.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 21.08.23.
//

import UIKit
import FirebaseStorage
import ProgressHUD
import FirebaseStorageUI

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: CategoryCollectionViewCell.self)
    let storage = Storage.storage().reference()
    
    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var categoryTitleLbl: UILabel!
    
    func setup(category: CategoryFS) {
        categoryTitleLbl.text = category.name
        let reference = storage.child("/categories/\(category.name ?? "").jpg")
        categoryImageView.sd_setImage(with: reference)
    }
    
}
