"Filed out from Dolphin Smalltalk 7"!

ILImport subclass: #ILImportLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!ILImportLibrary categoriesFor: #initializeFrom:!initializing!public! !

!ILImportLibrary class methodsFor!

isResponsibleFor: aStream
	[^(aStream next: 3) = 'LIB' asByteArray] ensure: [aStream reset]! !
!ILImportLibrary class categoriesFor: #isResponsibleFor:!public!testing! !

