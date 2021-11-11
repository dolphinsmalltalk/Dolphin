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
!Tools.EnvironmentBrowserShell categoriesForMethods!
browseExecutableManifest!commands!public! !
browseExecutableManifestFile:!commands!public! !
browserEnvironment:!accessing!public! !
browseUnimplemented!commands!public! !
createComponents!initializing!public! !
defaultHelpId!constants!public! !
displayLocalHierarchyOf:!private!updating! !
isLocalHierarchyMode!private!testing! !
isLocalHierarchyMode:!accessing!private! !
isMethodVisible:!private!testing! !
onTipTextRequired:!event handling!private! !
printCaptionForClass:on:!private!updating! !
printCaptionForMethod:on:!private!updating! !
queryCommand:!commands!private! !
resetFor:!commands!public! !
saveStateOn:!private!saved state! !
searchEnvironment!commands!public! !
toggleLocalHierarchy!commands!public! !
!

!Tools.EnvironmentBrowserShell class methodsFor!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Environment Browser'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #toolBackground nil 567 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.Toolbar) 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 28 198 63 1 0 0 204 53 63 1 3 0 20 59 0 0 0 0 247 0 5 86 111 1] 918022 ##(Graphics.Point) 193 193 nil 528 917510 ##(Graphics.Color) #default 8 1821628656 170 192 34 10 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 784 nil nil nil 7 nil nil nil 784 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Toolbar) #resource_Smalltalk_tools nil 1310982 ##(Core.MessageSequence) 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 674 63 1 674 553 51 784 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'smalltalkTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1104 nil nil nil 7 nil nil nil 1104 850 ##(UI.Toolbar) #resource_Search_tools nil 882 34 1 930 #createAt:extent: 34 2 674 615 1 674 437 51 1104 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 1056 1072 nil 27 8 'searchTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1328 nil nil nil 7 nil nil nil 1328 850 ##(UI.Toolbar) #resource_Edit_tools nil 882 34 1 930 #createAt:extent: 34 2 674 1051 1 674 247 51 1328 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 136 2 0 0 25 0 0 0] 1056 1072 nil 27 8 'editTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1552 nil nil nil 7 nil nil nil 1552 850 ##(UI.Toolbar) #resource_Class_browser_tools nil 882 34 1 930 #createAt:extent: 34 2 674 1297 1 674 353 51 1552 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 2 0 0 0 0 0 0 56 3 0 0 25 0 0 0] 1056 1072 nil 27 8 'classBrowserTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1776 nil nil nil 7 nil nil nil 1776 850 ##(UI.Toolbar) #resource_Image_tools nil 882 34 1 930 #createAt:extent: 34 2 674 1 1 674 63 51 1776 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1056 1072 nil 27 8 'imageTools' nil nil nil 170 192 1056 138 144 1056 nil nil 1 nil 674 33 33 nil nil 852806 1 ##(UI.FlowLayout) 1 1 1 882 34 1 930 #createAt:extent: 34 2 674 1 1 674 1699 51 528 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 81 3 0 0 25 0 0 0] 34 5 1776 784 1104 1328 1552 1072 nil 29 410 ##(UI.StatusBar) 34 21 nil 416 34 2 8 1140853004 1 2224 nil nil nil 7 nil 594 nil true 626 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 674 193 193 nil 2224 nil 8 1821181968 170 192 34 6 1050438 1 ##(UI.StatusBarItem) 8193 501 2224 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'packageOfSelection' 2402 8193 -1 2224 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'message' 2402 8705 351 2224 nil 786950 ##(Core.Message) #displayString 8 #() 2498 #iconImageIndex 8 #() 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:namespace | ''Method namespace: '', namespace fullName]' 8 #[32 105 29 226 1 178 106] 8 'Method namespace: ' #fullName #, 2592 7 257 nil 8 'namespace' nil nil nil 34 3 2416 2448 2480 1311814 1 ##(UI.StatusBarNullItem) 8705 1 2224 nil nil 882 34 1 930 #createAt:extent: 34 2 674 1 849 674 1699 45 2224 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 1 0 0 81 3 0 0 190 1 0 0] 8 #() 1072 nil 29 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2912 nil nil nil 7 nil nil nil 2912 1376774 ##(UI.ProportionalLayout) 138 ##(Core.Dictionary) 34 1 1049094 ##(Core.Association) 410 ##(UI.Splitter) 34 12 nil 2912 34 2 8 1140850688 1 3072 nil nil nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 3072 nil 1 #left nil nil nil 674 1 1 674 9 9 nil 3168 nil 882 34 1 930 #createAt:extent: 34 2 674 1 395 674 1699 11 3072 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 197 0 0 0 81 3 0 0 202 0 0 0] 8 #() 1072 nil 27 1 true 170 192 34 2 410 ##(UI.CardContainer) 34 16 nil 2912 34 2 8 1140850688 131073 3376 nil nil nil 7 nil nil nil 3376 853318 1 ##(UI.CardLayout) 138 144 34 2 3042 787270 1 ##(UI.CardLabel) 8 'Method Source' 2578 0 nil 2610 7 1 3520 8 'doIt' 8 '(CardLabel text: ''Method Source'' iconBlock: [Icon fromId: ''MethodSource.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 1442886 2 ##(Kernel.VariableBinding) #CardLabel 3520 ##(Smalltalk) 1 3552 3650 #Icon ##(Graphics.Icon) ##(Smalltalk) 1 8 'MethodSource.ico' #fromId: #text:iconBlock: 3568 11 1 nil nil 410 ##(UI.ReferenceView) 34 14 nil 3376 34 2 8 1140850688 131073 3712 nil nil nil 5 nil nil nil 3712 850 ##(Tools.MethodWorkspace) #resource_Default_view nil 882 34 1 930 #createAt:extent: 34 2 674 9 53 674 1683 335 3712 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 77 3 0 0 193 0 0 0] 1056 1072 nil 27 3042 3522 8 'Class definition' 2578 0 nil 2610 7 1 3520 8 'doIt' 8 '(CardLabel text: ''Class definition'' iconBlock: [Icon fromId: ''ClassDefinition.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 3664 3952 3680 8 'ClassDefinition.ico' #fromId: #text:iconBlock: 3968 11 1 nil nil 410 ##(UI.ReferenceView) 34 14 nil 3376 34 2 8 1140916224 131073 4064 nil 720 nil 23 nil nil nil 4064 850 ##(Tools.SmalltalkWorkspace) #resource_Default_view nil 882 34 1 930 #createAt:extent: 34 2 674 9 53 674 1683 335 4064 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 77 3 0 0 193 0 0 0] 1056 1072 nil 27 4064 nil nil nil 170 192 34 4 4064 8 'definition' 3712 8 'source' nil 410 ##(UI.TabViewXP) 34 28 nil 3376 34 2 8 1140916736 1 4336 787270 2 ##(UI.ListModel) 138 144 34 2 3536 3936 nil 1769478 ##(Kernel.IdentitySearchPolicy) nil nil 1 nil nil nil 4336 nil 8 1821416304 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil #smallIcons nil nil nil nil nil 882 34 3 930 #createAt:extent: 34 2 674 1 1 674 1699 395 4336 930 #setSingleSelection: 8 #(2) 4336 930 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4336 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 81 3 0 0 197 0 0 0] 8 #() 1072 nil 27 882 34 1 930 #createAt:extent: 34 2 674 1 405 674 1699 395 3376 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 202 0 0 0 81 3 0 0 143 1 0 0] 34 3 3712 4064 4336 1072 nil 27 8 'cards' nil 882 34 1 930 #createAt:extent: 34 2 674 1 51 674 1699 799 2912 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 81 3 0 0 168 1 0 0] 34 3 410 ##(UI.ContainerView) 34 15 nil 2912 34 2 8 1140850688 131073 5056 nil nil nil 7 nil nil nil 5056 2978 138 ##(Core.Dictionary) 34 2 3042 410 ##(UI.Splitter) 34 12 nil 5056 34 2 8 1140850688 1 5184 nil nil nil 519 nil nil nil 3138 5184 nil 1 #left nil nil nil 3168 3184 nil 3168 nil 882 34 1 930 #createAt:extent: 34 2 674 1127 1 674 11 395 5184 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 2 0 0 0 0 0 0 56 2 0 0 197 0 0 0] 8 #() 1072 nil 27 1 3042 410 ##(UI.Splitter) 34 12 nil 5056 34 2 8 1140850688 1 5424 nil nil nil 519 nil nil nil 3138 5424 nil 1 #left nil nil nil 3168 3184 nil 3168 nil 882 34 1 930 #createAt:extent: 34 2 674 559 1 674 11 395 5424 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 1 0 0 0 0 0 0 28 1 0 0 197 0 0 0] 8 #() 1072 nil 27 1 false 170 192 34 4 410 ##(UI.SlideyInneyOuteyThing) 34 23 nil 5056 34 2 8 1140850688 131073 5680 nil nil nil 519 nil nil nil 5680 3442 138 144 34 3 3042 3522 8 'Categories' 2578 0 nil 2610 3 1 2576 8 'doIt' 8 '[MethodCategory icon]
' 8 #[31 105 45 159 106] 3650 #MethodCategory ##(Core.MethodCategory) ##(Smalltalk) 1 #icon 5840 7 1 nil 21481 410 ##(UI.TreeView) 34 27 nil 410 ##(UI.SlidingCardTray) 34 22 nil 5680 34 2 8 1140850688 131073 5968 nil nil nil 7 nil nil nil 5968 5744 170 192 34 6 410 ##(UI.ListView) 34 45 nil 5968 34 2 8 1140920395 1 6064 4402 138 144 1056 nil 4480 720 nil 13 461638 4 ##(UI.Menu) nil true 34 10 1180742 2 ##(UI.CommandMenuItem) 2097153 1377606 4 ##(UI.CommandDescription) #browseInstVarReferences 8 'Browse &References' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 6210 1 6242 #addInstanceVariable 8 '&Add…' 1 1 nil nil nil 6210 1 6242 #removeInstanceVariables 8 'Remo&ve' 1 1 nil nil nil 6210 1 6242 #renameInstanceVariable 8 'Re&name' 1 1 nil nil nil 6290 4097 6210 1 6242 #pushDownInstanceVariables 8 'Push &Down' 1 1 nil nil nil 6210 1 6242 #createAccessors 8 '&Create Accessors' 1 1 nil nil nil 6210 1 6242 #abstractInstanceVariables 8 'Ab&stract' 1 1 nil nil nil 6210 1 6242 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 6064 nil 8 1821602992 2498 #value 8 #() 2578 0 nil 2610 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] #key #icon #imageIndex 6720 7 257 nil 4528 nil 2578 0 nil 2610 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] #key #name 8 '.' #, 6800 7 257 nil nil 674 65 65 nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 '' 201 #left ##(UI.BasicListAbstract) 2498 #<= 8 #() nil nil 6064 nil 1 nil nil #list 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 882 34 2 930 #createAt:extent: 34 2 674 1 37 674 447 343 6064 930 #contextMenu: 34 1 6176 6064 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 223 0 0 0 189 0 0 0] 8 #() 1072 nil 35 8 'variables' 410 ##(UI.ListView) 34 45 nil 5968 34 2 8 1140936777 1 7232 4402 138 144 1056 nil 4480 720 nil 29 6162 nil true 34 7 6210 1 6242 #browseSelectorsInProtocol 8 '&Selectors' 1 1 nil nil nil 6210 1 6242 #toggleProtocolReadOnly 8 '&Read Only' 1 1 nil nil nil 6290 4097 6210 1 6242 #addMethodProtocol 8 '&Add…' 1 1 nil nil nil 6162 nil true 34 2 6210 1 6242 #removeMethodProtocol 8 'Protocol' 1 1 nil nil nil 6210 1 6242 #removeMethodsInProtocol 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 6210 1 6242 #renameMethodProtocol 8 'Rename…' 1 1 nil nil nil 6210 1 6242 #browseMethodProtocol 8 'Browse' 1 1 nil nil nil 8 'Protocols' nil 134217729 nil nil nil nil nil nil nil 7232 nil 8 1821602992 2498 #name 8 #() ##(UI.IconicListAbstract) 4528 nil nil 2578 0 nil 2610 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 7824 7 257 nil 674 65 65 nil nil 138 144 34 1 6946 8 'Protocols' 447 #left 2498 #name 8 #() 2498 #<= 8 #() nil nil 7232 nil 3 nil 2578 0 nil 2610 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 8048 7 257 nil #report 7024 nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 882 34 3 930 #createAt:extent: 34 2 674 1 37 674 447 343 7232 930 #contextMenu: 34 1 7328 7232 930 #text: 34 1 8 'Protocols' 7232 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 223 0 0 0 189 0 0 0] 8 #() 1072 nil 35 8 'protocols' 5936 8 'categories' nil 410 ##(UI.TabViewXP) 34 28 nil 5680 34 2 8 1140916864 1 8384 4402 138 144 34 3 5808 3522 8 'Protocols' 2578 0 nil 2610 6 1 16 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 3650 #CardLabel 3520 ##(Smalltalk) 1 8512 3650 #MethodProtocol ##(Kernel.MethodProtocol) ##(Smalltalk) 1 #icon #text:iconBlock: 8528 11 1 nil 21487 3522 8 'Variables' nil 21491 nil 4480 nil nil 1 nil nil nil 8384 nil 8 1821416304 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 4528 nil nil nil nil nil #smallIcons nil nil nil nil nil 882 34 3 930 #createAt:extent: 34 2 674 1 1 674 559 395 8384 930 #setSingleSelection: 8 #(1) 8384 930 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8384 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 23 1 0 0 197 0 0 0] 8 #() 1072 nil 27 nil 5680 674 33 33 1246790 1 ##(UI.ButtonInteractor) 5968 nil 1 1180166 ##(Graphics.Rectangle) 674 411 3 674 443 35 nil 6242 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 882 34 1 930 #createAt:extent: 34 2 674 105 9 674 447 379 5968 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 52 0 0 0 4 0 0 0 19 1 0 0 193 0 0 0] 34 3 5936 7232 6064 1072 nil 27 34 2 8 1140916771 1 5936 787526 3 ##(UI.TreeModel) nil 4480 721670 ##(UI.TreeNode) nil nil nil 170 192 1056 720 nil 31 6162 nil true 34 4 6210 1 6242 #addMethodCategory 8 '&Add…' 1 1 nil nil nil 6162 nil true 34 2 6210 1 6242 #removeMethodCategory 8 'Category' 1 1 nil nil nil 6210 1 6242 #removeMethodsInCategory 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 6210 1 6242 #renameMethodCategory 8 'Rename…' 1 1 nil nil nil 6210 1 6242 #browseMethodCategory 8 'Browse' 1 1 nil nil nil 8 'Categories' nil 134217729 nil nil nil nil nil nil nil 5936 nil 8 1821380560 2498 #localName 8 #() ##(UI.IconicListAbstract) 4528 nil nil 2578 0 nil 2610 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawCategoryTree: 9680 7 257 nil nil nil 170 176 1056 nil #noIcons 1 170 192 1056 882 34 2 930 #createAt:extent: 34 2 674 1 37 674 447 343 5936 930 #contextMenu: 34 1 9296 5936 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 223 0 0 0 189 0 0 0] 8 #() 1072 nil 27 3042 8496 7232 3042 8640 6064 5936 nil nil nil 170 192 34 2 5968 8 'filters' nil 8384 5968 674 201 201 401 1 524319 nil nil 882 34 1 930 #createAt:extent: 34 2 674 569 1 674 559 395 5680 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 1 0 0 0 0 0 0 51 2 0 0 197 0 0 0] 34 2 5968 8384 1072 nil 27 8 'filtersSlidey' 410 ##(UI.ReferenceView) 34 14 nil 5056 34 2 8 1140850688 131073 10224 nil nil nil 31 6162 nil true 34 17 6210 1 6242 #findClass 8 'Find…' 1 1 852806 4 ##(Graphics.Icon) nil true 2819078 ##(Graphics.ImageFromStringResourceInitializer) 8 'FindClass.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr8.dll' nil 65541 nil nil nil 6162 nil true 34 10 6210 1 6242 #browseClassPackage 8 'Package <1d>' 1 1 10370 nil true 10402 8 'Package.ico' 10464 65541 nil nil nil 6290 4097 6210 2097153 6242 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 6162 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 6290 4097 6210 1 6242 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 6210 1 6242 #browseMethodHistoryForClass 8 'Method &History' 1 1 nil nil nil 6290 4097 6210 1 6242 #browsePublishedEvents 8 'Published &events' 1 1 nil nil nil 6210 1 6242 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 6290 4097 6210 1 6242 #newClass 8 '&New…' 1 1 10370 nil true 10402 8 'NewClass.ico' 10464 65541 nil nil nil 6210 1 6242 #removeClass 8 'Re&move' 1 1 10370 nil true 10402 8 'EditClear.ico' 10464 65541 nil nil nil 6162 nil true 34 17 6210 2097153 6242 #renameClass 8 'Re&name…' 1 1 nil nil nil 6290 4097 6210 1 6242 #addInstanceVariable 8 'Add <1s>&Instance Variable…' 1 1 nil nil nil 6210 1 6242 #addClassVariable 8 'Add &Class Variable…' 1 1 nil nil nil 6162 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 6162 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 6290 4097 6162 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 6162 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 6290 4097 6162 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 6162 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 6162 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 6290 4097 6210 1 6242 #convertToSibling 8 'Con&vert to Sibling…' 1 1 nil nil nil 6290 4097 6210 1 6242 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 10370 nil true 10402 8 'Refactoring.ico' 10464 65541 nil nil nil nil nil 6290 4097 6210 1 6242 #createInstanceVariableAccessors 8 'Create &Accessors…' 1 1 nil nil nil 6210 1 6242 #reformatAll 8 'Re&format All' 1 1 nil nil nil 6290 4097 6210 1 6242 #fileInClass 8 'File &In…' 1 1 nil nil nil 6210 1 6242 #fileOutClass 8 'File &Out…' 1 1 nil nil nil 6290 4097 6210 1 6242 #classPackage 8 '&Package…' 1 1 10370 nil true 10402 8 'Package.ico' 10464 65541 nil nil nil 6210 1 6242 #categorizeClass 8 '&Category…' 1 1 nil nil nil 6290 4097 6162 nil true 34 4 6210 1 6242 #newView 8 '&New…' 1 1 nil nil nil 6290 4097 6162 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 nil nil nil nil nil 6162 nil true 8 #() 8 '&Show' #viewsShowMenu 1 nil nil nil nil nil 8 '&Views' #viewsMenu 1 10370 nil true 10402 8 'View.ico' 10464 65541 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 10224 850 ##(Tools.ClassListSelector) #resource_Default_view nil 882 34 2 930 #createAt:extent: 34 2 674 1 1 674 559 395 10224 930 #contextMenu: 34 1 10288 10224 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 23 1 0 0 197 0 0 0] 1056 1072 nil 27 8 'classes' nil 882 34 1 930 #createAt:extent: 34 2 674 1 1 674 1699 395 5056 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 81 3 0 0 197 0 0 0] 34 5 10224 5424 5680 5184 410 ##(UI.ContainerView) 34 15 nil 5056 34 2 8 1140850688 131073 12944 nil nil nil 7 nil nil nil 12944 498 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 12944 34 2 8 1140850688 131073 13024 nil nil nil 535 nil nil nil 13024 2050 11 1 1 170 192 34 4 410 ##(UI.RadioButton) 34 16 nil 13024 34 2 8 1141055497 1 13136 918598 2 ##(UI.ValueHolder) nil nil 1704454 ##(Core.PluggableSearchPolicy) 2498 #= 8 #() 2498 #hash 8 #() false nil nil 7 nil nil nil 13136 nil 8 1821651072 1049094 ##(UI.NullConverter) nil nil nil 882 34 2 930 #createAt:extent: 34 2 674 161 1 674 111 51 13136 930 #text: 34 1 8 'C&lass' 13136 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 0 0 0 0 135 0 0 0 25 0 0 0] 8 #() 1072 nil 27 8 'classMode' 410 ##(UI.RadioButton) 34 16 nil 13024 34 2 8 1141055497 1 13584 13202 nil nil 13234 2498 #= 8 #() 2498 #hash 8 #() false nil nil 7 nil nil nil 13584 nil 8 1821651072 13346 nil nil nil 882 34 2 930 #createAt:extent: 34 2 674 21 1 674 131 51 13584 930 #text: 34 1 8 'In&stance' 13584 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 75 0 0 0 25 0 0 0] 8 #() 1072 nil 27 8 'instanceMode' 8946 674 21 1 674 1 1 882 34 1 930 #createAt:extent: 34 2 674 1 345 674 563 51 13024 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 172 0 0 0 25 1 0 0 197 0 0 0] 34 2 13584 13136 1072 nil 27 nil nil 410 ##(UI.ReferenceView) 34 14 nil 12944 34 2 8 1140850688 131073 14176 nil nil nil 31 nil nil nil 14176 850 ##(Tools.MethodBrowser) #resource_Class_browser_method_list nil 882 34 1 930 #createAt:extent: 34 2 674 1 1 674 563 345 14176 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 25 1 0 0 172 0 0 0] 1056 1072 nil 27 170 192 34 4 13024 8 'mode' 14176 8 'methods' nil 882 34 1 930 #createAt:extent: 34 2 674 1137 1 674 563 395 12944 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 56 2 0 0 0 0 0 0 81 3 0 0 197 0 0 0] 34 2 13024 14176 1072 nil 27 1072 nil 27 3072 3376 1072 nil 27 170 192 34 4 2224 8 'statusbar' 528 8 'toolbar' nil 658246 4 ##(UI.MenuBar) nil true 34 9 6162 nil true 34 10 6210 1 6242 #fileNew 8 '&New Workspace' 9373 1 10370 nil true 10402 8 'NewWorkspace.ico' 10464 65541 nil nil nil 6210 1 6242 #fileOpen 8 '&Open Workspace…' 9375 1 10370 nil true 10402 8 'OpenWorkspace.ico' 10464 65541 nil nil nil 6210 1 6242 #fileFileIn 8 '&File In…' 1 1 10370 nil true 10402 8 'FileIn.ico' 10464 65541 nil nil nil 6290 4097 6210 1 6242 #browseExecutableManifest 8 'Open &Executable Manifest…' 1 1 10370 nil true 10402 8 'FileOpen.ico' 10464 65541 nil nil nil 6290 4097 6210 1 6242 #saveImage 8 'Sa&ve Image' 1 1 10370 nil true 10402 8 'Snapshot.ico' 10464 65541 nil nil nil 6210 1 6242 #smalltalkExit 8 'E&xit Dolphin' 1 1 10370 nil true 10402 8 'PowerSwitch.ico' 10464 65541 nil nil nil 6290 4097 6210 1 6242 #exit 8 '&Close' 17639 1 1378630 2 ##(Graphics.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 10271 nil nil 6162 nil true 34 13 6210 1 6242 #undo 8 '&Undo' 9397 1 10370 nil true 10402 8 'EditUndo.ico' 10464 65541 nil nil nil 6290 4097 6210 1 6242 #cutSelection 8 'Cu&t' 9393 1 10370 nil true 10402 8 'EditCut.ico' 10464 65541 nil nil nil 6210 1 6242 #copySelection 8 '&Copy' 9351 1 10370 nil true 10402 8 'EditCopy.ico' 10464 65541 nil nil nil 6210 1 6242 #pasteClipboard 8 '&Paste' 9389 1 10370 nil true 10402 8 'EditPaste.ico' 10464 65541 nil nil nil 6210 1 6242 #editDelete 8 '&Delete' 1 1 10370 nil true 10402 8 'EditClear.ico' 10464 65541 nil nil nil 6162 nil true 34 2 6210 1 6242 #reformatSource 8 '&Source' 9391 1 nil nil nil 6210 1 6242 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 10287 nil nil 6290 4097 6210 1 6242 #selectAll 8 'Select &All' 9347 1 nil nil nil 6290 4097 6210 1 6242 #editFind 8 '&Find…' 9357 1 10370 nil true 2425862 ##(Graphics.ImageFromResourceInitializer) 47 983302 ##(OS.ShellLibrary) 65541 nil nil nil 6210 1 6242 #findNext 8 'Find &Next' 1253 1 10370 nil true 10402 8 'FindNext.ico' 10464 65541 nil nil nil 6210 1 6242 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 10297 nil nil 6162 nil true 34 15 6210 1 6242 #browseIt 8 '&Browse It' 9349 1 10370 nil true 10402 8 'ClassBrowserShell.ico' 10464 65541 nil nil nil 6210 1 6242 #displayIt 8 '&Display It' 9353 1 10370 nil true 10402 8 'DisplayIt.ico' 10464 65541 nil nil nil 6210 1 6242 #printIt 8 '&Print It' 9377 1 10370 nil true 10402 8 'PrintIt.ico' 10464 65541 nil nil nil 6210 1 6242 #evaluateIt 8 '&Evaluate It' 9355 1 10370 nil true 10402 8 'EvaluateIt.ico' 10464 65541 nil nil nil 6210 1 6242 #inspectIt 8 '&Inspect It' 9363 1 10370 nil true 10402 8 'InspectIt.ico' 10464 65541 nil nil nil 6210 1 6242 #debugIt 8 'Deb&ug It' 1269 1 10370 nil true 10402 8 'Debugger.ico' 10464 65541 nil nil nil 6210 1 6242 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 6290 4097 6210 1 6242 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 6210 1 6242 #browseReferences 8 '&References' 5367 1 nil nil nil 6290 4097 6210 2097153 6242 #accept 8 '&Accept' 9383 1 nil nil nil 6210 1 6242 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 6290 4097 6162 nil true 34 13 6210 1 6242 #renameVariable 8 'Re&name <1d>…' 1 1 10370 nil true 10402 8 'Rename.ico' 10464 65541 nil nil nil 6290 4097 6210 1 6242 #extractToTemporary 8 'Extract to &Temporary…' 9385 1 nil nil nil 6210 1 6242 #extractMethod 8 'E&xtract Method…' 9371 1 nil nil nil 6210 1 6242 #extractToComponent 8 'Extract to &Component…' 1 1 nil nil nil 6210 1 6242 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 6290 4097 6210 1 6242 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 6210 1 6242 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 6210 1 6242 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 6290 4097 6210 1 6242 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 6210 1 6242 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 10370 nil true 10402 8 'Refactoring.ico' 10464 65541 nil nil 10341 nil nil 8 '&Workspace' nil 134217729 nil nil 10343 nil nil 6162 nil true 34 17 6210 2097153 6242 #findClass 8 'Find…' 1 1 10370 nil true 10402 8 'FindClass.ico' 10464 65541 nil nil nil 6162 nil true 34 10 6210 1 6242 #browseClassPackage 8 'Package <1d>' 1 1 10370 nil true 10402 8 'Package.ico' 10464 65541 nil nil nil 6290 4097 6210 2097153 6242 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 6162 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil 10351 nil nil 6290 4097 6210 1 6242 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 6210 1 6242 #browseMethodHistoryForClass 8 'Method &History' 1 1 10370 nil true 10402 8 'MethodHistory.ico' 10464 65541 nil nil nil 6290 4097 6210 1 6242 #browsePublishedEvents 8 'Published &events' 1 1 10370 nil true 10402 8 'Event.ico' 10464 65541 nil nil nil 6210 1 6242 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil 10361 nil nil 6290 4097 6210 1 6242 #newClass 8 '&New…' 1 1 10370 nil true 10402 8 'NewClass.ico' 10464 65541 nil nil nil 6210 1 6242 #removeClass 8 'Re&move' 1 1 10370 nil true 10402 8 'EditClear.ico' 10464 65541 nil nil nil 6162 nil true 34 18 6210 2097153 6242 #renameClass 8 'Re&name…' 1 1 10370 nil true 10402 8 'Rename.ico' 10464 65541 nil nil nil 6210 1 6242 #copyClass 8 'Cl&one…' 1 1 nil nil nil 6290 4097 6210 1 6242 #addInstanceVariable 8 'Add <1s>&Instance Variable…' 1 1 nil nil nil 6210 1 6242 #addClassVariable 8 'Add &Class Variable…' 1 1 nil nil nil 6162 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil 10375 nil nil 6162 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil 10377 nil nil 6290 4097 6162 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil 10379 nil nil 6162 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil 10381 nil nil 6290 4097 6162 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil 10383 nil nil 6162 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil 10385 nil nil 6162 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil 10387 nil nil 6290 4097 6210 1 6242 #convertToSibling 8 'Con&vert to Sibling…' 1 1 nil nil nil 6290 4097 6210 1 6242 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 10370 nil true 10402 8 'Refactoring.ico' 10464 65541 nil nil 10393 nil nil 6290 4097 6210 1 6242 #createInstanceVariableAccessors 8 'Create &Accessors…' 1 1 nil nil nil 6210 1 6242 #reformatAll 8 'Re&format All' 1 1 nil nil nil 6290 4097 6210 1 6242 #fileInClass 8 'File &In…' 1 1 10370 nil true 10402 8 'FileIn.ico' 10464 65541 nil nil nil 6210 1 6242 #fileOutClass 8 'File &Out…' 1 1 nil nil nil 6290 4097 6210 1 6242 #classPackage 8 '&Package…' 1 1 10370 nil true 10402 8 'Package.ico' 10464 65541 nil nil nil 6210 1 6242 #categorizeClass 8 '&Category…' 1 1 10370 nil true 10402 8 'Category.ico' 10464 65541 nil nil nil 6290 4097 6162 nil true 34 4 6210 1 6242 #newView 8 '&New…' 1 1 nil nil nil 6290 4097 6162 nil true 8 #() 8 '&Edit' #viewsEditMenu 134217729 10370 nil true 10402 8 'ViewComposer.ico' 10464 65541 nil nil 10409 nil nil 6162 nil true 8 #() 8 '&Show' #viewsShowMenu 1 10370 nil true 10402 8 'TestView.ico' 10464 65541 nil nil 10411 nil nil 8 '&Views' #viewsMenu 134217729 10370 nil true 10402 8 'View.ico' 10464 65541 nil nil 10413 nil nil 8 '&Class' nil 134217729 nil nil 10415 nil nil 6162 nil true 34 15 6162 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 10417 nil nil 6162 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 10419 nil nil 6162 nil true 34 16 6210 1 6242 #browseReferencesToGlobal 8 'References to Global…' 1 1 nil nil nil 6210 1 6242 #browseContainingText 8 'C&ontaining Text…' 1 1 10370 nil true 10402 8 'SearchText.ico' 10464 65541 nil nil nil 6210 1 6242 #browseMethodCategory 8 'Cate&gory…' 1 1 10370 nil true 10402 8 'Category.ico' 10464 65541 nil nil nil 6210 1 6242 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 6210 1 6242 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 6290 4097 6210 1 6242 #browseMethodPackages 8 '&Package <s>' 1 1 10370 nil true 10402 8 'Package.ico' 10464 65541 nil nil nil 6210 1 6242 #browseMethodClasses 8 'C&lass <s>' 1 1 nil nil nil 6290 4097 6210 1 6242 #browseMethodHistory 8 '&Change History' 1 1 10370 nil true 10402 8 'MethodHistory.ico' 10464 65541 nil nil nil 6210 1 6242 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 6290 4097 6210 1 6242 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 6210 1 6242 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 6290 4097 6210 1 6242 #browseUnimplemented 8 'All U&nimplemented' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 10445 nil nil 6290 4097 6210 1 6242 #newMethod 8 '&New' 1 1 10370 nil true 10402 8 'NewMethod.ico' 10464 65541 nil nil nil 6210 1 6242 #removeMethod 8 '&Delete' 1 1 10370 nil true 10402 8 'EditClear.ico' 10464 65541 nil nil nil 6162 nil true 34 16 6210 1 6242 #renameMethod 8 'Re&name' 1 1 nil nil nil 6210 1 6242 #renameMethodReferences 8 'Rename Re&ferences…' 1 1 nil nil nil 6290 4097 6210 1 6242 #addParameter 8 'Add &Parameter…' 1 1 nil nil nil 6162 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 10457 nil nil 6162 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 10459 nil nil 6162 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 10461 nil nil 6290 4097 6162 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 10463 nil nil 6162 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 10465 nil nil 6290 4097 6210 1 6242 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 6210 1 6242 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 6210 1 6242 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 6210 1 6242 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 6210 1 6242 #moveMethod 8 'Move to &Component…' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 10370 nil true 10402 8 'Refactoring.ico' 10464 65541 nil nil 10477 nil nil 6290 4097 6210 1 6242 #methodPackage 8 '&Package…' 1 1 10370 nil true 10402 8 'Package.ico' 10464 65541 nil nil nil 6162 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 10481 nil nil 6162 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 10483 nil nil 6210 1 6242 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 6290 4097 6210 1 6242 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 6210 1 6242 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 10491 nil nil 6162 nil true 34 7 6210 1 6242 #undoChange 8 '&Undo <1d>' 1 1 10370 nil true 10402 8 'EditUndo.ico' 10464 65541 nil nil nil 6210 1 6242 #redoChange 8 '&Redo <1d>' 1 1 10370 nil true 10402 8 'EditRedo.ico' 10464 65541 nil nil nil 6210 1 6242 #clearChangeHistory 8 'Clear Change &History' 1 1 10370 nil true 10402 8 'MethodHistoryErase.ico' 10464 65541 nil nil nil 6290 4097 6210 1 6242 #historyBack 8 'Back to <1d>' 1 1 10370 nil true 10402 8 'HistoryBack.ico' 10464 65541 nil nil nil 6210 1 6242 #historyForward 8 'Forward to <1d>' 1 1 10370 nil true 10402 8 'HistoryForward.ico' 10464 65541 nil nil nil 6210 1 6242 #historyClear 8 'Clear Visit History' 1 1 10370 nil true 10402 8 'HistoryErase.ico' 10464 65541 nil nil nil 8 'H&istory' nil 134217729 nil nil 10505 nil nil 6162 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 10507 nil nil 6162 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 10509 nil nil 6162 nil true 34 15 6210 1 6242 #helpContents 8 '&Contents' 1025 1 10370 nil true 10402 8 'Help.ico' 10464 65541 nil nil nil 6210 1 6242 #help 8 'On this &Tool' 1249 1 nil nil nil 6210 1 6242 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 6290 4097 6210 1 6242 #learnSmalltalk 8 'Learn Smalltalk' 1 1 15410 $\x1F393 nil 706 #orchid 706 #white nil nil 1 nil nil nil nil 6290 4097 6210 1 6242 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 6210 1 6242 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 6210 1 6242 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 6290 4097 6210 1 6242 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 10370 nil true 10402 8 '!!APPLICATION' 10464 65541 nil nil nil 6210 1 6242 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 6210 1 6242 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 6290 4097 6210 1 6242 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 15410 $\x1F42C nil nil 706 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 10533 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 882 34 1 930 #createAt:extent: 34 2 674 12287 21 674 1731 1011 416 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 96 27 0 0 3 2 0 0] 34 3 528 2912 2224 1072 nil 27 )!

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
!Tools.EnvironmentBrowserShell class categoriesForMethods!
displayOn:!displaying!public! !
icon!constants!public! !
initializeTool!initializing!private! !
onEnvironment:!instance creation!public! !
resource_Default_view!public!resources-views! !
toolDescription!constants!public! !
toolsFolderHelpId!constants!public! !
toolsFolderIcon!constants!public! !
!

