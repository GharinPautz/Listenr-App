//
//  SpotifyAPI.swift
//  Listenr
//
//  Created by Gharin Pautz on 12/11/20.
//

import Foundation
import SwiftyJSON

class SpotifyAPI {
    static let recommendationsBaseURL = "https://api.spotify.com/v1/recommendations"
    static let searchBaseURL = "https://api.spotify.com/v1/search"
    static let APIKey = ""
    
    static func searchURL(muse: String, type: String) -> URL {
        let params = [
            "key": SpotifyAPI.APIKey,
            "muse": muse,
            "type": type
        ]
        
        var queryItems = [URLQueryItem]()
        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        var components = URLComponents(string: SpotifyAPI.searchBaseURL)!
        components.queryItems = queryItems
        let url = components.url!
        return url
    }
    
    // Here I started stubbing out how we can get the string optional artistID  using SwiftyJSON
    // It needs a completion handler that updates artist id in the PrevSongViewController class
/*
    static func fetchArtistID(artist: String) -> String? {

        let url = searchURL(muse: artist, type: "artist")
        
        let task = URLSession.shared.dataTask(with: url) { (dataOptional, urlResponseOptional, errorOptional) in
            if let data = dataOptional {
                if let json = try? JSON(data: data) {
                    let artistID = json["artists"]["items"]["id"].string
                    
                }
            }
        }
    }
 */
    
}
