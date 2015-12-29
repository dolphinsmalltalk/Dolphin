"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBDemandLoader
	instanceVariableNames: 'objectID transaction proxyObject'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBDemandLoader guid: (GUID fromString: '{8162EDD6-0FB8-11D4-B091-000000000000}')!
ODBDemandLoader comment: ''!
!ODBDemandLoader categoriesForClass!No category! !
!ODBDemandLoader methodsFor!

getObject
	^proxyObject odbSetTransactionObject: (transaction transactionObjectAt: objectID)!

odbObjectID
	^objectID!

odbSerialize: serializer 
	(serializer register: objectID) ifFalse: [^serializer saveExternalReference: objectID]!

perform: selector withArguments: arguments 
	^self getObject perform: selector withArguments: arguments!

printOn: aStream 
	objectID printOn: aStream.
	^proxyObject!

setTransaction: aTransaction objectID: anObjectID proxyObject: anODBReference 
	transaction := aTransaction.
	objectID := anObjectID.
	proxyObject := anODBReference!

transaction
	^transaction! !
!ODBDemandLoader categoriesFor: #getObject!public! !
!ODBDemandLoader categoriesFor: #odbObjectID!public! !
!ODBDemandLoader categoriesFor: #odbSerialize:!public! !
!ODBDemandLoader categoriesFor: #perform:withArguments:!public! !
!ODBDemandLoader categoriesFor: #printOn:!public! !
!ODBDemandLoader categoriesFor: #setTransaction:objectID:proxyObject:!public! !
!ODBDemandLoader categoriesFor: #transaction!public! !

