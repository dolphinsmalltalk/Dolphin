"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'UI.Tests.LayoutManagerTest'
	instanceVariableNames: 'shell'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.LayoutManagerTest guid: (Core.GUID fromString: '{a94f94cc-98cb-4a2e-801e-7c115e70d1f8}')!
UI.Tests.LayoutManagerTest isNonInstantiable: true!
UI.Tests.LayoutManagerTest comment: ''!
!UI.Tests.LayoutManagerTest methodsFor!

layoutManagerClass
	^self subclassResponsibility!

setUp
	shell := ShellView show.
	shell
		caption: self class name asPhrase;
		backcolor: Color face3d;
		extent: 300 @ 200.
	shell layoutManager: self layoutManagerClass new.
	shell show!

tearDown
	shell notNil ifTrue: [shell destroy]! !
!UI.Tests.LayoutManagerTest categoriesForMethods!
layoutManagerClass!private!unit tests! !
setUp!public!unit tests! !
tearDown!public!unit tests! !
!

