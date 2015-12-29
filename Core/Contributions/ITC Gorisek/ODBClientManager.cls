"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBClientManager
	instanceVariableNames: 'localClient environment idTable clients'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBClientManager guid: (GUID fromString: '{8162EDD3-0FB8-11D4-B091-000000000000}')!
ODBClientManager comment: ''!
!ODBClientManager categoriesForClass!No category! !
!ODBClientManager methodsFor!

addOpenedClient: aClient 
	"Private - Add opened client to array of clients."

	(clients at: aClient clientID) isNil 
		ifFalse: [OmniBase signalError: 'Client already exists'].
	clients at: aClient clientID put: aClient!

clientAt: clientID 
	"Answer client object for clientID or <nil> if none."

	| client |
	client := clients at: clientID.
	client isNil 
		ifTrue: 
			[client := ODBTerminatedClient new openOn: self clientID: clientID.
			client isNil 
				ifTrue: 
					[client := ODBForeignClient new openOn: self clientID: clientID.
					client isNil 
						ifTrue: 
							[(ODBFileStream exists: (self clientFileName: clientID)) 
								ifFalse: 
									[self
										removePending: clientID;
										removed: clientID]]]].
	^client!

clientFileName: clientID 
	"Private - Answer client file name for clientID."

	^self dirName , ODBFileStream pathSeparatorString , clientID printString , '.usr'!

clients
	"Answer collection of all clients currently connected to database."

	| client coll |
	coll := OrderedCollection new.
	idTable 
		onClientIDsDo: [:clientID | (client := self clientAt: clientID) == nil ifFalse: [coll add: client]].
	^coll!

close

    clients isNil
        ifFalse: [
            clients do: [:each | each == nil ifFalse: [ each remove ]].
            clients := nil ].
    idTable isNil
        ifFalse: [
            idTable close.
            idTable := nil ]!

closeForeignClients
	"Close cached foreign clients."

	clients do: [:each | (each notNil and: [each isForeign]) ifTrue: [each remove]]!

createOn: anEnvironment
        "Create new user manager."

    environment := anEnvironment.
    [   idTable := ODBClientTable createOn: self idFileName.
        self opened
    ] ifCurtailed: [ self close ]!

dirName
	"Private - Answer directory where user files are placed."

	^environment dirName , ODBFileStream pathSeparatorString , 'Users'!

environment

    ^environment!

globalUnlock
                "Private - Remove global lock."

        idTable globalUnlock!

idFileName
	"Private - Answer name of file where client statuses are stored."

	^environment dirName , ODBFileStream pathSeparatorString , 'omnibase.usr'!

localClient
        "Answer local client."

    localClient == nil
        ifFalse: [ ^localClient ]
        ifTrue: [ ^localClient := self newClient ]!

newClient
	"Answer new local client."

	| newClient |
	idTable 
		onNewClientIDDo: [:newID | newClient := ODBLocalClient new createOn: self clientID: newID].
	newClient isNil ifTrue: [OmniBase signalError: 'Maximum number of clients reached'].
	^newClient!

opened
	"Private - Receiver has just been opened."

	clients := Array new: ODBClientTable maxClients.
	"ensure that directory exists in case the database was unzipped
	(WinZIP does not zip and later create empty directories)."
	(ODBFileStream directoryExists: self dirName) 
		ifFalse: [ODBFileStream directoryCreate: self dirName]!

openOn: anOmniBase

	environment := anOmniBase.
	[	idTable := ODBClientTable openOn: self idFileName.
		self opened
	] ifCurtailed: [ self close ]!

removed: clientID
                "Private - Client has been completely removed."

        idTable removeClientID: clientID!

removeDisconnectedClients
	"Remove all disconnected clients."

	self clients do: 
			[:client | 
			(client isTerminated or: [idTable isBeingRemoved: client clientID]) 
				ifTrue: [client remove]]!

removeForeignActiveClient: clientID
                "Private - Foreign active client has been closed."

        clients at: clientID put: nil!

removeLocksFor: clientID
                "Private - Client has no RW transactions anymore."

        ^idTable activateClientID: clientID!

removePending: clientID
                "Private - Client is about to be removed."

        (localClient notNil and: [localClient clientID == clientID]) ifTrue: [localClient := nil].
        clients at: clientID put: nil.
        idTable removingClientID: clientID!

requestLocksFor: clientID
                "Private - Client wants to set locks. Answer <true> if OK."

        ^idTable requestLockForClientID: clientID!

setGlobalLockFor: clientID
                "Private - Client wants to set global lock. Answer <true> if OK."

        ^idTable setGlobalLockFor: clientID
! !
!ODBClientManager categoriesFor: #addOpenedClient:!private! !
!ODBClientManager categoriesFor: #clientAt:!public! !
!ODBClientManager categoriesFor: #clientFileName:!private! !
!ODBClientManager categoriesFor: #clients!public! !
!ODBClientManager categoriesFor: #close!public! !
!ODBClientManager categoriesFor: #closeForeignClients!public! !
!ODBClientManager categoriesFor: #createOn:!public! !
!ODBClientManager categoriesFor: #dirName!private! !
!ODBClientManager categoriesFor: #environment!public! !
!ODBClientManager categoriesFor: #globalUnlock!private! !
!ODBClientManager categoriesFor: #idFileName!private! !
!ODBClientManager categoriesFor: #localClient!public! !
!ODBClientManager categoriesFor: #newClient!public! !
!ODBClientManager categoriesFor: #opened!private! !
!ODBClientManager categoriesFor: #openOn:!public! !
!ODBClientManager categoriesFor: #removed:!private! !
!ODBClientManager categoriesFor: #removeDisconnectedClients!public! !
!ODBClientManager categoriesFor: #removeForeignActiveClient:!private! !
!ODBClientManager categoriesFor: #removeLocksFor:!private! !
!ODBClientManager categoriesFor: #removePending:!private! !
!ODBClientManager categoriesFor: #requestLocksFor:!private! !
!ODBClientManager categoriesFor: #setGlobalLockFor:!private! !

