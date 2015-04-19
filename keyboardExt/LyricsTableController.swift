//
//  LyricsTableController.swift
//  KanyeLyrics
//
//  Created by Calvin Zheng on 2015-04-18.
//  Copyright (c) 2015 JordanK. All rights reserved.
//

import UIKit

protocol LyricsTableControllerDelegate
{
    func lyricClicked(lyric: String?)
}

class LyricsTableController : NSObject, UITableViewDataSource, UITableViewDelegate, NSObjectProtocol
{
    var delegate : LyricsTableControllerDelegate?
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return LyricsDatabase.sharedInstance.selectedGroupContent().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let aCell = NSBundle.mainBundle().loadNibNamed("LyricCell", owner: self, options: nil)[0] as! LyricCell
        aCell.lyricLabel.text = LyricsDatabase.sharedInstance.lyric(indexPath.row)
        aCell.setSelected(false, animated: false)
        return aCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.delegate?.lyricClicked(LyricsDatabase.sharedInstance.lyric(indexPath.row))
    }
}