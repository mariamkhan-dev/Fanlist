//
//  Functions.swift
//  ProjectTest
//
//  Created by mk on 4/13/21.
//

import Foundation

let applicationDocumentsDirectory: URL = {
  let paths = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask)
  return paths[0]
}()
