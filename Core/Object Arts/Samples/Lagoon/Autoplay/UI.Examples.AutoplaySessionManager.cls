"Filed out from Dolphin Smalltalk"!

UI.RuntimeSessionManager
	subclass: #'UI.Examples.AutoplaySessionManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.AutoplaySessionManager guid: (Core.GUID fromString: '{4926b46c-437f-4688-a5ff-a86350c68924}')!
UI.Examples.AutoplaySessionManager comment: 'AutoplaySessionManager is the <RuntimeSessionManager> for the Autoplay sample. 

AutoplaySessionManager illustrates starting and parameterizing an applications main shell, simple command-line argument processing, and how to prevent multiple instances of a Dolphin application being started.'!
!UI.Examples.AutoplaySessionManager categoriesForClass!Samples! !
!UI.Examples.AutoplaySessionManager methodsFor!

allowDuplicate
	"It would appear that the image associated with this session is already open. Since we
	don't want more than one setup menu open, answer false to abort the load."

	^false


!

main
	"Start up the Autoplay application"

	| autoplay |
	autoplay := self mainShellClass create.
	self argc > 1 ifTrue: [
		autoplay homePage: (self argv at: 2).
		self argc > 2 ifTrue: [ | stream x y |
			stream := (self argv at: 3) readStream.
			x := Number readFrom: stream.
			stream skipWhile: [:c | c isDigit not].
			y := Number readFrom: stream.
			autoplay pageExtent: x@y]].
	autoplay show! !
!UI.Examples.AutoplaySessionManager categoriesForMethods!
allowDuplicate!operations-startup!public! !
main!operations!public! !
!

!UI.Examples.AutoplaySessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^Autoplay! !
!UI.Examples.AutoplaySessionManager class categoriesForMethods!
mainShellClass!constants!public! !
!

