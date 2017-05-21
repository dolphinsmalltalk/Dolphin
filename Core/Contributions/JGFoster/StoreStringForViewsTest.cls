"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #StoreStringForViewsTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StoreStringForViewsTest guid: (GUID fromString: '{718b74d6-40e5-4ce6-82f3-e931490a1cff}')!
StoreStringForViewsTest comment: ''!
!StoreStringForViewsTest categoriesForClass!Unclassified! !
!StoreStringForViewsTest methodsFor!

_testStoreStringForIdentifier: anIdentifier 
	"
	ViewTest new setTestSelector: #'testStoreString'; _testStoreStringForIdentifier: (ResourceIdentifier class: View name: 'Default view').
"

	| array1 array2 stream string view1 view2 x |
	
	[Transcript
		cr;
		show: anIdentifier printString.
	view1 := Smalltalk developmentSystem loadViewResource: anIdentifier resource inContext: View desktop.
	
	[string := view1 storeStringForView.
	view2 := Compiler evaluate: string.
	array1 := anIdentifier resource.
	stream := WriteStream on: Array new.
	(STLOutFiler on: stream) nextPut: view2.
	array2 := stream contents] 
			on: CompilerNotification , Error
			do: 
				[:ex | 
				Transcript show: ' - FAIL'.
				self assert: false]] 
			ensure: 
				[(SessionManager inputState)
					pumpMessages;
					processDeferredActions.
				(x := view1 topShell) == View desktop ifTrue: [view1 close] ifFalse: [x close].
				view2 ifNotNil: [(x := view2 topShell) == View desktop ifTrue: [view2 close] ifFalse: [x close]]].
	self assert: array1 size = array2 size.
	1 to: array1 size do: [:i | self assert: (array1 at: i) = (array2 at: i)]!

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

	true ifTrue: [^self].	"https://github.com/dolphinsmalltalk/Dolphin/pull/108"
	self allResourceIdentifiers do: 
			[:each | 
			| default view |
			
			[view := Smalltalk developmentSystem loadViewResource: each resource inContext: View desktop.
			default := view class show] 
					ensure: 
						[view close.
						default topShell close]]!

testStoreString
	"
	ViewTest debug: #'testStoreString'
"

	true ifTrue: [^self].	"https://github.com/dolphinsmalltalk/Dolphin/pull/108"
	self allResourceIdentifiers do: [:each | self _testStoreStringForIdentifier: each]! !
!StoreStringForViewsTest categoriesFor: #_testStoreStringForIdentifier:!public!unit tests! !
!StoreStringForViewsTest categoriesFor: #allResourceIdentifiers!public!unit tests! !
!StoreStringForViewsTest categoriesFor: #badResourceIdentifiers!public!unit tests! !
!StoreStringForViewsTest categoriesFor: #testAllResourceIdentifiers!public!unit tests! !
!StoreStringForViewsTest categoriesFor: #testStoreString!public!unit tests! !

