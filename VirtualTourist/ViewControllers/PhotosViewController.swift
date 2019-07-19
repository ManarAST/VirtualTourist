//
//  PhotosViewController.swift
//  VirtualTourist
//
//  Created by manar AL-Towaim on 12/07/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class PhotosViewController: UIViewController, UICollectionViewDelegate,  UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var morePhotosButton: UIBarButtonItem!
    @IBOutlet weak var noPhotosLabel: UILabel!
    
    
    
    var pin: Pin!
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var context: NSManagedObjectContext {
        return DataController.shard.viewContaxt
    }

    var pageNumber = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        fetchedResultsController = nil
    }
    

    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptors]
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            if fetchedResultsController.fetchedObjects?.count == 0 {
               morePhotosTapped(self)
            } else {
                UIisBusy(false)
            }
         
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        collectionView.reloadData()
    }
    
    @IBAction func morePhotosTapped(_ sender: Any) {
        UIisBusy(true)
        if fetchedResultsController.fetchedObjects?.count != 0 {
            
            for photo in fetchedResultsController.fetchedObjects! {
                context.delete(photo)
                pageNumber += 1
                
            }
            
            try? context.save()
        }
        
        FlickrAPI.getPhotoURLs(by: pin.coordinate, pageNumber: pageNumber) { (urls, easyError) in
            DispatchQueue.main.async {
                self.UIisBusy(false)
                
                guard easyError == nil else {
                    self.alert(title: "ERROR!", message: easyError?.message)
                    return
                }
                
                guard let urls = urls, !urls.isEmpty else {
                    self.noPhotosLabel.isHidden = false
                    return
                }
                for url in urls {
                    let photo = Photo(context: self.context)
                    photo.imageURL = url
                    photo.pin = self.pin
                    photo.loadImage(url: url, completion: { (image, easyError) in
                        if easyError != nil {
                            print(easyError!.message)
                            return
                        }
                       photo.set(image: image!)
                    })
                }
                try? self.context.save()
            }
        }
        
    }
    

    func UIisBusy (_ busy: Bool) {
        if busy {
            morePhotosButton.isEnabled = false
            activityIndicator.startAnimating()
        } else {
            morePhotosButton.isEnabled = true
            activityIndicator.stopAnimating()
        }
    }
    
    //    MARK: CollectionViewDelegate & Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotosViewCell
        let photoData = fetchedResultsController.object(at: indexPath)
        let photo = photoData.getPhoto()
        cell.imageView.image = photo
        try? context.save()
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = fetchedResultsController.object(at: indexPath)
        context.delete(photo)
        try? context.save()
    }
    
   
    
    //    MARK: NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        
   
            collectionView.reloadData()
        
    }
    
}
