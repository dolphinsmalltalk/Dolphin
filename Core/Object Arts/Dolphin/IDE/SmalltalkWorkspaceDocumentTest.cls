"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #SmalltalkWorkspaceDocumentTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SmalltalkWorkspaceDocumentTest guid: (GUID fromString: '{bfbd6640-c076-4597-81ac-28c7c2216d37}')!

SmalltalkWorkspaceDocumentTest comment: ''!

!SmalltalkWorkspaceDocumentTest categoriesForClass!Unclassified! !

!SmalltalkWorkspaceDocumentTest methodsFor!

classToTest
	^SmalltalkWorkspaceDocument!

testDefaultPositioning
	"Test that newly opened shells open with a default extent based on the monitor and emulate the well-established windows cascading behaviour."

	| workspaces |
	#nocreate.
	workspaces := OrderedCollection new.
	
	[| shell monitor i defaultExtent nextShell |
	shell := (workspaces add: self classToTest show) view.
	monitor := shell monitor.
	self assert: monitor identicalTo: DisplayMonitor active.
	defaultExtent := self classToTest defaultExtent
				ifNil: [monitor defaultWindowExtent]
				ifNotNil: [:ext | ext * monitor dpi // USER_DEFAULT_SCREEN_DPI].
	self assert: shell extent equals: defaultExtent.
	i := 1.
	
	[(i := i + 1) < 20 and: 
			[nextShell := (workspaces add: self classToTest show) view.
			nextShell position > shell position]]
			whileTrue: 
				[self assert: nextShell monitor identicalTo: monitor.
				self assert: nextShell extent equals: defaultExtent.
				self assert: nextShell position equals: shell position + monitor cascadeOffset.
				shell := nextShell].
	self assert: i > 10.
	"Should have wrapped"
	self assert: nextShell position equals: monitor cascadeOffset]
			ensure: [workspaces do: [:each | each destroy]]! !

!SmalltalkWorkspaceDocumentTest categoriesForMethods!
classToTest!helpers!private! !
testDefaultPositioning!public!unit tests! !
!

