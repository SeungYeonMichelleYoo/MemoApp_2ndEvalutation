//
//  WriteVM.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/10/29.
//
import Foundation
import RealmSwift

class WriteVM {
    let memos: [MemoModel] = []
    
    var tasks: Results<UserMemo>!
    
    init() {
        fetchData()
    }
    
    let repository = UserMemoRepositoryType()

    func saveOrDelete(userMemo: UserMemo, text: String) -> UserMemo {
        print("------------ooooooo-----------")
        if text.count > 0 {
            let strList = text.components(separatedBy: .newlines) // \n을 바탕으로 배열로 만듬
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
            if (userMemo.memoTitle == "") { // new memo
                print(";;;;;;;;;save==========")
                return repository.addMemo(title: title, content: content)
            } else { // modify memo
                print(";;;;;;;;;modify=========")
                repository.modify(item: userMemo, title: title, content: content)
            }
        } else {
            self.repository.delete(item: userMemo)
            self.tasks = repository.fetch()
            return UserMemo()
        }
        return userMemo
    }
    
    //특정 행에 대한 메모 가져오기
    func fetchMemo(index: Int) -> UserMemo {
        fetchData()
        return tasks[index]
    }
    
    
    func fetchData() {
        print("------------ofetchdataoooooo-----------")
        self.tasks = repository.fetch()
//        self.index = tasks.count - 1 //index는 0부터 시작하는데, 몇번째 인덱스인지 알아야 테이블뷰 구성이 가능. 1개 추가 -> 0번째 인덱스, 2개 추가-> 1번째 인덱스...
    }
}
