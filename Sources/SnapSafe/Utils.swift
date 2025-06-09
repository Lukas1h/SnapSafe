import Orion
import SnapSafeC
import UIKit

//Utility function to set `allowedDirections` for a page's view controller.
func setSwipeDirection(forController controller: UIViewController, direction: Int) {
  if let parentVC = controller.parent {
    NSLog("SBTWEAK: parentVC \(parentVC)")

    let selector = NSSelectorFromString("setAllowedDirections:")

    if parentVC.responds(to: selector) {
      NSLog("SBTWErAK: Responds")

      let objcMethod = class_getInstanceMethod(type(of: parentVC), selector)

      if objcMethod != nil {
        NSLog("SBTWErAK: bout to send")

        let objc_msgSend = class_getMethodImplementation(type(of: parentVC), selector)

        typealias objc_msgSend_t = @convention(c) (AnyObject, Selector, Int) -> Void
        let msgSend = unsafeBitCast(objc_msgSend, to: objc_msgSend_t.self)

        _ = msgSend(parentVC, selector, direction)
      }
    } else {
      NSLog(
        "SBTWEAK: Parent view controller does not respond to navigationManagerShouldDismiss")
    }

  } else {
    NSLog("SBTWEAK: Couldn't get parentvc")

  }

}