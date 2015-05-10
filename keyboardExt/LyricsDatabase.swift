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
    var favIndexData: [[String:Int]]!
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
            assertionFailure("Lyrics.plist format error")
        }
        
        self.selectedGroupIndex = NSUserDefaults.standardUserDefaults().integerForKey("SelectedGroup")
        if self.selectedGroupIndex >= self.dataArray.count
        {
            self.setSelectedGroup(0)
        }
        
        if let favData = NSUserDefaults.standardUserDefaults().objectForKey("FavoriteGroupData") as? [[String:Int]]
        {
            self.favIndexData = favData
        }
        else if let defaultFavData = self.dataArray[0]["Content"] as? [[String:Int]]
        {
            self.favIndexData = defaultFavData
            self.saveFavData()
        }
        else
        {
            assertionFailure("Lyrics.plist favorite group format error")
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
    
    func saveFavData()
    {
        //TODO: verify
        NSUserDefaults.standardUserDefaults().setObject(self.favIndexData, forKey: "FavoriteGroupData")
    }
    
    func titleForGroup(index: Int) -> String
    {
        if let aString = self.dataArray[index]["Category"] as? String
        {
            return aString
        }
        
        assertionFailure("Lyrics.plist format error")
        return ""
    }
    
    func colorForGroup(index: Int) -> UIColor
    {
        if let colorDict = self.dataArray[index]["Color"] as? [String:Int],
            r = colorDict["R"], g = colorDict["G"], b = colorDict["B"]
        {
            return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
        }
        else
        {
            assertionFailure("ColorFormatError")
            return UIColor.whiteColor()
        }
    }
    
    func titleForSelectedGroup() -> String
    {
        return self.titleForGroup(self.selectedGroupIndex)
    }
    
    func contentForGroup(groupIndex: Int) -> [[String:String]]
    {
        if groupIndex == 0
        {
            // favorite
            var content = [[String:String]]()
            for anIndex in self.favIndexData
            {
                if let group = anIndex["Group"], item = anIndex["Item"],
                    lyric = self.contentForGroup(group)[item]["Lyric"],
                    detail = self.contentForGroup(group)[item]["Detail"]
                {
                    content.append(["Lyric":lyric, "Detail":detail])
                }
                else
                {
                    assertionFailure("Lyrics.plist format error")
                }
            }
            return content
        }
        else if let content = self.dataArray[groupIndex]["Content"] as? [[String:String]]
        {
            return content
        }
        
        assertionFailure("Lyrics.plist format error")
        return []
    }
    
    func selectedGroupContent() -> [[String:String]]
    {
        return self.contentForGroup(self.selectedGroupIndex)
    }
    
    func lyric(indexInSelectedGroup: Int) -> String
    {
        if let lyric = self.selectedGroupContent()[indexInSelectedGroup]["Lyric"]
        {
            return lyric
        }
        
        assertionFailure("Lyrics.plist format error")
        return ""
    }
    
    func lyricDetail(indexInSelectedGroup: Int) -> String
    {
        if let lyricDetail = self.selectedGroupContent()[indexInSelectedGroup]["Detail"]
        {
            return lyricDetail
        }
        
        assertionFailure("Lyrics.plist format error")
        return ""
    }
    
    func isFav(indexInSelectedGroup: Int) -> Bool
    {
        if self.selectedGroupIndex == 0
        {
            return true
        }
        
        for anIndex in self.favIndexData
        {
            if let group = anIndex["Group"], item = anIndex["Item"]
            {
                if group == self.selectedGroupIndex && item == indexInSelectedGroup
                {
                    return true
                }
            }
            else
            {
                assertionFailure("Lyrics.plist favorite group format error")
            }
        }
        
        return false
    }
    
    func switchFavState(indexInSelectedGroup: Int)
    {
        if self.isFav(indexInSelectedGroup)
        {
            for (i, anIndex) in enumerate(self.favIndexData)
            {
                if let group = anIndex["Group"], item = anIndex["Item"]
                {
                    if group == self.selectedGroupIndex && item == indexInSelectedGroup
                    {
                        self.favIndexData.removeAtIndex(i)
                        self.saveFavData()
                        return
                    }
                }
                else
                {
                    assertionFailure("Lyrics.plist favorite group format error")
                }
            }
            
            assertionFailure("Fav inconsistent error")
        }
        else
        {
            self.favIndexData.append(["Group":self.selectedGroupIndex, "Item":indexInSelectedGroup])
            self.saveFavData()
        }
    }
}
