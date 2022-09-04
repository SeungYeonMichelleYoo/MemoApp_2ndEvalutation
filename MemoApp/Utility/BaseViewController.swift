//
//  BaseViewController.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/08/31.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    func configure() {}
    
    func showAlertMessage(title: String, button: String = "확인") { //매개변수 기본값
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
}

