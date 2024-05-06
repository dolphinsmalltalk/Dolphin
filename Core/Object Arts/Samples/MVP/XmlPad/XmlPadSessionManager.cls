"Filed out from Dolphin Smalltalk"!

RuntimeSessionManager subclass: #XmlPadSessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

XmlPadSessionManager guid: (GUID fromString: '{77f1f2c7-314a-4967-b1ea-0367f0546923}')!

XmlPadSessionManager comment: ''!

!XmlPadSessionManager categoriesForClass!Samples! !

!XmlPadSessionManager methodsFor!

main
	"Start the XmlPad application."

	| pad |
	pad := self mainShellClass show.
	self argc > 1 ifTrue: [pad openFile: (self argv at: 2)]! !

!XmlPadSessionManager categoriesForMethods!
main!operations!public! !
!

!XmlPadSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^XmlPad! !

!XmlPadSessionManager class categoriesForMethods!
mainShellClass!constants!public! !
!

