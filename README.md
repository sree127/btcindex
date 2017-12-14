## **BTC Price Index App**

Basic useful feature list:

 * Get latest bitcoin price
 * Get day's open, high & low price
 * Visual graph showing historical data 
 * Toggle historical data b/w daily, monthly and all-time prices
 * Select any price point from the linechart using indicators

<br>
API's used: :+1:
<br>

```
 * End point -> https://apiv2.bitcoinaverage.com 
 * Price Indices -> https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCUSD
 * Historical Data -> https://apiv2.bitcoinaverage.com/indices/global/history/BTCUSD?period=daily&?format=json
```

#### Dependencies:
 Used Carthage to manage the dependencies. 
 
 Libraries used: :+1:

 * [Charts](https://github.com/danielgindi/Charts) for plotting the line chart
 * [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift/) for computing the HMAC digest needed for API authentication
 
#### Fonts
* Quicksand - Bold/Medium/Regular

#### Testing
* Added unit tests for Controllers 
* Mock test for Network manager


#### Supported Screen Sizes
* iPhoneX
* iPhone 8 Plus
* iPhone 8
* iPhone SE


#### Errors

Compille Errors due to ````Charts module```` 
````
1. Drag the Charts.xcodeproj to your project
2. Go to your target's settings, hit the "+" under the "Embedded Binaries" section, and select the Charts.framework
````

#### Screenshots

![Initial](https://github.com/sree127/screenshots/blob/master/Simulator%20Screen%20Shot%20-%20iPhone%208%20-%202017-12-14%20at%2001.31.51.png)

![value selector](https://github.com/sree127/screenshots/blob/master/Simulator%20Screen%20Shot%20-%20iPhone%208%20-%202017-12-14%20at%2001.31.51.png)





 
