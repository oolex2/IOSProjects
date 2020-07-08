import UIKit

final class Network {
    
    public var mainData: [MainData] = []
    
    private var database = Database()
    
    private enum DecodeType: String {
        
        case cities = "cities"
        
        case regions = "regions"
        
        case currencies = "currencies"

    }
    
    private func decodeKeys (typeOfDecode: DecodeType, data: Data, code: String) -> String {
        
        var result = ""
        
        do {
            
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : AnyObject]
            
            if let postFromJson = json[typeOfDecode.rawValue] as? [String : AnyObject] {
                
                for (key,value) in postFromJson {
                    
                    if key == code {
                        
                        if let value = value as? String {
                            
                            result = value
                        }
                    }
                }
            }
        } catch {
            
            print(error)
        }
        
        return result
    }
    
    public func fetchData(completionHandler: @escaping (_ mainScrenData: [MainData], _ errors: Error?, _ data: Data?) -> ()) {
        
        guard  let url = URL(string: "https://resources.finance.ua/ua/public/currency-cash.json") else { return }
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard let jsonData = data else { return completionHandler(self.mainData, nil, data) }
            do {
                
                let bank = try JSONDecoder().decode(Bank.self, from: jsonData)
                
                for i in 0...bank.organizations.count - 1 {
                    
                    let city = self.decodeKeys(typeOfDecode: .cities, data: jsonData, code: bank.organizations[i].cityID)
                    let region = self.decodeKeys(typeOfDecode: .regions, data: jsonData, code: bank.organizations[i].regionID)
                    
                    let data = MainData()
                    data.city = city
                    data.region = region
                    if let link = bank.organizations[i].link.components(separatedBy: "/cash").first {
                        
                        data.link = link
                    }
                    data.title = bank.organizations[i].title
                    data.addres = bank.organizations[i].address
                    data.phoneNumber = bank.organizations[i].phone
                    data.image = UIImage()
                    
                    for (key,value) in bank.organizations[i].currencies {
                      
                        let currency = Currenci()
                        currency.symbol = key
                        currency.title = self.decodeKeys(typeOfDecode: .currencies, data: jsonData, code: key)
                        currency.ask = value.ask
                        currency.bid = value.bid
                        data.currency.append(currency)
                    }

                    self.mainData.append(data)
                    
                    self.saveToDataBase(bank.organizations[i], city: city, region: region)
                }
                
                self.database.save()
                
                completionHandler(self.mainData, error, data)
                self.mainData = []
                
            } catch {
                
                print(error)
            }
            
        }.resume()
    }
    
    private func saveToDataBase(_ oraganization: Organization, city: String, region: String) {
        
        var phoneNumber = oraganization.phone
        
        if phoneNumber == nil {
            
            phoneNumber = ""
        }
        
        self.database.writeToDatabase(bankTitle: oraganization.title, bankCity: city, bankPhoneNumber: phoneNumber!, bankRegion: region, bankAdress: oraganization.address)
    }
    
    typealias downloadCompletionHandler = (_ result: UIImage, _ error: Error?) -> ()
    
    public func downloadImage(from url: String, completitionHandler: @escaping downloadCompletionHandler) {
        
        if let urlToDownload = URL(string: url) {
            
            let urlRequest = URLRequest(url: urlToDownload)
            
            let task = URLSession.shared.dataTask(with: urlRequest) {
                
                (data,response,error) in
                
                if let data = data {
                    
                    if let image = UIImage(data: data) {
                        
                        completitionHandler(image, error)
                        
                    } else {
                        
                        assertionFailure("Image doesn't exist")
                    }
                    
                } else {
                    
                    if let image = UIImage(named: "incorrectImage") {
                        
                        completitionHandler(image, error)
                    }
                }
            }
            task.resume()
            
        } else {
            
            assertionFailure("incorrectUrl")
        }
    }
}
