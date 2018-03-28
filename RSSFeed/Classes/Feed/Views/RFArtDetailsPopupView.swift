//
//  RFArtDetailsPopupView.swift
//  RSSFeed
//
//  Created by victor on 28/03/2018.
//  Copyright © 2018 victor. All rights reserved.
//

import UIKit

public class RFArtDetailsPopupView: UIView {

    let imageView: UIImageView = UIImageView()
    let nameLabel = UILabel()
    let artistNameLabel = UILabel()
    let collectionNameLabel = UILabel()
    let genresLabel = UILabel()
    let releaseDateLabel = UILabel()
    
    var currentModel: RFFeedItemModel?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        let popupView = UIView()
        self.addSubview(popupView)
        popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 透明层
        let translucentView = UIView()
        translucentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closePopupView)))
        translucentView.backgroundColor = UIColor.black
        translucentView.alpha = 0.5
        popupView.addSubview(translucentView)
        translucentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let margin: CGFloat = 8
        let backgroundContentWidth: CGFloat = 250
        let imageViewWidth: CGFloat = 200
        
        // 内容层
        let backgroundContent = UIView()
        backgroundContent.backgroundColor = UIColor.white
        backgroundContent.layer.cornerRadius = 10
        backgroundContent.layer.masksToBounds = true
        popupView.addSubview(backgroundContent)
        backgroundContent.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.left.equalTo(30)
            $0.right.equalTo(-30)
            $0.height.equalTo(backgroundContentWidth + 150)
        }
        
        // 主图
        backgroundContent.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(imageViewWidth)
        }
    
        artistNameLabel.isUserInteractionEnabled = true
        artistNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openArtistHomePage)))
        artistNameLabel.textAlignment = .center
        artistNameLabel.textColor = UIColor.blue
        artistNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        backgroundContent.addSubview(artistNameLabel)
        artistNameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(margin)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.gray
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        backgroundContent.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(artistNameLabel.snp.bottom).offset(margin)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        collectionNameLabel.textAlignment = .center
        collectionNameLabel.textColor = UIColor.gray
        collectionNameLabel.font = UIFont.systemFont(ofSize: 14)
        backgroundContent.addSubview(collectionNameLabel)
        collectionNameLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(margin)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        genresLabel.textAlignment = .center
        genresLabel.textColor = UIColor.gray
        genresLabel.font = UIFont.italicSystemFont(ofSize: 14)
        backgroundContent.addSubview(genresLabel)
        genresLabel.snp.makeConstraints {
            $0.top.equalTo(collectionNameLabel.snp.bottom).offset(margin)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(25)
        }
    
        releaseDateLabel.textAlignment = .center
        releaseDateLabel.textColor = UIColor.gray
        releaseDateLabel.font = UIFont.systemFont(ofSize: 14)
        backgroundContent.addSubview(releaseDateLabel)
        releaseDateLabel.snp.makeConstraints {
            $0.top.equalTo(genresLabel.snp.bottom).offset(margin)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(25)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(with model: RFFeedItemModel?) {
        currentModel = model
        
        if let artworkUrl100 = model?.artworkUrl100,
            let url = URL(string: artworkUrl100){
            imageView.layer.cornerRadius = 10
            imageView.layer.masksToBounds = true
            imageView.pin_updateWithProgress = true
            imageView.pin_setImage(from: url)
        }
        
        if let artistName = model?.artistName {
            artistNameLabel.attributedText = NSAttributedString(string: artistName, attributes:
                [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
            artistNameLabel.text = artistName
        }

        if let albumName = model?.name {
            nameLabel.text = "Album Name: " + albumName
        }
        if let collectionName = model?.collectionName {
            collectionNameLabel.text = "Collection Name: " + collectionName
        }
        if let genres = model?.genres {
            var genresStr: String = ""
            let genresLen = genres.count
            var i: Int = 0
            for gmodel in genres {
                i += 1
                if let name = gmodel.name {
                    genresStr += name + (i == genresLen ? "" : ", ")
                    
                }
            }
            genresLabel.text = "Genres: " + genresStr
        }
        if let releaseDate = model?.releaseDate {
            releaseDateLabel.text = "Release Date: " + releaseDate
        }
    }

    @objc func closePopupView() {
        self.removeFromSuperview()
    }
    
    @objc func openArtistHomePage() {
        if let _currentModel = self.currentModel {
            NotificationCenter.default.post(name: Notification.Name(RFArtDetailsPopupView.getArtistNotificationName()), object: nil, userInfo: [ "currentModel" : _currentModel ])
        }
        closePopupView()
    }
    
    public static func getArtistNotificationName() -> String {
        return "kArtistNotificationName"
    }
}
