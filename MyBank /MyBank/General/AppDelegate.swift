import UIKit

// всі коментарі будуть тут
// *** - зірочками позначені рекомендовані вправи

/*

 TO improve:

1 - код який показує tutorial - він однаковий - треба винести в якийсь клас і перевикористати
2 - UI - зазвичай constraints constant не мають дробової частини - у вас де-не де є- 10,3 і тп - Навіть якшо так намальовано в дизайні - краще округлювати (потім буде легше робити з ними і робити певні розрахунки)
3 - UI - всі кольори малюнки тексти шрифти - краще вказувати в коді - тоді ваш Інтерфейс буде відповідати лише за "кістяк" UI - а налаштування його відображення буде явно зроблено в коді
      *** - Додайте локалізацію
      *** - Додайте тему (наприклад зелену і червону)
4 - Share зробіть в коді
5 - UI - враховуйте SAfeArea
6 - групуйте обєкти в інтерфейс білдері (MainSceneCell - там не погруповано і констрейнти не добре розставлені)
7 - Робіть cell в xib - тобі легко буде перевикористати їх в інших контролерах
      *** - додайте екран з вибраними банками де використовуються такі ж cells (ну і логіку як додати у вибране)
8 - Всі strings в коді - мають бути константами
  TutorialScene - String(describing: TutorialScene.self)
  MainSceneNavigation - String(describing: MainSceneNavigation.self)

  UserDefaults.standard.bool(forKey: "TutorialShown") -> use propertyWrapper

       @propertyWrapper
       public struct UserDefaultValue<T> {

       private let key: String
       private let defaultValue: T

       public init(_ key: String, defaultValue: T) {
       self.key = key
       self.defaultValue = defaultValue
       }

       public var wrappedValue: T {
       get {
       return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
       }
       set {
       UserDefaults.standard.set(newValue, forKey: key)
       }
       }
       }

  usage:

   struct Some {

    @UserDefaultValue("TutorialShown", defauktValue: false)
    static var myValue: Bool
   }

  UIStoryboard(name: "Main", bundle: nil) -> Use extension

  extension UIStoryboard {

   enum MyApp {

      static let main = "Main"
   }
 }

 usage = UIStoryboard.MyApp.main -> UIStoryboard(name: UIStoryboard.MyApp.main, bundle: nil)
 or similar solution

9 - assets - можна використовувати pdf - менше місця і кращя якість
10 - клас контейнер for example - Database - у вас методи і функції які не залежать від об'єкту Database (instance) - можливо варто зробити static і private init
11 - hardcode - його не має бути
 if fetchedObjects.count > 29 {

 index = fetchedObjects.count - 28

 а якшо є то має бути зроблено так щоб всі розуміли  чому саме так

 example:

 let maxObjectCount = 29
 if fetchedObjects.count > maxObjectCount {

 12 - помилки маюьб бути оброблені або прокинені далі

 } catch {

 print("Error in fetching with fetched result controller - \(error)")
 }

 це не орбробка помилки

 13 - кожній модельці - свій файл - як ви знайдете швидко об'єкт якшо вони всі в одному файлі
 14 - Network містить Database

 Network {

 public var mainData: [MainData] = []

 private var database = Database()


 це недобре - ви плутаєте відповідальність - натомість подумайте чи не логічніше надати тому кому треба Network лиш Network а тому кому треба CoreData  - CoreData - інакше ваші об'єкти стають GOD object - все знають і все вміють

 15 - виділяйте код в reuse components

 let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : AnyObject]

 if let postFromJson = json[typeOfDecode.rawValue] as? [String : AnyObject] {

 це точно можна було в Ext засунути

 16 - forceUnwrap - "s) as! [St"
 let location = view.annotation as! LocationAnnotation

 17 - робіть іменовані tuples

  (_ mainScrenData: [MainData], _ errors: Error?, _ data: Data?) -> ())

 -->

 typeallias Response = (_ mainScrenData: [MainData], _ errors: Error?, _ data: Data?) -> ())

 18 - використовуйте Generics
19 - повторюся - функція має виконувати 1 функцію і не мати 100 рядків - орієнтуйтеся на 40-60
 20 - продумуйте добре і тестуйте flow

 функція завантаження малюнка

 public func downloadImage(from url: String, completitionHandler: @escaping downloadCompletionHandler) {
 ...
 if let data = data {

 if let image = UIImage(data: data) {

 completitionHandler(image, error)

 } else {
 ...

 assertionFailure("Image doesn't exist")
 якшо помилка то тут немає виклику completitionHandler - deadEnd для production  версії
 }

 21 -  РОзбивайте UI на flow
  зробіть storyboard для tutorial
 зробіть storyboard для regular flow

 буде легше і швидше шукати UI і його редагувати (маленькі файли - швидше обробка)

 22 - TutorialScene

  -  винесіть dataSource/delegate в відповідальність окремого об'єкту
  - aditionalLabelData / mainLabelData - винесіть в plist і хай то буде даними які можна зчитати і показати а не hardcode в коді
 -         static let tutorialSceneIdentifier = "TutorialCell" - про cell має знати табличка і cell

  оптимізуйте

 наприклад

 import UIKit

 public extension UITableViewCell {

 // MARK: - UITableViewCell+BuildAction

 class var identifier: String {
 String(describing: self)
 }

 class var nib: UINib {
 UINib(nibName: self.identifier, bundle: nil)
 }

 class func deque(from tableView: UITableView) -> UITableViewCell {
 guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier),
 type(of: cell) == self
 else {
 fatalError("can't dequeu reusable cell")
 }
 return cell
 }

 class func register(for tableView: UITableView) {
 tableView.register(nib, forCellReuseIdentifier: identifier)
 }
 }


 usage:

 // somewhere before displaying data
 TutorialCell.register(tableView)

 // and in datasource

 final public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let currentItem = items[indexPath.section][indexPath.row]
 let cell = currentItem.dequeueCell(tableView, at: indexPath)

 return cell
 }

23 - документація чи уважність

 override func viewDidLayoutSubviews() { (TutorialScene)

 // немає super!

 override func viewWillAppear(_ animated: Bool) { (Location)


 24 - один контролер контролює все

 private func configureStyle() {

 UIApplication.shared.windows.forEach { window in

 if #available(iOS 13.0, *) {

 window.overrideUserInterfaceStyle = .light
 }
 }
 }

 це дуже погано

 25 - extension - окремі файли

 //MARK: - UIImage extension
 extension UIImage {

 extension UIColor { - в окремий файл

 extension UIColor {  - в окремий файл

 static func hexStringFromColor(color: UIColor) -> String {

 extension UIView {  - в окремий файл

 func roundCorners(corners: UIRectCorner, radius: CGFloat) {


 26 - розділяйте код логічно

 func scrollViewDidScroll(_ scrollView: UIScrollView) {
 це ж не UICollectionViewDeleagte (і тут доречі опечатка в англ мові)

 27 - пусті методи не потрібні

 override func awakeFromNib() {

 super.awakeFromNib()
 }

 28 - public
 @IBOutlet public weak var tutorialImageView: UIImageView!

 навіщо вам тут public (internal не вистачає) - повторити!

 29 - розділяти код
 private var locationManager = CLLocationManager()

 винести окремо - контролер не має про то знати

 30 - Назви - якщо ви вибрали все називати Scene - то чому шось Scene а щось Location - все має бути однаково!

 31 - MKAnnotationView - у вас свою - створіть клас subclass і реалізуйте всю логіку там а не в контролері - думайте про reuse

 32 - MainSceneAnimation - краще було б тоді винести в ext чи ще якось - бо створювати клас який просто створюєьться шоб викликати функцію instance - дивно (всі ж параметри передаються в функцію - навіщо вам об'єкт)

 33 - MainSceneCell - все має бути private і має бути метод який конфігурує cell  дані

 prepareForReuse?

 пусті функціїї

 extension UIColor { - в окремий файл

 34 - MainScene - dataSource/delegate - окремо треба б  (щоб контролер не відповідав а мав відповідальних) - схожа ситуація з tutorial

 35 -

 private func configureStyle() { - знову GOD функ

 як ви це будете міняти потім і як ви цим керуватимите?

 36 - ЖАХ

 private func configureImageData(_ data: [MainData]) {

 кожен раз як завантажиться малюнок ви перезавантажуєте табличку!!!

 напркилад

 cellForRowAtIndexPath ....

 setup ...

 і завантаження малюнка
 NetworkService.service.downloadImage(imgURL) { (image, error) in
  if let image = image {
    DispatchQueue.performOnMain {
      let cell = self.actualSearchResultTableView.cellForRow(at: indexPath) as? ActualSearchResultTableViewCell
  якшо cell !=nil = він існує і видимий інакше запишеться в cache URLSession
      cell?.avatarImageView?.image = image
    }
  }
 }

 говорили балакали - сіли заплакали =)

37 - думайте про локалізацію додатку навіть якщо замовник сказав шо не треба

 alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

 почитайте про локазізацію і Localizable.strings

 38 -

 розділяйте код - чому контролер це робить? хто має це робити?
 
 private func generateIcon(_ data: MainData) -> String {

 39 - BoOl power - це смерть

 private var searchButtonTapedOnce = true
 завжди мож зробити без

 40 - hardcode  і тп вже не пишу

 41 -         tableView.reloadData()
а де ж анімації :(

 42 - 

 extension UIColor {

 class var frogGreen: UIColor {

 так зргупуйте всі кольори в 1-н extension - а то там де їмо там і какаємо

як ви це будете шукати керувати міняти і тп? як це буде робити ваша команда?

 43 - DetailSceneCell- де prepareForReuse
ну і ті ж самі помилки

 44 - ShareScene зробіть в коді

 Good:

1 - CodeStyle - ну прогрес явно присутній
2- намагалися все розділяти - це добре
3- LocationAnnotation - супер
 4 - viewDidLoad в MainScene - супер


КОД: Загальна оцінка 5.2/10
 
UI:

 TO improve:

 1 - Тінь на кнопці Розпочати - подумайте як скомбінувати cornerRaius та тінь
 2 - Розміри - мають співпадати
 3 - SafeAreaa - має бути врахована
 4 - Landscape
 5 - якшо оновлення дуже швидке - то нижній бар - страшний - див 1.gif
 6 - Стилізуйте пошук - 2 .png
 7 - Status bar білий має бути
 8 - Pull to refresh робить через раз
 9 - Карта в мене не працює
 10 - назви валют в details screen - should be capitalized
 11 - знак вище нижче у валютах в details screen should be horizontally aligned
 12 - замість webView - має бути те що в дизайні (якшо даних немає залиште прочерк)
 13 - share не по дизайну
 14 - floatty button колір не такий тінь не така як на дизайні
 15 - тінь в cell на списку обрубана згори і знизу - 3.png
 16 -open searchBar ->  close searchbar - > go to details -> go back -> search bar visible а має не бути видимим бо його сховали - оце ваша Bool power
 17 -  search bar перекриває контент - 4.gif (ну і знизу так само - 5.gif)
 18 - share зявляється без анімації (виясніть  як - подивіться шось готове як то робиться - cocoacontols.org)
 19 - Карта - safe area
 20 - при появі дані перевантажуються кілька раз - див 6.gif
 21 -  pixel perfect - трошки хромає - УВАЖНО


 Good:

 1- animated coins on tutorial screen
 2- все схоже :)

 UI: Загальна оцінка 6/10

*/




@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let show = UserDefaults.standard.bool(forKey: "TutorialShown")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let tutorialScene = storyboard.instantiateViewController(withIdentifier: "TutorialScene") as? TutorialScene
        let mainSceneNavigation = storyboard.instantiateViewController(withIdentifier: "MainSceneNavigation")
        
        if let window = self.window {
            
            if show {
                
                window.rootViewController = mainSceneNavigation
                
            } else {
                
                window.rootViewController = tutorialScene
                UserDefaults.standard.set(true, forKey: "TutorialShown")
            }
        }

        return true
    }
}
