//
//  TKSegmentView.swift
//  TKSegmentView
//
//  Created by Toseef Khilji on 06/09/18.
//  Copyright © 2018 ASApps. All rights reserved.
//

import UIKit

public class TKSegmentView: UIView, TKItemViewDelegate {
    
    public weak var delegate: TKSegmentViewDelegate?
    
    override public var frame: CGRect {
        didSet {
            redraw()
        }
    }
    
    public var progressTintColor: UIColor? {
        didSet {
            redraw()
        }
    }
    
    public var trackTintColor: UIColor? {
        didSet {
            redraw()
        }
    }
    
    public var itemSpace: Double? {
        didSet {
            redraw()
        }
    }
    
    public var segments: [SegmentItem]? {
        didSet {
            redraw()
        }
    }

    public var isAutoProgress: Bool = false

    var segmentViews: [TKItemView] = []

    var currentIndex: Int = 0

    public init(withItems items: [SegmentItem]!) {
        self.segments = items
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        redraw()
    }
    
    fileprivate func redraw() {
        clear()
        draw()
    }
    
    fileprivate func clear() {
        
        segmentViews.removeAll()
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    fileprivate func draw() {
        
        guard let segments = self.segments, segments.count > 0 else { return }

        let horizontalSpace: Double = itemSpace ?? 6.0
        
        var elementWidth = ((Double(bounds.width) + horizontalSpace) / Double(segments.count))
        elementWidth -= horizontalSpace
        
        if elementWidth <= 0 { return }
        
        var xOffset: Double = 0.0
        
        for item in segments {
            
            let elementView = TKItemView(withItem: item)
            elementView.progressTintColor = self.progressTintColor
            elementView.trackTintColor = self.trackTintColor
            elementView.delegate = self
            elementView.frame = CGRect(x: xOffset, y: 0, width: elementWidth, height: Double(bounds.height))
            elementView.drawEmpty()
            self.addSubview(elementView)
            segmentViews.append(elementView)
            xOffset += elementWidth + horizontalSpace
        }
        
        let elementView = segmentViews[0]
        delegate?.progressBar(willDisplayItemAtIndex: 0)
        elementView.animate()
    }


    public func selectItem(at index: Int) {

        if index >= currentIndex {
            currentIndex = index
        }

        for (indx, elementview)in segmentViews.enumerated() {
            if index == indx {
                elementview.animate()
                delegate?.progressBar(willDisplayItemAtIndex: index)
                currentIndex = index
            } else if indx < currentIndex {
                elementview.drawFilled()
            } else {
                elementview.drawEmpty()
            }
        }
    }

    public func progressBar(didFinishWithElement element: TKItemView) {

        guard let segments = self.segments, segments.count > 0 else { return }

        if var index = segmentViews.index(of: element) {
            
            delegate?.progressBar(didDisplayItemAtIndex: index)

            if isAutoProgress {
                index += 1
                if index < segments.count {
                    let elementView = segmentViews[index]
                    delegate?.progressBar(willDisplayItemAtIndex: index)
                    currentIndex = index
                    elementView.animate()
                }
            }
        }
    }
}
