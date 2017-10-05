//
//  StroachTabBar.swift
//  StroachTabBar_iOS
//
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Lukas Trümper
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

public class StroachTabBar: UIView {
    
    // MARK: Static variables
    
    static let padding: CGFloat = 5.0;
    
    // MARK: Public properties
    
    public var delegate: StroachTabBarDelegate?;
    
    public private(set) var currentItem: StroachTabBarItem? {
        didSet {
            self.currentItem?.tintColor = self.selectedColor;
            oldValue?.tintColor = self.unselectedColor;
        }
    }
    
    public var selectedIndex: Int = 0 {
        willSet {
            if (newValue >= 0 && selectedIndex != newValue && currentItem != nil && items != nil && newValue < items!.count) {
                
                if (self.superview == nil) {
                    // StroachTabBar does not have its frame, animations will behave wrong.
                    self.currentItem = self.items![newValue];
                } else {
                    // StroachTabBar has its frame, animations will work properly.
                    self.transitionToItem(from: currentItem!, to: items![newValue], completion: {
                        self.currentItem = self.items![newValue];
                    });
                }
            }
        }
    }
    
    public var items: [StroachTabBarItem]? {
        didSet {
            // 1. Reset view.
            for view in subviews {
                view.removeFromSuperview();
            }
            currentItem = nil;
            self.selectedIndex = 0;
            
            // 2. Add items if needed.
            if (items != nil && items!.count > 0) {
                for item in items! {
                    item.addTarget(self, action: #selector(didSelectItem(sender:)), for: .touchUpInside);
                    item.tintColor = self.unselectedColor;
                    addSubview(item);
                }
                self.layoutIfNeeded();
                
                currentItem = items![0];
            }
        }
    }
    
    public override var tintColor: UIColor! {
        get {
            return self.selectedColor;
        }
        set {
            self.selectedColor = newValue;
        }
    }
    
    public var selectedColor: UIColor = UIColor.red {
        didSet {
            self.currentItem?.tintColor = self.selectedColor;
        }
    }
    
    public var unselectedColor: UIColor = UIColor.darkGray {
        didSet {
            if (items != nil) {
                for item in items! {
                    if (item != self.currentItem) {
                        item.tintColor = self.unselectedColor;
                    }
                }
            }
            
        }
    }
    
    public var borderColor: CGColor? {
        get {
            return self.topBorder.borderColor;
        }
        set {
            self.topBorder.borderColor = newValue;
        }
    }
    
    public var borderWidth: CGFloat {
        get {
            return self.topBorder.borderWidth;
        }
        set {
            self.topBorder.borderWidth = newValue;
        }
    }
    
    // MARK: Private properties
    
    private var topBorder: CALayer;
    
    // MARK: Initializer
    
    public override init(frame: CGRect) {
        self.topBorder = CALayer();
        
        super.init(frame: frame);
        
        self.layer.addSublayer(self.topBorder);
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.topBorder = CALayer();
        
        super.init(coder: aDecoder);
        
        self.layer.addSublayer(self.topBorder);
    }
    
    // MARK: View's lifecycle
    
    public override func layoutSubviews() {
        super.layoutSubviews();
        
        self.topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.borderWidth);
        
        if items != nil {
            let width = self.bounds.width/CGFloat(items!.count);
            for i in 0..<items!.count {
                let item = items![i];
                
                item.frame = CGRect(x: CGFloat(i) * width + (width - self.bounds.height + StroachTabBar.padding * 2)/2, y: StroachTabBar.padding, width: self.bounds.height - StroachTabBar.padding * 2, height: self.bounds.height - StroachTabBar.padding * 2);
            }
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview();
        
        // Now StroachTabBar has its frame, layer (outline) can be shown.
        self.currentItem?.showOutline();
    }
    
    // MARK: Private functions
    
    @objc private func didSelectItem(sender: StroachTabBarItem) {
        let index = self.items!.index(of: sender)!;
        self.selectedIndex = index;
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(350), execute: {
            self.delegate?.didSelectItem(tabBar: self, index: index);
        })
    }
    
