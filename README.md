# MyPlaces App
 <img src="https://github.com/martaboteller/MyPlaces/blob/master/MyPlaces/imagesForReadme/pinkIphonewithApp.png?raw=true" width="500" height="450"> 
 
This is the final project of a course named <i>IOS Application Developer</i> carried out at the UOC university thanks to a 
grant from the Generalitat of Catalonia and the European Union.

<div id="banner">
    <div class="inline-block">
 <img src="https://github.com/martaboteller/MyPlaces/blob/master/MyPlaces/imagesForReadme/PQTM.png?raw=true" width="100" height="50" > 
  <img src="https://github.com/martaboteller/MyPlaces/blob/master/MyPlaces/imagesForReadme/UOC.png?raw=true" width="50" height="50" hspace="30"> 
  </div>
</div>

## Getting Started

Cocoapods have been used in this project. Please refer to the following [guide] (https://guides.cocoapods.org/using/using-cocoapods)
if you need help adding pods to your XCode project.

More information about Firebase configuration can be found [here](https://firebase.google.com/docs/ios/setup).

### List of Used Pods

* pod 'GoogleMaps'
* pod 'GooglePlaces'
* pod 'Firebase'
* pod 'Firebase/Core'
* pod 'Firebase/Storage'
* pod 'Firebase/Database'
* pod 'Firebase/Auth'
* pod 'DropDown', '2.3.4'
* pod 'Fabric', '~> 1.7.11'
* pod 'Crashlytics', '~> 3.10.7'


## Deployment

Please find below the screen views designed for this project:

 <div id="banner">
    <div class="inline-block">
        <img src="https://github.com/martaboteller/MyPlaces/blob/master/MyPlaces/imagesForReadme/1.png?raw=true" width="100" height="200" title="First Screen">
      <img src="https://github.com/martaboteller/MyPlaces/blob/master/MyPlaces/imagesForReadme/2.png?raw=true" width="100" height="200" title="Table Screen" hspace="5">
      <img src="https://github.com/martaboteller/MyPlaces/blob/master/MyPlaces/imagesForReadme/3.png?raw=true" width="100" height="200" title="Map Screen" hspace="5">
<img src="https://github.com/martaboteller/MyPlaces/blob/master/MyPlaces/imagesForReadme/4.png?raw=true" width="100" height="200" title="Detail Screen" hspace="5">
<img src="https://github.com/martaboteller/MyPlaces/blob/master/MyPlaces/imagesForReadme/5.png?raw=true" width="100" height="200" title="Edit Screen" hspace="5">
<img src="https://github.com/martaboteller/MyPlaces/blob/master/MyPlaces/imagesForReadme/7.png?raw=true" width="100" height="200" title="SignUp Screen" hspace="5">
<img src="https://github.com/martaboteller/MyPlaces/blob/master/MyPlaces/imagesForReadme/8.png?raw=true" width="100" height="200" title="Forgotten Password Screen">
    </div>
</div>
&nbsp;

### Project Deliveries (PLA 1 - 4)

This project has been released in 4 deliveries identified as PLA 1, PLA 2, PLA 3 and PLA 4.

<img src="https://github.com/martaboteller/MyPlaces/blob/master/MyPlaces/imagesForReadme/pla1234.png?raw=true" width="600" height="300" title="Forgotten Password Screen">

#### Pla 1
First contact with XCode and design of an app skeleton.
#### Pla 2
Graphical interface design. 
#### Pla 3
Learning to use JSON. Maps. 
#### Pla 4
Including CocoaPods (Firebase, Google Maps). 

 <div id="banner">
    <div class="inline-block">
<img src="https://github.com/martaboteller/MyPlaces/blob/master/MyPlaces/imagesForReadme/interface.png?raw=true" width="400" height="200" title="Forgotten Password Screen">
<img src="https://github.com/martaboteller/MyPlaces/blob/master/MyPlaces/imagesForReadme/icons.png?raw=true" width="400" height="200" title="Forgotten Password Screen" hspace="30">
   </div>
</div>

&nbsp;

### App Flow



Firebase has been used as a backend connection. Only registered users (not guests) can save, edit and remove a place.


```
   func downloadDemoData(success:@escaping (_ arrayPlaces: [Place])->(),failure:@escaping (_ error:Error)->()){
```


## Built With

* XCode 10.1
* Swift 4.2
* Platform IOS 12.0

## Versioning

First version of MyPlaces App finished on Dec 2018.

## Authors

* **Marta Boteller** - [Marta Boteller](https://github.com/martaboteller).


## Acknowledgments

This could not have been done without the help of my teacher [Albert Mata](https://github.com/almata/).

