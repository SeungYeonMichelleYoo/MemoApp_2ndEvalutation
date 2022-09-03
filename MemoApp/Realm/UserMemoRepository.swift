//
//  UserMemoRepository.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/08/31.
//

import Foundation
import RealmSwift


//realm 관련 여기로 몰아두기(리팩토링)
class UserMemoRepositoryType {
    
    var localRealm = try! Realm()
    
    //메모 최신순으로 정렬
    func fetch() -> Results<UserMemo> {
        return localRealm.objects(UserMemo.self).sorted(byKeyPath: "memoDate", ascending: false)
    }
    
    
    func delete(item: UserMemo) {
        do {
            try self.localRealm.write {
                self.localRealm.delete(item)
            }
        } catch let error {
            print(error)
        }
    }
    
    func addMemo(title: String, content: String) {
        let data = UserMemo(memoTitle: title, memoContent: content, memoDate: Date())

        do {
            try localRealm.write {
                localRealm.add(data)
            }
        } catch let error {
            print(error)
        }
    }
    
    
    
}

