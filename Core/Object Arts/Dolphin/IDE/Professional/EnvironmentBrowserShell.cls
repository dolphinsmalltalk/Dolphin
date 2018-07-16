"Filed out from Dolphin Smalltalk 7"!

ClassBrowserAbstract subclass: #EnvironmentBrowserShell
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EnvironmentBrowserShell guid: (GUID fromString: '{b6ccd231-d2fb-4d98-b006-6a3ba26a4849}')!
EnvironmentBrowserShell comment: ''!
!EnvironmentBrowserShell categoriesForClass!Development! !
!EnvironmentBrowserShell methodsFor!

browseExecutableManfiestFile: filename 
	| dom |
	dom := IXMLDOMDocument new.
	dom loadURL: 'file://' , filename.
	self browserEnvironment: (SmalltalkSystem current browserEnvFromDom: dom)!

browseExecutableManifest
	| filename |
	filename := (FileOpenDialog new)
				caption: 'Open Executable Manifest';
				fileTypes: #(#('XML Manifest Files (*.xml)' '*.xml') #('All Files (*.*)' '*.*'));
				defaultExtension: 'xml';
				showModal.
	filename isNil ifTrue: [^self].
	self browseExecutableManfiestFile: filename!

browserEnvironment: aBrowserEnvironment 
	"Set the <BrowserEnvironment> that defines the list of classes displayed in the receiver."

	classesPresenter
		browserEnvironment: aBrowserEnvironment;
		searchEnvironment: aBrowserEnvironment.
	methodBrowserPresenter searchEnvironment: aBrowserEnvironment.
	definitionPresenter searchEnvironment: aBrowserEnvironment.
	self caption: aBrowserEnvironment label!

browseUnimplemented
	"Open a method browser on all methods in the selected packages that themselves send a
	message which is not apparently implemented in any of those packages or their
	prerequisites."

	| environment unimplemented |
	environment := self searchEnvironment.
	unimplemented := self systemModel unimplementedSelectorsIn: environment.
	self systemModel 
		browseSelectors: unimplemented asSortedCollection
		caption: ('Unimplemented Selectors in <1d>' expandMacrosWith: environment)
		environment: environment!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	classesPresenter := self add: ClassListSelector new name: 'classes'.
!

defaultHelpId
	^10895!

displayLocalHierarchyOf: class
	"Private - Update the receiver to display only the local hierarchy of the <ClassDescription>,
	class."

	| instClass |
	instClass := class instanceClass.
	classesPresenter
		model: (ClassHierarchyModel withAllClasses	
				filter: [:x | (instClass allSuperclasses includes: x) or: [instClass withAllSubclasses includes: x]]).
!

isLocalHierarchyMode
	"Private - Answer whether the receiver is in 'local hierarchy' mode displaying a subset of the entire
	class hierarchy."

	^false
	"^flags allMask: LocalHierarchyMask"!

isLocalHierarchyMode: aBoolean 
	"flags := flags mask: LocalHierarchyMask set: aBoolean"!

isMethodVisible: aCompiledMethod 
	^(self browserEnvironment includesMethod: aCompiledMethod) 
		and: [super isMethodVisible: aCompiledMethod]!

onTipTextRequired: tool
	"Private - Tool tip text is required for the <ToolbarItem>, tool."

	| cmd |
	cmd := tool command asSymbol.
	cmd == #toggleLocalHierarchy ifTrue: [
		^(self isLocalHierarchyMode 
				ifTrue: ['Browse entire hierarchy']
				ifFalse: ['Browse local hierarchy of ', self selectedClass name])].
	^super onTipTextRequired: tool!

printCaptionForClass: aClass on: aWriteStream 
	"Private - Answer a suitable caption for the selected method."

	^aWriteStream display: self browserEnvironment!

printCaptionForMethod: aCompiledMethod on: aWriteStream 
	self browserEnvironment displayOn: aWriteStream!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery>."

	| cmd |
	cmd := aCommandQuery commandSymbol.
	#toggleLocalHierarchy == cmd 
		ifTrue: 
			[self isLocalHierarchyMode 
				ifTrue: 
					[aCommandQuery
						isEnabled: true;
						isChecked: true]
				ifFalse: 
					[aCommandQuery
						isEnabled: (self hasClassSelected and: [self actualClass superclass notNil]);
						isChecked: false].
			^true].
	^super queryCommand: aCommandQuery!

resetFor: aClass 
	"Reset the receiver to place it into a state required to display aClass"

	(self isLocalHierarchyMode 
		and: [(classesPresenter model filter value: aClass instanceClass) not]) 
			ifTrue: [self displayLocalHierarchyOf: aClass]!

