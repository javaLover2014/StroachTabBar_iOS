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

import Foundation
import UIKit

public class StroachTabBar: UIView {
    
    public var delegate: StroachTabBarDelegate?;
    
    public private(set) var currentItem: StroachTabBarItem?;
    
    public var selectedIndex: Int = 0 {
        didSet {
            if (selectedIndex != oldValue && currentItem != nil && items != nil) {
                self.transitionToItem(from: currentItem!, to: items![selectedIndex], completion: {
                    self.currentItem = self.items![self.selectedIndex];
                });
            }
        }
    }
    
    public var items: [StroachTabBarItem]? {
        didSet {
            for view in subviews {
                view.removeFromSuperview();
            }
            currentItem = nil;
            
            if let barItems = items {
                for item in barItems {
                    item.addTarget(self, action: #selector(didSelectItem(sender:)), for: .touchUpInside);
                    item.tintColor = self.unselectedColor;
                    addSubview(item);
                }
                
                currentItem = barItems.count > 0 ? barItems[0] : nil;
                currentItem?.tintColor = self.selectedColor;
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
    
    // MARK: Initializer
    
    public override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews();
        
        if items != nil {
            let width = self.bounds.width/CGFloat(items!.count);
            for i in 0..<items!.count {
                let item = items![i];
                
                item.frame = CGRect.init(x: CGFloat(i) * width + (width - self.bounds.height + 10.0)/2, y: CGFloat(5.0), width: self.bounds.height - 10, height: self.bounds.height - 10);
            }
        }
    }
    
    // MARK: Private functions
    
    @objc private func didSelectItem(sender: StroachTabBarItem) {
        let index = self.items!.index(of: sender)!;
        self.selectedIndex = index;
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400), execute: {
            self.delegate?.didSelectItem(tabBar: self, index: index);
        })
    }
    
    private func transitionToItem(from: StroachTabBarItem, to: StroachTabBarItem, completion: (() -> Void)?) {
        self.layoutIfNeeded();

        let animatingTabTransitionLayer = CAShapeLayer();
        
        let animatingTabTransitionBezierPath = UIBezierPath();
        animatingTabTransitionLayer.strokeColor = self.selectedColor.cgColor;
        animatingTabTransitionLayer.fillColor = UIColor.clear.cgColor;
        animatingTabTransitionLayer.lineWidth = 2.0;
        
        let clockwise = self.items!.index(of: to)! < self.items!.index(of: from)!;

        animatingTabTransitionBezierPath.addArc(withCenter: from.center
            , radius: from.imageView!.frame.width/2.0 + 7.5, startAngle: CGFloat.pi/2.0, endAngle: CGFloat.pi, clockwise: clockwise);
        animatingTabTransitionBezierPath.addArc(withCenter: from.center
            , radius: from.imageView!.frame.width/2.0 + 7.5, startAngle: CGFloat.pi, endAngle: CGFloat.pi/2.0, clockwise: clockwise);
        
        //traveling from one item to the next
        let origin = from.convert(CGPoint(x: from.imageView!.frame.midX, y: from.imageView!.frame.maxY + 7.5), to: self);
        let destination = to.convert(CGPoint(x: to.imageView!.frame.midX, y: to.imageView!.frame.maxY + 7.5), to: self);
        animatingTabTransitionBezierPath.move(to: origin);
        animatingTabTransitionBezierPath.addLine(to: destination);
    
        animatingTabTransitionBezierPath.addArc(withCenter: to.center
            , radius: to.imageView!.frame.width/2.0 + 7.5, startAngle: CGFloat.pi/2.0, endAngle: CGFloat.pi, clockwise: clockwise);
        animatingTabTransitionBezierPath.addArc(withCenter: to.center
            , radius: to.imageView!.frame.width/2.0 + 7.5, startAngle: CGFloat.pi, endAngle: CGFloat.pi/2.0, clockwise: clockwise);
        
        //determining total length to see where the animation will begin and end
        let circumference = 2.0 * CGFloat.pi * (to.imageView!.frame.width/2.0 + 7.5);
        let distanceBetweenTabs = fabs(origin.x - destination.x);
        let totalLength = 2.0 * circumference + distanceBetweenTabs;
        
        let leadingAnimation = CABasicAnimation(keyPath: "strokeEnd");
        leadingAnimation.duration = 0.7;
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
        });
        animatingTabTransitionLayer.add(transitionAnimationGroup, forKey: nil);
        CATransaction.commit();
        
        self.layer.addSublayer(animatingTabTransitionLayer);
        
        completion?();
    }
    
}

public protocol StroachTabBarDelegate {
    
    func didSelectItem(tabBar: StroachTabBar, index: Int);
    
}
