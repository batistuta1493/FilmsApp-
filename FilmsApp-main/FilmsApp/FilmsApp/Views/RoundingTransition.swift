import UIKit

class RoundingTransition: NSObject {
    
    enum RoundingTransitionProfile: Int {
        case show
        case cancel
        case pop
    }
    
    private let time = 0.3
    
    var transitionProfile: RoundingTransitionProfile = .show
    var roundColor = UIColor.red
    
    var start = CGPoint.zero {
        didSet {
            round.center = start
        }
    }
    
    private var round = UIView()
}

// MARK: - UIViewController AnimatedTransitioning
extension RoundingTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return time
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        
        if transitionProfile == .show {
            if let showedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                let viewCenter = showedView.center
                let viewSize = showedView.frame.size
                
                round = UIView()
                round.frame = roundFrame(withViewCenter: viewCenter, size: viewSize, startPoint: start)
                round.layer.cornerRadius = round.frame.height / 2
                round.center = start
                round.backgroundColor = roundColor
                round.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                container.addSubview(round)
                
                showedView.center = start
                showedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                showedView.alpha = 0
                container.addSubview(showedView)
                
                UIView.animate(withDuration: time, animations: {
                    self.round.transform = CGAffineTransform.identity
                    showedView.transform = CGAffineTransform.identity
                    showedView.alpha = 1
                    showedView.center = viewCenter
                }, completion: { (success: Bool) in
                    transitionContext.completeTransition(success)
                })
            }
        } else {
            let transitionModeKey = (transitionProfile == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            
            if let returnableView = transitionContext.view(forKey: transitionModeKey) {
                let viewCenter = returnableView.center
                let viewSize = returnableView.frame.size
                
                round.frame = roundFrame(withViewCenter: viewCenter, size: viewSize, startPoint: start)
                round.layer.cornerRadius = round.frame.height / 2
                round.center = start
                
                UIView.animate(withDuration: time, animations: {
                    self.round.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returnableView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returnableView.center = self.start
                    returnableView.alpha = 0
                    
                    if self.transitionProfile == .pop {
                        container.insertSubview(returnableView, belowSubview: returnableView)
                        container.insertSubview(self.round, belowSubview: returnableView)
                    }
                }, completion: { (success: Bool) in
                    returnableView.center = viewCenter
                    returnableView.removeFromSuperview()
                    self.round.removeFromSuperview()
                    transitionContext.completeTransition(success)
                })
            }
        }
    }
    
    private func roundFrame(withViewCenter viewCenter: CGPoint, size viewSize: CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        
        let offsetVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
}
