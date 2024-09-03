import Orion
import SnapSafeC
import UIKit

//Prevent discover stories from showing after friend stories.
class SCOperaPageViewControllerHook: ClassHook<UIViewController> {
  static let targetName = "SCOperaPageViewController"
  @Property(.nonatomic) var isDiscoverStory = false

  private func checkIfDiscoveryStory() {
    if let page = target.value(forKey: "page") as? NSObject,
      let properties = page.value(forKey: "properties") as? NSObject
    {
      NSLog("SBTWEAK: Got page \(page) properties \(properties)")

      if properties.value(forKey: "discover_story_composite_id") != nil {
        isDiscoverStory = true

      } else {
        NSLog("SBTWEAK: Friend story")
      }
    } else {
      NSLog("SBTWEAK: Couldn't get page")
    }

  }

  private func dismissStory() {
    if let parentVC = target.parent {
      NSLog("SBTWEAK: parentVC \(parentVC)")

      let selector = NSSelectorFromString("navigationManagerShouldDismiss:")

      if parentVC.responds(to: selector) {
        NSLog("SBTWErAK: Responds")

        let objcMethod = class_getInstanceMethod(type(of: parentVC), selector)

        if objcMethod != nil {
          NSLog("SBTWErAK: bout to send")

          let objc_msgSend = class_getMethodImplementation(type(of: parentVC), selector)

          typealias objc_msgSend_t = @convention(c) (AnyObject, Selector, NSObject?) -> Void
          let msgSend = unsafeBitCast(objc_msgSend, to: objc_msgSend_t.self)

          _ = msgSend(parentVC, selector, nil)
        }
      } else {
        NSLog(
          "SBTWEAK: Parent view controller does not respond to navigationManagerShouldDismiss")
      }

    } else {
      NSLog("SBTWEAK: Couldn't get parentvc")

    }

  }

  func viewDidLoad() {
    orig.viewDidLoad()

    checkIfDiscoveryStory()

    //Hide the view if it's a discovery story, otherwise you can see the story for a moment when swiping.
    if isDiscoverStory {
      target.view.isHidden = true
    }
  }

  func viewDidFullyAppear() {
    orig.viewDidFullyAppear()

    //Dismiss the story view if the story is a discover story.
    if isDiscoverStory {
      dismissStory()
    }
  }
}

//Disable discover stories section.
class SCDiscoveryFeedDataStore: ClassHook<NSObject> {
  static let targetName = "SCDiscoverFeedSectionExtensionServices"

  func remoteSectionProviders() -> NSDictionary {
    return [:]
  }
}

//Hide some tabs.
class SIGNavigationBarViewHook: ClassHook<UIView> {
  static let targetName = "SIGNavigationBarView"

  func didMoveToSuperview() {
    orig.didMoveToSuperview()

    target.subviews[0].subviews[1].isHidden = true  //Hide map tab.
    target.subviews[0].subviews[5].isHidden = true  //Hide spotlight tab.
  }
}

// class SCDiscoverFeedViewControllerHook: ClassHook<UIViewController> {
//   static let targetName = "SCDiscoverFeedViewController"

//   func viewDidLoad() {
//     orig.viewDidLoad()

//     NSLog("SCTWEAK: View did load.")
//   }

//   func _currentSections() -> NSArray {
//     NSLog("SCTWEAK: currentSections")
//     return []
//   }

//   func _fetchStoriesForAllSectionsWithQuerySource(_ source: NSObject) {

//     NSLog("SCTWEAK: _fetchStoriesForAllSectionsWithQuerySource \(source)")

//     orig._fetchStoriesForAllSectionsWithQuerySource(source)

//   }

//   func _fetchStoriesForAllSectionsWithQuerySource(
//     _ source: NSObject, feedType: Int, sectionExtensionServices: NSObject
//   ) {

//     NSLog(
//       "SCTWEAK: _fetchStoriesForAllSectionsWithQuerySource \(source), \(feedType) \(sectionExtensionServices)"
//     )

//     orig._fetchStoriesForAllSectionsWithQuerySource(
//       source, feedType: feedType, sectionExtensionServices: sectionExtensionServices)

//   }

// }

// class SCDiscoverFeedStoryCollectionViewContrller: ClassHook<UIView> {
//   static let targetName = "SCDiscoverFeedStoryCollectionView"

//   func isHidden() -> Bool {
//     return true
//   }
// }
