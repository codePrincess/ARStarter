//
//  Planet.swift
//  solarsystem
//
//  Created by Romain on 14/03/2018.
//  Copyright © 2018 Romain. All rights reserved.
//

import UIKit


class Planet {
	
	var name : String
	var radius : CGFloat
	var rotation : CGFloat
	var color : UIColor
	var distance : Float
	
	init(name : String, radius : CGFloat, rotation : CGFloat, color : UIColor, distance : Float) {
		self.name = name
		self.radius = radius
		self.rotation = rotation
		self.color = color
		self.distance = distance
	}
	
}
