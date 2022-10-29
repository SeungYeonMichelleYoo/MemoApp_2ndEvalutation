//
//  RealmModel.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/08/31.
//

import Foundation
import RealmSwift

class UserMemo: Object {
    @Persisted var memoTitle: String //제목(필수)
    @Persisted var memoContent: String //내용(필수)
    @Persisted var memoDate = Date() //등록 날짜(필수)
    @Persisted var fixed: Bool //고정(옵션)
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(memoTitle: String, memoContent: String, memoDate: Date) {
        self.init()
        self.memoTitle = memoTitle
        self.memoContent = memoContent
        self.memoDate = memoDate
        self.fixed = false
    }
}


