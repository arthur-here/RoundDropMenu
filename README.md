# Round-Drop-Menu
iOS menu written on Swift that ideally suits small amount of image data.

![](http://i.imgur.com/gJLDmAP.gif)

## Usage
1. Add files from Round-Drop-Menu folder to your project.
2. Create a class that cofirms to `DropProtocol`.
3. In Storyboard change your view controller's class to `RoundDropViewController`.
4. In Storyboard add to your view new `RoundDropMenuView` subview.
5. Connect that subview with `menuView` outlet in view controller.
6. Optionally add to your view `UIImageView` and `UILabel` and connect them to `dataImageView` outlet and `descriptionLabel` outlet.
7. In `setup()` method of `RoundDropViewController` add instances of class, created in paragraph 2.
8. You can configure appearance of your menu by setting `dropColor` and `backgroundDropColor` in view controller.

## Author
* Arthur Myronenko - [@monkey_is_gone](https://twitter.com/monkey_is_gone)
