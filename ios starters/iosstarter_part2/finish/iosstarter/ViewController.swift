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
    let emojis = ["👩‍💻","👨‍💻","😺","💪","📱","😍","💩"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    }
    
    
}

