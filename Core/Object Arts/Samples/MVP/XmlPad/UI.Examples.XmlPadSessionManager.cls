"Filed out from Dolphin Smalltalk"!

UI.RuntimeSessionManager
	subclass: #'UI.Examples.XmlPadSessionManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.XmlPadSessionManager guid: (Core.GUID fromString: '{77f1f2c7-314a-4967-b1ea-0367f0546923}')!
UI.Examples.XmlPadSessionManager comment: ''!
!UI.Examples.XmlPadSessionManager categoriesForClass!Samples! !
!UI.Examples.XmlPadSessionManager methodsFor!

main
	"Start the XmlPad application."

	| pad |
	pad := self mainShellClass show.
	self argc > 1 ifTrue: [pad openFile: (self argv at: 2)]! !
!UI.Examples.XmlPadSessionManager categoriesForMethods!
main!operations!public! !
!

!UI.Examples.XmlPadSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^XmlPad! !
!UI.Examples.XmlPadSessionManager class categoriesForMethods!
mainShellClass!constants!public! !
!

