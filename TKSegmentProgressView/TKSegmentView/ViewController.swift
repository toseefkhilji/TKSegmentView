//
//  ViewController.swift
//  TKProgressView
//
//  Created by Toseef Khilji on 06/09/18.
//  Copyright © 2018 ASApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TKSegmentViewDelegate {

    var progressView: TKSegmentView!
    var items: [SegmentItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0...3 {
            items.append(SegmentItem())
        }
        let elementWithCompletion = SegmentItem(withDuration: 2) {
            print("elementWithCompletion finished")
        }

        items.append(elementWithCompletion)
        progressView = TKSegmentView(withItems: items)
        progressView.progressTintColor = UIColor(red: 39/255.0, green: 174/255.0, blue: 96/255.0, alpha: 1.0)
        progressView.trackTintColor = UIColor.lightGray
//        progressView.isAutoProgress = true
        progressView.delegate = self
        progressView.backgroundColor = .white
        progressView.itemSpace = 5.0
        progressView.frame = CGRect(x: 20, y: 80, width: view.bounds.width - 40, height: 5)
        view.addSubview(progressView)
    }

    func progressBar(willDisplayItemAtIndex index: Int) {
        print("willDisplayItemAtIndex \(index)")
    }

    func progressBar(didDisplayItemAtIndex index: Int) {
        print("didDisplayItemAtIndex \(index)")
    }

    @IBAction func change(_ sender: UISegmentedControl) {
        progressView.selectItem(at: sender.selectedSegmentIndex)
    }
}

