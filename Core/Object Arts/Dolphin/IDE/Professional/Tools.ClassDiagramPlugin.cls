"Filed out from Dolphin Smalltalk 7"!

Tools.ClassBrowserPlugin subclass: #'Tools.ClassDiagramPlugin'
	instanceVariableNames: 'classesPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ClassDiagramPlugin guid: (Core.GUID fromString: '{2a2213bc-1639-42cf-a5b9-987d7fd36e9a}')!
Tools.ClassDiagramPlugin comment: 'ClassDiagramPlugin is a simple example of a <classBrowserPlugin> that renders the hierarchy below the browser''s currently selected class in a moen tree diagram. Although the time taken to perform this rendition is not significant, for illustrative purposes, we have chosen to defer the building of the class diagram until the plug-in''s card is selected in the browser.

Instance Variables:
	classesPresenter		<ClassHierarchySelector> used to show the class hierarchy diagram

'!
!Tools.ClassDiagramPlugin categoriesForClass!Browser-Plugins!MVP-Presenters! !
!Tools.ClassDiagramPlugin methodsFor!

buildClassDiagram
	"Private - Create the diagram for the browser's currently selected class"

	Cursor wait showWhile: 
			[| classModel instClass showAllClasses |
			instClass := self browser actualClass ifNotNil: [:actualClass | actualClass instanceClass].
			classModel := ClassHierarchyModel withAllClasses.
			showAllClasses := instClass isNil or: [instClass == Object].
			showAllClasses
				ifFalse: 
					[classModel
						filter: [:x | (instClass allSuperclasses includes: x) or: [instClass withAllSubclasses includes: x]]].
			classesPresenter model: classModel.
			classesPresenter selectionOrNil: instClass.

			"Don't expand Object since it just wastes times"
			showAllClasses ifFalse: [classesPresenter expandAll: nil]]!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	classesPresenter := self add: ClassHierarchySelector new name: 'classes'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	classesPresenter when: #selectionChanged send: #onClassSelected to: self.
	self model 
		when: #classSelected send: #onBrowserClassSelected to: self;
		when: #methodSelected send: #onBrowserMethodSelected to: self.

!

defaultHelpId
	^10748!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see.
	This will be used as the label for the tab when the receiver is being displayed as a plugin within the Class Browser."

	aPuttableStream nextPutAll: 'Class Diagram'!

onBrowserClassSelected
	"Event handler for a class being selected within the receiver's associated browser. "

	"For efficiency we only build the diagram if we are the current card"

	self isCurrentCard ifTrue: [self buildClassDiagram]!

onBrowserMethodSelected
	"Event handler for a method being selected within the receiver's associated browser. "

	(self isCurrentCard and: [self browser hasMethodSelected]) 
		ifTrue: [self browser ensureSourceVisible]!

onClassSelected
	"Event handler for a class being selected within the receiver's diagram. 
	Pass the class selection on to the browser"

	| classRequired |
	classRequired := classesPresenter selectionOrNil.
	classRequired notNil 
		ifTrue: [self browser isInstanceMode ifFalse: [classRequired := classRequired class]].
	self browser actualClass: classRequired!

onShownInBrowser
	"Event handler indicating that the receiver has been displayed within it's browser. "

	super onShownInBrowser.
	"For efficiency we defer the creation of the diagram until the receiver becomes the current card"
	self buildClassDiagram! !
!Tools.ClassDiagramPlugin categoriesFor: #buildClassDiagram!operations!private! !
!Tools.ClassDiagramPlugin categoriesFor: #createComponents!initializing!public! !
!Tools.ClassDiagramPlugin categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.ClassDiagramPlugin categoriesFor: #defaultHelpId!constants!public! !
!Tools.ClassDiagramPlugin categoriesFor: #displayOn:!displaying!public! !
!Tools.ClassDiagramPlugin categoriesFor: #onBrowserClassSelected!event handling!private! !
!Tools.ClassDiagramPlugin categoriesFor: #onBrowserMethodSelected!event handling!private! !
!Tools.ClassDiagramPlugin categoriesFor: #onClassSelected!event handling!private! !
!Tools.ClassDiagramPlugin categoriesFor: #onShownInBrowser!event handling!public! !

!Tools.ClassDiagramPlugin class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^ClassHierarchyDiagram icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 917510 ##(Graphics.Color) #default nil 5 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 nil nil nil nil 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 544 nil nil nil 5 461638 4 ##(UI.Menu) nil true 34 17 1180742 2 ##(UI.CommandMenuItem) 2097153 1377606 4 ##(UI.CommandDescription) #findClass 8 'Find...' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'FindClass.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 610 nil true 34 10 658 1 690 #browseClassPackage 8 'Package <1d>' 1 1 738 nil true 784 8 'Package.ico' 832 nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 658 2097153 690 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 610 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 978 4097 658 1 690 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 658 1 690 #browseMethodHistoryForClass 8 'Method &History' 1 1 738 nil true 784 8 'MethodHistory.ico' 832 nil nil 978 4097 658 1 690 #browsePublishedEvents 8 'Published &events' 1 1 nil nil nil 658 1 690 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 978 4097 658 1 690 #newClass 8 '&New...' 1 1 738 nil true 784 8 'NewClass.ico' 832 nil nil 658 1 690 #deleteClassHierarchy 8 '&Delete' 1 1 738 nil true 784 8 'EditClear.ico' 832 nil nil 610 nil true 34 19 658 1 690 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 658 2097153 690 #renameClass 8 'Re&name...' 1 1 738 nil true 784 8 'Rename.ico' 832 nil nil 658 1 690 #copyClass 8 'Cl&one...' 1 1 nil nil nil 978 4097 658 1 690 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 658 1 690 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 610 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 610 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 978 4097 610 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 610 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 978 4097 610 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 610 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 610 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 978 4097 658 1 690 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 978 4097 658 1 690 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 738 nil true 784 8 'Refactoring.ico' 832 nil nil nil nil 978 4097 658 1 690 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 658 1 690 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 978 4097 658 1 690 #fileInClass 8 'File &In...' 1 1 nil nil nil 658 1 690 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 978 4097 658 1 690 #classPackage 8 '&Package...' 1 1 738 nil true 784 8 'Package.ico' 832 nil nil 658 1 690 #categorizeClass 8 '&Category...' 1 1 738 nil true 784 8 'Category.ico' 832 nil nil 978 4097 610 nil true 34 4 658 1 690 #newView 8 '&New...' 1 1 nil nil nil 978 4097 610 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 738 nil true 784 8 'ViewComposer.ico' 832 nil nil nil nil 610 nil true 8 #() 8 '&Show' #viewsShowMenu 1 738 nil true 784 8 'TestView.ico' 832 nil nil nil nil 8 '&Views' #viewsMenu 134217729 738 nil true 784 8 'View.ico' 832 nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 544 1376838 1 ##(UI.ResourceIdentifier) ##(Tools.ClassHierarchySelector) #resource_Moen_view nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 1 1 3298 701 501 544 3250 #contextMenu: 34 1 624 544 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 8 #() 3298 193 193 nil 27 170 192 34 2 544 8 'classes' nil 3186 138 144 34 1 3250 #createAt:extent: 34 2 3298 6143 21 3298 701 501 416 3378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 93 13 0 0 4 1 0 0] 34 1 544 3440 nil 27 )! !
!Tools.ClassDiagramPlugin class categoriesFor: #icon!constants!public! !
!Tools.ClassDiagramPlugin class categoriesFor: #resource_Default_view!public!resources-views! !

