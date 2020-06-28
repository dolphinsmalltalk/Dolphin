"Filed out from Dolphin Smalltalk 7"!

ClassSelector subclass: #ClassHierarchySelector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ClassHierarchySelector guid: (GUID fromString: '{e11cf5f9-c2ec-47e1-ba1f-fa2fc4c88ad7}')!
ClassHierarchySelector comment: 'A ClassHierarchySelector is used to display a tree of classes. It implements the behaviour common to the class hierarchy panes in the <ClassBrowserShell> and <ClassHierarchyDiagram>.'!
!ClassHierarchySelector categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !
!ClassHierarchySelector methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	classesPresenter := self add: TreePresenter new name: 'classes'!

customDrawClassTree: anNMTVCUSTOMDRAW
	"Private - Custom drawing to implement the emphasis in the class hierarchy tree."

	| class |
	class := anNMTVCUSTOMDRAW item.
	class isNonInstantiable ifTrue: [anNMTVCUSTOMDRAW font isItalic: true].
	class isDeprecated ifTrue: [anNMTVCUSTOMDRAW font isStruckThrough: true]!

expand: aClass
	"Expands aClass in the displayed hierarchy"

	classesPresenter expand: aClass!

expandAll: aClass
	"Expands aClass and all it's subclasses in the displayed hierarchy"

	classesPresenter expandAll: aClass!

newClass
	"Create a new subclass of the selected class (or a subclass of nil if no class is actually selected)."

	| aClass package |
	aClass := self selectionOrNil.
	package := aClass isNil ifFalse: [aClass owningPackage].
	(self systemModel createSubclassOf: aClass inPackage: package) 
		ifNotNil: [:newClass | self actualClass: newClass]! !
!ClassHierarchySelector categoriesFor: #createComponents!initializing!public! !
!ClassHierarchySelector categoriesFor: #customDrawClassTree:!helpers!private! !
!ClassHierarchySelector categoriesFor: #expand:!operations!public! !
!ClassHierarchySelector categoriesFor: #expandAll:!operations!public! !
!ClassHierarchySelector categoriesFor: #newClass!commands!public! !

!ClassHierarchySelector class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^Smalltalk developmentSystem classHierarchy!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 327686 ##(Smalltalk.Color) #default nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 17 984134 2 ##(Smalltalk.CommandMenuItem) 2097153 1180998 4 ##(Smalltalk.CommandDescription) #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 514 nil true 34 10 562 1 594 #browseClassPackage 8 'Package <1d>' 1 1 642 nil true 688 8 'Package.ico' 736 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 562 2097153 594 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 514 nil true 8 #() 8 'Local Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 882 4097 562 1 594 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 562 1 594 #browseMethodHistoryForClass 8 'Method &History' 1 1 642 nil true 688 8 'MethodHistory.ico' 736 nil nil 882 4097 562 1 594 #browsePublishedEvents 8 'Published &events' 1 1 642 nil true 688 8 'Event.ico' 736 nil nil 562 1 594 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 882 4097 562 1 594 #newClass 8 '&New...' 1 1 642 nil true 688 8 'NewClass.ico' 736 nil nil 562 1 594 #deleteClassHierarchy 8 '&Delete' 1 1 642 nil true 688 8 'EditClear.ico' 736 nil nil 514 nil true 34 19 562 1 594 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 562 2097153 594 #renameClass 8 'Re&name...' 1 1 642 nil true 688 8 'Rename.ico' 736 nil nil 562 1 594 #copyClass 8 'Cl&one...' 1 1 nil nil nil 882 4097 562 1 594 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 562 1 594 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 514 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 514 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 882 4097 514 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 514 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 882 4097 514 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 514 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 514 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 882 4097 562 1 594 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 882 4097 562 1 594 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 642 nil true 688 8 'Refactoring.ico' 736 nil nil nil nil 882 4097 562 1 594 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 562 1 594 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 882 4097 562 1 594 #fileInClass 8 'File &In...' 1 1 642 nil true 688 8 'FileIn.ico' 736 nil nil 562 1 594 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 882 4097 562 1 594 #classPackage 8 '&Package...' 1 1 642 nil true 688 8 'Package.ico' 736 nil nil 562 1 594 #categorizeClass 8 '&Category...' 1 1 642 nil true 688 8 'Category.ico' 736 nil nil 882 4097 514 nil true 34 4 562 1 594 #newView 8 '&New...' 1 1 nil nil nil 882 4097 514 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 642 nil true 688 8 'ViewComposer.ico' 736 nil nil nil nil 514 nil true 8 #() 8 '&Show' #viewsShowMenu 1 642 nil true 688 8 'TestView.ico' 736 nil nil nil nil 8 '&Views' #viewsMenu 134217729 642 nil true 688 8 'View.ico' 736 nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.TreeView) 34 27 nil 416 34 2 8 1140916779 1 3152 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 8 #() 496 nil 29 nil nil nil 3152 nil 8 1903706176 459270 ##(Smalltalk.Message) #name 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 5 1 3440 8 'doIt' 8 '[:ctx | ctx view parentView presenter  customDrawClassTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #parentView #presenter #customDrawClassTree: 3456 7 257 nil nil nil 170 176 3328 nil #smallIcons 1 170 ##(Smalltalk.PluggableLookupTable) 3328 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 3698 701 501 3152 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 8 #() 3698 193 193 nil 27 170 192 34 2 3152 8 'classes' nil 3586 138 144 34 2 3650 #createAt:extent: 34 2 3698 3839 21 3698 701 501 416 3650 #contextMenu: 34 1 528 416 3746 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 34 1 3152 3808 nil 27 )!

