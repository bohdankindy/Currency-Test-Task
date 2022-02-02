//
//  ViewController.swift
//  CurrencyTestTask
//
//  Created by Bohdan Kindy on 19.10.2021.
//

import UIKit

// MARK: Constants

enum Constants {
    
    static let privateBankReuseIdentifier = "privateBankReuseIdentifier"
    static let nbuReuseIdentifier = "nbuforReuseIdentifier"
    static let privateBankCellNib = "PrivateBankItemCell"
    static let nbuCellNib = "NBUItemCell"
    static let pburlStr = "https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5"
    static let nbuStr: String = { () -> String in
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?date=" + dateFormatter.string(from: date) + "&json"
    }()
    
}

// MARK: KEYS

private enum PrivateBankKeys {
    
    static let ccy = "ccy"
    static let buy = "buy"
    static let sale = "sale"
}

private enum NBUKeys {
    
    static let txt = "txt"
    static let rate = "rate"
    static let cc = "cc"
    static let exchangedate = "exchangedate"
}

// MARK: - DataProviderDelegate

protocol DataProviderDelegate: AnyObject {
    
    var privateBankModel: [PrivateBankCellType] { get }
    var nbuModel: [NBUCellType] { get }
    
    func didSelectPrivateBankCell(for indexPath: IndexPath)
    func didSelectNBUCell(for indexPath: IndexPath)
}

// MARK: - Class implementation

class CurrenciesViewController: UIViewController, DataProviderDelegate {
    
    // MARK: Properties
        
    var privateBankDataProvider: CurrencyTableViewDataProvider?
    var nbuDataProvider: CurrencyTableViewDataProvider?
    
    var privateBankModel: [PrivateBankCellType] = []
    var nbuModel: [NBUCellType] = []
    
    // MARK: Outlets
    
    @IBOutlet weak var privateBankCurrencyTableView: UITableView!
    @IBOutlet weak var nbuCurrencyTableView: UITableView!
    @IBOutlet weak var privateBankLabel: UILabel!
    @IBOutlet weak var nbuLabel: UILabel!
    @IBOutlet weak var pbDate: UIButton!
    @IBOutlet weak var nbuDate: UIButton!
    
    
    // MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableViews()
        setupDataProviders()
        setupModels()
        setupDates()
        setupNavigationBar()
    }
}

// MARK: - Private

private extension CurrenciesViewController {
    
    func loadPBData() {
        
        self.privateBankModel.append(.header(leftText: "Валюта", middleText: "Покупка", rightText: "Продажа"))

        guard let url = URL(string: Constants.pburlStr) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, responce, error) in
            guard let data = data,
                  let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return }
            
            jsonArray.forEach { json in
                guard let ccy = json[PrivateBankKeys.ccy] as? String,
                      let buy = json[PrivateBankKeys.buy] as? String,
                      let sale = json[PrivateBankKeys.sale] as? String else { return }
                
                self.privateBankModel.append(.currency(currency: Currency.safeCurrency(rawValue: ccy), leftText: ccy, middleText: buy, rightText: sale))
            }

            DispatchQueue.main.async {
                self.privateBankCurrencyTableView.reloadData()
            }
        }
        task.resume()
    }
    
    func loadNBUData() {
        
        guard let url = URL(string: Constants.nbuStr) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            
            guard let data = data,
                  let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return }
            
            jsonArray.forEach { json in
                guard let txt = json[NBUKeys.txt] as? String,
                      let rate = json[NBUKeys.rate] as? Double,
                      let cc = json[NBUKeys.cc] as? String else { return }
                
                self.nbuModel.append(.currency(currency: Currency.safeCurrency(rawValue: cc), leftText: txt, rightTopText: "\(rate)" + "UAH", rightBottomText: "1\(cc)"))
            }
            DispatchQueue.main.async {
                self.nbuCurrencyTableView.reloadData()
            }
        }
        task.resume()
    }
    
    func setupDataProviders() {
        
        privateBankDataProvider = PrivateBankDataProvider()
        privateBankDataProvider?.delegate = self
        privateBankCurrencyTableView.delegate = privateBankDataProvider
        privateBankCurrencyTableView.dataSource = privateBankDataProvider
        
        nbuDataProvider =  NBUDataProvider()
        nbuDataProvider?.delegate = self
        nbuCurrencyTableView.delegate = nbuDataProvider
        nbuCurrencyTableView.dataSource = nbuDataProvider
    }
    
    func setupModels() {
        loadPBData()
        loadNBUData()
    }
    
    func setupTableViews() {
        
        let privateBankNib = UINib(nibName: Constants.privateBankCellNib, bundle: nil)
        let nbuNib = UINib(nibName: Constants.nbuCellNib, bundle: nil)
        
        privateBankCurrencyTableView.register(privateBankNib, forCellReuseIdentifier: Constants.privateBankReuseIdentifier)
        nbuCurrencyTableView.register(nbuNib, forCellReuseIdentifier: Constants.nbuReuseIdentifier)
        
        privateBankCurrencyTableView.separatorStyle = .none
        nbuCurrencyTableView.separatorStyle = .none
        
        privateBankCurrencyTableView.showsVerticalScrollIndicator = false
        nbuCurrencyTableView.showsVerticalScrollIndicator = false
    }
    
    func setupPBDate() {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        pbDate.setTitle(dateFormatter.string(from: date), for: .normal)
        pbDate.setTitleColor(.black, for: .normal)
    }
    
    func setupNBUDate() {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        nbuDate.setTitle(dateFormatter.string(from: date), for: .normal)
        nbuDate.setTitleColor(.black, for: .normal)
    }
    
    func setupDates() {
        setupPBDate()
        setupNBUDate()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(named: "darkGreen")
    }
}

// MARK: - Internal

internal extension CurrenciesViewController {
    
    func didSelectPrivateBankCell(for indexPath: IndexPath) {
        
        let cellType = privateBankModel[indexPath.row]
        
        switch cellType {
        case let .currency(pbCurrency, _, _, _):
            
            if let nbuIndex = nbuModel.firstIndex(where: { nbuCellType -> Bool in
                switch nbuCellType {
                case let .currency(nbuCurrency, _, _, _):
                    return nbuCurrency == pbCurrency
                }
            }) {
                let nbuIndexPath = IndexPath(row: nbuIndex, section: 0)
                nbuCurrencyTableView.selectRow(at: nbuIndexPath, animated: true, scrollPosition: .top)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.nbuCurrencyTableView.deselectRow(at: nbuIndexPath, animated: true)
                }
            }
        default:
            break
        }
    }
    
    func didSelectNBUCell(for indexPath: IndexPath) {
        
        let cellType = nbuModel[indexPath.row]

        switch cellType {
        case let .currency(nbuCurrency, _, _, _):

            if let privateBankIndex = privateBankModel.firstIndex(where: { privateBankCellType in
                switch privateBankCellType {
                case let .currency(pbCurrency, _, _, _):
                    return pbCurrency == nbuCurrency
                case .header:
                    return false
                }
            }) {
                let pbIndexPath = IndexPath(row: privateBankIndex, section: 0)
                privateBankCurrencyTableView.selectRow(at: pbIndexPath, animated: true, scrollPosition: .top)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.privateBankCurrencyTableView.deselectRow(at: pbIndexPath, animated: true)
                }
            }
        }
    }
}
