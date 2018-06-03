# CodeChallenge for Domain
by _Dmitrii Zverev_. 3 July 2018

<h2>Given Instructions:</h2>

- [x] Acquire property models from the following endpoint

- [x] Display a control on the top of the screen to switch between buy and rent. This selection must persist between launches.

- [x] Display a label on the top of the screen to display the number of properties marked as favourite.

- [x] Display properties on screen with the following UI elements: Favourite button, Image, description text.

- [x] The properties (at least 20) must be displayed in a column when the device trait collection horizontal size class is Compact. The properties must be displayed in a 2 column layout when the device trait collection horizontal size class is Regular.

- [x] The favourites must be persisted securely between launches.


<h2>Given Expectations:</h2>

- [x] The code written by yourself must be Swift, Objective-C libraries are fine.

- [x] This should represent code you would be proud to ship as part of the Domain team. Don't try and get too fancy and impress us with an obscure technique/library. There will be plenty of time to discuss those after you complete the challenge.

- [x] Please refrain from the use of storyboards or xib files for the purposes of this exercise.

- [x] Layout code must use Autolayout where appropriate. DSL libraries like SnapKit are acceptable.

- [x] The code must be written to support iOS9+ and all the devices that includes. Assets must be optimised for each device scale. You can get high resolution or vector graphics from The Noun Project or any source your prefer.

- [x] Some examples of the use of size classes must be included.

- [x] You are expected to include unit tests where appropriate. You can use XCTest or any other testing framework you prefer.

- [x] You are expected to include Git history and follow the same Git methodology and process as if you were working with others.

- [x] Your project should build with the newest version of Xcode available at the time of your submission.

- [x] Include a brief description of your design goals and any tradeoffs or compromises you made in your README file.

<h2>Personal challenges:</h2>

**I haven't written an app without storyboard or XIBs for ages so decided to not to use 3rd part libs or Pods (except Autolayout one):** 

 * Using Codable structs was fun and good practice, however, I still think that for the API requests the best solution is combination [Alamorife](https://github.com/Alamofire/Alamofire)  + [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON). It gives you full control of creating objects/structs (especially using optional initialisations) and literally 100% crush free code.
 * Although I used my own UIImageView subclass with image loading and caching methods, I'd recommend the [Kingfisher](https://github.com/onevcat/Kingfisher) as an amazing and totally covering all possible image loading scenarios tool.
 
 **In this challenge, I demonstrated that I know how to use:**
 
- structs
- lazy variables
- optional 
- Codable (including snake_case to camelCase converting)
- class extensions and sub-classes
- Threads
- URL Sessions
- Error throwing Enums
- Creating UI without Storyboard/Xib
- closures
- escaping
- tuples 
- Saving/loading offline data
- Caching
- ..  and much more 

__About Unit testing:__
In my solution of the coding excersice, it was hard to find what exactly needs to be tested because all functions, methods, extensions and structs are simple and impossible-to-crash. Except might be a _JSON-to-Struct part_. However, to display that I know what unit tests are and how to write them, I implemented some examples including the _Asynchronous URL Connection test_.
