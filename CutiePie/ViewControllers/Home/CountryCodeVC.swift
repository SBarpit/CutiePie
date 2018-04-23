//
//  CountryCodeVC.swift
//  Onboarding
//
//  Created by Appinventiv on 02/11/17.
//  Copyright © 2017 Gurdeep Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol SetContryCodeDelegate {
    func setCountryCode(country_info: JSONDictionary)
}

class CountryCodeVC: BaseVc {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var countryCodeTableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!

    
    var countryInfo = JSONDictionaryArray()
    var filteredCountryList = JSONDictionaryArray()
    var delegate:SetContryCodeDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false//isNavigationBarHidden = false
        self.navigationItem.title = StringConstants.Select_Country.localized
        self.navigationController?.navigationBar.isTranslucent = false

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = true//isNavigationBarHidden = false
    }
    
    private func initialSetup(){
    
        self.countryCodeTableView.delegate = self
        self.countryCodeTableView.dataSource = self
        self.searchBar.placeholder = StringConstants.Search_Country.localized
        self.readJson()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func readJson() {
        
        let file = Bundle.main.path(forResource: "countryData", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: file!))

        let jsonData = try? JSONSerialization.jsonObject(with: data!, options: []) as! JSONDictionaryArray
        
        self.countryInfo = jsonData!
        self.filteredCountryList = jsonData!
        self.countryCodeTableView.reloadData()

        
    }

    
    @IBAction func backbtnTap(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func searchEditingChanged(_ sender: UITextField) {
        
        let filter = self.countryInfo.filter({ ($0["CountryEnglishName"] as? String ?? "").localizedCaseInsensitiveContains(sender.text!)
        })
        self.filteredCountryList = filter
        
        if sender.text == ""{
            self.filteredCountryList = self.countryInfo
        }
        self.countryCodeTableView.reloadData()

    }
    
}


extension CountryCodeVC: UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell", for: indexPath) as! CountryCodeCell
        let info = self.filteredCountryList[indexPath.row]
        cell.populateView(info: info)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = self.filteredCountryList[indexPath.row]

        self.delegate.setCountryCode(country_info: info)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}

class CountryCodeCell: UITableViewCell {
    
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var countryCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func populateView(info: JSONDictionary){
        
        guard let code = info["CountryCode"] else{return}
        guard let name = info["CountryEnglishName"] as? String else{return}
        self.countryCode.text = "\(name)(+\(code))"
        guard let img = info["CountryFlag"] as? String else{return}
            self.countryFlag.image = UIImage(named: img)

    }
}
