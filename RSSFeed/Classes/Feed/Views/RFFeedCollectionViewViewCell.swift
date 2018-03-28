//
//  RFFeedCollectionViewViewCell.swift
//  RSSFeed
//
//  Created by victor on 28/03/2018.
//  Copyright © 2018 victor. All rights reserved.
//

import UIKit
import SnapKit
import PINRemoteImage


public class RFFeedCollectionViewViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = UIImageView()
    let nameLabel = UILabel()
    let artistNameLabel = UILabel()
    let collectionNameLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        let margin: CGFloat = 15
        
        let background = UIView()
        background.layer.shadowColor = UIColor.gray.cgColor
        background.layer.shadowOpacity = 0.5
        background.layer.shadowOffset = CGSize(width: 3, height: 10)
        background.layer.shadowRadius = 10
        self.contentView.addSubview(background)
        background.snp.makeConstraints {
            $0.top.left.equalTo(margin)
            $0.right.bottom.equalTo(-margin)
        }
        
        let imageViewWidth: CGFloat = 190
        let nameLabelRightMargin: CGFloat = imageViewWidth + 5
        
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        background.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.left.equalTo(10)
            $0.right.equalTo(-nameLabelRightMargin)
            $0.height.equalTo(25)
        }
        
        artistNameLabel.textColor = UIColor.gray
        artistNameLabel.font = UIFont.systemFont(ofSize: 14)
        background.addSubview(artistNameLabel)
        artistNameLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.left.equalTo(10)
            $0.right.equalTo(-nameLabelRightMargin)
            $0.height.equalTo(25)
        }
        
        collectionNameLabel.textColor = UIColor.gray
        collectionNameLabel.font = UIFont.systemFont(ofSize: 14)
        background.addSubview(collectionNameLabel)
        collectionNameLabel.snp.makeConstraints {
            $0.top.equalTo(artistNameLabel.snp.bottom).offset(10)
            $0.left.equalTo(10)
            $0.right.equalTo(-nameLabelRightMargin)
            $0.height.equalTo(25)
        }
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.gray
        bottomLine.alpha = 0.5
        background.addSubview(bottomLine)
        bottomLine.snp.makeConstraints {
            $0.left.equalTo(0)
            $0.bottom.equalTo(0)
            $0.right.equalTo(-imageViewWidth)
            $0.height.equalTo(0.5)
        }
        
        background.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.equalTo(5)
            $0.bottom.equalTo(0)
            $0.right.equalTo(0)
            $0.width.equalTo(imageViewWidth + 5)
        }
    }
    
    public func update(with model: RFFeedItemModel?) {
        if let artworkUrl100 = model?.artworkUrl100,
            let url = URL(string: artworkUrl100){
            imageView.layer.cornerRadius = 10
            imageView.layer.masksToBounds = true
            imageView.pin_updateWithProgress = true
            imageView.pin_setImage(from: url)
        }
        
        nameLabel.text = model?.name
        artistNameLabel.text = model?.artistName
        collectionNameLabel.text = model?.collectionName
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func getReuseCellId() -> String {
        return "kRFFeedCollectionViewViewReuseCellIdentifier"
    }
}
