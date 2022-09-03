//
//  addMemoButton.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/09/03.
//

//addMemoButton 을 addView하고 constraint주는게 FirstViewController & MainVC에서 반복되는데 이걸 몽땅 한번에 써서 이용하는 방법은 없을까?
//그렇다고 BaseVC를 상속받는 방법으로 하면 MainVC에서 tableview 요소를 등록하는게 어려워짐.

import UIKit

class addMemoButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        tintColor = .orange
    }
}
