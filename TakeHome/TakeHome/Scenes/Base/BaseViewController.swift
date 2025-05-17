//
//  BaseViewController.swift
//  TakeHome
//
//  Created by Le on 17/5/25.
//

import UIKit

class BaseViewController<VM: BaseViewModelType>: UIViewController {
    let viewModel: VM
    var alert: CustomAlertType
    
    init(viewModel: VM, alert: CustomAlertType = CustomAlert.shared) {
        self.viewModel = viewModel
        self.alert = alert
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleError(_ error: CustomError, showingAlert: Bool) {
        switch error {
            
        default:
            break
        }
        if showingAlert {
            alert.showAlertOneButton(self, title: CommonString.error,
                                     message: error.localizedDescription,
                                     buttonTitle: CommonString.ok, handler: nil)

        }
    }

    deinit {
        print("\(self.className) is deallocated")
    }
}
