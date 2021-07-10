"Filed out from Dolphin Smalltalk"!

Tools.ClassBrowserAbstract subclass: #'Tools.EnvironmentBrowserShell'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.EnvironmentBrowserShell guid: (Core.GUID fromString: '{b6ccd231-d2fb-4d98-b006-6a3ba26a4849}')!
Tools.EnvironmentBrowserShell comment: ''!
!Tools.EnvironmentBrowserShell categoriesForClass!MVP-Presenters! !
!Tools.EnvironmentBrowserShell methodsFor!

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
	dom := MSXML newDocument.
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
	classesPresenter := self add: ClassListSelector new name: 'classes'!

defaultHelpId
	^10895!

displayLocalHierarchyOf: class
	"Private - Update the receiver to display only the local hierarchy of the <ClassDescription>,
	class."

	| instClass |
	instClass := class instanceClass.
	classesPresenter model: (ClassHierarchyModel withAllClasses
				filter: [:x | (instClass allSuperclasses includes: x) or: [instClass withAllSubclasses includes: x]])!

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

	aWriteStream nextPutAll: '[:anEnvironmentBrowser | anEnvironmentBrowser browserEnvironment: '.
	self browserEnvironment storeOn: aWriteStream.
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
!Tools.EnvironmentBrowserShell categoriesFor: #browseExecutableManifest!commands!public! !
!Tools.EnvironmentBrowserShell categoriesFor: #browseExecutableManifestFile:!commands!public! !
!Tools.EnvironmentBrowserShell categoriesFor: #browserEnvironment:!accessing!public! !
!Tools.EnvironmentBrowserShell categoriesFor: #browseUnimplemented!commands!public! !
!Tools.EnvironmentBrowserShell categoriesFor: #createComponents!initializing!public! !
!Tools.EnvironmentBrowserShell categoriesFor: #defaultHelpId!constants!public! !
!Tools.EnvironmentBrowserShell categoriesFor: #displayLocalHierarchyOf:!private!updating! !
!Tools.EnvironmentBrowserShell categoriesFor: #isLocalHierarchyMode!private!testing! !
!Tools.EnvironmentBrowserShell categoriesFor: #isLocalHierarchyMode:!accessing!private! !
!Tools.EnvironmentBrowserShell categoriesFor: #isMethodVisible:!private!testing! !
!Tools.EnvironmentBrowserShell categoriesFor: #onTipTextRequired:!event handling!private! !
!Tools.EnvironmentBrowserShell categoriesFor: #printCaptionForClass:on:!private!updating! !
!Tools.EnvironmentBrowserShell categoriesFor: #printCaptionForMethod:on:!private!updating! !
!Tools.EnvironmentBrowserShell categoriesFor: #queryCommand:!commands!private! !
!Tools.EnvironmentBrowserShell categoriesFor: #resetFor:!commands!public! !
!Tools.EnvironmentBrowserShell categoriesFor: #saveStateOn:!private!saved state! !
!Tools.EnvironmentBrowserShell categoriesFor: #searchEnvironment!commands!public! !
!Tools.EnvironmentBrowserShell categoriesFor: #toggleLocalHierarchy!commands!public! !

