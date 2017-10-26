import UIKit

class ViewController: UIViewController {

    var cdCollection: [CD] = []
    var currentCdIndex: Int = 0
    var json: [Dictionary<String,Any>] = []
    var failCount = 0
    
    var isEdited: Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchJson()
        self.initHandleInputChange()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBOutlet weak var AlbumName: UITextField!

    @IBOutlet weak var ArtistName: UITextField!
    
    @IBOutlet weak var GenreName: UITextField!
    
    @IBOutlet weak var YearName: UITextField!
    
    @IBOutlet weak var TrackCount: UITextField!
    
    @IBOutlet weak var IndexInfo: UITextField!
    
    @IBOutlet weak var PreviousButton: UIButton!
    
    @IBOutlet weak var NextButton: UIButton!
    
    @IBOutlet weak var SaveButton: UIButton!
    
    @IBOutlet weak var DeleteButton: UIButton!
    func inputChanged(textField: UITextField) {
        self.SaveButton.isEnabled = true
    }
    
    func initHandleInputChange() {
            self.AlbumName.addTarget(self, action: #selector(inputChanged(textField:)), for: .editingChanged)
           self.ArtistName.addTarget(self, action: #selector(inputChanged(textField:)), for: .editingChanged)
           self.GenreName.addTarget(self, action: #selector(inputChanged(textField:)), for: .editingChanged)
           self.YearName.addTarget(self, action: #selector(inputChanged(textField:)), for: .editingChanged)
           self.TrackCount.addTarget(self, action: #selector(inputChanged(textField:)), for: .editingChanged)
    }
    
    func fetchJson(){
        let url = URL(string:"https://isebi.net/albums.php");
        
        let task = URLSession.shared.dataTask(with: url!){
            (data, response, error) in
           
            let json = (try! JSONSerialization.jsonObject(with: data!, options: []) as? [Dictionary<String,Any>])
            self.json = json != nil ? json! : []
            
            if (json == nil && self.failCount < 3) {
                self.failCount = self.failCount + 1
                self.fetchJson()
            }
            
            self.cdCollection = self.parseCollection(json: self.json)
            DispatchQueue.main.async {
                self.updateScreen()
            }
        }
        
        task.resume()
    }
    
    func parseCollection(json: [Dictionary<String,Any>]) -> [CD] {
        var collection:[CD] = [];
        for element in json {
            collection.append(CD(json:element))
        }
        return collection
    }
    
    func updateScreen(){
        var cd: CD
        if (self.currentCdIndex == self.cdCollection.count) {
            cd = CD()
            self.IndexInfo.text = "Nowy rekord"
        } else {
            cd = self.cdCollection[self.currentCdIndex]
            self.IndexInfo.text = "Rekord \(self.currentCdIndex + 1) z \(self.cdCollection.count)"
        }
        
        self.AlbumName.text = cd.album
        self.ArtistName.text = cd.artist
        self.GenreName.text = cd.genre
        self.YearName.text = cd.year
        self.TrackCount.text = cd.tracks
        
        self.PreviousButton.isEnabled = self.currentCdIndex != 0
        self.NextButton.isEnabled = self.currentCdIndex != self.cdCollection.count
        self.SaveButton.isEnabled = false
        
        if (self.cdCollection.count > 0 && self.currentCdIndex < self.cdCollection.count) {
            self.DeleteButton.isEnabled = true
        } else {
            self.DeleteButton.isEnabled = false
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if (self.currentCdIndex < (self.cdCollection.count)){
            self.currentCdIndex = self.currentCdIndex + 1
            self.updateScreen()
        }
    }
   
    @IBAction func previousAction(_ sender: Any) {
        if (self.currentCdIndex > 0){
            self.currentCdIndex = self.currentCdIndex - 1
            self.updateScreen()
        }
    }
    
    @IBAction func newAction(_ sender: Any) {
        self.currentCdIndex = self.cdCollection.count
        self.updateScreen()
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        if (self.cdCollection.count > 0 && self.currentCdIndex < self.cdCollection.count) {
            self.cdCollection.remove(at: self.currentCdIndex)
            self.updateScreen()
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let cd: CD = CD()
        cd.album = self.AlbumName.text!
        cd.artist = self.ArtistName.text!
        cd.genre = self.GenreName.text!
        cd.year = self.YearName.text!
        cd.tracks = self.TrackCount.text!
        
        self.cdCollection.insert(cd, at: self.currentCdIndex)
        self.updateScreen()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }
    
}

