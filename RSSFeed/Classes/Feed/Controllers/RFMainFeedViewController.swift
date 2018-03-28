//
//  ViewController.swift
//  RSSFeed
//
//  Created by victor on 26/03/2018.
//  Copyright © 2018 victor. All rights reserved.
//

import UIKit
import SnapKit

public class RFMainFeedViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let statusBarView = UIView()
        statusBarView.backgroundColor = UIColor.white
        view.addSubview(statusBarView)
        statusBarView.snp.makeConstraints {
            $0.top.left.equalTo(0)
            $0.width.equalTo(self.view.snp.width)
            $0.height.equalTo(statusBarHeight)
        }
        
        let feedListVC = RFFeedListViewController()
        addChildViewController(feedListVC)
        view.addSubview(feedListVC.view)
        feedListVC.didMove(toParentViewController: self)
        feedListVC.view.snp.makeConstraints {
            $0.top.equalTo(statusBarView.snp.bottom)
            $0.left.equalTo(0)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(self.view.snp.bottom)
        }
        
    }




}

