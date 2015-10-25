//
//  ViewController.swift
//  googletrendsearch
//
//  Created by Tecco on 2015/08/18.
//  Copyright (c) 2015年 Tecco's Project. All rights reserved.
//

import UIKit
import Kanna

class ViewController: UIViewController, NSXMLParserDelegate{

    
    @IBOutlet weak var tableView: UITableView!
    
    var strXMLData:String = ""
    var currentElement:String = ""
    var passData:Bool=false
    var passName:Bool=false
    var parser = NSXMLParser()
    
    var tableData:[String] = []
    var exceptTitleNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url:String="http://www.google.co.jp/trends/hottrends/atom/hourly"
        let urlToSend: NSURL = NSURL(string: url)!
        // Parse the XML
        parser = NSXMLParser(contentsOfURL: urlToSend)!
        parser.delegate = self
        
        let success:Bool = parser.parse()
        
        if success {
            print("success!")
        } else {
            print("failure!")
        }
        
        let html = strXMLData
        if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
            print("-----------------")
            
            // Search for nodes by CSS
            for link in doc.css("a") {
                print(link.text)
                tableData.append(link.text!)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName;
        if(elementName=="content"){
            passName=true;
        }
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        if(elementName=="content"){
            passName=false;
        }
        
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if(passName){
            strXMLData = strXMLData + string
            
            //tableData.append(string!)
        }
        
        if(passData)
        {
            print(string)
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        NSLog("failure error: %@", parseError)
    }
    
    // セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    // セルの内容を変更
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = tableData[indexPath.row]
        
        return cell
    }

}

