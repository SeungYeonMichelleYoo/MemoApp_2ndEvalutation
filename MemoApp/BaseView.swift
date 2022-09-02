//
//  BaseView.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/08/31.
//

import UIKit
import SnapKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
//    func configureUI() {
//        self.backgroundColor = UIColor.black
//    }
    
    func setConstraints() {}
}
