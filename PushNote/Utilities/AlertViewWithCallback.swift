import UIKit

open class AlertViewWithCallback {
  public init() { }

  func show(_ alert: UIAlertView, onButtonTapped: ((UIAlertView, Int)->())?) {
    AlertViewWithCallbackDelegate.shared.callback = onButtonTapped
    alert.delegate = AlertViewWithCallbackDelegate.shared
    alert.show()
  }
}
