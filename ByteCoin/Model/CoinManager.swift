//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//  Completed By Abhang Mane @Goldmedal


import Foundation

//protocol for the delegate
protocol CoinManagerDelegate{
    func lastPrice(lastPrice:String,currency:String)
    
    func didFailError(error:Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "9FA5FEB8-A912-4E45-8C9A-31370EFD6518"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate:CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        
        //1.Create URL string
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
 
        if let url = URL(string: urlString) {
            
            //2.Create URL session
            let session = URLSession(configuration: .default)
            
            //1.Create task for the urlsession
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    self.delegate?.didFailError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.lastPrice(lastPrice: priceString, currency: currency)
                    }
                }
            }
            //4.resume the task
            task.resume()
        }
        
    }
    
    //parse the json in double format for rate of coin if error occurs handle with delegate
    func parseJSON(_ data:Data)-> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            return lastPrice
            
        } catch {
            delegate?.didFailError(error: error)
            return nil
        }
    }
}
