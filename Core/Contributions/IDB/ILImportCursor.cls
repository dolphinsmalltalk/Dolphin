"Filed out from Dolphin Smalltalk"!

ILImportIcon subclass: #ILImportCursor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ILImportCursor guid: (GUID fromString: '{7cfee127-28c8-488d-a83b-2a8d6e1f6fa2}')!

ILImportCursor comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ILImportCursor categoriesForClass!IDB Goodies! !

!ILImportCursor methodsFor!

hotSpotFor: anInteger
	| iconDirEntry |
	iconDirEntry := iconDir idEntries at: anInteger.
	^iconDirEntry wPlanes @ iconDirEntry wBitCount!

proxyClass
	^ILImportCursorProxy! !

!ILImportCursor categoriesForMethods!
hotSpotFor:!accessing!public! !
proxyClass!constants!public! !
!

!ILImportCursor class methodsFor!

isResponsibleFor: aStream
	^(aStream next: 3) = #[0 0 2]! !

!ILImportCursor class categoriesForMethods!
isResponsibleFor:!public!testing! !
!

