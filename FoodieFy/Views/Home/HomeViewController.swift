//
//  HomeViewController.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 21.08.23.
//

import UIKit
import ProgressHUD
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet var categoryCollectionView: UICollectionView!
    @IBOutlet var popularDishesCollectionView: UICollectionView!
    @IBOutlet var newDishesCollectionView: UICollectionView!
    @IBOutlet var logoutPressed: UIBarButtonItem!
    
    var popularDishes: [DishFS] = []
    var newDishes: [DishFS] = []
    var categories: [CategoryFS] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.show()
        setupContent()
    }
    
    private func setupContent() {
        setupDelegates()
        registerCells()
        fillWithContent()
    }
    
    private func fillWithContent(){
        Task.init {
            do {
                categories = try await FirebaseService.shared.fetchCategories()
                popularDishes = try await FirebaseService.shared.fetchPopularAndNew(dish: .popular)
                newDishes = try await FirebaseService.shared.fetchPopularAndNew(dish: .new)
                self.categoryCollectionView.reloadData()
                self.popularDishesCollectionView.reloadData()
                self.newDishesCollectionView.reloadData()
                ProgressHUD.dismiss()
            } catch (let error) {
                ProgressHUD.showError(error.localizedDescription)
            }
        }
    }
    
    private func setupDelegates() {
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        popularDishesCollectionView.dataSource = self
        popularDishesCollectionView.delegate = self
        newDishesCollectionView.dataSource = self
        newDishesCollectionView.delegate = self
    }
    
    private func registerCells() {
        categoryCollectionView.register(UINib(nibName: CategoryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        
        popularDishesCollectionView.register(UINib(nibName: PopularDishesCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PopularDishesCollectionViewCell.identifier)
        
        newDishesCollectionView.register(UINib(nibName: ChefCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ChefCollectionViewCell.identifier)
    }
    
    
    @IBAction func logutPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Are you shure you want to log out?", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            do {
                try Auth.auth().signOut()
            } catch let (error){
                ProgressHUD.showError(error.localizedDescription)
            }
            let controller = OnboardingViewController.instantiate()
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            alertController.dismiss(animated: true)
        }))
        present(alertController, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case categoryCollectionView:
            return categories.count
        case popularDishesCollectionView:
            return popularDishes.count
        case newDishesCollectionView:
            return newDishes.count
        default: return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case categoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            cell.setup(category: categories[indexPath.row])
            return cell
        case popularDishesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularDishesCollectionViewCell.identifier, for: indexPath) as! PopularDishesCollectionViewCell
            cell.setup(plate: self.popularDishes[indexPath.row])
            return cell
        case newDishesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChefCollectionViewCell.identifier, for: indexPath) as! ChefCollectionViewCell
            cell.setup(plate: newDishes[indexPath.row])
            return cell
        default: return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            let controller = ListDishesViewController.instantiate()
            controller.category = categories[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = DishDetailsViewController.instantiate()
            controller.plate = collectionView == popularDishesCollectionView ? popularDishes[indexPath.row] : newDishes[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
