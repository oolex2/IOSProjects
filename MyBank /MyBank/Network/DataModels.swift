import UIKit

// MARK: - MainData

final class MainData {
    
    var city: String?
    var region: String?
    var title: String?
    var addres: String?
    var phoneNumber: String?
    var image: UIImage?
    var link: String?
    var currency: [Currenci] = []
}

final class Currenci {
    
    var symbol: String?
    var title: String?
    var ask: String?
    var bid: String?
}

// MARK: - Bank
struct Bank: Codable {

    let organizations: [Organization]
    let currencies: Currencies

    enum CodingKeys: String, CodingKey {
        
        case organizations, currencies
    }
}

// MARK: - Currencies
struct Currencies: Codable {
    
    let aed, amd, aud, azn: String
    let bgn, brl, byn, cad: String
    let chf, clp, cny, czk: String
    let dkk, dzd, egp, eur: String
    let gbp, gel, hkd, hrk: String
    let huf, ils, inr, iqd: String
    let jpy, krw, kwd, kzt: String
    let lbp, mdl, mxn, nok: String
    let nzd, pln, ron, rub: String
    let sar, sek, sgd, thb: String
    let currenciesTRY, usd: String
    let vnd: String

    enum CodingKeys: String, CodingKey {
        case aed = "AED"
        case amd = "AMD"
        case aud = "AUD"
        case azn = "AZN"
        case bgn = "BGN"
        case brl = "BRL"
        case byn = "BYN"
        case cad = "CAD"
        case chf = "CHF"
        case clp = "CLP"
        case cny = "CNY"
        case czk = "CZK"
        case dkk = "DKK"
        case dzd = "DZD"
        case egp = "EGP"
        case eur = "EUR"
        case gbp = "GBP"
        case gel = "GEL"
        case hkd = "HKD"
        case hrk = "HRK"
        case huf = "HUF"
        case ils = "ILS"
        case inr = "INR"
        case iqd = "IQD"
        case jpy = "JPY"
        case krw = "KRW"
        case kwd = "KWD"
        case kzt = "KZT"
        case lbp = "LBP"
        case mdl = "MDL"
        case mxn = "MXN"
        case nok = "NOK"
        case nzd = "NZD"
        case pln = "PLN"
        case ron = "RON"
        case rub = "RUB"
        case sar = "SAR"
        case sek = "SEK"
        case sgd = "SGD"
        case thb = "THB"
        case currenciesTRY = "TRY"
        case usd = "USD"
        case vnd = "VND"
    }
}

// MARK: - Organization
struct Organization: Codable {
    
    let id: String
    let oldID, orgType: Int
    let branch: Bool
    let title, regionID, cityID: String
    let phone: String?
    let address: String
    let link: String
    let currencies: [String: Currency]

    enum CodingKeys: String, CodingKey {
        case id
        case oldID = "oldId"
        case orgType, branch, title
        case regionID = "regionId"
        case cityID = "cityId"
        case phone, address, link, currencies
    }
}

// MARK: - Currency
struct Currency: Codable {
    
    let ask, bid: String
}

