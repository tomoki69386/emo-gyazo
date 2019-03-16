//
//  ViewController.swift
//  emo-gyazo
//
//  Created by 築山朋紀 on 2019/03/13.
//  Copyright © 2019 tomoki. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    private var post = [PostModel]() {
        didSet {
            post = Array(post.reversed())
        }
    }
    let url = "\(AppUser.apiHost)/api/v1/posts"

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.register(TimelineTableViewCell.nib, forCellReuseIdentifier: "TimelineTableViewCell")
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
            tableView.addSubview(refreshControl)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        request()
    }
    
    @objc func refreshControlAction(refreshControl: UIRefreshControl) {
        Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode([PostModel].self, from: data)
                    self.post.removeAll()
                    for item in decoded {
                        self.post.insert(item, at: 0)
                    }
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                } catch {
                    print("error:", "\(type(of: PostModel.self))型へのデコードに失敗しました")
                    refreshControl.endRefreshing()
                }
            case .failure:
                print("ERROR:", "\(type(of: PostModel.self))型へ変換するJSONが取得できませんでした")
                refreshControl.endRefreshing()
            }
        }
    }
    
    private func request() {
        let parameters: Parameters = [
            "page": "1"
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode([PostModel].self, from: data)
                    for item in decoded {
                        self.post.insert(item, at: 0)
                    }
                    self.tableView.reloadData()
                } catch {
                    print("error:", "\(type(of: PostModel.self))型へのデコードに失敗しました")
                }
            case .failure:
                print("ERROR:", "\(type(of: PostModel.self))型へ変換するJSONが取得できませんでした")
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell") as? TimelineTableViewCell else {
            fatalError("Invalid cell")
        }
        cell.update(with: post[indexPath.row])
        return cell
    }
}
