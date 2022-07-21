"Filed out from Dolphin Smalltalk"!

Tools.ClassSelector subclass: #'Tools.ClassListSelector'
	instanceVariableNames: 'flags classesListPresenter browserEnvironment namespacesPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ClassListSelector guid: (Core.GUID fromString: '{337ede86-614b-4281-b0fe-16ffb1e67d72}')!
Tools.ClassListSelector comment: 'A ClassListSelector is used to display a list of classes. It implements the class list pane in the <PackagedClassSelector>, as used in the System Browser.

Instance Variables:
	classesListPresenter	<ListPresenter> displaying the list.
	environment			<RBEnvironment> defining the set of classes in the list.

'!
!Tools.ClassListSelector categoriesForClass!MVP-Resources-IDE Tools! !
!Tools.ClassListSelector methodsFor!

browseItCommand
	"Private - Answer the command that the context-sensitive 'Browse-It' command would be linked
	to if sent to the receiver at this moment."

	classesListPresenter hasFocus ifTrue: [^#browseClass].
	^super browseItCommand!

browserEnvironment
	"Answer the <BrowserEnvironment> from which the receiver is displaying a list of classes."

	^browserEnvironment!

browserEnvironment: aBrowserEnvironment
	"Set the <BrowserEnvironment> that defines the list of classes displayed in the receiver."

	browserEnvironment := aBrowserEnvironment.
	self updateClasses!

classesListPresenter
	^classesListPresenter!

classNamesSelector: aSymbol
	super classNamesSelector: aSymbol.
	namespacesPresenter view getTextBlock: classesPresenter view getTextBlock!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	classesListPresenter := self add: ListPresenter new beSorted name: 'classesList'.
	classesPresenter := self add: TreeListPresenter new name: 'classes'.
	namespacesPresenter := self add: (TreeListPresenter on: classesPresenter model) name: 'namespaces'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self view
		when: #currentCardChangedFrom:to:
		send: #onCardChangedFrom:to:
		to: self.
	classesListPresenter
		when: #actionPerformed
			send: #browseClass
			to: self;
		when: #selectionChanged
			send: #onListSelectionChanged
			to: self;
		when: #aboutToEditLabel:
			send: #onAboutToRenameClass:
			to: self;
		when: #labelOf:editedTo:accept:
			send: #onClass:renameTo:accept:
			to: self;
		when: #drag:
			send: #onDrag:
			to: self;
		when: #drop:
			send: #onDropOver:
			to: self;
		when: #dragEnter:
			send: #onDragOverList:
			to: self;
		when: #dragOver:
			send: #onDragOverList:
			to: self.
	namespacesPresenter
		when: #selectionChanged
		send: #onNamespacesSelectionChanged
		to: self.

	"It might seem odd to monitor the repackaging event, but we might be displaying classes from a PackageEnvironment."
	#todo.	"Trigger add/remove/update events from RBEnvironments, then we can get rid of this bodge"
	Package manager
		when: #classRepackaged:from:to:
		send: #onClassRepackaged:from:to:
		to: self!

customDrawClassList: anNMLVCUSTOMDRAW
	"Private - Custom drawing to implement the emphasis in the class list. See #customDrawClassTree: for details, although note that the list cannot contain 'included but not defined' classes."

	| class |
	class := anNMLVCUSTOMDRAW item.
	(browserEnvironment definesClass: class)
		ifFalse: [anNMLVCUSTOMDRAW forecolor: ClassBrowserAbstract.LooseMethodColor].
	self systemModel setCustomDrawAttributes: anNMLVCUSTOMDRAW forClass: class!

customDrawClassTree: anNMTVCUSTOMDRAW
	"Private - Custom drawing to implement the emphasis in a class or namespace hierarchy tree. 
	  - 'Defined classes' (the meaning of which is dependent on the RBEnvironment whose content the receiver is displaying) are drawn in the normal colour and font. 
	  - 'Included but not defined' classes are highlighted in the loose method colour (dark magenta by default, but configurable in User Preferences). 
	  - Class that are neither defined nor included may be present only to form the structure of the hierarchy (i.e. ancestor classes of any of the first two categories of classes), so are greyed-out by fading the normal colour.
	  - Abstract classes are highlighted with italics
	  - Deprecated classes are struck out"

	| class |
	class := anNMTVCUSTOMDRAW item.
	(browserEnvironment includesClass: class)
		ifTrue: 
			[(browserEnvironment definesClass: class)
				ifFalse: [anNMTVCUSTOMDRAW forecolor: ClassBrowserAbstract.LooseMethodColor]]
		ifFalse: 
			[anNMTVCUSTOMDRAW
				forecolor: (anNMTVCUSTOMDRAW forecolor fadedBy: ClassBrowserAbstract.GrayedMethodFadeFactor)].
	self systemModel setCustomDrawAttributes: anNMTVCUSTOMDRAW forClass: class!

deleteItCommand
	"Private - Answer the command that the context-sensitive 'Browse-It' command would be linked
	to if sent to the receiver at this moment."

	classesListPresenter hasFocus ifTrue: [^#removeClass].
	^super deleteItCommand!

flags
	^flags!

flags: anInteger
	flags := anInteger!

initialize
	"Private - Initialize the receiver"

	super initialize.
	browserEnvironment := BrowserEnvironment new forClasses: #()!

model: aListModel
	"Connects the receiver to a new model."

	| devsys |
	devsys := SmalltalkSystem current.
	classesPresenter treeModel: devsys classHierarchy.
	namespacesPresenter treeModel: devsys namespaceHierarchy.
	classesListPresenter model: aListModel.
	super model: aListModel.
	namespacesPresenter model: aListModel!

onCardChangedFrom: previousView to: currentView
	"The user has changed the current class selection view in the receiver."

	| selections |
	selections := previousView selections.
	currentView selections: selections ifAbsent: [currentView resetSelection]
	!

onClassRepackaged: aClass from: anUndefinedObject to: aPackage
	(browserEnvironment includesClass: aClass)
		ifTrue: 
			["Was it previously included? If not then add it."
			(classesPresenter model includes: aClass) ifFalse: [classesPresenter model add: aClass]]
		ifFalse: 
			["Remove if it was previously included"
			classesPresenter model remove: aClass ifAbsent: nil]!

onDragOverList: aDragDropSession
	"Private - The user is dragging over the class hierarchy pane.
	Set the operation of the <DragDropSession>, session,
	that would occur if a drop took place now of the objects in that session."

	"We do not accept class drops over the class list, because the results are rather confusing"

	(aDragDropSession isFormatAvailable: #Class)
		ifTrue: [aDragDropSession operation: nil]
		ifFalse: [self onDragOver: aDragDropSession]!

onListSelectionChanged
	"Private - Sent when the receiver's class list selection has changed. If the list is the current card, then transmit a selection change to observers."

	self selectableItems == classesListPresenter ifTrue: [self trigger: #selectionChanged]!

onNamespacesSelectionChanged
	"Private - Sent when the receiver's classes-by-namespace selection has changed."

	self selectableItems == namespacesPresenter ifTrue: [self trigger: #selectionChanged]!

onSelectionChanged
	"Private - Sent when the receiver's class hierarchy selection has changed."

	self selectableItems == classesPresenter ifTrue: [self trigger: #selectionChanged]!

onViewClosed
	super onViewClosed.
	self systemModel removeEventsTriggeredFor: self.
	Package manager removeEventsTriggeredFor: self!

renameClass
	"Private - Initiate in-place label edit for the selected class."

	classesListPresenter view isWindowVisible 
		ifTrue: [classesListPresenter view editSelectionLabel]
		ifFalse: [super renameClass]!

selectableItems
	"Private - Answer the name of the <selectableItems> component that actually handles the selectable items in the receiver"
	
	^self view currentCard presenter!

updateClasses
	"Private - Update the classes list for this package. Try and maintain the existing selection if possible."

	| originalSelection |
	originalSelection := self selections.
	self noEventsDo: 
			[classesPresenter list: browserEnvironment allClasses asSortedCollection.
			self selections: originalSelection ifAbsent: []].
	self selections = originalSelection ifFalse: [self onSelectionChanged]! !
!Tools.ClassListSelector categoriesForMethods!
browseItCommand!helpers!private! !
browserEnvironment!public! !
browserEnvironment:!accessing!public! !
classesListPresenter!accessing!private! !
classNamesSelector:!accessing!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
customDrawClassList:!helpers!private! !
customDrawClassTree:!helpers!private! !
deleteItCommand!helpers!private! !
flags!accessing!private! !
flags:!accessing!private! !
initialize!initializing!private! !
model:!accessing!public! !
onCardChangedFrom:to:!public! !
onClassRepackaged:from:to:!event handling!private! !
onDragOverList:!event handling!private! !
onListSelectionChanged!event handling!private!selection! !
onNamespacesSelectionChanged!event handling!private! !
onSelectionChanged!event handling!private!selection! !
onViewClosed!event handling!private! !
renameClass!commands!private!refactoring! !
selectableItems!accessing!private! !
updateClasses!private!updating! !
!

!Tools.ClassListSelector class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ListModel new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.CardContainer} 34 16 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 461638 4 #{UI.Menu} nil true 34 15 1180742 2 #{UI.CommandMenuItem} 2097153 1377606 4 #{UI.CommandDescription} #findClass 8 'Find…' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'FindClass.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 482 nil true 34 10 530 1 562 #browseClassPackage 8 'Package <1d>' 1 1 610 nil true 642 8 'PackageBrowserShell.ico' 704 65541 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 530 2097153 562 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 482 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 866 4097 530 1 562 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 530 1 562 #browseMethodHistoryForClass 8 'Method &History' 1 1 610 nil true 642 8 'MethodHistory.ico' 704 65541 nil nil nil 866 4097 530 1 562 #browsePublishedEvents 8 'Published &events' 1 1 610 nil true 642 8 'Event.ico' 704 65541 nil nil nil 530 1 562 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 866 4097 530 1 562 #newClass 8 '&New…' 1 1 610 nil true 642 8 'NewClass.ico' 704 65541 nil nil nil 530 1 562 #removeClass 8 'Re&move' 1 1 610 nil true 642 8 'ClassDelete.ico' 704 65541 nil nil nil 482 nil true 34 22 530 2097153 562 #renameClass 8 'Re&name…' 1 1 610 nil true 642 8 'Rename.ico' 704 65541 nil nil nil 530 1 562 #changeClassNamespace 8 'C&hange Namespace…' 1 1 610 nil true 642 8 'Namespace.ico' 704 65541 nil nil nil 866 4097 530 1 562 #addInstanceVariable 8 'Add <1s>&Instance Variable…' 1 1 nil nil nil 530 1 562 #addClassVariable 8 'Add &Class Variable…' 1 1 nil nil nil 482 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 482 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 866 4097 482 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 482 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 866 4097 482 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 482 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 482 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 866 4097 530 1 562 #addImport 8 'Add Impor&t…' 1 1 nil nil nil 530 1 562 #removeImport 8 '&Remove Import…' 1 1 nil nil nil 866 4097 530 1 562 #copyClass 8 'Cl&one…' 1 1 nil nil nil 530 1 562 #convertToSibling 8 'Con&vert to Sibling…' 1 1 nil nil nil 866 4097 530 1 562 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 610 nil true 642 8 'Refactoring.ico' 704 65541 nil nil nil nil nil 530 1 562 #reformatAll 8 'Re&format All' 1 1 nil nil nil 866 4097 530 1 562 #fileInClass 8 'File &In…' 1 1 610 nil true 642 8 'FileIn.ico' 704 65541 nil nil nil 530 1 562 #fileOutClass 8 'File &Out…' 1 1 nil nil nil 866 4097 530 1 562 #classPackage 8 '&Package…' 1 1 610 nil true 642 8 'Package.ico' 704 65541 nil nil nil 530 1 562 #categorizeClass 8 '&Category…' 1 1 610 nil true 642 8 'Category.ico' 704 65541 nil nil nil 866 4097 482 nil true 34 4 530 1 562 #newView 8 '&New…' 1 1 nil nil nil 866 4097 482 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 610 nil true 642 8 'ViewComposer.ico' 704 65541 nil nil nil nil nil 482 nil true 8 #() 8 '&Show' #viewsShowMenu 1 610 nil true 642 8 'TestView.ico' 704 65541 nil nil nil nil nil 8 '&Views' #viewsMenu 134217729 610 nil true 642 8 'View.ico' 704 65541 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 416 853318 1 #{UI.CardLayout} 138 144 34 3 1049094 #{Core.Association} 8 'Class List' 410 #{UI.ListView} 34 45 nil 416 34 2 8 1140920905 1 3504 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 29 nil nil nil 3504 nil 8 1809872048 786950 #{Core.Message} #displayString 8 #() 3714 #iconImageIndex 3744 1639750 1 #{Graphics.IconImageManager} nil 3714 #fullName 8 #() nil nil nil nil 138 144 34 2 1117254 5 #{UI.ListViewColumn} 8 'Class' 477 #left 3714 #unqualifiedName 8 #() 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x :y | x name <= y name]' 8 #[30 105 17 158 18 158 130 106] #name 3968 7 513 nil nil nil 3504 nil 3 nil 3954 0 nil 3986 4 1 3952 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawClassList: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawClassList: 4064 7 257 nil 3874 8 'Namespace' 201 #left 3714 #displayString 8 #() 3954 0 nil 3986 4 1 3952 8 'doIt' 8 '[:a :b | a isNil or: [b notNil and: [a fullName <= b fullName]]]' 8 #[32 105 17 223 2 58 106 18 222 6 226 2 226 34 130 106 59 106] #or: #and: #fullName 4208 7 513 nil 3714 #environment 3936 nil 3504 nil 1 nil nil #report 8 #() nil 133217 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 9 53 4418 685 441 3504 4370 #text: 34 1 8 'Class' 3504 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 90 1 0 0 246 0 0 0] 8 #() 4418 193 193 nil 35 3458 8 'Class Hierarchy' 410 #{UI.TreeView} 34 27 nil 416 34 2 8 1140918827 1 4624 787526 3 #{UI.TreeModel} nil 3648 721670 #{UI.TreeNode} nil nil nil 170 192 3616 3680 nil 29 nil nil nil 4624 nil 8 1809649616 3714 #unqualifiedName 8 #() 3714 #iconImageIndex 4800 3792 nil 3714 #fullName 8 #() 3954 0 nil 3986 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx view parentView presenter  customDrawClassTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #parentView #presenter #customDrawClassTree: 4864 7 257 nil nil nil 170 176 3616 nil #smallIcons 1 170 192 3616 4322 34 1 4370 #createAt:extent: 34 2 4418 9 53 4418 685 441 4624 4514 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 90 1 0 0 246 0 0 0] 8 #() 4576 nil 27 3458 8 'Class Namespaces' 410 #{UI.TreeView} 34 27 nil 416 34 2 8 1409352235 1 5152 4690 nil 3648 4722 nil nil nil 170 192 3616 3680 nil 29 nil nil nil 5152 nil 8 1809649616 3714 #unqualifiedName 8 #() 3714 #iconImageIndex 8 #() 3792 nil 3714 #fullName 8 #() 4864 nil nil 170 176 3616 nil #smallIcons 1 170 192 3616 4322 34 1 4370 #createAt:extent: 34 2 4418 9 53 4418 685 441 5152 4514 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 90 1 0 0 246 0 0 0] 8 #() 4576 nil 27 3504 nil nil nil 170 192 34 6 5152 8 'namespaces' 3504 8 'classesList' 4624 8 'classes' nil 410 #{UI.TabViewXP} 34 28 nil 416 34 2 8 1140916736 1 5632 3570 138 144 34 3 3488 4608 5136 nil 3648 nil nil 1 nil nil nil 5632 nil 8 1809685360 3714 #displayString 4800 3714 #iconImageIndex 4800 3792 nil nil nil nil nil #noIcons nil nil nil nil nil 4322 34 3 4370 #createAt:extent: 34 2 4418 1 1 4418 701 501 5632 4370 #setSingleSelection: 8 #(1) 5632 4370 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 5632 4514 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 8 #() 4576 nil 27 4322 34 2 4370 #createAt:extent: 34 2 4418 12287 21 4418 701 501 416 4370 #contextMenu: 34 1 496 416 4514 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 93 25 0 0 4 1 0 0] 34 4 3504 4624 5152 5632 4576 nil 27)! !
!Tools.ClassListSelector class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

