"Filed out from Dolphin Smalltalk 7"!

ODBExternalBuffer subclass: #ODBObjectHolder
	instanceVariableNames: 'container objectID oldVersion'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBObjectHolder guid: (GUID fromString: '{8162edf7-0fb8-11d4-b091-000000000000}')!
ODBObjectHolder comment: ''!
!ODBObjectHolder categoriesForClass!No category! !
!ODBObjectHolder methodsFor!

container
	^container!

createOn: aByteArray 
	"Private - Create and initialize receiver."

	contents := aByteArray.
	oldVersion := false!

fileID
	^self uLongAtOffset: 9!

fileID: anInteger 
	self uLongAtOffset: 9 put: anInteger!

getObject
	"Answer database object."

	^(ODBDatabaseObject persistentClassAt: self persistentClassID) new openOn: self!

initialize
	"Private - Initialize receiver."

	oldVersion := false!

isRemoved
	1 to: contents size do: [:i | (contents at: i) == 0 ifFalse: [^false]].
	^true!

loadBytes
	"Load bytes at object position and answer a byte array."

	^container loadBytesAt: self objectPosition length: self objectLength!

loadPreviousVersionFrom: oldHolders 
	"Load previous version holder from oldHolders."

	oldVersion := true.
	oldHolders loadAt: self previousVersionPosition for: contents!

loadPreviousVersionOrNilFrom: oldHolders 
	"Load previous version holder from oldHolders.
	Answer <false> in case of doing online backup for a version in the past and the new version is not yet valid, else answer <true>."

	^oldHolders loadAtOrNil: self previousVersionPosition for: contents!

lockStartPosition
	"Answer start position at which object ID locks are set."

	^2147483648	"at 2 GB"!

lockWith: lockID 
	| indexFile |
	oldVersion ifTrue: [^false].
	indexFile := container indexFile.
	
	[(indexFile
		lock: objectID index;
		at: objectID index) = contents 
		ifTrue: [^indexFile stream lockAt: self lockStartPosition + objectID index length: 1].
	oldVersion := true] 
			ensure: [container indexFile unlock: objectID index].
	^false!

makeNewVersion: oldHolders

        | position |
        self versionNumber = 0 "new object"
                ifTrue: [ position := 0]
                ifFalse: [ position := oldHolders store: contents ].
        ^(self class createOn: contents shallowCopy)
                setContainer: container objectID: objectID;
                previousVersionPosition: position!

objectID
	^objectID!

objectLength
	^((contents at: 10) bitOr: ((contents at: 11) bitShift: 8)) 
		bitOr: ((contents at: 12) bitShift: 16)!

objectLength: anInteger 
	contents
		at: 10 put: (anInteger bitAnd: 255);
		at: 11 put: ((anInteger bitShift: -8) bitAnd: 255);
		at: 12 put: (anInteger bitShift: -16)!

objectPosition
	^self uLongAtOffset: 12!

objectPosition: anInteger 
	self uLongAtOffset: 12 put: anInteger!

oldVersion
	^oldVersion!

persistentClassID
	^contents at: 9!

persistentClassID: anInteger 
	contents at: 9 put: anInteger!

previousVersionPosition
	^self uLongAtOffset: 4!

previousVersionPosition: anInteger 
	self uLongAtOffset: 4 put: anInteger!

printOn: aStream 
	super printOn: aStream.
	aStream nextPut: $(.
	objectID printOn: aStream.
	aStream nextPutAll: ';version='.
	self versionNumber printOn: aStream.
	aStream nextPutAll: ';pid='.
	self persistentClassID printOn: aStream.
	aStream nextPut: $)!

rootObjectID
	"Answer root object ID for root object holder."

	^ODBObjectID new fromBytes: contents at: 10!

rootObjectID: anObjectID 
	"Set root object ID for root object holder."

	anObjectID putBytesTo: contents at: 10!

setContainer: aContainer 
	container := aContainer!

