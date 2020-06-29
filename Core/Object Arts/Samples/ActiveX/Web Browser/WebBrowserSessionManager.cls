"Filed out from Dolphin Smalltalk 7"!

RuntimeSessionManager subclass: #WebBrowserSessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
WebBrowserSessionManager guid: (GUID fromString: '{3a7bff88-3535-4b52-be21-3a61a9a2370e}')!
WebBrowserSessionManager comment: ''!
!WebBrowserSessionManager categoriesForClass!Unclassified! !
!WebBrowserSessionManager methodsFor!

main
	"Start the WebBrowser application."

	| pad |
	pad := self mainShellClass show.
	self argc > 1 ifTrue: [pad openUrl: (self argv at: 2)]!

objectArtsUrl
	"Private - Answer the URL of the Object Arts home page"

	^'http://www.object-arts.com'.! !
!WebBrowserSessionManager categoriesFor: #main!operations!public! !
!WebBrowserSessionManager categoriesFor: #objectArtsUrl!constants!private! !

!WebBrowserSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^WebBrowserShell! !
!WebBrowserSessionManager class categoriesFor: #mainShellClass!constants!public! !

