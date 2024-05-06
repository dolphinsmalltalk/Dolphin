"Filed out from Dolphin Smalltalk"!

RuntimeSessionManager subclass: #NotepadSessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NotepadSessionManager guid: (GUID fromString: '{10c33fb0-4c63-4493-8746-29ccfcd29ece}')!

NotepadSessionManager comment: ''!

!NotepadSessionManager categoriesForClass!Samples! !

!NotepadSessionManager methodsFor!

main
	"Start the Notepad application."

	| pad |
	pad := self mainShellClass show.
	self argc > 1 ifTrue: [pad openFile: (self argv at: 2)]! !

!NotepadSessionManager categoriesForMethods!
main!operations!public! !
!

!NotepadSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^Notepad! !

!NotepadSessionManager class categoriesForMethods!
mainShellClass!constants!public! !
!

