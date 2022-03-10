//
//  BreedFavoritesViewController.swift
//  Shape
//
//  Created by Raul Mantilla on 6/03/22.
//

import UIKit
import Combine
import SwiftUI

class BreedFavoritesViewController: UIViewController {
    
    private var viewModel: FavoritesViewModel?
    private var subscriptions = [AnyCancellable]()
    
    private var collectionView: UICollectionView = {
        let collectView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        let layout = UICollectionViewFlowLayout.init()
        collectView.setCollectionViewLayout(layout, animated: true)
        collectView.backgroundColor = UIColor.clear
        return collectView
    }()
    
    let breedPickerView: UIPickerView = UIPickerView()
    
    let filterButtonView: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(L10n.filter, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
        
    }()
    
    let dismissFilterButtonView: UIButton = {
        let dismissbutton = UIButton(frame: .zero)
        dismissbutton.setTitleColor(.black, for: .normal)
        
        dismissbutton.tintColor = .black
        dismissbutton.addTarget(self, action: #selector(onDismissFilterButtonTapped), for: .touchUpInside)
        dismissbutton.semanticContentAttribute = .forceRightToLeft
        return dismissbutton
    }()
    
    let toolBar: UIToolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = FavoritesViewModel()
        addFilterButtonView()
        addCollectionView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.action.send(.getBreedPictures)
        viewModel?.action.send(.getBreed)
        breedPickerView.reloadAllComponents()
    }
    
    func bind() {
        viewModel?.$favoritePictures
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                self?.updateUI()
            })
            .store(in: &subscriptions)
    }
    
    private func updateUI() {
        self.collectionView.reloadData()
    }
    
    private func addPickerView() {
        breedPickerView.delegate = self
        breedPickerView.dataSource = self
        self.view.addSubview(breedPickerView)
        
        breedPickerView.translatesAutoresizingMaskIntoConstraints = false
        breedPickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        breedPickerView.trailingAnchor.constraint(equalTo:view.trailingAnchor).isActive = true
        breedPickerView.leadingAnchor.constraint(equalTo:view.leadingAnchor).isActive = true
        breedPickerView.backgroundColor = .white
    }
    
    private func addToolBar() {
        self.view.addSubview(toolBar)
        toolBar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        toolBar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.topAnchor.constraint(equalTo: breedPickerView.safeAreaLayoutGuide.topAnchor).isActive = true
        toolBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        toolBar.items = [UIBarButtonItem.init(title: L10n.done, style: .done, target: self, action: #selector(onDoneButtonTapped))]
    }
    
    private func addFilterButtonView() {
        
        self.view.addSubview(filterButtonView)
        
        filterButtonView.translatesAutoresizingMaskIntoConstraints = false
        filterButtonView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        filterButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        filterButtonView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        filterButtonView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    private func addDismissFilterButtonView() {
        
        self.view.addSubview(dismissFilterButtonView)
        
        dismissFilterButtonView.translatesAutoresizingMaskIntoConstraints = false
        dismissFilterButtonView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        dismissFilterButtonView.leadingAnchor.constraint(equalTo: filterButtonView.trailingAnchor, constant: 10).isActive = true
        dismissFilterButtonView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dismissFilterButtonView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        dismissFilterButtonView.setTitle(viewModel?.selectedBreed, for: .normal)
        dismissFilterButtonView.setImage(UIImage(systemName: "multiply.circle"), for: .normal)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        addPickerView()
        addToolBar()
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        breedPickerView.removeFromSuperview()
        guard let selectedBreed = viewModel?.selectedBreed, !selectedBreed.isEmpty else { return }
        viewModel?.action.send(.filterBy(breed: selectedBreed))
        addDismissFilterButtonView()
    }
    
    @objc func onDismissFilterButtonTapped() {
        if let viewModel = self.viewModel {
            viewModel.selectedBreed = ""
            viewModel.action.send(.filterBy(breed: viewModel.selectedBreed))
        }
        dismissFilterButtonView.removeFromSuperview()
        
    }
    
    private func addCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: filterButtonView.bottomAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo:view.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo:view.leadingAnchor).isActive = true
        
        collectionView.register(BreedPictureCell.self, forCellWithReuseIdentifier: String(describing: BreedPictureCell.self))
    }
    
    func setFavoritePicture(_ picture: String) {
        self.viewModel?.action.send(.removeFavorite(picture: picture, breed: ""))
    }
}

extension BreedFavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else { return 0 }
        return viewModel.favoritePictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let viewModel = self.viewModel,
           let picture = viewModel.favoritePictures[safe: indexPath.row],
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BreedPictureCell.self), for: indexPath) as? BreedPictureCell {
            cell.configure(with: picture, isFavorite: true)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel = self.viewModel,
           let picture = viewModel.favoritePictures[safe: indexPath.row] {
            self.setFavoritePicture(picture)
        }
    }
    
}

extension BreedFavoritesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel?.breeds.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let viewModel = self.viewModel,
           let breed = viewModel.breeds[safe: row] {
            return breed.capitalized
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let viewModel = self.viewModel,
           let breed = viewModel.breeds[safe: row] {
            viewModel.selectedBreed = breed
        }
    }
    
 
}

extension BreedFavoritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let itemWidth = (collectionView.bounds.width / 3) - padding
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
}
