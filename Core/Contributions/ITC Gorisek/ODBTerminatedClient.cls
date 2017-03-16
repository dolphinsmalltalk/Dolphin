"Filed out from Dolphin Smalltalk 7"!

ODBClient subclass: #ODBTerminatedClient
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBTerminatedClient guid: (GUID fromString: '{8162ee02-0fb8-11d4-b091-000000000000}')!
ODBTerminatedClient comment: '"Terminated clients are clients that were left connected when the database
was not closed (they still hold locks and their transactions might have been
interrupted while being committed). "'!
!ODBTerminatedClient categoriesForClass!No category! !
!ODBTerminatedClient methodsFor!

isTerminated

    ^true!

loadTransactions

    | transactionFile transaction |
    clientFile transactionIDs do: [:fileID |
        [ transactionFile := ODBTransactionFile openOn: (self trnFileName: fileID) ]
            on: Error do: [:er | transactionFile := nil ].
        transactionFile notNil
            ifTrue: [
                transaction := ODBTerminatedTransaction new.
                transaction transactionFile: transactionFile.
                self transactionAdd: transaction.
                transaction start
            ]
    ]!

openOn: aClientManager clientID: clientID

    | fName |
    id := clientID.
    clientManager := aClientManager.
    fName := clientManager clientFileName: id.
    [ clientFile := ODBClientFile new openOn: fName ]
        on: Error do: [:er | ^nil ].
    clientManager addOpenedClient: self.
    self loadTransactions! !
!ODBTerminatedClient categoriesFor: #isTerminated!public! !
!ODBTerminatedClient categoriesFor: #loadTransactions!private! !
!ODBTerminatedClient categoriesFor: #openOn:clientID:!public! !

