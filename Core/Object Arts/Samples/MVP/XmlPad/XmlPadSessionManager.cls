"Filed out from Dolphin Smalltalk X6.2"!

RuntimeSessionManager subclass: #XmlPadSessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
XmlPadSessionManager guid: (GUID fromString: '{77F1F2C7-314A-4967-B1EA-0367F0546923}')!
XmlPadSessionManager comment: ''!
!XmlPadSessionManager categoriesForClass!Samples! !
!XmlPadSessionManager methodsFor!

main
	"Start the XmlPad application."

	| pad |
	pad := self mainShellClass show.
	self argc > 1 ifTrue: [pad openFile: (self argv at: 2)]! !
!XmlPadSessionManager categoriesFor: #main!operations!public! !

!XmlPadSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^XmlPad! !
!XmlPadSessionManager class categoriesFor: #mainShellClass!constants!public! !

