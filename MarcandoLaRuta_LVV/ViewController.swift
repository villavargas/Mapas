//
//  ViewController.swift
//
//  Created by Luis Alejandro Villa Vargas
//  Copyright © 2016 personal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
  
  @IBOutlet weak var moverme: UISwitch!
  @IBOutlet weak var mapa: MKMapView!
  @IBOutlet weak var selector: UISegmentedControl!
    
  private let mi_manejador = CLLocationManager()
  var existe_origen:Bool = false
  var inicial:CLLocation?
  var punto = 0
  


  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedWhenInUse {
      mi_manejador.startUpdatingLocation()
      mapa.showsUserLocation = true
    } else {
      mi_manejador.stopUpdatingLocation()
      mapa.showsUserLocation = false
    }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
   
    if let latitude = manager.location?.coordinate.latitude, let longitude = manager.location?.coordinate.longitude {
      
      if !existe_origen {
        inicial = CLLocation(latitude: latitude, longitude: longitude)
        existe_origen = true
      }
      
      let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
      
      let pin = MKPointAnnotation()
      pin.coordinate = center
      pin.title = ("Latitud: ~ \(Double(round(latitude*100/100))), Longitud: ~ \(Double(round(longitude*100/100)))")
      if let punto = inicial {
        pin.subtitle = "Distancia recorrida: \(Double(round(manager.location!.distanceFromLocation(punto)*100)/100))"
      } else {
        print("no hay origen")
      }
      
      self.mapa.addAnnotation(pin)
      self.mapa.setRegion(region, animated: true)
    } else {
      let alert = UIAlertController(title: "Error", message: "No se puede localizar", preferredStyle: UIAlertControllerStyle.ActionSheet)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
      }))
      
    }
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    print("\(error)")
  }
  
    @IBAction func mapSatellite(sender: AnyObject) {
         mapa.mapType = .Satellite
    }
    @IBAction func MapStandard(sender: AnyObject) {
        mapa.mapType = .Standard
    }
    
    @IBAction func mapHybri(sender: AnyObject) {
        mapa.mapType = .Hybrid
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mi_manejador.delegate = self
        mi_manejador.desiredAccuracy = kCLLocationAccuracyBest
        mi_manejador.distanceFilter = 50.0
        mi_manejador.requestWhenInUseAuthorization()
        
        var punto = CLLocationCoordinate2D()
        
        mapa.delegate = self
        
        if let latitude = mi_manejador.location?.coordinate.latitude, let longitude = mi_manejador.location?.coordinate.longitude {
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapa.setRegion(region, animated: true)
            
            punto.longitude = longitude
            punto.latitude = latitude
            
            let inicioPin:MKPointAnnotation = MKPointAnnotation()
            inicioPin.title = "Inicio!"
            inicioPin.coordinate = punto
            mapa.addAnnotation(inicioPin)
            
        } else {
            let alert = UIAlertController(title: "Error", message: "No se puede localizar", preferredStyle: UIAlertControllerStyle.ActionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
            }))
            
        }
        
    }
    
  
  
  
}

