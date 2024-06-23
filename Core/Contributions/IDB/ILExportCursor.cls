"Filed out from Dolphin Smalltalk"!

ILExportIcon subclass: #ILExportCursor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ILExportCursor guid: (GUID fromString: '{5e60c6ca-e0fd-4036-a41f-7884aec55be9}')!

ILExportCursor comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ILExportCursor categoriesForClass!IDB Goodies! !

!ILExportCursor methodsFor!

hotSpotFor: anILImage
	"Cursors must have an hot spot so use the middle if needed"

	^anILImage hotSpot isNil ifTrue: [anILImage rectangle center] ifFalse: [anILImage hotSpot]!

icondirType
	^2! !

!ILExportCursor categoriesForMethods!
hotSpotFor:!accessing!public! !
icondirType!constants!public! !
!

