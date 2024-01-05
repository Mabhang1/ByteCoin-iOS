//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
}


//MARK: - UIPickerViewDataSource,Delegate
extension ViewController:UIPickerViewDataSource,UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    //displaying the row array
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int){
        let currencySelected = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: currencySelected)
    }
    
    //number of pickers to display
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
}


//MARK: - CoinManagerDelegate

//recieve lastprice and currency data dynamically
extension ViewController:CoinManagerDelegate{
    func lastPrice(lastPrice: String, currency: String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = lastPrice
            self.currencyLabel.text = currency
        }
    }
    //handle possible errors
    func didFailError(error: Error) {
        print(error)
    }
}
