//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoinExchangeRate(coinExchangeRate: Double, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?

    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "DF2657E0-5357-4F42-97FC-BD3FBA4461EE"

    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]
    
    func fetchBTCRate(currency: String) {
        let requestUrl = "https://rest.coinapi.io/v1/exchangerate/BTC/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: requestUrl) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, _, error in
                
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        delegate?.didUpdateCoinExchangeRate(coinExchangeRate: bitcoinPrice, currency: currency)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    private func parseJSON(_ ExchangeData: Data) -> Double? {
        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode(ExchangeRate.self, from: ExchangeData)
            let rate = decodedData.rate
            return rate
            
        } catch {
            print(error)
            
            return nil
        }
    }
}
