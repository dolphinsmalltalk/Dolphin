"Filed out from Dolphin Smalltalk"!

ILImport subclass: #ILImportLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ILImportLibrary guid: (GUID fromString: '{b91a4b63-db7b-4d34-b437-50da4e732240}')!
ILImportLibrary comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ILImportLibrary categoriesForClass!IDB Goodies! !
!ILImportLibrary methodsFor!

initializeFrom: aStream
	aStream skip: 3.
	^Object binaryReadFrom: aStream! !
!ILImportLibrary categoriesForMethods!
initializeFrom:!initializing!public! !
!

!ILImportLibrary class methodsFor!

isResponsibleFor: aStream
	[^(aStream next: 3) = 'LIB' asByteArray] ensure: [aStream reset]! !
!ILImportLibrary class categoriesForMethods!
isResponsibleFor:!public!testing! !
!

