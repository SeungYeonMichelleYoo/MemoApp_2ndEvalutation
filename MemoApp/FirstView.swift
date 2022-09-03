//
//  FirstView.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/09/03.
//
import UIKit
import SnapKit

class FirstView: BaseView {
    
    lazy var popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        //모서리 둥글게 만들기
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        return view
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "처음 오셨군요!\n환영합니다:)\n\n당신만의 메모를 작성하고\n관리해보세요!"
        label.textColor = UIColor.orange
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var okButton: UIButton = {
        let view = UIButton()
        view.setTitle("확인", for: .normal)
        view.tintColor = .white
        view.backgroundColor = .orange
        //모서리 둥글게 만들기
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        self.addSubview(popupView)
        [contentLabel, okButton].forEach {
            popupView.addSubview($0)
        }
    
    }
    override func setConstraints() {
        popupView.snp.makeConstraints { make in
            make.width.height.equalTo(300)
            make.center.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leadingMargin.equalToSuperview().offset(8)
            make.width.height.equalTo(200)
        }
        
        okButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.width.equalTo(contentLabel)
            make.height.equalTo(50)
        }
    }
}
