//
//  UIViewAdditions.swift
//  KanyeLyrics
//
//  Created by Calvin Zheng on 2015-04-19.
//  Copyright (c) 2015 JordanK. All rights reserved.
//

import UIKit

extension UIView
{
    var top: CGFloat
    {
        get
        {
            return self.frame.origin.y
        }
        set
        {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var bottom: CGFloat
    {
        get
        {
            return self.frame.origin.y + self.frame.size.height
        }
        set
        {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }
    
    var width: CGFloat
    {
        get
        {
            return self.frame.size.width
        }
        set
        {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
}
