//
//  Functions.swift
//  ProjectTest
//
//  Created by Mariam Khan on 4/13/21.
//

import Foundation

// Helps Find Paths for Application
let applicationDocumentsDirectory: URL = {
  let paths = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask)
  return paths[0]
}()
