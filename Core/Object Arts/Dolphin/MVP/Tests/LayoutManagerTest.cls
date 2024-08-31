﻿"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #LayoutManagerTest
	instanceVariableNames: 'shell'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

LayoutManagerTest guid: (GUID fromString: '{a94f94cc-98cb-4a2e-801e-7c115e70d1f8}')!

LayoutManagerTest isAbstract: true!

LayoutManagerTest comment: ''!

!LayoutManagerTest categoriesForClass!Unclassified! !

!LayoutManagerTest methodsFor!

layoutManagerClass
	^self subclassResponsibility!

setUp
	shell := ShellView new.
	shell
		create;
		caption: self class name asPhrase;
		backcolor: Color face3d;
		designExtent: 300 @ 200;
		layoutManager: self layoutManagerClass new;
		show!

tearDown
	shell notNil ifTrue: [shell destroy]! !

!LayoutManagerTest categoriesForMethods!
layoutManagerClass!private!unit tests! !
setUp!public!unit tests! !
tearDown!public!unit tests! !
!
