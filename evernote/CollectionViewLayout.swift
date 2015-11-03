//
//  CollectionViewLayout.swift
//  evernote
//
//  Created by 梁树元 on 10/30/15.
//  Copyright © 2015 com. All rights reserved.
//

import UIKit

public let horizonallyPadding:CGFloat = 10
public let verticallyPadding:CGFloat = 10

public let screenWidth = UIScreen.mainScreen().bounds.size.width
public let screenHeight = UIScreen.mainScreen().bounds.size.height

public let cellWidth = screenWidth - 2 * horizonallyPadding
private let cellHeight:CGFloat = 45

private let SpringFactor:CGFloat = 10.0

class CollectionViewLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        itemSize = CGSizeMake(cellWidth, cellHeight)
        headerReferenceSize = CGSizeMake(screenWidth, verticallyPadding)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        itemSize = CGSizeMake(cellWidth, cellHeight)
        headerReferenceSize = CGSizeMake(screenWidth, verticallyPadding)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let offsetY = self.collectionView!.contentOffset.y
        let attrsArray = super.layoutAttributesForElementsInRect(rect)
        let collectionViewFrameHeight = self.collectionView!.frame.size.height;
        let collectionViewContentHeight = self.collectionView!.contentSize.height;
        let ScrollViewContentInsetBottom = self.collectionView!.contentInset.bottom;
        let bottomOffset = offsetY + collectionViewFrameHeight - collectionViewContentHeight - ScrollViewContentInsetBottom
        let numOfItems = self.collectionView!.numberOfSections()
        
        for attr:UICollectionViewLayoutAttributes in attrsArray! {
            if (attr.representedElementCategory == UICollectionElementCategory.Cell) {
                var cellRect = attr.frame;
                if offsetY <= 0 {
                    let distance = fabs(offsetY) / SpringFactor;
                    cellRect.origin.y += offsetY + distance * CGFloat(attr.indexPath.section + 1);
                }else if bottomOffset > 0 {
                    let distance = bottomOffset / SpringFactor;
                    cellRect.origin.y += bottomOffset - distance *
                        CGFloat(numOfItems - attr.indexPath.section)
                }
                attr.frame = cellRect;
            }
        }
        return attrsArray;
    }
}
