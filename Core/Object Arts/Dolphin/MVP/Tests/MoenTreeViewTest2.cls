"Filed out from Dolphin Smalltalk"!

SelectableTreeItemsTest subclass: #MoenTreeViewTest2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MoenTreeViewTest2 guid: (GUID fromString: '{fe4b1b34-22de-4a95-8ba2-05b2f076c51e}')!

MoenTreeViewTest2 comment: 'SUnitBrowser openOnTestCase: self'!

!MoenTreeViewTest2 categoriesForClass!Unclassified! !

!MoenTreeViewTest2 methodsFor!

classToTest
	^MoenTreeView!

mouseDownEventOn: anObject buttons: anArray
	| position |
	position := (presenter nodeForObject: anObject ifAbsent: [])
				ifNil: [presenter clientRectangle corner - 1]
				ifNotNil: [:node | node rectangle origin + 1].
	^self mouseDownEventAt: position buttons: anArray!

oldDolphinVersionsForStbUpgrade
	^2 to: 5!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assert: view backcolor identicalTo: Color default.
	self assert: view isAutoExpanding.
	self assert: view anchorNode isExpanded.
	self assert: view anchorNode hasExpanded!

vuFile
	^'TreePresenter.Moen tree.vu'! !

!MoenTreeViewTest2 categoriesForMethods!
classToTest!helpers!private! !
mouseDownEventOn:buttons:!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!MoenTreeViewTest2 class methodsFor!

resource_Moen_tree_D6
	"Answer the literal data from which the 'Moen tree' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Moen_tree)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.MoenTreeView) 98 30 0 0 98 2 8 1409286144 1 416 590918 3 ##(Smalltalk.TreeModel) 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) 0 0 0 234 256 98 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 517 0 0 0 416 788998 ##(Smalltalk.MoenTreeNode) 0 721926 ##(Smalltalk.MoenContour) 0 0 0 0 328198 ##(Smalltalk.Point) 1 1 752 0 0 0 0 0 7 459270 ##(Smalltalk.Message) 8 #displayString 98 0 432 268435457 738 5 3 1049670 1 ##(Smalltalk.IconImageManager) 738 1 1 41 0 197382 ##(Smalltalk.Pen) 0 16 393478 ##(Smalltalk.LOGPEN) 8 #[0 0 0 0 1 0 0 0 0 0 0 0 192 192 192 0] 738 33 33 738 19999 19999 114721 880 738 35 1 0 0 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 738 2799 21 738 271 251 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 254 5 0 0 135 0 0 0] 98 0 738 193 193 0 27)!

resource_Moen_tree_D7
	"Answer the literal data from which the 'Moen tree' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Moen_tree)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.MoenTreeView) 34 30 nil nil 34 2 8 1409286144 1 416 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 8 #() 327686 ##(Smalltalk.Color) #default nil 517 nil nil nil 416 788998 ##(Smalltalk.MoenTreeNode) nil 721926 ##(Smalltalk.MoenContour) nil nil nil nil 328198 ##(Smalltalk.Point) 1 1 720 nil nil nil nil nil 7 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.MoenTreeView) 268435457 706 5 3 1049926 1 ##(Smalltalk.IconImageManager) 706 1 1 41 nil 197382 ##(Smalltalk.Pen) nil true 393478 ##(Smalltalk.LOGPEN) 8 #[0 0 0 0 1 0 0 0 0 0 0 0 192 192 192 0] 706 33 33 706 19999 19999 114721 832 706 35 1 nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 706 3839 21 706 271 251 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 6 8 0 0 135 0 0 0] 8 #() 706 193 193 nil 27 )! !

!MoenTreeViewTest2 class categoriesForMethods!
resource_Moen_tree_D6!public!resources-views! !
resource_Moen_tree_D7!public!resources-views! !
!

