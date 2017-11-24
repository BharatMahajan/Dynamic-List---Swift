//
//  Post.swift
//  REST-List
//
//  Created by Er. Bharat Mahajan on 08/11/17.
//  Copyright © 2017 Er. Bharat Mahajan. All rights reserved.
//

class Post {
    var title : String?
    var description : String?
    var image : String?
    var published_at : String?
    
    init(title: String?, description: String?, image: String?, published_at: String?) {
        self.title = title
        self.description = description
        self.image = image
        self.published_at = published_at
    }
}