saveStateOn: aWriteStream 
	"Private - Write the source of a monadic block that will configure an instance of the receiver's class
	to match the state current receiver, to aWriteStream. The block expects a fresh instance of
	the receiver's class as it's parameter"

	aWriteStream nextPutAll: '[:anEnvironmentBrowser | '.
	self 
		saveStateAspects: #(#browserEnvironment)
		for: 'anEnvironmentBrowser'
		on: aWriteStream.
	aWriteStream
		nextPut: $.;
		cr.
	super saveStateOn: aWriteStream.
	aWriteStream
		nextPutAll: ' value: anEnvironmentBrowser';
		cr.
	aWriteStream nextPut: $]!

searchEnvironment
	^classesPresenter browserEnvironment!

toggleLocalHierarchy
	"Toggle between the entire hierarchy and showing only the current class and its subclasses."

	| instClass actualClass |
	self promptToSaveChanges ifFalse: [^self].

	"Use the selected class rather than the actual class, so always follows instance hierarchy"
	instClass := self selectedClass.
	actualClass := self actualClass.
	self isLocalHierarchyMode: self isLocalHierarchyMode not.
	self isLocalHierarchyMode 
		ifTrue: 
			["Toggled into local hierarchy mode"
			self displayLocalHierarchyOf: instClass.
			self actualClass: actualClass]
		ifFalse: 
			["Toggled out of local hierarchy mode..."
			classesPresenter model: self model classHierarchy.
			actualClass notNil ifTrue: [self actualClass: actualClass]].
	self validateUserInterface! !
!EnvironmentBrowserShell categoriesFor: #browseExecutableManfiestFile:!commands!public! !
!EnvironmentBrowserShell categoriesFor: #browseExecutableManifest!commands!public! !
!EnvironmentBrowserShell categoriesFor: #browserEnvironment:!accessing!public! !
!EnvironmentBrowserShell categoriesFor: #browseUnimplemented!commands!public! !
!EnvironmentBrowserShell categoriesFor: #createComponents!initializing!public! !
!EnvironmentBrowserShell categoriesFor: #defaultHelpId!constants!public! !
!EnvironmentBrowserShell categoriesFor: #displayLocalHierarchyOf:!private!updating! !
!EnvironmentBrowserShell categoriesFor: #isLocalHierarchyMode!private!testing! !
!EnvironmentBrowserShell categoriesFor: #isLocalHierarchyMode:!accessing!private! !
!EnvironmentBrowserShell categoriesFor: #isMethodVisible:!private!testing! !
!EnvironmentBrowserShell categoriesFor: #onTipTextRequired:!event handling!private! !
!EnvironmentBrowserShell categoriesFor: #printCaptionForClass:on:!private!updating! !
!EnvironmentBrowserShell categoriesFor: #printCaptionForMethod:on:!private!updating! !
!EnvironmentBrowserShell categoriesFor: #queryCommand:!commands!private! !
!EnvironmentBrowserShell categoriesFor: #resetFor:!commands!public! !
!EnvironmentBrowserShell categoriesFor: #saveStateOn:!private!saved state! !
!EnvironmentBrowserShell categoriesFor: #searchEnvironment!commands!public! !
!EnvironmentBrowserShell categoriesFor: #toggleLocalHierarchy!commands!public! !

!EnvironmentBrowserShell class methodsFor!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Environment Browser'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self defaultShowInheritedMethods: false.
	self defaultFilterObjectMethods: true.
	self canUseIdeaSpace: true.
!

initializeTool
	"
	self initializeTool
	"
	(Smalltalk developmentSystem)
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self!

