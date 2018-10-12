//
//  SegmentView.swift
//  TKSegmentView
//
//  Created by Toseef Khilji on 06/09/18.
//  Copyright © 2018 ASApps. All rights reserved.
//

import UIKit

public protocol TKSegmentViewDelegate: class {
    
    func progressBar(willDisplayItemAtIndex index: Int)
    func progressBar(didDisplayItemAtIndex index: Int)
}

public protocol TKItemViewDelegate: class {
    
    func progressBar(didFinishWithElement element: TKItemView)
}

public class TKItemView: UIView {
    
    weak var delegate: TKItemViewDelegate?
    let item: SegmentItem
    
    var progressTintColor: UIColor?
    var trackTintColor: UIColor?
    
    init(withItem item: SegmentItem!) {
        self.item = item
        super.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawEmpty() {
        
        let emptyColor = trackTintColor ?? .lightGray
        let emptyShape = CAShapeLayer()
        emptyShape.frame = self.bounds
        emptyShape.backgroundColor = emptyColor.cgColor
        emptyShape.cornerRadius = bounds.height / 2
        self.layer.addSublayer(emptyShape)
    }

    func drawFilled() {

        let fillColor = progressTintColor ?? .darkGray
        let emptyShape = CAShapeLayer()
        emptyShape.frame = self.bounds
        emptyShape.backgroundColor = fillColor.cgColor
        emptyShape.cornerRadius = bounds.height / 2
        self.layer.addSublayer(emptyShape)
    }

    func animate() {
        
        let fillColor = progressTintColor ?? .darkGray
        let startPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height), cornerRadius: bounds.height / 2).cgPath
        let endPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2)
        
        let filledShape = CAShapeLayer()
        filledShape.path = startPath
        filledShape.fillColor = fillColor.cgColor
        self.layer.addSublayer(filledShape)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.delegate?.progressBar(didFinishWithElement: self)
            self.item.handler?()
        })
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = endPath.cgPath
        animation.duration = self.item.duration
        animation.repeatCount = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fillMode = kCAFillModeBoth
        animation.isRemovedOnCompletion = false
        
        filledShape.add(animation, forKey: animation.keyPath)
        CATransaction.commit()
    }
}


public class SegmentItem {

    public typealias CompletionHanlder = () -> ()

    let duration: Double
    let handler: CompletionHanlder?

    public init(withDuration duration: Double = 0.5, handler completion: CompletionHanlder? = nil) {
        self.duration = duration
        self.handler = completion
    }
}
