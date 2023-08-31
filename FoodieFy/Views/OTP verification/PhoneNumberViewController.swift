//
//  PhoneNumberViewController.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 28.08.23.
//

import UIKit
import PhoneNumberKit
import ProgressHUD
import Firebase

class PhoneNumberViewController: UIViewController {
    
    @IBOutlet var phoneNumberTextField: PhoneNumberTextField!
    let phoneNumberKit = PhoneNumberKit()
    let dataBase = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
    }
    
    func setupTextField() {
        phoneNumberTextField.withFlag = true
        phoneNumberTextField.withPrefix = true
        phoneNumberTextField.borderStyle = .roundedRect
        phoneNumberTextField.withExamplePlaceholder = true
        phoneNumberTextField.withDefaultPickerUI = true
    }

    @IBAction func sendCodePressed(_ sender: UIButton) {
        guard let userPhone = phoneNumberTextField.text else {
            ProgressHUD.showError("Please, enter your phone number")
            return
        }
        do {
            let phoneNumber = try phoneNumberKit.parse(userPhone)
            let formatedNumber = phoneNumberKit.format(phoneNumber, toType: .e164)
            let numberForNextVC = phoneNumber.numberString
            AuthManager.shared.startAuth(phoneNumber: formatedNumber) { [weak self] success in
                guard success else {
                    ProgressHUD.showError("Sorry, something's wrong with your phone number")
                    return
                }
                DispatchQueue.main.async {
                    let controller = OTPViewController.instantiate()
                    controller.modalPresentationStyle = .fullScreen
                    controller.phoneNumber = numberForNextVC
                    self?.present(controller, animated: true) {
                        self?.phoneNumberTextField.text = ""
                    }
                }
            }
        } catch {
            ProgressHUD.showError("Please, enter a valid phone number")
        }
    }
}
