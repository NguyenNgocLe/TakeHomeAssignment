//
//  ListUserViewController.swift
//  TakeHome
//
//  Created by Le on 17/5/25.
//

import UIKit

class ListUserViewController<VM: ListUserViewModelType>: BaseViewController<VM>,
                                                         UITableViewDelegate, UITableViewDataSource {
    // MARK: - Views
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(UINib(nibName: UserTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    // MARK: - LifeCycle
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        navigationItem.backButtonTitle = ""
    }
    
    // MARK: - Setup Views constraint layout tableView
    private func setupViews() {
        title = CommonString.githubUser
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Properties & Init
    private let hud: CustomHudType
    
    // MARK: - Init
    init(viewModel: VM, hud: CustomHudType = CustomHud.shared) {
        self.hud = hud
        super.init(viewModel: viewModel)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// fetch list user information
    func fetchData() {
        hud.showHud(message: nil)
        viewModel.fetchUsers()
        
        viewModel.getListUsersSuccessHandler = { [weak self] in
            self?.hud.hideHud()
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.getListUsersFailureHandler = { [weak self] error in
            self?.hud.hideHud()
            DispatchQueue.main.async {
                self?.handleError(error, showingAlert: true)
            }
        }
    }
    
    // MARK: - TableView & Config
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithClassName(with: UserTableViewCell.self, for: indexPath)
        if let model = viewModel.getUser(at: indexPath.row) {
            let userCell = UserCellModel(imageViewURL: model.avatar_url, name: model.login)
            cell.setupData(model: userCell)
        } else {
            CustomLogs.log("Can not get user at index Path \(indexPath.row)")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = viewModel.getUser(at: indexPath.row) {
            let userModel = UserDetailsModel(imageViewURL: model.avatar_url, name: model.login)
            let vc = DetailsUserViewController(viewModel: DetailsUserViewModel(userDetailsModel: userModel))
            navigationController?.pushViewController(vc, animated: true)
        } else {
            CustomLogs.log("Can't navigate details user screen!")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
