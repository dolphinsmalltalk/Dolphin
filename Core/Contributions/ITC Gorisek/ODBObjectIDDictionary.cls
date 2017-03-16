"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ODBObjectIDDictionary
	instanceVariableNames: 'dictionaries'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBObjectIDDictionary guid: (GUID fromString: '{8162eddf-0fb8-11d4-b091-000000000000}')!
ODBObjectIDDictionary comment: ''!
!ODBObjectIDDictionary categoriesForClass!No category! !
!ODBObjectIDDictionary methodsFor!

at: objectID 
	"Answer transaction object at objectID or <nil> if absent."

	| dict |
	(dict := dictionaries at: objectID containerID) isNil ifTrue: [^nil].
	^dict at: objectID index!

at: objectID ifAbsentPutValue: anObject 
	| dict |
	(dict := dictionaries at: objectID containerID) isNil 
		ifTrue: [dictionaries at: objectID containerID put: (dict := OmniBase newFastIdentityDictionary: 500)].
	^dict at: objectID index ifAbsentPutValue: anObject!

at: objectID put: anObject 
	| dict |
	(dict := dictionaries at: objectID containerID) isNil 
		ifTrue: [dictionaries at: objectID containerID put: (dict := OmniBase newFastIdentityDictionary: 500)].
	^dict at: objectID index put: anObject!

initialize
	dictionaries := Array new: 255!

removeKey: objectID 
	"Remove transaction object association with objectID. 
	Do nothing if objectID is absent."

	| dict |
	(dict := dictionaries at: objectID containerID) isNil 
		ifFalse: [dict removeKey: objectID index]! !
!ODBObjectIDDictionary categoriesFor: #at:!public! !
!ODBObjectIDDictionary categoriesFor: #at:ifAbsentPutValue:!public! !
!ODBObjectIDDictionary categoriesFor: #at:put:!public! !
!ODBObjectIDDictionary categoriesFor: #initialize!private! !
!ODBObjectIDDictionary categoriesFor: #removeKey:!public! !

!ODBObjectIDDictionary class methodsFor!

new
	^super new initialize! !
!ODBObjectIDDictionary class categoriesFor: #new!instance creation!public! !