onEnvironment: aBrowserEnvironment 
	^(self show)
		browserEnvironment: aBrowserEnvironment;
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786950 ##(Smalltalk.DefaultColor) #toolBackground nil 567 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 28 198 63 1 0 0 204 53 63 1 3 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point) 193 193 nil 528 524550 ##(Smalltalk.ColorRef) 8 4278190080 8 1912794480 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 800 nil nil nil 7 nil nil nil 800 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Edit_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 1 51 674 247 51 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 8 #() 674 193 193 nil 27 8 'editTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1136 nil nil nil 7 nil nil nil 1136 866 ##(Smalltalk.Toolbar) #resource_Search_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 661 1 674 433 51 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 1 0 0 0 0 0 0 34 2 0 0 25 0 0 0] 1088 1104 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1376 nil nil nil 7 nil nil nil 1376 866 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 63 1 674 599 51 1376 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 74 1 0 0 25 0 0 0] 1088 1104 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1616 nil nil nil 7 nil nil nil 1616 866 ##(Smalltalk.Toolbar) #resource_Class_browser_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 247 51 674 307 51 1616 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 123 0 0 0 25 0 0 0 20 1 0 0 50 0 0 0] 1088 1104 nil 27 8 'classBrowserTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1856 nil nil nil 7 nil nil nil 1856 866 ##(Smalltalk.Toolbar) #resource_Image_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 1 674 63 51 1856 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1088 1104 nil 27 8 'imageTools' 170 192 1088 138 144 1088 170 176 1088 nil 1 nil 674 33 33 674 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 898 138 144 34 2 962 #createAt:extent: 34 2 674 1 1 674 1169 101 528 962 #updateSizePosted 1088 528 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 50 0 0 0] 34 5 1856 1376 1136 800 1616 1104 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140853004 1 2384 nil nil nil 7 nil 594 nil true 626 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 674 193 193 nil 2384 nil 8 1912526784 170 192 34 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 2384 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1050182 1 ##(Smalltalk.IconImageManager) 8 'message' 2562 1 501 2384 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2608 8 'packageOfSelection' 34 2 2640 2576 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2384 nil nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 643 674 1169 41 2384 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 8 #() 1104 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2880 nil nil nil 7 nil nil nil 2880 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 2880 34 2 8 1140850688 1 3040 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3040 nil 1 #left nil nil nil 674 1 1 674 9 9 nil 3136 nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 267 674 1169 11 3040 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 133 0 0 0 72 2 0 0 138 0 0 0] 8 #() 1104 nil 27 1 true 170 192 34 2 410 ##(Smalltalk.CardContainer) 34 16 nil 2880 34 2 8 1140850688 131073 3360 nil nil nil 7 nil nil nil 3360 655878 ##(Smalltalk.CardLayout) 138 144 34 2 3010 590662 1 ##(Smalltalk.CardLabel) 8 'Method Source' 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 7 1 16 8 'doIt' 8 '(CardLabel text: ''Method Source'' iconBlock: [Icon fromId: ''CompiledMethod.ico''])' 8 #[29 30 35 113 31 32 180 106 195 105] 3504 3536 ##(Smalltalk.Icon) 8 'CompiledMethod.ico' #fromId: #text:iconBlock: 3568 11 1 nil 20981 410 ##(Smalltalk.ReferenceView) 34 14 nil 3360 34 2 8 1140850688 131073 3680 nil nil nil 7 nil nil nil 3680 866 ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 9 53 674 1153 207 3680 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 68 2 0 0 129 0 0 0] 1088 1104 nil 27 3010 3506 8 'Class definition' 3554 0 nil 3586 7 1 ##(Smalltalk.SmallInteger) 8 'doIt' 8 '(CardLabel text: ''Class definition'' iconBlock: [Icon fromId: ''Class.ico''])' 8 #[29 30 35 113 31 32 180 106 195 105] 3504 3936 ##(Smalltalk.Icon) 8 'Class.ico' #fromId: #text:iconBlock: 3952 11 1 nil 21493 410 ##(Smalltalk.ReferenceView) 34 14 nil 3360 34 2 8 1140916224 131073 4048 nil 706 8 4278190080 nil 21 nil nil nil 4048 866 ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 9 53 674 1153 207 4048 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 68 2 0 0 129 0 0 0] 1088 1104 nil 27 3680 170 192 34 4 3680 8 'source' 4048 8 'definition' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 3360 34 2 8 1140916736 1 4368 590662 2 ##(Smalltalk.ListModel) 138 144 34 2 3520 3920 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 1 nil nil nil 4368 nil 8 1912616880 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2608 nil nil nil nil nil #smallIcons nil nil nil nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 674 1 1 674 1169 267 4368 962 #basicSelectionsByIndex: 34 1 8 #(1) 4368 962 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4368 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 133 0 0 0] 8 #() 1104 nil 27 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 277 674 1169 267 3360 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 138 0 0 0 72 2 0 0 15 1 0 0] 34 3 3680 4048 4368 1104 nil 27 8 'cards' nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 101 674 1169 543 2880 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 72 2 0 0 65 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2880 34 2 8 1140850688 131073 5120 nil nil nil 7 nil nil nil 5120 2946 138 ##(Smalltalk.Dictionary) 34 2 3010 410 ##(Smalltalk.Splitter) 34 12 nil 5120 34 2 8 1140850688 1 5248 nil nil nil 519 nil nil nil 3106 5248 nil 1 #left nil nil nil 674 1 1 3152 nil 5328 nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 775 1 674 11 267 5248 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 131 1 0 0 0 0 0 0 136 1 0 0 133 0 0 0] 8 #() 1104 nil 27 1 3010 410 ##(Smalltalk.Splitter) 34 12 nil 5120 34 2 8 1140850688 1 5520 nil nil nil 519 nil nil nil 3106 5520 nil 1 #left nil nil nil 674 1 1 3152 nil 5600 nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 383 1 674 11 267 5520 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 0 0 0 0 0 0 0 196 0 0 0 133 0 0 0] 8 #() 1104 nil 27 1 false 170 192 34 4 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 5120 34 2 8 1140850688 131073 5808 nil nil nil 519 nil nil nil 5808 3426 138 144 34 3 3010 3506 8 'Categories' nil 21481 410 ##(Smalltalk.TreeView) 34 27 nil 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 5808 34 2 8 1140850688 131073 6000 nil nil nil 7 nil nil nil 6000 5872 170 192 34 6 410 ##(Smalltalk.ListView) 34 30 nil 6000 34 2 8 1140920395 1 6096 4434 138 144 1088 nil 4512 706 8 4278190080 nil 13 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 2097153 1180998 4 ##(Smalltalk.CommandDescription) #browseInstVarReferences 8 'Browse &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 6274 1 6306 #addInstanceVariable 8 '&Add...' 1 1 nil nil nil 6274 1 6306 #removeInstanceVariables 8 'Remo&ve' 1 1 nil nil nil 6274 1 6306 #renameInstanceVariable 8 'Re&name' 1 1 nil nil nil 6354 4097 6274 1 6306 #pushDownInstanceVariables 8 'Push &Down' 1 1 nil nil nil 6274 1 6306 #createAccessors 8 '&Create Accessors' 1 1 nil nil nil 6274 1 6306 #abstractInstanceVariables 8 'Ab&stract' 1 1 nil nil nil 6274 1 6306 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 6096 nil 8 1912800272 459270 ##(Smalltalk.Message) #value 8 #() 3554 0 nil 3586 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] #key #icon #imageIndex 6800 7 257 nil 2608 nil 3554 0 nil 3586 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] #key #name 8 '.' #, 6880 7 257 nil nil 674 65 65 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 201 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) nil nil 6096 nil 1 nil nil #list 1088 nil 133217 nil 34 4 nil nil 674 1 1 nil 898 138 144 34 2 962 #createAt:extent: 34 2 674 1 37 674 223 215 6096 962 #contextMenu: 34 1 6240 6096 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 111 0 0 0 125 0 0 0] 8 #() 1104 nil 27 8 'variables' 5968 8 'categories' 410 ##(Smalltalk.ListView) 34 30 nil 6000 34 2 8 1140936777 1 7328 4434 138 144 1088 nil 4512 706 8 4278190080 nil 29 6226 nil true 34 7 6274 1 6306 #browseSelectorsInProtocol 8 '&Selectors' 1 1 nil nil nil 6274 1 6306 #toggleProtocolReadOnly 8 '&Read Only' 1 1 nil nil nil 6354 4097 6274 1 6306 #addMethodProtocol 8 '&Add...' 1 1 nil nil nil 6226 nil true 34 2 6274 1 6306 #removeMethodProtocol 8 'Protocol' 1 1 nil nil nil 6274 1 6306 #removeMethodsInProtocol 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 6274 1 6306 #renameMethodProtocol 8 'Rename...' 1 1 nil nil nil 6274 1 6306 #browseMethodProtocol 8 'Browse' 1 1 nil nil nil 8 'Protocols' nil 134217729 nil nil nil nil nil nil nil 7328 nil 8 1912800272 6754 #name 8 #() ##(Smalltalk.IconicListAbstract) 2608 nil nil 3554 0 nil 3586 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 7952 7 257 nil 674 65 65 nil nil 138 144 34 1 7026 8 'Protocols' 215 #left 6754 #name 8 #() ##(Smalltalk.SortedCollection) nil nil 7328 nil 3 nil 3554 0 nil 3586 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 8144 7 257 nil #report 1088 nil 133217 nil 34 4 nil nil 674 1 1 nil 898 138 144 34 3 962 #createAt:extent: 34 2 674 1 37 674 223 215 7328 962 #contextMenu: 34 1 7456 7328 962 #text: 34 1 8 'Protocols' 7328 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 111 0 0 0 125 0 0 0] 8 #() 1104 nil 27 8 'protocols' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 5808 34 2 8 1140916864 1 8512 4434 138 144 34 3 5936 3506 8 'Protocols' 3554 0 nil 3586 6 1 16 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 983558 ##(Smalltalk.VariableBinding) #CardLabel 3504 8640 8738 #MethodProtocol ##(Smalltalk.MethodProtocol) #icon #text:iconBlock: 8656 11 1 nil 21487 3506 8 'Variables' nil 21491 nil 4512 nil nil 1 nil nil nil 8512 nil 8 1912616880 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2608 nil nil nil nil nil #smallIcons nil nil nil nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 674 1 1 674 383 267 8512 962 #basicSelectionsByIndex: 34 1 8 #(1) 8512 962 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8512 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 191 0 0 0 133 0 0 0] 8 #() 1104 nil 27 nil 5808 674 33 33 1050182 1 ##(Smalltalk.ButtonInteractor) 6000 nil 1 590342 ##(Smalltalk.Rectangle) 674 187 3 674 219 35 nil 6306 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 153 9 674 223 251 6000 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 0 0 0 4 0 0 0 187 0 0 0 129 0 0 0] 34 3 5968 7328 6096 1104 nil 27 34 2 8 1140916771 1 5968 590918 3 ##(Smalltalk.TreeModel) nil 4512 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 1088 706 8 4278190080 nil 31 6226 nil true 34 4 6274 1 6306 #addMethodCategory 8 '&Add...' 1 1 nil nil nil 6226 nil true 34 2 6274 1 6306 #removeMethodCategory 8 'Category' 1 1 nil nil nil 6274 1 6306 #removeMethodsInCategory 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 6274 1 6306 #renameMethodCategory 8 'Rename...' 1 1 nil nil nil 6274 1 6306 #browseMethodCategory 8 'Browse' 1 1 nil nil nil 8 'Categories' nil 134217729 nil nil nil nil nil nil nil 5968 nil 8 1912658960 6754 #localName 8 #() ##(Smalltalk.IconicListAbstract) 2608 nil nil 3554 0 nil 3586 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawCategoryTree: 9904 7 257 nil nil nil 170 176 1088 17 #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 1088 898 138 144 34 2 962 #createAt:extent: 34 2 674 1 37 674 223 215 5968 962 #contextMenu: 34 1 9520 5968 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 111 0 0 0 125 0 0 0] 8 #() 1104 nil 27 3010 8624 7328 3010 8784 6096 5968 170 192 34 2 6000 8 'filters' nil 8512 6000 674 201 201 401 1 524319 nil nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 393 1 674 383 267 5808 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 196 0 0 0 0 0 0 0 131 1 0 0 133 0 0 0] 34 2 6000 8512 1104 nil 27 8 'filtersSlidey' 410 ##(Smalltalk.ReferenceView) 34 14 nil 5120 34 2 8 1140850688 131073 10480 nil nil nil 31 6226 nil true 34 19 6274 1 6306 #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 6226 nil true 34 9 6274 1 6306 #browseClassPackage 8 'Package <1d>' 1 1 10626 nil true 10672 8 'Package.ico' 10720 nil nil 6354 4097 6274 2097153 6306 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 6226 nil true 8 #() 8 'Local Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 6354 4097 6274 1 6306 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 6354 4097 6274 1 6306 #browsePublishedEvents 8 'Published &events' 1 1 nil nil nil 6274 1 6306 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 6354 4097 6274 1 6306 #newClass 8 '&New...' 1 1 10626 nil true 10672 8 'NewClass.ico' 10720 nil nil 6274 1 6306 #deleteClassHierarchy 8 '&Delete' 1 1 10626 nil true 10672 8 'EditClear.ico' 10720 nil nil 6226 nil true 34 18 6274 1 6306 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 6274 2097153 6306 #renameClass 8 'Re&name...' 1 1 nil nil nil 6354 4097 6274 1 6306 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 6274 1 6306 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 6226 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 6226 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 6354 4097 6226 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 6226 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 6354 4097 6226 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 6226 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 6226 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 6354 4097 6274 1 6306 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 6354 4097 6274 1 6306 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 10626 nil true 10672 8 'Refactoring.ico' 10720 nil nil nil nil 6354 4097 6274 1 6306 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 6274 1 6306 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 6354 4097 6274 1 6306 #fileInClass 8 'File &In...' 1 1 nil nil nil 6274 1 6306 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 6354 4097 6274 1 6306 #classPackage 8 '&Package...' 1 1 10626 nil true 10672 8 'Package.ico' 10720 nil nil 6274 1 6306 #categorizeClass 8 '&Category...' 1 1 nil nil nil 6354 4097 6226 nil true 34 7 6274 1 6306 #browseChangedMethods 8 'Browse &Changes in Image' 1 1 nil nil nil 6274 1 6306 #browseMethodHistoryForClass 8 'Browse Change &History in Image' 1 1 nil nil nil 6354 4097 6274 1 6306 #browseClassEditions 8 'Browse Class &Editions' 1 1 nil nil nil 6274 1 6306 #browseAvailableMethods 8 'Browse Deleted Method Editions' 1 1 nil nil nil 6354 4097 6274 1 6306 #compareClass 8 'Compare Class Edition...' 1 1 nil nil nil 8 'C&hanges' nil 134217729 nil nil nil nil nil 6354 4097 6226 nil true 34 4 6274 1 6306 #newView 8 '&New...' 1 1 nil nil nil 6354 4097 6226 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 nil nil nil nil nil 6226 nil true 8 #() 8 '&Show' #viewsShowMenu 1 nil nil nil nil nil 8 '&Views' #viewsMenu 1 10626 nil true 10672 8 'View.ico' 10720 nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 10480 866 ##(Smalltalk.ClassListSelector) #resource_Default_view nil 898 138 144 34 2 962 #createAt:extent: 34 2 674 1 1 674 383 267 10480 962 #contextMenu: 34 1 10544 10480 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 191 0 0 0 133 0 0 0] 1088 1104 nil 27 8 'classes' nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 1 674 1169 267 5120 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 133 0 0 0] 34 5 10480 5520 5808 5248 410 ##(Smalltalk.ContainerView) 34 15 nil 5120 34 2 8 1140850688 131073 13472 nil nil nil 7 nil nil nil 13472 498 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 13472 34 2 8 1140850688 131073 13552 nil nil nil 535 nil nil nil 13552 2178 11 1 1 170 192 34 4 410 ##(Smalltalk.RadioButton) 34 16 nil 13552 34 2 8 1141055497 1 13664 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 6754 #= 8 #() 6754 #hash 8 #() false nil nil 7 nil nil nil 13664 nil 8 1912725136 852486 ##(Smalltalk.NullConverter) nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 674 161 1 674 111 51 13664 962 #text: 34 1 8 'C&lass' 13664 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 0 0 0 0 135 0 0 0 25 0 0 0] 8 #() 1104 nil 27 8 'classMode' 410 ##(Smalltalk.RadioButton) 34 16 nil 13552 34 2 8 1141055497 1 14128 13730 nil nil 13762 6754 #= 8 #() 6754 #hash 8 #() false nil nil 7 nil nil nil 14128 nil 8 1912725136 13874 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 674 21 1 674 131 51 14128 962 #text: 34 1 8 'In&stance' 14128 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 75 0 0 0 25 0 0 0] 8 #() 1104 nil 27 8 'instanceMode' 9122 674 21 1 674 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 217 674 385 51 13552 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 108 0 0 0 192 0 0 0 133 0 0 0] 34 2 14128 13664 1104 nil 27 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 13472 34 2 8 1140850688 131073 14752 nil nil nil 31 nil nil nil 14752 866 ##(Smalltalk.MethodBrowser) #resource_Class_browser_method_list nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 1 674 385 217 14752 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 192 0 0 0 108 0 0 0] 1088 1104 nil 27 170 192 34 4 13552 8 'mode' 14752 8 'methods' nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 785 1 674 385 267 13472 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 0 0 0 0 72 2 0 0 133 0 0 0] 34 2 13552 14752 1104 nil 27 1104 nil 27 3040 3360 1104 nil 27 170 192 34 4 2384 8 'statusbar' 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 9 6226 nil true 34 10 6274 1 6306 #fileNew 8 '&New' 9373 1 10626 nil true 10672 8 'FileNew.ico' 10720 nil nil 6274 1 6306 #fileOpen 8 '&Open...' 9375 1 10626 nil true 10672 8 'FileOpen.ico' 10720 nil nil 6274 1 6306 #fileFileIn 8 '&File In...' 1 1 nil nil nil 6354 4097 6274 1 6306 #browseExecutableManifest 8 'Open &Executable Manifest...' 1 1 nil nil nil 6354 4097 6274 1 6306 #saveImage 8 'Sa&ve Image' 1 1 10626 nil true 10672 8 'Snapshot.ico' 10720 nil nil 6274 1 6306 #smalltalkExit 8 'E&xit Dolphin' 1 1 10626 nil true 10672 8 'PowerSwitch.ico' 10720 nil nil 6354 4097 6274 1 6306 #exit 8 '&Close' 17639 1 10626 nil true 10672 8 'CloseWindow.ico' 10720 nil nil 8 '&File' nil 134217729 nil nil 49273 nil nil 6226 nil true 34 13 6274 1 6306 #undo 8 '&Undo' 9397 1 10626 nil true 10672 8 'EditUndo.ico' 10720 nil nil 6354 4097 6274 1 6306 #cutSelection 8 'Cu&t' 9393 1 10626 nil true 10672 8 'EditCut.ico' 10720 nil nil 6274 1 6306 #copySelection 8 '&Copy' 9351 1 10626 nil true 10672 8 'EditCopy.ico' 10720 nil nil 6274 1 6306 #pasteClipboard 8 '&Paste' 9389 1 10626 nil true 10672 8 'EditPaste.ico' 10720 nil nil 6274 1 6306 #editDelete 8 '&Delete' 1 1 10626 nil true 10672 8 'EditClear.ico' 10720 nil nil 6226 nil true 34 2 6274 1 6306 #reformatSource 8 '&Source' 9391 1 nil nil nil 6274 1 6306 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 49289 nil nil 6354 4097 6274 1 6306 #selectAll 8 'Select &All' 9347 1 nil nil nil 6354 4097 6274 1 6306 #editFind 8 '&Find...' 9357 1 10626 nil true 10672 47 786694 ##(Smalltalk.ShellLibrary) nil nil 6274 1 6306 #findNext 8 'Find &Next' 1253 1 10626 nil true 10672 8 'FindNext.ico' 10720 nil nil 6274 1 6306 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 49299 nil nil 6226 nil true 34 14 6274 1 6306 #browseIt 8 '&Browse It' 9349 1 10626 nil true 10672 8 'ClassBrowserShell.ico' 10720 nil nil 6274 1 6306 #displayIt 8 '&Display It' 9353 1 10626 nil true 10672 8 'DisplayIt.ico' 10720 nil nil 6274 1 6306 #evaluateIt 8 '&Evaluate It' 9355 1 10626 nil true 10672 8 'EvaluateIt.ico' 10720 nil nil 6274 1 6306 #inspectIt 8 '&Inspect It' 9363 1 10626 nil true 10672 8 'InspectIt.ico' 10720 nil nil 6274 1 6306 #debugIt 8 'Deb&ug It' 1269 1 10626 nil true 10672 8 'Debugger.ico' 10720 nil nil 6274 1 6306 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 6354 4097 6274 1 6306 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 6274 1 6306 #browseReferences 8 '&References' 5367 1 nil nil nil 6354 4097 6274 2097153 6306 #accept 8 '&Accept' 9383 1 nil nil nil 6274 1 6306 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 6354 4097 6226 nil true 34 13 6274 1 6306 #renameVariable 8 'Re&name <1d>...' 1 1 nil nil nil 6354 4097 6274 1 6306 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 nil nil nil 6274 1 6306 #extractMethod 8 'E&xtract Method...' 9371 1 nil nil nil 6274 1 6306 #extractToComponent 8 'Extract to &Component...' 1 1 nil nil nil 6274 1 6306 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 6354 4097 6274 1 6306 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 6274 1 6306 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 6274 1 6306 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 6354 4097 6274 1 6306 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 6274 1 6306 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 10626 nil true 10672 8 'Refactoring.ico' 10720 nil 49341 nil nil 8 '&Workspace' nil 134217729 nil nil 49343 nil nil 6226 nil true 34 20 6274 2097153 6306 #findClass 8 'Find...' 1 1 10626 nil true 10672 8 'FindClass.ico' 10720 nil nil 6226 nil true 34 10 6274 1 6306 #browseClassPackage 8 'Package <1d>' 1 1 10626 nil true 10672 8 'Package.ico' 10720 nil nil 6354 4097 6274 2097153 6306 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 6226 nil true 8 #() 8 'Local Re&ferences To' #browseVariablesMenu 134217729 nil nil 49351 nil nil 6354 4097 6274 1 6306 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 6274 1 6306 #browseMethodHistoryForClass 8 'Method &History' 1 1 nil nil nil 6354 4097 6274 1 6306 #browsePublishedEvents 8 'Published &events' 1 1 nil nil nil 6274 1 6306 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil 49361 nil nil 6354 4097 6274 1 6306 #newClass 8 '&New...' 1 1 10626 nil true 10672 8 'NewClass.ico' 10720 nil nil 6274 1 6306 #deleteClassHierarchy 8 '&Delete' 1 1 10626 nil true 10672 8 'EditClear.ico' 10720 nil nil 6226 nil true 34 19 6274 1 6306 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 6274 2097153 6306 #renameClass 8 'Re&name...' 1 1 nil nil nil 6274 1 6306 #copyClass 8 'Cl&one...' 1 1 nil nil nil 6354 4097 6274 1 6306 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 6274 1 6306 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 6226 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil 49377 nil nil 6226 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil 49379 nil nil 6354 4097 6226 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil 49381 nil nil 6226 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil 49383 nil nil 6354 4097 6226 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil 49385 nil nil 6226 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil 49387 nil nil 6226 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil 49389 nil nil 6354 4097 6274 1 6306 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 6354 4097 6274 1 6306 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 10626 nil true 10672 8 'Refactoring.ico' 10720 nil 49395 nil nil 6354 4097 6274 1 6306 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 6274 1 6306 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 6354 4097 6274 1 6306 #fileInClass 8 'File &In...' 1 1 nil nil nil 6274 1 6306 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 6354 4097 6274 1 6306 #classPackage 8 '&Package...' 1 1 10626 nil true 10672 8 'Package.ico' 10720 nil nil 6274 1 6306 #categorizeClass 8 '&Category...' 1 1 nil nil nil 6354 4097 6274 1 6306 #browseClassEditions 8 'Browse &Editions' 1 1 nil nil nil 6274 1 6306 #compareClass 8 'Compare with...' 1 1 nil nil nil 6354 4097 6226 nil true 34 4 6274 1 6306 #newView 8 '&New...' 1 1 nil nil nil 6354 4097 6226 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 nil nil 49415 nil nil 6226 nil true 8 #() 8 '&Show' #viewsShowMenu 1 nil nil 49417 nil nil 8 '&Views' #viewsMenu 1 10626 nil true 10672 8 'View.ico' 10720 nil 49419 nil nil 8 '&Class' nil 134217729 nil nil 49421 nil nil 6226 nil true 34 18 6226 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 49423 nil nil 6226 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 49425 nil nil 6226 nil true 34 14 6274 1 6306 #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 6274 1 6306 #browseContainingText 8 'C&ontaining Text...' 1 1 10626 nil true 10672 8 'SearchText.ico' 10720 nil nil 6274 1 6306 #browseMethodCategory 8 'Cate&gory...' 1 1 nil nil nil 6274 1 6306 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 6274 1 6306 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 6354 4097 6274 1 6306 #browseMethodPackages 8 'Package <s>' 1 1 nil nil nil 6274 1 6306 #browseMethodClasses 8 'Class <s>' 1 1 nil nil nil 6354 4097 6274 1 6306 #browseMethodHistory 8 '&Change History' 1 1 nil nil nil 6274 1 6306 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 6354 4097 6274 1 6306 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 6274 1 6306 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 49449 nil nil 6354 4097 6274 1 6306 #newMethod 8 '&New' 1 1 10626 nil true 10672 8 'NewMethod.ico' 10720 nil nil 6274 1 6306 #removeMethod 8 '&Delete' 1 1 10626 nil true 10672 8 'EditClear.ico' 10720 nil nil 6226 nil true 34 17 6274 1 6306 #renameMethod 8 'Re&name' 1 1 nil nil nil 6274 1 6306 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 6274 1 6306 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 6354 4097 6274 1 6306 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 6226 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 49463 nil nil 6226 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 49465 nil nil 6226 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 49467 nil nil 6354 4097 6226 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 49469 nil nil 6226 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 49471 nil nil 6354 4097 6274 1 6306 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 6274 1 6306 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 6274 1 6306 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 6274 1 6306 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 6274 1 6306 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 10626 nil true 10672 8 'Refactoring.ico' 10720 nil 49483 nil nil 6354 4097 6274 1 6306 #methodPackage 8 '&Package...' 1 1 10626 nil true 10672 8 'Package.ico' 10720 nil nil 6226 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 49487 nil nil 6226 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 49489 nil nil 6274 1 6306 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 6354 4097 6274 1 6306 #browseMethodEditions 8 'Browse &Editions' 1 1 nil nil nil 6274 1 6306 #browseAvailableMethods 8 'Browse Available Editions' 1 1 nil nil nil 6354 4097 6274 1 6306 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 6274 1 6306 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 49501 nil nil 6226 nil true 34 7 6274 1 6306 #undoChange 8 '&Undo <1d>' 1 1 10626 nil true 10672 8 'EditUndo.ico' 10720 nil nil 6274 1 6306 #redoChange 8 '&Redo <1d>' 1 1 10626 nil true 10672 8 'EditRedo.ico' 10720 nil nil 6274 1 6306 #clearChangeHistory 8 'Clear Change &History' 1 1 nil nil nil 6354 4097 6274 1 6306 #historyBack 8 'Back to <1d>' 1 1 10626 nil true 10672 8 'HistoryBack.ico' 10720 nil nil 6274 1 6306 #historyForward 8 'Forward to <1d>' 1 1 10626 nil true 10672 8 'HistoryForward.ico' 10720 nil nil 6274 1 6306 #historyClear 8 'Clear Visit History' 1 1 nil nil nil 8 'H&istory' nil 134217729 nil nil 49515 nil nil 6226 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 49517 nil nil 6226 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 49519 nil nil 6226 nil true 34 15 6274 1 6306 #helpContents 8 '&Contents' 1025 1 10626 nil true 10672 49 16656 nil nil 6274 1 6306 #help 8 'On this &Tool' 1249 1 nil nil nil 6274 1 6306 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 6354 4097 6274 1 6306 #learnSmalltalk 8 'Learn Smalltalk' 1 1 nil nil nil 6354 4097 6274 1 6306 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 6274 1 6306 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 6274 1 6306 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 6354 4097 6274 1 6306 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 nil nil nil 6274 1 6306 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 6274 1 6306 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 6354 4097 6274 1 6306 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 10626 nil true 10672 8 '!!APPLICATION' 10720 nil nil 8 '&Help' nil 134217729 nil nil 49543 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 674 3839 21 674 1201 801 416 962 #updateMenuBar 1088 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 3 528 2880 2384 1104 nil 27 )!

