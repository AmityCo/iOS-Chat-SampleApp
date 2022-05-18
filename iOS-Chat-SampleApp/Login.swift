//
//  ViewController.swift
//  iOS-Chat-SampleApp
//
//  Created by Mark on 18/5/2565 BE.
//

import UIKit
import AmitySDK
class Login: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    var client:AmityClient?
    
    @IBAction func loginBtn(_ sender: UIButton) {
        if userIdTextField.text != "" && userIdTextField.text != "" {
            client!.login(userId: userIdTextField.text!, displayName: displayNameTextField.text!, authToken: nil, completion: {success,error in
                if error == nil {
                    print("login success")
                }
                
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.client = try! AmityClient(apiKey: "b3babb0b3a89f4341d31dc1a01091edcd70f8de7b23d697f")
        
        // Do any additional setup after loading the view.
    }
    
    


}

