"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ViewTest guid: (GUID fromString: '{CF223394-A19E-45F9-A270-551C288901EF}')!
ViewTest comment: ''!
!ViewTest categoriesForClass!Unclassified! !
!ViewTest methodsFor!

allResourceIdentifiers

	| badList list |
	badList := self badResourceIdentifiers.
	list := ResourceIdentifier allResourceIdentifiers.
	list := list reject: [:each | badList includes: each printString].
	^list!

badResourceIdentifiers

	^#(
		'DatePresenter.Month view'	"#109"
		'TextPresenter.Masked edit'	"#110"
	)!

testAllResourceIdentifiers
	"Verify that all views actually can be opened. See #badResourceIdentifiers for failures"

	self allResourceIdentifiers do: [:each | 
		| default view |
		[
			view := Smalltalk developmentSystem
				loadViewResource: each resource
				inContext: View desktop.
			default := view class show.
		] ensure: [
			view close.
			default topShell close.
		].
	]!

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
!ViewTest categoriesFor: #allResourceIdentifiers!public!unit tests! !
!ViewTest categoriesFor: #badResourceIdentifiers!public!unit tests! !
!ViewTest categoriesFor: #testAllResourceIdentifiers!public!unit tests! !
!ViewTest categoriesFor: #testRecreateMaintainsModelConnection!public!unit tests! !

