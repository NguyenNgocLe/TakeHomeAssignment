//
//  DetailsUserViewController.swift
//  TakeHome
//
//  Created by Le on 17/5/25.
//

import UIKit

class DetailsUserViewController<VM: DetailsUserViewModelType>: BaseViewController<VM> {
    // MARK: - Views
    private lazy var informationView: DetailsUser = {
        let view = DetailsUser()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.contentMode = .scaleToFill
        stack.spacing = 80
        return stack
    }()
    
    private lazy var followerStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .fill
        stack.axis = .vertical
        stack.contentMode = .scaleToFill
        stack.spacing = 0
        return stack
    }()
    
    private lazy var followerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var followerImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "person.2.circle.fill")
        view.contentMode = .scaleAspectFit
        view.tintColor = .blue
        return view
    }()
    
    private lazy var numberFollowerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var followerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = CommonString.follower
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var followingStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 1
        return stack
    }()
    
    private lazy var followingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var followingImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "person.fill.checkmark")
        view.contentMode = .scaleAspectFit
        view.tintColor = .blue
        return view
    }()
    
    private lazy var numberFollowingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = CommonString.following
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    private lazy var titleBlogLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = CommonString.blog
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var blogLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        return label
    }()
    
    // MARK: - Properties
    private let hud: CustomHudType
    
    // MARK: - Init
    init(viewModel: VM, hud: CustomHudType = CustomHud.shared) {
        self.hud = hud
        super.init(viewModel: viewModel)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        title = CommonString.detailsUser
        fetchUserDetails()
    }
    
    /// Fetch user details
    ///  - Call All UserInformation Success
    ///  - Call InformationFailed
    func fetchUserDetails() {
        Task {
            self.hud.showHud(message: nil)
            await viewModel.getUserFollowingAndFollower()
        }
        getAllUserInformationSuccess()
        getInformationFailed()
    }
    
    /// Handle UI Information Success
    func getAllUserInformationSuccess() {
        viewModel.getAllInfoSuccess = { [weak self] data in
            self?.hud.hideHud()
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateUI(with: data)
            }
        }
    }
    
    /// Handle UI Information Failed
    func getInformationFailed() {
        viewModel.getDataFailedHandler = { [weak self] error in
            self?.hud.hideHud()
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.handleError(error, showingAlert: true)
            }
        }
    }
    
    /// Update UI Information Text
    func updateUI(with details: DetailsUserModel) {
        numberFollowerLabel.text = "\(details.numberFollower)"
        numberFollowingLabel.text = "\(details.numberFollowing)"
        blogLabel.text = details.blog
        informationView.setLocationValue(value: details.location)
    }

    /// Setup constraints layout
    private func setupViews() {
        view.addSubview(informationView)
        view.addSubview(contentInfoStackView)
        contentInfoStackView.addArrangedSubview(followerStackView)
        contentInfoStackView.addArrangedSubview(followingStackView)
        followerStackView.addArrangedSubview(followerView)
        followerView.addSubview(followerImageView)
        followerStackView.addArrangedSubview(numberFollowerLabel)
        followerStackView.addArrangedSubview(followerLabel)
        
        followingStackView.addArrangedSubview(followingView)
        followingView.addSubview(followingImageView)
        followingStackView.addArrangedSubview(numberFollowingLabel)
        followingStackView.addArrangedSubview(followingLabel)
        
        view.addSubview(titleBlogLabel)
        view.addSubview(blogLabel)
        constraintLayout()
    }
    
    /// Constraint element inherit
    private func constraintLayout() {
        NSLayoutConstraint.activate([
            informationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            informationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            informationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            informationView.heightAnchor.constraint(equalToConstant: 156),
            
            contentInfoStackView.topAnchor.constraint(equalTo: informationView.bottomAnchor, constant: 24),
            contentInfoStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        constraintFollowerImageView()
        constraintFollowingImageView()
        constraintTitle()
        informationView.setupView(model: viewModel.getUserDetailsModel())
    }
    
    /// Constraint layout FollowerImageView
    private func constraintFollowerImageView() {
        NSLayoutConstraint.activate([
            followerImageView.widthAnchor.constraint(equalToConstant: 70),
            followerImageView.heightAnchor.constraint(equalToConstant: 70),
            followerImageView.topAnchor.constraint(equalTo: followerView.topAnchor),
            followerImageView.leadingAnchor.constraint(equalTo: followerView.leadingAnchor, constant: 8),
            followerImageView.trailingAnchor.constraint(equalTo: followerView.trailingAnchor),
            followerImageView.bottomAnchor.constraint(equalTo: followerView.bottomAnchor)
        ])
    }
    
    /// Constraint layout FollowingImageViews
    private func constraintFollowingImageView() {
        NSLayoutConstraint.activate([
            followingImageView.widthAnchor.constraint(equalToConstant: 70),
            followingImageView.heightAnchor.constraint(equalToConstant: 70),
            followingImageView.topAnchor.constraint(equalTo: followingView.topAnchor),
            followingImageView.leadingAnchor.constraint(equalTo: followingView.leadingAnchor, constant: 8),
            followingImageView.trailingAnchor.constraint(equalTo: followingView.trailingAnchor),
            followingImageView.bottomAnchor.constraint(equalTo: followingView.bottomAnchor),
            numberFollowingLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    /// Constraint layout FollowerImageView
    private func constraintTitle() {
        NSLayoutConstraint.activate([
            titleBlogLabel.topAnchor.constraint(equalTo: contentInfoStackView.bottomAnchor, constant: 16),
            titleBlogLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            blogLabel.topAnchor.constraint(equalTo: titleBlogLabel.bottomAnchor, constant: 16),
            blogLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
}
