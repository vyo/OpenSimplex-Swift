import Foundation
import ImageIO
import CoreServices
import OpenSimplexNoise


public final class CLI {
    private let arguments: [String]
    
    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }
    
    public func run() throws {
        print("Hello world")
        let width = 64
        let widthTime = 64
        let height = 64
        let heightTime = 64
        let featureSize = 32.0
        
        let noise = OpenSimplexNoise()
        
        var pixels = [UInt8](repeating: 0, count: width * height * 4)
        
        //        for w in 0..<heightTime {
        //        for z in 0..<widthTime {
        for y in 0..<height {
            for x in 0..<width {
                let value = noise.eval(
                    x: Double(x) / featureSize,
                    y: Double(x) / featureSize,
                    z: Double(x) / featureSize,
                    w: Double(y) / featureSize
                )
                let rgb = UInt8((value + 1) * 127.5)
                pixels[(y * width + x) * 4 + 0] = 255
                pixels[(y * width + x) * 4  + 1] = rgb
                pixels[(y * width + x) * 4  + 2] = rgb
                pixels[(y * width + x) * 4  + 3] = rgb
            }
        }
        //            }
        //        }
        
        // let render = CGColorRenderingIntent.RenderingIntentDefault
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let providerRef = CGDataProvider.init(data: NSData(bytes: pixels, length: width * height * 4))
        let cgImage = CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: width * 4, space: rgbColorSpace, bitmapInfo: bitmapInfo, provider: providerRef!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
        
        if let cgImage = cgImage {
            let url = CFURLCreateWithString(
                nil,
                "file:///tmp/swiftNoise.png" as CFString,
                nil
            )!
            if let destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, nil) {
                CGImageDestinationAddImage(destination, cgImage, nil)
                CGImageDestinationFinalize(destination)
            }
        }
    }
}
