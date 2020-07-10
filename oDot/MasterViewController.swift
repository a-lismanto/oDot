//
//  MasterViewController.swift
//  oDot
//
//  Created by Andrew on 08/07/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit
import SwiftyPickerPopover

class MasterViewController: UITableViewController {

    var roleBarButton: UIBarButtonItem?
    var detailViewController: DetailViewController? = nil
    var heroes = [Hero]()
    var selectedRole = "All"
    var roleOptions = ["All"]


    override func viewDidLoad() {
        super.viewDidLoad()
        self.roleBarButton = UIBarButtonItem(title: self.selectedRole, style: .plain, target: self, action: #selector(chooseRole(_:)))
        navigationItem.leftBarButtonItem = self.roleBarButton
        navigationItem.title = "Heroes"
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        self.tableView.register(UINib(nibName: "HeroCell", bundle: Bundle.main), forCellReuseIdentifier: "HeroCell")
        
        self.heroes = RealmWorker.shared.getAllHeroes()
        self.roleOptions = RealmWorker.shared.getAllRoles()
        print("Realm: \(String(describing: RealmWorker.shared.realm.configuration.fileURL))")
        
        ServiceWorker.shared.getData { (result) in
            if result {
                self.refreshData()
            }
        }
    }
    
    func refreshData() {
        self.heroes = RealmWorker.shared.getAllHeroes(withRole: self.selectedRole)
        self.roleOptions = RealmWorker.shared.getAllRoles()
        self.roleBarButton?.title = self.selectedRole
        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func chooseRole(_ sender: Any) {
        let popup = StringPickerPopover(title: "Choose Role", choices: roleOptions)
            .setSelectedRow(self.roleOptions.firstIndex(of: self.selectedRole) ?? 0)
            .setDoneButton(title:"Done", action: { (popover, selectedRow, selectedString) in
                self.selectedRole = selectedString
                self.refreshData()
            })
        popup.appear(barButtonItem: sender as! UIBarButtonItem, baseViewController: self)
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let hero = heroes[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.hero = hero
                controller.similarHeroes = RealmWorker.shared.getSimilarHeros(ofHero: hero)

                detailViewController = controller
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCell", for: indexPath) as! HeroCell
        
        cell.hero = heroes[indexPath.row]
        cell.setup()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // triger segue
        self.performSegue(withIdentifier: "showDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func refreshTable() {
        tableView.reloadData()
    }

}

