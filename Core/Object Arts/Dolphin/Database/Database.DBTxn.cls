"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Database.DBTxn'
	instanceVariableNames: 'connection readOnly creator'
	classVariableNames: ''
	imports: #(#{OS.ODBCConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
Database.DBTxn guid: (Core.GUID fromString: '{87b4c478-026e-11d3-9fd7-00a0cc3e4a32}')!
Database.DBTxn comment: 'A DBTxn instance represents a Database Connection transaction in progress.

Generally one does not explicitly instantiate DBTxn instances, but rather one uses the methods DBConnection>>beginRWTxn, and DBConnection>>beginTxn to create an appropriate type of transaction on a specific connection. 

Instance Variables:
	connection		<DBConnection> on which the transaction is active.
	readOnly		<Boolean> flag indicating whether the transaction is read only or not.
	creator		<Object>

'!
!Database.DBTxn categoriesForClass!ODBC Interface! !
!Database.DBTxn methodsFor!

beReadOnly
	"Set the receiver's readOnly inst var to true."

	readOnly := true!

beReadWrite
	"Set the receiver's readOnly inst var to false."

	readOnly := false!

commit
	"Commit the transaction."

	readOnly ifTrue: [^self rollback].
	self transcriptMessage: 'committing...'.
	DBConnection transact: connection action: SQL_COMMIT!

connection
	"Answer the connection instance variable."

	^connection!

connection: aDBConnection
	"Private - Set the connection instance variable to aDBConnection."

	connection := aDBConnection.!

creator: anObject
	"Private - Set the creator instance variable to anObject."

	creator := anObject.
	self transcriptMessage: 'New transaction...'!

printOn: aStream
	"Print a text representation of the receiver on aStream."

	super printOn: aStream.
	aStream
		nextPutAll: '(commits ';
		nextPutAll: (readOnly
			ifTrue: ['disabled']
			ifFalse: ['enabled']);
		nextPutAll: connection dsn;
		nextPutAll: ', belonging to: ';
		nextPutAll: creator printString;
		nextPut: $)!

rollback
	"Free up all resources held by the tuples opened during this
	transaction"

	self transcriptMessage: 'rolling back...'.
	DBConnection transact: connection action: SQL_ROLLBACK!

transcriptMessage: aString
	"Private - Output an appropriately annotated message to the current
	session's trace device. In a development session this is the Transcript,
	and in a runtime session it is typically the debug trace device."

	creator notNil
		ifTrue: 
			[(SessionManager current traceStream)
				print: self;
				space;
				nextPutAll: aString;
				cr]! !
!Database.DBTxn categoriesFor: #beReadOnly!accessing!public! !
!Database.DBTxn categoriesFor: #beReadWrite!accessing!public! !
!Database.DBTxn categoriesFor: #commit!operations!public! !
!Database.DBTxn categoriesFor: #connection!accessing!public! !
!Database.DBTxn categoriesFor: #connection:!initializing!private! !
!Database.DBTxn categoriesFor: #creator:!development!private! !
!Database.DBTxn categoriesFor: #printOn:!printing!public! !
!Database.DBTxn categoriesFor: #rollback!operations!public! !
!Database.DBTxn categoriesFor: #transcriptMessage:!operations-logging!private! !

!Database.DBTxn class methodsFor!

newOn: aDBConnection
	"Answer an instance of the receiver with commits disabled."

	^super new
		connection: aDBConnection;
		beReadOnly;
		yourself!

newRWOn: aDBConnection
	"Answer an instance of the receiver with commits enabled."

	^super new
		connection: aDBConnection;
		beReadWrite;
		yourself! !
!Database.DBTxn class categoriesFor: #newOn:!instance creation!public! !
!Database.DBTxn class categoriesFor: #newRWOn:!instance creation!public! !

