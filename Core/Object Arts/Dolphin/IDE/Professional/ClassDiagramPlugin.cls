"Filed out from Dolphin Smalltalk 7"!

ClassBrowserPlugin subclass: #ClassDiagramPlugin
	instanceVariableNames: 'classesPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassDiagramPlugin guid: (GUID fromString: '{2A2213BC-1639-42CF-A5B9-987D7FD36E9A}')!
ClassDiagramPlugin comment: 'ClassDiagramPlugin is a simple example of a <classBrowserPlugin> that renders the hierarchy below the browser''s currently selected class in a moen tree diagram. Although the time taken to perform this rendition is not significant, for illustrative purposes, we have chosen to defer the building of the class diagram until the plug-in''s card is selected in the browser.

Instance Variables:
	classesPresenter		<ClassHierarchySelector> used to show the class hierarchy diagram

'!
!ClassDiagramPlugin categoriesForClass!Browser-Plugins!MVP-Presenters! !
!ClassDiagramPlugin methodsFor!

buildClassDiagram
	"Private - Create the diagram for the browser's currently selected class"

	Cursor wait showWhile: 
			[| classModel instClass showAllClasses |
			instClass := self browser actualClass 
						ifNotNil: [:actualClass | actualClass instanceClass].
			classModel := ClassHierarchyModel withAllClasses.
			showAllClasses := instClass isNil or: [instClass == Object].
			showAllClasses 
				ifFalse: 
					[classModel filter: 
							[:x | 
							(instClass allSuperclasses includes: x) or: [instClass withAllSubclasses includes: x]]].
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

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it. This will be used as the label for the tab when the receiver is being displayed
	as a plugin within the Class Browser"

	aStream nextPutAll: 'Class Diagram'!

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
!ClassDiagramPlugin categoriesFor: #buildClassDiagram!operations!private! !
!ClassDiagramPlugin categoriesFor: #createComponents!initializing!public! !
!ClassDiagramPlugin categoriesFor: #createSchematicWiring!initializing!public! !
!ClassDiagramPlugin categoriesFor: #defaultHelpId!constants!public! !
!ClassDiagramPlugin categoriesFor: #displayOn:!displaying!public! !
!ClassDiagramPlugin categoriesFor: #onBrowserClassSelected!event handling!private! !
!ClassDiagramPlugin categoriesFor: #onBrowserMethodSelected!event handling!private! !
!ClassDiagramPlugin categoriesFor: #onClassSelected!event handling!private! !
!ClassDiagramPlugin categoriesFor: #onShownInBrowser!event handling!public! !

!ClassDiagramPlugin class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^ClassHierarchyDiagram icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 576 0 0 0 5 265030 4 ##(Smalltalk.Menu)  0 16 98 19 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 658 0 16 98 9 706 1 738 8 #browseClassPackage 8 'Package <1d>' 1 1 802 0 16 848 8 'Package.ico' 896 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 706 2097153 738 8 #browseClassReferences 8 '&Class References' 1 1 0 0 0 658 0 16 98 0 8 'Local Re&ferences To' 8 #browseVariablesMenu 134217729 0 0 0 0 0 1058 4097 706 1 738 8 #browseChangedMethods 8 'Changed &Methods' 1 1 0 0 0 1058 4097 706 1 738 8 #browsePublishedEvents 8 'Published &events' 1 1 0 0 0 706 1 738 8 #browsePublishedAspects 8 'Published &aspects' 1 1 0 0 0 8 '&Browse' 8 #browseMenu 134217729 0 0 0 0 0 1058 4097 706 1 738 8 #newClass 8 '&New...' 1 1 802 0 16 848 8 'NewClass.ico' 896 0 0 706 1 738 8 #deleteClassHierarchy 8 '&Delete' 1 1 802 0 16 848 8 'EditClear.ico' 896 0 0 658 0 16 98 18 706 1 738 8 #safeRemoveClass 8 '&Remove' 1 1 0 0 0 706 2097153 738 8 #renameClass 8 'Re&name...' 1 1 0 0 0 1058 4097 706 1 738 8 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 0 0 0 706 1 738 8 #addClassVariable 8 'Add &Class Variable...' 1 1 0 0 0 658 0 16 98 0 8 'Re&move Variable' 8 #removeVariables 134217729 0 0 0 0 0 658 0 16 98 0 8 'Ren&ame Variable' 8 #renameVariables 134217729 0 0 0 0 0 1058 4097 658 0 16 98 0 8 'Push &Down' 8 #pushDownVariables 134217729 0 0 0 0 0 658 0 16 98 0 8 'Pull &Up' 8 #pullUpVariables 134217729 0 0 0 0 0 1058 4097 658 0 16 98 0 8 'Cr&eate Accessors' 8 #createVariableAccessors 134217729 0 0 0 0 0 658 0 16 98 0 8 'A&bstract' 8 #abstractVariables 134217729 0 0 0 0 0 658 0 16 98 0 8 '&Protect/Concrete' 8 #protectVariables 134217729 0 0 0 0 0 1058 4097 706 1 738 8 #convertToSibling 8 'Con&vert to Sibling...' 1 1 0 0 0 1058 4097 706 1 738 8 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 0 0 0 8 '&Refactorings' 8 #classRefactoringsMenu 134217729 802 0 16 848 8 'Refactoring.ico' 896 0 0 0 0 1058 4097 706 1 738 8 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 0 0 0 706 1 738 8 #reformatAll 8 'Refor&mat All' 1 1 0 0 0 1058 4097 706 1 738 8 #fileInClass 8 'File &In...' 1 1 0 0 0 706 1 738 8 #fileOutClass 8 'File &Out...' 1 1 0 0 0 1058 4097 706 1 738 8 #classPackage 8 '&Package...' 1 1 802 0 16 848 8 'Package.ico' 896 0 0 706 1 738 8 #categorizeClass 8 '&Category...' 1 1 0 0 0 1058 4097 658 0 16 98 7 706 1 738 1264 8 'Browse &Changes in Image' 1 1 0 0 0 706 1 738 8 #browseMethodHistoryForClass 8 'Browse Change &History in Image' 1 1 0 0 0 1058 4097 706 1 738 8 #browseClassEditions 8 'Browse Class &Editions' 1 1 0 0 0 706 1 738 8 #browseAvailableMethods 8 'Browse Deleted Method Editions' 1 1 0 0 0 1058 4097 706 1 738 8 #compareClass 8 'Compare Class Edition...' 1 1 0 0 0 8 'C&hanges' 0 134217729 0 0 0 0 0 1058 4097 658 0 16 98 4 706 1 738 8 #newView 8 '&New...' 1 1 0 0 0 1058 4097 658 0 16 98 0 8 '&Edit' 8 #viewsEditMenu 1 0 0 0 0 0 658 0 16 98 0 8 '&Show' 8 #viewsShowMenu 1 0 0 0 0 0 8 '&Views' 8 #viewsMenu 1 802 0 16 848 8 'View.ico' 896 0 0 0 0 8 '&Class' 0 134217729 0 0 0 0 0 0 0 576 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.ClassHierarchySelector)  8 #resource_Moen_view 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 4082 701 501 576 4018 8 #contextMenu: 98 1 672 576 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 98 0 4082 193 193 0 27 234 256 98 2 576 8 'classes' 0 3954 202 208 98 1 4018 4048 98 2 4082 3839 21 4082 701 501 416 4178 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 98 1 576 4240 0 27 )! !
!ClassDiagramPlugin class categoriesFor: #icon!constants!public! !
!ClassDiagramPlugin class categoriesFor: #resource_Default_view!public!resources-views! !

