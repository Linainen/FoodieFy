//
//  ListDishesViewController.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 22.08.23.
//

import UIKit
import ProgressHUD

class ListDishesViewController: UIViewController {
    
    @IBOutlet var dishesTableView: UITableView!
    
    var category: CategoryFS!
    var platesByCategory: [DishFS] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        ProgressHUD.show()
        setupContent()
    }
    
    func setupContent() {
        registerCells()
        setupDelegates()
        fetchDishes()
    }
    
    func fetchDishes(){
        Task.init {
            do {
                platesByCategory = try await FirebaseService.shared.fetchDishesByCategory(category: category.name)
                self.dishesTableView.reloadData()
                ProgressHUD.dismiss()
            } catch (let error) {
                ProgressHUD.showError(error.localizedDescription)
            }
        }
    }
    
    private func registerCells() {
        dishesTableView.register(UINib(nibName: DishListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DishListTableViewCell.identifier)
    }

    private func setupDelegates() {
        dishesTableView.delegate = self
        dishesTableView.dataSource = self
    }
}

extension ListDishesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return platesByCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DishListTableViewCell.identifier) as! DishListTableViewCell
        cell.setup(plate: platesByCategory[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DishDetailsViewController.instantiate()
        controller.plate = platesByCategory[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
