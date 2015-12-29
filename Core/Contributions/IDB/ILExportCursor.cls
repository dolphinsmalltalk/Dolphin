"Filed out from Dolphin Smalltalk X6"!

ILExportIcon subclass: #ILExportCursor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ILExportCursor guid: (GUID fromString: '{5E60C6CA-E0FD-4036-A41F-7884AEC55BE9}')!
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
!ILExportCursor categoriesFor: #hotSpotFor:!accessing!public! !
!ILExportCursor categoriesFor: #icondirType!constants!public! !

