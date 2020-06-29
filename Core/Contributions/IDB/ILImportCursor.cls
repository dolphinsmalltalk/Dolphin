"Filed out from Dolphin Smalltalk 7"!

ILImportIcon subclass: #ILImportCursor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!ILImportCursor categoriesFor: #hotSpotFor:!accessing!public! !
!ILImportCursor categoriesFor: #proxyClass!constants!public! !

!ILImportCursor class methodsFor!

isResponsibleFor: aStream
	^(aStream next: 3) = #[0 0 2]! !
!ILImportCursor class categoriesFor: #isResponsibleFor:!public!testing! !

