"Filed out from Dolphin Smalltalk"!

Tools.Tests.ClassSelectorTest
	subclass: #'Tools.Tests.ClassHierarchySelectorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Tests.ClassHierarchySelectorTest guid: (Core.GUID fromString: '{92fa03e6-71b4-4ff0-8fb9-901b0058396f}')!

Tools.Tests.ClassHierarchySelectorTest comment: ''!

!Tools.Tests.ClassHierarchySelectorTest methodsFor!

classToTest
	^ClassHierarchySelector
!

resetSelection
	super resetSelection.
	self assertContains: Object.
	self assertContains: Behavior! !

!Tools.Tests.ClassHierarchySelectorTest categoriesForMethods!
classToTest!helpers!private! !
resetSelection!helpers!private! !
!

!Tools.Tests.ClassHierarchySelectorTest class methodsFor!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 265030 4 ##(Smalltalk.Menu)  0 16 98 20 984134 2 ##(Smalltalk.CommandMenuItem)  2097153 1180998 4 ##(Smalltalk.CommandDescription)  8 #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 546 0 16 98 10 594 1 626 8 #browseClassPackage 8 'Package <1d>' 1 1 690 0 16 736 8 'Package.ico' 784 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 594 2097153 626 8 #browseClassReferences 8 '&Class References' 1 1 0 0 0 546 0 16 98 0 8 'Local Re&ferences To' 8 #browseVariablesMenu 134217729 0 0 0 0 0 946 4097 594 1 626 8 #browseChangedMethods 8 'Changed &Methods' 1 1 0 0 0 594 1 626 8 #browseMethodHistoryForClass 8 'Method &History' 1 1 0 0 0 946 4097 594 1 626 8 #browsePublishedEvents 8 'Published &events' 1 1 0 0 0 594 1 626 8 #browsePublishedAspects 8 'Published &aspects' 1 1 0 0 0 8 '&Browse' 8 #browseMenu 134217729 0 0 0 0 0 946 4097 594 1 626 8 #newClass 8 '&New...' 1 1 690 0 16 736 8 'NewClass.ico' 784 0 0 594 1 626 8 #deleteClassHierarchy 8 '&Delete' 1 1 690 0 16 736 8 'EditClear.ico' 784 0 0 546 0 16 98 19 594 1 626 8 #safeRemoveClass 8 '&Remove' 1 1 0 0 0 594 2097153 626 8 #renameClass 8 'Re&name...' 1 1 0 0 0 594 1 626 8 #copyClass 8 'Cl&one...' 1 1 0 0 0 946 4097 594 1 626 8 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 0 0 0 594 1 626 8 #addClassVariable 8 'Add &Class Variable...' 1 1 0 0 0 546 0 16 98 0 8 'Re&move Variable' 8 #removeVariables 134217729 0 0 0 0 0 546 0 16 98 0 8 'Ren&ame Variable' 8 #renameVariables 134217729 0 0 0 0 0 946 4097 546 0 16 98 0 8 'Push &Down' 8 #pushDownVariables 134217729 0 0 0 0 0 546 0 16 98 0 8 'Pull &Up' 8 #pullUpVariables 134217729 0 0 0 0 0 946 4097 546 0 16 98 0 8 'Cr&eate Accessors' 8 #createVariableAccessors 134217729 0 0 0 0 0 546 0 16 98 0 8 'A&bstract' 8 #abstractVariables 134217729 0 0 0 0 0 546 0 16 98 0 8 '&Protect/Concrete' 8 #protectVariables 134217729 0 0 0 0 0 946 4097 594 1 626 8 #convertToSibling 8 'Con&vert to Sibling...' 1 1 0 0 0 946 4097 594 1 626 8 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 0 0 0 8 '&Refactorings' 8 #classRefactoringsMenu 134217729 690 0 16 736 8 'Refactoring.ico' 784 0 0 0 0 946 4097 594 1 626 8 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 0 0 0 594 1 626 8 #reformatAll 8 'Refor&mat All' 1 1 0 0 0 946 4097 594 1 626 8 #fileInClass 8 'File &In...' 1 1 0 0 0 594 1 626 8 #fileOutClass 8 'File &Out...' 1 1 0 0 0 946 4097 594 1 626 8 #classPackage 8 '&Package...' 1 1 690 0 16 736 8 'Package.ico' 784 0 0 594 1 626 8 #categorizeClass 8 '&Category...' 1 1 0 0 0 946 4097 594 1 626 8 #browseClassEditions 8 'Browse &Editions' 1 1 0 0 0 594 1 626 8 #compareClass 8 'Compare with...' 1 1 0 0 0 946 4097 546 0 16 98 4 594 1 626 8 #newView 8 '&New...' 1 1 0 0 0 946 4097 546 0 16 98 0 8 '&Edit' 8 #viewsEditMenu 1 0 0 0 0 0 546 0 16 98 0 8 '&Show' 8 #viewsShowMenu 1 0 0 0 0 0 8 '&Views' 8 #viewsMenu 1 690 0 16 736 8 'View.ico' 784 0 0 0 0 8 '&Class' 0 134217729 0 0 0 0 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.TreeView)  98 27 0 416 98 2 8 1140916267 1 3680 590918 3 ##(Smalltalk.TreeModel)  0 1310726 ##(Smalltalk.IdentitySearchPolicy)  525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 98 0 498 528 0 29 0 0 0 3680 0 8 4294902319 459270 ##(Smalltalk.Message)  8 #name 98 0 8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 234 240 3872 17 8 #smallIcons 1 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 4194 701 501 3680 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 98 0 4194 193 193 0 27 234 256 98 2 3680 8 'classes' 0 4066 202 208 98 2 4130 4160 98 2 4194 3839 21 4194 701 501 416 4130 8 #contextMenu: 98 1 560 416 4242 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 98 1 3680 4304 0 27 )! !

!Tools.Tests.ClassHierarchySelectorTest class categoriesForMethods!
resource_Default_view_D6!constants!public! !
!

