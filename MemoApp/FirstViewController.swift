//
//  FirstViewController.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/09/03.
//

import UIKit
import SnapKit
import RealmSwift

class FirstViewController: BaseViewController {
    
    var firstView = FirstView()
    
    override func loadView() {
        self.view = firstView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstView.backgroundColor = .darkGray
  
        //밑 배경 투명 처리
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.isOpaque = true
        firstView.okButton.addTarget(self, action: #selector(okButtonClicked), for: .touchUpInside)
    }
    
    @objc func okButtonClicked() {
        //되돌아가기 (first-> mainVC)
        self.dismiss(animated: true)
    }
    
}