resource_Moen_view
	"Answer the literal data from which the 'Moen view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Moen_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScrollingDecorator) 34 18 nil nil 34 2 8 1412431872 131073 416 nil 327686 ##(Smalltalk.Color) #default nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 2 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 514 nil true 34 4 562 1 594 #browseClassPackage 8 'Package <1d>' 1 1 642 nil true 688 8 'Package.ico' 736 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 562 1 594 #browseClass 8 '&Class' 1 1 642 nil true 688 8 'ClassBrowserShell.ico' 736 nil nil 562 2097153 594 #browseClassReferences 8 'Class &References' 1 1 nil nil nil 8 '&Browse' #browse 134217729 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 416 1573190 1 ##(Smalltalk.ScrollingDecoratorLayout) true 170 192 34 2 410 ##(Smalltalk.MoenTreeView) 34 30 nil 416 34 2 8 1140916224 1 1136 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 8 #() 496 nil 541 nil nil nil 1136 788998 ##(Smalltalk.MoenTreeNode) nil 721926 ##(Smalltalk.MoenContour) nil nil nil nil 328198 ##(Smalltalk.Point) 1 1 1408 nil nil nil nil nil 7 459270 ##(Smalltalk.Message) #name 8 #() ##(Smalltalk.IconicListAbstract) 3 3 1049926 1 ##(Smalltalk.IconImageManager) 1394 21 21 41 nil 197382 ##(Smalltalk.Pen) nil true 393478 ##(Smalltalk.LOGPEN) 8 #[0 0 0 0 1 0 0 0 0 0 0 0 212 208 200 0] 1394 33 33 1394 19999 19999 65609 1394 1 1 1394 35 1 nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 1394 1 1 1394 771 521 1136 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 129 1 0 0 4 1 0 0] 8 #() 1394 193 193 nil 27 8 'classes' nil 1394 1 1 true 1394 33 33 1666 138 144 34 2 1730 #createAt:extent: 34 2 1394 3839 21 1394 771 521 416 1730 #contextMenu: 34 1 528 416 1810 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 0 9 0 0 14 1 0 0] 34 1 1136 1872 nil 27 )! !
!ClassHierarchySelector class categoriesFor: #defaultModel!models!public! !
!ClassHierarchySelector class categoriesFor: #resource_Default_view!public!resources-views! !
!ClassHierarchySelector class categoriesFor: #resource_Moen_view!public!resources-views! !

