//
//  ViewController.swift
//  Photo Search App Final
//
//  Created by Daniel Springer on 10/01/2017.
//  Copyright © 2017 Daniel Springer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFlickrBy(_searchString: "dogs")
        
    }
    func searchFlickrBy(_searchString:String) {
        let manager = AFHTTPSessionManager()
        let searchParameters:[String:Any] = ["method": "flickr.photos.search",
                                             "api_key": "a15948e7e9575bc9687d29c86b55974f",
                                             "format": "json",
                                             "nojsoncallback": 1,
                                             "text": _searchString,
                                             "extras": "url_m",
                                             "per_page": 5]
        
        manager.get("https://api.flickr.com/services/rest/",
                    parameters: searchParameters,
                    progress: nil,
                    success: { (operation: URLSessionDataTask, responseObject:Any?) in
                        if let responseObject = responseObject {
                            print("Response: " + (responseObject as AnyObject).description)
                            if let photos = (responseObject as AnyObject)["photos"] as? [String: AnyObject] {
                                if let photoArray = photos["photo"] as? [[String: AnyObject]] {
                                    self.scrollView.contentSize = CGSize(width: 320, height: 320 * CGFloat(photoArray.count))
                                    for (i,photoDictionary) in photoArray.enumerated() {
                                        if let imageURLString = photoDictionary["url_m"] as? String {
                                            let imageView = UIImageView(frame: CGRect(x:0, y:320*CGFloat(i), width:320, height:320))
                                            if let url = URL(string: imageURLString) {
                                                imageView.setImageWith(url)
                                                self.scrollView.addSubview(imageView)
                                                let imageWidth = self.view.frame.width
                                                self.scrollView.contentSize = CGSize(width: imageWidth, height: imageWidth * CGFloat(photoArray.count))
                                                for (i,photoDictionary) in photoArray.enumerated() {
                                                    if let imageURLString = photoDictionary["url_m"] as? String {
                                                        let imageView = UIImageView(frame: CGRect(x:0, y:320*CGFloat(i), width:imageWidth, height:imageWidth))
                                                        if let url = URL(string: imageURLString) {
                                                            imageView.setImageWith(url)
                                                            self.scrollView.addSubview(imageView)
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                            
                        }
        }) { (operation:URLSessionDataTask?, error:Error) in
            print("Error: " + error.localizedDescription)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            searchFlickrBy(_searchString: searchText)
        }
    }
}
   
