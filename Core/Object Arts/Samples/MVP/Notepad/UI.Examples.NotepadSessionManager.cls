"Filed out from Dolphin Smalltalk"!

UI.RuntimeSessionManager
	subclass: #'UI.Examples.NotepadSessionManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.NotepadSessionManager guid: (Core.GUID fromString: '{10c33fb0-4c63-4493-8746-29ccfcd29ece}')!
UI.Examples.NotepadSessionManager comment: ''!
!UI.Examples.NotepadSessionManager categoriesForClass!Samples! !
!UI.Examples.NotepadSessionManager methodsFor!

main
	"Start the Notepad application."

	| pad |
	pad := self mainShellClass show.
	self argc > 1 ifTrue: [pad openFile: (self argv at: 2)]! !
!UI.Examples.NotepadSessionManager categoriesForMethods!
main!operations!public! !
!

!UI.Examples.NotepadSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^Notepad! !
!UI.Examples.NotepadSessionManager class categoriesForMethods!
mainShellClass!constants!public! !
!

