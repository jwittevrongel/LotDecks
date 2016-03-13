//
//  DetailViewController.swift
//  LotDecks
//
//  Created by Jeremiah Wittevrongel on 3/8/16.
//  Copyright © 2016 Jeremiah Wittevrongel. All rights reserved.
//

import UIKit
import SQLite

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImage: UIImageView!
    var cardDatabase : CardDatabase? = nil
    
    var detailItem: Row? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let item = self.detailItem {
            if let imageView = self.detailImage {
                let image = self.cardDatabase!.getImageForHero(item[self.cardDatabase!.col_id])
                imageView.image = image
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do {
            self.cardDatabase = try CardDatabase()
        }
        catch {
            
        }

        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

