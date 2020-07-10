//
//  DetailViewController.swift
//  oDot
//
//  Created by Andrew on 08/07/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var heroBigImage: UIImageView?
    @IBOutlet weak var detailTableView: UITableView?

    var hero: Hero?
    var heroDetailData: [String] = [String]()
    var similarHeroes: [Hero] = [Hero]()

    func configureView() {
        // Update the user interface for the detail item.
        if let selectedHero = self.hero {
            self.navigationItem.title = selectedHero.localized_name
            let imageUrl = UrlUtils.buildAvatarImageUrl(avatarUrlPiece: selectedHero.img ?? "")
            self.heroBigImage?.sd_setImage(with: imageUrl, completed: nil)
            // Hero Details
            self.heroDetailData.removeAll()
            self.heroDetailData.append(selectedHero.attack_type ?? "")
            self.heroDetailData.append(selectedHero.primary_attr ?? "")
            self.heroDetailData.append(String(selectedHero.base_health))
            self.heroDetailData.append(String(selectedHero.base_attack_max))
            self.heroDetailData.append(String(selectedHero.move_speed))
            self.heroDetailData.append(selectedHero.roles ?? "")
        }
    }
    
    func setHero(hero: Hero) {
        self.hero = hero
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailTableView?.dataSource = self
        self.detailTableView?.delegate = self
        self.detailTableView!.register(UINib(nibName: "HeroCell", bundle: Bundle.main), forCellReuseIdentifier: "HeroCell")
        self.detailTableView?.allowsSelection = false
        configureView()
    }

    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Other choice"
        }
        
        return ""
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.heroDetailData.count
        } else if section == 1 {
            return self.similarHeroes.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            // similar heroes
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCell", for: indexPath) as! HeroCell
                    
            cell.hero = self.similarHeroes[indexPath.row]
            cell.setup()
            
            return cell
            
        } else {
            // attr
            let cell = tableView.dequeueReusableCell(withIdentifier: "KeyValueCell", for: indexPath)
                
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Attack Type"
            case 1:
                cell.textLabel?.text = "Atribute"
            case 2:
                cell.textLabel?.text = "Health"
            case 3:
                cell.textLabel?.text = "Max Attack"
            case 4:
                cell.textLabel?.text = "Speed"
            case 5:
                cell.textLabel?.text = "Role"
            default:
                cell.textLabel?.text = "?"
            }
            
            cell.detailTextLabel?.text = heroDetailData[indexPath.row]
                
            return cell
        }
    }


}

