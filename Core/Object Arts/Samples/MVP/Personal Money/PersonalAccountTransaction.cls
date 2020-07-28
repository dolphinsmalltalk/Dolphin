"Filed out from Dolphin Smalltalk 7"!

Model subclass: #PersonalAccountTransaction
	instanceVariableNames: 'date description amount isDebit'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self date displayOn: aPuttableStream.
	aPuttableStream nextPutAll: ': '.
	aPuttableStream nextPutAll: self description.
	aPuttableStream nextPutAll: (self isDebit ifTrue: [' - debit '] ifFalse: [' - credit ']).
	self amount displayOn: aPuttableStream!

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
!PersonalAccountTransaction categoriesFor: #actualAmount!accessing!public! !
!PersonalAccountTransaction categoriesFor: #amount!accessing!public! !
!PersonalAccountTransaction categoriesFor: #amount:!accessing!public! !
!PersonalAccountTransaction categoriesFor: #date!accessing!public! !
!PersonalAccountTransaction categoriesFor: #date:!accessing!public! !
!PersonalAccountTransaction categoriesFor: #description!accessing!public! !
!PersonalAccountTransaction categoriesFor: #description:!accessing!public! !
!PersonalAccountTransaction categoriesFor: #displayOn:!displaying!public! !
!PersonalAccountTransaction categoriesFor: #initialize!initializing!private! !
!PersonalAccountTransaction categoriesFor: #isDebit!accessing!public!testing! !
!PersonalAccountTransaction categoriesFor: #isDebit:!accessing!public! !
!PersonalAccountTransaction categoriesFor: #printOn:!printing!public! !

