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
    var dataDict: NSDictionary!
    var selectedGroupIndex: Int!
    static let sharedInstance = LyricsDatabase()
    
    override init()
    {
        self.dataDict = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Lyrics", ofType: "plist")!)
        self.selectedGroupIndex = NSUserDefaults.standardUserDefaults().integerForKey("SelectedGroup")
    }
    
    func setSelectedGroup(selectedGroup: Int)
    {
        self.selectedGroupIndex = selectedGroup
        NSUserDefaults.standardUserDefaults().setInteger(selectedGroup, forKey: "SelectedGroup")
    }
    
    func selectedGroup() -> NSDictionary
    {
        return self.dataDict[self.dataDict.allKeys[self.selectedGroupIndex] as! String] as! NSDictionary
    }
    
    func lyric(indexInSelectedGroup: Int) -> String?
    {
        return self.selectedGroup().allKeys[indexInSelectedGroup] as? String
    }
    
    func lyricDetail(indexInSelectedGroup: Int) -> String?
    {
        return self.selectedGroup()[self.selectedGroup().allKeys[indexInSelectedGroup] as! String] as? String
    }
}
