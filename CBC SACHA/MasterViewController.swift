//  MasterViewController.swift
//  CBC SACHA
//
//  Created by Sacha Sukhdeo on 2018-08-14.
//  Copyright © 2018 Sacha Sukhdeo. All rights reserved.

import UIKit
import CoreData

class MasterViewController: UITableViewController {
    
    @IBOutlet weak var topBar: UINavigationItem!
    var articles: Array<Article>?
    let rssFeedService = RSSFeedService()
    var previousIndexPath: IndexPath?
    
    @IBAction func refresh(_ sender: Any) {
        articles = []
        tableView.reloadData()
        articles = rssFeedService.getTopStories()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let indexPath = previousIndexPath {
            tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail",
            let indexPath = self.tableView.indexPathForSelectedRow {
            previousIndexPath = indexPath
            let link = articles?[indexPath.row].link
            (segue.destination as! DetailViewController).link = link
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        configureCell(cell as! RSSTableViewCell, forRow: indexPath.row)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! RSSTableViewCell).imageArticle.image = nil
        (cell as! RSSTableViewCell).imageArticle.link = nil
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let articles = articles,
            articles.count > indexPath.row {
            let article = articles[indexPath.row]
            if let url = article.imageUrl {
                (cell as! RSSTableViewCell).imageArticle.link = url
            }
        }
    }
    
    func configureCell(_ cell: RSSTableViewCell, forRow index: Int) {

        if let articles = articles,
            articles.count > index {
            let article = articles[index]
            cell.title.text = article.title
            cell.date.text = article.date
            cell.author.text = article.author
        }
    }

}

