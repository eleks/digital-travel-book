//
//  WLDataManager.swift
//  Weekend In Lviv
//
//  Created by Admin on 19.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import Foundation

// Singleton shared instance of class
let _singletonDataManagerSharedInstance = WLDataManager()

class WLDataManager : NSObject {
  
    // Instance variables/constants
    let managedObjectContext:NSManagedObjectContext?

    var _dataFolder:String? = nil
    var dataFolder:String? {
        get {
            if let dataFolder_ = _dataFolder? {
            }
            else{
                let appDelegate = UIApplication.sharedApplication().delegate as WLAppDelegate
                let url:NSURL = appDelegate.applicationDocumentsDirectory()
                let documentPath:String = url.path
                _dataFolder = documentPath.stringByAppendingPathComponent(".localData")
            }
            
            if !NSFileManager.defaultManager().fileExistsAtPath(_dataFolder!) {
                var error:NSErrorPointer = nil
                NSFileManager.defaultManager().createDirectoryAtPath(_dataFolder!,
                                                                    withIntermediateDirectories: true,
                                                                    attributes: nil,
                                                                    error: error)
                if error {
                    println("Data manager: local data document folder creation error :\(error)")
                }
            }
            return _dataFolder!
        }
        set (dataFolder) {
            _dataFolder = dataFolder
        }
    }
    
    var placesList:WLPlace[] = []
    
    
    
    // Class variable
    class var sharedManager:WLDataManager
    {
        return _singletonDataManagerSharedInstance;
    }
    
    // Instance methods
    init()
    {
        let appDelegate:WLAppDelegate = UIApplication.sharedApplication()!.delegate! as WLAppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        
        super.init()
    }
    
    func fillPlacesList()
    {
        var places:Place[] = self.places()
       
        let _array:AnyObject[] = NSLocale.preferredLanguages()
        let language = _array[0] as String
        self.placesList = []
        let sortByTimestamp:Array<NSSortDescriptor> = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        for place in places {
        
            var newPlace:WLPlace = WLPlace()
            
            newPlace.title              = self.placeMainTitleWithLocale(locale:language, place:place)
            newPlace.placeTopImagePath  = place.topImage.pathToFile
            newPlace.listImagePath      = place.listIcon.pathToFile
            newPlace.placeMenuImagePath = place.menuIcon.pathToFile
            newPlace.placeText          = self.placeMainTextWithLocale(locale:language, place:place)
            newPlace.placeAudioPath     = self.placeAudioWithLocale(locale:language, place:place)
            newPlace.moIdentificator    = place.identificator
            newPlace.placeFavourite     = place.favourite.boolValue
            
            var textBlocks:TextBlock[] = place.blocks.sortedArrayUsingDescriptors(sortByTimestamp)! as TextBlock[]
            var texts:WLTextBlock[] = []
            
            for block in textBlocks {
                texts.append(self.placeTextBlockWithLocale(locale: language, textBlock: block as TextBlock))
            }
            newPlace.placesTextBlocks = texts
        
            let pointBlocks:PointBlock[] = place.pointBlocks.sortedArrayUsingDescriptors(sortByTimestamp)!  as PointBlock[]
            var points:WLPointBlock[] = []
            
            for pointBlock in pointBlocks {
                points.append(self.pointBlockWithLocale(locale: language, pointBlock: pointBlock))
            }
            newPlace.placesPointBlocks = points

            self.placesList.append(newPlace)
        }
    }
    
    func clearPlacesData()
    {
        var places:Place[] = self.places()
        if places.count > 0 {
            if NSFileManager.defaultManager().fileExistsAtPath(self.dataFolder) {
                var error:NSErrorPointer = nil
                let result = NSFileManager.defaultManager().removeItemAtPath(self.dataFolder, error:error)
                if !result {
                    println("Data manager: folder deleting error:\(error)")
                }
            }
            for place in places {
                self.managedObjectContext!.deleteObject(place as Place)
            }
            self.saveContext()
        }
    }
    
