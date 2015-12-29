"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBChangesPackage
	instanceVariableNames: 'changes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBChangesPackage guid: (GUID fromString: '{8162EDCF-0FB8-11D4-B091-000000000000}')!
ODBChangesPackage comment: ''!
!ODBChangesPackage categoriesForClass!No category! !
!ODBChangesPackage methodsFor!

add: aChange 
	changes add: aChange!

changes
	^changes!

collectChangeClassIDsFrom: rootClass to: aDictionary 
	"Private - Collect all change classIDs and store them to aDictionary."

	rootClass changeClassID notNil 
		ifTrue: [aDictionary at: rootClass changeClassID put: rootClass].
	rootClass subclasses do: [:each | self collectChangeClassIDsFrom: each to: aDictionary]!

commit
	changes do: [:each | each commit]!

committed
	"Changes have just been committed."

	changes do: [:each | each committed]!

initialize
	changes := (SortedCollection new: 300) sortBlock: self!

loadFromStream: aStream 
	"Load receiver from aStream."

	"collect change class IDs"

	| memoryStream classID classes change |
	classes := IdentityDictionary new.
	self collectChangeClassIDsFrom: ODBChange to: classes.
	"load changes"
	changes := OrderedCollection new.
	memoryStream := ODBMemoryReadStream new readFrom: aStream.
	[(classID := memoryStream getByte) > 0] whileTrue: 
			[change := (classes at: classID
						ifAbsent: [OmniBase signalError: 'Transaction rollback: Unknown change classID']) new 
						loadFromStream: memoryStream.
			changes add: change]!

rollback
	"Rollback change objects."

	changes do: [:each | each rollback]!

storeOnStream: aStream 
	"Store receiver on aStream."

	| memoryStream classID |
	memoryStream := ODBMemoryWriteStream new.
	changes do: 
			[:each | 
			(classID := each class changeClassID) isNil 
				ifFalse: 
					[memoryStream putByte: classID.
					each storeOnStream: memoryStream]].
	memoryStream
		putByte: 0;
		writeOn: aStream!

transaction: aTransaction 
	changes do: [:each | each transaction: aTransaction]!

value: change1 value: change2 
	"Private - Answer <true> if change1 is to be committed before change2.
	Disk access optimization so that files are updated sequentialy."

	| oid1 oid2 cid1 cid2 |
	(oid1 := change1 objectID) isNil ifTrue: [^true].
	(oid2 := change2 objectID) isNil ifTrue: [^false].
	(cid1 := oid1 containerID) == (cid2 := oid2 containerID) 
		ifTrue: [^oid1 index < oid2 index].
	^cid1 < cid2! !
!ODBChangesPackage categoriesFor: #add:!public! !
!ODBChangesPackage categoriesFor: #changes!public! !
!ODBChangesPackage categoriesFor: #collectChangeClassIDsFrom:to:!private! !
!ODBChangesPackage categoriesFor: #commit!public! !
!ODBChangesPackage categoriesFor: #committed!public! !
!ODBChangesPackage categoriesFor: #initialize!private! !
!ODBChangesPackage categoriesFor: #loadFromStream:!public! !
!ODBChangesPackage categoriesFor: #rollback!public! !
!ODBChangesPackage categoriesFor: #storeOnStream:!public! !
!ODBChangesPackage categoriesFor: #transaction:!public! !
!ODBChangesPackage categoriesFor: #value:value:!private! !

!ODBChangesPackage class methodsFor!

new

    ^super new initialize! !
!ODBChangesPackage class categoriesFor: #new!public! !

