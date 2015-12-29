"Filed out from Dolphin Smalltalk X6.2"!

ODBFile subclass: #ODBClientTable
	instanceVariableNames: 'table'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBClientTable guid: (GUID fromString: '{8162EE18-0FB8-11D4-B091-000000000000}')!
ODBClientTable comment: ''!
!ODBClientTable categoriesForClass!No category! !
!ODBClientTable methodsFor!

activateClientID: clientID 
	"Mark clientID as active."

	self clientTableAt: clientID lockAndPut: 1!

clientTableAt: index 
	"Private - Answer value at client table index."

	^table at: index + 1!

clientTableAt: index lockAndPut: value 
	"Private - Put value at client table index."

	self waitForLockAt: self headerLength + index length: 1.
	[self clientTableAt: index put: value] 
		ensure: [self unlockAt: self headerLength + index length: 1]!

clientTableAt: index put: value 
	"Private - Put value at client table index."

	stream
		position: self headerLength + index;
		putByte: value!

created
	"Private - Put default values into file."

	"client table"

	stream
		putBytesFrom: (ByteArray new: 258);
		flush!

descriptionString
	^'OmniBase Client Table
OmniBase 1.0, David Gorisek (c) 1998

'!

globalLockClientID
	"Private - Answer clientID of client that has set global lock."

	^table at: 1!

globalLockClientID: clientID 
	"Private - Write clientID of client that has put global lock."

	stream
		position: self headerLength;
		putByte: clientID!

globalUnlock
	self lockTable.
	[self globalLockClientID: 0] ensure: [self unlockTable]!

initialize
	table := ByteArray new: self class maxClients + 1!

isBeingRemoved: clientID 
	"Answer <true> if clientID is being removed."

	^(self clientTableAt: clientID) == 2!

loadTable
	"Private - Load client table from file."

	stream atPosition: self headerLength getBytesFor: table!

lockTable
	"Private - Lock client table from being changed."

	self waitForLockAt: self headerLength length: table size!

onClientIDsDo: aBlock 
	"Evaluate aBlock on every active or disconnected clientID."

	self loadTable.
	1 to: self class maxClients
		do: [:i | (self clientTableAt: i) == 0 ifFalse: [aBlock value: i]]!

onNewClientIDDo: aBlock 
	"Evaluate aBlock with new clientID.
	aBlock will not be evaluated if no clientID is avaiable."

	self lockTable.
	
	[self loadTable.
	1 to: self class maxClients
		do: 
			[:i | 
			(self clientTableAt: i) == 0 
				ifTrue: 
					[self clientTableAt: i put: 2.
					stream flush.
					aBlock value: i.
					self clientTableAt: i put: 1.
					^self]]] 
			ensure: [self unlockTable]!

removeClientID: clientID 
	"Remove clientID."

	self clientTableAt: clientID lockAndPut: 0!

removingClientID: clientID 
	"Client clientID is being removed."

	self lockTable.
	
	[self loadTable.
	self globalLockClientID == clientID ifTrue: [self globalLockClientID: 0].
	(self clientTableAt: clientID) > 0 ifTrue: [self clientTableAt: clientID put: 2]] 
			ensure: [self unlockTable]!

requestLockForClientID: clientID 
	"If global lock has not been set yet, mark that 
	clientID has requested transaction file to store locks. 
	Answer <true> if client can lock objects or <false> if not."

	self lockTable.
	
	[self loadTable.
	self globalLockClientID == 0 ifFalse: [^false].
	self clientTableAt: clientID put: 10.
	^true] 
			ensure: [self unlockTable]!

setGlobalLockFor: clientID 
	"Try to global lock database. Answer <true> if successfull."

	self lockTable.
	
	[self loadTable.
	self globalLockClientID == 0 ifFalse: [^false].
	1 to: self class maxClients do: [:i | (self clientTableAt: i) == 10 ifTrue: [^false]].
	self globalLockClientID: clientID.
	^true] 
			ensure: [self unlockTable]!

unlockTable
	"Private - Unlock client table."

	self unlockAt: self headerLength length: table size! !
!ODBClientTable categoriesFor: #activateClientID:!public! !
!ODBClientTable categoriesFor: #clientTableAt:!public! !
!ODBClientTable categoriesFor: #clientTableAt:lockAndPut:!public! !
!ODBClientTable categoriesFor: #clientTableAt:put:!public! !
!ODBClientTable categoriesFor: #created!public! !
!ODBClientTable categoriesFor: #descriptionString!public! !
!ODBClientTable categoriesFor: #globalLockClientID!public! !
!ODBClientTable categoriesFor: #globalLockClientID:!public! !
!ODBClientTable categoriesFor: #globalUnlock!public! !
!ODBClientTable categoriesFor: #initialize!public! !
!ODBClientTable categoriesFor: #isBeingRemoved:!public! !
!ODBClientTable categoriesFor: #loadTable!public! !
!ODBClientTable categoriesFor: #lockTable!public! !
!ODBClientTable categoriesFor: #onClientIDsDo:!public! !
!ODBClientTable categoriesFor: #onNewClientIDDo:!public! !
!ODBClientTable categoriesFor: #removeClientID:!public! !
!ODBClientTable categoriesFor: #removingClientID:!public! !
!ODBClientTable categoriesFor: #requestLockForClientID:!public! !
!ODBClientTable categoriesFor: #setGlobalLockFor:!public! !
!ODBClientTable categoriesFor: #unlockTable!public! !

!ODBClientTable class methodsFor!

maxClients
	"Answer maximum number of clients connected to database. 
	Valid numbers are from 1 to 255."

	^64! !
!ODBClientTable class categoriesFor: #maxClients!public! !

