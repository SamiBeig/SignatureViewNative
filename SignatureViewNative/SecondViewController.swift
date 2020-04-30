//
//  SecondViewController.swift
//  SignatureViewNative
//
//  Created by Sami Beig on 3/25/20.
//  Copyright © 2020 Sami Beig. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {


  
  @IBOutlet weak var signatureView: UIView!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
  override func viewDidAppear(_ animated: Bool) {
    
    view.addSubview(signature)
    signature.frame = signatureView.frame
    signature.backgroundColor = .white
    signature.layer.borderWidth = 0.0
    signature.layer.borderColor = UIColor.white.cgColor

    
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
