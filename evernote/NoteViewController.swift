//
//  NoteViewController.swift
//  evernote
//
//  Created by 梁树元 on 10/31/15.
//  Copyright © 2015 com. All rights reserved.
//

import UIKit

public protocol NoteViewControllerDelegate:NSObjectProtocol {
    func didClickGoBack()
}

class NoteViewController: UIViewController {
    
    internal weak var delegate: NoteViewControllerDelegate?
    internal var domainColor:UIColor = UIColor()
    internal var titleName:String?
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        totalView.layer.masksToBounds = true
        totalView.layer.cornerRadius = 5.0
        totalView.backgroundColor = domainColor
        titleLabel.text = titleName
        textView.contentOffset = CGPoint(x: 0, y: 0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(NoteViewController.handleTapGesture(_:)))
        self.totalView.addGestureRecognizer(tap)
    }
    
    func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func goBack(_ sender: AnyObject) {
        delegate?.didClickGoBack()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
