//
//  WriteViewController.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/09/03.
//
import UIKit
import SnapKit
import RealmSwift

class WriteViewController: BaseViewController {
    
    var tasks: Results<UserMemo>!
    
    var mainview = WriteView()
    
    let repository = UserMemoRepositoryType()
    
    //tableview 행이 생성되기 전. 아무것도 없는 상태.
    var index = -1
    
    override func loadView() {
        self.view = mainview
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //MainVC에서 넘어온 경우
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "메모", style: .plain, target: self, action: #selector(backButtonClicked))
        
        //Search에서 넘어온 경우
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareBtnClicked))
        let completeButton = UIBarButtonItem(title: "완료",  style: .plain, target: self, action: #selector(completeBtnClicked))
        navigationItem.rightBarButtonItems = [completeButton, shareButton]
        self.navigationController?.navigationBar.backgroundColor = .darkGray
        navigationController?.navigationBar.barTintColor = UIColor.green
        
        print("\(navigationItem.rightBarButtonItems)")
        
        if (index != -1) {
            mainview.textView.text = tasks[index].memoTitle + "\n" + tasks[index].memoContent
            print(mainview.textView.text)
        } else {
            //화면 접속하자마자 키보드 올리기
            mainview.textView.becomeFirstResponder()
        }
    }
    @objc func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
     
    
    @objc func shareBtnClicked() {
        //        showActivityViewController()
    }
    //복원하는거처럼 똑같이 해야될듯
    //
    //    var memoContent = MainViewController.mainTableView.tasks[indexPath.row].memoContent
    //    func showActivityViewController(memoContent: memoContent) {
    //        let vc = UIActivityViewController(activityItems: [memoContent], applicationActivities: [])
    //        self.present(vc, animated: true)
    //    }
    
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
            } else { // modify memo
                
            }
        } else {
            if (index != -1) { //메모 수정화면일 경우, 아무것도 입력하지 않으면 메모를 삭제
                repository.delete(item: tasks[index])
            }
        }
    }
    
}
