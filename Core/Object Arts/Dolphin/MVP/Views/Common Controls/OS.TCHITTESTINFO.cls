"Filed out from Dolphin Smalltalk"!

OS.CCHITTESTINFO subclass: #'OS.TCHITTESTINFO'
	instanceVariableNames: 'iItem'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.TCHITTESTINFO guid: (Core.GUID fromString: '{a369fa40-e397-4c16-b3f5-b254fd07aebe}')!
OS.TCHITTESTINFO comment: 'TCHITTESTINFO is an ExternalStructure class to represent the Win32 common control structure of the same name.

TCHISTTESTINFO is used for hit-testing with Tab View controls.
'!
!OS.TCHITTESTINFO categoriesForClass!External-Data-Structured-Win32! !
!OS.TCHITTESTINFO methodsFor!

handle
	"Private - Answer the item 'handle' associated with the receiver.
	In the case of a TabView hit-test, this is a 1-based integer index."

	^iItem + 1!

iItem: anInteger 
	iItem := anInteger! !
!OS.TCHITTESTINFO categoriesForMethods!
handle!accessing!private! !
iItem:!accessing!private! !
!

