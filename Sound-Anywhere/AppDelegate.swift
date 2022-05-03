//
//  AppDelegate.swift
//  Sound-Anywhere
//
//  Created by 오현식 on 2022/03/21.
//

import CoreLocation
import UIKit

import Common
import Data
import Domain
import Presentation
import Resource

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        registerDependencies()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration",
                                    sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
    }
    
    private func registerDependencies() {
        let locationService = CLLocationService()
        
        let queryCLLocationServiceUseCase = DefaultQueryCLLocationServiceUseCase(locationService: locationService)
        let commandCLLocationServiceUseCase = DefaultCommandCLLocationServiceUseCase(locationService: locationService)
        
        let firestore = FakeFirestore<ZoneDTO>()
        let zoneRepository = DefaultZoneRepository<FakeFirestore<ZoneDTO>>(firestore: firestore)

        if let data = Resource.Dummy.zone,
           let dummy = try? JSONDecoder().decode([ZoneDTO].self, from: data) {
            zoneRepository.setDummy(dummy: dummy)
        }
        
        let queryZoneUseCase = DefaultQueryZoneUseCase(zoneRepository: zoneRepository)
    
        let mapViewModel = MapViewModel(dependencies: .init(
            defaultLocation: CLLocation(latitude: 37.54330366639085,
                                        longitude: 127.04455548501139),
            queryCLLocationServiceUseCase: queryCLLocationServiceUseCase,
            commandCLLocationServiceUseCase: commandCLLocationServiceUseCase,
            queryZoneUseCase: queryZoneUseCase))
        
        DIContainer.shared.register(dependency: mapViewModel)
    }
}
