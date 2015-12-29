"Filed out from Dolphin Smalltalk X6"!

CCHITTESTINFO subclass: #TCHITTESTINFO
	instanceVariableNames: 'iItem'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TCHITTESTINFO guid: (GUID fromString: '{A369FA40-E397-4C16-B3F5-B254FD07AEBE}')!
TCHITTESTINFO comment: 'TCHITTESTINFO is an ExternalStructure class to represent the Win32 common control structure of the same name.

TCHISTTESTINFO is used for hit-testing with Tab View controls.
'!
!TCHITTESTINFO categoriesForClass!External-Data-Structured-Win32! !
!TCHITTESTINFO methodsFor!

handle
	"Private - Answer the item 'handle' associated with the receiver.
	In the case of a TabView hit-test, this is a 1-based integer index."

	^iItem + 1!

iItem: anInteger 
	iItem := anInteger! !
!TCHITTESTINFO categoriesFor: #handle!accessing!private! !
!TCHITTESTINFO categoriesFor: #iItem:!accessing!private! !