toolDescription
	"Answer the description of this tool that should be displayed in, for example,
	the system shell window."

	^'Executable Browser'!

toolsFolderHelpId
	^10601!

toolsFolderIcon
	| desc |
	desc := self toolDescription.
	^SmalltalkSystemIcon 
		tool: self
		icon: nil
		description: desc
		openBlock: 
			[:folder :sysicon | 
			(sysicon tool create)
				caption: desc;
				show]
		helpId: self toolsFolderHelpId!

uninitialize
	"Private - Uninitialize the receiver prior to remove from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: self toolDescription;
		unregisterTool: self! !
!EnvironmentBrowserShell class categoriesFor: #displayOn:!displaying!public! !
!EnvironmentBrowserShell class categoriesFor: #icon!constants!public! !
!EnvironmentBrowserShell class categoriesFor: #initialize!initializing!private! !
!EnvironmentBrowserShell class categoriesFor: #initializeTool!initializing!private! !
!EnvironmentBrowserShell class categoriesFor: #onEnvironment:!instance creation!public! !
!EnvironmentBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !
!EnvironmentBrowserShell class categoriesFor: #toolDescription!constants!public! !
!EnvironmentBrowserShell class categoriesFor: #toolsFolderHelpId!constants!public! !
!EnvironmentBrowserShell class categoriesFor: #toolsFolderIcon!constants!public! !
!EnvironmentBrowserShell class categoriesFor: #uninitialize!class hierarchy-removing!private! !

