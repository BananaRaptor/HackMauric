import UIKit
import UserNotifications

struct Test : Codable {
   let workingstate = true
    let flow = 0
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var gradient: UIView!
    
    
    
    
    
    static public var pompes: Array<Pompe> = Array()
    let server = "http://18.222.169.179:3000"
    
    @IBOutlet weak var serverResponseLabel: UILabel!
    
    
    @IBAction func sendRequestButtonTappled(_ sender: UIButton) {
        
        
        
            
        
        
        
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
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var updateListView = Timer.scheduledTimer(timeInterval: 2.00, target: self, selector: #selector(updateTable), userInfo: nil, repeats: true)
        var updatePumps = Timer.scheduledTimer(timeInterval: 5.00, target: self, selector: #selector(updateFlow), userInfo: nil, repeats: true)
        
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
            view.backgroundColor = UIColor.black
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
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150),
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
        if ViewController.pompes[indexPath.row].flow > 0 {
            
            cell.pompeLabel.text = ViewController.pompes[indexPath.row].name + "  1  " + String(ViewController.pompes[indexPath.row].flow)
            cell.pompeLabel.textColor = UIColor.systemGreen
            
        } else {
            
            cell.pompeLabel.text = ViewController.pompes[indexPath.row].name + "  0   " + String(ViewController.pompes[indexPath.row].flow)
            cell.pompeLabel.textColor = UIColor.red
            
            var content = UNMutableNotificationContent()
            content.title = "Alerte Pompe"
            content.subtitle = "Problème"
            content.body = "Vérifier votre pompe " + ViewController.pompes[indexPath.row].name
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)
            let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        }
        
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
    
    @objc func updateFlow() {
        
        for pompe in ViewController.pompes {
            let urlComps = NSURLComponents(string: "http://18.222.169.179:3000/getFlow/"+pompe.code)!
            let URL = urlComps.url!
            var request = URLRequest(url:URL)
            request.httpMethod = "GET"
            
            
            
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
                    if let json = try JSONSerialization.jsonObject(with: data!, options:[] ) as? [String: Any] {
                        print(json)
                        if let workingState = json["workingstate"] as? Bool {
                            print(workingState)
                            pompe.workingState = workingState
                        }
                        if let flow = json["flow"] as? Int {
                            print(flow)
                            pompe.flow = flow
                        }
                     }
                 } catch {
                     print(error)
                 }
             }
             task.resume()
            
        }
    }
    
    
    
    
}

