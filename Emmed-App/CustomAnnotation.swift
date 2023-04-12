//
//  CustomAnnotation.swift
//  Emmed-App
//
//  Created by vorawit chenthulee on 12/4/2566 BE.
//

import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var dustValue: Int

    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, dustValue: Int) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.dustValue = dustValue
    }
}
