"Filed out from Dolphin Smalltalk 7"!

ClassSelector subclass: #ClassHierarchySelector
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ClassHierarchySelector guid: (Core.GUID fromString: '{e11cf5f9-c2ec-47e1-ba1f-fa2fc4c88ad7}')!
ClassHierarchySelector comment: 'A ClassHierarchySelector is used to display a tree of classes. It implements the behaviour common to the class hierarchy panes in the <ClassBrowserShell> and <ClassHierarchyDiagram>.'!
!ClassHierarchySelector categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !
!ClassHierarchySelector methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	classesPresenter := self add: TreePresenter new name: 'classes'!

customDrawClassTree: anNMTVCUSTOMDRAW
	"Private - Custom drawing to implement the emphasis in the class hierarchy tree."

	self systemModel setCustomDrawAttributes: anNMTVCUSTOMDRAW forClass: anNMTVCUSTOMDRAW item!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 917510 ##(Graphics.Color) #default nil 5 461638 4 ##(UI.Menu) nil true 34 17 1180742 2 ##(UI.CommandMenuItem) 2097153 1377606 4 ##(UI.CommandDescription) #findClass 8 'Find...' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'FindClass.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 514 nil true 34 10 562 1 594 #browseClassPackage 8 'Package <1d>' 1 1 642 nil true 688 8 'Package.ico' 736 nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 562 2097153 594 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 514 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 882 4097 562 1 594 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 562 1 594 #browseMethodHistoryForClass 8 'Method &History' 1 1 642 nil true 688 8 'MethodHistory.ico' 736 nil nil 882 4097 562 1 594 #browsePublishedEvents 8 'Published &events' 1 1 642 nil true 688 8 'Event.ico' 736 nil nil 562 1 594 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 882 4097 562 1 594 #newClass 8 '&New...' 1 1 642 nil true 688 8 'NewClass.ico' 736 nil nil 562 1 594 #deleteClassHierarchy 8 '&Delete' 1 1 642 nil true 688 8 'EditClear.ico' 736 nil nil 514 nil true 34 19 562 1 594 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 562 2097153 594 #renameClass 8 'Re&name...' 1 1 642 nil true 688 8 'Rename.ico' 736 nil nil 562 1 594 #copyClass 8 'Cl&one...' 1 1 nil nil nil 882 4097 562 1 594 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 562 1 594 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 514 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 514 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 882 4097 514 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 514 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 882 4097 514 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 514 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 514 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 882 4097 562 1 594 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 882 4097 562 1 594 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 642 nil true 688 8 'Refactoring.ico' 736 nil nil nil nil 882 4097 562 1 594 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 562 1 594 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 882 4097 562 1 594 #fileInClass 8 'File &In...' 1 1 642 nil true 688 8 'FileIn.ico' 736 nil nil 562 1 594 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 882 4097 562 1 594 #classPackage 8 '&Package...' 1 1 642 nil true 688 8 'Package.ico' 736 nil nil 562 1 594 #categorizeClass 8 '&Category...' 1 1 642 nil true 688 8 'Category.ico' 736 nil nil 882 4097 514 nil true 34 4 562 1 594 #newView 8 '&New...' 1 1 nil nil nil 882 4097 514 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 642 nil true 688 8 'ViewComposer.ico' 736 nil nil nil nil 514 nil true 8 #() 8 '&Show' #viewsShowMenu 1 642 nil true 688 8 'TestView.ico' 736 nil nil nil nil 8 '&Views' #viewsMenu 134217729 642 nil true 688 8 'View.ico' 736 nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 nil nil nil nil 410 ##(UI.TreeView) 34 27 nil 416 34 2 8 1140918827 1 3152 787526 3 ##(UI.TreeModel) nil 1769478 ##(Kernel.IdentitySearchPolicy) 721670 ##(UI.TreeNode) nil nil nil 170 192 8 #() 496 nil 29 nil nil nil 3152 nil 8 1881010192 786950 ##(Core.Message) #name 3328 ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil 3362 #fullName 8 #() 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 5 1 3456 8 'doIt' 8 '[:ctx | ctx view parentView presenter  customDrawClassTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #parentView #presenter #customDrawClassTree: 3472 7 257 nil nil nil 170 176 3328 nil #smallIcons 1 170 192 3328 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 1 1 3714 701 501 3152 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 8 #() 3714 193 193 nil 27 170 192 34 2 3152 8 'classes' nil 3602 138 144 34 2 3666 #createAt:extent: 34 2 3714 6143 21 3714 701 501 416 3666 #contextMenu: 34 1 528 416 3762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 93 13 0 0 4 1 0 0] 34 1 3152 3824 nil 27 )!

resource_Moen_view
	"Answer the literal data from which the 'Moen view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Moen_view)
	"

	^#(#'!!STL' 4 788558 10 ##(STBViewProxy) ##(ScrollingDecorator) 34 18 nil nil 34 2 8 1412431872 131073 416 nil 327686 ##(Color) #default nil 5 265030 4 ##(Menu) nil true 34 2 984134 2 ##(CommandMenuItem) 1 1180998 4 ##(CommandDescription) #findClass 8 'Find...' 1 1 263494 3 ##(Icon) nil true 1572870 ##(ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 514 nil true 34 4 562 1 594 #browseClassPackage 8 'Package <1d>' 1 1 642 nil true 688 8 'Package.ico' 736 nil nil 983366 1 ##(DividerMenuItem) 4097 562 1 594 #browseClass 8 '&Class' 1 1 642 nil true 688 8 'ClassBrowserShell.ico' 736 nil nil 562 2097153 594 #browseClassReferences 8 'Class &References' 1 1 nil nil nil 8 '&Browse' #browse 134217729 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 416 1573190 1 ##(ScrollingDecoratorLayout) true 170 192 34 2 410 ##(MoenTreeView) 34 30 nil 416 34 2 8 1140916224 1 1136 590918 3 ##(TreeModel) nil 1310726 ##(IdentitySearchPolicy) 525062 ##(TreeNode) nil nil nil 170 192 8 #() 496 nil 541 nil nil nil 1136 788998 ##(MoenTreeNode) nil 721926 ##(MoenContour) nil nil nil nil 328198 ##(Point) 1 1 1408 nil nil nil nil nil 7 459270 ##(Message) #unqualifiedName 1312 ##(IconicListAbstract) 3 3 1049926 1 ##(IconImageManager) 1394 21 21 41 nil 197382 ##(Pen) nil true 393478 ##(LOGPEN) 8 #[0 0 0 0 1 0 0 0 0 0 0 0 212 208 200 0] 1394 33 33 1394 19999 19999 65609 1394 1 1 1394 35 1 nil nil nil 983302 ##(MessageSequence) 138 144 34 1 721670 ##(MessageSend) #createAt:extent: 34 2 1394 1 1 1394 771 521 1136 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 129 1 0 0 4 1 0 0] 8 #() 1394 193 193 nil 27 8 'classes' nil 1394 1 1 true 1394 33 33 1650 138 144 34 2 1714 #createAt:extent: 34 2 1394 6143 21 1394 771 521 416 1714 #contextMenu: 34 1 528 416 1794 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 128 13 0 0 14 1 0 0] 34 1 1136 1856 nil 27)! !
!ClassHierarchySelector class categoriesFor: #defaultModel!models!public! !
!ClassHierarchySelector class categoriesFor: #resource_Default_view!public!resources-views! !
!ClassHierarchySelector class categoriesFor: #resource_Moen_view!public!resources-views! !

