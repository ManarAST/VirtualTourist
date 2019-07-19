//
//  ViewController.swift
//  VirtualTourist
//
//  Created by manar AL-Towaim on 26/06/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate{

    @IBOutlet weak var map: MKMapView!
    
    var fetchedResultController: NSFetchedResultsController<Pin>!
    var context: NSManagedObjectContext{
        return DataController.shard.viewContaxt
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultController = nil
    }
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
           updateMap()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

    
    func updateMap (){
        guard let pins = fetchedResultController.fetchedObjects else {
            print("coud not fetch pins")
            return
        }
      
        for pin in pins {
            if map.annotations.contains(where: { pin.compare(coordinate: $0.coordinate) }) {continue}
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coordinate
            map.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
       
        let pin = fetchedResultController.fetchedObjects?.filter {
            $0.compare(coordinate: view.annotation!.coordinate)
            }.first!
        
        performSegue(withIdentifier: "toPhotos", sender: pin)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotos" {
            let controller = segue.destination as! PhotosViewController
            controller.pin = sender as? Pin
        }
    }
    
    
    
    
    @IBAction func LongPressAction(_ sender: UILongPressGestureRecognizer) {
        if sender.state != .began {return}
        
        let location = sender.location(in: map)
        let pin = Pin(context: context)
        pin.coordinate = map.convert(location, toCoordinateFrom: map)
        try? context.save()
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateMap()
    }
    
   
    
    


}

