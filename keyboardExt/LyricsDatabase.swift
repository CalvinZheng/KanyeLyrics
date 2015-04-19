//
//  LyricsDatabase.swift
//  KanyeLyrics
//
//  Created by Calvin Zheng on 2015-04-18.
//  Copyright (c) 2015 JordanK. All rights reserved.
//

import UIKit

class LyricsDatabase: NSObject
{
    var dataArray: [[String:AnyObject]]!
    var selectedGroupIndex: Int!
    static let sharedInstance = LyricsDatabase()
    
    override init()
    {
        super.init()
        
        if let path = NSBundle.mainBundle().pathForResource("Lyrics", ofType: "plist"), data = NSArray(contentsOfFile: path) as? [[String:AnyObject]]
        {
            self.dataArray = data
        }
        else
        {
            assertionFailure("Lyrics.plist format error!!!")
        }
        
        self.selectedGroupIndex = NSUserDefaults.standardUserDefaults().integerForKey("SelectedGroup")
        if self.selectedGroupIndex >= self.dataArray.count
        {
            self.setSelectedGroup(0)
        }
    }
    
    func setSelectedGroup(selectedGroup: Int)
    {
        if self.selectedGroupIndex < self.dataArray.count
        {
            self.selectedGroupIndex = selectedGroup
            NSUserDefaults.standardUserDefaults().setInteger(selectedGroup, forKey: "SelectedGroup")
        }
    }
    
    func titleForGroup(index: Int) -> String
    {
        if let aString = self.dataArray[index]["Category"] as? String
        {
            return aString
        }
        
        assertionFailure("Lyrics.plist format error!!!")
        return ""
    }
    
    func selectedGroupContent() -> [[String:String]]
    {
        if let content = self.dataArray[self.selectedGroupIndex]["Content"] as? [[String:String]]
        {
            return content
        }
        
        assertionFailure("Lyrics.plist format error!!!")
        return []
    }
    
    func lyric(indexInSelectedGroup: Int) -> String
    {
        if let lyric = self.selectedGroupContent()[indexInSelectedGroup]["Lyric"]
        {
            return lyric
        }
        
        assertionFailure("Lyrics.plist format error!!!")
        return ""
    }
    
    func lyricDetail(indexInSelectedGroup: Int) -> String
    {
        if let lyricDetail = self.selectedGroupContent()[indexInSelectedGroup]["Detail"]
        {
            return lyricDetail
        }
        
        assertionFailure("Lyrics.plist format error!!!")
        return ""
    }
}
