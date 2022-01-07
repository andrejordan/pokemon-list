//
//  PokemonListViewController.swift
//  iOSBaseProject
//
//  Created by Karen Pinzas Morrongiello on 2022-01-05.
//

import UIKit

class PokemonListViewController: UIViewController {
	private let tableView = UITableView()
	private var pokemons = [Pokemon]()
	private let loadingIndicator = UIActivityIndicatorView()
	private var showActivityIndicator: Bool = true {
		didSet {
			if showActivityIndicator {
				loadingIndicator.startAnimating()
			} else {
				loadingIndicator.stopAnimating()
			}
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = "List of Pokemons"
		setupTableView()
		setupLoadingIndicator()
		loadCharacters()
	}
	
	private func setupLoadingIndicator() {
		loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
		loadingIndicator.hidesWhenStopped = true
		loadingIndicator.style = .medium
		view.addSubview(loadingIndicator)
		
		NSLayoutConstraint.activate([
			loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
		])
	}
	
	private func setupTableView() {
		tableView.separatorColor = .clear
		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableView)
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
		
		tableView.dataSource = self
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 44.0
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
	}
	
	private func showErrorAlert() {
		let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
		self.present(alert, animated: true, completion: nil)
	}
	
	private func loadCharacters() {
		let configuration = URLSessionConfiguration.default
		let session = URLSession(configuration: configuration)
		guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=50") else { return }
		
		showActivityIndicator = true
		
		session.dataTask(with: url) { [weak self] data, response, error in
			DispatchQueue.main.async {
				self?.showActivityIndicator.toggle()
				
				if let _ = error {
					self?.showErrorAlert()
				}
							
				if let data = data {
					do {
						let decoder = JSONDecoder()
						let pokemonResponse = try decoder.decode(PokemonServiceResponse.self, from: data)
						self?.pokemons = pokemonResponse.results
						self?.tableView.reloadData()
					} catch {
						self?.showErrorAlert()
					}
				}
			}
		}.resume()
	}
}

extension PokemonListViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return pokemons.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = pokemons[indexPath.row].name.capitalized
		return cell
	}
}
