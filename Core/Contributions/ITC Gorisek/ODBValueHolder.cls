"Filed out from Dolphin Smalltalk 7"!

ODBExternalBuffer subclass: #ODBValueHolder
	instanceVariableNames: 'object removed objectSet'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBValueHolder guid: (GUID fromString: '{8162edf9-0fb8-11d4-b091-000000000000}')!
ODBValueHolder comment: ''!
!ODBValueHolder categoriesForClass!No category! !
!ODBValueHolder methodsFor!

getObjectIn: aTransaction 
	objectSet == true ifTrue: [^object].
	^aTransaction objectAt: self objectID!

isRemoved
	"Answer <true> if the key has been removed 
	(there is no value associated with it)."

	removed isNil ifFalse: [^removed].
	^removed := (self uLongAtOffset: 8) = 0!

loadPreviousVersionFrom: oldHolders 
	| previousVersionPosition |
	previousVersionPosition := self previousVersionPosition.
	previousVersionPosition = 0 
		ifTrue: [contents := ByteArray new: contents size]
		ifFalse: [oldHolders loadAt: previousVersionPosition for: contents]!

makeNewVersion: oldHolders 
	"Store receiver to oldHolders and make new instance
	of receiver class that points to receiver in oldKeys."

	| position |
	self versionNumber = 0 
		ifTrue: [position := 0]
		ifFalse: [position := oldHolders store: contents].
	^(self class new)
		previousVersionPosition: position;
		updateOn: self!

makeRemoved
	"Mark valueHolder as removed."

	contents at: 8 put: ((contents at: 8) bitOr: 128)!

object
	^object!

object: anObject 
	object := anObject.
	removed := false.
	objectSet := true!

objectID
	^ODBObjectID new fromBytes: contents at: 9!

objectID: anObjectID 
	anObjectID putBytesTo: contents at: 9!

previousVersionPosition
	^self uLongAtOffset: 4!

previousVersionPosition: anInteger 
	self uLongAtOffset: 4 put: anInteger!

removed
	"Key has been removed."

	object := nil.
	removed := true!

updateOn: aValueHolder 
	"Private - Make new version from aValueHolder."

	(removed := aValueHolder isRemoved) 
		ifFalse: 
			[object := aValueHolder object.
			objectSet := true]!

versionNumber
	^self uLongAtOffset: 0!

versionNumber: anInteger 
	self uLongAtOffset: 0 put: anInteger! !
!ODBValueHolder categoriesFor: #getObjectIn:!public!public/unclassified! !
!ODBValueHolder categoriesFor: #isRemoved!public! !
!ODBValueHolder categoriesFor: #loadPreviousVersionFrom:!public! !
!ODBValueHolder categoriesFor: #makeNewVersion:!public! !
!ODBValueHolder categoriesFor: #makeRemoved!public! !
!ODBValueHolder categoriesFor: #object!accessing!public! !
!ODBValueHolder categoriesFor: #object:!public!public/accessing! !
!ODBValueHolder categoriesFor: #objectID!accessing!public! !
!ODBValueHolder categoriesFor: #objectID:!accessing!public! !
!ODBValueHolder categoriesFor: #previousVersionPosition!accessing!private! !
!ODBValueHolder categoriesFor: #previousVersionPosition:!accessing!private! !
!ODBValueHolder categoriesFor: #removed!public! !
!ODBValueHolder categoriesFor: #updateOn:!private/unclassified!public! !
!ODBValueHolder categoriesFor: #versionNumber!accessing!public! !
!ODBValueHolder categoriesFor: #versionNumber:!accessing!public! !

!ODBValueHolder class methodsFor!

sizeInBytes
	"versionNumber          4 bytes
	previousVersionPosition 4 bytes
	objectID                4 bytes
	-------------------------------
	total                   12 bytes"

	^12! !
!ODBValueHolder class categoriesFor: #sizeInBytes!private! !

