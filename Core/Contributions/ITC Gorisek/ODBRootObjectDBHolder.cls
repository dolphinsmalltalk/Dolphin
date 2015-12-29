"Filed out from Dolphin Smalltalk X6.2"!

ODBDatabaseObject subclass: #ODBRootObjectDBHolder
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBRootObjectDBHolder guid: (GUID fromString: '{8162EE04-0FB8-11D4-B091-000000000000}')!
ODBRootObjectDBHolder comment: ''!
!ODBRootObjectDBHolder categoriesForClass!No category! !
!ODBRootObjectDBHolder methodsFor!

makeTransactionObject: aTransaction 
	^ODBRootObjectHolder new 
		setObjectHolder: objectHolder
		dataBaseObject: objectHolder rootObjectID
		transaction: aTransaction!

referencesDo: aBlock 
	aBlock value: objectHolder rootObjectID! !
!ODBRootObjectDBHolder categoriesFor: #makeTransactionObject:!public! !
!ODBRootObjectDBHolder categoriesFor: #referencesDo:!public! !

!ODBRootObjectDBHolder class methodsFor!

classID
	"Answer database object classID."

	^1! !
!ODBRootObjectDBHolder class categoriesFor: #classID!public! !

