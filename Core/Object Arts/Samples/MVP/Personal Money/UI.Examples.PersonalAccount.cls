﻿"Filed out from Dolphin Smalltalk"!

Core.Model
	subclass: #'UI.Examples.PersonalAccount'
	instanceVariableNames: 'name accountNumber initialBalance transactions currentBalance'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.PersonalAccount guid: (Core.GUID fromString: '{87b4c668-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.Examples.PersonalAccount comment: 'A PersonalAccount holds all details pertaining to a single account in the PersonalMoney system. 

Instance Variables
	accountNumber 	<String> containing the account number.
	name		<String> containing the account name.
	initialBalance	<Number> that is the opening balance of the account.
	currentBalance	<Number> that is the current balance of the account after the transactions have been applied.
	transactions 	<SortedCollection> of PersonalAccountTransactions.


'!

!UI.Examples.PersonalAccount categoriesForClass!MVP-Models!Samples! !

!UI.Examples.PersonalAccount methodsFor!

accountNumber
	"Answer the account number of the receiver"

	^accountNumber!

accountNumber: aString
	"Set the account number of the receiver to aString"

	accountNumber := aString!

addTransaction: aPersonalAccountTransaction
	"Add aPersonalAccountTransactions to the collection of transactiosn owned by the receiver.
	Answers aPersonalAccountTransaction"

	self transactions add: aPersonalAccountTransaction.
	self calculateCurrentBalance.
	^aPersonalAccountTransaction!

calculateCurrentBalance
	"Calculate and set the current balance of the receiver. Add the total
	of all the actual amounts to the initial balance"

	| balance |
	balance := self transactions inject: self initialBalance into: [:total :each |
		total + each actualAmount ].
	self currentBalance: balance.!

currentBalance
	"Answer the calculated current balance of the receiver."

	^currentBalance!

currentBalance: aNumber
	"Set the current balance of the receiver to aNumber."

	currentBalance := aNumber.
	self trigger: #currentBalanceChanged!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self name displayOn: aPuttableStream.
	aPuttableStream nextPut: $-.
	self accountNumber displayOn: aPuttableStream!

initialBalance
	"Answer the account initial balance of the receiver"

	^initialBalance!

initialBalance: aNumber
	"Set the account initial balance of the receiver to aNumber"

	initialBalance := aNumber.
	self calculateCurrentBalance!

initialize
	"Private - Initialize the receiver"

	name := 'New account'.
	initialBalance := currentBalance := 0.0.
	transactions := ListModel on: 
		(SortedCollection sortBlock: [:x :y | x date <= y date])!

name
	"Answer the account name of the receiver"

	^name!

name: aString
	"Set the account name of the receiver to aString"

	name := aString!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	aStream 
		basicPrint: self;
		nextPut: $(;
		display: self name;
		nextPut: $,;
		display: self accountNumber;
		nextPut: $,;
		display: self currentBalance;
		nextPut: $)!

removeTransaction: aPersonalAccountTransaction
	"Remove aPersonalAccountTransactions from the collection of transactiosn owned by the receiver.
	Answers aPersonalAccountTransaction"

	self transactions remove: aPersonalAccountTransaction.
	self calculateCurrentBalance.
	^aPersonalAccountTransaction!

transactions
	"Answer the transactions collection"

	^transactions! !

!UI.Examples.PersonalAccount categoriesForMethods!
accountNumber!accessing!public! !
accountNumber:!accessing!public! !
addTransaction:!adding!public! !
calculateCurrentBalance!operations!public! !
currentBalance!accessing!public! !
currentBalance:!accessing!public! !
displayOn:!displaying!public! !
initialBalance!accessing!public! !
initialBalance:!accessing!public! !
initialize!initializing!private! !
name!accessing!public! !
name:!accessing!public! !
printOn:!printing!public! !
removeTransaction:!public!removing! !
transactions!accessing!public! !
!

!UI.Examples.PersonalAccount class methodsFor!

publishedEventsOfInstances
	"Answer a Set of Symbols that describe the published events triggered
	by instances of the receiver."

	^super publishedEventsOfInstances
		add: #currentBalanceChanged;
		yourself.
! !

!UI.Examples.PersonalAccount class categoriesForMethods!
publishedEventsOfInstances!development!events!public! !
!

