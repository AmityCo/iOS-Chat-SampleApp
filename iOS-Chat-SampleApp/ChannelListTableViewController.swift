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
    var messageRepository:AmityMessageRepository?
    var channelToken:AmityNotificationToken?
    var messageToken:AmityNotificationToken?
    var channels:AmityCollection<AmityChannel>?
    var messagesCollection: AmityCollection<AmityMessage>?
    var latestMessages:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logout))
        print("enter channel viewdidload")
        
        self.channelRepository = AmityChannelRepository(client:AmityManager.shared.client!)
        self.messageRepository = AmityMessageRepository(client: AmityManager.shared.client!)
        
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
            print("enter observe channel")
            self.channels = channels
            self.latestMessages = []
            for index in 0..<channels.count() {
                self.messagesCollection = self.messageRepository?.getMessages(channelId: channels.object(at: UInt(index))!.channelId, includingTags: [], excludingTags: [], filterByParentId: false, parentId: nil, reverse: true)

                if self.messagesCollection?.count() ?? 0 > 0, let message = self.messagesCollection?.object(at: 0),let messageBody =  message.data?["text"] as? String {
                    print("enter get messages \(messageBody)")
                    self.latestMessages?.append(messageBody)
                }
                else{
                    self.latestMessages?.append("")
                }
                self.tableView.reloadData()
                
            }
      
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadChannels()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as! ChannelTableViewCell
        cell.displayName.text = channel?.displayName
        if !(self.latestMessages?.isEmpty ?? true) , indexPath.row < self.latestMessages?.count ?? 0 {
           
            cell.message.text = self.latestMessages?[indexPath.row]
        }
        else{
            cell.message.text = ""
        }
       
        let dateFormatter = DateFormatter()
         
        dateFormatter.dateFormat = "HH:mm"
         
        let time = dateFormatter.string(from: channel!.updatedAt)
        cell.timeLabel.text = time
        if cell.avatar.image == nil {
        cell.avatar.sd_setImage(with: URL(string: channel!.getAvatarInfo() != nil ? channel!.getAvatarInfo()?.fileURL as! String  : "https://fakeface.rest/face/view?minimum_age=25&maximum_age=30&t=\(Int.random(in: 0..<6))"))
        }
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
