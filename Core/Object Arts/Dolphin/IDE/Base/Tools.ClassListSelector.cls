"Filed out from Dolphin Smalltalk 7"!

Tools.ClassSelector subclass: #'Tools.ClassListSelector'
	instanceVariableNames: 'classesListPresenter environment'
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

	^environment!

browserEnvironment: aBrowserEnvironment 
	"Set the <BrowserEnvironment> that defines the list of classes displayed in the receiver."

	environment := aBrowserEnvironment.
	self updateClasses!

classesListPresenter
	^classesListPresenter!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	classesListPresenter := self add: ListPresenter new beSorted name: 'classesList'.
	classesPresenter := self add: TreeListPresenter new name: 'classes'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
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
	"We need to monitor for class updates, as the TreeListPresenter may not update correctly for
	these if a class is moved under a subclass that is not in its current filter. In that case
	the class will disappear from the tree but remain in the list. We need to refresh the filter
	to include the class' new ancestor chain and add that ancestor chain to the tree as new
	infrastructural nodes so that the reparented class can be displayed in the tree again."
	"(self systemModel)
		when: #classUpdated:
			send: #onClassUpdated:
			to: self."

	"It might seem odd to monitor the repackaging event, but we might be displaying classes from a PackageEnvironment."
	#todo.	"Trigger add/remove/update events from RBEnvironments, then we can get rid of this bodge"
	Package manager
		when: #classRepackaged:from:to:
		send: #onClassRepackaged:from:to:
		to: self!

customDrawClassList: anNMLVCUSTOMDRAW
	"Private - Custom drawing to implement the emphasis in the class list tree. Owned classes
	are displayed in the normal colour and font. The classes of loose methods are highlighted in
	the loose method colour (dark magenta by default, but configurable in User Preferences)."

	| class |
	class := anNMLVCUSTOMDRAW item.
	(environment definesClass: class)
		ifFalse: [anNMLVCUSTOMDRAW forecolor: ClassBrowserAbstract looseMethodColor].
	self systemModel setCustomDrawAttributes: anNMLVCUSTOMDRAW forClass: class!

customDrawClassTree: anNMTVCUSTOMDRAW
	"Private - Custom drawing to implement the emphasis in the class hierarchy tree. 'Defined
	classes' (the meaning of which is dependent on the RBEnvironment whose content the receiver
	is displaying) are drawn in the normal colour and font. 'Included but not defined' classes
	are highlighted in the loose method colour (dark magenta by default, but configurable in
	User Preferences). Any classes present only to form the structure of the hierarchy (i.e.
	ancestor classes of any of the first two categories of classes) are greyed by fading the
	normal colour."

	| class |
	class := anNMTVCUSTOMDRAW item.
	(environment includesClass: class)
		ifTrue: 
			[(environment definesClass: class)
				ifFalse: [anNMTVCUSTOMDRAW forecolor: ClassBrowserAbstract looseMethodColor]]
		ifFalse: 
			[anNMTVCUSTOMDRAW
				forecolor: (anNMTVCUSTOMDRAW forecolor fadedBy: ClassBrowserAbstract grayedMethodFadeFactor)].
	self systemModel setCustomDrawAttributes: anNMTVCUSTOMDRAW forClass: class!

