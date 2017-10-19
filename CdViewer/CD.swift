import UIKit

class CD {
    var artist:String = "";
    var album:String = "";
    var genre:String = "";
    var year:String = "";
    var tracks:String = "";
    
    init () {
    }
    
    init(json: [String: Any]) {
       self.artist = String(describing: json["artist"]!)
       self.album = String(describing: json["album"]!)
       self.genre = String(describing: json["genre"]!)
       self.year = String(describing: json["year"]!)
       self.tracks = String(describing: json["tracks"]!)
    }
}
