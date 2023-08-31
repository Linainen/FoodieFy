//
//  OrdersInCartViewController.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 23.08.23.
//

import UIKit
import ProgressHUD
import Firebase

class OrdersInCartViewController: UIViewController {
    
    @IBOutlet var ordersTableView: UITableView!
    @IBOutlet var totalAmmountLbl: UILabel!
    
    var ordersFS: [OrderFS] = []
    let dataBase = Firestore.firestore()
    let ordersModel = OrdersInCartModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your orders"
        doSetup()
        fetchOrders()
    }
    
    private func doSetup() {
        setupTotalSum()
        ordersTableView.dataSource = self
        ordersTableView.register(UINib(nibName: OrdersInCartTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OrdersInCartTableViewCell.identifier)
    }
    
    private func setupTotalSum(){
        let sum = ordersModel.calculateSum(orders: ordersFS)
        totalAmmountLbl.text = "\(sum) BYN"
    }
    
    private func fetchOrders() {
        dataBase.collection(K.FirestoreCollections.order).addSnapshotListener { querrySnapshot, error in
            self.ordersFS = []
            if let err = error {
                ProgressHUD.showError(err)
            } else {
                if let snapshoDocuments = querrySnapshot?.documents {
                    for document in snapshoDocuments {
                        let data = document.data()
                        if let plateName = data[K.OrderParams.name] as? String, let platePrice = data[K.OrderParams.price] as? Double, let plateQuantity = data[K.OrderParams.quantity] as? Double, let userPhone = data[K.OrderParams.user] as? String {
                            let currentUserPhone = Auth.auth().currentUser?.phoneNumber ?? ""
                            if userPhone == currentUserPhone {
                                let docID = document.documentID
                                let order = OrderFS(name: plateName, quantity: plateQuantity, price: platePrice, user: currentUserPhone, documentID: docID)
                                self.ordersFS.append(order)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.ordersTableView.reloadData()
                        self.setupTotalSum()
                    }
                }
            }
        }
    }
    
    @IBAction func placeOrderPressed(_ sender: UIButton) {
        guard !ordersFS.isEmpty else {
            ProgressHUD.showError("Your order cart is empty 😔")
            return
        }
        let deliveryVC = DeliveryDetailsViewController.instantiate()
        if let sheetDeliveryVC = deliveryVC.sheetPresentationController {
            sheetDeliveryVC.detents = [.medium()]
        }
        deliveryVC.orders = self.ordersFS
        deliveryVC.delegate = self
        present(deliveryVC, animated: true)
    }
}

extension OrdersInCartViewController: UITableViewDataSource, DeliveryDetailsDelegate {
    
    func orderCompleted(){
        ordersModel.clearOrders(orders: self.ordersFS)
        ordersTableView.reloadData()
        ProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let intRandom = Int.random(in: 10...50)
            ProgressHUD.showSucceed("We'll deliver your order in \(intRandom) minutes ⏳")
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersFS.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrdersInCartTableViewCell.identifier) as! OrdersInCartTableViewCell
        let order = ordersFS[indexPath.row]
        cell.setup(order: order)
        cell.order = order
        return cell
    }
    
}

