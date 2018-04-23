//
//  WalkThroughVC.swift
//  WalkthroughDemo
//
//  Created by Appinventiv on 26/10/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class WalkThroughVC: BaseVc {

    //MARK:- PROPERTIES
    //=================
    let tutorialImages : [UIImage] = [#imageLiteral(resourceName: "ic_tutorial screen_01"),#imageLiteral(resourceName: "ic_tutorial screen_02"),#imageLiteral(resourceName: "ic_tutorial screen_03"),#imageLiteral(resourceName: "ic_tutorial screen_04")]

   
    //MARK:- IBOUTLET
    //=================
    @IBOutlet weak var tutorialCollectionView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUserDefaults.save(value: "Yes", forKey: .tutorialDisplayed)
    }

    private func initialSetup() {
        
        self.tutorialCollectionView.delegate = self
        self.tutorialCollectionView.dataSource = self
        self.pageControl.numberOfPages = self.tutorialImages.count
    }
    
    fileprivate func navigateToNextScreen() {
        
        //Navigate to next screen
        print("next button tapped at last index")
        
        CommonClass().gotoHome()
    }
}

//MARK:- IBACTION
//===============
extension WalkThroughVC {
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        if self.pageControl.currentPage == self.tutorialImages.count - 1 {
            self.navigateToNextScreen()
        }else{
            self.tutorialCollectionView.scrollToItem(at: IndexPath(item: self.pageControl.currentPage + 1, section: 0), at: .centeredHorizontally, animated: true)
            self.pageControl.currentPage += 1
        }
        
    }
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        self.navigateToNextScreen()
    }
}

//MARK:- COLLECTION VIEW DATASOURCE
//=================================
extension WalkThroughVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tutorialImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionCell", for: indexPath) as? TutorialCollectionCell else {
            
            fatalError("TutorialCollectionCell not found")
        }
        cell.populate(withImage: self.tutorialImages[indexPath.item])
        return cell
    }
}

//MARK:- COLLECTION VIEW FLOWLAYOUT DELEGATE
//==========================================
extension WalkThroughVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.frame.size
    }
}


//MARK:- COLLECTION VIEW DELEGATE
//===============================
extension WalkThroughVC : UICollectionViewDelegate {
    
}

//MARK:- SCROLL VIEW DELEGATE
//===========================
extension WalkThroughVC {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset
        let page = offset.x / self.view.bounds.width
        self.manageScroll(forPage: Int(page))
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offset = scrollView.contentOffset
        let page = offset.x / self.view.bounds.width
        self.manageScroll(forPage: Int(page))
        
    }
    
    func manageScroll(forPage page : Int) {
        
        self.pageControl.currentPage = page
    }
}


//MARK:- CELL CLASS
//=================
class TutorialCollectionCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
    }
    
    func populate(withImage image : UIImage) {
        
        self.imageView.image = image
    }
}
