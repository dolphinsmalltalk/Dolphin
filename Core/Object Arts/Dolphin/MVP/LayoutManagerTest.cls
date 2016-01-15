"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #LayoutManagerTest
	instanceVariableNames: 'shell'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LayoutManagerTest guid: (GUID fromString: '{A94F94CC-98CB-4A2E-801E-7C115E70D1F8}')!
LayoutManagerTest comment: ''!
!LayoutManagerTest categoriesForClass!Unclassified! !
!LayoutManagerTest methodsFor!

layoutManagerClass
	^self subclassResponsibility!

setUp
	shell := View desktop addSubView: ShellView new.
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

!LayoutManagerTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!LayoutManagerTest class categoriesFor: #isAbstract!public!Testing! !

