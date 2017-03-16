"Filed out from Dolphin Smalltalk 7"!

ODBClient subclass: #ODBForeignClient
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBForeignClient guid: (GUID fromString: '{8162ee00-0fb8-11d4-b091-000000000000}')!
ODBForeignClient comment: '"Used to monitor clients connected to database. Foreign clients can not modify
objects in the database. "'!
!ODBForeignClient categoriesForClass!No category! !
!ODBForeignClient methodsFor!

isForeign

    ^true!

openOn: aClientManager clientID: clientID

    | fName |
    id := clientID.
    clientManager := aClientManager.
    fName := clientManager clientFileName: id.
    [ clientFile := ODBClientFile new openReadOnlyOn: fName ]
        on: Error do: [ :er | ^nil ].
    clientManager addOpenedClient: self
!

remove
	"Remove client from database. 
	Close files only, because client may be still active."

	clientFile isNil 
		ifFalse: 
			[self transactions copy do: [:each | each abort].
			clientFile close.
			clientFile := nil.
			clientManager removeForeignActiveClient: id]!

transactions
        "Answer all R/W transactions started by receiver."

    self updateTransactions.
    ^transactions!

updateTransactions
	"Private - Update transactions from transaction files."

	! !
!ODBForeignClient categoriesFor: #isForeign!public! !
!ODBForeignClient categoriesFor: #openOn:clientID:!public! !
!ODBForeignClient categoriesFor: #remove!public! !
!ODBForeignClient categoriesFor: #transactions!public! !
!ODBForeignClient categoriesFor: #updateTransactions!private! !