setContainer: aContainer objectID: anObjectID 
	objectID := anObjectID.
	container := aContainer!

store
	"Store contents to indexFile."

	| indexFile index |
	
	[(indexFile := container indexFile)
		lock: (index := objectID index);
		at: index put: contents] 
			ensure: [indexFile unlock: index]!

storeBytes: aByteArray 
	self objectLength: aByteArray size.
	container 
		addByteStorageRequest: (ODBByteStorageRequest new objectHolder: self bytes: aByteArray)!

unlockWith: lockID 
	oldVersion ifTrue: [^false].
	^container indexFile stream unlockAt: self lockStartPosition + objectID index length: 1!

versionNumber
	^self uLongAtOffset: 0!

versionNumber: anInteger 
	self uLongAtOffset: 0 put: anInteger! !
!ODBObjectHolder categoriesFor: #container!accessing!public! !
!ODBObjectHolder categoriesFor: #createOn:!initializing!private! !
!ODBObjectHolder categoriesFor: #fileID!accessing!public! !
!ODBObjectHolder categoriesFor: #fileID:!accessing!public! !
!ODBObjectHolder categoriesFor: #getObject!public! !
!ODBObjectHolder categoriesFor: #initialize!initializing!private! !
!ODBObjectHolder categoriesFor: #isRemoved!public! !
!ODBObjectHolder categoriesFor: #loadBytes!public! !
!ODBObjectHolder categoriesFor: #loadPreviousVersionFrom:!public! !
!ODBObjectHolder categoriesFor: #loadPreviousVersionOrNilFrom:!public! !
!ODBObjectHolder categoriesFor: #lockStartPosition!initializing!private! !
!ODBObjectHolder categoriesFor: #lockWith:!public! !
!ODBObjectHolder categoriesFor: #makeNewVersion:!public! !
!ODBObjectHolder categoriesFor: #objectID!accessing!public! !
!ODBObjectHolder categoriesFor: #objectLength!accessing!private! !
!ODBObjectHolder categoriesFor: #objectLength:!accessing!private! !
!ODBObjectHolder categoriesFor: #objectPosition!accessing!private! !
!ODBObjectHolder categoriesFor: #objectPosition:!accessing!private! !
!ODBObjectHolder categoriesFor: #oldVersion!accessing!public! !
!ODBObjectHolder categoriesFor: #persistentClassID!accessing!private! !
!ODBObjectHolder categoriesFor: #persistentClassID:!accessing!private! !
!ODBObjectHolder categoriesFor: #previousVersionPosition!accessing!private! !
!ODBObjectHolder categoriesFor: #previousVersionPosition:!accessing!private! !
!ODBObjectHolder categoriesFor: #printOn:!public! !
!ODBObjectHolder categoriesFor: #rootObjectID!accessing!public! !
!ODBObjectHolder categoriesFor: #rootObjectID:!accessing!public! !
!ODBObjectHolder categoriesFor: #setContainer:!initializing!private! !
!ODBObjectHolder categoriesFor: #setContainer:objectID:!initializing!private! !
!ODBObjectHolder categoriesFor: #store!public! !
!ODBObjectHolder categoriesFor: #storeBytes:!public! !
!ODBObjectHolder categoriesFor: #unlockWith:!public! !
!ODBObjectHolder categoriesFor: #versionNumber!accessing!public! !
!ODBObjectHolder categoriesFor: #versionNumber:!accessing!public! !

!ODBObjectHolder class methodsFor!

createOn: aByteArray 
	^self basicNew createOn: aByteArray!

new
	^super new initialize!

sizeInBytes
	"Private - Answer number of bytes required to store receiver into a file."

	^16! !
!ODBObjectHolder class categoriesFor: #createOn:!private! !
!ODBObjectHolder class categoriesFor: #new!private! !
!ODBObjectHolder class categoriesFor: #sizeInBytes!private! !

