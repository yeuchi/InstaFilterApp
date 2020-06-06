//
//  FilterParams.swift
//  InstaFilter
//
//  Created by yeuchi on 6/4/20.
//  Copyright © 2020 yeuchi. All rights reserved.
//

import Foundation

/*
  * Description: My Insta Filter assignment - 3x3 spatial convolution filter
  * Author: Chi Yeung
  * Date: June 2, 2020
  */

 /*
  * STEP 3: Create the image processor
  * a. Encapsulate your chosen Filter parameters and/or formulas in a struct/class definition.
  *
  * b. Create and test an ImageProcessor class/struct to manage an arbitrary number Filter instances to apply to an image. It should allow you to specify the order of application for the Filters.
  */
 enum KernelType {
     case xSobel
     case ySobel
     case sharpen
     case blur
     case identity
 }

 /*
  * The formula should have parameters that can be modified so that the filter can have a small or large effect on the image.
  */
 enum EffectLevel {
     case small
     case large
 }

struct FilterParams {
       /*
        * Rubric:
        * Is there an interface to apply specific default filter formulas/parameters to an image, by specifying each configuration’s name as a String? Maximum of 2 pts
        *
        * Are there parameters for each filter formula that can change the intensity of the effect of the filter? Maximum of 3 pts
        */
       var listKernel:[KernelType] = []
       var effectLevel:EffectLevel = EffectLevel.small
       
       /*
        * STEP 4: Create predefined filters
        * - Create five reasonable default Filter configurations
        *
        * Define 3x3 kernels (could be different size 5x5, 7x7.. but too slow)
        * Sobel: derivatives
        * sharpen: laplacian + identity
        * blur: average
        */
       private let identity: [[Int]] = [[0, 0, 0], [0, 1, 0], [0, 0, 0]]
       private let xSobel_small: [[Int]] = [[0, 0, 0], [0, 1, -1], [0, 0, 0]]
       private let xSobel_large: [[Int]] = [[0, 1, -1], [0, 1, -1], [0, 1, -1]]
       private let ySobel_small: [[Int]] = [[0, 0, 0], [0, 1, 0], [0, -1, 0]]
       private let ySobel_large: [[Int]] = [[0, 0, 0], [1, 1, 1], [-1, -1, -1]]
       private let sharpen_small: [[Int]] = [[-1, -1, -1], [-1, 14, -1], [-1, -1, -1]]
       private let sharpen_large: [[Int]] = [[-1, -1, -1], [-1, 10, -1], [-1, -1, -1]]
       private let blur_small: [[Int]] = [[1, 1, 1], [1, 5, 1], [1, 1, 1]]
       private let blur_large: [[Int]] = [[1, 1, 1], [1, 1, 1], [1, 1, 1]]

    
    func getKernel(type:KernelType) -> [[Int]] {
        switch(type) {
        case KernelType.xSobel:
            return effectLevel == EffectLevel.small ? xSobel_small : xSobel_large
            
        case KernelType.ySobel:
            return effectLevel == EffectLevel.small ? ySobel_small : ySobel_large
            
        case KernelType.sharpen:
            return effectLevel == EffectLevel.small ? sharpen_small : sharpen_large
            
        case KernelType.identity:
            return identity
            
        case KernelType.blur:
            return effectLevel == EffectLevel.small ? blur_small : blur_large
        }
    }
}