    func saveContext() -> Bool
    {
        var error: NSError? = nil
        
        if var managedObjectContext_ = self.managedObjectContext {
            if managedObjectContext_.hasChanges && !managedObjectContext_.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                println("Data manager: CAN'T SAVE DB !!! unresolved error \(error)")
                return false
            }
            return true
        }

        return false
    }

    func addPlaceWithOptions(options:Dictionary<String, AnyObject>) -> Place
    {
        var entity:NSEntityDescription? = NSEntityDescription.entityForName("Place", inManagedObjectContext: self.managedObjectContext!)
        
        var newPlace = Place(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext!)
        
        var mutableOptions:Dictionary<String, AnyObject> = options
      
        for (property: String, object_ : AnyObject) in mutableOptions {
            //println("Dictionary: \(property): \(object_)")
            switch(property){
                
                case "topImageName":
                    if let image = self.addImageWithFileName(object_ as String)? {
                        
                        newPlace.topImage = image
                    }
                    else{
                        println("Data manager: can't add topImage")
                    }
                
                case "lictIconImageName":
                    if let image = self.addImageWithFileName(object_ as String)? {
                        
                        newPlace.listIcon = image
                    }
                    else{
                        println("Data manager: can't add listIcon")
                    }
                
                case "menuIconImageName":
                    if let image = self.addImageWithFileName(object_ as String)? {
                        
                        newPlace.menuIcon = image
                    }
                    else{
                        println("Data manager: can't add menuIcon")
                    }
                
                case "mainTitle":
                    var titles:Dictionary<String, String> = object_ as Dictionary<String, String>
            
                    for (key: String, object: String) in titles {
                        
                        if let localizetText = self.addLocalizedTextWithLocale(locale: key, text: object)? {
                            
                            newPlace.addTitlesObject(localizetText)
                        }
                        else{
                            println("Data manager: can't add addTitlesObject")
                        }
                    }
                
                case "mainText":
                    var texts:Dictionary<String, String> = object_ as Dictionary<String, String>
                
                    for (key: String, object: String) in texts {
                
                        if let localizetText = self.addLocalizedTextWithLocale(locale: key, text: object)? {
                            
                            newPlace.addTextObject(localizetText)
                        }
                        else{
                            println("Data manager: can't add addTextObject")
                        }
                    }
                
                case "textBlocks":
                    var texts:Array<AnyObject> = object_ as Array<AnyObject>
                
                    for object : AnyObject in texts {
          
                        if let textObject = self.addTextBlockWithOptions(object as Dictionary<String, AnyObject>)? {
                            
                            newPlace.addBlocksObject(textObject)
                        }
                        else{
                            println("Data manager: can't add textObject")
                        }
                
                    }
        
                case "pointBlocks":
                    var points:Array<AnyObject> = object_ as Array<AnyObject>
                
                    for object : AnyObject in points {
                        
                        if let pointBlock = self.addPointBlockWithOptions(object as Dictionary<String, AnyObject>)? {
                            
                            newPlace.addPointBlocksObject(pointBlock)
                        }
                        else{
                            println("Data manager: can't add textObject")
                        }
                    }

                case "audioFiles":
                    var audios:Dictionary<String, String> = object_ as Dictionary<String, String>
                    
                    for (key: String, object: String) in audios {

                        if let audioFile = self.addAudioFileWithLocale(locale: key, fileName: object)? {
                            
                            newPlace.addAudioFilesObject(audioFile)
                        }
                        else{
                            println("Data manager: can't add audio file")
                        }
                    }

                default:
                    println("Data manager: unrecognized property")
            }
        }
        newPlace.identificator = NSNumber(double: NSDate.timeIntervalSinceReferenceDate() )
        //println("Data manager: newPlace = \(newPlace)")
        return newPlace
    }
    
    func placeWithIdentifier(identifier:NSNumber) -> Place
    {
        var request = NSFetchRequest(entityName: "Place")
        var predicate = NSPredicate(format: "identificator == %@", identifier)
        
        request.predicate = predicate
        
        var error:NSError? = nil
        var array:Array<Place> = self.managedObjectContext!.executeFetchRequest(request, error: &error) as Place[]
        
        if(error){
            println("Place fetching error: \(error)")
        }
        
        return array[0]
    }
    
    func addImageWithFileName(fileName:String) -> Image?
    {
        var fileNameComponents:Array<String> = fileName.componentsSeparatedByString(".")
        let file:String         = fileNameComponents[0]
        let type:String         = fileNameComponents[fileNameComponents.endIndex - 1]
        
        let imagePath:String    = NSBundle.mainBundle().pathForResource(file, ofType: type)
        var imageData:NSData    = NSData.dataWithContentsOfFile(imagePath, options: nil, error: nil)
        
        var image:UIImage?      = UIImage(data: imageData)
        var savedImage:UIImage? = nil

        if(!UIScreen.mainScreen().isRetinaDisplay()){

            let newSize = CGSizeMake(image!.size.width, image!.size.height)
            savedImage  = image!.resizeImage(newSize: newSize, interpolationQuality: kCGInterpolationHigh)
        }
        else{
            savedImage  = image!
        }
        
        let filePath:String = self.dataFolder!.stringByAppendingPathComponent(String(format:"%@%f.jpeg", file, NSDate.timeIntervalSinceReferenceDate()))
        var savedImageData:NSData? = UIImageJPEGRepresentation(savedImage!, CGFloat(0.5))
        savedImageData!.writeToFile(filePath, atomically: true)
        
        var entity = NSEntityDescription.entityForName("Image", inManagedObjectContext: self.managedObjectContext!)
        var returnedImage = Image(entity: NSEntityDescription.entityForName("Image", inManagedObjectContext: self.managedObjectContext!),
                                  insertIntoManagedObjectContext: self.managedObjectContext!)
        returnedImage.pathToFile = filePath
        returnedImage.timestamp  = NSDate.date()

        return returnedImage
    }
    
    func imageWithPath(path:String) -> UIImage
    {
        var imgData:NSData = NSData.dataWithContentsOfFile(path, options: nil, error: nil)
        return UIImage(data: imgData)
    }
    
    func imageListWithPlace(place:WLPlace) -> Array<String>
    {
        var result:Array<String> = []
        
        for textBlock in place.placesTextBlocks {
            for item in (textBlock.blockImagesPath) {
                result.append(item)
            }
        }
        
        return result
    }
    
    func addLocalizedTextWithLocale(#locale:String?, text:String?) -> LocalizedText!
    {
        var entityDescription   = NSEntityDescription.entityForName("LocalizedText", inManagedObjectContext: self.managedObjectContext!)
        var localizedText       = LocalizedText(entity: entityDescription, insertIntoManagedObjectContext: self.managedObjectContext!)
        
        localizedText.locale    = locale!
        localizedText.text      = text!
        
        return localizedText
    }
    
    func placeMainTitleWithLocale(#locale:String, place:Place) -> String
    {
        return self.getString(locale: locale, localizedStrings: place.titles)
    }
    
    
    func placeMainTextWithLocale(#locale:String, place:Place) -> String
    {
        return self.getString(locale: locale, localizedStrings: place.text)
    }
    
    
    func textBlockTitleWithLocale(#locale:String, textBlock:TextBlock) -> String
    {
        return self.getString(locale: locale, localizedStrings: textBlock.titles)
    }
    
    func textBlockSubtitleWithLocale(#locale:String, textBlock:TextBlock) -> String
    {
        return self.getString(locale: locale, localizedStrings:textBlock.subtitle)
    }
    
    func textBlockTextWithLocale(#locale:String, textBlock:TextBlock) -> String
    {
        return self.getString(locale:locale, localizedStrings:textBlock.texts)
    }
    
    func pointBlockTextWithLocale(#locale:String, pointBlock:PointBlock) -> String
    {
        return self.getString(locale:locale, localizedStrings:pointBlock.mainText)
    }
    
    func pointTextWithLocale(#locale:String, point:PointOfBlock) -> String
    {
        return self.getString(locale:locale, localizedStrings:point.text)
    }
    
    func placeAudioWithLocale(#locale:String, place:Place) -> String
    {
        return self.getString(locale:locale, localizedStrings:place.audioFiles)
    }
    
    func getString(#locale:String, localizedStrings:NSSet) -> String
    {
        var predicate               = NSPredicate(format: "locale == %@", locale)
        var title:LocalizedText?    = localizedStrings.filteredSetUsingPredicate(predicate).anyObject() as? LocalizedText
 
        //println("localizedStrings = \(localizedStrings)")
        
        if let title_ = title? {
            return title_.text
        }
        else{
            predicate = NSPredicate(format: "locale == %@", "de")
            title = localizedStrings.filteredSetUsingPredicate(predicate).anyObject() as? LocalizedText
            
            if let title_ = title? {
                return title_.text
            }
            else{
                var audio:AudioFile? = localizedStrings.filteredSetUsingPredicate(predicate).anyObject() as? AudioFile
                
                if let title_ = audio? {
                    return audio!.path!
                }
                else{
                    return ""
                }
            }
        }
    }
    
    func addTextBlockWithOptions(options:Dictionary<String, AnyObject>) -> TextBlock?
    {
        var entity = NSEntityDescription.entityForName("TextBlock", inManagedObjectContext: self.managedObjectContext!)
        
        var newTextBlock = TextBlock(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext!)
        newTextBlock.timestamp = NSDate()
        
        var mutableOptions:Dictionary<String, AnyObject> = options

        for (property: String, object_ : AnyObject) in mutableOptions {
            //println("Dictionary: \(property): \(object_)")
            switch(property){

            case "title":
                var titles:Dictionary<String, String> = object_ as Dictionary<String, String>
                
                for (key: String, object: String) in titles {
                    newTextBlock.addTitlesObject(self.addLocalizedTextWithLocale(locale: key, text: object))
                }
                
            case "subtitle":
                var subtitles:Dictionary<String, String> = object_ as Dictionary<String, String>
                
                for (key: String, object: String) in subtitles {
                    newTextBlock.addSubtitleObject(self.addLocalizedTextWithLocale(locale: key, text: object))
                }
                
            case "text":
                var texts:Dictionary<String, String> = object_ as Dictionary<String, String>
                
                for (key: String, object: String) in texts {
                    newTextBlock.addTextsObject(self.addLocalizedTextWithLocale(locale: key, text: object))
                }
                
            case "images":
                for fileName:String in object_ as String[] {
                    println("\(fileName)")
                    newTextBlock.addImagesObject(self.addImageWithFileName(fileName))
                }

            default:
                println("Data manager: unrecognized property")
            }

        }
        
        return newTextBlock
    }
    
    func placeTextBlockWithLocale(#locale:String, textBlock block:TextBlock) -> WLTextBlock
    {
        var newTextBlock = WLTextBlock()
        newTextBlock.blockTitle = self.textBlockTitleWithLocale(locale: locale, textBlock:block)
        newTextBlock.blockSubtitle = self.textBlockSubtitleWithLocale(locale:locale, textBlock:block)
        newTextBlock.blockText = self.textBlockTextWithLocale(locale:locale, textBlock:block)
        
        var temporaryImages:String[] = []
        let dateSortDescriptor:Array<NSSortDescriptor> = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        var array:Image[] = block.images.sortedArrayUsingDescriptors(dateSortDescriptor)!  as Image[]
        
        for image in array {
            temporaryImages.append(image.pathToFile)
        }
        newTextBlock.blockImagesPath = temporaryImages
        
        return newTextBlock
    }
    
    func addPointBlockWithOptions(options:Dictionary<String, AnyObject>) -> PointBlock?
    {
        var entity = NSEntityDescription.entityForName("PointBlock", inManagedObjectContext: self.managedObjectContext!)
        
        var pointBlock = PointBlock(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext!)
        
        pointBlock.timestamp = NSDate()
        var mutableOptions:Dictionary<String, AnyObject> = options
        
        for (property: String, object_ : AnyObject) in mutableOptions {
            //println("Dictionary: \(property): \(object_)")
            switch(property){
                
            case "imageName":
                pointBlock.image = self.addImageWithFileName(object_ as String)
                
            case "text":
                var texts:Dictionary<String, String> = object_ as Dictionary<String, String>
                
                for (key: String, object: String) in texts {
                    pointBlock.addMainTextObject(self.addLocalizedTextWithLocale(locale: key, text: object))
                }
                
            case "points":
                var pointDict:Array<AnyObject> = object_ as Array<AnyObject>
                
                for object : AnyObject in pointDict {
                    pointBlock.addPointsObject(self.addPointOfBlockWithOptions(object as Dictionary<String, AnyObject>))
                }
                
            default:
                println("Data manager: unrecognized property")
            }
        }
        
        return pointBlock
    }
    
    func pointBlockWithLocale(#locale:String, pointBlock block:PointBlock) -> WLPointBlock
    {
        var pointBlock:WLPointBlock = WLPointBlock()
        
        pointBlock.blockImagePath   = block.image.pathToFile
        pointBlock.blockText        = self.pointBlockTextWithLocale(locale:locale, pointBlock:block)
        var points:WLPoint[]        = []
        
        var set:NSSet = block.points

        for point : AnyObject in set {
            points.append(self.pointWithLocale(locale:locale, pointOfBlock:point as PointOfBlock))
        }
        pointBlock.blockPoints = points
        
        return pointBlock
    }

    func pointWithLocale(#locale:String, pointOfBlock:PointOfBlock) -> WLPoint
    {
        var point:WLPoint = WLPoint()
        
        point.imagePath = pointOfBlock.image.pathToFile
        point.x = pointOfBlock.x.floatValue
        point.y = pointOfBlock.y.floatValue
        point.text = self.pointTextWithLocale(locale:locale, point:pointOfBlock)
        
        return point
    }
    
    func addPointOfBlockWithOptions(options:Dictionary<String, AnyObject>) -> PointOfBlock?
    {
        var entity       = NSEntityDescription.entityForName("PointOfBlock", inManagedObjectContext: self.managedObjectContext!)
        var pointOfBlock = PointOfBlock(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext!)
        
        var mutableOptions:Dictionary<String, AnyObject> = options
        
        for (property: String, object_ : AnyObject) in mutableOptions {
            //println("Dictionary: \(property): \(object_)")
            switch(property){
                
            case "image":
                pointOfBlock.image = self.addImageWithFileName(object_ as String)!
                
            case "pointX":
                pointOfBlock.x = NSNumber(integer: object_ as Int)
                
            case "pointY":
                pointOfBlock.y = NSNumber(integer: object_ as Int)
                
            case "bottomText":
                var pointDict:Dictionary<String, String> = object_ as Dictionary<String, String>
                
                for (key: String, object: String) in pointDict {
                    pointOfBlock.addTextObject(self.addLocalizedTextWithLocale(locale: key, text: object))
                }
                
            default:
                println("Data manager: unrecognized property")
            }
        }
        return pointOfBlock
    }
   
    func addAudioFileWithLocale(#locale:String, fileName:String) -> AudioFile?
    {
        let file = fileName.lastPathComponent.stringByDeletingPathExtension
        let type = fileName.pathExtension
        
        let filePath    = NSBundle.mainBundle()!.pathForResource(file, ofType: type)
        let newFilePath = self.dataFolder!.stringByAppendingPathComponent(String(format:"%@%f.%@", file, NSDate.timeIntervalSinceReferenceDate(), type))
        
        var error:NSError? = nil
        NSFileManager.defaultManager()!.copyItemAtPath(filePath, toPath: newFilePath, error: &error)

        if let error_ = error? {
            println("Data manager: audio file copy error: \(error)")
            return nil
        }
        
        var entity      = NSEntityDescription.entityForName("AudioFile", inManagedObjectContext: self.managedObjectContext!)
        var audioFile   = AudioFile(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext!)

        audioFile.path   = newFilePath
        audioFile.locale = locale
     
        return audioFile
    }
    
    func places() -> Place[]
    {
        var request = NSFetchRequest(entityName:"Place")
        var error: NSError? = nil
        
        return self.managedObjectContext!.executeFetchRequest(request, error: &error) as Place[]
    }

}








