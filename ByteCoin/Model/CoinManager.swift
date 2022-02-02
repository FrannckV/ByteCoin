//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
}


struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "DDAD0CE3-454E-438E-980F-6EB25C6FD1AA"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String){
        
        let urlString = "\(baseURL)/\(currency)"
        performRequest(with: urlString)
        print(urlString)
        
    }
    
    func performRequest (with urlString: String) {
        /* 1. Create a URL
         if let url = URL(string: baseURL) {
         
         // 2. Create a URLSession
         let session = URLSession(configuration: .default)
         
         // 3. Give the session a task with a closure
         
         let task = session.dataTask(with: url) { data, response, error in
         if error != nil {
         delegate?.didFailWithError(error: error!)
         return
         }
         
         if let safeData = data {
         //var testString = "This is a test string"
         //var somedata = testString.data(using: String.Encoding.utf8)
         let backToString = String(data: safeData, encoding: String.Encoding.utf8) as String?
         print(backToString!)
         
         if let coin = parseJSON(safeData) {
         delegate?.didUpdateCoin(self, coin: coin)
         
         }
         }
         }
         
         // 4. Start the task
         task.resume()
         }*/
        if let url = URL(string: urlString) {
            
            print("url : \(apiKey)")
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            
            request.setValue("application/json", forHTTPHeaderField:"Content-Type")
            
            request.setValue(apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
            
            request.timeoutInterval = 20.0
            
            URLSession.shared.dataTask(with: request) {
                
                (data, response, error) in
                
                if let saveData = data{
                    
                    if let rate = parseJSON(saveData){
                        
                        delegate?.didUpdateCoin(self, coin: rate)
                        
                    }
                    
                }
                
            }.resume()
            
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            
            let coin = CoinModel(rate: rate)
            
            return coin
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
