"Filed out from Dolphin Smalltalk X6.2"!

RuntimeSessionManager subclass: #FileSystemMonitorSessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileSystemMonitorSessionManager guid: (GUID fromString: '{A00427FB-6695-464A-8E1F-251A892444A6}')!
FileSystemMonitorSessionManager comment: ''!
!FileSystemMonitorSessionManager categoriesForClass!System-Support! !
!FileSystemMonitorSessionManager methodsFor!

main
	| fsm |
	fsm := self mainShellClass show.
	self argc > 1 
		ifTrue: 
			[| path |
			path := self argv at: 2.
			(File isDirectory: path) ifTrue: [fsm directory: path]]! !
!FileSystemMonitorSessionManager categoriesFor: #main!operations!public! !

!FileSystemMonitorSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^FileSystemMonitor! !
!FileSystemMonitorSessionManager class categoriesFor: #mainShellClass!constants!public! !

