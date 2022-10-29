//
//  WriteVM.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/10/29.
//

import Foundation
import RealmSwift

struct WriteVM {
    let memos: [MemoModel]
    
    var index = -1
    
    var tasks: Results<UserMemo>!
    
    var mainview = WriteView()
    
    let repository = UserMemoRepositoryType()
    
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
