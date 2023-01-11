//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var bitCoinLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var currencyPicker: UIPickerView!

    var coinManager = CoinManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}

// MARK: - currencyPickerDatasource

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
}

// MARK: - currencyPickerDelegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.fetchBTCRate(currency: selectedCurrency)
    }
}

// MARK: - coinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdateCoinExchangeRate(coinExchangeRate: Double, currency: String) {
        let coinPriceString = String(format: "%.2f", coinExchangeRate)

        DispatchQueue.main.async {
            self.bitCoinLabel.text = coinPriceString
            self.currencyLabel.text = currency
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}
