"Filed out from Dolphin Smalltalk"!

RuntimeSessionManager subclass: #DefaultShellSessionManager
	instanceVariableNames: 'mainShellClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
!DefaultShellSessionManager categoriesForMethods!
main!operations-startup!public! !
mainShellClass!constants!public! !
mainShellClass:!constants!public! !
!

!DefaultShellSessionManager class methodsFor!

installNew
	self shouldNotImplement! !
!DefaultShellSessionManager class categoriesForMethods!
installNew!public! !
!

