"Filed out from Dolphin Smalltalk X6.2"!

RuntimeSessionManager subclass: #NotepadSessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NotepadSessionManager guid: (GUID fromString: '{10C33FB0-4C63-4493-8746-29CCFCD29ECE}')!
NotepadSessionManager comment: ''!
!NotepadSessionManager categoriesForClass!Samples! !
!NotepadSessionManager methodsFor!

main
	"Start the Notepad application."

	| pad |
	pad := self mainShellClass show.
	self argc > 1 ifTrue: [pad openFile: (self argv at: 2)]! !
!NotepadSessionManager categoriesFor: #main!operations!public! !

!NotepadSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^Notepad! !
!NotepadSessionManager class categoriesFor: #mainShellClass!constants!public! !

