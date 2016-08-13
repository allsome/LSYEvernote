//
//  CollectionViewController.swift
//  evernote
//
//  Created by 梁树元 on 10/12/15.
//  Copyright © 2015 com. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let topPadding:CGFloat = 20
public let BGColor = UIColor(red: 56.0/255.0, green: 51/255.0, blue: 76/255.0, alpha: 1.0)

class CollectionViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let colorArray = NSMutableArray()
    private let rowNumber = 15
    private let customTransition = EvernoteTransition()
    private let collectionView = UICollectionView(frame: CGRect(x: 0, y: topPadding, width: screenWidth, height: screenHeight - topPadding), collectionViewLayout: CollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BGColor
        collectionView.backgroundColor = BGColor
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = false
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, verticallyPadding, 0);

        self.view.addSubview(collectionView)
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        let random = arc4random() % 360 // 160 arc4random() % 360
        for index in 0 ..< rowNumber {
            let color = UIColor(hue: CGFloat((Int(random) + index * 6)).truncatingRemainder(dividingBy: 360.0) / 360.0, saturation: 0.8, brightness: 1.0, alpha: 1.0)
            colorArray.add(color)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return colorArray.count
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.backgroundColor = colorArray.object(at: colorArray.count - 1 - (indexPath as NSIndexPath).section) as? UIColor
        cell.titleLabel.text = "Notebook + " + String((indexPath as NSIndexPath).section + 1)
        cell.titleLine.alpha = 0.0
        cell.textView.alpha = 0.0
        cell.backButton.alpha = 0.0
        cell.tag = (indexPath as NSIndexPath).section
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        let visibleCells = collectionView.visibleCells as! [CollectionViewCell]
        let storyBoard = UIStoryboard(name: "evernote", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "Note") as! NoteViewController
        viewController.titleName = cell.titleLabel.text!
        viewController.domainColor = cell.backgroundColor!

        let finalFrame = CGRect(x: 10, y: collectionView.contentOffset.y + 10, width: screenWidth - 20, height: screenHeight - 40)
        self.customTransition.EvernoteTransitionWith(selectCell: cell, visibleCells: visibleCells, originFrame: cell.frame, finalFrame: finalFrame, panViewController:viewController, listViewController: self)
        viewController.transitioningDelegate = self.customTransition
        viewController.delegate = self.customTransition
        self.present(viewController, animated: true) { () -> Void in
        }
    }

}
