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
    
    var tasks: Results<UserMemo>!
    
    var mainview = WriteView()
    
    let repository = UserMemoRepositoryType()
    
    //tableview 행이 생성되기 전. 아무것도 없는 상태.
    var index = -1
    
    var navTitle: String = "메모"
    
    let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareBtnClicked))
    let completeButton = UIBarButtonItem(title: "완료",  style: .plain, target: self, action: #selector(completeBtnClicked))
    
    override func loadView() {
        self.view = mainview
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = []
        self.navigationController?.navigationBar.backgroundColor = .darkGray
        
        //MARK: - 스와이프 제스처시 키보드가 내려감으로 저장됨
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        mainview.textView.delegate = self
        
        print("\(navigationItem.rightBarButtonItems)")
        
        if (index != -1) {
            mainview.textView.text = tasks[index].memoTitle + "\n" + tasks[index].memoContent
            print(mainview.textView.text)
        } else {
            //화면 접속하자마자 키보드 올리기
            mainview.textView.becomeFirstResponder()
        }
        
        addBackButton()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
               navigationItem.rightBarButtonItems = [completeButton, shareButton]
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewEnd")
        saveOrDelete()
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
    
    
    //MARK: - backButtonClicked()
    @objc func backButtonClicked() {
        print(#function)
        saveOrDelete()
        self.navigationController?.popViewController(animated: true)
    }
     
    //MARK: - 공유 버튼 클릭시
    @objc func shareBtnClicked() {
        saveOrDelete()
        let shareTitle: String = tasks[index].memoTitle
        let shareContent: String = tasks[index].memoContent
        var memocontent = [Any]()
        memocontent.append(shareTitle)
        memocontent.append(shareContent)
        let vc = UIActivityViewController(activityItems: memocontent, applicationActivities: [])
        self.present(vc, animated: true)
    }
        
    @objc func completeBtnClicked() {
        saveOrDelete()
    }
    
    func saveOrDelete() {
        if mainview.textView.text.count > 0 {
            let strList = mainview.textView.text.components(separatedBy: .newlines) // \n을 바탕으로 배열로 만듬
            var title = ""
            var content = ""
            if (strList.count > 0) {
                title = strList[0]
                
                if (strList.count > 1) {
                    for i in 1...strList.count-1 {
                        content += strList[i] + "\n"
                    }
                    content = content.trimmingCharacters(in: .whitespacesAndNewlines) //마지막 \n 없애기
                }
            }
            if (index == -1) { // new memo
                repository.addMemo(title: title, content: content)
                fetchData()
            } else { // modify memo
                repository.modify(item: tasks[index], title: title, content: content)
            }
        } else {
            if (index != -1) { // 메모 수정화면일 경우, 아무것도 입력하지 않으면 메모를 삭제
                repository.delete(item: tasks[index])
                tasks = repository.fetch()
                index = -1
            }
        }
    }
    
    func fetchData() {
        tasks = repository.fetch()
        index = tasks.count - 1 //index는 0부터 시작하는데, 몇번째 인덱스인지 알아야 테이블뷰 구성이 가능. 1개 추가 -> 0번째 인덱스, 2개 추가-> 1번째 인덱스...
    }
}
