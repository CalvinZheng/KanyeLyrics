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
    func lyricClicked(lyric: String)
    func lyricDetailClicked(detail: String)
}

class LyricsTableController : NSObject, UITableViewDataSource, UITableViewDelegate, NSObjectProtocol
{
    var tableView: UITableView?
    var delegate: LyricsTableControllerDelegate?
    var expandedIndex: Int?
    
    func reset()
    {
        self.expandedIndex = nil
        self.tableView?.reloadData()
        self.tableView?.contentOffset = CGPoint.zeroPoint
    }
    
    func prepareForDisplay()
    {
        self.tableView?.registerNib(UINib(nibName: "LyricCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "LyricCell")
        self.tableView?.registerNib(UINib(nibName: "LyricDetailCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "LyricDetailCell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return LyricsDatabase.sharedInstance.selectedGroupContent().count + (expandedIndex != nil ? 1 : 0)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.row-1 == self.expandedIndex
        {
            return 36
        }
        else
        {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.row-1 == self.expandedIndex
        {
            if let aCell = tableView.dequeueReusableCellWithIdentifier("LyricDetailCell", forIndexPath: indexPath) as? LyricDetailCell
            {
                aCell.detailLabel.text = LyricsDatabase.sharedInstance.lyricDetail(self.expandedIndex!)
                return aCell
            }
            else
            {
                assertionFailure("NoDetailCellFound")
                return UITableViewCell()
            }
        }
        else
        {
            var index = indexPath.row
            if self.expandedIndex != nil && indexPath.row > self.expandedIndex!+1
            {
                index--
            }
            
            if let aCell = tableView.dequeueReusableCellWithIdentifier("LyricCell", forIndexPath: indexPath) as? LyricCell
            {
                aCell.lyricLabel.text = LyricsDatabase.sharedInstance.lyric(index)
                aCell.starButton.selected = LyricsDatabase.sharedInstance.isFav(index)
                aCell.starButton.addTarget(self, action: "starTapped:", forControlEvents: UIControlEvents.TouchUpInside)
                return aCell
            }
            else
            {
                assertionFailure("NoCellFound")
                return UITableViewCell()
            }
        }
    }
    
    func starTapped(sender: UIButton)
    {
        for aCell in self.tableView!.visibleCells()
        {
            if let aLyricCell = aCell as? LyricCell
            {
                if aLyricCell.starButton == sender
                {
                    if let indexPath = self.tableView?.indexPathForCell(aLyricCell)
                    {
                        var row = indexPath.row
                        if self.expandedIndex != nil && row > self.expandedIndex!+1
                        {
                            row--
                        }
                        LyricsDatabase.sharedInstance.switchFavState(row)
                        
                        if LyricsDatabase.sharedInstance.isInFavGroup()
                        {
                            self.tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
                        }
                        else
                        {
                            self.tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                        }
                    }
                    
                    return
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let index = self.expandedIndex
        {
            if indexPath.row == index
            {
                self.expandedIndex = nil
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index+1, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Top)
                tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: index, inSection: indexPath.section), atScrollPosition: UITableViewScrollPosition.None, animated: true)
            }
            else if indexPath.row == index+1
            {
                self.delegate?.lyricDetailClicked(LyricsDatabase.sharedInstance.lyricDetail(index))
            }
            else
            {
                var indexInData = indexPath.row
                var cellToSendBack: UITableViewCell?
                if indexPath.row > index+1
                {
                    indexInData--
                }
                else
                {
                    cellToSendBack = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index+1, inSection: indexPath.section))
                }
                
                self.expandedIndex = nil
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index+1, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Top)
                self.expandedIndex = indexInData
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: indexInData+1, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Top)
                cellToSendBack?.superview?.sendSubviewToBack(cellToSendBack!)
                
                tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: indexInData+1, inSection: indexPath.section), atScrollPosition: UITableViewScrollPosition.None, animated: true)
                self.delegate?.lyricClicked(LyricsDatabase.sharedInstance.lyric(indexInData))
            }
        }
        else
        {
            self.expandedIndex = indexPath.row
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row+1, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Top)
            
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: indexPath.row+1, inSection: indexPath.section), atScrollPosition: UITableViewScrollPosition.None, animated: true)
            self.delegate?.lyricClicked(LyricsDatabase.sharedInstance.lyric(indexPath.row))
        }
    }
}