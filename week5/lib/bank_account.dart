// ===== Week 5 – Part 8: Encapsulation =====
class BankAccount {
  // Private fields: the leading underscore hides them from other files.
  // Outside code can only reach them through the getters/methods below.
  double _balance = 0;
  String _owner;
  final double overdraftLimit;
  final List<String> _transactions = [];

  BankAccount(this._owner, {this.overdraftLimit = 0});

  // Getters: read-only access
  double get balance => _balance;
  String get owner => _owner;
  List<String> get transactions => _transactions;

  // Setter: write access WITH validation
  set owner(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Owner name cannot be empty');
    }
    _owner = value;
  }

  void deposit(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Deposit amount must be greater than zero');
    }
    _balance += amount;
    _transactions.add('Deposit: $amount');
    print('Deposited: $amount, New balance: $_balance');
  }

  void withdraw(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Withdrawal amount must be greater than zero');
    }
    if (amount > _balance + overdraftLimit) {
      throw StateError('Insufficient funds');
    }
    _balance -= amount;
    _transactions.add('Withdrawal: $amount');
    print('Withdrew: $amount, New balance: $_balance');
  }

  void transfer(BankAccount other, double amount) {
    withdraw(amount);
    other.deposit(amount);
  }
}

void main() {
  final ama = BankAccount('Ama', overdraftLimit: 100);
  final kofi = BankAccount('Kofi');

  ama.deposit(500);
  ama.withdraw(200);
  ama.transfer(kofi, 150);

  try {
    ama.withdraw(1000); // more than balance + overdraft
  } catch (e) {
    print('Error: $e');
  }

  print('${ama.owner}: ${ama.balance}');
  print('${kofi.owner}: ${kofi.balance}');
  print('History: ${ama.transactions}');
}