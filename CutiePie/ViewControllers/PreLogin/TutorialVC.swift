//
//  TutorialVC.swift
//  Cutiepie
//
//  Created by Arpit Srivastava on 17/04/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit

class TutorialVC: UIViewController {
    
    // MARK:- VARIABLES
    //====================
    var colorsArray = [#colorLiteral(red: 0.3360654116, green: 0.7479227185, blue: 0.8092854619, alpha: 1),#colorLiteral(red: 0.9699628949, green: 0.4208073616, blue: 0.5002488494, alpha: 1),#colorLiteral(red: 0.496411562, green: 0.8107064366, blue: 0.6023204923, alpha: 1)]
    var currentPage:Int = 0
    var timer:Timer!
    
    // MARK:- IBOUTLETS
    //====================
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var headingDescpLabel: UILabel!
    @IBOutlet weak var tutorialCollectionView: UICollectionView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK:- IBACTIONS
    //====================
    @IBAction func nextPageButton(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomePageVC") as? WelcomePageVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
}

// MARK:- LIFE CYCLE
//====================
extension TutorialVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        self.registerCells()
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
}

// MARK:- COLLECTION VIEW DELEGATE AND DATASOURCE
//==============================================
extension TutorialVC :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = tutorialCollectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCell", for: indexPath) as? TutorialCell else { return UICollectionViewCell()}
        //        cell.cellImageView.image = UIImage(named: "1")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.tutorialCollectionView.frame.width - 10
        let height = self.tutorialCollectionView.frame.height - 20
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10,right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.3) {
            self.headingLabel.alpha = 1
            self.headingDescpLabel.alpha = 1
            switch self.currentPage {
            case 0:
                self.headingLabel.text = "SELECT PRODUCT"
                self.headingDescpLabel.text = "As you can see in the first picture, the background is a light color, somewhat resembling the image's background. As I scroll halfway to the 2nd picture, the background turns darker."
            case 1:
                self.headingLabel.text = "CUSTOMISE PRODUCT"
                self.headingDescpLabel.text = "I wanted to check-in to see how you're doing on the trial. If you run into any roadblocks or have any questions about features, how-to's, best practices etc., please don't hesitate to reach out.  Just hit reply! "
            default:
                self.headingLabel.text = "BUY PRODUCT"
                self.headingDescpLabel.text = "I wanted to check-in to see how you're doing on the trial. As you can see in the first picture, the background is a light color, somewhat resembling the image's background.  "
            }
        }
        
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.3) {
            self.headingDescpLabel.alpha = 0.3
            self.headingLabel.alpha = 0.3
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageWidth: CGFloat = tutorialCollectionView.bounds.size.width
        let currentPage: Int = Int( floor( (tutorialCollectionView.contentOffset.x - pageWidth / 3) / (pageWidth)) + 1)
        self.currentPage = currentPage
        self.pageControll.currentPage = currentPage
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.size.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        
        if percentageHorizontalOffset < 0.5
        {
            self.view.backgroundColor = fadeFromColor(fromColor: colorsArray[0], toColor: colorsArray[1], withPercentage: (percentageHorizontalOffset*2))
        }
        else
        {
            self.view.backgroundColor = fadeFromColor(fromColor: colorsArray[1], toColor: colorsArray[2], withPercentage: (percentageHorizontalOffset - 0.5) * 2)
        }
        
    }
    
}

// MARK:- FUNCTIONS
//====================
extension TutorialVC {
    
    /// Invite Page Content Initial Setup
    private func initialSetup() {
        self.pageControll.currentPage = 0
        self.pageControll.numberOfPages = 3
        self.nextButton.roundCorners()
        self.nextButton.layer.shadowRadius = 1
        self.nextButton.clipsToBounds = true
        self.tutorialCollectionView.delegate = self
        self.tutorialCollectionView.dataSource = self
        navigationController?.hidesBarsOnTap = true
        
    }
    
    
    /// This method will calculate the RGBs
    private func fadeFromColor(fromColor: UIColor, toColor: UIColor, withPercentage: CGFloat) -> UIColor
    {
        var fromRed: CGFloat = 0.0
        var fromGreen: CGFloat = 0.0
        var fromBlue: CGFloat = 0.0
        var fromAlpha: CGFloat = 0.0
        
        // Get the RGBA values from the colours
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0.0
        var toGreen: CGFloat = 0.0
        var toBlue: CGFloat = 0.0
        var toAlpha: CGFloat = 0.0
        
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        // Calculate the actual RGBA values of the fade colour
        let red = (toRed - fromRed) * withPercentage + fromRed;
        let green = (toGreen - fromGreen) * withPercentage + fromGreen;
        let blue = (toBlue - fromBlue) * withPercentage + fromBlue;
        let alpha = (toAlpha - fromAlpha) * withPercentage + fromAlpha;
        
        // Return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    private func registerCells(){
        let nib = UINib(nibName: "TutorialCell", bundle: nil)
        tutorialCollectionView.register(nib, forCellWithReuseIdentifier: "TutorialCell")
        
    }
    
    private func setUpStatusBar(){
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor.white
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
    }
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        if let coll  = tutorialCollectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)!  < colorsArray.count - 1){
                    self.blurringEffect((indexPath?.row)!)
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
    
    private func blurringEffect(_ currentPage:Int){
        
        UIView.animate(withDuration:0.2) {
            self.headingLabel.alpha = 1
            self.headingDescpLabel.alpha = 1
        }
        switch currentPage {
        case 0:
            self.headingLabel.text = "SELECT PRODUCT"
            self.headingDescpLabel.text = "As you can see in the first picture, the background is a light color, somewhat resembling the image's background. As I scroll halfway to the 2nd picture, the background turns darker."
        case 1:
            self.headingLabel.text = "CUSTOMISE PRODUCT"
            self.headingDescpLabel.text = "I wanted to check-in to see how you're doing on the trial. If you run into any roadblocks or have any questions about features, how-to's, best practices etc., please don't hesitate to reach out.  Just hit reply! "
        default:
            self.headingLabel.text = "BUY PRODUCT"
            self.headingDescpLabel.text = "I wanted to check-in to see how you're doing on the trial. As you can see in the first picture, the background is a light color, somewhat resembling the image's background.  "
        }
    }
}

