"Filed out from Dolphin Smalltalk"!

UI.Tests.SelectableTreeItemsTest
	subclass: #'UI.Tests.TreeViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.TreeViewTest guid: (Core.GUID fromString: '{9f22e0fe-4151-461c-a92a-f1d9f25e6605}')!

UI.Tests.TreeViewTest comment: ''!

!UI.Tests.TreeViewTest methodsFor!

assertContains: anObject
	self assertNotNil: (presenter view findNode: anObject)!

classToTest
	^TreeView!

testSetImageBlockDoesNotAffectSelection
	presenter view class updateModes do: 
			[:each | 
			presenter view updateMode: each.
			super testSetImageBlockDoesNotAffectSelection.
			presenter view model clear]!

testSetTextBlockDoesNotAffectSelection
	presenter view class updateModes do: 
			[:each | 
			presenter view updateMode: each.
			super testSetTextBlockDoesNotAffectSelection.
			presenter view model clear]!

verifyUpgradedView: anInteger  identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger  identifier: aResourceIdentifier.
	view := self view.
	self assert: view backcolor identicalTo: Color default.
	self assert: view updateMode identicalTo: #dynamic.
	self assertIsNil: view customDrawBlock.
	self assert: view largeIconExtent equals: SystemMetrics default largeIconExtent.
	self assert: view isExpandAllEnabled.
	self assert: view isVirtual.
	anInteger < 13
		ifTrue: [self assert: self view indentSeparation equals: 16 * self view dpi // USER_DEFAULT_SCREEN_DPI]! !

!UI.Tests.TreeViewTest categoriesForMethods!
assertContains:!helpers!private! !
classToTest!helpers!private! !
testSetImageBlockDoesNotAffectSelection!public!unit tests! !
testSetTextBlockDoesNotAffectSelection!public!unit tests! !
verifyUpgradedView:identifier:!helpers!private! !
!

!UI.Tests.TreeViewTest class methodsFor!

resource_Default_view_13
	"Answer the literal data from which the 'Default view 13' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view_13)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.TreeView} 38 #{Core.Array} 35 nil nil 50 2 8 1409352231 1025 32 1094 3 #{UI.TreeModel} nil 6 #{Kernel.IdentitySearchPolicy} 774 #{UI.TreeNode} nil nil nil 550 #{Core.IdentityDictionary} 0 6 #{Graphics.Color} #default nil 5 nil nil nil 32 nil nil 518 #{Core.Message} #displayString 8 #() 274 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil 550 #{Core.LookupTable} 0 nil #noIcons 1 210 0 1 262 #{UI.TreeViewDynamicUpdateMode} 32 nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 199 15 0 0 39 1 0 0] 193 80 8 '' 32 1 8 #() 518 #{Graphics.Point} 193 193 nil 29)!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.TreeView) 98 27 0 0 98 2 8 1409351719 1025 416 590918 3 ##(Smalltalk.TreeModel) 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) 0 0 0 234 256 98 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 0 8 4294903619 459270 ##(Smalltalk.Message) 8 #displayString 98 0 8 ##(Smalltalk.IconicListAbstract) 1049670 1 ##(Smalltalk.IconImageManager) 0 0 0 0 0 234 240 608 17 8 #noIcons 1 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 2799 21 962 401 571 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 63 6 0 0 39 1 0 0] 98 0 962 193 193 0 27)!

resource_Default_view_D7
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.TreeView) 34 27 nil nil 34 2 8 1409352231 1025 416 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 8 #() 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 1903706176 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil 170 176 592 nil #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 592 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 882 401 571 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 71 8 0 0 39 1 0 0] 8 #() 882 193 193 nil 27 )! !

!UI.Tests.TreeViewTest class categoriesForMethods!
resource_Default_view_13!public!resources-views! !
resource_Default_view_D6!public!resources-views! !
resource_Default_view_D7!public!resources-views! !
!

