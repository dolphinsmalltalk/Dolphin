"Filed out from Dolphin Smalltalk 7"!

ClassBrowserAbstract subclass: #EnvironmentBrowserShell
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 565 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 28 198 63 1 0 0 204 53 63 1 3 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point) 193 193 nil 528 327686 ##(Smalltalk.Color) #default 8 1903898080 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 784 nil nil nil 7 nil nil nil 784 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 63 1 674 553 51 784 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1120 nil nil nil 7 nil nil nil 1120 850 ##(Smalltalk.Toolbar) #resource_Image_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 1 674 63 51 1120 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1072 1088 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1360 nil nil nil 7 nil nil nil 1360 850 ##(Smalltalk.Toolbar) #resource_Search_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 615 1 674 437 51 1360 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 1072 1088 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1600 nil nil nil 7 nil nil nil 1600 850 ##(Smalltalk.Toolbar) #resource_Edit_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1051 1 674 247 51 1600 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 136 2 0 0 25 0 0 0] 1072 1088 nil 27 8 'editTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1840 nil nil nil 7 nil nil nil 1840 850 ##(Smalltalk.Toolbar) #resource_Class_browser_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1297 1 674 307 51 1840 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 2 0 0 0 0 0 0 33 3 0 0 25 0 0 0] 1072 1088 nil 27 8 'classBrowserTools' 170 192 1072 138 144 1072 nil nil 1 nil 674 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 882 138 144 34 2 946 #createAt:extent: 34 2 674 1 1 674 1699 51 528 946 #updateSizePosted 1072 528 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 81 3 0 0 25 0 0 0] 34 5 1120 784 1360 1600 1840 1088 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140853004 1 2336 nil nil nil 7 nil 594 nil true 626 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 674 193 193 nil 2336 nil 8 1903688272 170 192 34 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 2336 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'message' 2514 1 501 2336 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'packageOfSelection' 34 2 2560 2528 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2336 nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 849 674 1699 45 2336 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 1 0 0 81 3 0 0 190 1 0 0] 8 #() 1088 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2800 nil nil nil 7 nil nil nil 2800 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 2800 34 2 8 1140850688 1 2960 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2960 nil 1 #left nil nil nil 674 1 1 674 9 9 nil 3056 nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 395 674 1699 11 2960 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 197 0 0 0 81 3 0 0 202 0 0 0] 8 #() 1088 nil 27 1 true 170 192 34 2 410 ##(Smalltalk.CardContainer) 34 16 nil 2800 34 2 8 1140850688 131073 3280 nil nil nil 7 nil nil nil 3280 655878 ##(Smalltalk.CardLayout) 138 144 34 2 2930 590662 1 ##(Smalltalk.CardLabel) 8 'Method Source' 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 7 1 3424 8 'doIt' 8 '(CardLabel text: ''Method Source'' iconBlock: [Icon fromId: ''MethodSource.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 983558 ##(Smalltalk.VariableBinding) #CardLabel 3424 3456 3586 #Icon ##(Smalltalk.Icon) 8 'MethodSource.ico' #fromId: #text:iconBlock: 3488 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 3280 34 2 8 1140850688 131073 3648 nil nil nil 5 nil nil nil 3648 850 ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 9 53 674 1683 335 3648 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 77 3 0 0 193 0 0 0] 1072 1088 nil 27 2930 3426 8 'Class definition' 3474 0 nil 3506 7 1 3424 8 'doIt' 8 '(CardLabel text: ''Class definition'' iconBlock: [Icon fromId: ''ClassDefinition.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 3600 3904 3616 8 'ClassDefinition.ico' #fromId: #text:iconBlock: 3920 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 3280 34 2 8 1140916224 131073 4016 nil 720 nil 23 nil nil nil 4016 850 ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 9 53 674 1683 335 4016 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 77 3 0 0 193 0 0 0] 1072 1088 nil 27 4016 170 192 34 4 3648 8 'source' 4016 8 'definition' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 3280 34 2 8 1140916736 1 4304 590662 2 ##(Smalltalk.ListModel) 138 144 34 2 3440 3888 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 1 nil nil nil 4304 nil 8 1904010400 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #smallIcons nil nil nil nil nil 882 138 144 34 3 946 #createAt:extent: 34 2 674 1 1 674 1699 395 4304 946 #basicSelectionsByIndex: 34 1 8 #(2) 4304 946 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4304 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 81 3 0 0 197 0 0 0] 8 #() 1088 nil 27 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 405 674 1699 395 3280 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 202 0 0 0 81 3 0 0 143 1 0 0] 34 3 3648 4016 4304 1088 nil 27 8 'cards' nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 51 674 1699 799 2800 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 81 3 0 0 168 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2800 34 2 8 1140850688 131073 5088 nil nil nil 7 nil nil nil 5088 2866 138 ##(Smalltalk.Dictionary) 34 2 2930 410 ##(Smalltalk.Splitter) 34 12 nil 5088 34 2 8 1140850688 1 5216 nil nil nil 519 nil nil nil 3026 5216 nil 1 #left nil nil nil 3056 3072 nil 3056 nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1127 1 674 11 395 5216 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 2 0 0 0 0 0 0 56 2 0 0 197 0 0 0] 8 #() 1088 nil 27 1 2930 410 ##(Smalltalk.Splitter) 34 12 nil 5088 34 2 8 1140850688 1 5472 nil nil nil 519 nil nil nil 3026 5472 nil 1 #left nil nil nil 3056 3072 nil 3056 nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 559 1 674 11 395 5472 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 1 0 0 0 0 0 0 28 1 0 0 197 0 0 0] 8 #() 1088 nil 27 1 false 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 5088 34 2 8 1140850688 131073 5744 nil nil nil 31 265030 4 ##(Smalltalk.Menu) nil true 34 17 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 5810 nil true 34 10 5858 1 5890 #browseClassPackage 8 'Package <1d>' 1 1 5938 nil true 5984 8 'Package.ico' 6032 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 5858 2097153 5890 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 5810 nil true 8 #() 8 'Local Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 6178 4097 5858 1 5890 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 5858 1 5890 #browseMethodHistoryForClass 8 'Method &History' 1 1 nil nil nil 6178 4097 5858 1 5890 #browsePublishedEvents 8 'Published &events' 1 1 nil nil nil 5858 1 5890 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 6178 4097 5858 1 5890 #newClass 8 '&New...' 1 1 5938 nil true 5984 8 'NewClass.ico' 6032 nil nil 5858 1 5890 #deleteClassHierarchy 8 '&Delete' 1 1 5938 nil true 5984 8 'EditClear.ico' 6032 nil nil 5810 nil true 34 18 5858 1 5890 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 5858 2097153 5890 #renameClass 8 'Re&name...' 1 1 nil nil nil 6178 4097 5858 1 5890 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 5858 1 5890 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 5810 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 5810 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 6178 4097 5810 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 5810 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 6178 4097 5810 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 5810 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 5810 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 6178 4097 5858 1 5890 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 6178 4097 5858 1 5890 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 5938 nil true 5984 8 'Refactoring.ico' 6032 nil nil nil nil 6178 4097 5858 1 5890 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 5858 1 5890 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 6178 4097 5858 1 5890 #fileInClass 8 'File &In...' 1 1 nil nil nil 5858 1 5890 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 6178 4097 5858 1 5890 #classPackage 8 '&Package...' 1 1 5938 nil true 5984 8 'Package.ico' 6032 nil nil 5858 1 5890 #categorizeClass 8 '&Category...' 1 1 nil nil nil 6178 4097 5810 nil true 34 4 5858 1 5890 #newView 8 '&New...' 1 1 nil nil nil 6178 4097 5810 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 nil nil nil nil nil 5810 nil true 8 #() 8 '&Show' #viewsShowMenu 1 nil nil nil nil nil 8 '&Views' #viewsMenu 1 5938 nil true 5984 8 'View.ico' 6032 nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 5744 850 ##(Smalltalk.ClassListSelector) #resource_Default_view nil 882 138 144 34 2 946 #createAt:extent: 34 2 674 1 1 674 559 395 5744 946 #contextMenu: 34 1 5824 5744 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 23 1 0 0 197 0 0 0] 1072 1088 nil 27 8 'classes' 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 5088 34 2 8 1140850688 131073 8352 nil nil nil 519 nil nil nil 8352 3346 138 144 34 3 2930 3426 8 'Categories' 3474 0 nil 3506 3 1 3472 8 'doIt' 8 '[MethodCategory icon]
' 8 #[31 105 45 159 106] 3586 #MethodCategory ##(Smalltalk.MethodCategory) #icon 8512 7 1 nil 21481 410 ##(Smalltalk.TreeView) 34 27 nil 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 8352 34 2 8 1140850688 131073 8640 nil nil nil 7 nil nil nil 8640 8416 170 192 34 6 410 ##(Smalltalk.ListView) 34 30 nil 8640 34 2 8 1140936777 1 8736 4370 138 144 1072 nil 4448 720 nil 29 5810 nil true 34 7 5858 1 5890 #browseSelectorsInProtocol 8 '&Selectors' 1 1 nil nil nil 5858 1 5890 #toggleProtocolReadOnly 8 '&Read Only' 1 1 nil nil nil 6178 4097 5858 1 5890 #addMethodProtocol 8 '&Add...' 1 1 nil nil nil 5810 nil true 34 2 5858 1 5890 #removeMethodProtocol 8 'Protocol' 1 1 nil nil nil 5858 1 5890 #removeMethodsInProtocol 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 5858 1 5890 #renameMethodProtocol 8 'Rename...' 1 1 nil nil nil 5858 1 5890 #browseMethodProtocol 8 'Browse' 1 1 nil nil nil 8 'Protocols' nil 134217729 nil nil nil nil nil nil nil 8736 nil 8 1903904528 459270 ##(Smalltalk.Message) #name 8 #() ##(Smalltalk.IconicListAbstract) 4496 nil nil 3474 0 nil 3506 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 9344 7 257 nil 674 65 65 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Protocols' 439 #left 9298 #name 8 #() 9298 #<= 8 #() nil nil 8736 nil 3 nil 3474 0 nil 3506 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 9584 7 257 nil #report 1072 nil 133217 nil 34 4 nil nil 674 1 1 nil 882 138 144 34 3 946 #createAt:extent: 34 2 674 1 37 674 447 343 8736 946 #contextMenu: 34 1 8832 8736 946 #text: 34 1 8 'Protocols' 8736 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 223 0 0 0 189 0 0 0] 8 #() 1088 nil 27 8 'protocols' 8608 8 'categories' 410 ##(Smalltalk.ListView) 34 30 nil 8640 34 2 8 1140920395 1 9968 4370 138 144 1072 nil 4448 720 nil 13 5810 nil true 34 10 5858 2097153 5890 #browseInstVarReferences 8 'Browse &References' 1 1 nil nil nil 6178 4097 5858 1 5890 #addInstanceVariable 8 '&Add...' 1 1 nil nil nil 5858 1 5890 #removeInstanceVariables 8 'Remo&ve' 1 1 nil nil nil 5858 1 5890 #renameInstanceVariable 8 'Re&name' 1 1 nil nil nil 6178 4097 5858 1 5890 #pushDownInstanceVariables 8 'Push &Down' 1 1 nil nil nil 5858 1 5890 #createAccessors 8 '&Create Accessors' 1 1 nil nil nil 5858 1 5890 #abstractInstanceVariables 8 'Ab&stract' 1 1 nil nil nil 5858 1 5890 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 9968 nil 8 1903904528 9298 #value 8 #() 3474 0 nil 3506 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] #key #icon #imageIndex 10560 7 257 nil 4496 nil 3474 0 nil 3506 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] #key #name 8 '.' #, 10640 7 257 nil nil 674 65 65 nil nil 138 144 34 1 9474 8 '' 201 #left ##(Smalltalk.BasicListAbstract) 9298 #<= 8 #() nil nil 9968 nil 1 nil nil #list 1072 nil 133217 nil 34 4 nil nil 674 1 1 nil 882 138 144 34 2 946 #createAt:extent: 34 2 674 1 37 674 447 343 9968 946 #contextMenu: 34 1 10064 9968 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 223 0 0 0 189 0 0 0] 8 #() 1088 nil 27 8 'variables' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 8352 34 2 8 1140916864 1 11088 4370 138 144 34 3 8480 3426 8 'Protocols' 3474 0 nil 3506 6 1 16 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 3586 #CardLabel 3424 11216 3586 #MethodProtocol ##(Smalltalk.MethodProtocol) #icon #text:iconBlock: 11232 11 1 nil 21487 3426 8 'Variables' nil 21491 nil 4448 nil nil 1 nil nil nil 11088 nil 8 1904010400 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 4496 nil nil nil nil nil #smallIcons nil nil nil nil nil 882 138 144 34 3 946 #createAt:extent: 34 2 674 1 1 674 559 395 11088 946 #basicSelectionsByIndex: 34 1 8 #(1) 11088 946 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 11088 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 23 1 0 0 197 0 0 0] 8 #() 1088 nil 27 nil 8352 674 33 33 1050182 1 ##(Smalltalk.ButtonInteractor) 8640 nil 1 590342 ##(Smalltalk.Rectangle) 674 411 3 674 443 35 nil 5890 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 105 9 674 447 379 8640 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 52 0 0 0 4 0 0 0 19 1 0 0 193 0 0 0] 34 3 8608 8736 9968 1088 nil 27 34 2 8 1140916771 1 8608 590918 3 ##(Smalltalk.TreeModel) nil 4448 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 1072 720 nil 31 5810 nil true 34 4 5858 1 5890 #addMethodCategory 8 '&Add...' 1 1 nil nil nil 5810 nil true 34 2 5858 1 5890 #removeMethodCategory 8 'Category' 1 1 nil nil nil 5858 1 5890 #removeMethodsInCategory 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 5858 1 5890 #renameMethodCategory 8 'Rename...' 1 1 nil nil nil 5858 1 5890 #browseMethodCategory 8 'Browse' 1 1 nil nil nil 8 'Categories' nil 134217729 nil nil nil nil nil nil nil 8608 nil 8 1903706176 9298 #localName 8 #() ##(Smalltalk.IconicListAbstract) 4496 nil nil 3474 0 nil 3506 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawCategoryTree: 12432 7 257 nil nil nil 170 176 1072 nil #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 1072 882 138 144 34 2 946 #createAt:extent: 34 2 674 1 37 674 447 343 8608 946 #contextMenu: 34 1 12048 8608 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 223 0 0 0 189 0 0 0] 8 #() 1088 nil 27 2930 11200 8736 2930 11344 9968 8608 170 192 34 2 8640 8 'filters' nil 11088 8640 674 201 201 401 1 524319 nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 569 1 674 559 395 8352 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 1 0 0 0 0 0 0 51 2 0 0 197 0 0 0] 34 2 8640 11088 1088 nil 27 8 'filtersSlidey' nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 1 674 1699 395 5088 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 81 3 0 0 197 0 0 0] 34 5 5744 5472 8352 5216 410 ##(Smalltalk.ContainerView) 34 15 nil 5088 34 2 8 1140850688 131073 13168 nil nil nil 7 nil nil nil 13168 498 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 13168 34 2 8 1140850688 131073 13248 nil nil nil 535 nil nil nil 13248 2130 11 1 1 170 192 34 4 410 ##(Smalltalk.RadioButton) 34 16 nil 13248 34 2 8 1141055497 1 13360 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 9298 #= 8 #() 9298 #hash 8 #() false nil nil 7 nil nil nil 13360 nil 8 1903885040 852486 ##(Smalltalk.NullConverter) nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 674 21 1 674 131 51 13360 946 #text: 34 1 8 'In&stance' 13360 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 75 0 0 0 25 0 0 0] 8 #() 1088 nil 27 8 'instanceMode' 410 ##(Smalltalk.RadioButton) 34 16 nil 13248 34 2 8 1141055497 1 13824 13426 nil nil 13458 9298 #= 8 #() 9298 #hash 8 #() false nil nil 7 nil nil nil 13824 nil 8 1903885040 13570 nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 674 161 1 674 111 51 13824 946 #text: 34 1 8 'C&lass' 13824 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 0 0 0 0 135 0 0 0 25 0 0 0] 8 #() 1088 nil 27 8 'classMode' 11682 674 21 1 674 1 1 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 345 674 563 51 13248 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 172 0 0 0 25 1 0 0 197 0 0 0] 34 2 13360 13824 1088 nil 27 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 13168 34 2 8 1140850688 131073 14448 nil nil nil 31 nil nil nil 14448 850 ##(Smalltalk.MethodBrowser) #resource_Class_browser_method_list nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 1 674 563 345 14448 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 25 1 0 0 172 0 0 0] 1072 1088 nil 27 170 192 34 4 14448 8 'methods' 13248 8 'mode' nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1137 1 674 563 395 13168 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 56 2 0 0 0 0 0 0 81 3 0 0 197 0 0 0] 34 2 13248 14448 1088 nil 27 1088 nil 27 2960 3280 1088 nil 27 170 192 34 4 2336 8 'statusbar' 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 9 5810 nil true 34 10 5858 1 5890 #fileNew 8 '&New Workspace' 9373 1 5938 nil true 5984 8 'NewWorkspace.ico' 6032 nil nil 5858 1 5890 #fileOpen 8 '&Open Workspace...' 9375 1 5938 nil true 5984 8 'OpenWorkspace.ico' 6032 nil nil 5858 1 5890 #fileFileIn 8 '&File In...' 1 1 5938 nil true 5984 8 'FileIn.ico' 6032 nil nil 6178 4097 5858 1 5890 #browseExecutableManifest 8 'Open &Executable Manifest...' 1 1 5938 nil true 5984 8 'FileOpen.ico' 6032 nil nil 6178 4097 5858 1 5890 #saveImage 8 'Sa&ve Image' 1 1 5938 nil true 5984 8 'Snapshot.ico' 6032 nil nil 5858 1 5890 #smalltalkExit 8 'E&xit Dolphin' 1 1 5938 nil true 5984 8 'PowerSwitch.ico' 6032 nil nil 6178 4097 5858 1 5890 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 40193 nil nil 5810 nil true 34 13 5858 1 5890 #undo 8 '&Undo' 9397 1 5938 nil true 5984 8 'EditUndo.ico' 6032 nil nil 6178 4097 5858 1 5890 #cutSelection 8 'Cu&t' 9393 1 5938 nil true 5984 8 'EditCut.ico' 6032 nil nil 5858 1 5890 #copySelection 8 '&Copy' 9351 1 5938 nil true 5984 8 'EditCopy.ico' 6032 nil nil 5858 1 5890 #pasteClipboard 8 '&Paste' 9389 1 5938 nil true 5984 8 'EditPaste.ico' 6032 nil nil 5858 1 5890 #editDelete 8 '&Delete' 1 1 5938 nil true 5984 8 'EditClear.ico' 6032 nil nil 5810 nil true 34 2 5858 1 5890 #reformatSource 8 '&Source' 9391 1 nil nil nil 5858 1 5890 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 40209 nil nil 6178 4097 5858 1 5890 #selectAll 8 'Select &All' 9347 1 nil nil nil 6178 4097 5858 1 5890 #editFind 8 '&Find...' 9357 1 5938 nil true 5984 47 786694 ##(Smalltalk.ShellLibrary) nil nil 5858 1 5890 #findNext 8 'Find &Next' 1253 1 5938 nil true 5984 8 'FindNext.ico' 6032 nil nil 5858 1 5890 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 40219 nil nil 5810 nil true 34 14 5858 1 5890 #browseIt 8 '&Browse It' 9349 1 5938 nil true 5984 8 'ClassBrowserShell.ico' 6032 nil nil 5858 1 5890 #displayIt 8 '&Display It' 9353 1 5938 nil true 5984 8 'DisplayIt.ico' 6032 nil nil 5858 1 5890 #evaluateIt 8 '&Evaluate It' 9355 1 5938 nil true 5984 8 'EvaluateIt.ico' 6032 nil nil 5858 1 5890 #inspectIt 8 '&Inspect It' 9363 1 5938 nil true 5984 8 'InspectIt.ico' 6032 nil nil 5858 1 5890 #debugIt 8 'Deb&ug It' 1269 1 5938 nil true 5984 8 'Debugger.ico' 6032 nil nil 5858 1 5890 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 6178 4097 5858 1 5890 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 5858 1 5890 #browseReferences 8 '&References' 5367 1 nil nil nil 6178 4097 5858 2097153 5890 #accept 8 '&Accept' 9383 1 nil nil nil 5858 1 5890 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 6178 4097 5810 nil true 34 13 5858 1 5890 #renameVariable 8 'Re&name <1d>...' 1 1 5938 nil true 5984 8 'Rename.ico' 6032 nil nil 6178 4097 5858 1 5890 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 nil nil nil 5858 1 5890 #extractMethod 8 'E&xtract Method...' 9371 1 nil nil nil 5858 1 5890 #extractToComponent 8 'Extract to &Component...' 1 1 nil nil nil 5858 1 5890 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 6178 4097 5858 1 5890 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 5858 1 5890 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 5858 1 5890 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 6178 4097 5858 1 5890 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 5858 1 5890 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 5938 nil true 5984 8 'Refactoring.ico' 6032 nil 40261 nil nil 8 '&Workspace' nil 134217729 nil nil 40263 nil nil 5810 nil true 34 17 5858 2097153 5890 #findClass 8 'Find...' 1 1 5938 nil true 5984 8 'FindClass.ico' 6032 nil nil 5810 nil true 34 10 5858 1 5890 #browseClassPackage 8 'Package <1d>' 1 1 5938 nil true 5984 8 'Package.ico' 6032 nil nil 6178 4097 5858 2097153 5890 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 5810 nil true 8 #() 8 'Local Re&ferences To' #browseVariablesMenu 134217729 nil nil 40271 nil nil 6178 4097 5858 1 5890 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 5858 1 5890 #browseMethodHistoryForClass 8 'Method &History' 1 1 5938 nil true 5984 8 'MethodHistory.ico' 6032 nil nil 6178 4097 5858 1 5890 #browsePublishedEvents 8 'Published &events' 1 1 5938 nil true 5984 8 'Event.ico' 6032 nil nil 5858 1 5890 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil 40281 nil nil 6178 4097 5858 1 5890 #newClass 8 '&New...' 1 1 5938 nil true 5984 8 'NewClass.ico' 6032 nil nil 5858 1 5890 #deleteClassHierarchy 8 '&Delete' 1 1 5938 nil true 5984 8 'EditClear.ico' 6032 nil nil 5810 nil true 34 19 5858 1 5890 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 5858 2097153 5890 #renameClass 8 'Re&name...' 1 1 5938 nil true 5984 8 'Rename.ico' 6032 nil nil 5858 1 5890 #copyClass 8 'Cl&one...' 1 1 nil nil nil 6178 4097 5858 1 5890 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 5858 1 5890 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 5810 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil 40297 nil nil 5810 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil 40299 nil nil 6178 4097 5810 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil 40301 nil nil 5810 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil 40303 nil nil 6178 4097 5810 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil 40305 nil nil 5810 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil 40307 nil nil 5810 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil 40309 nil nil 6178 4097 5858 1 5890 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 6178 4097 5858 1 5890 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 5938 nil true 5984 8 'Refactoring.ico' 6032 nil 40315 nil nil 6178 4097 5858 1 5890 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 5858 1 5890 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 6178 4097 5858 1 5890 #fileInClass 8 'File &In...' 1 1 5938 nil true 5984 8 'FileIn.ico' 6032 nil nil 5858 1 5890 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 6178 4097 5858 1 5890 #classPackage 8 '&Package...' 1 1 5938 nil true 5984 8 'Package.ico' 6032 nil nil 5858 1 5890 #categorizeClass 8 '&Category...' 1 1 5938 nil true 5984 8 'Category.ico' 6032 nil nil 6178 4097 5810 nil true 34 4 5858 1 5890 #newView 8 '&New...' 1 1 nil nil nil 6178 4097 5810 nil true 8 #() 8 '&Edit' #viewsEditMenu 134217729 5938 nil true 5984 8 'ViewComposer.ico' 6032 nil 40331 nil nil 5810 nil true 8 #() 8 '&Show' #viewsShowMenu 1 5938 nil true 5984 8 'TestView.ico' 6032 nil 40333 nil nil 8 '&Views' #viewsMenu 134217729 5938 nil true 5984 8 'View.ico' 6032 nil 40335 nil nil 8 '&Class' nil 134217729 nil nil 40337 nil nil 5810 nil true 34 15 5810 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 40339 nil nil 5810 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 40341 nil nil 5810 nil true 34 16 5858 1 5890 #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 5858 1 5890 #browseContainingText 8 'C&ontaining Text...' 1 1 5938 nil true 5984 8 'SearchText.ico' 6032 nil nil 5858 1 5890 #browseMethodCategory 8 'Cate&gory...' 1 1 5938 nil true 5984 8 'Category.ico' 6032 nil nil 5858 1 5890 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 5858 1 5890 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 6178 4097 5858 1 5890 #browseMethodPackages 8 '&Package <s>' 1 1 5938 nil true 5984 8 'Package.ico' 6032 nil nil 5858 1 5890 #browseMethodClasses 8 'C&lass <s>' 1 1 nil nil nil 6178 4097 5858 1 5890 #browseMethodHistory 8 '&Change History' 1 1 5938 nil true 5984 8 'MethodHistory.ico' 6032 nil nil 5858 1 5890 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 6178 4097 5858 1 5890 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 5858 1 5890 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 6178 4097 5858 1 5890 #browseUnimplemented 8 'All U&nimplemented' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 40367 nil nil 6178 4097 5858 1 5890 #newMethod 8 '&New' 1 1 5938 nil true 5984 8 'NewMethod.ico' 6032 nil nil 5858 1 5890 #removeMethod 8 '&Delete' 1 1 5938 nil true 5984 8 'EditClear.ico' 6032 nil nil 5810 nil true 34 17 5858 1 5890 #renameMethod 8 'Re&name' 1 1 nil nil nil 5858 1 5890 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 5858 1 5890 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 6178 4097 5858 1 5890 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 5810 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 40381 nil nil 5810 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 40383 nil nil 5810 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 40385 nil nil 6178 4097 5810 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 40387 nil nil 5810 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 40389 nil nil 6178 4097 5858 1 5890 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 5858 1 5890 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 5858 1 5890 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 5858 1 5890 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 5858 1 5890 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 5938 nil true 5984 8 'Refactoring.ico' 6032 nil 40401 nil nil 6178 4097 5858 1 5890 #methodPackage 8 '&Package...' 1 1 5938 nil true 5984 8 'Package.ico' 6032 nil nil 5810 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 40405 nil nil 5810 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 40407 nil nil 5858 1 5890 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 6178 4097 5858 1 5890 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 5858 1 5890 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 40415 nil nil 5810 nil true 34 7 5858 1 5890 #undoChange 8 '&Undo <1d>' 1 1 5938 nil true 5984 8 'EditUndo.ico' 6032 nil nil 5858 1 5890 #redoChange 8 '&Redo <1d>' 1 1 5938 nil true 5984 8 'EditRedo.ico' 6032 nil nil 5858 1 5890 #clearChangeHistory 8 'Clear Change &History' 1 1 5938 nil true 5984 8 'MethodHistoryErase.ico' 6032 nil nil 6178 4097 5858 1 5890 #historyBack 8 'Back to <1d>' 1 1 5938 nil true 5984 8 'HistoryBack.ico' 6032 nil nil 5858 1 5890 #historyForward 8 'Forward to <1d>' 1 1 5938 nil true 5984 8 'HistoryForward.ico' 6032 nil nil 5858 1 5890 #historyClear 8 'Clear Visit History' 1 1 5938 nil true 5984 8 'HistoryErase.ico' 6032 nil nil 8 'H&istory' nil 134217729 nil nil 40429 nil nil 5810 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 40431 nil nil 5810 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 40433 nil nil 5810 nil true 34 15 5858 1 5890 #helpContents 8 '&Contents' 1025 1 5938 nil true 5984 8 'Help.ico' 6032 nil nil 5858 1 5890 #help 8 'On this &Tool' 1249 1 nil nil nil 5858 1 5890 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 6178 4097 5858 1 5890 #learnSmalltalk 8 'Learn Smalltalk' 1 1 15618 $\x1F393 nil 706 #orchid 706 #white nil nil 1 nil nil nil nil 6178 4097 5858 1 5890 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 5858 1 5890 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 5858 1 5890 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 6178 4097 5858 1 5890 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 5938 nil true 5984 8 '!!APPLICATION' 6032 nil nil 5858 1 5890 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 5858 1 5890 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 6178 4097 5858 1 5890 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 15618 $\x1F42C nil nil 706 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' nil 134217729 nil nil 40457 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 674 3839 21 674 1731 1011 416 946 #updateMenuBar 1072 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 224 10 0 0 3 2 0 0] 34 3 528 2800 2336 1088 nil 27)!

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

