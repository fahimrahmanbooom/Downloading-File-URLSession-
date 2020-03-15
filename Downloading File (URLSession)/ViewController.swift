//
//  ViewController.swift
//  Downloading File (URLSession)
//
//  Created by Fahim Rahman on 14/3/20.
//  Copyright © 2020 Fahim Rahman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var openButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    var newUrl = URL(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadButton.layer.cornerRadius = downloadButton.frame.height / 2
        openButton.layer.cornerRadius = openButton.frame.height / 2
        
        label.text = "Press the download button"
    }
    
    
    
    // Downloading content method
    
    func downloadingContent() {
        
        let url = URL(string: "https://file-examples.com/wp-content/uploads/2017/02/file_example_JSON_1kb.json")
        
        URLSession.shared.downloadTask(with: url!) { (urlresponse, response, error) in
            
            guard let originalUrl = urlresponse else { return }
            
            do {
                let path = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                
                self.newUrl = path.appendingPathComponent("json")
                
                try FileManager.default.moveItem(at: originalUrl, to: self.newUrl!)
                
                self.defaults.set(self.newUrl, forKey: "newUrl")
                print(self.newUrl!)
            }
            catch {
                print(error.localizedDescription)
                return
            }
        }.resume()
    }
    
    
    
    // Opening content from saved location method
    
    func openFileFromSavedLocationIfItIsSaved() {
        
        let filemanager = FileManager.default
        
        if filemanager.fileExists(atPath: defaults.url(forKey: "newUrl")!.path) == true {
            
            print("file found")
            print("already downloaded")
        }
        else {
            
            print("file doesn't exist")
            print("downloading content")
            downloadingContent()
        }
    }
    
    
    // Download button actions
    
    @IBAction func downloadButtonPressed(_ sender: UIButton) {
        
        label.text = "Downloading Content if not downloaded yet"
        openFileFromSavedLocationIfItIsSaved()
    }
    
    
    // Open button actions
    
    @IBAction func openButtonPressed(_ sender: UIButton) {
        
        label.text = "File is opening"
        openFileFromSavedLocationIfItIsSaved()
    }
}
