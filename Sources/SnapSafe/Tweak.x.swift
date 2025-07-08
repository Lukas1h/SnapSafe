import Orion
import SnapSafeC
import UIKit


//Commented out some stuff because it got me banned for one week, then one month....


//Hide some tabs.
class SIGNavigationBarViewHook: ClassHook<UIView> {
  static let targetName = "SIGNavigationBarView"

  @Property(.nonatomic) var mapTab: UIView! = nil
  @Property(.nonatomic) var friendsTab: UIView! = nil
  @Property(.nonatomic) var cameraTab: UIView! = nil
  @Property(.nonatomic) var storiesTab: UIView! = nil
  @Property(.nonatomic) var spotlightTab: UIView! = nil

  func didMoveToSuperview() {
    orig.didMoveToSuperview()

    let container = target.subviews[0]

    mapTab = container.subviews[1]
    friendsTab = container.subviews[2]
    cameraTab = container.subviews[3]
    storiesTab = container.subviews[4]
    spotlightTab = container.subviews[5]

    //Hide tabs.
    if let mapTab,
       let storiesTab,
       let spotlightTab 
    {
      mapTab.isHidden = true 
      storiesTab.isHidden = true 
      spotlightTab.isHidden = true
    }

  }


  func layoutSubviews() {
    orig.layoutSubviews()

    //Hide tabs.
    if let friendsTab,
       let cameraTab
    {
      let scale: CGFloat = 1.2
      friendsTab.transform = CGAffineTransform.identity
      cameraTab.transform = CGAffineTransform.identity

      // Calculate the scaled width
      let originalTabWidth = friendsTab.frame.width
      let scaledTabWidth = originalTabWidth * scale
      let totalTabs = 2
      let totalWidth = CGFloat(totalTabs) * scaledTabWidth
      let screenWidth = UIScreen.main.bounds.width
      let startX = (screenWidth - totalWidth) / 2
      let padding:CGFloat = 10

      // Set frames before applying transform to avoid transform affecting frame.origin
      friendsTab.frame.origin.x = startX
      cameraTab.frame.origin.x = startX + scaledTabWidth + padding

      // Now apply the scaling transform
      friendsTab.transform = CGAffineTransform(scaleX: scale, y: scale)
      cameraTab.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
  }
}

//Disable swiping on camera page.
class SCSwipeContainerSwipeViewControllerHook: ClassHook<UIViewController> {
  static let targetName = "SCSwipeViewContainerViewController"
  func allowedDirections() -> Int {
    return 0
  }
}

//Disable swiping on Friends page.
class SCFriendsFeedViewControllerHook: ClassHook<UIViewController> {
  static let targetName = "SCFriendsFeedViewController"

  func viewDidLoad() {
    orig.viewDidLoad()
    setSwipeDirection(forController: target, direction: 0)
  }
}

//Hide Explore Lenses button.
class SCLensExplorerAboveMiniCarouselButtonImplHook: ClassHook<UIView> {
  static let targetName = "SCLensExplorerAboveMiniCarouselButtonImpl"