deleteItCommand
	"Private - Answer the command that the context-sensitive 'Browse-It' command would be linked
	to if sent to the receiver at this moment."

	"packagesPresenter packagesPresenter hasFocus ifTrue: [^#uninstallPackage]."
	classesListPresenter hasFocus ifTrue: [^#deleteClassHierarchy].
	^super deleteItCommand!

initialize
	"Private - Initialize the receiver"

	super initialize.
	environment := Refactory.Browser.BrowserEnvironment new forClasses: #()!

model: aListModel
	"Connects the receiver to a new model."

	classesPresenter treeModel: Smalltalk developmentSystem classHierarchy.
	super model: aListModel.
	classesListPresenter model: aListModel!

onClassRepackaged: aClass from: anUndefinedObject to: aPackage 
	(environment includesClass: aClass) 
		ifTrue: 
			["Was it previously included? If not then add it."
			(self selectableItems model includes: aClass) 
				ifFalse: 
					[self selectableItems model add: aClass]]
		ifFalse: 
			["Remove if it was previously included"
			self selectableItems model remove: aClass ifAbsent: []]!

onDragOverList: aDragDropSession
	"Private - The user is dragging over the class hierarchy pane.
	Set the operation of the <DragDropSession>, session,
	that would occur if a drop took place now of the objects in that session."

	"We do not accept class drops over the class list, because the results are rather confusing"

	(aDragDropSession isFormatAvailable: #Class)
		ifTrue: [aDragDropSession operation: nil]
		ifFalse: [self onDragOver: aDragDropSession]!

onListSelectionChanged
	"Private - Sent when the receiver's class list selection has changed."

	"Synchronize the selection change between class list and hierarchy views"

	self selectableItems selectionOrNil: classesListPresenter selectionOrNil!

onSelectionChanged
	"Private - Sent when the receiver's class list selection has changed."

	"Synchronize the selection change between class list and hierarchy views"

	classesListPresenter selection: self selectableItems selectionOrNil
		ifAbsent: [classesListPresenter noEventsDo: [classesListPresenter resetSelection]].
	super onSelectionChanged!

onViewClosed
	super onViewClosed.
	self systemModel removeEventsTriggeredFor: self.
	Package manager removeEventsTriggeredFor: self!

renameClass
	"Private - Initiate in-place label edit for the selected class."

	classesListPresenter view isWindowVisible 
		ifTrue: [classesListPresenter view editSelectionLabel]
		ifFalse: [super renameClass]!

updateClasses
	"Private - Update the classes list for this package. Try and maintain the existing selection if possible."

	| classes originalSelection |
	classes := Set new.
	environment classesDo: [:each | classes add: each instanceClass].
	originalSelection := self selections.
	self noEventsDo: 
			[classesPresenter list: classes asSortedCollection.
			classesPresenter selections: originalSelection ifAbsent: []].
	self selections == originalSelection ifFalse: [self onSelectionChanged]! !
!Tools.ClassListSelector categoriesFor: #browseItCommand!helpers!private! !
!Tools.ClassListSelector categoriesFor: #browserEnvironment!public! !
!Tools.ClassListSelector categoriesFor: #browserEnvironment:!accessing!public! !
!Tools.ClassListSelector categoriesFor: #classesListPresenter!accessing!private! !
!Tools.ClassListSelector categoriesFor: #createComponents!initializing!public! !
!Tools.ClassListSelector categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.ClassListSelector categoriesFor: #customDrawClassList:!helpers!private! !
!Tools.ClassListSelector categoriesFor: #customDrawClassTree:!helpers!private! !
!Tools.ClassListSelector categoriesFor: #deleteItCommand!helpers!private! !
!Tools.ClassListSelector categoriesFor: #initialize!initializing!private! !
!Tools.ClassListSelector categoriesFor: #model:!accessing!public! !
!Tools.ClassListSelector categoriesFor: #onClassRepackaged:from:to:!event handling!private! !
!Tools.ClassListSelector categoriesFor: #onDragOverList:!event handling!private! !
!Tools.ClassListSelector categoriesFor: #onListSelectionChanged!event handling!private!selection! !
!Tools.ClassListSelector categoriesFor: #onSelectionChanged!event handling!private!selection! !
!Tools.ClassListSelector categoriesFor: #onViewClosed!event handling!private! !
!Tools.ClassListSelector categoriesFor: #renameClass!commands!private!refactoring! !
!Tools.ClassListSelector categoriesFor: #updateClasses!private!updating! !

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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.CardContainer) 34 16 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 461638 4 ##(UI.Menu) nil true 34 17 1180742 2 ##(UI.CommandMenuItem) 2097153 1377606 4 ##(UI.CommandDescription) #findClass 8 'Find...' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'FindClass.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 482 nil true 34 10 530 1 562 #browseClassPackage 8 'Package <1d>' 1 1 610 nil true 656 8 'PackageBrowserShell.ico' 704 nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 530 2097153 562 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 482 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 850 4097 530 1 562 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 530 1 562 #browseMethodHistoryForClass 8 'Method &History' 1 1 610 nil true 656 8 'MethodHistory.ico' 704 nil nil 850 4097 530 1 562 #browsePublishedEvents 8 'Published &events' 1 1 nil nil nil 530 1 562 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 850 4097 530 1 562 #newClass 8 '&New...' 1 1 610 nil true 656 8 'NewClass.ico' 704 nil nil 530 1 562 #deleteClassHierarchy 8 '&Delete' 1 1 610 nil true 656 8 'EditClear.ico' 704 nil nil 482 nil true 34 19 530 1 562 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 530 2097153 562 #renameClass 8 'Re&name...' 1 1 nil nil nil 530 1 562 #copyClass 8 'Cl&one...' 1 1 nil nil nil 850 4097 530 1 562 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 530 1 562 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 482 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 482 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 850 4097 482 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 482 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 850 4097 482 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 482 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 482 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 850 4097 530 1 562 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 850 4097 530 1 562 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 610 nil true 656 8 'Refactoring.ico' 704 nil nil nil nil 850 4097 530 1 562 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 530 1 562 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 850 4097 530 1 562 #fileInClass 8 'File &In...' 1 1 nil nil nil 530 1 562 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 850 4097 530 1 562 #classPackage 8 '&Package...' 1 1 610 nil true 656 8 'Package.ico' 704 nil nil 530 1 562 #categorizeClass 8 '&Category...' 1 1 nil nil nil 850 4097 482 nil true 34 4 530 1 562 #newView 8 '&New...' 1 1 nil nil nil 850 4097 482 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 610 nil true 656 8 'ViewComposer.ico' 704 nil nil nil nil 482 nil true 8 #() 8 '&Show' #viewsShowMenu 1 610 nil true 656 8 'TestView.ico' 704 nil nil nil nil 8 '&Views' #viewsMenu 134217729 610 nil true 656 8 'View.ico' 704 nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 416 853318 1 ##(UI.CardLayout) 138 144 34 2 1049094 ##(Core.Association) 8 'Class List' 410 ##(UI.ListView) 34 45 nil 416 34 2 8 1140920909 1 3072 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1769478 ##(Kernel.IdentitySearchPolicy) 917510 ##(Graphics.Color) #default nil 29 nil nil nil 3072 nil 8 1801282304 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil 786950 ##(Core.Message) #fullName 8 #() nil nil nil nil 138 144 34 2 1117254 5 ##(UI.ListViewColumn) 8 'Class' 477 #left 3314 #unqualifiedName 8 #() 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x :y | x name <= y name]' 8 #[30 105 17 158 18 158 130 106] #name 3488 7 513 nil nil nil 3072 nil 3 nil 3474 0 nil 3506 4 1 3472 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawClassList: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawClassList: 3584 7 257 nil 3394 8 'Namespace' 201 #left 3314 #displayString 8 #() 3474 0 nil 3506 4 1 3472 8 'doIt' 8 '[:a :b | a isNil or: [b notNil and: [a fullName <= b fullName]]]' 8 #[32 105 17 223 2 58 106 18 222 6 226 2 226 34 130 106 59 106] #or: #and: #fullName 3728 7 513 nil 3314 #environment 3456 nil 3072 nil 1 nil nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 9 53 3954 685 441 3072 3906 #text: 34 1 8 'Class' 3072 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 90 1 0 0 246 0 0 0] 8 #() 3954 193 193 nil 35 3026 8 'Class Hierarchy' 410 ##(UI.TreeView) 34 27 nil 416 34 2 8 1140853291 1 4160 787526 3 ##(UI.TreeModel) nil 3216 721670 ##(UI.TreeNode) nil nil nil 170 192 3184 3248 nil 29 nil nil nil 4160 nil 8 1801125840 3314 #unqualifiedName 8 #() 3314 #iconImageIndex 4336 3296 nil 3314 #fullName 8 #() 3474 0 nil 3506 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view parentView presenter  customDrawClassTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #parentView #presenter #customDrawClassTree: 4400 7 257 nil nil nil 170 176 3184 nil #smallIcons 1 170 192 3184 3842 138 144 34 1 3906 #createAt:extent: 34 2 3954 9 53 3954 685 441 4160 4050 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 90 1 0 0 246 0 0 0] 8 #() 4112 nil 27 3072 nil nil nil 170 192 34 4 4160 8 'classes' 3072 8 'classesList' nil 410 ##(UI.TabViewXP) 34 28 nil 416 34 2 8 1140916736 1 4736 3138 138 144 34 2 3056 4144 nil 3216 nil nil 1 nil nil nil 4736 nil 8 1801049728 3314 #displayString 4336 3314 #iconImageIndex 4336 3296 nil nil nil nil nil #noIcons nil nil nil nil nil 3842 138 144 34 3 3906 #createAt:extent: 34 2 3954 1 1 3954 701 501 4736 3906 #setSingleSelection: 8 #(1) 4736 3906 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4736 4050 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 8 #() 4112 nil 27 3842 138 144 34 2 3906 #createAt:extent: 34 2 3954 6143 21 3954 701 501 416 3906 #contextMenu: 34 1 496 416 4050 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 93 13 0 0 4 1 0 0] 34 3 3072 4160 4736 4112 nil 27 )! !
!Tools.ClassListSelector class categoriesFor: #defaultModel!models!public! !
!Tools.ClassListSelector class categoriesFor: #resource_Default_view!public!resources-views! !

