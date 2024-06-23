"Filed out from Dolphin Smalltalk"!

Core.Model
	subclass: #'UI.Examples.PersonalMoney'
	instanceVariableNames: 'owner accounts'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.PersonalMoney guid: (Core.GUID fromString: '{87b4c66a-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.Examples.PersonalMoney comment: 'PersonalMoney represent the entirety of the Personal Money system for a single user. It hold owner details and a collection of accounts for this user.

Instance Variables
	owner	<String> containing the owner''s name
	accounts	<OrderedCollection> of PersonalAccounts.'!

!UI.Examples.PersonalMoney categoriesForClass!MVP-Models!Samples! !

!UI.Examples.PersonalMoney methodsFor!

accounts
	"Answer the accounts collection"

	^accounts!

addAccount: aPersonalAccount
	"Add aPersonalAccount to the collection of accounts owned by the receiver.
	Answers aPersonalAccount"

	^self accounts add: aPersonalAccount!

initialize
	"Private - Initialize the receiver"

	accounts := ListModel new!

owner
	"Answer the owner of the receiver"

	^owner!

owner: aString
	"Set the owner of the receiver to aString"

	owner := aString!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	aStream basicPrint: self; nextPut: $(; print: self owner; nextPut: $).!

removeAccount: aPersonalAccount
	"Remove aPersonalAccount from the collection of accounts owned by the receiver.
	Answers aPersonalAccount"

	^self accounts remove: aPersonalAccount! !

!UI.Examples.PersonalMoney categoriesForMethods!
accounts!accessing!initializing!public! !
addAccount:!adding!public! !
initialize!initializing!private! !
owner!accessing!public! !
owner:!accessing!public! !
printOn:!printing!public! !
removeAccount:!public!removing! !
!

