# Round-Drop-Menu

[![Build Status](https://travis-ci.org/burntheroad/Round-Drop-Menu.svg?branch=master)](https://travis-ci.org/burntheroad/Round-Drop-Menu)

Simple highly customizable iOS component written in Swift gives you another way to represent data. Round-Drop-Menu is great for small sets of visual information.

![](http://i.imgur.com/gJLDmAP.gif)

## Usage
Round-Drop-Menu usage is very similar to `UITableView` or `UICollectionView`. You should simply:

1. Place `RoundDropMenu` in your View Controller.
2. Conform your View Controller to `RoundDropMenuDataSource` and implement two methods:
* `numberOfDropsInRoundDropMenu(menu: RoundDropMenu) -> Int`
* `roundDropMenu(menu: RoundDropMenu, dropViewForIndex index: Int) -> DropView`
3.  Set `RoundDropMenu` `dataSource` to your View Controller. 
4.  *Optionally conform to `RoundDropMenuDelegate` to get method `roundDropMenu(menu: RoundDropMenu, didSelectDropWithIndex index: Int)`*

## Customization
You can change appearance of menu by setting next properties:

##### `DropView`:
* `color` - default color of the drops
* `highlitedColor` - color of view in highlithed state.

##### `RoundDropMenu`:
* `color` - color of the oval in the center of menu.
* `offset` - padding from view bounds to oval.
* `maxDropRadius` - radius of the drop in the center of menu.
* `minDropRadius` - minimal radius of the drop.

## TODOs:
- [ ] CocoaPods/Carthage/SPM
- [ ] Implement scroll deceleration
- [ ] More customization options

## Author
* Arthur Myronenko - [@monkey_has_gone](https://twitter.com/monkey_has_gone)