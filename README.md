## StroachTabBar for iOS

The StroachTabBar is a modern TabBar with a unique animation written in Swift. It is heavily inspired by [BATabBarController](https://github.com/antiguab/BATabBarController) but its implementation is more user-friendly. Because the StroachTabBarController is a subclass of UITabBarController it can be used without major code changes.

### Installation

StroachTabBarController is available through [CocoaPods](). To install it, simply add the following line to your Podfile:

```ruby
use_frameworks!
pod 'StroachTabBar_iOS'
```

Run

```ruby
pod install
```

 and **import** it in your source code.

```swift
import StroachTabBarController
```

### Usage 

This is an instruction of how to use *StroachTabBarController* in the **Storyboard**.
1. Add a native UITabBarController to the storyboard as the initial view controller and establish relationships with its view controllers.

2. Change the class of the UITabBarController to StroachTabBarController.

   ![Add](./images/Add.tiff)

3. In the App Delegate cast the window.rootViewController to an instance of StroachTabBarController and add a StroachTabBarItem for every connected view controller.

   ```swift
   if let tabBarController = window?.rootViewController as? StroachTabBarController {
   	let itemA = StroachTabBarItem(image: UIImage(named: "imageA")!);
    let itemB = StroachTabBarItem(image: UIImage(named: "imageB")!);
               
       tabBarController.stroachTabBar.items = [itemA, itemB];
   }
   ```

4. Customize the look and feel of the StroachTabBar.

   ```swift
   tabBarController.stroachTabBar.backgroundColor = UIColor.black;
   tabBarController.stroachTabBar.selectedColor = UIColor.orange;
   tabBarController.stroachTabBar.unselectedColor = UIColor.darkGray;
   ```

### Contact

If you have any questions feel free to send an email to lukas.truemper@outlook.de.

### License

This project is published under the MIT License.

Copyright 2017 Lukas Trümper

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
