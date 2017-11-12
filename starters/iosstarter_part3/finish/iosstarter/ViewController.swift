//
//  ViewController.swift
//  iosstarter
//
//  Created by Manu Rink on 10.11.17.
//  Copyright © 2017 byteroyal. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var counterLabel: UILabel!
    let emojis = ["👩‍💻","👨‍💻","😺","💪","📱","😍","💩"]
    var counter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.text = "\(counter)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createTapped(_ sender: Any) {
        let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: emojis.count)
        let randomEmoji = emojis[randomNumber]
        let text = "Wow, you pressed a button and then suddenly \(randomEmoji) happended \n"
        textView.insertText(text)
        textView.scrollRangeToVisible(NSMakeRange(textView.text.count-1, 0))
        counter += 1
        counterLabel.text = "\(counter)"
    }
    
    @IBAction func clearTapped(_ sender: Any) {
        textView.text = ""
        counter = 0
        counterLabel.text = "\(counter)"
    }
    
    
    
}

