//
//  SceneDelegate.swift
//  Sound-Anywhere
//
//  Created by 오현식 on 2022/03/21.
//

import CoreLocation
import UIKit

import Data
import Domain
import Presentation
import Resource
import RxCommon
import UI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private lazy var mapViewModel: MapViewModelType = {
        let locationService = CLLocationService()
        
        let queryCLLocationServiceUseCase = DefaultQueryCLLocationServiceUseCase(locationService: locationService)
        let commandCLLocationServiceUseCase = DefaultCommandCLLocationServiceUseCase(locationService: locationService)
        
        var firestore: FirestoreType
        #if DEBUG
            firestore = FakeFirestore()
        #else
            firestore = DefaultFireStore()
        #endif

        let zoneRepository = DefaultZoneRepository(firestore: firestore)

        if let data = Resource.Dummy.zone,
           let dummy = try? JSONDecoder().decode([ZoneDTO].self, from: data) {
            zoneRepository.setDummy(dummy: dummy)
        }
        
        let queryZoneUseCase = DefaultQueryZoneUseCase(zoneRepository: zoneRepository)
      
        return MapViewModel(defaultLocation: CLLocation(latitude: 37.54887101,
                                                        longitude: 126.91332598),
                            queryCLLocationServiceUseCase: queryCLLocationServiceUseCase,
                            commandCLLocationServiceUseCase: commandCLLocationServiceUseCase,
                            queryZoneUseCase: queryZoneUseCase)
        
    }()
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        configureWindow(windowScene)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

    // MARK: - Private Methods
    
    private func configureWindow(_ windowScene: UIWindowScene) {
        let storyboard = Resource.Storyboard(id: .map)
        let mapViewController: MapViewController = storyboard.instance()
        mapViewController.viewModel = mapViewModel
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = mapViewController
        window?.makeKeyAndVisible()
    }
}
