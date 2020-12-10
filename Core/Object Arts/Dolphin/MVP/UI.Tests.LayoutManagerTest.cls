"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #LayoutManagerTest
	instanceVariableNames: 'shell'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
LayoutManagerTest guid: (GUID fromString: '{a94f94cc-98cb-4a2e-801e-7c115e70d1f8}')!
LayoutManagerTest isAbstract: true!
LayoutManagerTest comment: ''!
!LayoutManagerTest categoriesForClass!Unclassified! !
!LayoutManagerTest methodsFor!

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
!LayoutManagerTest categoriesFor: #layoutManagerClass!private!unit tests! !
!LayoutManagerTest categoriesFor: #setUp!public!unit tests! !
!LayoutManagerTest categoriesFor: #tearDown!public!unit tests! !

