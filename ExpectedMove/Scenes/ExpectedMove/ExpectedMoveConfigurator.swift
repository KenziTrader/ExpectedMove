//
//  ExpectedMoveConfigurator.swift
//  ExpectedMove
//
//  Created by Rene Laterveer on 6/8/16.
//  Copyright (c) 2016 Rene Laterveer. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: Connect View, Interactor, and Presenter

extension ExpectedMoveViewController: ExpectedMovePresenterOutput
{
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    router.passDataToNextScene(segue)
  }
}

extension ExpectedMoveInteractor: ExpectedMoveViewControllerOutput
{
}

extension ExpectedMovePresenter: ExpectedMoveInteractorOutput
{
}

class ExpectedMoveConfigurator
{
  // MARK: Object lifecycle
  
  class var sharedInstance: ExpectedMoveConfigurator
  {
    struct Static {
      static var instance: ExpectedMoveConfigurator?
      static var token: dispatch_once_t = 0
    }
    
    dispatch_once(&Static.token) {
      Static.instance = ExpectedMoveConfigurator()
    }
    
    return Static.instance!
  }
  
  // MARK: Configuration
  
  func configure(viewController: ExpectedMoveViewController)
  {
    let router = ExpectedMoveRouter()
    router.viewController = viewController
    
    let presenter = ExpectedMovePresenter()
    presenter.output = viewController
    
    let interactor = ExpectedMoveInteractor()
    interactor.output = presenter
    
    viewController.output = interactor
    viewController.router = router
  }
}