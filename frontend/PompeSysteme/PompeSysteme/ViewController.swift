import UIKit
import UserNotifications



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    
    static public var pompes: Array<Pompe> = Array()
    let server = "http://18.222.169.179:3000"
    
    @IBOutlet weak var serverResponseLabel: UILabel!
    
    
    @IBAction func sendRequestButtonTappled(_ sender: UIButton) {
        
        
        
            let myUrl = URL(string: "http://18.222.169.179:3000/addpump");
             
             var request = URLRequest(url:myUrl!)
             
             request.httpMethod = "POST"// Compose a query string
             
             let postString = "firstName=James&lastName=Bond";
             
             request.httpBody = postString.data(using: String.Encoding.utf8);
             
             let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                 
                 if error != nil
                 {
                     print("error=\(error)")
                     return
                 }
                 
                 // You can print out response object
                 print("response = \(response)")
        
                 //Let's convert response sent from a server side script to a NSDictionary object:
                 do {
                     let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                     
                     if let parseJSON = json {
                         
                         // Now we can access value of First Name by its key
                         let firstNameValue = parseJSON["firstName"] as? String
                         print("firstNameValue: \(firstNameValue)")
                     }
                 } catch {
                     print(error)
                 }
             }
             task.resume()
        
        
        
        
        //Get info
//        guard let url  = URL(string: server) else {return}
//        // background task to make request with URLSession
//        let task = URLSession.shared.dataTask(with: url) {
//            (data, response, error) in
//            if let error = error {
//                print(error)
//                return
//            }
//            guard let data = data else {return}
//            guard let dataString = String(data: data, encoding: String.Encoding.utf8) else {return}
//            // update the UI if all went OK
//            DispatchQueue.main.async {
//                self.serverResponseLabel.text = dataString
//                print(dataString)
//            }
//        }
//        // start the task
//        task.resume()
    }
    
    @IBAction func sendNotification(_ sender: Any) {
        print("criss de notiff")
        var content = UNMutableNotificationContent()
        content.title = "Notification Tutorial"
        content.subtitle = "from ioscreator.com"
        content.body = " Notification triggered"
        
                    
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var update = Timer.scheduledTimer(timeInterval: 2.00, target: self, selector: #selector(updateTable), userInfo: nil, repeats: true)
        
        setupTableView()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            (granted, error) in
            if granted {
                print("yes")
            } else {
                print("No")
            }
        }
    }
    
    
    
    class ThirtyDayCell: UITableViewCell {
        
        let cellView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.blue
            view.layer.cornerRadius = 10
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let pompeLabel: UILabel = {
            let label = UILabel()
            label.text = "Day 1"
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupView()
        }
        
        func setupView() {
            addSubview(cellView)
            cellView.addSubview(pompeLabel)
            self.selectionStyle = .none
            
            NSLayoutConstraint.activate([
                cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
                cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
                cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            
            pompeLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
            pompeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            pompeLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
            pompeLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
            
        }

        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    

    
    
    func setupTableView() {
        
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(ThirtyDayCell.self, forCellReuseIdentifier: "cellId")
        
        view.addSubview(tableview)
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    public let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorColor = UIColor.white
        return tv
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewController.pompes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ThirtyDayCell
        cell.pompeLabel.text = ViewController.pompes[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    @IBAction func addButton(_ sender: Any) {
        
    }
    
    
    @objc func updateTable() {
        tableview.reloadData()
    }
}

