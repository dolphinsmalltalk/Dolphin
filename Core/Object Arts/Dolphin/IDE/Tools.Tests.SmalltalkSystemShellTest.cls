"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'Tools.Tests.SmalltalkSystemShellTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Tests.SmalltalkSystemShellTest guid: (Core.GUID fromString: '{6d373cd5-f02e-4adb-bce9-f0755886a74b}')!

Tools.Tests.SmalltalkSystemShellTest comment: ''!

!Tools.Tests.SmalltalkSystemShellTest methodsFor!

classToTest
	^SmalltalkSystemShell!

destroyPresenter
	presenter == self classToTest default ifFalse: [super destroyPresenter]!

initializePresenter
	presenter := self classToTest default!

systemFolderPresenter
	^presenter instVarNamed: 'systemFolderPresenter'!

testIconOrdering
	| initialContents sampleApps finalContents |
	"1782"
	initialContents := self systemFolderPresenter contents asArray.
	sampleApps := initialContents detect: [:each | each description = 'Sample Applications'].
	self systemFolderPresenter selection: sampleApps.
	self systemFolderPresenter onActionPerformed.
	self systemFolderPresenter up.
	finalContents := self systemFolderPresenter contents asArray.
	self assert: finalContents equals: initialContents!

testReset
	| oldView |
	oldView := presenter view.
	self classToTest reset.
	presenter := self classToTest default.
	self deny: oldView identicalTo: presenter view.
	self assert: (DisplayMonitor active effectiveWorkArea contains: presenter view rectangle)!

viewClass
	^ShellView! !

!Tools.Tests.SmalltalkSystemShellTest categoriesForMethods!
classToTest!helpers!private! !
destroyPresenter!public!Running! !
initializePresenter!public!Running! !
systemFolderPresenter!private!unit tests! !
testIconOrdering!public!unit tests! !
testReset!public!unit tests! !
viewClass!constants!private! !
!

