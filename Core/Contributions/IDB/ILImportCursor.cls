"Filed out from Dolphin Smalltalk X6"!

ILImportIcon subclass: #ILImportCursor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ILImportCursor guid: (GUID fromString: '{7CFEE127-28C8-488D-A83B-2A8D6E1F6FA2}')!
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

