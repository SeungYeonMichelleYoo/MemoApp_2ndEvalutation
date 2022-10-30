//
//  WriteViewController.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/09/03.
//
import UIKit
import SnapKit
import RealmSwift
import IQKeyboardManagerSwift

class WriteViewController: BaseViewController, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    var mainview = WriteView()
    
    private var writeViewModel: WriteVM!
    
    //tableview 행이 생성되기 전. 아무것도 없는 상태.
//    var index = -1
    
    var memo: UserMemo = UserMemo()
    
    var navTitle: String = "메모"
    
    let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareBtnClicked))
    let completeButton = UIBarButtonItem(title: "완료",  style: .plain, target: self, action: #selector(completeBtnClicked))
    
    override func loadView() {
        self.view = mainview
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.writeViewModel = WriteVM()
        
        navigationItem.rightBarButtonItems = []
        self.navigationController?.navigationBar.backgroundColor = .darkGray
        
        //MARK: - 스와이프 제스처시 키보드가 내려감으로 저장됨
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        mainview.textView.delegate = self
        
        print("\(navigationItem.rightBarButtonItems)")
        
        if (memo.memoTitle != "" ) {
//            memo = writeViewModel.fetchMemo(index: index)
            mainview.textView.text = memo.memoTitle + "\n" + memo.memoContent
            print(mainview.textView.text)
        } else {
            //화면 접속하자마자 키보드 올리기
            mainview.textView.becomeFirstResponder()
        }
        
        addBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //MARK: - 다크모드 대응
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        } else {
            view.backgroundColor = .white
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItems = [completeButton, shareButton]
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewEnd")
        memo = writeViewModel.saveOrDelete(userMemo: memo, text: mainview.textView.text)
    }
    
    
    func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        //if 메모리스트에서 넘어온 경우: 메모, if 검색화면에서 넘어온 경우: 검색
        backButton.setTitle("\(navTitle)", for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backButtonClicked)))
    }
    
    @objc func backButtonClicked() {
        print(#function)
        memo = writeViewModel.saveOrDelete(userMemo: memo, text: mainview.textView.text)
        self.navigationController?.popViewController(animated: true)
    }
     
    @objc func shareBtnClicked() {
        memo = writeViewModel.saveOrDelete(userMemo: memo, text: mainview.textView.text)
//        memo = writeViewModel.fetchMemo(index: index)
        let shareTitle: String = memo.memoTitle
        let shareContent: String = memo.memoContent
        var memocontent = [Any]()
        memocontent.append(shareTitle)
        memocontent.append(shareContent)
        let vc = UIActivityViewController(activityItems: memocontent, applicationActivities: [])
        self.present(vc, animated: true)
    }
        
    @objc func completeBtnClicked() {
        memo = writeViewModel.saveOrDelete(userMemo: memo, text: mainview.textView.text)
    }
}
