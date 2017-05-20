"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ViewTest guid: (GUID fromString: '{cf223394-a19e-45f9-a270-551c288901ef}')!
ViewTest comment: ''!
!ViewTest categoriesForClass!Unclassified! !
!ViewTest methodsFor!

testRecreateMaintainsModelConnection
	| t |
	t := TextPresenter show.
	t model value: 'aaa'.
	self assert: t view value = 'aaa'.
	t view hasBorder: true.
	t model value: 'bbb'.
	"If this fails, then the view did not receive a #valueChanged event from the model"
	self assert: t view value = 'bbb'.
	t topShell exit! !
!ViewTest categoriesFor: #testRecreateMaintainsModelConnection!public!unit tests! !

