struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount : Int
    var currency : String
    
    init(amount: Int, currency: String) {
        self.amount = amount
//        guard currency == "USD" || currency == "GBP" || currency == "EUR" || currency == "CAN" else {
//            throw NonValidCurrency
//        }
//        do {
//            try self.currency = currency
//        }
//        catch NonValidCurrency {
//            print("Not a valid currency")
//        }
        self.currency = currency
    }
    
    func convert(_ currency: String) -> Money {
        // normalize to USD
        var amountInUSD = 0
        switch self.currency {
        case "GBP":
            amountInUSD = self.amount * 2
        case "EUR":
            amountInUSD = Int(Double(self.amount / 3 * 2) )
        case "CAN":
            amountInUSD = Int(Double(self.amount / 5 * 4) )
        default:
            amountInUSD = self.amount
        }
        
        // convert to from usd to target currency
        var newAmount = 0
        switch currency {
        case "GBP":
            newAmount = amountInUSD / 2
        case "EUR":
            newAmount = Int(Double(amountInUSD) * 1.5)
        case "CAN":
            newAmount = Int(Double(amountInUSD) * 1.25)
        default:
            newAmount = amountInUSD
        }
        
        return Money(amount: newAmount, currency: currency)
    }
    
    func add(_ newMoney : Money) -> Money {
        if newMoney.currency == self.currency {
            return Money(amount: newMoney.amount + self.amount, currency: self.currency)
        }
        else {
            let convertedMoney = self.convert(newMoney.currency)
            return Money(amount: convertedMoney.amount + newMoney.amount, currency: newMoney.currency)
        }
    }
    
    func subtract(_ newMoney : Money) -> Money {
        if newMoney.currency == self.currency {
            return Money(amount: self.amount - newMoney.amount, currency: self.currency)
        }
        else {
            let convertedMoney = newMoney.convert(self.currency)
            return Money(amount: self.amount - convertedMoney.amount, currency: self.currency)
        }
    }
}

////////////////////////////////////
// Job
//
public class Job {
    var title = ""
    var type : JobType
    init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    func calculateIncome(_ hours : Int) -> Int {
        switch self.type {
        case let .Hourly(wage):
            return Int(wage * Double(hours))
        case let .Salary(pay):
            return Int(pay)
        }
    }
    
    func raise(byAmount : Int) {
        if case let .Salary(pay) = self.type {
            self.type = JobType.Salary(pay + UInt(byAmount))
        }
    }
    
    func raise(byAmount : Double) {
        if case let .Hourly(pay) = self.type {
            self.type = JobType.Hourly(pay + Double(byAmount))
        }
    }
    
    func raise(byPercent : Double) {
        switch self.type {
        case let .Hourly(wage):
            self.type = JobType.Hourly(wage * (Double(byPercent) + 1))
        case let .Salary(pay):
            self.type = JobType.Salary(UInt(Double(pay) * ((Double(byPercent) + 1))))
                                            
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var _firstName : String
    var _lastName : String
    var _age : Int
    var _job : Job?
    var _spouse : Person?
    
    init(firstName : String, lastName : String, age : Int) {
        self._firstName = firstName
        self._lastName = lastName
        self._age = age
    }
    
    public var job : Job? {
        get {
            return self._job
        }
        set {
            if self._age > 15 {
                self._job = newValue
            }
        }
    }
    
    public var spouse : Person? {
        get {
            return self._spouse
        }
        set {
            if self._age > 15 {
                self._spouse = newValue
            }
        }
    }
    
    func toString() -> String {
        return "[Person: firstName:\(self._firstName) lastName:\(self._lastName) age:\(self._age) job:\(self._job) spouse:\(self._spouse)]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members : [Person] = []
    
    init(spouse1 : Person, spouse2 : Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            self.members.append(spouse1)
            self.members.append(spouse2)
            
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
        }
    }
    
    func householdIncome() -> Int {
        var income = 0
        for person in self.members {
            if person.job != nil {
                income += person.job!.calculateIncome(2000)
            }
        }
        return income
    }
    
    func haveChild(_ child : Person) {
        members.append(child)
    }
}
