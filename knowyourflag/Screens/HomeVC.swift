//
//  HomeVC.swift
//  knowyourflag
//
//  Created by Chris James on 28/05/2024.
//

import UIKit
import Combine
import DropDown

class HomeVC: UIViewController {
    private let profileViewModel: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()
    
    var collectionView: UICollectionView!
    let gameTypes = [GameType.guessTheCountry.rawValue, GameType.guessTheFlag.rawValue]
    let gameModes = [GameMode.sixtySeconds.rawValue, GameMode.unlimited.rawValue]
    let gameModeDropdown = DropDown()
    
    init(profileViewModel: ProfileViewModel = ProfileViewModel.sharedInstance) {
        self.profileViewModel = profileViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupObservers()
        configureCollectionView()
        configureGameModeDropdown()
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

extension HomeVC {
    private func setupObservers() {
        profileViewModel.$profile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profile in
                print("HomeVC profile:\(profile)")
            }
            .store(in: &cancellables)
    }
}
