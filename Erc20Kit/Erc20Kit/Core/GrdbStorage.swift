import RxSwift
import BigInt
import GRDB

class GrdbStorage {
    private let dbPool: DatabasePool

    init(databaseDirectoryUrl: URL, databaseFileName: String) {
        let databaseURL = databaseDirectoryUrl.appendingPathComponent("\(databaseFileName).sqlite")

        let configuration: Configuration = Configuration()
//        configuration.trace = { print($0) }

        dbPool = try! DatabasePool(path: databaseURL.path, configuration: configuration)

        try! migrator.migrate(dbPool)
    }

    var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("createTokenBalances") { db in
            try db.create(table: TokenBalance.databaseTableName) { t in
                t.column(TokenBalance.Columns.primaryKey.name, .text).notNull()
                t.column(TokenBalance.Columns.value.name, .text)

                t.primaryKey([TokenBalance.Columns.primaryKey.name], onConflict: .replace)
            }
        }

        migrator.registerMigration("createTransactions") { db in
            try db.create(table: Transaction.databaseTableName) { t in
                t.column(Transaction.Columns.transactionHash.name, .text).notNull()
                t.column(Transaction.Columns.transactionIndex.name, .integer)
                t.column(Transaction.Columns.from.name, .text).notNull()
                t.column(Transaction.Columns.to.name, .text).notNull()
                t.column(Transaction.Columns.value.name, .text).notNull()
                t.column(Transaction.Columns.timestamp.name, .double).notNull()
                t.column(Transaction.Columns.interTransactionIndex.name, .integer).notNull()
                t.column(Transaction.Columns.logIndex.name, .integer)
                t.column(Transaction.Columns.blockHash.name, .text)
                t.column(Transaction.Columns.blockNumber.name, .integer)

                t.primaryKey([Transaction.Columns.transactionHash.name, Transaction.Columns.interTransactionIndex.name], onConflict: .replace)
            }
        }

        return migrator
    }
}

extension GrdbStorage: ITokenBalanceStorage {

    var balance: BigUInt? {
        get {
            let tokenBalance = try! dbPool.read { db in
                try TokenBalance.fetchOne(db)
            }
            return tokenBalance?.value
        }
        set {
            let tokenBalance = TokenBalance(value: newValue)

            _ = try! dbPool.write { db in
                try tokenBalance.insert(db)
            }
        }
    }

}

extension GrdbStorage: ITransactionStorage {

    var lastTransactionBlockHeight: Int? {
        return try! dbPool.read { db in
            try Transaction.order(Transaction.Columns.blockNumber.desc).fetchOne(db)?.blockNumber
        }
    }

    var pendingTransactions: [Transaction] {
        return try! dbPool.read { db in
            try Transaction.filter(Transaction.Columns.logIndex == nil).fetchAll(db)
        }
    }

    func transactionsSingle(from: (hash: Data, interTransactionIndex: Int)?, limit: Int?) -> Single<[Transaction]> {
        return Single.create { [weak self] observer in
            try! self?.dbPool.read { db in
                var request = Transaction.order(Transaction.Columns.timestamp.desc, Transaction.Columns.transactionIndex.desc, Transaction.Columns.interTransactionIndex.desc)

                if let from = from, let fromTransaction = try request.filter(Transaction.Columns.transactionHash == from.hash).filter(Transaction.Columns.interTransactionIndex == from.interTransactionIndex).fetchOne(db) {
                    let transactionIndex = fromTransaction.transactionIndex ?? 0
                    request = request.filter(
                            Transaction.Columns.timestamp < fromTransaction.timestamp ||
                                    (Transaction.Columns.timestamp == fromTransaction.timestamp && Transaction.Columns.transactionIndex < transactionIndex) ||
                                    (Transaction.Columns.timestamp == fromTransaction.timestamp && Transaction.Columns.transactionIndex == fromTransaction.transactionIndex && Transaction.Columns.interTransactionIndex < from.interTransactionIndex)
                    )
                }
                if let limit = limit {
                    request = request.limit(limit)
                }

                observer(.success(try request.fetchAll(db)))
            }

            return Disposables.create()
        }
    }

    func save(transactions: [Transaction]) {
        _ = try! dbPool.write { db in
            for transaction in transactions {
                try transaction.insert(db)
            }
        }
    }

    func update(transaction: Transaction) {
        _ = try! dbPool.write { db in
            try transaction.update(db)
        }
    }

}
