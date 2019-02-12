import Foundation
import RxSwift

protocol IReachabilityManager {
    var isReachable: Bool { get }
    var reachabilitySignal: Signal { get }
}

protocol IApiConfigProvider {
    var reachabilityHost: String { get }
    var apiUrl: String { get }
}

protocol IGethProviderProtocol {
    func getGasPrice() -> Single<Wei>
    func getGasLimit(address: String, data: Data?) -> Single<Wei>
    func getBalance(address: String, contractAddress: String?, blockParameter: BlockParameter) -> Single<Balance>
    func getTransactions(address: String, erc20: Bool, startBlock: Int64) -> Single<Transactions>
    func getBlockNumber() -> Single<Int>
    func getTransactionCount(address: String, blockParameter: BlockParameter) -> Single<Int>
    func sendRawTransaction(rawTransaction: String) -> Single<SentTransaction>
}

protocol IPeriodicTimer {
    var delegate: IPeriodicTimerDelegate? { get set }
    func schedule()
    func invalidate()
}

protocol IPeriodicTimerDelegate: class {
    func onFire()
}

protocol IRefreshKitDelegate: class {
    func onRefresh()
    func onDisconnect()
}

protocol IRefreshManager {
    func didRefresh()
}