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

_testStoreStringForIdentifier: anIdentifier
"
	ViewTest new setTestSelector: #'testStoreString'; _testStoreStringForIdentifier: (ResourceIdentifier class: StyledContainer name: 'Default view').
"
	| string view1 view2 x |
	[
		Transcript cr; show: anIdentifier printString.
		view1 := Smalltalk developmentSystem
			loadViewResource: anIdentifier resource
			inContext: View desktop.
		[
			string := view1 storeString.
			view2 := Compiler evaluate: string.
		] on: CompilerNotification , Error do: [:ex | 
			Transcript show: ' - FAIL'. self halt.
		].
	] ensure: [
		SessionManager inputState
			pumpMessages;
			processDeferredActions.
		(x := view1 topShell) == View desktop ifTrue: [view1 close] ifFalse: [x close].
		view2 ifNotNil: [(x := view2 topShell) == View desktop ifTrue: [view2 close] ifFalse: [x close]].
	].
!

allResourceIdentifiers

	| badList list |
	badList := self badResourceIdentifiers.
	list := ResourceIdentifier allResourceIdentifiers.
	list := list reject: [:each | badList includes: each printString].
	list := list reject: [:each | each owningClass name < ''].
	^list!

badResourceIdentifiers

	^#(
		'AXControlBrowser.Default view'
		'AXControlSite.Default view'
		'AXValueConvertingControlSite.Default view'
		'EditableListViewDemo.Default view'
		'ListPresenter.Editable list view'
		'WordPad.Default view'
		'XmlPad.Default view'
	)!

testAllResourceIdentifiers
	"Verify that all views actually can be opened. See #badResourceIdentifiers for failures"

	true ifTrue: [^self].		"https://github.com/dolphinsmalltalk/Dolphin/pull/108"
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
	t topShell exit!

testStoreString
"
	ViewTest debug: #'testStoreString'
"
	true ifTrue: [^self].		"https://github.com/dolphinsmalltalk/Dolphin/pull/108"
	self allResourceIdentifiers do: [:each | 
		self _testStoreStringForIdentifier: each.
	].
! !
!ViewTest categoriesFor: #_testStoreStringForIdentifier:!public!unit tests! !
!ViewTest categoriesFor: #allResourceIdentifiers!public!unit tests! !
!ViewTest categoriesFor: #badResourceIdentifiers!public!unit tests! !
!ViewTest categoriesFor: #testAllResourceIdentifiers!public!unit tests! !
!ViewTest categoriesFor: #testRecreateMaintainsModelConnection!public!unit tests! !
!ViewTest categoriesFor: #testStoreString!public!unit tests! !

