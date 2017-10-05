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

public class StroachTabBarController : UITabBarController {
    
    // MARK: Public properties
    
    public private(set) var stroachTabBar: StroachTabBar;
    
    public override var selectedIndex: Int {
        get {
            return super.selectedIndex;
        }
        set {
            super.selectedIndex = newValue;
            self.stroachTabBar.selectedIndex = newValue;
        }
    }
    
    // MARK: Initializer
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.stroachTabBar = StroachTabBar();
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        
        self.stroachTabBar.delegate = self;
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.stroachTabBar = StroachTabBar();
        
        super.init(coder: aDecoder);
        
        self.stroachTabBar.delegate = self;
    }
    
    // MARK: Controller's lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad();
        
        self.tabBar.backgroundImage = UIImage();
        self.tabBar.shadowImage = UIImage();
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        self.stroachTabBar.frame = self.tabBar.bounds;
        self.stroachTabBar.layoutSubviews();
        
        for view in self.tabBar.subviews {
            view.removeFromSuperview();
        }
        
        self.tabBar.addSubview(self.stroachTabBar);
    }
    
}

extension StroachTabBarController: StroachTabBarDelegate {
    
    public func didSelectItem(tabBar: StroachTabBar, index: Int) {
        self.selectedViewController = self.viewControllers?[index];
    }
    
}
