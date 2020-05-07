//
//  ViewController.swift
//  EasyLayout
//
//  Created by Andrey Krasivichev on 20.04.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
        self.scrollView.backgroundColor = UIColor.cyan
        self.setupConstraints()
    }

    // MARK: Private
    
    private func setupConstraints() {
        let scrollView = self.scrollView
        
        scrollView.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(30.0)
            make.height.equalTo(self.view).multipliedBy(0.3)
        }
        
        let firstSubview: UIView = UIView()
        firstSubview.backgroundColor = UIColor.blue
        scrollView.addSubview(firstSubview)
        firstSubview.makeConstraints { (make) in
            make.centerX.top.equalTo(scrollView)
            make.width.equalTo(200.0)
            make.height.equalTo(80.0)
        }
        
        let secondSubview: UIView = UIView()
        secondSubview.backgroundColor = UIColor.red
        scrollView.addSubview(secondSubview)
        secondSubview.makeConstraints { (make) in
            make.top.equalTo(firstSubview.cm.bottom).offset(20.0)
            make.width.equalTo(firstSubview).multipliedBy(0.5)
            make.centerX.equalTo(scrollView)
            make.height.equalTo(120.0)
        }
        
        let thirdSubview: UIView = UIView()
        thirdSubview.backgroundColor = UIColor.magenta
        scrollView.addSubview(thirdSubview)
        thirdSubview.makeConstraints { (make) in
            make.centerX.equalTo(secondSubview)
            make.top.equalTo(secondSubview.cm.bottom).offset(20.0)
            make.width.equalTo(100.0)
            make.height.equalTo(400.0)
            make.bottom.equalTo(scrollView).priority(100.0)
            make.bottom.equalTo(scrollView).offset(-20.0)
        }
        
        let safeAreaCheckView: UIView = UIView()
        safeAreaCheckView.backgroundColor = UIColor.red
        self.view.addSubview(safeAreaCheckView)
        safeAreaCheckView.makeConstraints { (make) in
            make.edges.equalTo(self.view.cm.safeArea).inset(30.0)
        }
        
        let superViewCheck: UIView = UIView()
        superViewCheck.backgroundColor = UIColor.orange
        safeAreaCheckView.addSubview(superViewCheck)
        superViewCheck.makeConstraints { (make) in
            make.edges.equalToSuperView().inset(20.0)
        }
    }

}   

