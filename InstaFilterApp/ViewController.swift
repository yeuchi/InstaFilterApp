//
//  ViewController.swift
//  InstaFilterApp
//
//  Created by yeuchi on 6/4/20.
//  Copyright © 2020 yeuchi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var myRGBA:RGBAImage? = nil
    var image:UIImage?=nil
    
    @IBOutlet weak var btnConvolve: UIButton!
    @IBOutlet weak var btnHighlight: UIButton!
    @IBOutlet weak var imageViewSource: UIImageView!
    @IBOutlet weak var imageViewHighlight: UIImageView!
    @IBOutlet weak var imageViewConvolve: UIImageView!
    
    
    @IBAction func onHighlight(_ sender: UIButton) {
        btnHighlight.isSelected = true
        runRedHighlight()
    }
    
    @IBAction func onConvolve(_ sender: UIButton) {
        btnConvolve.isSelected = true
        runInstaFilter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image = UIImage(named: "sample")
        imageViewSource.image = self.image
    }
    
    func runRedHighlight() {
            // Process the image!
            self.myRGBA = RGBAImage(image:self.image!)!
            
            let x=10
            let y=10

            let index = y * self.myRGBA!.width + x
            var pixel = self.myRGBA!.pixels[index]

            // edit 1 pixel
            pixel.red = 255
            pixel.green = 0
            pixel.blue = 0
            self.myRGBA!.pixels[index] = pixel

            // find mean pixel value
            var totalRed = 0
            var totalGreen = 0
            var totalBlue = 0

            for y in 0..<self.myRGBA!.height {
                for x in 0..<self.myRGBA!.width {
                    let i = y * self.myRGBA!.width + x
                    var pix = self.myRGBA!.pixels[i]
                
                    totalRed += Int(pix.red)
                    totalGreen += Int(pix.green)
                    totalBlue += Int(pix.blue)
                }
            }

            let count = self.myRGBA!.width * self.myRGBA!.height
            let meanRed = totalRed / count
            let meanGreen = totalGreen / count
            let meanBlue = totalBlue / count
            // mean: R=119, G=98, B=83

            // Red highlight filter
            for y in 0..<self.myRGBA!.height {
                for x in 0..<self.myRGBA!.width {
                    let i = y * self.myRGBA!.width + x
                    var pix = self.myRGBA!.pixels[i]
                
                    let redDiff = Int(pix.red) - meanRed
                    if(redDiff>0){
                        pix.red = UInt8(max(0, min(255, meanRed+redDiff*5)))
                        self.myRGBA!.pixels[i] = pix
                    }
                }
            }
            let redImage = self.myRGBA!.toUIImage()
            imageViewHighlight.image = redImage
        }
            
        func runInstaFilter() {
            
            self.myRGBA = RGBAImage(image:self.image!)!
            
            /*
             * STEP 5: Apply predefined filters
             * In the ImageProcessor interface create a new method to apply a predefined filter giving its name as a String parameter. The ImageProcessor interface should be able to look up the filter and apply it.
             *
             * !! User may add N filters in sequential processing !!
             *
             * Rubric:
             * Is there an interface to specify the order and parameters for an arbitrary number of filter calculations that should be applied to an image? Maximum of 2 pts
             *
             * User may add N arbitrary kernels (filters) below.
             * User may edit effect level below
             */
            var params = FilterParams()
            params.effectLevel = EffectLevel.small
            params.listKernel.append(KernelType.sharpen)
            //params.listKernel.append(KernelType.blur)
            //params.listKernel.append(KernelType.xSobel)
            //params.listKernel.append(KernelType.ySoble)

            for k in 0..<params.listKernel.count {
                
                // iterate through all selected kernels
                let kernelType = params.listKernel[k]
                let filter = params.getKernel(type:kernelType)

                // Denominator: find kernel sum
                var denominator = 0
                for cy in 0..<3 {
                    for cx in 0..<3 {
                        denominator += filter[cx][cy]
                    }
                }
                if(denominator == 0) {
                    denominator = 1
                }
                else if (denominator < 0) {
                    denominator *= -1
                }

                /*
                 * Rubric:
                 * Does the playground code apply a filter to each pixel of the image? Maximum of 2 pts
                 */
                for y in 0..<self.myRGBA!.height {
                    for x in 0..<self.myRGBA!.width {
                        var sumRed = 0
                        var sumGreen = 0
                        var sumBlue = 0
                        
                        // integrate, convolve with kernel (index -1 -> 1)
                        for cy in 0..<3 {
                            for cx in 0..<3 {
                                
                                // constraint pixel index -> in bound
                                var yy = y + cy - 1
                                if(yy < 0){
                                    yy = 0
                                }
                                else if (yy >= self.myRGBA!.height) {
                                    yy = self.myRGBA!.height-1
                                }
                                
                                var xx = x + cx - 1
                                if(xx < 0){
                                    xx = 0
                                }
                                else if (xx >= self.myRGBA!.width) {
                                    xx = self.myRGBA!.width-1
                                }
                                
                                // do integration
                                let i = yy * self.myRGBA!.width + xx
                                let pix = self.myRGBA!.pixels[i]
                                sumRed += Int(pix.red) * filter[cx][cy]
                                sumGreen += Int(pix.green) * filter[cx][cy]
                                sumBlue += Int(pix.blue) * filter[cx][cy]
                            }
                        }
                        let ii = y * self.myRGBA!.width + x
                        self.myRGBA!.pixels[ii].red = UInt8(max(0, min(255, sumRed/denominator)))
                        self.myRGBA!.pixels[ii].green = UInt8(max(0, min(255, sumGreen/denominator)))
                        self.myRGBA!.pixels[ii].blue = UInt8(max(0, min(255, sumBlue/denominator)))
                    }
                }
                let convolvedImage = self.myRGBA!.toUIImage()
                imageViewConvolve.image = convolvedImage
                //newImage2
            }

        }
    }
