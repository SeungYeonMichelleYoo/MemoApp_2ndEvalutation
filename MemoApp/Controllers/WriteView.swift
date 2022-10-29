//
//  WriteView.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/09/03.
//

import UIKit
import SnapKit

class WriteView: BaseView {
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 18)
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        self.addSubview(textView)
    }
    override func setConstraints() {
        
       textView.snp.makeConstraints { make in
//           make.edges.equalToSuperview()
           make.leading.equalToSuperview()
           make.trailing.equalToSuperview()
           make.top.equalToSuperview()
           make.bottom.equalToSuperview()
        }
    }
}
