//
//  OTPViewController.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 28.08.23.
//

import UIKit
import ProgressHUD

class OTPViewController: UIViewController {
    
    @IBOutlet var phoneNumberLbl: UILabel!
    @IBOutlet var smsCodeTextField: UITextField!
    var phoneNumber: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberLbl.text = phoneNumber
    }
    
    @IBAction func proceedBtnPressed(_ sender: UIButton) {
        
        guard let smsCode = smsCodeTextField.text else {
            ProgressHUD.showError("There was an error")
            return
        }
        
        AuthManager.shared.verifyCode(smsCode: smsCode) { success in
            guard success else {
                ProgressHUD.showError("Incorrect code!")
                return
            }
            DispatchQueue.main.async {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "HomeNC") as! UINavigationController
                controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .flipHorizontal
                controller.navigationBar.isTranslucent = true
                self.present(controller, animated: true)
            }
        }
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
}
