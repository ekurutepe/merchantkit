import StoreKit

internal protocol StoreKitTransactionObserverDelegate : class {
    func storeKitTransactionObserver(_ observer: StoreKitTransactionObserver, didPurchaseProductWith identifier: String)
}

internal final class StoreKitTransactionObserver : NSObject, SKPaymentTransactionObserver {
    public weak var delegate: StoreKitTransactionObserverDelegate?
    
    internal override init() {
        super.init()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
                case .purchased:
                    self.completePurchase(for: transaction)
                case .purchasing:
                    break
                case .restored:
                    self.completePurchase(for: transaction.original!)
                case .failed:
                    break
                case .deferred:
                    break
            }
        }
    }
    
    private func completePurchase(for transaction: SKPaymentTransaction) {
        self.delegate?.storeKitTransactionObserver(self, didPurchaseProductWith: transaction.payment.productIdentifier)
    }
}