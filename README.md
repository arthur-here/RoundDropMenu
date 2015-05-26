# Round-Drop-Menu
iOS menu written on Swift that ideally suits small amount of image data.

![](http://i.imgur.com/gJLDmAP.gif)

## Usage
1. Add files from Round-Drop-Menu folder to your project.
2. Create a class that cofirms to `DropProtocol`.
3. Create a subclass of a `RoundDropViewController`.
4. Override methods `numberOfDrops()` and `dropForIndex(index:)`.
5. In storyboard add new view.
6. Create new outlet in your subclass and submit it to overriden method `viewForMenu()`.
7. You can use `RoundDropMenuDelegate` to handle menu event.
8. You can configure appearance of your menu by setting `dropColor` and `backgroundDropColor` in your subclass.

## TODOs:
* change animation for centring drops;
* provide more public settings for appearance;

## Author
* Arthur Myronenko - [@monkey_has_gone](https://twitter.com/monkey_has_gone)
