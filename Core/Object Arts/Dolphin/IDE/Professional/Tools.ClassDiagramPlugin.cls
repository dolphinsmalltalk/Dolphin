"Filed out from Dolphin Smalltalk"!

Tools.ClassBrowserPlugin
	subclass: #'Tools.ClassDiagramPlugin'
	instanceVariableNames: 'classesPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ClassDiagramPlugin guid: (Core.GUID fromString: '{2a2213bc-1639-42cf-a5b9-987d7fd36e9a}')!
Tools.ClassDiagramPlugin comment: '`ClassDiagramPlugin` is a simple example of a `<classBrowserPlugin>` that renders the hierarchy below the browser''s currently selected class in a moen tree diagram. Although the time taken to perform this rendition is not significant, for illustrative purposes, we have chosen to defer the building of the class diagram until the plug-in''s card is selected in the browser.

##Instance Variables:
  classesPresenter		`ClassHierarchySelector` used to show the class hierarchy diagram
'!
!Tools.ClassDiagramPlugin categoriesForClass!Browser-Plugins!MVP-Presenters! !
!Tools.ClassDiagramPlugin methodsFor!

buildClassDiagram
	"Private - Create the diagram for the browser's currently selected class"

	Cursor wait showWhile: 
			[| classModel classes showAllClasses count |
			classes := self browser selectedClasses.
			count := classes size.
			showAllClasses := count == 0 or: [count == 1 and: [classes anyOne == Object]].
			classModel := ClassHierarchyModel withAllClasses.
			showAllClasses
				ifFalse: 
					[classModel
						filter: [:x | classes anySatisfy: [:class | (class includesBehavior: x) or: [x includesBehavior: class]]]].
			classesPresenter model: classModel.
			count == 1 ifTrue: [classesPresenter selection: classes anyOne].

			"Don't expand-all from Object since it just wastes time"
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
!Tools.ClassDiagramPlugin categoriesForMethods!
buildClassDiagram!operations!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultHelpId!constants!public! !
displayOn:!displaying!public! !
onBrowserClassSelected!event handling!private! !
onBrowserMethodSelected!event handling!private! !
onClassSelected!event handling!private! !
onShownInBrowser!event handling!public! !
!

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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 176 nil nil nil 5 2886 4 #{UI.Menu} nil true 50 17 1094 2 #{UI.CommandMenuItem} 2097153 1350 4 #{UI.CommandDescription} #findClass 8 'Find…' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'FindClass.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 242 nil true 50 10 290 1 322 #browseClassPackage 8 'Package <1d>' 1 1 370 nil true 402 8 'Package.ico' 464 65541 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 290 2097153 322 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 242 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 626 4097 290 1 322 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 290 1 322 #browseMethodHistoryForClass 8 'Method &History' 1 1 370 nil true 402 8 'MethodHistory.ico' 464 65541 nil nil nil 626 4097 290 1 322 #browsePublishedEvents 8 'Published &events' 1 1 nil nil nil 290 1 322 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 626 4097 290 1 322 #newClass 8 '&New…' 1 1 370 nil true 402 8 'NewClass.ico' 464 65541 nil nil nil 290 1 322 #removeClass 8 'Re&move' 1 1 370 nil true 402 8 'ClassDelete.ico' 464 65541 nil nil nil 242 nil true 50 18 290 2097153 322 #renameClass 8 'Re&name…' 1 1 370 nil true 402 8 'Rename.ico' 464 65541 nil nil nil 290 1 322 #copyClass 8 'Cl&one…' 1 1 nil nil nil 626 4097 290 1 322 #addInstanceVariable 8 'Add <1s>&Instance Variable…' 1 1 nil nil nil 290 1 322 #addClassVariable 8 'Add &Class Variable…' 1 1 nil nil nil 242 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 242 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 626 4097 242 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 242 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 626 4097 242 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 242 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 242 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 626 4097 290 1 322 #convertToSibling 8 'Con&vert to Sibling…' 1 1 nil nil nil 626 4097 290 1 322 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 370 nil true 402 8 'Refactoring.ico' 464 65541 nil nil nil nil nil 626 4097 290 1 322 #createInstanceVariableAccessors 8 'Create &Accessors…' 1 1 nil nil nil 290 1 322 #reformatAll 8 'Re&format All' 1 1 nil nil nil 626 4097 290 1 322 #fileInClass 8 'File &In…' 1 1 nil nil nil 290 1 322 #fileOutClass 8 'File &Out…' 1 1 nil nil nil 626 4097 290 1 322 #classPackage 8 '&Package…' 1 1 370 nil true 402 8 'Package.ico' 464 65541 nil nil nil 290 1 322 #categorizeClass 8 '&Category…' 1 1 370 nil true 402 8 'Category.ico' 464 65541 nil nil nil 626 4097 242 nil true 50 4 290 1 322 #newView 8 '&New…' 1 1 nil nil nil 626 4097 242 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 370 nil true 402 8 'ViewComposer.ico' 464 65541 nil nil nil nil nil 242 nil true 8 #() 8 '&Show' #viewsShowMenu 1 370 nil true 402 8 'TestView.ico' 464 65541 nil nil nil nil nil 8 '&Views' #viewsMenu 134217729 370 nil true 402 8 'View.ico' 464 65541 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 176 582 1 #{UI.ResourceIdentifier} #{Tools.ClassHierarchySelector} #resource_Moen_view nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1 1 3042 701 501 176 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 8 #() 3042 193 193 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 176 8 'classes' nil 2946 50 1 2994 #createAt:extent: 50 2 3042 6143 21 3042 701 501 32 3090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 93 13 0 0 4 1 0 0] 50 1 176 3152 nil 27)! !
!Tools.ClassDiagramPlugin class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

