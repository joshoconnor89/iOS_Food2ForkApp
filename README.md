# iOS_Food2ForkApp

What this is
------------
A simple iOS application which uses AFNetworking and SDWebImage.  This is a project written in 
Objective-C.  Food2ForkApp fetches the Food2Fork API (http://food2fork.com/about/api) using
AFNetworking, with the endpoint being what the user searched.  The JSON data fetched is then 
cached using SDWebImage for quick scrolling.  This app uses Master-Detail design for recipes 
queried in the Food2Fork database.

Installing 
----------
- If you don't have CocoaPods, install it ($ sudo gem install cocoapods)
- Run pod install on project directory to install AFNetworking and SDWebImage CocoaPods.
- Open the .xcworkspace file with Xcode.  Enjoy

Work by 
----------
Josh O'Connor 2016
