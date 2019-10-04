//
//  ViewController.swift
//  PassWord
//
//  Created by 泛白的红砖 on 2019/10/2.
//  Copyright © 2019 DaiJiAn. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource ,UISearchBarDelegate {
    var tableView : UITableView = UITableView()
    var nameArray : Array<String>?
    var passwordArray : Array<String>?
    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "简易密码本"
        let tableView = UITableView (frame: CGRect(x: 0, y: 0 , width: self.view.frame.width , height: self.view.frame.height), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        // 初始化数组
        nameArray = []
        passwordArray = []
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<User>(entityName: "User")
        do {
            
            let items = try  managedObjectContext.fetch(request)
            
            for i in items {
//                    managedObjectContext.delete(i)
//                    print(i.name)
//                    print(i.password)
                    nameArray?.append(i.name!)
                    passwordArray?.append(i.password!)
                }
//           try managedObjectContext.save()
            }catch{
            
        }
        
        let rightBarItems = UIBarButtonItem(title: "添加", style: .done , target: self, action: #selector(addNew))
        self.navigationItem.rightBarButtonItem = rightBarItems
        
        self.view.addSubview(tableView)
        
        //添加搜索框
        let search = UISearchBar (frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30 ))
        search.searchBarStyle = .minimal
        search.placeholder = "账号数据超过20个时才能正常使用搜索功能"
        search.delegate = self
        tableView.addSubview(search)
        
        
    }
    
    //点击搜索后输出搜索结果
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let str = searchBar.text!
        var row = 0
        for i in 0 ..< nameArray!.count {
            if nameArray?[i].hasPrefix(str) ?? false {
//                print(nameArray?[i])
                row = i
                break
            }
        }
        let indexPath = IndexPath(row: row, section: 0)
        if row > 15 {
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
    }
    //设置cell行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray?.count ?? 1
    }
    // 设置cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // 设置tableview的cell的数据
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indentifer = "reuseCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: indentifer)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle , reuseIdentifier: indentifer)
        }
        let numRow = indexPath.row
        cell?.textLabel?.text = nameArray?[numRow]
        return cell!
    }
    
    //添加新的账号和密码以Alert窗口的方式实现
    @objc func addNew () {
        let alertController = UIAlertController (title: "添加个人账户", message: "添加的账户不能与已有账户重复或为空", preferredStyle: .alert)
                alertController.addTextField(configurationHandler: {
                    (textField) in textField.placeholder = "如:腾讯QQ 1686888981"
                }  )
                
                alertController.addTextField(configurationHandler: {
                    (textField) in textField.placeholder = "请输入登录密码"
                })
                let alertCancel = UIAlertAction (title: "取消", style: .cancel, handler: nil)
                let alertAdd = UIAlertAction (title: "确认", style: .default, handler: {
                    (UIAlertAction) -> Void in
                    // 如果所输入的名称有存在的,则不保存
                    var exist = false
                    self.nameArray?.forEach({
                        (element) in
                        if element == alertController.textFields?.first!.text || alertController.textFields?.first!.text?.count == 0{
                            exist = true
                        }
                    })
                    if exist {
                        return
                    }
                    // 存储所添加的数据
                    
                    let managedObjectContext = self.appDelegate.persistentContainer.viewContext
                    let userAdd = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedObjectContext) as? User
                    userAdd?.name = alertController.textFields?.first?.text
                    userAdd?.password = alertController.textFields?.last?.text
                    
                    do {
                        try managedObjectContext.save()
                    }catch{
                    }
                    self.viewDidLoad()
                })
                alertController.addAction(alertAdd)
                alertController.addAction(alertCancel)
                self.present(alertController, animated: true, completion: nil)
        
    }
    // 返回单元格的删除状态
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    // 删除CoreData中数据,删除单元格,删除数组中对应的数据
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let rowNum = indexPath.row
            let name = nameArray![rowNum]
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<User>(entityName: "User")
            let predicate = NSPredicate(format: "name = '\(name)'", "")
            request.predicate = predicate
            do {
                let items = try managedObjectContext.fetch(request)
                for i in items {
                    managedObjectContext.delete(i)
                }
                try managedObjectContext.save()
            }catch{
                print("获取数据失败")
            }
            
            nameArray?.remove(at: rowNum)
            passwordArray?.remove(at: rowNum)
            tableView.deleteRows(at: [indexPath] , with: .automatic)
        }
    }
    
    // 选中时显示密码信息
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = passwordArray?[indexPath.row]
        
    }
    // 取消选择时隐藏密码信息
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = ""
    }


}

