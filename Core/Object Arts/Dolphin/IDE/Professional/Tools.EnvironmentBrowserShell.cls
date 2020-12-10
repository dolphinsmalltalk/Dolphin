"Filed out from Dolphin Smalltalk 7"!

ClassBrowserAbstract subclass: #EnvironmentBrowserShell
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
EnvironmentBrowserShell guid: (GUID fromString: '{b6ccd231-d2fb-4d98-b006-6a3ba26a4849}')!
EnvironmentBrowserShell comment: ''!
!EnvironmentBrowserShell categoriesForClass!MVP-Presenters! !
!EnvironmentBrowserShell methodsFor!

browseExecutableManifest
	| filename |
	filename := FileOpenDialog new
				caption: 'Open Executable Manifest';
				fileTypes: #(#('XML Manifest Files (*.xml)' '*.xml') #('All Files (*.*)' '*.*'));
				defaultExtension: 'xml';
				showModal.
	filename isNil ifTrue: [^self].
	self browseExecutableManifestFile: filename!

browseExecutableManifestFile: filename
	| dom |
	dom := IXMLDOMDocument new.
	dom loadURL: 'file://' , filename.
	self browserEnvironment: (SmalltalkSystem current browserEnvFromDom: dom)!

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
		caption: ('Unimplemented Selectors in <1p>' expandMacrosWith: environment)
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
!EnvironmentBrowserShell categoriesFor: #browseExecutableManifest!commands!public! !
!EnvironmentBrowserShell categoriesFor: #browseExecutableManifestFile:!commands!public! !
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 565 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 28 198 63 1 0 0 204 53 63 1 3 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point) 193 193 nil 528 327686 ##(Smalltalk.Color) #default 8 1867527152 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 784 nil nil nil 7 nil nil nil 784 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Search_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 615 1 674 437 51 784 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1120 nil nil nil 7 nil nil nil 1120 850 ##(Smalltalk.Toolbar) #resource_Edit_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1051 1 674 247 51 1120 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 136 2 0 0 25 0 0 0] 1072 1088 nil 27 8 'editTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1360 nil nil nil 7 nil nil nil 1360 850 ##(Smalltalk.Toolbar) #resource_Image_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 1 674 63 51 1360 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1072 1088 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1600 nil nil nil 7 nil nil nil 1600 850 ##(Smalltalk.Toolbar) #resource_Class_browser_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1297 1 674 307 51 1600 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 2 0 0 0 0 0 0 33 3 0 0 25 0 0 0] 1072 1088 nil 27 8 'classBrowserTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1840 nil nil nil 7 nil nil nil 1840 850 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 63 1 674 553 51 1840 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 1072 1088 nil 27 8 'smalltalkTools' 170 192 1072 138 144 1072 nil nil 1 nil 674 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 1 674 1699 51 528 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 81 3 0 0 25 0 0 0] 34 5 1360 1840 784 1120 1600 1088 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140853004 1 2320 nil nil nil 7 nil 594 nil true 626 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 674 193 193 nil 2320 nil 8 1867315760 170 192 34 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 2320 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'message' 2498 1 501 2320 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'packageOfSelection' 34 2 2544 2512 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2320 nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 849 674 1699 45 2320 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 1 0 0 81 3 0 0 190 1 0 0] 8 #() 1088 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2784 nil nil nil 7 nil nil nil 2784 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 2784 34 2 8 1140850688 1 2944 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2944 nil 1 #left nil nil nil 674 1 1 674 9 9 nil 3040 nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 395 674 1699 11 2944 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 197 0 0 0 81 3 0 0 202 0 0 0] 8 #() 1088 nil 27 1 true 170 192 34 2 410 ##(Smalltalk.CardContainer) 34 16 nil 2784 34 2 8 1140850688 131073 3264 nil nil nil 7 nil nil nil 3264 656710 1 ##(Smalltalk.CardLayout) 138 144 34 2 2914 590662 1 ##(Smalltalk.CardLabel) 8 'Method Source' 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 7 1 3408 8 'doIt' 8 '(CardLabel text: ''Method Source'' iconBlock: [Icon fromId: ''MethodSource.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 983558 ##(Smalltalk.VariableBinding) #CardLabel 3408 3440 3570 #Icon ##(Smalltalk.Icon) 8 'MethodSource.ico' #fromId: #text:iconBlock: 3472 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 3264 34 2 8 1140850688 131073 3632 nil nil nil 5 nil nil nil 3632 850 ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 9 53 674 1683 335 3632 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 77 3 0 0 193 0 0 0] 1072 1088 nil 27 2914 3410 8 'Class definition' 3458 0 nil 3490 7 1 3408 8 'doIt' 8 '(CardLabel text: ''Class definition'' iconBlock: [Icon fromId: ''ClassDefinition.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 3584 3888 3600 8 'ClassDefinition.ico' #fromId: #text:iconBlock: 3904 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 3264 34 2 8 1140916224 131073 4000 nil 720 nil 23 nil nil nil 4000 850 ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 9 53 674 1683 335 4000 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 77 3 0 0 193 0 0 0] 1072 1088 nil 27 4000 nil nil nil 170 192 34 4 3632 8 'source' 4000 8 'definition' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 3264 34 2 8 1140916736 1 4288 590662 2 ##(Smalltalk.ListModel) 138 144 34 2 3424 3872 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 1 nil nil nil 4288 nil 8 1867639456 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #smallIcons nil nil nil nil nil 882 138 144 34 3 946 #createAt:extent: 34 2 674 1 1 674 1699 395 4288 946 #basicSelectionsByIndex: 34 1 8 #(2) 4288 946 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4288 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 81 3 0 0 197 0 0 0] 8 #() 1088 nil 27 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 405 674 1699 395 3264 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 202 0 0 0 81 3 0 0 143 1 0 0] 34 3 3632 4000 4288 1088 nil 27 8 'cards' nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 51 674 1699 799 2784 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 81 3 0 0 168 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2784 34 2 8 1140850688 131073 5072 nil nil nil 7 nil nil nil 5072 2850 138 ##(Smalltalk.Dictionary) 34 2 2914 410 ##(Smalltalk.Splitter) 34 12 nil 5072 34 2 8 1140850688 1 5200 nil nil nil 519 nil nil nil 3010 5200 nil 1 #left nil nil nil 3040 3056 nil 3040 nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 559 1 674 11 395 5200 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 1 0 0 0 0 0 0 28 1 0 0 197 0 0 0] 8 #() 1088 nil 27 1 2914 410 ##(Smalltalk.Splitter) 34 12 nil 5072 34 2 8 1140850688 1 5456 nil nil nil 519 nil nil nil 3010 5456 nil 1 #left nil nil nil 3040 3056 nil 3040 nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1127 1 674 11 395 5456 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 2 0 0 0 0 0 0 56 2 0 0 197 0 0 0] 8 #() 1088 nil 27 1 false 170 192 34 4 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 5072 34 2 8 1140850688 131073 5728 nil nil nil 519 nil nil nil 5728 3330 138 144 34 3 2914 3410 8 'Categories' 3458 0 nil 3490 3 1 3456 8 'doIt' 8 '[MethodCategory icon]
' 8 #[31 105 45 159 106] 3570 #MethodCategory ##(Smalltalk.MethodCategory) #icon 5888 7 1 nil 21481 410 ##(Smalltalk.TreeView) 34 27 nil 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 5728 34 2 8 1140850688 131073 6016 nil nil nil 7 nil nil nil 6016 5792 170 192 34 6 5984 8 'categories' 410 ##(Smalltalk.ListView) 34 45 nil 6016 34 2 8 1140936777 1 6128 4354 138 144 1072 nil 4432 720 nil 29 265030 4 ##(Smalltalk.Menu) nil true 34 7 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #browseSelectorsInProtocol 8 '&Selectors' 1 1 nil nil nil 6274 1 6306 #toggleProtocolReadOnly 8 '&Read Only' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 6274 1 6306 #addMethodProtocol 8 '&Add...' 1 1 nil nil nil 6226 nil true 34 2 6274 1 6306 #removeMethodProtocol 8 'Protocol' 1 1 nil nil nil 6274 1 6306 #removeMethodsInProtocol 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 6274 1 6306 #renameMethodProtocol 8 'Rename...' 1 1 nil nil nil 6274 1 6306 #browseMethodProtocol 8 'Browse' 1 1 nil nil nil 8 'Protocols' nil 134217729 nil nil nil nil nil nil nil 6128 nil 8 1867533600 459270 ##(Smalltalk.Message) #name 8 #() ##(Smalltalk.IconicListAbstract) 4480 nil nil 3458 0 nil 3490 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 6800 7 257 nil 674 65 65 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Protocols' 439 #left 6754 #name 8 #() 6754 #<= 8 #() nil nil 6128 nil 3 nil 3458 0 nil 3490 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 7040 7 257 nil #report 1072 nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 882 138 144 34 3 946 #createAt:extent: 34 2 674 1 37 674 447 343 6128 946 #contextMenu: 34 1 6240 6128 946 #text: 34 1 8 'Protocols' 6128 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 223 0 0 0 189 0 0 0] 8 #() 1088 nil 35 8 'protocols' 410 ##(Smalltalk.ListView) 34 45 nil 6016 34 2 8 1140920395 1 7376 4354 138 144 1072 nil 4432 720 nil 13 6226 nil true 34 10 6274 2097153 6306 #browseInstVarReferences 8 'Browse &References' 1 1 nil nil nil 6402 4097 6274 1 6306 #addInstanceVariable 8 '&Add...' 1 1 nil nil nil 6274 1 6306 #removeInstanceVariables 8 'Remo&ve' 1 1 nil nil nil 6274 1 6306 #renameInstanceVariable 8 'Re&name' 1 1 nil nil nil 6402 4097 6274 1 6306 #pushDownInstanceVariables 8 'Push &Down' 1 1 nil nil nil 6274 1 6306 #createAccessors 8 '&Create Accessors' 1 1 nil nil nil 6274 1 6306 #abstractInstanceVariables 8 'Ab&stract' 1 1 nil nil nil 6274 1 6306 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 7376 nil 8 1867533600 6754 #value 8 #() 3458 0 nil 3490 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] #key #icon #imageIndex 7968 7 257 nil 4480 nil 3458 0 nil 3490 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] #key #name 8 '.' #, 8048 7 257 nil nil 674 65 65 nil nil 138 144 34 1 6930 8 '' 201 #left ##(Smalltalk.BasicListAbstract) 6754 #<= 8 #() nil nil 7376 nil 1 nil nil #list 1072 nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 674 1 37 674 447 343 7376 946 #contextMenu: 34 1 7472 7376 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 223 0 0 0 189 0 0 0] 8 #() 1088 nil 35 8 'variables' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 5728 34 2 8 1140916864 1 8464 4354 138 144 34 3 5856 3410 8 'Protocols' 3458 0 nil 3490 6 1 16 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 3570 #CardLabel 3408 8592 3570 #MethodProtocol ##(Smalltalk.MethodProtocol) #icon #text:iconBlock: 8608 11 1 nil 21487 3410 8 'Variables' nil 21491 nil 4432 nil nil 1 nil nil nil 8464 nil 8 1867639456 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 4480 nil nil nil nil nil #smallIcons nil nil nil nil nil 882 138 144 34 3 946 #createAt:extent: 34 2 674 1 1 674 559 395 8464 946 #basicSelectionsByIndex: 34 1 8 #(1) 8464 946 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8464 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 23 1 0 0 197 0 0 0] 8 #() 1088 nil 27 nil 5728 674 33 33 1050182 1 ##(Smalltalk.ButtonInteractor) 6016 nil 1 590342 ##(Smalltalk.Rectangle) 674 411 3 674 443 35 nil 6306 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 105 9 674 447 379 6016 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 52 0 0 0 4 0 0 0 19 1 0 0 193 0 0 0] 34 3 5984 6128 7376 1088 nil 27 34 2 8 1140916771 1 5984 590918 3 ##(Smalltalk.TreeModel) nil 4432 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 1072 720 nil 31 6226 nil true 34 4 6274 1 6306 #addMethodCategory 8 '&Add...' 1 1 nil nil nil 6226 nil true 34 2 6274 1 6306 #removeMethodCategory 8 'Category' 1 1 nil nil nil 6274 1 6306 #removeMethodsInCategory 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 6274 1 6306 #renameMethodCategory 8 'Rename...' 1 1 nil nil nil 6274 1 6306 #browseMethodCategory 8 'Browse' 1 1 nil nil nil 8 'Categories' nil 134217729 nil nil nil nil nil nil nil 5984 nil 8 1867333664 6754 #localName 8 #() ##(Smalltalk.IconicListAbstract) 4480 nil nil 3458 0 nil 3490 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawCategoryTree: 9808 7 257 nil nil nil 170 176 1072 nil #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 1072 882 138 144 34 2 946 #createAt:extent: 34 2 674 1 37 674 447 343 5984 946 #contextMenu: 34 1 9424 5984 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 223 0 0 0 189 0 0 0] 8 #() 1088 nil 27 2914 8576 6128 2914 8720 7376 5984 nil nil nil 170 192 34 2 6016 8 'filters' nil 8464 6016 674 201 201 401 1 524319 nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 569 1 674 559 395 5728 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 1 0 0 0 0 0 0 51 2 0 0 197 0 0 0] 34 2 6016 8464 1088 nil 27 8 'filtersSlidey' 410 ##(Smalltalk.ReferenceView) 34 14 nil 5072 34 2 8 1140850688 131073 10384 nil nil nil 31 6226 nil true 34 17 6274 1 6306 #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 6226 nil true 34 10 6274 1 6306 #browseClassPackage 8 'Package <1d>' 1 1 10530 nil true 10576 8 'Package.ico' 10624 nil nil 6402 4097 6274 2097153 6306 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 6226 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 6402 4097 6274 1 6306 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 6274 1 6306 #browseMethodHistoryForClass 8 'Method &History' 1 1 nil nil nil 6402 4097 6274 1 6306 #browsePublishedEvents 8 'Published &events' 1 1 nil nil nil 6274 1 6306 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 6402 4097 6274 1 6306 #newClass 8 '&New...' 1 1 10530 nil true 10576 8 'NewClass.ico' 10624 nil nil 6274 1 6306 #deleteClassHierarchy 8 '&Delete' 1 1 10530 nil true 10576 8 'EditClear.ico' 10624 nil nil 6226 nil true 34 18 6274 1 6306 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 6274 2097153 6306 #renameClass 8 'Re&name...' 1 1 nil nil nil 6402 4097 6274 1 6306 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 6274 1 6306 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 6226 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 6226 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 6402 4097 6226 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 6226 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 6402 4097 6226 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 6226 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 6226 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 6402 4097 6274 1 6306 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 6402 4097 6274 1 6306 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 10530 nil true 10576 8 'Refactoring.ico' 10624 nil nil nil nil 6402 4097 6274 1 6306 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 6274 1 6306 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 6402 4097 6274 1 6306 #fileInClass 8 'File &In...' 1 1 nil nil nil 6274 1 6306 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 6402 4097 6274 1 6306 #classPackage 8 '&Package...' 1 1 10530 nil true 10576 8 'Package.ico' 10624 nil nil 6274 1 6306 #categorizeClass 8 '&Category...' 1 1 nil nil nil 6402 4097 6226 nil true 34 4 6274 1 6306 #newView 8 '&New...' 1 1 nil nil nil 6402 4097 6226 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 nil nil nil nil nil 6226 nil true 8 #() 8 '&Show' #viewsShowMenu 1 nil nil nil nil nil 8 '&Views' #viewsMenu 1 10530 nil true 10576 8 'View.ico' 10624 nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 10384 850 ##(Smalltalk.ClassListSelector) #resource_Default_view nil 882 138 144 34 2 946 #createAt:extent: 34 2 674 1 1 674 559 395 10384 946 #contextMenu: 34 1 10448 10384 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 23 1 0 0 197 0 0 0] 1072 1088 nil 27 8 'classes' nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 1 674 1699 395 5072 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 81 3 0 0 197 0 0 0] 34 5 10384 5200 5728 5456 410 ##(Smalltalk.ContainerView) 34 15 nil 5072 34 2 8 1140850688 131073 13088 nil nil nil 7 nil nil nil 13088 498 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 13088 34 2 8 1140850688 131073 13168 nil nil nil 535 nil nil nil 13168 2130 11 1 1 170 192 34 4 410 ##(Smalltalk.RadioButton) 34 16 nil 13168 34 2 8 1141055497 1 13280 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 6754 #= 8 #() 6754 #hash 8 #() false nil nil 7 nil nil nil 13280 nil 8 1867514112 852486 ##(Smalltalk.NullConverter) nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 674 21 1 674 131 51 13280 946 #text: 34 1 8 'In&stance' 13280 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 75 0 0 0 25 0 0 0] 8 #() 1088 nil 27 8 'instanceMode' 410 ##(Smalltalk.RadioButton) 34 16 nil 13168 34 2 8 1141055497 1 13744 13346 nil nil 13378 6754 #= 8 #() 6754 #hash 8 #() false nil nil 7 nil nil nil 13744 nil 8 1867514112 13490 nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 674 161 1 674 111 51 13744 946 #text: 34 1 8 'C&lass' 13744 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 0 0 0 0 135 0 0 0 25 0 0 0] 8 #() 1088 nil 27 8 'classMode' 9058 674 21 1 674 1 1 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 345 674 563 51 13168 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 172 0 0 0 25 1 0 0 197 0 0 0] 34 2 13280 13744 1088 nil 27 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 13088 34 2 8 1140850688 131073 14368 nil nil nil 31 nil nil nil 14368 850 ##(Smalltalk.MethodBrowser) #resource_Class_browser_method_list nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 1 674 563 345 14368 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 25 1 0 0 172 0 0 0] 1072 1088 nil 27 170 192 34 4 14368 8 'methods' 13168 8 'mode' nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1137 1 674 563 395 13088 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 56 2 0 0 0 0 0 0 81 3 0 0 197 0 0 0] 34 2 13168 14368 1088 nil 27 1088 nil 27 2944 3264 1088 nil 27 170 192 34 4 2320 8 'statusbar' 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 9 6226 nil true 34 10 6274 1 6306 #fileNew 8 '&New Workspace' 9373 1 10530 nil true 10576 8 'NewWorkspace.ico' 10624 nil nil 6274 1 6306 #fileOpen 8 '&Open Workspace...' 9375 1 10530 nil true 10576 8 'OpenWorkspace.ico' 10624 nil nil 6274 1 6306 #fileFileIn 8 '&File In...' 1 1 10530 nil true 10576 8 'FileIn.ico' 10624 nil nil 6402 4097 6274 1 6306 #browseExecutableManifest 8 'Open &Executable Manifest...' 1 1 10530 nil true 10576 8 'FileOpen.ico' 10624 nil nil 6402 4097 6274 1 6306 #saveImage 8 'Sa&ve Image' 1 1 10530 nil true 10576 8 'Snapshot.ico' 10624 nil nil 6274 1 6306 #smalltalkExit 8 'E&xit Dolphin' 1 1 10530 nil true 10576 8 'PowerSwitch.ico' 10624 nil nil 6402 4097 6274 1 6306 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 46205 nil nil 6226 nil true 34 13 6274 1 6306 #undo 8 '&Undo' 9397 1 10530 nil true 10576 8 'EditUndo.ico' 10624 nil nil 6402 4097 6274 1 6306 #cutSelection 8 'Cu&t' 9393 1 10530 nil true 10576 8 'EditCut.ico' 10624 nil nil 6274 1 6306 #copySelection 8 '&Copy' 9351 1 10530 nil true 10576 8 'EditCopy.ico' 10624 nil nil 6274 1 6306 #pasteClipboard 8 '&Paste' 9389 1 10530 nil true 10576 8 'EditPaste.ico' 10624 nil nil 6274 1 6306 #editDelete 8 '&Delete' 1 1 10530 nil true 10576 8 'EditClear.ico' 10624 nil nil 6226 nil true 34 2 6274 1 6306 #reformatSource 8 '&Source' 9391 1 nil nil nil 6274 1 6306 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 46221 nil nil 6402 4097 6274 1 6306 #selectAll 8 'Select &All' 9347 1 nil nil nil 6402 4097 6274 1 6306 #editFind 8 '&Find...' 9357 1 10530 nil true 10576 47 786694 ##(Smalltalk.ShellLibrary) nil nil 6274 1 6306 #findNext 8 'Find &Next' 1253 1 10530 nil true 10576 8 'FindNext.ico' 10624 nil nil 6274 1 6306 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 46231 nil nil 6226 nil true 34 15 6274 1 6306 #browseIt 8 '&Browse It' 9349 1 10530 nil true 10576 8 'ClassBrowserShell.ico' 10624 nil nil 6274 1 6306 #displayIt 8 '&Display It' 9353 1 10530 nil true 10576 8 'DisplayIt.ico' 10624 nil nil 6274 1 6306 #printIt 8 '&Print It' 9377 1 10530 nil true 10576 8 'PrintIt.ico' 10624 nil nil 6274 1 6306 #evaluateIt 8 '&Evaluate It' 9355 1 10530 nil true 10576 8 'EvaluateIt.ico' 10624 nil nil 6274 1 6306 #inspectIt 8 '&Inspect It' 9363 1 10530 nil true 10576 8 'InspectIt.ico' 10624 nil nil 6274 1 6306 #debugIt 8 'Deb&ug It' 1269 1 10530 nil true 10576 8 'Debugger.ico' 10624 nil nil 6274 1 6306 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 6402 4097 6274 1 6306 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 6274 1 6306 #browseReferences 8 '&References' 5367 1 nil nil nil 6402 4097 6274 2097153 6306 #accept 8 '&Accept' 9383 1 nil nil nil 6274 1 6306 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 6402 4097 6226 nil true 34 13 6274 1 6306 #renameVariable 8 'Re&name <1d>...' 1 1 10530 nil true 10576 8 'Rename.ico' 10624 nil nil 6402 4097 6274 1 6306 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 nil nil nil 6274 1 6306 #extractMethod 8 'E&xtract Method...' 9371 1 nil nil nil 6274 1 6306 #extractToComponent 8 'Extract to &Component...' 1 1 nil nil nil 6274 1 6306 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 6402 4097 6274 1 6306 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 6274 1 6306 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 6274 1 6306 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 6402 4097 6274 1 6306 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 6274 1 6306 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 10530 nil true 10576 8 'Refactoring.ico' 10624 nil 46275 nil nil 8 '&Workspace' nil 134217729 nil nil 46277 nil nil 6226 nil true 34 17 6274 2097153 6306 #findClass 8 'Find...' 1 1 10530 nil true 10576 8 'FindClass.ico' 10624 nil nil 6226 nil true 34 10 6274 1 6306 #browseClassPackage 8 'Package <1d>' 1 1 10530 nil true 10576 8 'Package.ico' 10624 nil nil 6402 4097 6274 2097153 6306 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 6226 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil 46285 nil nil 6402 4097 6274 1 6306 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 6274 1 6306 #browseMethodHistoryForClass 8 'Method &History' 1 1 10530 nil true 10576 8 'MethodHistory.ico' 10624 nil nil 6402 4097 6274 1 6306 #browsePublishedEvents 8 'Published &events' 1 1 10530 nil true 10576 8 'Event.ico' 10624 nil nil 6274 1 6306 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil 46295 nil nil 6402 4097 6274 1 6306 #newClass 8 '&New...' 1 1 10530 nil true 10576 8 'NewClass.ico' 10624 nil nil 6274 1 6306 #deleteClassHierarchy 8 '&Delete' 1 1 10530 nil true 10576 8 'EditClear.ico' 10624 nil nil 6226 nil true 34 19 6274 1 6306 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 6274 2097153 6306 #renameClass 8 'Re&name...' 1 1 10530 nil true 10576 8 'Rename.ico' 10624 nil nil 6274 1 6306 #copyClass 8 'Cl&one...' 1 1 nil nil nil 6402 4097 6274 1 6306 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 6274 1 6306 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 6226 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil 46311 nil nil 6226 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil 46313 nil nil 6402 4097 6226 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil 46315 nil nil 6226 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil 46317 nil nil 6402 4097 6226 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil 46319 nil nil 6226 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil 46321 nil nil 6226 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil 46323 nil nil 6402 4097 6274 1 6306 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 6402 4097 6274 1 6306 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 10530 nil true 10576 8 'Refactoring.ico' 10624 nil 46329 nil nil 6402 4097 6274 1 6306 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 6274 1 6306 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 6402 4097 6274 1 6306 #fileInClass 8 'File &In...' 1 1 10530 nil true 10576 8 'FileIn.ico' 10624 nil nil 6274 1 6306 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 6402 4097 6274 1 6306 #classPackage 8 '&Package...' 1 1 10530 nil true 10576 8 'Package.ico' 10624 nil nil 6274 1 6306 #categorizeClass 8 '&Category...' 1 1 10530 nil true 10576 8 'Category.ico' 10624 nil nil 6402 4097 6226 nil true 34 4 6274 1 6306 #newView 8 '&New...' 1 1 nil nil nil 6402 4097 6226 nil true 8 #() 8 '&Edit' #viewsEditMenu 134217729 10530 nil true 10576 8 'ViewComposer.ico' 10624 nil 46345 nil nil 6226 nil true 8 #() 8 '&Show' #viewsShowMenu 1 10530 nil true 10576 8 'TestView.ico' 10624 nil 46347 nil nil 8 '&Views' #viewsMenu 134217729 10530 nil true 10576 8 'View.ico' 10624 nil 46349 nil nil 8 '&Class' nil 134217729 nil nil 46351 nil nil 6226 nil true 34 15 6226 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 46353 nil nil 6226 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 46355 nil nil 6226 nil true 34 16 6274 1 6306 #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 6274 1 6306 #browseContainingText 8 'C&ontaining Text...' 1 1 10530 nil true 10576 8 'SearchText.ico' 10624 nil nil 6274 1 6306 #browseMethodCategory 8 'Cate&gory...' 1 1 10530 nil true 10576 8 'Category.ico' 10624 nil nil 6274 1 6306 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 6274 1 6306 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 6402 4097 6274 1 6306 #browseMethodPackages 8 '&Package <s>' 1 1 10530 nil true 10576 8 'Package.ico' 10624 nil nil 6274 1 6306 #browseMethodClasses 8 'C&lass <s>' 1 1 nil nil nil 6402 4097 6274 1 6306 #browseMethodHistory 8 '&Change History' 1 1 10530 nil true 10576 8 'MethodHistory.ico' 10624 nil nil 6274 1 6306 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 6402 4097 6274 1 6306 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 6274 1 6306 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 6402 4097 6274 1 6306 #browseUnimplemented 8 'All U&nimplemented' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 46381 nil nil 6402 4097 6274 1 6306 #newMethod 8 '&New' 1 1 10530 nil true 10576 8 'NewMethod.ico' 10624 nil nil 6274 1 6306 #removeMethod 8 '&Delete' 1 1 10530 nil true 10576 8 'EditClear.ico' 10624 nil nil 6226 nil true 34 17 6274 1 6306 #renameMethod 8 'Re&name' 1 1 nil nil nil 6274 1 6306 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 6274 1 6306 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 6402 4097 6274 1 6306 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 6226 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 46395 nil nil 6226 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 46397 nil nil 6226 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 46399 nil nil 6402 4097 6226 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 46401 nil nil 6226 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 46403 nil nil 6402 4097 6274 1 6306 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 6274 1 6306 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 6274 1 6306 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 6274 1 6306 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 6274 1 6306 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 10530 nil true 10576 8 'Refactoring.ico' 10624 nil 46415 nil nil 6402 4097 6274 1 6306 #methodPackage 8 '&Package...' 1 1 10530 nil true 10576 8 'Package.ico' 10624 nil nil 6226 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 46421 nil nil 6226 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 46423 nil nil 6274 1 6306 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 6402 4097 6274 1 6306 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 6274 1 6306 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 46431 nil nil 6226 nil true 34 7 6274 1 6306 #undoChange 8 '&Undo <1d>' 1 1 10530 nil true 10576 8 'EditUndo.ico' 10624 nil nil 6274 1 6306 #redoChange 8 '&Redo <1d>' 1 1 10530 nil true 10576 8 'EditRedo.ico' 10624 nil nil 6274 1 6306 #clearChangeHistory 8 'Clear Change &History' 1 1 10530 nil true 10576 8 'MethodHistoryErase.ico' 10624 nil nil 6402 4097 6274 1 6306 #historyBack 8 'Back to <1d>' 1 1 10530 nil true 10576 8 'HistoryBack.ico' 10624 nil nil 6274 1 6306 #historyForward 8 'Forward to <1d>' 1 1 10530 nil true 10576 8 'HistoryForward.ico' 10624 nil nil 6274 1 6306 #historyClear 8 'Clear Visit History' 1 1 10530 nil true 10576 8 'HistoryErase.ico' 10624 nil nil 8 'H&istory' nil 134217729 nil nil 46445 nil nil 6226 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 46447 nil nil 6226 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 46449 nil nil 6226 nil true 34 15 6274 1 6306 #helpContents 8 '&Contents' 1025 1 10530 nil true 10576 8 'Help.ico' 10624 nil nil 6274 1 6306 #help 8 'On this &Tool' 1249 1 nil nil nil 6274 1 6306 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 6402 4097 6274 1 6306 #learnSmalltalk 8 'Learn Smalltalk' 1 1 15538 $\x1F393 nil 706 #orchid 706 #white nil nil 1 nil nil nil nil 6402 4097 6274 1 6306 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 6274 1 6306 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 6274 1 6306 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 6402 4097 6274 1 6306 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 10530 nil true 10576 8 '!!APPLICATION' 10624 nil nil 6274 1 6306 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 6274 1 6306 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 6402 4097 6274 1 6306 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 15538 $\x1F42C nil nil 706 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 46473 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 7039 21 674 1731 1011 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 32 17 0 0 3 2 0 0] 34 3 528 2784 2320 1088 nil 27 )!

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
		helpId: self toolsFolderHelpId! !
!EnvironmentBrowserShell class categoriesFor: #displayOn:!displaying!public! !
!EnvironmentBrowserShell class categoriesFor: #icon!constants!public! !
!EnvironmentBrowserShell class categoriesFor: #initialize!initializing!private! !
!EnvironmentBrowserShell class categoriesFor: #initializeTool!initializing!private! !
!EnvironmentBrowserShell class categoriesFor: #onEnvironment:!instance creation!public! !
!EnvironmentBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !
!EnvironmentBrowserShell class categoriesFor: #toolDescription!constants!public! !
!EnvironmentBrowserShell class categoriesFor: #toolsFolderHelpId!constants!public! !
!EnvironmentBrowserShell class categoriesFor: #toolsFolderIcon!constants!public! !