  func layoutSubviews() {
    NSLog("SBTWEAK: hiding lens button")
    target.isHidden = true
  }
}

// //Make Explore button open Add Friends page instead.
// class SCHeaderButtonProviderHook: ClassHook<NSObject> {
//   static let targetName = "SCHeaderButtonProvider"

//   //When the Explore button is tapped, don't run the original tap handeler, and instead call the handeler for the Add Friends button.
//   func didTapSearchHeaderButton(_ id: NSObject) {
//     let selector = NSSelectorFromString("didTapAddFriendsHeaderButton:")

//     if target.responds(to: selector) {
//       let objcMethod = class_getInstanceMethod(type(of: target), selector)

//       if objcMethod != nil {
//         let objc_msgSend = class_getMethodImplementation(type(of: target), selector)

//         typealias objc_msgSend_t = @convention(c) (AnyObject, Selector, NSObject?) -> Void
//         let msgSend = unsafeBitCast(objc_msgSend, to: objc_msgSend_t.self)

//         _ = msgSend(target, selector, nil)
//       }
//     }
//   }
// }

// // Hide friends suggestions.
// class SCConversationFeedDataSourceHook: ClassHook<NSObject> {
//   // Lord I'm asking that this doesn't get me banned
//   // and that you would bless me as I try to honor
//   // you with what I see and do.

//   static let targetName = "SCConversationFeedDataSource"

//   func quickAddSnapchatters() -> NSArray {
//     return []
//   }

//   func incomingSnapchatters() -> NSArray {
//     return []
//   }

//   func contactSnapchatters() -> NSArray {
//     return []
//   }

//   func contactNonSnapchatters() -> NSArray {
//     return []
//   }
// }

// //Prevent discover stories from showing after friend stories.
// class SCOperaPageViewControllerHook: ClassHook<UIViewController> {
//   static let targetName = "SCOperaPageViewController"
//   @Property(.nonatomic) var isDiscoverStory = false

//   private func checkIfDiscoveryStory() {
//     if let page = target.value(forKey: "page") as? NSObject,
//       let properties = page.value(forKey: "properties") as? NSObject
//     {
//       NSLog("SBTWEAK: Got page \(page) properties \(properties)")

//       if properties.value(forKey: "discover_story_composite_id") != nil {
//         isDiscoverStory = true

//       } else {
//         NSLog("SBTWEAK: Friend story")
//       }
//     } else {
//       NSLog("SBTWEAK: Couldn't get page")
//     }

//   }

//   private func dismissStory() {
//     if let parentVC = target.parent {
//       NSLog("SBTWEAK: parentVC \(parentVC)")

//       let selector = NSSelectorFromString("navigationManagerShouldDismiss:")

//       if parentVC.responds(to: selector) {
//         NSLog("SBTWErAK: Responds")

//         let objcMethod = class_getInstanceMethod(type(of: parentVC), selector)

//         if objcMethod != nil {
//           NSLog("SBTWErAK: bout to send")

//           let objc_msgSend = class_getMethodImplementation(type(of: parentVC), selector)

//           typealias objc_msgSend_t = @convention(c) (AnyObject, Selector, NSObject?) -> Void
//           let msgSend = unsafeBitCast(objc_msgSend, to: objc_msgSend_t.self)

//           _ = msgSend(parentVC, selector, nil)
//         }
//       } else {
//         NSLog(
//           "SBTWEAK: Parent view controller does not respond to navigationManagerShouldDismiss")
//       }

//     } else {
//       NSLog("SBTWEAK: Couldn't get parentvc")

//     }

//   }

//   func viewDidLoad() {
//     orig.viewDidLoad()

//     checkIfDiscoveryStory()

//     //Hide the view if it's a discovery story, otherwise you can see the story for a moment when swiping.
//     if isDiscoverStory {
//       target.view.isHidden = true
//     }
//   }

//   func viewDidFullyAppear() {
//     orig.viewDidFullyAppear()

//     //Dismiss the story view if the story is a discover story.
//     if isDiscoverStory {
//       dismissStory()
//     }
//   }
// }

//Hide spinner for discover stories section.
class SCDiscoverFeedLoadingViewCellHook: ClassHook<UIView> {
  static let targetName = "SCDiscoverFeedLoadingViewCell"

  func layoutSubviews() {
    target.isHidden = true
  }
}










// ====== Commented out because it might ban the user ======
//Disable discover stories section.
// class SCDiscoverFeedSectionExtensionServicesHook: ClassHook<NSObject> {
//   static let targetName = "SCDiscoverFeedSectionExtensionServices"

//   //This somehow hides the discover section.
//   func remoteSectionProviders() -> NSDictionary {
//     return [:]
//   }
// }


// //Only allow swiping right on Friends page.
// class SCFriendsFeedViewControllerHook: ClassHook<UIViewController> {
//   static let targetName = "SCFriendsFeedViewController"

//   func viewDidLoad() {
//     orig.viewDidLoad()
//     setSwipeDirection(forController: target, direction: 0)
//   }
// }




// //Only allow swiping left on Stories page.
// class SCDiscoverFeedContainerViewControllerHook: ClassHook<UIViewController> {
//   // static let targetName = "SCDiscoverFeedContainerViewController"
//     static let targetName = "SCSwipeViewConntainerViewController"

//   func viewDidLoad() {
//     orig.viewDidLoad()
//     setSwipeDirection(forController: target, direction: 2)
//   }
// }


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
