//
//  GroupSelectionController.swift
//  KanyeLyrics
//
//  Created by Calvin Zheng on 2015-04-19.
//  Copyright (c) 2015 JordanK. All rights reserved.
//

import UIKit

protocol GroupSelectionControllerDelegate
{
    func didSelectGroup(index: Int)
}

class GroupSelectionController: NSObject, GroupTitleViewDelegate
{
    var scrollView: UIScrollView?
    var delegate: GroupSelectionControllerDelegate?
    
    lazy var allTitleViews: [GroupTitleView] =
    {
        var views = [GroupTitleView]()
        
        for i in 0..<LyricsDatabase.sharedInstance.dataArray.count
        {
            if let aTitleView = NSBundle.mainBundle().loadNibNamed("GroupTitleView", owner: self, options: nil)[0] as? GroupTitleView
            {
                aTitleView.titleButton.setTitle(LyricsDatabase.sharedInstance.titleForGroup(i), forState: UIControlState.Normal)
                aTitleView.backgroundColor = LyricsDatabase.sharedInstance.colorForGroup(i)
                aTitleView.delegate = self
                
                views.append(aTitleView)
            }
            else
            {
                assertionFailure("FailToLoadTitleView")
            }
        }
        
        return views
    }()

    
    func prepareContent()
    {
        if let scrollView = self.scrollView
        {
            scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: CGFloat(self.allTitleViews.count) * self.allTitleViews[0].frame.size.height)
            var top: CGFloat = 0
            for aTitleView in self.allTitleViews
            {
                aTitleView.top = top
                aTitleView.width = scrollView.bounds.size.width
                aTitleView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleBottomMargin
                scrollView.addSubview(aTitleView)
                top = aTitleView.bottom
            }
        }
        else
        {
            assertionFailure("NoScrollViewError")
        }
    }
    
    func titleTapped(sender: GroupTitleView)
    {
        self.delegate?.didSelectGroup(find(self.allTitleViews, sender)!)
    }
}
