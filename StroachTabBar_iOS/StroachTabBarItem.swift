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

public class StroachTabBarItem: UIButton {
    
    private var outerCircleLayer: CAShapeLayer?;
    
    public init(image: UIImage) {
        super.init(frame: CGRect.zero);
        self.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal);
        self.imageView?.contentMode = UIViewContentMode.scaleAspectFit;
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews();
        
        self.backgroundColor = UIColor.clear;
        
        self.titleLabel?.isHidden = true;
        self.imageView?.frame = CGRect.init(x: 7.5, y: 7.5, width: self.bounds.width - 15, height: self.bounds.height - 15.0);
    }
    
    func showOutline() {
        self.layoutIfNeeded();
        
        self.outerCircleLayer?.removeFromSuperlayer();
        
        self.outerCircleLayer = CAShapeLayer();
        let outerCircleBezierPath = UIBezierPath();
        let outlineRadius = (self.imageView!.frame.width + 15)/2.0;
        
        outerCircleBezierPath.addArc(withCenter: self.imageView!.center, radius: outlineRadius, startAngle: CGFloat.pi/2.0, endAngle: CGFloat.pi, clockwise: false);
        outerCircleBezierPath.addArc(withCenter: self.imageView!.center, radius: outlineRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi/2.0, clockwise: false);
        
        self.outerCircleLayer!.path = outerCircleBezierPath.cgPath;
        self.outerCircleLayer!.strokeColor = self.tintColor.cgColor;
        self.outerCircleLayer!.fillColor = UIColor.clear.cgColor;
        self.outerCircleLayer!.lineWidth = 2.0;
        self.layer.addSublayer(self.outerCircleLayer!);
    }
    
    func hideOutline() {
        if (self.outerCircleLayer != nil) {
            self.outerCircleLayer?.removeFromSuperlayer();
            self.outerCircleLayer = nil;
        }
    }
    
}
