//
//  Memo.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/08/31.
//

import Foundation
import RealmSwift

class Memo: Object {
    @Persisted var title: String //제목(필수)
    @Persisted var content: String //내용(필수)
    @Persisted var date = Date() //등록 날짜(필수)
    @Persisted var fixed: Bool //고정(옵션)
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(title: String, content: String, date: Date) {
        self.init()
        self.title = title
        self.content = content
        self.date = date
        self.fixed = false
    }
}


