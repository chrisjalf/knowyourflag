//
//  HomeVC.swift
//  knowyourflag
//
//  Created by Chris James on 28/05/2024.
//

import UIKit
import DropDown

class HomeVC: UIViewController {
    
    var collectionView: UICollectionView!
    let gameTypes = [GameType.guessTheCountry.rawValue, GameType.guessTheFlag.rawValue]
    let gameModes = [GameMode.sixtySeconds.rawValue, GameMode.unlimited.rawValue]
    let gameModeDropdown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureCollectionView()
        configureGameModeDropdown()
        
        let apiManager = APIManager.sharedInstance
//        apiManager.test { [weak self] result in
//            guard let _ = self else { return }
//            
//            switch result {
//            case .success(let a):
//                print("popo: \(a)")
//                break
//            case .failure(let error):
//                print("error: \(error)")
//                break
//            }
//        }
        apiManager.login(request: LoginRequest(email: "chris.w4ac@gmail.com", password: "p4r4d31nd34th")) { [weak self] result in
            guard let _ = self else { return }
            
            switch result {
            case .success(let data):
                KeychainManager.sharedInstance.save(data: Data(data.access_token.utf8), service: "access_token", account: "kyf")
                break
            case .failure(let err):
                print("error: \(err)")
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func configureGameModeDropdown() {
        gameModeDropdown.cornerRadius = 10
        gameModeDropdown.selectionBackgroundColor = .systemPink
        gameModeDropdown.selectedTextColor = .white
        gameModeDropdown.dimmedBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as? MyCollectionViewCell else { return UICollectionViewCell() }
        cell.configureLabel(gameTypes[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MyCollectionViewCell else { return false }
        
        if cell.isSelected == true {
            gameModeDropdown.hide()
            return true
        } else {
            gameModeDropdown.anchorView = cell
            gameModeDropdown.bottomOffset = CGPoint(x: 0, y: cell.bounds.height)
            gameModeDropdown.dataSource = gameModes
            gameModeDropdown.selectionAction = { [unowned self] (index, item) in
                var vc: UIViewController?
                var remainingTime: Int!
                
                switch gameModes[index] {
                case GameMode.sixtySeconds.rawValue:
                    remainingTime = 60
                case GameMode.unlimited.rawValue:
                    remainingTime = 0
                default: break
                }
                
                switch indexPath.row {
                case 0:
                    vc = GuessTheCountryVC(remainingTime: remainingTime)
                case 1:
                    vc = GuessTheFlagVC(remainingTime: remainingTime)
                default: break
                }
                
                if let vc = vc {
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
            gameModeDropdown.show()
        }
        
        return false
    }
}
