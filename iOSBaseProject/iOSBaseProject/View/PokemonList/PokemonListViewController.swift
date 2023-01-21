//
//  PokemonListViewController.swift
//  iOSBaseProject
//
//  Created by Karen Pinzas Morrongiello on 2022-01-05.
//

import UIKit

class PokemonListViewController: UIViewController {
    
    private let viewModel: PokemonViewModel
	private let tableView = UITableView()
	private let loadingIndicator = UIActivityIndicatorView()
    
    // MARK: Initializers
    init(withViewModel viewModel: PokemonViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = "List of Pokemons"
        bind()
        viewModel.getPokemonList()
		setupTableView()
		setupLoadingIndicator()
	}
    
    override func viewWillDisappear(_ animated: Bool) {
        unbind()
    }
    
    // MARK: Bind to Observables
    private func bind() {
        viewModel.isLoading.addAndNotify(observer: self) { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
        }
        viewModel.pokemonList.addAndNotify(observer: self) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    private func unbind() {
        viewModel.isLoading.removeObserver(self)
        viewModel.pokemonList.removeObserver(self)
    }
	
    // MARK: Setup Subviews
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
        tableView.delegate = self
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 44.0
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
	}
}

// MARK: UITableView Datasource & Delegate
extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemonList.value.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.pokemonList.value[indexPath.row].name.capitalized
		return cell
	}
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.paginateIfNeeded(indexPath.row)
    }
    
}
