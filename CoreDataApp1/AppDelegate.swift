//
//  AppDelegate.swift
//  CoreDataApp1
//
//  Created by Denis Voronov on 27/07/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let tumblrUrl = URL(string: "http://api.tumblr.com/v2/blog/rockcult.tumblr.com/posts?api_key=epkeOJk6wRxp6DW1PMg4t3D6Spom46067rCD2zFKgOj6WLJJU7&limit=20&offset=0")!

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        applicationDocumentsDirectory()
        
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        loadData()
        
        return true
    }
    
    func loadData() {
        let dataTask = URLSession.shared.dataTask(with: AppDelegate.tumblrUrl) {data, response, error in
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject] {
                    print("\(String(describing: json))")
                }
                if let data = data {
                    let decoder = JSONDecoder()
                    let tumblrRoot = try decoder.decode(TumblrRoot.self, from: data)
                    print("\(String(describing: tumblrRoot))")
                    
                    for tumblrPost in tumblrRoot.response.posts {
                        if self.createTumblrPostEntity(from: tumblrPost) != nil {
                            
                        }
                    }
                    
                    self.saveContext()
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    @discardableResult
    func createTumblrPostEntity(from tumblrPost: TumblrPost) -> ETumblrPost? {
        let context = persistentContainer.viewContext
        if let entity = NSEntityDescription.insertNewObject(forEntityName: "ETumblrPost", into: context) as? ETumblrPost {
            entity.id = tumblrPost.id
            entity.blogName = tumblrPost.blog_name
            entity.caption = tumblrPost.caption
            entity.imagePermalink = tumblrPost.image_permalink.absoluteString
            return entity
        }
        return nil
    }
    
    func applicationDocumentsDirectory() {
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CoreDataApp1")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

