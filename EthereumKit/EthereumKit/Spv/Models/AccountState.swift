import GRDB

class AccountState: Record {
    let address: Data
    let nonce: Int
    let balance: BInt
    let storageHash: Data // Storage Trie root hash
    let codeHash: Data

    init(address: Data, nonce: Int, balance: BInt, storageHash: Data, codeHash: Data) {
        self.address = address
        self.nonce = nonce
        self.balance = balance
        self.storageHash = storageHash
        self.codeHash = codeHash

        super.init()
    }

    override class var databaseTableName: String {
        return "account_states"
    }

    enum Columns: String, ColumnExpression {
        case address
        case nonce
        case balance
        case storageHash
        case codeHash
    }

    required init(row: Row) {
        address = row[Columns.address]
        nonce = row[Columns.nonce]
        balance = row[Columns.balance]
        storageHash = row[Columns.storageHash]
        codeHash = row[Columns.codeHash]

        super.init(row: row)
    }

    override func encode(to container: inout PersistenceContainer) {
        container[Columns.address] = address
        container[Columns.nonce] = nonce
        container[Columns.balance] = balance
        container[Columns.storageHash] = storageHash
        container[Columns.codeHash] = codeHash
    }

    func toString() -> String {
        return "(\n" +
                "  nonce: \(nonce)\n" + 
                "  balance: \(balance.asString(withBase: 10))\n" + 
                "  storageHash: \(storageHash.toHexString())\n" + 
                "  codeHash: \(codeHash.toHexString())\n" +
                ")"
    }

}