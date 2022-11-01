//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Aldiyar Ikhsan on 12.10.2022.
//

import Foundation

protocol CoinDelegate{
    func ch(coinData:String,currency:String)
    func errir(Error:Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "?apikey=E86C2FED-1CF4-4D8C-AB69-108501ADF8D8"
    
    var delegate:CoinDelegate?
    
    let currencyArray = ["KZT", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice (for currency: String){
        let urlString = "\(baseURL)\(currency)\(apiKey)"
        requestURL(with: urlString,currency: currency)
    }
    
    func requestURL(with urlString:String,currency:String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task  = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.errir(Error: error!)
                }
            
                if let safedata = data{
                    if let coinDouble = pareseJson(coinData: safedata){
                        let coinDoubl2 = String(format: "%.2f", coinDouble)
                        self.delegate?.ch(coinData: coinDoubl2,currency:currency)
                        print(coinDoubl2)
                    }
                } 
            }
            task.resume()
        }
    }
    
    func pareseJson(coinData:Data)->Double?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            return rate
        }catch{
            self.delegate?.errir(Error: error)
            return nil
        }
    }
}

