//
//  ViewController.swift
//  PeekAndPop_Demo
//
//  Created by William Wong on 29/12/2015.
//  Copyright © 2015 Fleetmatics. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    struct previewDataObject {
        var title:String
        var preferredHeight:Double
    }
    
    let sampleData = [
        previewDataObject(title: "small", preferredHeight: 150),
        previewDataObject(title: "medium", preferredHeight: 200),
        previewDataObject(title: "large", preferredHeight: 300)
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (traitCollection.forceTouchCapability == .Available) {
            registerForPreviewingWithDelegate(self, sourceView: self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail", let indexPath = tableView.indexPathForSelectedRow {
            let previewDetail = sampleData[indexPath.row]
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            
            // Pass the `title` to the `detailViewController`.
            detailViewController.detailTitle = previewDetail.title
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TestCell = tableView.dequeueReusableCellWithIdentifier("testcell", forIndexPath: indexPath) as! TestCell
        let dataObj = sampleData[indexPath.row]
        cell.titleLabel.text = dataObj.title
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetail", sender: indexPath)
        
    }
}

extension ViewController: UIViewControllerPreviewingDelegate {
    // Create a previewing view controller to be shown at "Peek".
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.tableView.indexPathForRowAtPoint(location),
            cell = self.tableView.cellForRowAtIndexPath(indexPath) else { return nil }
        guard let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as? DetailViewController else { return nil }
        
        print("row: \(indexPath.row)")
        let previewDetail = sampleData[indexPath.row - 1]
        detailViewController.detailTitle = previewDetail.title
        
        detailViewController.preferredContentSize = CGSize(width: 0.0, height: previewDetail.preferredHeight)

        // Set the source rect to the cell frame, so surrounding elements are blurred.
        previewingContext.sourceRect = cell.frame
        
        return detailViewController
}
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: nil)
    }

}
