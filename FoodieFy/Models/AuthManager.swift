//
//  AuthManager.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 28.08.23.
//

import Foundation
import FirebaseAuth
import ProgressHUD

class AuthManager {
    
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    private var verificationID: String?
    
    func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void ) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            guard let verificationID = verificationID, error == nil else {
                ProgressHUD.showError("Phone Verification Error")
                completion(false)
                return
            }
            self?.verificationID = verificationID
            completion(true)
        }
    }
    
    func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void ) {
        guard let verificationID = verificationID else {
            ProgressHUD.showError("SMS Code Error")
            completion(false)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: smsCode)
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
}
