import UIKit

class CD: NSObject, NSCoding {
    
    var artist:String = "";
    var album:String = "";
    var genre:String = "";
    var year:String = "";
    var tracks:String = "";
    
    override init () {
    }
    
    init(json: [String: Any]) {
       self.artist = String(describing: json["artist"]!)
       self.album = String(describing: json["album"]!)
       self.genre = String(describing: json["genre"]!)
       self.year = String(describing: json["year"]!)
       self.tracks = String(describing: json["tracks"]!)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        self.artist = aDecoder.decodeObject(forKey: "artist") as! String
        self.album = aDecoder.decodeObject(forKey: "album") as! String
        self.genre = aDecoder.decodeObject(forKey: "genre") as! String
        self.year = aDecoder.decodeObject(forKey: "year") as! String
        self.tracks = aDecoder.decodeObject(forKey: "tracks") as! String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.artist, forKey: "artist")
        aCoder.encode(self.album, forKey: "album")
        aCoder.encode(self.genre, forKey: "genre")
        aCoder.encode(self.year, forKey: "year")
        aCoder.encode(self.tracks, forKey: "tracks")
    }
}
