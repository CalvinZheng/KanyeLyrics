//
//  KeyboardViewController.swift
//  keyboardExt
//
//  Created by Calvin Zheng on 2015-04-18.
//  Copyright (c) 2015 JordanK. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, LyricsTableControllerDelegate {

    var keyboardMainView: UIView!
    var lyricsTableController: LyricsTableController!

    @IBOutlet var lyricsTableView: UITableView!
    
    // MARK: - override
    
    override func updateViewConstraints()
    {
        super.updateViewConstraints()
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.lyricsTableController = LyricsTableController()
        self.lyricsTableController.delegate = self
        
        self.keyboardMainView = NSBundle.mainBundle().loadNibNamed("keyboardMainView", owner: self, options: nil)[0] as! UIView
        self.keyboardMainView.frame = self.view.bounds
        self.keyboardMainView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.view.addSubview(self.keyboardMainView)
        
        self.lyricsTableView.delegate = self.lyricsTableController
        self.lyricsTableView.dataSource = self.lyricsTableController
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    override func textWillChange(textInput: UITextInput)
    {
    }

    override func textDidChange(textInput: UITextInput)
    {
    }
    
    // MARK: - func
    
    func lyricClicked(lyric: String?)
    {
        UIDevice.currentDevice().playInputClick()
        self.textDocProxy().insertText(lyric!)
    }
    
    func textDocProxy() -> UITextDocumentProxy
    {
        return self.textDocumentProxy as! UITextDocumentProxy
    }
    
    // MARK: - actions
    
    @IBAction func deleteTapped(sender: UIButton)
    {
        self.textDocProxy().deleteBackward()
    }

    @IBAction func globeTapped(sender: UIButton)
    {
        self.advanceToNextInputMode()
    }
}
