"Filed out from Dolphin Smalltalk 7"!

UI.RuntimeSessionManager subclass: #'UI.DefaultShellSessionManager'
	instanceVariableNames: 'mainShellClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.DefaultShellSessionManager guid: (Core.GUID fromString: '{6554f3ce-3ad5-4ef5-86ce-14ac1596fe2d}')!
UI.DefaultShellSessionManager comment: ''!
!UI.DefaultShellSessionManager categoriesForClass!System-Support! !
!UI.DefaultShellSessionManager methodsFor!

main
	self mainShellClass show!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^mainShellClass!

mainShellClass: aShellClass 
	mainShellClass := aShellClass! !
!UI.DefaultShellSessionManager categoriesFor: #main!operations-startup!public! !
!UI.DefaultShellSessionManager categoriesFor: #mainShellClass!constants!public! !
!UI.DefaultShellSessionManager categoriesFor: #mainShellClass:!constants!public! !

!UI.DefaultShellSessionManager class methodsFor!

installNew
	self shouldNotImplement! !
!UI.DefaultShellSessionManager class categoriesFor: #installNew!public! !

