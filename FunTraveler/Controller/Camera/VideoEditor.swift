//
//  VideoEditor.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/23.
//

import UIKit
import AVFoundation

class VideoEditor {
    
    func makeCustomEffect(fromVideoAt videoURL: URL, onComplete: @escaping (URL?) -> Void) {
        let asset = AVURLAsset(url: videoURL)
        let composition = AVMutableComposition()
        
        guard let compositionTrack = composition.addMutableTrack(
                withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid),
            let assetTrack = asset.tracks(withMediaType: .video).first
        else {
            print("Something is wrong with the asset.")
            onComplete(nil)
            return
        }
        
        do {
            let timeRange = CMTimeRange(start: .zero, duration: asset.duration)
            try compositionTrack.insertTimeRange(timeRange, of: assetTrack, at: .zero)
            
            if let audioAssetTrack = asset.tracks(withMediaType: .audio).first,
               let compositionAudioTrack = composition.addMutableTrack(
                withMediaType: .audio,
                preferredTrackID: kCMPersistentTrackID_Invalid) {
                try compositionAudioTrack.insertTimeRange(
                    timeRange,
                    of: audioAssetTrack,
                    at: .zero)
            }
        } catch {
            print(error)
            onComplete(nil)
            return
        }
        
        compositionTrack.preferredTransform = assetTrack.preferredTransform
        let videoInfo = orientation(from: assetTrack.preferredTransform)
        
        let videoSize: CGSize
        if videoInfo.isPortrait {
            videoSize = CGSize(
                width: assetTrack.naturalSize.height,
                height: assetTrack.naturalSize.width)
        } else {
            videoSize = assetTrack.naturalSize
        }

        let backgroundLayer = CALayer()
        backgroundLayer.frame = CGRect(origin: .zero, size: videoSize)
        let videoLayer = CALayer()
        videoLayer.frame = CGRect(origin: .zero, size: videoSize)
        let overlayLayer = CALayer()
        overlayLayer.frame = CGRect(origin: .zero, size: videoSize)
        
        backgroundLayer.backgroundColor = UIColor.white.cgColor
    
        videoLayer.frame = CGRect(
            x: 20,
            y: 20,
            width: videoSize.width - 60,
            height: videoSize.height - 60)
        
        backgroundLayer.contentsGravity = .resizeAspectFill
        
        addImage(to: overlayLayer, videoSize: videoSize)

        let outputLayer = CALayer()
        outputLayer.frame = CGRect(origin: .zero, size: videoSize)
        outputLayer.addSublayer(backgroundLayer)
        outputLayer.addSublayer(videoLayer)
        outputLayer.addSublayer(overlayLayer)
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = videoSize
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(
            postProcessingAsVideoLayer: videoLayer,
            in: outputLayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(
            start: .zero,
            duration: composition.duration)
        videoComposition.instructions = [instruction]
        let layerInstruction = compositionLayerInstruction(
            for: compositionTrack,
               assetTrack: assetTrack)
        instruction.layerInstructions = [layerInstruction]
        
        guard let export = AVAssetExportSession(
            asset: composition,
            presetName: AVAssetExportPresetHighestQuality)
        else {
            print("Cannot create export session.")
            onComplete(nil)
            return
        }
        
        let videoName = UUID().uuidString
        let exportURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(videoName)
            .appendingPathExtension("mov")
        
        export.videoComposition = videoComposition
        export.outputFileType = .mov
        export.outputURL = exportURL
        
        export.exportAsynchronously {
            DispatchQueue.main.async {
                switch export.status {
                case .completed:
                    onComplete(exportURL)
                default:
                    print("Something went wrong during export.")
                    print(export.error ?? "unknown error")
                    onComplete(nil)
                }
            }
        }
    }
    
    private func addImage(to layer: CALayer, videoSize: CGSize) {
        // topImageLayer
        guard let topImage = UIImage.asset(.topLayer) else { return }
        let topImageLayer = CALayer()
        
        let topAspect: CGFloat = topImage.size.width / topImage.size.height
        let topImgWidth = videoSize.width
        let topImgHeight = topImgWidth / topAspect
        topImageLayer.frame = CGRect(
            x: 0,
            y: videoSize.height-90,
            width: topImgWidth,
            height: topImgHeight)
        
        topImageLayer.contents = topImage.cgImage
        layer.addSublayer(topImageLayer)
        
        // bottomLayer
        guard let image = UIImage.asset(.bottomLayer) else { return }
        let imageLayer = CALayer()
        
        let aspect: CGFloat = image.size.width / image.size.height
        let width = videoSize.width
        let height = width / aspect
        imageLayer.frame = CGRect(x: 0, y: 20, width: width, height: height)
        
        imageLayer.contents = image.cgImage
        layer.addSublayer(imageLayer)
    }
}

private func orientation(from transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
    var assetOrientation = UIImage.Orientation.up
    var isPortrait = false
    if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
        assetOrientation = .right
        isPortrait = true
    } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
        assetOrientation = .left
        isPortrait = true
    } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
        assetOrientation = .up
    } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
        assetOrientation = .down
    }
    
    return (assetOrientation, isPortrait)
}

private func compositionLayerInstruction(
    for track: AVCompositionTrack, assetTrack: AVAssetTrack) -> AVMutableVideoCompositionLayerInstruction {
    let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
    let transform = assetTrack.preferredTransform
    
    instruction.setTransform(transform, at: .zero)
    
    return instruction
}
