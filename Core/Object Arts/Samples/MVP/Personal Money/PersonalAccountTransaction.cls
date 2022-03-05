"Filed out from Dolphin Smalltalk"!

Model subclass: #PersonalAccountTransaction
	instanceVariableNames: 'date description amount isDebit'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PersonalAccountTransaction guid: (GUID fromString: '{87b4c669-026e-11d3-9fd7-00a0cc3e4a32}')!
PersonalAccountTransaction comment: 'A PersonalAccountTransaction holds details regarding a single transaction for an account within the PersonalMoney system.

Instance Variables
	amount		<Number> containing the amount of the transaction.
	description		<String> describing the purpose of the transactions.
	date		<Date> on which the transaction was made.
	isDebit		<Boolean> that indicates whether the transaction is a debit or credit.'!
!PersonalAccountTransaction categoriesForClass!MVP-Models!Samples! !
!PersonalAccountTransaction methodsFor!

actualAmount
	"Answer the actual amount of the receiver taking into consideration
	whether it is a debit or credit transaction"

	^self isDebit
		ifTrue: [ self amount negated ]
		ifFalse: [ self amount ]!

amount
	"Answer the amount of the receiver"

	^amount!

amount: aNumber
	"Set the amount of the receiver to aNumber"

	amount := aNumber!

date
	"Answer the date of the receiver"

	^date!

date: aDate
	"Set the date of the receiver to aDate"

	date := aDate!

description
	"Answer the String description of the receiver"

	^description!

description: aString
	"Set the description of the receiver to aString"

	description := aString!

displayOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a user
	would want to see it."

	self date displayOn: aStream.
	aStream nextPutAll: ': '.
	aStream nextPutAll: self description.
	aStream nextPutAll: (self isDebit 
		ifTrue: [' - debit ']
		ifFalse: [ ' - credit ']).
	self amount displayOn: aStream.
!

initialize
	"Private - Initialize the receiver"

	date := Date today.
	description := String new.
	amount := 0.0.
	isDebit := true!

isDebit
	"Answer true if the receiver is a Debit transaction"

	^isDebit!

isDebit: aBoolean
	"Set the receiver to a Debit transaction according to aBoolean.
	If aBoolean is true then the receiver is treated as a credit"

	isDebit := aBoolean!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	aStream 
		basicPrint: self;
		nextPut: $(;
		display: self;
		nextPut: $)! !
!PersonalAccountTransaction categoriesForMethods!
actualAmount!accessing!public! !
amount!accessing!public! !
amount:!accessing!public! !
date!accessing!public! !
date:!accessing!public! !
description!accessing!public! !
description:!accessing!public! !
displayOn:!displaying!public! !
initialize!initializing!private! !
isDebit!accessing!public!testing! !
isDebit:!accessing!public! !
printOn:!printing!public! !
!

