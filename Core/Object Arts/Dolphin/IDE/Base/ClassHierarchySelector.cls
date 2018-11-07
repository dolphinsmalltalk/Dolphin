"Filed out from Dolphin Smalltalk 7"!

ClassSelector subclass: #ClassHierarchySelector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 17 984134 2 ##(Smalltalk.CommandMenuItem) 2097153 1180998 4 ##(Smalltalk.CommandDescription) #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 530 nil true 34 10 578 1 610 #browseClassPackage 8 'Package <1d>' 1 1 658 nil true 704 8 'Package.ico' 752 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 578 2097153 610 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 530 nil true 8 #() 8 'Local Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 898 4097 578 1 610 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 578 1 610 #browseMethodHistoryForClass 8 'Method &History' 1 1 658 nil true 704 8 'MethodHistory.ico' 752 nil nil 898 4097 578 1 610 #browsePublishedEvents 8 'Published &events' 1 1 658 nil true 704 8 'Event.ico' 752 nil nil 578 1 610 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 898 4097 578 1 610 #newClass 8 '&New...' 1 1 658 nil true 704 8 'NewClass.ico' 752 nil nil 578 1 610 #deleteClassHierarchy 8 '&Delete' 1 1 658 nil true 704 8 'EditClear.ico' 752 nil nil 530 nil true 34 19 578 1 610 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 578 2097153 610 #renameClass 8 'Re&name...' 1 1 658 nil true 704 8 'Rename.ico' 752 nil nil 578 1 610 #copyClass 8 'Cl&one...' 1 1 nil nil nil 898 4097 578 1 610 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 578 1 610 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 530 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 530 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 898 4097 530 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 530 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 898 4097 530 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 530 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 530 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 898 4097 578 1 610 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 898 4097 578 1 610 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 658 nil true 704 8 'Refactoring.ico' 752 nil nil nil nil 898 4097 578 1 610 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 578 1 610 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 898 4097 578 1 610 #fileInClass 8 'File &In...' 1 1 658 nil true 704 8 'FileIn.ico' 752 nil nil 578 1 610 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 898 4097 578 1 610 #classPackage 8 '&Package...' 1 1 658 nil true 704 8 'Package.ico' 752 nil nil 578 1 610 #categorizeClass 8 '&Category...' 1 1 658 nil true 704 8 'Category.ico' 752 nil nil 898 4097 530 nil true 34 4 578 1 610 #newView 8 '&New...' 1 1 nil nil nil 898 4097 530 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 658 nil true 704 8 'ViewComposer.ico' 752 nil nil nil nil 530 nil true 8 #() 8 '&Show' #viewsShowMenu 1 658 nil true 704 8 'TestView.ico' 752 nil nil nil nil 8 '&Views' #viewsMenu 134217729 658 nil true 704 8 'View.ico' 752 nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.TreeView) 34 27 nil 416 34 2 8 1140916779 1 3168 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 8 #() 496 nil 29 nil nil nil 3168 nil 8 1914975136 459270 ##(Smalltalk.Message) #name 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 5 1 3456 8 'doIt' 8 '[:ctx | ctx view parentView presenter  customDrawClassTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #parentView #presenter #customDrawClassTree: 3472 7 257 nil nil nil 170 176 3344 nil #smallIcons 1 170 ##(Smalltalk.PluggableLookupTable) 3344 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 3714 701 501 3168 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 8 #() 3714 193 193 nil 27 170 192 34 2 3168 8 'classes' nil 3602 138 144 34 2 3666 #createAt:extent: 34 2 3714 3839 21 3714 701 501 416 3666 #contextMenu: 34 1 544 416 3762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 34 1 3168 3824 nil 27 )!

resource_Moen_view
	"Answer the literal data from which the 'Moen view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Moen_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScrollingDecorator) 34 18 nil nil 34 2 8 1412431872 131073 416 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 2 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 530 nil true 34 4 578 1 610 #browseClassPackage 8 'Package <1d>' 1 1 658 nil true 704 8 'Package.ico' 752 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 578 1 610 #browseClass 8 '&Class' 1 1 658 nil true 704 8 'ClassBrowserShell.ico' 752 nil nil 578 2097153 610 #browseClassReferences 8 'Class &References' 1 1 nil nil nil 8 '&Browse' #browse 134217729 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 416 1573190 1 ##(Smalltalk.ScrollingDecoratorLayout) true 170 192 34 2 410 ##(Smalltalk.MoenTreeView) 34 30 nil 416 34 2 8 1140916224 1 1152 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 8 #() 496 nil 541 nil nil nil 1152 788998 ##(Smalltalk.MoenTreeNode) nil 721926 ##(Smalltalk.MoenContour) nil nil nil nil 328198 ##(Smalltalk.Point) 1 1 1424 nil nil nil nil nil 7 459270 ##(Smalltalk.Message) #name 8 #() ##(Smalltalk.IconicListAbstract) 3 3 1049926 1 ##(Smalltalk.IconImageManager) 1410 21 21 41 nil 197382 ##(Smalltalk.Pen) nil true 393478 ##(Smalltalk.LOGPEN) 8 #[0 0 0 0 1 0 0 0 0 0 0 0 212 208 200 0] 1410 33 33 1410 19999 19999 65609 1410 1 1 1410 35 1 nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 1410 1 1 1410 771 521 1152 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 129 1 0 0 4 1 0 0] 8 #() 1410 193 193 nil 27 8 'classes' nil 1410 1 1 true 1410 33 33 1682 138 144 34 2 1746 #createAt:extent: 34 2 1410 2799 21 1410 771 521 416 1746 #contextMenu: 34 1 544 416 1826 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 248 6 0 0 14 1 0 0] 34 1 1152 1888 nil 27 )! !
!ClassHierarchySelector class categoriesFor: #defaultModel!models!public! !
!ClassHierarchySelector class categoriesFor: #resource_Default_view!public!resources-views! !
!ClassHierarchySelector class categoriesFor: #resource_Moen_view!public!resources-views! !

