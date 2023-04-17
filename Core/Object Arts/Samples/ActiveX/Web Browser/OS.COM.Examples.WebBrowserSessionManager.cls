"Filed out from Dolphin Smalltalk"!

UI.RuntimeSessionManager
	subclass: #'OS.COM.Examples.WebBrowserSessionManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Examples.WebBrowserSessionManager guid: (Core.GUID fromString: '{3a7bff88-3535-4b52-be21-3a61a9a2370e}')!
OS.COM.Examples.WebBrowserSessionManager comment: ''!
!OS.COM.Examples.WebBrowserSessionManager methodsFor!

main
	"Start the WebBrowser application."

	| pad |
	pad := self mainShellClass show.
	self argc > 1 ifTrue: [pad openUrl: (self argv at: 2)]! !
!OS.COM.Examples.WebBrowserSessionManager categoriesForMethods!
main!operations!public! !
!

!OS.COM.Examples.WebBrowserSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^WebBrowserShell! !
!OS.COM.Examples.WebBrowserSessionManager class categoriesForMethods!
mainShellClass!constants!public! !
!