!Tools.EnvironmentBrowserShell class methodsFor!

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

	SmalltalkSystem current
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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #toolBackground nil 567 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 28 198 63 1 0 0 204 53 63 1 3 0 20 59 0 0 0 0 247 0 5 86 111 1] 918022 ##(Graphics.Point) 193 193 nil 528 917510 ##(Graphics.Color) #default 8 1886172432 170 192 34 10 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 784 nil nil nil 7 nil nil nil 784 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Toolbar) #resource_Edit_tools nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 674 1051 1 674 247 51 784 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 136 2 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'editTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1120 nil nil nil 7 nil nil nil 1120 850 ##(UI.Toolbar) #resource_Class_browser_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1297 1 674 353 51 1120 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 2 0 0 0 0 0 0 56 3 0 0 25 0 0 0] 1072 1088 nil 27 8 'classBrowserTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1360 nil nil nil 7 nil nil nil 1360 850 ##(UI.Toolbar) #resource_Search_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 615 1 674 437 51 1360 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 1072 1088 nil 27 8 'searchTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1600 nil nil nil 7 nil nil nil 1600 850 ##(UI.Toolbar) #resource_Image_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 1 674 63 51 1600 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1072 1088 nil 27 8 'imageTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1840 nil nil nil 7 nil nil nil 1840 850 ##(UI.Toolbar) #resource_Smalltalk_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 63 1 674 553 51 1840 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 1072 1088 nil 27 8 'smalltalkTools' 170 192 1072 138 144 1072 nil nil 1 nil 674 33 33 nil nil 852806 1 ##(UI.FlowLayout) 1 1 1 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 1 674 1699 51 528 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 81 3 0 0 25 0 0 0] 34 5 1600 1840 1360 784 1120 1088 nil 27 410 ##(UI.StatusBar) 34 18 nil 416 34 2 8 1140853004 1 2320 nil nil nil 7 nil 594 nil true 626 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 674 193 193 nil 2320 nil 8 1885871984 170 192 34 6 1050438 1 ##(UI.StatusBarItem) 8193 -1 2320 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'message' 2498 8705 351 2320 nil 786950 ##(Core.Message) #displayString 8 #() 2562 #iconImageIndex 8 #() 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:namespace | ''Method namespace: '', namespace fullName]' 8 #[32 105 29 226 1 178 106] 8 'Method namespace: ' #fullName #, 2656 7 257 nil 8 'namespace' 2498 8193 501 2320 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'packageOfSelection' 34 3 2784 2512 2544 1311814 1 ##(UI.StatusBarNullItem) 8705 1 2320 nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 849 674 1699 45 2320 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 1 0 0 81 3 0 0 190 1 0 0] 8 #() 1088 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3024 nil nil nil 7 nil nil nil 3024 1376774 ##(UI.ProportionalLayout) 138 ##(Core.Dictionary) 34 1 1049094 ##(Core.Association) 410 ##(UI.Splitter) 34 12 nil 3024 34 2 8 1140850688 1 3184 nil nil nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 3184 nil 1 #left nil nil nil 674 1 1 674 9 9 nil 3280 nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 395 674 1699 11 3184 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 197 0 0 0 81 3 0 0 202 0 0 0] 8 #() 1088 nil 27 1 true 170 192 34 2 410 ##(UI.CardContainer) 34 16 nil 3024 34 2 8 1140850688 131073 3504 nil nil nil 7 nil nil nil 3504 853318 1 ##(UI.CardLayout) 138 144 34 2 3154 787270 1 ##(UI.CardLabel) 8 'Method Source' 2642 0 nil 2674 7 1 3648 8 'doIt' 8 '(CardLabel text: ''Method Source'' iconBlock: [Icon fromId: ''MethodSource.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 1442886 2 ##(Kernel.VariableBinding) #CardLabel 3648 ##(Smalltalk) 1 3680 3778 #Icon ##(Graphics.Icon) ##(Smalltalk) 1 8 'MethodSource.ico' #fromId: #text:iconBlock: 3696 11 1 nil nil 410 ##(UI.ReferenceView) 34 14 nil 3504 34 2 8 1140850688 131073 3840 nil nil nil 5 nil nil nil 3840 850 ##(Tools.MethodWorkspace) #resource_Default_view nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 9 53 674 1683 335 3840 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 77 3 0 0 193 0 0 0] 1072 1088 nil 27 3154 3650 8 'Class definition' 2642 0 nil 2674 7 1 3648 8 'doIt' 8 '(CardLabel text: ''Class definition'' iconBlock: [Icon fromId: ''ClassDefinition.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 3792 4096 3808 8 'ClassDefinition.ico' #fromId: #text:iconBlock: 4112 11 1 nil nil 410 ##(UI.ReferenceView) 34 14 nil 3504 34 2 8 1140916224 131073 4208 nil 720 nil 23 nil nil nil 4208 850 ##(Tools.SmalltalkWorkspace) #resource_Default_view nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 9 53 674 1683 335 4208 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 77 3 0 0 193 0 0 0] 1072 1088 nil 27 4208 nil nil nil 170 192 34 4 4208 8 'definition' 3840 8 'source' nil 410 ##(UI.TabViewXP) 34 28 nil 3504 34 2 8 1140916736 1 4496 787270 2 ##(UI.ListModel) 138 144 34 2 3664 4080 nil 1769478 ##(Kernel.IdentitySearchPolicy) nil nil 1 nil nil nil 4496 nil 8 1885916928 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil #smallIcons nil nil nil nil nil 882 138 144 34 3 946 #createAt:extent: 34 2 674 1 1 674 1699 395 4496 946 #setSingleSelection: 8 #(2) 4496 946 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4496 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 81 3 0 0 197 0 0 0] 8 #() 1088 nil 27 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 405 674 1699 395 3504 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 202 0 0 0 81 3 0 0 143 1 0 0] 34 3 3840 4208 4496 1088 nil 27 8 'cards' nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 51 674 1699 799 3024 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 81 3 0 0 168 1 0 0] 34 3 410 ##(UI.ContainerView) 34 15 nil 3024 34 2 8 1140850688 131073 5264 nil nil nil 7 nil nil nil 5264 3090 138 ##(Core.Dictionary) 34 2 3154 410 ##(UI.Splitter) 34 12 nil 5264 34 2 8 1140850688 1 5392 nil nil nil 519 nil nil nil 3250 5392 nil 1 #left nil nil nil 3280 3296 nil 3280 nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 559 1 674 11 395 5392 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 1 0 0 0 0 0 0 28 1 0 0 197 0 0 0] 8 #() 1088 nil 27 1 3154 410 ##(UI.Splitter) 34 12 nil 5264 34 2 8 1140850688 1 5648 nil nil nil 519 nil nil nil 3250 5648 nil 1 #left nil nil nil 3280 3296 nil 3280 nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1127 1 674 11 395 5648 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 2 0 0 0 0 0 0 56 2 0 0 197 0 0 0] 8 #() 1088 nil 27 1 false 170 192 34 4 410 ##(UI.SlideyInneyOuteyThing) 34 23 nil 5264 34 2 8 1140850688 131073 5920 nil nil nil 519 nil nil nil 5920 3570 138 144 34 3 3154 3650 8 'Categories' 2642 0 nil 2674 3 1 2640 8 'doIt' 8 '[MethodCategory icon]
' 8 #[31 105 45 159 106] 3778 #MethodCategory ##(Core.MethodCategory) ##(Smalltalk) 1 #icon 6080 7 1 nil 21481 410 ##(UI.TreeView) 34 27 nil 410 ##(UI.SlidingCardTray) 34 22 nil 5920 34 2 8 1140850688 131073 6208 nil nil nil 7 nil nil nil 6208 5984 170 192 34 6 410 ##(UI.ListView) 34 45 nil 6208 34 2 8 1140936777 1 6304 4562 138 144 1072 nil 4640 720 nil 29 461638 4 ##(UI.Menu) nil true 34 7 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #browseSelectorsInProtocol 8 '&Selectors' 1 1 nil nil nil 6450 1 6482 #toggleProtocolReadOnly 8 '&Read Only' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 6450 1 6482 #addMethodProtocol 8 '&Add…' 1 1 nil nil nil 6402 nil true 34 2 6450 1 6482 #removeMethodProtocol 8 'Protocol' 1 1 nil nil nil 6450 1 6482 #removeMethodsInProtocol 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 6450 1 6482 #renameMethodProtocol 8 'Rename…' 1 1 nil nil nil 6450 1 6482 #browseMethodProtocol 8 'Browse' 1 1 nil nil nil 8 'Protocols' nil 134217729 nil nil nil nil nil nil nil 6304 nil 8 1886148704 2562 #name 8 #() ##(UI.IconicListAbstract) 4688 nil nil 2642 0 nil 2674 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 6960 7 257 nil 674 65 65 nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 'Protocols' 439 #left 2562 #name 8 #() 2562 #<= 8 #() nil nil 6304 nil 3 nil 2642 0 nil 2674 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 7200 7 257 nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 882 138 144 34 3 946 #createAt:extent: 34 2 674 1 37 674 447 343 6304 946 #contextMenu: 34 1 6416 6304 946 #text: 34 1 8 'Protocols' 6304 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 223 0 0 0 189 0 0 0] 8 #() 1088 nil 35 8 'protocols' 6176 8 'categories' 410 ##(UI.ListView) 34 45 nil 6208 34 2 8 1140920395 1 7568 4562 138 144 1072 nil 4640 720 nil 13 6402 nil true 34 10 6450 2097153 6482 #browseInstVarReferences 8 'Browse &References' 1 1 nil nil nil 6578 4097 6450 1 6482 #addInstanceVariable 8 '&Add…' 1 1 nil nil nil 6450 1 6482 #removeInstanceVariables 8 'Remo&ve' 1 1 nil nil nil 6450 1 6482 #renameInstanceVariable 8 'Re&name' 1 1 nil nil nil 6578 4097 6450 1 6482 #pushDownInstanceVariables 8 'Push &Down' 1 1 nil nil nil 6450 1 6482 #createAccessors 8 '&Create Accessors' 1 1 nil nil nil 6450 1 6482 #abstractInstanceVariables 8 'Ab&stract' 1 1 nil nil nil 6450 1 6482 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 7568 nil 8 1886148704 2562 #value 8 #() 2642 0 nil 2674 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] #key #icon #imageIndex 8160 7 257 nil 4688 nil 2642 0 nil 2674 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] #key #name 8 '.' #, 8240 7 257 nil nil 674 65 65 nil nil 138 144 34 1 7090 8 '' 201 #left ##(UI.BasicListAbstract) 2562 #<= 8 #() nil nil 7568 nil 1 nil nil #list 7280 nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 674 1 37 674 447 343 7568 946 #contextMenu: 34 1 7664 7568 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 223 0 0 0 189 0 0 0] 8 #() 1088 nil 35 8 'variables' nil 410 ##(UI.TabViewXP) 34 28 nil 5920 34 2 8 1140916864 1 8656 4562 138 144 34 3 6048 3650 8 'Protocols' 2642 0 nil 2674 6 1 16 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 3778 #CardLabel 3648 ##(Smalltalk) 1 8784 3778 #MethodProtocol ##(Kernel.MethodProtocol) ##(Smalltalk) 1 #icon #text:iconBlock: 8800 11 1 nil 21487 3650 8 'Variables' nil 21491 nil 4640 nil nil 1 nil nil nil 8656 nil 8 1885916928 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 4688 nil nil nil nil nil #smallIcons nil nil nil nil nil 882 138 144 34 3 946 #createAt:extent: 34 2 674 1 1 674 559 395 8656 946 #setSingleSelection: 8 #(1) 8656 946 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8656 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 23 1 0 0 197 0 0 0] 8 #() 1088 nil 27 nil 5920 674 33 33 1246790 1 ##(UI.ButtonInteractor) 6208 nil 1 1180166 ##(Graphics.Rectangle) 674 411 3 674 443 35 nil 6482 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 105 9 674 447 379 6208 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 52 0 0 0 4 0 0 0 19 1 0 0 193 0 0 0] 34 3 6176 6304 7568 1088 nil 27 34 2 8 1140916771 1 6176 787526 3 ##(UI.TreeModel) nil 4640 721670 ##(UI.TreeNode) nil nil nil 170 192 1072 720 nil 31 6402 nil true 34 4 6450 1 6482 #addMethodCategory 8 '&Add…' 1 1 nil nil nil 6402 nil true 34 2 6450 1 6482 #removeMethodCategory 8 'Category' 1 1 nil nil nil 6450 1 6482 #removeMethodsInCategory 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 6450 1 6482 #renameMethodCategory 8 'Rename…' 1 1 nil nil nil 6450 1 6482 #browseMethodCategory 8 'Browse' 1 1 nil nil nil 8 'Categories' nil 134217729 nil nil nil nil nil nil nil 6176 nil 8 1885992864 2562 #localName 8 #() ##(UI.IconicListAbstract) 4688 nil nil 2642 0 nil 2674 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawCategoryTree: 9984 7 257 nil nil nil 170 176 1072 nil #noIcons 1 170 192 1072 882 138 144 34 2 946 #createAt:extent: 34 2 674 1 37 674 447 343 6176 946 #contextMenu: 34 1 9600 6176 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 223 0 0 0 189 0 0 0] 8 #() 1088 nil 27 3154 8768 6304 3154 8912 7568 6176 nil nil nil 170 192 34 2 6208 8 'filters' nil 8656 6208 674 201 201 401 1 524319 nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 569 1 674 559 395 5920 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 1 0 0 0 0 0 0 51 2 0 0 197 0 0 0] 34 2 6208 8656 1088 nil 27 8 'filtersSlidey' 410 ##(UI.ReferenceView) 34 14 nil 5264 34 2 8 1140850688 131073 10560 nil nil nil 31 6402 nil true 34 17 6450 1 6482 #findClass 8 'Find…' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'FindClass.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 6402 nil true 34 10 6450 1 6482 #browseClassPackage 8 'Package <1d>' 1 1 10706 nil true 10752 8 'Package.ico' 10800 nil nil 6578 4097 6450 2097153 6482 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 6402 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 6578 4097 6450 1 6482 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 6450 1 6482 #browseMethodHistoryForClass 8 'Method &History' 1 1 nil nil nil 6578 4097 6450 1 6482 #browsePublishedEvents 8 'Published &events' 1 1 nil nil nil 6450 1 6482 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 6578 4097 6450 1 6482 #newClass 8 '&New…' 1 1 10706 nil true 10752 8 'NewClass.ico' 10800 nil nil 6450 1 6482 #deleteClassHierarchy 8 '&Delete' 1 1 10706 nil true 10752 8 'EditClear.ico' 10800 nil nil 6402 nil true 34 18 6450 1 6482 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 6450 2097153 6482 #renameClass 8 'Re&name…' 1 1 nil nil nil 6578 4097 6450 1 6482 #addInstanceVariable 8 'Add <1s>&Instance Variable…' 1 1 nil nil nil 6450 1 6482 #addClassVariable 8 'Add &Class Variable…' 1 1 nil nil nil 6402 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 6402 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 6578 4097 6402 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 6402 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 6578 4097 6402 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 6402 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 6402 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 6578 4097 6450 1 6482 #convertToSibling 8 'Con&vert to Sibling…' 1 1 nil nil nil 6578 4097 6450 1 6482 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 10706 nil true 10752 8 'Refactoring.ico' 10800 nil nil nil nil 6578 4097 6450 1 6482 #createInstanceVariableAccessors 8 'Create &Accessors…' 1 1 nil nil nil 6450 1 6482 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 6578 4097 6450 1 6482 #fileInClass 8 'File &In…' 1 1 nil nil nil 6450 1 6482 #fileOutClass 8 'File &Out…' 1 1 nil nil nil 6578 4097 6450 1 6482 #classPackage 8 '&Package…' 1 1 10706 nil true 10752 8 'Package.ico' 10800 nil nil 6450 1 6482 #categorizeClass 8 '&Category…' 1 1 nil nil nil 6578 4097 6402 nil true 34 4 6450 1 6482 #newView 8 '&New…' 1 1 nil nil nil 6578 4097 6402 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 nil nil nil nil nil 6402 nil true 8 #() 8 '&Show' #viewsShowMenu 1 nil nil nil nil nil 8 '&Views' #viewsMenu 1 10706 nil true 10752 8 'View.ico' 10800 nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 10560 850 ##(Tools.ClassListSelector) #resource_Default_view nil 882 138 144 34 2 946 #createAt:extent: 34 2 674 1 1 674 559 395 10560 946 #contextMenu: 34 1 10624 10560 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 23 1 0 0 197 0 0 0] 1072 1088 nil 27 8 'classes' nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 1 674 1699 395 5264 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 81 3 0 0 197 0 0 0] 34 5 10560 5392 5920 5648 410 ##(UI.ContainerView) 34 15 nil 5264 34 2 8 1140850688 131073 13264 nil nil nil 7 nil nil nil 13264 498 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 13264 34 2 8 1140850688 131073 13344 nil nil nil 535 nil nil nil 13344 2130 11 1 1 170 192 34 4 410 ##(UI.RadioButton) 34 16 nil 13344 34 2 8 1141055497 1 13456 918598 2 ##(UI.ValueHolder) nil nil 1704454 ##(Core.PluggableSearchPolicy) 2562 #= 8 #() 2562 #hash 8 #() false nil nil 7 nil nil nil 13456 nil 8 1886213424 1049094 ##(UI.NullConverter) nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 674 161 1 674 111 51 13456 946 #text: 34 1 8 'C&lass' 13456 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 0 0 0 0 135 0 0 0 25 0 0 0] 8 #() 1088 nil 27 8 'classMode' 410 ##(UI.RadioButton) 34 16 nil 13344 34 2 8 1141055497 1 13920 13522 nil nil 13554 2562 #= 8 #() 2562 #hash 8 #() false nil nil 7 nil nil nil 13920 nil 8 1886213424 13666 nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 674 21 1 674 131 51 13920 946 #text: 34 1 8 'In&stance' 13920 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 75 0 0 0 25 0 0 0] 8 #() 1088 nil 27 8 'instanceMode' 9234 674 21 1 674 1 1 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 345 674 563 51 13344 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 172 0 0 0 25 1 0 0 197 0 0 0] 34 2 13920 13456 1088 nil 27 nil nil 410 ##(UI.ReferenceView) 34 14 nil 13264 34 2 8 1140850688 131073 14544 nil nil nil 31 nil nil nil 14544 850 ##(Tools.MethodBrowser) #resource_Class_browser_method_list nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 1 674 563 345 14544 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 25 1 0 0 172 0 0 0] 1072 1088 nil 27 170 192 34 4 14544 8 'methods' 13344 8 'mode' nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1137 1 674 563 395 13264 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 56 2 0 0 0 0 0 0 81 3 0 0 197 0 0 0] 34 2 13344 14544 1088 nil 27 1088 nil 27 3184 3504 1088 nil 27 170 192 34 4 2320 8 'statusbar' 528 8 'toolbar' nil 658246 4 ##(UI.MenuBar) nil true 34 9 6402 nil true 34 10 6450 1 6482 #fileNew 8 '&New Workspace' 9373 1 10706 nil true 10752 8 'NewWorkspace.ico' 10800 nil nil 6450 1 6482 #fileOpen 8 '&Open Workspace…' 9375 1 10706 nil true 10752 8 'OpenWorkspace.ico' 10800 nil nil 6450 1 6482 #fileFileIn 8 '&File In…' 1 1 10706 nil true 10752 8 'FileIn.ico' 10800 nil nil 6578 4097 6450 1 6482 #browseExecutableManifest 8 'Open &Executable Manifest…' 1 1 10706 nil true 10752 8 'FileOpen.ico' 10800 nil nil 6578 4097 6450 1 6482 #saveImage 8 'Sa&ve Image' 1 1 10706 nil true 10752 8 'Snapshot.ico' 10800 nil nil 6450 1 6482 #smalltalkExit 8 'E&xit Dolphin' 1 1 10706 nil true 10752 8 'PowerSwitch.ico' 10800 nil nil 6578 4097 6450 1 6482 #exit 8 '&Close' 17639 1 1378630 2 ##(Graphics.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 51405 nil nil 6402 nil true 34 13 6450 1 6482 #undo 8 '&Undo' 9397 1 10706 nil true 10752 8 'EditUndo.ico' 10800 nil nil 6578 4097 6450 1 6482 #cutSelection 8 'Cu&t' 9393 1 10706 nil true 10752 8 'EditCut.ico' 10800 nil nil 6450 1 6482 #copySelection 8 '&Copy' 9351 1 10706 nil true 10752 8 'EditCopy.ico' 10800 nil nil 6450 1 6482 #pasteClipboard 8 '&Paste' 9389 1 10706 nil true 10752 8 'EditPaste.ico' 10800 nil nil 6450 1 6482 #editDelete 8 '&Delete' 1 1 10706 nil true 10752 8 'EditClear.ico' 10800 nil nil 6402 nil true 34 2 6450 1 6482 #reformatSource 8 '&Source' 9391 1 nil nil nil 6450 1 6482 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 51421 nil nil 6578 4097 6450 1 6482 #selectAll 8 'Select &All' 9347 1 nil nil nil 6578 4097 6450 1 6482 #editFind 8 '&Find…' 9357 1 10706 nil true 10752 47 983302 ##(OS.ShellLibrary) nil nil 6450 1 6482 #findNext 8 'Find &Next' 1253 1 10706 nil true 10752 8 'FindNext.ico' 10800 nil nil 6450 1 6482 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 51431 nil nil 6402 nil true 34 15 6450 1 6482 #browseIt 8 '&Browse It' 9349 1 10706 nil true 10752 8 'ClassBrowserShell.ico' 10800 nil nil 6450 1 6482 #displayIt 8 '&Display It' 9353 1 10706 nil true 10752 8 'DisplayIt.ico' 10800 nil nil 6450 1 6482 #printIt 8 '&Print It' 9377 1 10706 nil true 10752 8 'PrintIt.ico' 10800 nil nil 6450 1 6482 #evaluateIt 8 '&Evaluate It' 9355 1 10706 nil true 10752 8 'EvaluateIt.ico' 10800 nil nil 6450 1 6482 #inspectIt 8 '&Inspect It' 9363 1 10706 nil true 10752 8 'InspectIt.ico' 10800 nil nil 6450 1 6482 #debugIt 8 'Deb&ug It' 1269 1 10706 nil true 10752 8 'Debugger.ico' 10800 nil nil 6450 1 6482 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 6578 4097 6450 1 6482 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 6450 1 6482 #browseReferences 8 '&References' 5367 1 nil nil nil 6578 4097 6450 2097153 6482 #accept 8 '&Accept' 9383 1 nil nil nil 6450 1 6482 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 6578 4097 6402 nil true 34 13 6450 1 6482 #renameVariable 8 'Re&name <1d>…' 1 1 10706 nil true 10752 8 'Rename.ico' 10800 nil nil 6578 4097 6450 1 6482 #extractToTemporary 8 'Extract to &Temporary…' 9385 1 nil nil nil 6450 1 6482 #extractMethod 8 'E&xtract Method…' 9371 1 nil nil nil 6450 1 6482 #extractToComponent 8 'Extract to &Component…' 1 1 nil nil nil 6450 1 6482 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 6578 4097 6450 1 6482 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 6450 1 6482 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 6450 1 6482 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 6578 4097 6450 1 6482 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 6450 1 6482 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 10706 nil true 10752 8 'Refactoring.ico' 10800 nil 51475 nil nil 8 '&Workspace' nil 134217729 nil nil 51477 nil nil 6402 nil true 34 17 6450 2097153 6482 #findClass 8 'Find…' 1 1 10706 nil true 10752 8 'FindClass.ico' 10800 nil nil 6402 nil true 34 10 6450 1 6482 #browseClassPackage 8 'Package <1d>' 1 1 10706 nil true 10752 8 'Package.ico' 10800 nil nil 6578 4097 6450 2097153 6482 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 6402 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil 51485 nil nil 6578 4097 6450 1 6482 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 6450 1 6482 #browseMethodHistoryForClass 8 'Method &History' 1 1 10706 nil true 10752 8 'MethodHistory.ico' 10800 nil nil 6578 4097 6450 1 6482 #browsePublishedEvents 8 'Published &events' 1 1 10706 nil true 10752 8 'Event.ico' 10800 nil nil 6450 1 6482 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil 51495 nil nil 6578 4097 6450 1 6482 #newClass 8 '&New…' 1 1 10706 nil true 10752 8 'NewClass.ico' 10800 nil nil 6450 1 6482 #deleteClassHierarchy 8 '&Delete' 1 1 10706 nil true 10752 8 'EditClear.ico' 10800 nil nil 6402 nil true 34 19 6450 1 6482 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 6450 2097153 6482 #renameClass 8 'Re&name…' 1 1 10706 nil true 10752 8 'Rename.ico' 10800 nil nil 6450 1 6482 #copyClass 8 'Cl&one…' 1 1 nil nil nil 6578 4097 6450 1 6482 #addInstanceVariable 8 'Add <1s>&Instance Variable…' 1 1 nil nil nil 6450 1 6482 #addClassVariable 8 'Add &Class Variable…' 1 1 nil nil nil 6402 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil 51511 nil nil 6402 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil 51513 nil nil 6578 4097 6402 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil 51515 nil nil 6402 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil 51517 nil nil 6578 4097 6402 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil 51519 nil nil 6402 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil 51521 nil nil 6402 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil 51523 nil nil 6578 4097 6450 1 6482 #convertToSibling 8 'Con&vert to Sibling…' 1 1 nil nil nil 6578 4097 6450 1 6482 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 10706 nil true 10752 8 'Refactoring.ico' 10800 nil 51529 nil nil 6578 4097 6450 1 6482 #createInstanceVariableAccessors 8 'Create &Accessors…' 1 1 nil nil nil 6450 1 6482 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 6578 4097 6450 1 6482 #fileInClass 8 'File &In…' 1 1 10706 nil true 10752 8 'FileIn.ico' 10800 nil nil 6450 1 6482 #fileOutClass 8 'File &Out…' 1 1 nil nil nil 6578 4097 6450 1 6482 #classPackage 8 '&Package…' 1 1 10706 nil true 10752 8 'Package.ico' 10800 nil nil 6450 1 6482 #categorizeClass 8 '&Category…' 1 1 10706 nil true 10752 8 'Category.ico' 10800 nil nil 6578 4097 6402 nil true 34 4 6450 1 6482 #newView 8 '&New…' 1 1 nil nil nil 6578 4097 6402 nil true 8 #() 8 '&Edit' #viewsEditMenu 134217729 10706 nil true 10752 8 'ViewComposer.ico' 10800 nil 51545 nil nil 6402 nil true 8 #() 8 '&Show' #viewsShowMenu 1 10706 nil true 10752 8 'TestView.ico' 10800 nil 51547 nil nil 8 '&Views' #viewsMenu 134217729 10706 nil true 10752 8 'View.ico' 10800 nil 51549 nil nil 8 '&Class' nil 134217729 nil nil 51551 nil nil 6402 nil true 34 15 6402 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 51553 nil nil 6402 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 51555 nil nil 6402 nil true 34 16 6450 1 6482 #browseReferencesToGlobal 8 'References to Global…' 1 1 nil nil nil 6450 1 6482 #browseContainingText 8 'C&ontaining Text…' 1 1 10706 nil true 10752 8 'SearchText.ico' 10800 nil nil 6450 1 6482 #browseMethodCategory 8 'Cate&gory…' 1 1 10706 nil true 10752 8 'Category.ico' 10800 nil nil 6450 1 6482 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 6450 1 6482 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 6578 4097 6450 1 6482 #browseMethodPackages 8 '&Package <s>' 1 1 10706 nil true 10752 8 'Package.ico' 10800 nil nil 6450 1 6482 #browseMethodClasses 8 'C&lass <s>' 1 1 nil nil nil 6578 4097 6450 1 6482 #browseMethodHistory 8 '&Change History' 1 1 10706 nil true 10752 8 'MethodHistory.ico' 10800 nil nil 6450 1 6482 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 6578 4097 6450 1 6482 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 6450 1 6482 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 6578 4097 6450 1 6482 #browseUnimplemented 8 'All U&nimplemented' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 51581 nil nil 6578 4097 6450 1 6482 #newMethod 8 '&New' 1 1 10706 nil true 10752 8 'NewMethod.ico' 10800 nil nil 6450 1 6482 #removeMethod 8 '&Delete' 1 1 10706 nil true 10752 8 'EditClear.ico' 10800 nil nil 6402 nil true 34 17 6450 1 6482 #renameMethod 8 'Re&name' 1 1 nil nil nil 6450 1 6482 #renameMethodReferences 8 'Rename Re&ferences…' 1 1 nil nil nil 6450 1 6482 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 6578 4097 6450 1 6482 #addParameter 8 'Add &Parameter…' 1 1 nil nil nil 6402 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 51595 nil nil 6402 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 51597 nil nil 6402 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 51599 nil nil 6578 4097 6402 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 51601 nil nil 6402 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 51603 nil nil 6578 4097 6450 1 6482 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 6450 1 6482 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 6450 1 6482 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 6450 1 6482 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 6450 1 6482 #moveMethod 8 'Move to &Component…' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 10706 nil true 10752 8 'Refactoring.ico' 10800 nil 51615 nil nil 6578 4097 6450 1 6482 #methodPackage 8 '&Package…' 1 1 10706 nil true 10752 8 'Package.ico' 10800 nil nil 6402 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 51619 nil nil 6402 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 51621 nil nil 6450 1 6482 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 6578 4097 6450 1 6482 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 6450 1 6482 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 51629 nil nil 6402 nil true 34 7 6450 1 6482 #undoChange 8 '&Undo <1d>' 1 1 10706 nil true 10752 8 'EditUndo.ico' 10800 nil nil 6450 1 6482 #redoChange 8 '&Redo <1d>' 1 1 10706 nil true 10752 8 'EditRedo.ico' 10800 nil nil 6450 1 6482 #clearChangeHistory 8 'Clear Change &History' 1 1 10706 nil true 10752 8 'MethodHistoryErase.ico' 10800 nil nil 6578 4097 6450 1 6482 #historyBack 8 'Back to <1d>' 1 1 10706 nil true 10752 8 'HistoryBack.ico' 10800 nil nil 6450 1 6482 #historyForward 8 'Forward to <1d>' 1 1 10706 nil true 10752 8 'HistoryForward.ico' 10800 nil nil 6450 1 6482 #historyClear 8 'Clear Visit History' 1 1 10706 nil true 10752 8 'HistoryErase.ico' 10800 nil nil 8 'H&istory' nil 134217729 nil nil 51643 nil nil 6402 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 51645 nil nil 6402 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 51647 nil nil 6402 nil true 34 15 6450 1 6482 #helpContents 8 '&Contents' 1025 1 10706 nil true 10752 8 'Help.ico' 10800 nil nil 6450 1 6482 #help 8 'On this &Tool' 1249 1 nil nil nil 6450 1 6482 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 6578 4097 6450 1 6482 #learnSmalltalk 8 'Learn Smalltalk' 1 1 15714 $\x1F393 nil 706 #orchid 706 #white nil nil 1 nil nil nil nil 6578 4097 6450 1 6482 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 6450 1 6482 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 6450 1 6482 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 6578 4097 6450 1 6482 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 10706 nil true 10752 8 '!!APPLICATION' 10800 nil nil 6450 1 6482 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 6450 1 6482 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 6578 4097 6450 1 6482 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 15714 $\x1F42C nil nil 706 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 51671 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 6143 21 674 1731 1011 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 96 15 0 0 3 2 0 0] 34 3 528 3024 2320 1088 nil 27 )!

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
			sysicon tool create
				caption: desc;
				show]
		helpId: self toolsFolderHelpId! !
!Tools.EnvironmentBrowserShell class categoriesFor: #displayOn:!displaying!public! !
!Tools.EnvironmentBrowserShell class categoriesFor: #icon!constants!public! !
!Tools.EnvironmentBrowserShell class categoriesFor: #initialize!initializing!private! !
!Tools.EnvironmentBrowserShell class categoriesFor: #initializeTool!initializing!private! !
!Tools.EnvironmentBrowserShell class categoriesFor: #onEnvironment:!instance creation!public! !
!Tools.EnvironmentBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.EnvironmentBrowserShell class categoriesFor: #toolDescription!constants!public! !
!Tools.EnvironmentBrowserShell class categoriesFor: #toolsFolderHelpId!constants!public! !
!Tools.EnvironmentBrowserShell class categoriesFor: #toolsFolderIcon!constants!public! !

