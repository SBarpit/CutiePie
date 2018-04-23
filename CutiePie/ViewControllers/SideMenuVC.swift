//
//  SideMenuVC.swift
//  Onboarding
//
//  Created by Appinventiv on 30/10/17.
//  Copyright © 2017 Gurdeep Singh. All rights reserved.
//

import UIKit

class SideMenuVC: BaseVc {

    static var selectedSideMenuIndex = 1
    
    let menuOptions : [String] = ["Home"]
    
    let menuOptionsImages : [UIImage] = [#imageLiteral(resourceName: "icSidemenuEnableHome")]
    
    let menuOptionsImagesSelected : [UIImage] = [#imageLiteral(resourceName: "icSidemenuDisableHome")]

    @IBOutlet weak var sideMenuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialSetup()
    }


    private func initialSetup() {
        
        self.view.backgroundColor = .clear
        self.sideMenuTableView.layer.borderColor = UIColor.gray.cgColor;
        self.sideMenuTableView.layer.borderWidth = 0.5;
        
        self.sideMenuTableView.layer.contentsScale = UIScreen.main.scale;
        self.sideMenuTableView.layer.shadowColor = UIColor.black.cgColor;
        self.sideMenuTableView.layer.shadowOffset = CGSize.zero;
        self.sideMenuTableView.layer.shadowRadius = 5.0;
        self.sideMenuTableView.layer.shadowOpacity = 0.5;

        
    }
}


extension SideMenuVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.menuOptions.count+1

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch  indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserImageNameCellID") as? UserImageNameCell else{
                fatalError("UserImageNameCell not found")
            }

            
            let value = AppUserDefaults.value(forKey: .userData)

            let user = User(json: value)
            
            cell.userEmail.text = user.email
            cell.userName.text = user.first_name
            cell.userImage.imageFromURl(user.imageUrl)
            
            return cell
        case 1...self.menuOptions.count:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuOptionCellID") as? SideMenuOptionCell else{
                fatalError("SideMenuOptionCell not found")
            }
                cell.sideOption.text = self.menuOptions[indexPath.row-1]
                if SideMenuVC.selectedSideMenuIndex == indexPath.row {
                    cell.iconImage.image = self.menuOptionsImagesSelected[indexPath.row-1]
                    cell.backgroundColor = AppColors.themeBlueColor
                    cell.sideOption.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }else{
                    cell.iconImage.image = self.menuOptionsImages[indexPath.row-1]
                    cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    cell.sideOption.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
                
            return cell
        default:
            fatalError("Wrong index")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 140
        default:
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        closeLeft()
        
        if (SideMenuVC.selectedSideMenuIndex != (indexPath.row)) {
            SideMenuVC.selectedSideMenuIndex = indexPath.row
            
                switch indexPath.row {
                    
                case 1:
                    CommonClass().gotoUserDetails()
                default: break
                    
                }
            }
        
    }
    
}



class UserImageNameCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.userImage.layer.cornerRadius = self.userImage.frame.width/2
        self.userImage.layer.masksToBounds = true

    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

class SideMenuOptionCell : UITableViewCell{
    
    @IBOutlet weak var sideOption: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
