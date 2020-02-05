import UIKit

private let alertViewWithCallbackDelegate1731 = AlertViewWithCallbackDelegate()

class AlertViewWithCallbackDelegate: NSObject, UIAlertViewDelegate {
  
  class var shared: AlertViewWithCallbackDelegate {
    return alertViewWithCallbackDelegate1731
  }
  
  var callback: ((UIAlertView, Int)->())?
  
  fileprivate override init() {
    super.init()
  }
  
  func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
    callback?(alertView, buttonIndex)
    callback = nil
  }
}
