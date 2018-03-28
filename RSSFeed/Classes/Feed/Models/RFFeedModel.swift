//
//  RFFeedModel.swift
//  RSSFeed
//
//  Created by victor on 27/03/2018.
//  Copyright © 2018 victor. All rights reserved.
//

import Foundation
import SwiftyJSON


public class RFFeedItemAuthorModel {
    
    public var name: String?
    public var uri: String?
    
    public init(with json: JSON) {
        self.name = json["name"].string
        self.uri = json["uri"].string
    }
}

public class RFFeedItemLinkModel {
    
    public var selfLink: String?
    public var alternate: String?
    
    public init(with json: JSON) {
        self.selfLink = json["self"].string
        self.alternate = json["alternate"].string
    }
}

public class RFFeedItemGenreModel {

    public var genreId: String?
    public var name: String?
    public var url: String?
    
    public init(with json: JSON) {
        self.genreId = json["genreId"].string
        self.name = json["name"].string
        self.url = json["url"].string
    }
    
}

public class RFFeedItemModel {
    
    public var artistName: String?
    public var id: String?
    public var releaseDate: String?
    public var name: String?
    public var collectionName: String?
    public var kind: String?
    public var copyright: String?
    public var artistId: String?
    public var artistUrl: String?
    public var artworkUrl100: String?
    public var genres: Array<RFFeedItemGenreModel>?
    public var url: String?
    
    public init(with json: JSON) {
        self.artistName = json["artistName"].string
        self.id = json["id"].string
        self.releaseDate = json["releaseDate"].string
        self.name = json["name"].string
        self.collectionName = json["collectionName"].string
        self.kind = json["kind"].string
        self.copyright = json["copyright"].string
        self.artistId = json["artistId"].string
        self.artistUrl = json["artistUrl"].string
        self.artworkUrl100 = json["artworkUrl100"].string
        self.url = json["url"].string
        self.genres = json["genres"].array?.map({ (json) -> RFFeedItemGenreModel in
            return RFFeedItemGenreModel(with: json)
        })
    }
}

public class RFFeedModel {
    
    public var title: String?
    public var id: String?
    public var author: RFFeedItemAuthorModel?
    public var links: [RFFeedItemLinkModel]?
    public var copyright: String?
    public var country: String?
    public var icon: String?
    public var updated: String?
    public var results: Array<RFFeedItemModel>?
    
    public init(with json: JSON) {
        self.title = json["title"].string
        self.id = json["id"].string
        self.author = RFFeedItemAuthorModel(with: json["author"])
        self.links = json["links"].array?.map {
            return RFFeedItemLinkModel(with: $0)
        }
        self.copyright = json["copyright"].string
        self.country = json["country"].string
        self.icon = json["icon"].string
        self.updated = json["updated"].string
        self.results = json["results"].array?.map {
            return RFFeedItemModel(with: $0)
        }
    }
}
