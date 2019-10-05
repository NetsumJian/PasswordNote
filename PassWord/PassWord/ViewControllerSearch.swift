//
//  ViewControllerSearch.swift
//  PassWord
//
//  Created by 泛白的红砖 on 2019/10/5.
//  Copyright © 2019 DaiJiAn. All rights reserved.
//

import UIKit

class ViewControllerSearch: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    var searchArrayName = Array<String>()
    var searchArrayPassword = Array<String>()
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        backButton.backgroundColor = UIColor.gray
        backButton.setTitle("返回", for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        let searchTable = UITableView(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 50 ), style: .plain)
        searchTable.delegate = self
        searchTable.dataSource = self
        self.view.addSubview(searchTable)
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArrayName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reId")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle , reuseIdentifier: "reId")
        }
        
        let numRow = indexPath.row
        cell?.textLabel?.text = searchArrayName[numRow]
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.detailTextLabel?.text = searchArrayPassword[indexPath.row]
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = ""
    }
    @objc func back () {
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
