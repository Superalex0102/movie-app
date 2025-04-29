//
//  AlertModel.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 29..
//

import Foundation
 
 struct AlertModel: Identifiable {
     let id = UUID()
     let title: String
     let message: String
     let dismissButtonTitle: String
 }
