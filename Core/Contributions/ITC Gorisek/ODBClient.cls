"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBClient
	instanceVariableNames: 'id clientFile transactions clientManager transactionFiles'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBClient guid: (GUID fromString: '{8162EDD2-0FB8-11D4-B091-000000000000}')!
ODBClient comment: ''!
!ODBClient categoriesForClass!No category! !
!ODBClient methodsFor!

clientID
        "Answer client ID."

    ^id!

description
	"Answer client description string."

	^clientFile clientDescription!

initialize

    transactions := OrderedCollection new.
    transactionFiles := OrderedCollection new!

isForeign

    ^false!

isTerminated

    ^false!

remove
	"Remove client from database."

	| cf |
	clientFile isNil 
		ifFalse: 
			[clientManager removePending: id.
			self transactions copy do: [:t | t abort].
			cf := clientFile.
			clientFile := nil.
			cf remove ifTrue: [clientManager removed: id]]!

transactionAdd: aTransaction
        "Private - Add aTransaction to client."

    transactions add: aTransaction.
    aTransaction setClient: self environment: clientManager environment!

transactionRemove: aTransaction
        "Private - Remove aTransaction."

    | trnFile trID |
    (trnFile := aTransaction transactionFile) == nil
        ifFalse: [
            trID := trnFile transactionID.
            trnFile remove
                ifTrue: [
                    transactionFiles remove: trID ifAbsent: [].
                    clientFile transactionIDs: transactionFiles.
                    transactionFiles isEmpty
                        ifTrue: [ clientManager removeLocksFor: id ]
                ]
        ].
    transactions remove: aTransaction ifAbsent: []!

transactions
        "Answer collection of R/W transactions started by client."

    ^transactions asArray!

trnFileName: fileID 
	"Private - Answer transaction file name."

	^clientManager dirName , ODBFileStream pathSeparatorString , fileID printString , '.trn'! !
!ODBClient categoriesFor: #clientID!public! !
!ODBClient categoriesFor: #description!public! !
!ODBClient categoriesFor: #initialize!private! !
!ODBClient categoriesFor: #isForeign!public! !
!ODBClient categoriesFor: #isTerminated!public! !
!ODBClient categoriesFor: #remove!public! !
!ODBClient categoriesFor: #transactionAdd:!private! !
!ODBClient categoriesFor: #transactionRemove:!private! !
!ODBClient categoriesFor: #transactions!public! !
!ODBClient categoriesFor: #trnFileName:!private! !

!ODBClient class methodsFor!

new

    ^super new initialize! !
!ODBClient class categoriesFor: #new!public! !

