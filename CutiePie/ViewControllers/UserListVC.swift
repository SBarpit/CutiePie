//
//  UserListVC.swift
//  Onboarding
//
//  Created by Appinventiv on 08/12/17.
//  Copyright © 2017 Gurdeep Singh. All rights reserved.
//

import UIKit
import Windless

class UserListVC: BaseVc {

    @IBOutlet weak var userTableView: UITableView!
    
    var userList : [FriendsModel] = [FriendsModel]()
    
    fileprivate var pageNo = 1
    var noData : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = true

    }
    
    private func initialSetup(){
        
        self.userTableView.delegate = self
        self.userTableView.dataSource = self
        
        self.userTableView.windless.start()
        
        self.getUsers()
    }
    
    func getUsers(){
        
        let param : [String : Any] = ["page":self.pageNo,
                                      "req_type" : 3,
                                      "accesstoken":AppUserDefaults.value(forKey: .Accesstoken).stringValue]
        
        WebServices.getUserList(parameters: param, success: { (data) in
            
            let error_code = data["CODE"].stringValue
            
            if "\(error_code)" == "200" {
                
                let array : [FriendsModel] = data["RESULT"].arrayValue.map({ (json) -> FriendsModel in
                    return FriendsModel(withJSON: json)
                })
                self.userList.append(contentsOf: array)
                
                self.pageNo = data["NEXT_PAGE"].intValue
                
            }
        
            self.userTableView.windless.end()
            self.noData = false
            self.userTableView.reloadData()

            
        }) { (e) in
            self.noData = false
            self.userTableView.windless.end()
            self.userTableView.reloadData()

        }
        
    }
}

//MARK:- TableView DataSource
//===========================

extension UserListVC : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.noData {
            return 15
        }else{
            return self.userList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableCell", for: indexPath) as? UserTableCell else{
            fatalError(("UserTableCell not found at line: \(#line) in function: \(#function) in file: \(#file)"))
        }
        
        if !self.noData {
            cell.populateData(withUser: self.userList[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}


//MARK:- TableView Delegate
//=========================
extension UserListVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if self.pageNo != 0 && (self.userList.count - 1 == indexPath.row) {
            
            self.getUsers()
            
        }
    }
}

class UserTableCell : UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func populateData(withUser user : FriendsModel) {
        
        self.nameLabel.text = user.name
        
    }
}



