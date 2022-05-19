//
//  ChannelListTableViewController.swift
//  iOS-Chat-SampleApp
//
//  Created by Mark on 18/5/2565 BE.
//

import UIKit
import AmitySDK
import SDWebImage
class ChannelListTableViewController: UITableViewController {
    var channelRepository:AmityChannelRepository?
    var channelToken:AmityNotificationToken?
    var channels:AmityCollection<AmityChannel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logout))
        print("enter channel viewdidload")
        
        self.channelRepository = AmityChannelRepository(client:AmityManager.shared.client!)
        loadChannels()
        
    }

    // MARK: - Table view data source
    @objc func logout(){
        AmityManager.shared.client?.logout()
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadChannels() {
        let query = AmityChannelQuery()
        query.types = [AmityChannelQueryType.community]
            query.filter = .userIsMember
            query.includeDeleted = false
        let channelCollection = self.channelRepository?.getChannels(with: query)
        self.channelToken = channelCollection?.observe({ channels, change, error in
            self.channels = channels
            self.tableView.reloadData()
           
      
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return channels == nil ? 0 : Int(exactly:channels!.count())!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let channel = channels!.object(at: UInt(indexPath.row))
        print("check channel \(channel!.channelId)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as! ChannelTableViewCell
        cell.displayName.text = channel?.displayName
        let dateFormatter = DateFormatter()
         
        dateFormatter.dateFormat = "HH:mm"
         
        let time = dateFormatter.string(from: channel!.updatedAt)
        cell.timeLabel.text = time

        cell.avatar.sd_setImage(with: URL(string: channel!.getAvatarInfo() != nil ? channel!.getAvatarInfo()?.fileURL as! String  : ""))
        return cell
    }
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chatViewController") as! ChatViewController
        let channel = channels!.object(at: UInt(indexPath.row))
        vc.channelID = channel?.channelId
        self.navigationController?.pushViewController(vc, animated: true)
        print("select row at \(indexPath.row)")
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
