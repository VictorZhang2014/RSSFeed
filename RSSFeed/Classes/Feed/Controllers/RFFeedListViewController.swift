//
//  RFFeedListViewController.swift
//  RSSFeed
//
//  Created by victor on 26/03/2018.
//  Copyright © 2018 victor. All rights reserved.
//

import UIKit
import SnapKit


public class RFFeedListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    lazy var collectionView: UICollectionView = { () -> UICollectionView in
        let width: CGFloat = self.view.frame.size.width
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: width, height: 200)
        
        let _collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: flowLayout)
        _collectionView.backgroundColor = UIColor.white
        _collectionView.showsVerticalScrollIndicator = true
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.delegate = self
        _collectionView.dataSource = self
        _collectionView.register(RFFeedCollectionViewViewCell.self, forCellWithReuseIdentifier: RFFeedCollectionViewViewCell.getReuseCellId())
        return _collectionView
    }()
    
    var activityIndicator: UIActivityIndicatorView?
    var feedModel: RFFeedModel?
    var currentPageNumber: Int = 10
    var isRequesting: Bool = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
        request(with: currentPageNumber)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openArtistPage(notification:)), name: Notification.Name(RFArtDetailsPopupView.getArtistNotificationName()), object: nil)
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.white
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator?.activityIndicatorViewStyle = .gray
        activityIndicator?.startAnimating()
        self.view.addSubview(activityIndicator!)
        activityIndicator?.snp.makeConstraints {
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.centerY.equalTo(self.view.snp.centerY)
            $0.width.height.equalTo(30)
        }
    }
    
    @objc func openArtistPage(notification: NSNotification) {
        let userInfo = notification.userInfo
        if let _userInfo = userInfo {
            let currentModel: RFFeedItemModel? = _userInfo["currentModel"] as? RFFeedItemModel
            if let _currentModel = currentModel {
                
                let webViewVC = RFWebViewViewController()
                webViewVC.artistName = _currentModel.artistName
                webViewVC.artistUrl = _currentModel.url
                let nav = UINavigationController(rootViewController: webViewVC)
                self.present(nav, animated: true, completion: nil)
            }

        }
    }
    
    func request(with pageNumber: Int) {
        if isRequesting {
            return
        }
        
        isRequesting = true
        RFRequestManager.getArtistList(with: "/us/apple-music/hot-tracks/all/\(pageNumber)/explicit.json") { (model, error) in
            if let indicator = self.activityIndicator {
                indicator.stopAnimating()
                self.activityIndicator = nil
            }
            if let _error = error {
                self.alert(with: _error.localizedDescription)
                self.isRequesting = false
                return
            }
            if let _model = model {
                self.feedModel = _model
                self.collectionView.reloadData()
            }
            self.isRequesting = false
        }
    }

    /// UICollectionViewDataSource, UICollectionViewDelegate
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedModel?.results?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = feedModel?.results?[indexPath.row]
        
        let cell: RFFeedCollectionViewViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RFFeedCollectionViewViewCell.getReuseCellId(), for: indexPath) as! RFFeedCollectionViewViewCell
    
        cell.update(with: model)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = feedModel?.results?[indexPath.row]
        
        let popupView = RFArtDetailsPopupView()
        popupView.update(with: model)
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(popupView)
        popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.size.height) {

            if isRequesting {
                return
            }
            
            currentPageNumber += 10
            request(with: currentPageNumber)
        }
    }
    
    func alert(with message: String) {
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Okay", style: .default) { (action) in
            
        })
        self.present(alertVC, animated: true, completion: nil)
    }
}
