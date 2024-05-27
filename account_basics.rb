class Account
    attr_reader :account_number, :account_holder_name, :balance
    @@account_numbers = []

    def initialize(account_holder_name, init_bal, account_number)
        puts "@@account_numbers:: #{@@account_numbers}"

        if @@account_numbers.include?(account_number)
            puts "Account already exists" 
            raise "Account already exists" 
        else
            @account_number = account_number
            @account_holder_name = account_holder_name
            @balance = init_bal
            @@account_numbers << account_number
        end
    end

    def deposit(amount)
        if amount > 0
            @balance += amount
            puts "Amount Deposited: #{amount}"
        else
            puts "Invalid"
        end
    end

    def withdraw(amount)
        if @balance >= amount
            @balance -= amount
            puts "Amount withdrawn #{amount}"
        else
            puts "Invalid"
        end
    end

    def check_balance
        puts "Balance: #{@balance}"
    end
end 
# account_holder_name, init_bal, account_number
acc1 = Account.new("User1", 1000, "123")
acc1.deposit(100)
acc1.check_balance

acc1.withdraw(100)
acc1.check_balance

acc2 = Account.new("User2", 1000, "1123")

acc2.deposit(200)
acc2.check_balance

acc2.withdraw(100)
acc2.check_balance
