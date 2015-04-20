//
//  GroupTitleView.swift
//  KanyeLyrics
//
//  Created by Calvin Zheng on 2015-04-19.
//  Copyright (c) 2015 JordanK. All rights reserved.
//

import UIKit

protocol GroupTitleViewDelegate
{
    func titleTapped(sender: GroupTitleView)
}

class GroupTitleView: UIView
{
    var delegate: GroupTitleViewDelegate?

    @IBOutlet var titleButton: UIButton!
    
    @IBAction func titleTapped(sender: UIButton)
    {
        self.delegate?.titleTapped(self)
    }
}