    private func transitionToItem(from: StroachTabBarItem, to: StroachTabBarItem, completion: (() -> Void)?) {
        self.layoutSubviews();
        
        let animatingTabTransitionLayer = CAShapeLayer();
        
        let animatingTabTransitionBezierPath = UIBezierPath();
        animatingTabTransitionLayer.strokeColor = self.selectedColor.cgColor;
        animatingTabTransitionLayer.fillColor = UIColor.clear.cgColor;
        animatingTabTransitionLayer.lineWidth = 2.0;
        
        let clockwise = self.items!.index(of: to)! < self.items!.index(of: from)!;

        animatingTabTransitionBezierPath.addArc(withCenter: from.center
            , radius: from.imageView!.frame.width/2.0 + StroachTabBarItem.padding, startAngle: CGFloat.pi/2.0, endAngle: CGFloat.pi, clockwise: clockwise);
        animatingTabTransitionBezierPath.addArc(withCenter: from.center
            , radius: from.imageView!.frame.width/2.0 + StroachTabBarItem.padding, startAngle: CGFloat.pi, endAngle: CGFloat.pi/2.0, clockwise: clockwise);
        
        //traveling from one item to the next
        let origin = from.convert(CGPoint(x: from.imageView!.frame.midX, y: from.imageView!.frame.maxY + StroachTabBarItem.padding), to: self);
        let destination = to.convert(CGPoint(x: to.imageView!.frame.midX, y: to.imageView!.frame.maxY + StroachTabBarItem.padding), to: self);
        animatingTabTransitionBezierPath.move(to: origin);
        animatingTabTransitionBezierPath.addLine(to: destination);
    
        animatingTabTransitionBezierPath.addArc(withCenter: to.center
            , radius: to.imageView!.frame.width/2.0 + StroachTabBarItem.padding, startAngle: CGFloat.pi/2.0, endAngle: CGFloat.pi, clockwise: clockwise);
        animatingTabTransitionBezierPath.addArc(withCenter: to.center
            , radius: to.imageView!.frame.width/2.0 + StroachTabBarItem.padding, startAngle: CGFloat.pi, endAngle: CGFloat.pi/2.0, clockwise: clockwise);
        
        let circumference = 2.0 * CGFloat.pi * (to.imageView!.frame.width/2.0 + StroachTabBarItem.padding);
        let distanceBetweenTabs = fabs(origin.x - destination.x);
        let totalLength = 2.0 * circumference + distanceBetweenTabs;
        
        let leadingAnimation = CABasicAnimation(keyPath: "strokeEnd");
        leadingAnimation.duration = 0.6;
        leadingAnimation.fromValue = 0;
        leadingAnimation.toValue = 1;
        leadingAnimation.isRemovedOnCompletion = false;
        leadingAnimation.fillMode = kCAFillModeForwards;
        leadingAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut);
        
        let trailingAnimation = CABasicAnimation(keyPath: "strokeStart");
        trailingAnimation.duration = leadingAnimation.duration - 0.15;
        trailingAnimation.fromValue = 0;
        trailingAnimation.isRemovedOnCompletion = false;
        trailingAnimation.fillMode = kCAFillModeForwards;
        trailingAnimation.toValue = (circumference + distanceBetweenTabs) / totalLength;
        trailingAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn);
        
        animatingTabTransitionLayer.path = animatingTabTransitionBezierPath.cgPath;
        
        CATransaction.begin();
        from.tintColor = self.unselectedColor;
        from.hideOutline();
        
        let transitionAnimationGroup = CAAnimationGroup();
        transitionAnimationGroup.animations  = [leadingAnimation,trailingAnimation];
        transitionAnimationGroup.duration = leadingAnimation.duration;
        transitionAnimationGroup.isRemovedOnCompletion = false;
        transitionAnimationGroup.fillMode = kCAFillModeForwards;
        CATransaction.setCompletionBlock ({
            to.tintColor = self.selectedColor;
            to.showOutline();
            
            animatingTabTransitionLayer.removeFromSuperlayer();
            animatingTabTransitionLayer.removeAllAnimations();
            
            completion?();
        });
        animatingTabTransitionLayer.add(transitionAnimationGroup, forKey: nil);
        CATransaction.commit();
        
        self.layer.addSublayer(animatingTabTransitionLayer);
    }
    
}

public protocol StroachTabBarDelegate {
    
    func didSelectItem(tabBar: StroachTabBar, index: Int);
    
}
