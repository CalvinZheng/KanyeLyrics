//
//  KeyboardViewController.swift
//  keyboardExt
//
//  Created by Calvin Zheng on 2015-04-18.
//  Copyright (c) 2015 JordanK. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, LyricsTableControllerDelegate, GroupTitleViewDelegate, GroupSelectionControllerDelegate {

    var keyboardMainView: UIView!
    var lastLyricString: String = ""
    var lastDetailString: String = ""
    var groupTitleView: GroupTitleView!
    var groupSelectionMode: Bool!
    
    lazy var lyricsTableController: LyricsTableController =
    {
        var controller = LyricsTableController()
        controller.delegate = self
        return controller
    }()
    
    lazy var groupSelectionController: GroupSelectionController =
    {
        var controller = GroupSelectionController()
        controller.delegate = self
        return controller
    }()
    
    @IBOutlet var lyricsTableView: UITableView!
    @IBOutlet var titleContainerView: UIView!
    @IBOutlet var groupSelectionScrollView: UIScrollView!
    @IBOutlet var scrollViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var scrollViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - override
    
    override func updateViewConstraints()
    {
        super.updateViewConstraints()
        
        if self.groupSelectionMode == false
        {
            self.scrollViewTopConstraint.active = false
            self.scrollViewHeightConstraint.active = true
        }
        else
        {
            self.scrollViewTopConstraint.active = true
            self.scrollViewHeightConstraint.active = false
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.groupSelectionMode = false
        
        self.keyboardMainView = NSBundle.mainBundle().loadNibNamed("keyboardMainView", owner: self, options: nil)[0] as! UIView
        self.keyboardMainView.frame = self.view.bounds
        self.keyboardMainView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.view.addSubview(self.keyboardMainView)
        
        self.lyricsTableController.tableView = self.lyricsTableView
        self.lyricsTableView.delegate = self.lyricsTableController
        self.lyricsTableView.dataSource = self.lyricsTableController
        
        self.groupTitleView = NSBundle.mainBundle().loadNibNamed("GroupTitleView", owner: self, options: nil)[0] as! GroupTitleView
        self.groupTitleView.titleButton.setTitle(LyricsDatabase.sharedInstance.titleForSelectedGroup(), forState: UIControlState.Normal)
        self.groupTitleView.backgroundColor = LyricsDatabase.sharedInstance.colorForGroup(LyricsDatabase.sharedInstance.selectedGroupIndex)
        self.groupTitleView.frame = self.titleContainerView.bounds
        self.groupTitleView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.titleContainerView.addSubview(self.groupTitleView)
        
        self.groupTitleView.delegate = self
        
        self.groupSelectionController.scrollView = self.groupSelectionScrollView
    }
    
    // MARK: - func
    
    func lyricClicked(lyric: String)
    {
        if let context = self.textDocProxy().documentContextBeforeInput
        {
            if context.hasSuffix(self.lastLyricString) || self.lastLyricString.hasSuffix(context)
            {
                for i in 1...count(self.lastLyricString)
                {
                    self.textDocProxy().deleteBackward()
                }
            }
            else
            {
                let lastLongString = self.lastLyricString + "\n" + self.lastDetailString
                if context.hasSuffix(lastLongString) || lastLongString.hasSuffix(context)
                {
                    for i in 1...count(lastLongString)
                    {
                        self.textDocProxy().deleteBackward()
                    }
                }
            }
        }
        
        self.textDocProxy().insertText(lyric)
        
        self.lastLyricString = lyric
        self.lastDetailString = ""
    }
    
    func lyricDetailClicked(detail: String)
    {
        if let context = self.textDocProxy().documentContextBeforeInput
        {
            if context.hasSuffix(self.lastDetailString) || self.lastDetailString.hasSuffix(context)
            {
                for i in 1...count("\n"+self.lastDetailString)
                {
                    self.textDocProxy().deleteBackward()
                }
            }
        }
        
        self.textDocProxy().insertText("\n"+detail)
        
        self.lastDetailString = detail
    }
    
    func textDocProxy() -> UITextDocumentProxy
    {
        return self.textDocumentProxy as! UITextDocumentProxy
    }
    
    // MARK: - actions
    
    var timer: NSTimer?
    
    @IBAction func deleteTapped(sender: UIButton)
    {
        self.textDocProxy().deleteBackward()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "deleteHold:", userInfo: nil, repeats: false)
    }
    
    func deleteHold(timer: NSTimer)
    {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.07, target: self, selector: "deleteHoldOn:", userInfo: nil, repeats: true)
    }
    
    func deleteHoldOn(timer: NSTimer)
    {
        self.textDocProxy().deleteBackward()
    }
    
    @IBAction func deleteReleased(sender: UIButton)
    {
        self.timer?.invalidate()
        self.timer = nil
    }

    @IBAction func globeTapped(sender: UIButton)
    {
        self.advanceToNextInputMode()
    }
    
    // MARK: - delegate
    
    func titleTapped(sender: GroupTitleView)
    {
        if self.groupSelectionMode == true
        {
            self.scrollViewTopConstraint.active = false
            self.scrollViewHeightConstraint.active = true
            self.lyricsTableView.hidden = false
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.layoutIfNeeded()
            },
                completion: { (finished) -> Void in
                self.groupSelectionMode = false
            })
        }
        else
        {
            self.groupSelectionController.prepareContent()
            self.scrollViewHeightConstraint.active = false
            self.scrollViewTopConstraint.active = true
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.layoutIfNeeded()
            },
                completion: { (finished) -> Void in
                self.lyricsTableView.hidden = true
                self.groupSelectionMode = true
            })
        }
        
    }
    
    func didSelectGroup(index: Int)
    {
        assert(self.groupSelectionMode == true, "UnknownError")
        LyricsDatabase.sharedInstance.setSelectedGroup(index)
        self.lyricsTableController.reset()
        self.groupTitleView.titleButton.setTitle(LyricsDatabase.sharedInstance.titleForSelectedGroup(), forState: UIControlState.Normal)
        
        self.scrollViewHeightConstraint.active = true
        self.scrollViewTopConstraint.active = false
        self.lyricsTableView.hidden = false
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.groupTitleView.backgroundColor = LyricsDatabase.sharedInstance.colorForGroup(LyricsDatabase.sharedInstance.selectedGroupIndex)
            },
            completion: { (finished) -> Void in
                self.groupSelectionMode = false
        })
    }
}
