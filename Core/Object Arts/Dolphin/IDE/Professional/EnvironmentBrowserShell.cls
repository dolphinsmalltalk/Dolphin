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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 196934 1 ##(Smalltalk.RGB) 8 4294967295 0 567 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851532 131073 560 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 28 198 63 1 0 0 204 53 63 1 3 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point) 193 193 0 560 642 672 8 4294903529 234 256 98 10 410 8 ##(Smalltalk.ReferenceView) 98 14 0 560 98 2 8 1140850688 131073 864 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 0 0 864 1180166 ##(Smalltalk.ResourceIdentifier) 576 8 #resource_Class_browser_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 770 355 51 770 307 51 864 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 177 0 0 0 25 0 0 0 74 1 0 0 50 0 0 0] 98 0 770 193 193 0 27 8 'classBrowserTools' 410 880 98 14 0 560 98 2 8 1140850688 131073 1280 0 946 31 0 7 0 0 0 1280 978 576 8 #resource_Image_tools 0 1026 202 208 98 1 1090 1120 98 2 770 1 1 770 63 51 1280 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1232 1248 0 27 8 'imageTools' 410 880 98 14 0 560 98 2 8 1140850688 131073 1552 0 946 31 0 7 0 0 0 1552 978 576 8 #resource_Smalltalk_tools 0 1026 202 208 98 1 1090 1120 98 2 770 63 1 770 991 51 1552 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1232 1248 0 27 8 'smalltalkTools' 410 880 98 14 0 560 98 2 8 1140850688 131073 1824 0 946 31 0 7 0 0 0 1824 978 576 8 #resource_Edit_tools 0 1026 202 208 98 1 1090 1120 98 2 770 1 51 770 247 51 1824 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 1232 1248 0 27 8 'editTools' 410 880 98 14 0 560 98 2 8 1140850688 131073 2096 0 946 31 0 7 0 0 0 2096 978 576 8 #resource_Find_tools 0 1026 202 208 98 1 1090 1120 98 2 770 247 51 770 109 51 2096 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 123 0 0 0 25 0 0 0 177 0 0 0 50 0 0 0] 1232 1248 0 27 8 'findTools' 234 256 1232 202 208 1232 234 240 1232 0 1 0 770 33 33 770 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1026 202 208 98 2 1090 1120 98 2 770 1 1 770 1169 101 560 1090 8 #updateSizePosted 1232 560 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 50 0 0 0] 98 5 1280 1552 1824 2096 864 1248 0 27 410 8 ##(Smalltalk.StatusBar) 98 18 0 416 98 2 8 1140853004 1 2672 0 642 672 0 7 0 690 0 16 722 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 770 193 193 0 2672 0 8 4294905391 234 256 98 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 2672 0 8 ##(Smalltalk.BasicListAbstract) 8 ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'message' 2882 1 501 2672 0 2912 2928 2960 8 'packageOfSelection' 98 2 2992 2896 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2672 0 0 1026 202 208 98 1 1090 1120 98 2 770 1 643 770 1169 41 2672 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 98 0 1248 0 27 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 3232 0 0 0 7 0 0 0 3232 1180166 ##(Smalltalk.ProportionalLayout) 202 8 ##(Smalltalk.Dictionary) 98 1 721414 ##(Smalltalk.Association) 410 8 ##(Smalltalk.Splitter) 98 12 0 3232 98 2 8 1140850688 1 3424 0 642 672 0 519 0 0 0 3424 1026 202 208 98 1 1090 1120 98 2 770 1 267 770 1169 11 3424 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 133 0 0 0 72 2 0 0 138 0 0 0] 98 0 1248 0 27 1 16 234 256 98 2 410 8 ##(Smalltalk.CardContainer) 98 16 0 3232 98 2 8 1140850688 131073 3712 0 917766 ##(Smalltalk.PluggableColor) 1090 8 #toolBackgroundColor 98 0 8 ##(Smalltalk.SmalltalkSystem) 0 7 0 0 0 3712 655878 ##(Smalltalk.CardLayout) 202 208 98 2 3394 590662 1 ##(Smalltalk.CardLabel) 8 'Method Source' 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 7 1 80 8 'doIt' 8 '(CardLabel text: ''Method Source'' iconBlock: [Icon fromId: ''CompiledMethod.ico''])' 8 #[29 30 35 113 31 32 180 106 195 105] 3968 4000 8 ##(Smalltalk.Icon) 8 'CompiledMethod.ico' 8 #fromId: 8 #text:iconBlock: 4032 11 1 0 20981 410 880 98 14 0 3712 98 2 8 1140850688 131073 4192 0 0 0 7 0 0 0 4192 978 8 ##(Smalltalk.MethodWorkspace) 8 #resource_Default_view 0 1026 202 208 98 1 1090 1120 98 2 770 9 55 770 1153 205 4192 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 68 2 0 0 129 0 0 0] 1232 1248 0 27 3394 3970 8 'Class definition' 4018 0 0 4050 7 1 8 ##(Smalltalk.SmallInteger) 8 'doIt' 8 '(CardLabel text: ''Class definition'' iconBlock: [Icon fromId: ''Class.ico''])' 8 #[29 30 35 113 31 32 180 106 195 105] 3968 4480 4128 8 'Class.ico' 4160 4176 4496 11 1 0 21493 410 880 98 14 0 3712 98 2 8 1140916224 131073 4608 0 0 0 21 0 0 0 4608 978 8 ##(Smalltalk.SmalltalkWorkspace) 4288 0 1026 202 208 98 1 1090 1120 98 2 770 9 55 770 1153 205 4608 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 68 2 0 0 129 0 0 0] 1232 1248 0 27 4192 234 256 98 4 4608 8 'definition' 4192 8 'source' 0 410 8 ##(Smalltalk.TabViewXP) 98 28 0 3712 98 2 8 1140916736 1 4912 590662 2 ##(Smalltalk.ListModel) 202 208 98 2 3984 4464 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 3808 0 1 0 0 0 4912 0 8 4294903943 2912 2928 2960 0 0 0 0 0 8 #smallIcons 0 0 0 0 0 1026 202 208 98 3 1090 1120 98 2 770 1 1 770 1169 267 4912 1090 8 #basicSelectionsByIndex: 98 1 98 1 3 4912 1090 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 4912 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 133 0 0 0] 98 0 1248 0 27 1026 202 208 98 1 1090 1120 98 2 770 1 277 770 1169 267 3712 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 138 0 0 0 72 2 0 0 15 1 0 0] 98 3 4192 4608 4912 1248 0 27 8 'cards' 0 1026 202 208 98 1 1090 1120 98 2 770 1 101 770 1169 543 3232 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 72 2 0 0 65 1 0 0] 98 3 410 3248 98 15 0 3232 98 2 8 1140850688 131073 5728 0 642 8 4278190080 0 7 0 0 0 5728 3314 202 3360 98 2 3394 410 3440 98 12 0 5728 98 2 8 1140850688 1 5888 0 642 672 0 519 0 0 0 5888 1026 202 208 98 1 1090 1120 98 2 770 383 1 770 11 267 5888 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 0 0 0 0 0 0 0 196 0 0 0 133 0 0 0] 98 0 1248 0 27 1 3394 410 3440 98 12 0 5728 98 2 8 1140850688 1 6144 0 642 672 0 519 0 0 0 6144 1026 202 208 98 1 1090 1120 98 2 770 775 1 770 11 267 6144 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 131 1 0 0 0 0 0 0 136 1 0 0 133 0 0 0] 98 0 1248 0 27 1 32 234 256 98 4 410 8 ##(Smalltalk.SlideyInneyOuteyThing) 98 23 0 5728 98 2 8 1140850688 131073 6416 0 642 8 4278190080 0 519 0 0 0 6416 3890 202 208 98 3 3394 3970 8 'Categories' 0 21481 410 8 ##(Smalltalk.TreeView) 98 27 0 410 8 ##(Smalltalk.SlidingCardTray) 98 22 0 6416 98 2 8 1140850688 131073 6672 0 482 30915469 0 7 0 0 0 6672 6528 234 256 98 6 410 8 ##(Smalltalk.ListView) 98 30 0 6672 98 2 8 1140936777 1 6800 4994 202 208 1232 0 5072 642 8 4278190080 0 29 265030 4 ##(Smalltalk.Menu) 0 16 98 7 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #browseSelectorsInProtocol 8 '&Selectors' 1 1 0 0 0 6994 1 7026 8 #toggleProtocolReadOnly 8 '&Read Only' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 6994 1 7026 8 #addMethodProtocol 8 '&Add...' 1 1 0 0 0 6946 0 16 98 2 6994 1 7026 8 #removeMethodProtocol 8 'Protocol' 1 1 0 0 0 6994 1 7026 8 #removeMethodsInProtocol 8 'Methods' 1 1 0 0 0 8 'Remove' 0 1 0 0 0 0 0 6994 1 7026 8 #renameMethodProtocol 8 'Rename...' 1 1 0 0 0 6994 1 7026 8 #browseMethodProtocol 8 'Browse' 1 1 0 0 0 8 'Protocols' 0 134217729 0 0 0 0 0 0 0 6800 0 8 4294909021 459270 ##(Smalltalk.Message) 8 #name 98 0 2928 2960 0 0 4018 0 0 4050 5 1 8 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] 8 #view 8 #presenter 8 #parentPresenter 8 #customDrawProtocols: 7648 7 257 0 770 65 65 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Protocols' 227 8 #left 7586 7616 98 0 8 ##(Smalltalk.SortedCollection) 0 0 6800 0 3 0 4018 0 0 4050 5 1 7680 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] 7744 7760 7776 7792 7968 7 257 0 8 #report 1232 0 133217 0 98 1 0 1026 202 208 98 3 1090 1120 98 2 770 1 37 770 235 215 6800 1090 8 #contextMenu: 98 1 6960 6800 1090 8 #text: 98 1 8 'Protocols' 6800 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 117 0 0 0 125 0 0 0] 98 0 1248 0 27 8 'protocols' 6624 8 'categories' 410 6816 98 30 0 6672 98 2 8 1140920395 1 8384 4994 202 208 1232 0 5072 642 8 4278190080 0 13 6946 0 16 98 10 6994 2097153 7026 8 #browseInstVarReferences 8 'Browse &References' 1 1 0 0 0 7154 4097 6994 1 7026 8 #addInstanceVariable 8 '&Add...' 1 1 0 0 0 6994 1 7026 8 #removeInstanceVariables 8 'Remo&ve' 1 1 0 0 0 6994 1 7026 8 #renameInstanceVariable 8 'Re&name' 1 1 0 0 0 7154 4097 6994 1 7026 8 #pushDownInstanceVariables 8 'Push &Down' 1 1 0 0 0 6994 1 7026 8 #createAccessors 8 '&Create Accessors' 1 1 0 0 0 6994 1 7026 8 #abstractInstanceVariables 8 'Ab&stract' 1 1 0 0 0 6994 1 7026 8 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 0 0 0 0 0 134217729 0 0 0 0 0 0 0 8384 0 8 4294909021 7586 8 #value 98 0 4018 0 0 4050 4 1 7680 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] 8 #key 8 #icon 8 #imageIndex 9152 7 257 0 2960 0 4018 0 0 4050 5 1 7680 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] 9232 7616 8 '.' 8 #, 9280 7 257 0 0 770 65 65 0 0 202 208 98 1 7858 8 '' 201 7904 2912 7952 0 0 8384 0 1 0 0 8 #list 1232 0 133217 0 98 1 0 1026 202 208 98 2 1090 1120 98 2 770 1 37 770 235 215 8384 1090 8208 98 1 8512 8384 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 117 0 0 0 125 0 0 0] 98 0 1248 0 27 8 'variables' 0 410 4928 98 28 0 6416 98 2 8 1140916864 1 9712 4994 202 208 98 3 6592 3970 8 'Protocols' 4018 0 0 4050 6 1 80 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 983558 ##(Smalltalk.VariableBinding) 8 #CardLabel 3968 9840 9938 8 #MethodProtocol 8 ##(Smalltalk.MethodProtocol) 9248 4176 9856 11 1 0 21487 3970 8 'Variables' 0 21491 0 5072 6752 0 1 0 0 0 9712 0 8 4294903943 2912 2928 2960 0 0 0 0 0 5104 0 0 0 0 0 1026 202 208 98 3 1090 1120 98 2 770 1 1 770 383 267 9712 1090 5248 98 1 98 1 3 9712 1090 5312 98 2 -1 1 9712 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 191 0 0 0 133 0 0 0] 98 0 1248 0 27 0 6416 770 33 33 1049862 ##(Smalltalk.ButtonInteractor) 6672 0 590342 ##(Smalltalk.Rectangle) 770 199 3 770 231 35 1 7026 8 #togglePin 8 'Pin or Unpin the tray' 1 1 0 0 0 1026 202 208 98 1 1090 1120 98 2 770 141 9 770 235 251 6672 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 4 0 0 0 187 0 0 0 129 0 0 0] 98 3 6624 6800 8384 1248 0 27 98 2 8 1140916771 1 6624 590918 3 ##(Smalltalk.TreeModel) 0 5072 525062 ##(Smalltalk.TreeNode) 0 0 0 234 256 1232 642 8 4278190080 0 31 6946 0 16 98 4 6994 1 7026 8 #addMethodCategory 8 '&Add...' 1 1 0 0 0 6946 0 16 98 2 6994 1 7026 8 #removeMethodCategory 8 'Category' 1 1 0 0 0 6994 1 7026 8 #removeMethodsInCategory 8 'Methods' 1 1 0 0 0 8 'Remove' 0 1 0 0 0 0 0 6994 1 7026 8 #renameMethodCategory 8 'Rename...' 1 1 0 0 0 6994 1 7026 8 #browseMethodCategory 8 'Browse' 1 1 0 0 0 8 'Categories' 0 134217729 0 0 0 0 0 0 0 6624 0 8 4294904491 7586 8 #localName 98 0 2928 2960 0 0 4018 0 0 4050 5 1 7680 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] 7744 7760 7776 8 #customDrawCategoryTree: 11264 7 257 0 0 0 234 240 1232 17 8 #noIcons 1 0 1026 202 208 98 2 1090 1120 98 2 770 1 37 770 235 215 6624 1090 8208 98 1 10784 6624 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 117 0 0 0 125 0 0 0] 98 0 1248 0 27 3394 9824 6800 3394 10032 8384 6624 234 256 98 2 6672 8 'filters' 0 9712 6672 770 201 201 401 1 524319 0 0 1026 202 208 98 1 1090 1120 98 2 770 393 1 770 383 267 6416 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 196 0 0 0 0 0 0 0 131 1 0 0 133 0 0 0] 98 2 6672 9712 1248 0 27 8 'filtersSlidey' 410 880 98 14 0 5728 98 2 8 1140850688 131073 11856 0 3794 1090 3840 98 0 3872 0 31 6946 0 16 98 19 6994 1 7026 8 #findClass 8 'Find...' 1 1 4130 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 6946 0 16 98 9 6994 1 7026 8 #browseClassPackage 8 'Package <1d>' 1 1 4130 0 16 12096 8 'Package.ico' 12144 0 0 7154 4097 6994 2097153 7026 8 #browseClassReferences 8 '&Class References' 1 1 0 0 0 6946 0 16 98 0 8 'Local Re&ferences To' 8 #browseVariablesMenu 134217729 0 0 0 0 0 7154 4097 6994 1 7026 8 #browseChangedMethods 8 'Changed &Methods' 1 1 0 0 0 7154 4097 6994 1 7026 8 #browsePublishedEvents 8 'Published &events' 1 1 0 0 0 6994 1 7026 8 #browsePublishedAspects 8 'Published &aspects' 1 1 0 0 0 8 '&Browse' 8 #browseMenu 134217729 0 0 0 0 0 7154 4097 6994 1 7026 8 #newClass 8 '&New...' 1 1 4130 0 16 12096 8 'NewClass.ico' 12144 0 0 6994 1 7026 8 #deleteClassHierarchy 8 '&Delete' 1 1 4130 0 16 12096 8 'EditClear.ico' 12144 0 0 6946 0 16 98 18 6994 1 7026 8 #safeRemoveClass 8 '&Remove' 1 1 0 0 0 6994 2097153 7026 8 #renameClass 8 'Re&name...' 1 1 0 0 0 7154 4097 6994 1 7026 8656 8 'Add <1s>&Instance Variable...' 1 1 0 0 0 6994 1 7026 8 #addClassVariable 8 'Add &Class Variable...' 1 1 0 0 0 6946 0 16 98 0 8 'Re&move Variable' 8 #removeVariables 134217729 0 0 0 0 0 6946 0 16 98 0 8 'Ren&ame Variable' 8 #renameVariables 134217729 0 0 0 0 0 7154 4097 6946 0 16 98 0 8 'Push &Down' 8 #pushDownVariables 134217729 0 0 0 0 0 6946 0 16 98 0 8 'Pull &Up' 8 #pullUpVariables 134217729 0 0 0 0 0 7154 4097 6946 0 16 98 0 8 'Cr&eate Accessors' 8 #createVariableAccessors 134217729 0 0 0 0 0 6946 0 16 98 0 8 'A&bstract' 8 #abstractVariables 134217729 0 0 0 0 0 6946 0 16 98 0 8 '&Protect/Concrete' 8 #protectVariables 134217729 0 0 0 0 0 7154 4097 6994 1 7026 8 #convertToSibling 8 'Con&vert to Sibling...' 1 1 0 0 0 7154 4097 6994 1 7026 8 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 0 0 0 8 '&Refactorings' 8 #classRefactoringsMenu 134217729 4130 0 16 12096 8 'Refactoring.ico' 12144 0 0 0 0 7154 4097 6994 1 7026 8 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 0 0 0 6994 1 7026 8 #reformatAll 8 'Refor&mat All' 1 1 0 0 0 7154 4097 6994 1 7026 8 #fileInClass 8 'File &In...' 1 1 0 0 0 6994 1 7026 8 #fileOutClass 8 'File &Out...' 1 1 0 0 0 7154 4097 6994 1 7026 8 #classPackage 8 '&Package...' 1 1 4130 0 16 12096 8 'Package.ico' 12144 0 0 6994 1 7026 8 #categorizeClass 8 '&Category...' 1 1 0 0 0 7154 4097 6946 0 16 98 7 6994 1 7026 12496 8 'Browse &Changes in Image' 1 1 0 0 0 6994 1 7026 8 #browseMethodHistoryForClass 8 'Browse Change &History in Image' 1 1 0 0 0 7154 4097 6994 1 7026 8 #browseClassEditions 8 'Browse Class &Editions' 1 1 0 0 0 6994 1 7026 8 #browseAvailableMethods 8 'Browse Deleted Method Editions' 1 1 0 0 0 7154 4097 6994 1 7026 8 #compareClass 8 'Compare Class Edition...' 1 1 0 0 0 8 'C&hanges' 0 134217729 0 0 0 0 0 7154 4097 6946 0 16 98 4 6994 1 7026 8 #newView 8 '&New...' 1 1 0 0 0 7154 4097 6946 0 16 98 0 8 '&Edit' 8 #viewsEditMenu 1 0 0 0 0 0 6946 0 16 98 0 8 '&Show' 8 #viewsShowMenu 1 0 0 0 0 0 8 '&Views' 8 #viewsMenu 1 4130 0 16 12096 8 'View.ico' 12144 0 0 0 0 8 '&Class' 0 134217729 0 0 0 0 0 0 0 11856 978 8 ##(Smalltalk.ClassListSelector) 4288 0 1026 202 208 98 2 1090 1120 98 2 770 1 1 770 383 267 11856 1090 8208 98 1 11968 11856 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 191 0 0 0 133 0 0 0] 1232 1248 0 27 8 'classes' 0 1026 202 208 98 1 1090 1120 98 2 770 1 1 770 1169 267 5728 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 133 0 0 0] 98 5 11856 5888 6416 6144 410 3248 98 15 0 5728 98 2 8 1140850688 131073 15488 0 0 0 7 0 0 0 15488 530 1 1 0 410 576 98 25 0 15488 98 2 8 1140886340 131137 15568 0 642 8 4278190080 0 535 0 0 0 15568 642 8 4278190080 8 4294903529 234 256 98 4 410 8 ##(Smalltalk.RadioButton) 98 16 0 15568 98 2 8 1141055497 1 15744 721990 2 ##(Smalltalk.ValueHolder) 0 0 1376774 ##(Smalltalk.PluggableSearchPolicy) 7586 8 #= 98 0 7586 8 #hash 98 0 32 0 0 7 0 0 0 15744 0 8 4294907745 852486 ##(Smalltalk.NullConverter) 0 0 0 1026 202 208 98 2 1090 1120 98 2 770 161 1 770 111 51 15744 1090 8256 98 1 8 'C&lass' 15744 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 0 0 0 0 135 0 0 0 25 0 0 0] 98 0 1248 0 27 8 'classMode' 410 15760 98 16 0 15568 98 2 8 1141055497 1 16256 15826 0 0 15858 7586 15904 98 0 7586 15952 98 0 32 0 0 7 0 0 0 16256 0 8 4294907745 16002 0 0 0 1026 202 208 98 2 1090 1120 98 2 770 21 1 770 131 51 16256 1090 8256 98 1 8 'In&stance' 16256 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 75 0 0 0 25 0 0 0] 98 0 1248 0 27 8 'instanceMode' 234 256 1232 98 0 234 240 1232 10370 770 21 1 770 1 1 1 0 770 33 31 770 45 45 0 2450 11 1 1 1026 202 208 98 2 1090 1120 98 2 770 1 217 770 385 51 15568 1090 2608 1232 15568 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 108 0 0 0 192 0 0 0 133 0 0 0] 98 2 16256 15744 1248 0 27 0 0 410 880 98 14 0 15488 98 2 8 1140850688 131073 16992 0 0 0 31 0 0 0 16992 978 8 ##(Smalltalk.MethodBrowser) 8 #resource_Class_browser_method_list 0 1026 202 208 98 1 1090 1120 98 2 770 1 1 770 385 217 16992 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 192 0 0 0 108 0 0 0] 1232 1248 0 27 234 256 98 4 15568 8 'mode' 16992 8 'methods' 0 1026 202 208 98 1 1090 1120 98 2 770 785 1 770 385 267 15488 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 0 0 0 0 72 2 0 0 133 0 0 0] 98 2 15568 16992 1248 0 27 1248 0 27 3424 3712 1248 0 27 234 256 98 4 2672 8 'statusbar' 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 9 6946 0 16 98 10 6994 1 7026 8 #fileNew 8 '&New' 9373 1 4130 0 16 12096 8 'FileNew.ico' 12144 0 0 6994 1 7026 8 #fileOpen 8 '&Open...' 9375 1 4130 0 16 12096 8 'FileOpen.ico' 12144 0 0 6994 1 7026 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 7154 4097 6994 1 7026 8 #browseExecutableManifest 8 'Open &Executable Manifest...' 1 1 0 0 0 7154 4097 6994 1 7026 8 #saveImage 8 'Sa&ve Image' 1 1 4130 0 16 12096 8 'Snapshot.ico' 12144 0 0 6994 1 7026 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 4130 0 16 12096 8 'PowerSwitch.ico' 12144 0 0 7154 4097 6994 1 7026 8 #exit 8 '&Close' 17639 1 4130 0 16 12096 8 'CloseWindow.ico' 12144 0 0 8 '&File' 0 134217729 0 0 25863 0 0 6946 0 16 98 13 6994 1 7026 8 #undo 8 '&Undo' 9397 1 4130 0 16 12096 8 'EditUndo.ico' 12144 0 0 7154 4097 6994 1 7026 8 #cutSelection 8 'Cu&t' 9393 1 4130 0 16 12096 8 'EditCut.ico' 12144 0 0 6994 1 7026 8 #copySelection 8 '&Copy' 9351 1 4130 0 16 12096 8 'EditCopy.ico' 12144 0 0 6994 1 7026 8 #pasteClipboard 8 '&Paste' 9389 1 4130 0 16 12096 8 'EditPaste.ico' 12144 0 0 6994 1 7026 8 #editDelete 8 '&Delete' 1 1 4130 0 16 12096 8 'EditClear.ico' 12144 0 0 6946 0 16 98 2 6994 1 7026 8 #reformatSource 8 '&Source' 9391 1 0 0 0 6994 1 7026 8 #reformatComment 8 '&Comment' 9367 1 0 0 0 8 'Ref&ormat' 0 134217729 0 0 25879 0 0 7154 4097 6994 1 7026 8 #selectAll 8 'Select &All' 9347 1 0 0 0 7154 4097 6994 1 7026 8 #editFind 8 '&Find...' 9357 1 4130 0 16 12096 47 786694 ##(Smalltalk.ShellLibrary) 0 0 6994 1 7026 8 #findNext 8 'Find &Next' 1253 1 4130 0 16 12096 8 'FindNext.ico' 12144 0 0 6994 1 7026 8 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 134217729 0 0 25889 0 0 6946 0 16 98 14 6994 1 7026 8 #browseIt 8 '&Browse It' 9349 1 4130 0 16 12096 8 'ClassBrowserShell.ico' 12144 0 0 6994 1 7026 8 #displayIt 8 '&Display It' 9353 1 4130 0 16 12096 8 'DisplayIt.ico' 12144 0 0 6994 1 7026 8 #evaluateIt 8 '&Evaluate It' 9355 1 4130 0 16 12096 8 'EvaluateIt.ico' 12144 0 0 6994 1 7026 8 #inspectIt 8 '&Inspect It' 9363 1 4130 0 16 12096 8 'InspectIt.ico' 12144 0 0 6994 1 7026 8 #debugIt 8 'Deb&ug It' 1269 1 4130 0 16 12096 8 'Debugger.ico' 12144 0 0 6994 1 7026 8 #fileItIn 8 'Fi&le It In' 1 1 0 0 0 7154 4097 6994 1 7026 8 #browseDefinitions 8 'Defi&nitions' 1271 1 0 0 0 6994 1 7026 8 #browseReferences 8 '&References' 5367 1 0 0 0 7154 4097 6994 2097153 7026 8 #accept 8 '&Accept' 9383 1 0 0 0 6994 1 7026 8 #reformatAccept 8 'Refor&mat/Accept' 13479 1 0 0 0 7154 4097 6946 0 16 98 13 6994 1 7026 8 #renameVariable 8 'Re&name <1d>...' 1 1 0 0 0 7154 4097 6994 1 7026 8 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 0 0 0 6994 1 7026 8 #extractMethod 8 'E&xtract Method...' 9371 1 0 0 0 6994 1 7026 8 #extractToComponent 8 'Extract to &Component...' 1 1 0 0 0 6994 1 7026 8 #inlineMessage 8 'Inline &Message' 13467 1 0 0 0 7154 4097 6994 1 7026 8 #inlineTemporary 8 '&Inline Temporary' 13481 1 0 0 0 6994 1 7026 8 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 0 0 0 6994 1 7026 8 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 0 0 0 7154 4097 6994 1 7026 8 #inlineParameter 8 'In&line Parameter' 1 1 0 0 0 6994 1 7026 8 #removeParameter 8 'Remove &Parameter' 1 1 0 0 0 8 'Re&factorings' 8 #codeRefactoringsMenu 134217729 4130 0 16 12096 8 'Refactoring.ico' 12144 0 25931 0 0 8 '&Workspace' 0 134217729 0 0 25933 0 0 6946 0 16 98 20 6994 2097153 7026 12032 8 'Find...' 1 1 4130 0 16 12096 8 'FindClass.ico' 12144 0 0 6946 0 16 98 10 6994 1 7026 12240 8 'Package <1d>' 1 1 4130 0 16 12096 8 'Package.ico' 12144 0 0 7154 4097 6994 2097153 7026 12352 8 '&Class References' 1 1 0 0 0 6946 0 16 98 0 8 'Local Re&ferences To' 12432 134217729 0 0 25941 0 0 7154 4097 6994 1 7026 12496 8 'Changed &Methods' 1 1 0 0 0 6994 1 7026 14496 8 'Method &History' 1 1 0 0 0 7154 4097 6994 1 7026 12576 8 'Published &events' 1 1 0 0 0 6994 1 7026 12640 8 'Published &aspects' 1 1 0 0 0 8 '&Browse' 12688 134217729 0 0 25951 0 0 7154 4097 6994 1 7026 12752 8 '&New...' 1 1 4130 0 16 12096 8 'NewClass.ico' 12144 0 0 6994 1 7026 12848 8 '&Delete' 1 1 4130 0 16 12096 8 'EditClear.ico' 12144 0 0 6946 0 16 98 19 6994 1 7026 12976 8 '&Remove' 1 1 0 0 0 6994 2097153 7026 13040 8 'Re&name...' 1 1 0 0 0 6994 1 7026 8 #copyClass 8 'Cl&one...' 1 1 0 0 0 7154 4097 6994 1 7026 8656 8 'Add <1s>&Instance Variable...' 1 1 0 0 0 6994 1 7026 13168 8 'Add &Class Variable...' 1 1 0 0 0 6946 0 16 98 0 8 'Re&move Variable' 13248 134217729 0 0 25967 0 0 6946 0 16 98 0 8 'Ren&ame Variable' 13312 134217729 0 0 25969 0 0 7154 4097 6946 0 16 98 0 8 'Push &Down' 13392 134217729 0 0 25971 0 0 6946 0 16 98 0 8 'Pull &Up' 13456 134217729 0 0 25973 0 0 7154 4097 6946 0 16 98 0 8 'Cr&eate Accessors' 13536 134217729 0 0 25975 0 0 6946 0 16 98 0 8 'A&bstract' 13600 134217729 0 0 25977 0 0 6946 0 16 98 0 8 '&Protect/Concrete' 13664 134217729 0 0 25979 0 0 7154 4097 6994 1 7026 13728 8 'Con&vert to Sibling...' 1 1 0 0 0 7154 4097 6994 1 7026 13808 8 'Remove Dup&licate Methods' 1 1 0 0 0 8 '&Refactorings' 13856 134217729 4130 0 16 12096 8 'Refactoring.ico' 12144 0 25985 0 0 7154 4097 6994 1 7026 13952 8 'Create &Accessors...' 1 1 0 0 0 6994 1 7026 14016 8 'Refor&mat All' 1 1 0 0 0 7154 4097 6994 1 7026 14096 8 'File &In...' 1 1 0 0 0 6994 1 7026 14160 8 'File &Out...' 1 1 0 0 0 7154 4097 6994 1 7026 14240 8 '&Package...' 1 1 4130 0 16 12096 8 'Package.ico' 12144 0 0 6994 1 7026 14336 8 '&Category...' 1 1 0 0 0 7154 4097 6994 1 7026 14576 8 'Browse &Editions' 1 1 0 0 0 6994 1 7026 14720 8 'Compare with...' 1 1 0 0 0 7154 4097 6946 0 16 98 4 6994 1 7026 14848 8 '&New...' 1 1 0 0 0 7154 4097 6946 0 16 98 0 8 '&Edit' 14944 1 0 0 26005 0 0 6946 0 16 98 0 8 '&Show' 15008 1 0 0 26007 0 0 8 '&Views' 15040 1 4130 0 16 12096 8 'View.ico' 12144 0 26009 0 0 8 '&Class' 0 134217729 0 0 26011 0 0 6946 0 16 98 18 6946 0 16 98 0 8 'De&finitions of' 8 #definitionsMenu 1 0 0 26013 0 0 6946 0 16 98 0 8 '&References to' 8 #referencesMenu 1 0 0 26015 0 0 6946 0 16 98 14 6994 1 7026 8 #browseReferencesToGlobal 8 'References to Global...' 1 1 0 0 0 6994 1 7026 8 #browseContainingText 8 'C&ontaining Text...' 1 1 4130 0 16 12096 8 'SearchText.ico' 12144 0 0 6994 1 7026 11152 8 'Cate&gory...' 1 1 0 0 0 6994 1 7026 8 #browseCompilationFailures 8 'Compilation &Failures' 1 1 0 0 0 6994 1 7026 8 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 0 0 0 7154 4097 6994 1 7026 8 #browseMethodPackages 8 'Package <s>' 1 1 0 0 0 6994 1 7026 8 #browseMethodClasses 8 'Class <s>' 1 1 0 0 0 7154 4097 6994 1 7026 8 #browseMethodHistory 8 '&Change History' 1 1 0 0 0 6994 1 7026 8 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 0 0 0 7154 4097 6994 1 7026 8 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 0 0 0 6994 1 7026 8 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 0 0 0 8 '&Browse other' 0 134217729 0 0 26039 0 0 7154 4097 6994 1 7026 8 #newMethod 8 '&New' 1 1 4130 0 16 12096 8 'NewMethod.ico' 12144 0 0 6994 1 7026 8 #removeMethod 8 '&Delete' 1 1 4130 0 16 12096 8 'EditClear.ico' 12144 0 0 6946 0 16 98 17 6994 1 7026 8 #renameMethod 8 'Re&name' 1 1 0 0 0 6994 1 7026 8 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 0 0 0 6994 1 7026 8 #safeRemoveMethods 8 'Rem&ove' 1 1 0 0 0 7154 4097 6994 1 7026 8 #addParameter 8 'Add &Parameter...' 1 1 0 0 0 6946 0 16 98 0 8 'Remo&ve Parameter' 8 #removeParameterMenu 134217729 0 0 26053 0 0 6946 0 16 98 0 8 'Rena&me Parameter' 8 #renameParameterMenu 134217729 0 0 26055 0 0 6946 0 16 98 0 8 '&Inline Parameter' 8 #inlineParameterMenu 134217729 0 0 26057 0 0 7154 4097 6946 0 16 98 0 8 'Rename &Temporary' 8 #renameTempMenu 134217729 0 0 26059 0 0 6946 0 16 98 0 8 'Convert Temp to Inst. Var.' 8 #convertTempToInstVarMenu 134217729 0 0 26061 0 0 7154 4097 6994 1 7026 8 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 0 0 0 6994 1 7026 8 #pushUpMethods 8 'Push &Up' 9325 1 0 0 0 6994 1 7026 8 #pushDownMethods 8 'Push &Down' 9327 1 0 0 0 6994 1 7026 8 #overrideMethods 8 'Ove&rride <1d>' 1 1 0 0 0 6994 1 7026 8 #moveMethod 8 'Move to &Component...' 1 1 0 0 0 8 'Refactorin&gs' 8 #methodRefactoringsMenu 134217729 4130 0 16 12096 8 'Refactoring.ico' 12144 0 26073 0 0 7154 4097 6994 1 7026 8 #methodPackage 8 '&Package...' 1 1 4130 0 16 12096 8 'Package.ico' 12144 0 0 6946 0 16 98 0 8 'Add to &Category' 8 #addCategoryMenu 134217729 0 0 26077 0 0 6946 0 16 98 0 8 'Re&move from Category' 8 #removeCategoryMenu 134217729 0 0 26079 0 0 6994 1 7026 8 #togglePrivate 8 'Pri&vate' 1 1 0 0 0 7154 4097 6994 1 7026 8 #browseMethodEditions 8 'Browse &Editions' 1 1 0 0 0 6994 1 7026 14640 8 'Browse Available Editions' 1 1 0 0 0 7154 4097 6994 1 7026 8 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 0 0 0 6994 1 7026 8 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 0 0 0 8 '&Method' 0 134217729 0 0 26091 0 0 6946 0 16 98 7 6994 1 7026 8 #undoChange 8 '&Undo <1d>' 1 1 4130 0 16 12096 8 'EditUndo.ico' 12144 0 0 6994 1 7026 8 #redoChange 8 '&Redo <1d>' 1 1 4130 0 16 12096 8 'EditRedo.ico' 12144 0 0 6994 1 7026 8 #clearChangeHistory 8 'Clear Change &History' 1 1 0 0 0 7154 4097 6994 1 7026 8 #historyBack 8 'Back to <1d>' 1 1 4130 0 16 12096 8 'HistoryBack.ico' 12144 0 0 6994 1 7026 8 #historyForward 8 'Forward to <1d>' 1 1 4130 0 16 12096 8 'HistoryForward.ico' 12144 0 0 6994 1 7026 8 #historyClear 8 'Clear Visit History' 1 1 0 0 0 8 'H&istory' 0 134217729 0 0 26105 0 0 6946 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 26107 0 0 6946 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 26109 0 0 6946 0 16 98 15 6994 1 7026 8 #helpContents 8 '&Contents' 1025 1 4130 0 16 12096 49 19184 0 0 6994 1 7026 8 #help 8 'On this &Tool' 1249 1 0 0 0 6994 1 7026 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 7154 4097 6994 1 7026 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 7154 4097 6994 1 7026 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 6994 1 7026 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 6994 1 7026 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 7154 4097 6994 1 7026 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 6994 1 7026 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 6994 1 7026 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 7154 4097 6994 1 7026 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 4130 0 16 12096 8 '!!APPLICATION' 12144 0 0 8 '&Help' 0 134217729 0 0 26133 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1026 202 208 98 2 1090 1120 98 2 770 3839 21 770 1201 801 416 1090 8 #updateMenuBar 1232 416 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 98 3 560 3232 2672 1248 0 27 )!

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

