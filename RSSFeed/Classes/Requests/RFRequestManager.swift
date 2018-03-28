//
//  RFRequestManager.swift
//  RSSFeed
//
//  Created by victor on 27/03/2018.
//  Copyright © 2018 victor. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


public class RFRequestManager: NSObject {
    
    private static var requestUrlPrefix: String = "https://rss.itunes.apple.com/api/v1/"
    
    public static func getArtistList(with url: String, completionHandler: @escaping (RFFeedModel?, Error?) -> Void) {
        let completeUrl = requestUrlPrefix + url
        Alamofire.request(completeUrl).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let feedModel = RFFeedModel(with: json["feed"])
                completionHandler(feedModel, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    

}
