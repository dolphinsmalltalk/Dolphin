"Filed out from Dolphin Smalltalk 7"!

RuntimeSessionManager subclass: #DefaultShellSessionManager
	instanceVariableNames: 'mainShellClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DefaultShellSessionManager guid: (GUID fromString: '{6554f3ce-3ad5-4ef5-86ce-14ac1596fe2d}')!
DefaultShellSessionManager comment: ''!
!DefaultShellSessionManager categoriesForClass!System-Support! !
!DefaultShellSessionManager methodsFor!

main
	self mainShellClass show!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^mainShellClass!

mainShellClass: aShellClass 
	mainShellClass := aShellClass! !
!DefaultShellSessionManager categoriesFor: #main!operations-startup!public! !
!DefaultShellSessionManager categoriesFor: #mainShellClass!constants!public! !
!DefaultShellSessionManager categoriesFor: #mainShellClass:!constants!public! !

!DefaultShellSessionManager class methodsFor!

installNew
	self shouldNotImplement! !
!DefaultShellSessionManager class categoriesFor: #installNew!public! !

