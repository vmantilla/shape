//
//  BreedsListViewController.swift
//  Shape
//
//  Created by Raul Mantilla on 6/03/22.
//

import UIKit
import Combine

class BreedsListViewController: UIViewController {
    
    var viewModel = BreedsListViewModel()
    var subscriptions = [AnyCancellable]()
    
    private var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView()
        bind()
        viewModel.action.send(.getBreedList)
    }
    
    func bind() {
        viewModel.$breeds
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                self?.updateUI()
            })
            .store(in: &subscriptions)
        
        viewModel.$isShowingError
            .sink(receiveValue: { [weak self] value in
                if value {
                    self?.addAlertView()
                }
            })
            .store(in: &subscriptions)
    }
    
    private func updateUI() {
        self.tableView.reloadData()
    }
    
    private func addTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo:view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo:view.leadingAnchor).isActive = true
        
        tableView.register(BreedsListCell.self, forCellReuseIdentifier: String(describing: BreedsListCell.self))
    }
    
    private func addAlertView() {
        let alert = UIAlertController(title: L10n.errorNetworkResponse, message: "", preferredStyle: UIAlertController.Style.alert)
        let alertReload: UIAlertAction = UIAlertAction(title: L10n.tryReloadData, style: UIAlertAction.Style.default, handler: {_ in self.viewModel.action.send(.getBreedList)})
        let alertCancel: UIAlertAction = UIAlertAction(title: L10n.dismissAlertWindow, style: UIAlertAction.Style.cancel)
        
        alert.addAction(alertReload)
        alert.addAction(alertCancel)
        present(alert, animated: false, completion: nil)
    }
}

extension BreedsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.breeds.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = self.viewModel.breeds[safe: indexPath.row],
           let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BreedsListCell.self), for: indexPath) as? BreedsListCell {
            cell.updateUI(data.name)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = self.viewModel.breeds[safe: indexPath.row] {
           self.goTo(.breedsImages(breed: data))
        }
    }
}

extension BreedsListViewController {
    
    enum BreedsListNavigation {
        case breedsImages(breed: Breed)
    }
    
    func goTo(_ screen: BreedsListNavigation) {
        switch screen {
        case .breedsImages(let breed):
            let viewController = BreedPicturesViewController()
            viewController.breed = breed
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
