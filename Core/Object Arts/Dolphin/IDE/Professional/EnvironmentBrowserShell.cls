"Filed out from Dolphin Smalltalk"!

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

!EnvironmentBrowserShell categoriesForMethods!
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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 533 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 528 327686 ##(Smalltalk.Color) #default 8 1962208256 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 752 nil nil nil 7 nil nil nil 752 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 784 8 '' 752 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1120 nil nil nil 7 nil nil nil 1120 818 ##(Smalltalk.Toolbar) #resource_Edit_tools nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[11 2 0 0 0 0 0 0 134 2 0 0 25 0 0 0] 193 1152 8 '' 1120 3 1056 1074 193 193 nil 27 8 'editTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1376 nil nil nil 7 nil nil nil 1376 818 ##(Smalltalk.Toolbar) #resource_Class_browser_tools nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[134 2 0 0 0 0 0 0 31 3 0 0 25 0 0 0] 193 1408 8 '' 1376 3 1056 1074 193 193 nil 27 8 'classBrowserTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1632 nil nil nil 7 nil nil nil 1632 818 ##(Smalltalk.Toolbar) #resource_Search_tools nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[51 1 0 0 0 0 0 0 11 2 0 0 25 0 0 0] 193 1664 8 '' 1632 3 1056 1074 193 193 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1888 nil nil nil 7 nil nil nil 1888 818 ##(Smalltalk.Toolbar) #resource_Image_tools nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 1920 8 '' 1888 3 1056 1074 193 193 nil 27 8 'imageTools' nil nil nil 170 192 1056 138 144 1056 nil nil 9 1599 #smallIcons nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 0 0 0 0 81 3 0 0 25 0 0 0] 193 560 8 '' 528 3 34 5 1888 752 1632 1120 1376 1074 193 193 nil 31 410 ##(Smalltalk.StatusBar) 34 21 nil 416 34 2 8 1140853004 1 2384 nil nil nil 7 nil 594 nil true 626 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 77 0 105 0 99 0 114 0 111 0 115 0 111 0 102 0 116 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2384 nil 8 1961901280 170 192 34 4 853830 1 ##(Smalltalk.StatusBarItem) 8193 -1 2384 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'message' 2546 8193 501 2384 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'packageOfSelection' nil nil nil 34 2 2592 2560 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 2384 nil nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 168 1 0 0 81 3 0 0 190 1 0 0] 193 2416 8 '' 2384 3 8 #() 1074 193 193 nil 29 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2848 nil nil nil 7 nil nil nil 2848 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 2848 34 2 8 1140850688 1 3008 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3008 nil 1 #left nil nil nil 1074 1 1 1074 9 9 nil 3104 nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 197 0 0 0 81 3 0 0 202 0 0 0] 193 3040 8 '' 3008 3 8 #() 1074 193 193 nil 27 1 true 170 192 34 2 410 ##(Smalltalk.CardContainer) 34 16 nil 2848 34 2 8 1140850688 131073 3344 nil nil nil 7 nil nil nil 3344 656710 1 ##(Smalltalk.CardLayout) 138 144 34 2 2978 590662 1 ##(Smalltalk.CardLabel) 8 'Method Source' 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 7 1 3488 8 'doIt' 8 '(CardLabel text: ''Method Source'' iconBlock: [Icon fromId: ''MethodSource.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 983558 ##(Smalltalk.VariableBinding) #CardLabel 3488 3520 3650 #Icon ##(Smalltalk.Icon) 8 'MethodSource.ico' #fromId: #text:iconBlock: 3552 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 3344 34 2 8 1140850688 131073 3712 nil nil nil 5 nil nil nil 3712 818 ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[4 0 0 0 24 0 0 0 77 3 0 0 193 0 0 0] 193 3744 8 '' 3712 1 1056 1074 193 193 nil 27 2978 3490 8 'Class definition' 3538 0 nil 3570 7 1 3488 8 'doIt' 8 '(CardLabel text: ''Class definition'' iconBlock: [Icon fromId: ''ClassDefinition.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 3664 3984 3680 8 'ClassDefinition.ico' #fromId: #text:iconBlock: 4000 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 3344 34 2 8 1140916224 131073 4096 nil 688 nil 23 nil nil nil 4096 818 ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[4 0 0 0 24 0 0 0 77 3 0 0 193 0 0 0] 193 4128 8 '' 4096 3 1056 1074 193 193 nil 27 4096 nil nil nil 170 192 34 4 3712 8 'source' 4096 8 'definition' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 3344 34 2 8 1140916736 1 4400 590662 2 ##(Smalltalk.ListModel) 138 144 34 2 3504 3968 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 1 nil nil nil 4400 nil 8 1961760432 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #smallIcons nil nil nil nil nil 850 138 144 34 3 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 0 0 0 0 81 3 0 0 197 0 0 0] 193 4432 8 '' 4400 914 #setSingleSelection: 8 #(2) 4400 914 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4400 3 8 #() 1074 193 193 nil 27 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 202 0 0 0 81 3 0 0 143 1 0 0] 193 3376 8 '' 3344 3 34 3 3712 4096 4400 1074 193 193 nil 27 8 'cards' nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 25 0 0 0 81 3 0 0 168 1 0 0] 193 2880 8 '' 2848 3 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2848 34 2 8 1140850688 131073 5200 nil nil nil 7 nil nil nil 5200 2914 138 ##(Smalltalk.Dictionary) 34 2 2978 410 ##(Smalltalk.Splitter) 34 12 nil 5200 34 2 8 1140850688 1 5328 nil nil nil 519 nil nil nil 3074 5328 nil 1 #left nil nil nil 3104 3120 nil 3104 nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[23 1 0 0 0 0 0 0 28 1 0 0 197 0 0 0] 193 5360 8 '' 5328 3 8 #() 1074 193 193 nil 27 1 2978 410 ##(Smalltalk.Splitter) 34 12 nil 5200 34 2 8 1140850688 1 5600 nil nil nil 519 nil nil nil 3074 5600 nil 1 #left nil nil nil 3104 3120 nil 3104 nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[51 2 0 0 0 0 0 0 56 2 0 0 197 0 0 0] 193 5632 8 '' 5600 3 8 #() 1074 193 193 nil 27 1 false 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 5200 34 2 8 1140850688 131073 5888 nil nil nil 31 265030 4 ##(Smalltalk.Menu) nil true 34 17 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 5954 nil true 34 10 6002 1 6034 #browseClassPackage 8 'Package <1d>' 1 1 6082 nil true 6128 8 'Package.ico' 6176 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 6002 2097153 6034 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 5954 nil true 8 #() 8 'Local Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 6322 4097 6002 1 6034 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 6002 1 6034 #browseMethodHistoryForClass 8 'Method &History' 1 1 nil nil nil 6322 4097 6002 1 6034 #browsePublishedEvents 8 'Published &events' 1 1 nil nil nil 6002 1 6034 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 6322 4097 6002 1 6034 #newClass 8 '&New...' 1 1 6082 nil true 6128 8 'NewClass.ico' 6176 nil nil 6002 1 6034 #deleteClassHierarchy 8 '&Delete' 1 1 6082 nil true 6128 8 'EditClear.ico' 6176 nil nil 5954 nil true 34 18 6002 1 6034 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 6002 2097153 6034 #renameClass 8 'Re&name...' 1 1 nil nil nil 6322 4097 6002 1 6034 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 6002 1 6034 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 5954 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 5954 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 6322 4097 5954 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 5954 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 6322 4097 5954 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 5954 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 5954 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 6322 4097 6002 1 6034 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 6322 4097 6002 1 6034 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 6082 nil true 6128 8 'Refactoring.ico' 6176 nil nil nil nil 6322 4097 6002 1 6034 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 6002 1 6034 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 6322 4097 6002 1 6034 #fileInClass 8 'File &In...' 1 1 nil nil nil 6002 1 6034 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 6322 4097 6002 1 6034 #classPackage 8 '&Package...' 1 1 6082 nil true 6128 8 'Package.ico' 6176 nil nil 6002 1 6034 #categorizeClass 8 '&Category...' 1 1 nil nil nil 6322 4097 5954 nil true 34 4 6002 1 6034 #newView 8 '&New...' 1 1 nil nil nil 6322 4097 5954 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 nil nil nil nil nil 5954 nil true 8 #() 8 '&Show' #viewsShowMenu 1 nil nil nil nil nil 8 '&Views' #viewsMenu 1 6082 nil true 6128 8 'View.ico' 6176 nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 5888 818 ##(Smalltalk.ClassListSelector) #resource_Default_view nil 850 138 144 34 2 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 0 0 0 0 23 1 0 0 197 0 0 0] 193 5920 8 '' 5888 914 #contextMenu: 34 1 5968 5888 3 1056 1074 193 193 nil 27 8 'classes' 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 5200 34 2 8 1140850688 131073 8512 nil nil nil 519 nil nil nil 8512 3410 138 144 34 3 2978 3490 8 'Categories' 3538 0 nil 3570 3 1 3536 8 'doIt' 8 '[MethodCategory icon]
' 8 #[31 105 45 159 106] 3650 #MethodCategory ##(Smalltalk.MethodCategory) #icon 8672 7 1 nil 21481 410 ##(Smalltalk.TreeView) 34 27 nil 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 8512 34 2 8 1140850688 131073 8800 nil nil nil 7 nil nil nil 8800 8576 170 192 34 6 410 ##(Smalltalk.ListView) 34 45 nil 8800 34 2 8 1140936777 1 8896 4466 138 144 1056 nil 4544 688 nil 29 5954 nil true 34 7 6002 1 6034 #browseSelectorsInProtocol 8 '&Selectors' 1 1 nil nil nil 6002 1 6034 #toggleProtocolReadOnly 8 '&Read Only' 1 1 nil nil nil 6322 4097 6002 1 6034 #addMethodProtocol 8 '&Add...' 1 1 nil nil nil 5954 nil true 34 2 6002 1 6034 #removeMethodProtocol 8 'Protocol' 1 1 nil nil nil 6002 1 6034 #removeMethodsInProtocol 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 6002 1 6034 #renameMethodProtocol 8 'Rename...' 1 1 nil nil nil 6002 1 6034 #browseMethodProtocol 8 'Browse' 1 1 nil nil nil 8 'Protocols' nil 134217729 nil nil nil nil nil nil nil 8896 nil 8 1962164432 459270 ##(Smalltalk.Message) #name 8 #() ##(Smalltalk.IconicListAbstract) 4592 nil nil 3538 0 nil 3570 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 9504 7 257 nil 1074 65 65 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Protocols' 451 #left 9458 #name 8 #() 9458 #<= 8 #() nil nil 8896 nil 3 nil 3538 0 nil 3570 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 9744 7 257 nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 850 138 144 34 2 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 18 0 0 0 225 0 0 0 189 0 0 0] 193 8928 8 'Protocols' 8896 914 #contextMenu: 34 1 8992 8896 1 8 #() 1074 193 193 nil 35 8 'protocols' 8768 8 'categories' 410 ##(Smalltalk.ListView) 34 45 nil 8800 34 2 8 1140920395 1 10080 4466 138 144 1056 nil 4544 688 nil 13 5954 nil true 34 10 6002 2097153 6034 #browseInstVarReferences 8 'Browse &References' 1 1 nil nil nil 6322 4097 6002 1 6034 #addInstanceVariable 8 '&Add...' 1 1 nil nil nil 6002 1 6034 #removeInstanceVariables 8 'Remo&ve' 1 1 nil nil nil 6002 1 6034 #renameInstanceVariable 8 'Re&name' 1 1 nil nil nil 6322 4097 6002 1 6034 #pushDownInstanceVariables 8 'Push &Down' 1 1 nil nil nil 6002 1 6034 #createAccessors 8 '&Create Accessors' 1 1 nil nil nil 6002 1 6034 #abstractInstanceVariables 8 'Ab&stract' 1 1 nil nil nil 6002 1 6034 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 10080 nil 8 1962164432 9458 #value 8 #() 3538 0 nil 3570 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] #key #icon #imageIndex 10672 7 257 nil 4592 nil 3538 0 nil 3570 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] #key #name 8 '.' #, 10752 7 257 nil nil 1074 65 65 nil nil 138 144 34 1 9634 8 '' 201 #left ##(Smalltalk.BasicListAbstract) 9458 #<= 8 #() nil nil 10080 nil 1 nil nil #list 9824 nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 850 138 144 34 2 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 18 0 0 0 225 0 0 0 189 0 0 0] 193 10112 8 '' 10080 914 #contextMenu: 34 1 10176 10080 1 8 #() 1074 193 193 nil 35 8 'variables' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 8512 34 2 8 1140916864 1 11184 4466 138 144 34 3 8640 3490 8 'Protocols' 3538 0 nil 3570 6 1 16 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 3650 #CardLabel 3488 11312 3650 #MethodProtocol ##(Smalltalk.MethodProtocol) #icon #text:iconBlock: 11328 11 1 nil 21487 3490 8 'Variables' nil 21491 nil 4544 nil nil 1 nil nil nil 11184 nil 8 1961760432 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 4592 nil nil nil nil nil #smallIcons nil nil nil nil nil 850 138 144 34 3 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 0 0 0 0 23 1 0 0 197 0 0 0] 193 11216 8 '' 11184 914 #setSingleSelection: 8 #(1) 11184 914 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 11184 3 8 #() 1074 193 193 nil 27 nil 8512 1074 33 33 1050182 1 ##(Smalltalk.ButtonInteractor) 8800 nil 1 590342 ##(Smalltalk.Rectangle) 1074 415 3 1074 447 35 nil 6034 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[50 0 0 0 4 0 0 0 19 1 0 0 193 0 0 0] 193 8832 8 '' 8800 3 34 3 8768 8896 10080 1074 193 193 nil 27 34 2 8 1140916771 1 8768 590918 3 ##(Smalltalk.TreeModel) nil 4544 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 1056 688 nil 31 5954 nil true 34 4 6002 1 6034 #addMethodCategory 8 '&Add...' 1 1 nil nil nil 5954 nil true 34 2 6002 1 6034 #removeMethodCategory 8 'Category' 1 1 nil nil nil 6002 1 6034 #removeMethodsInCategory 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 6002 1 6034 #renameMethodCategory 8 'Rename...' 1 1 nil nil nil 6002 1 6034 #browseMethodCategory 8 'Browse' 1 1 nil nil nil 8 'Categories' nil 134217729 nil nil nil nil nil nil nil 8768 nil 8 1961862080 9458 #localName 8 #() ##(Smalltalk.IconicListAbstract) 4592 nil nil 3538 0 nil 3570 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawCategoryTree: 12544 7 257 nil nil nil 170 176 1056 nil #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 1056 850 138 144 34 2 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 18 0 0 0 225 0 0 0 189 0 0 0] 193 12048 8 '' 8768 914 #contextMenu: 34 1 12160 8768 3 8 #() 1074 193 193 nil 27 2978 11296 8896 2978 11440 10080 8768 nil nil nil 170 192 34 2 8800 8 'filters' nil 11184 8800 1074 201 201 401 1 524319 nil nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[28 1 0 0 0 0 0 0 51 2 0 0 197 0 0 0] 193 8544 8 '' 8512 3 34 2 8800 11184 1074 193 193 nil 27 8 'filtersSlidey' nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 0 0 0 0 81 3 0 0 197 0 0 0] 193 5232 8 '' 5200 3 34 5 5888 5328 8512 5600 410 ##(Smalltalk.ContainerView) 34 15 nil 5200 34 2 8 1140850688 131073 13312 nil nil nil 7 nil nil nil 13312 498 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 13312 34 2 8 1140850688 131073 13392 nil nil nil 535 nil nil nil 13392 2178 11 1 1 170 192 34 4 410 ##(Smalltalk.RadioButton) 34 16 nil 13392 34 2 8 1141055497 1 13504 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 9458 #= 8 #() 9458 #hash 8 #() false nil nil 519 nil nil nil 13504 nil 8 1962103648 852486 ##(Smalltalk.NullConverter) nil nil nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[10 0 0 0 3 0 0 0 68 0 0 0 21 0 0 0] 193 13536 8 'In&stance' 13504 3 8 #() 1074 193 193 nil 27 8 'instanceMode' 410 ##(Smalltalk.RadioButton) 34 16 nil 13392 34 2 8 1141055497 1 13936 13570 nil nil 13602 9458 #= 8 #() 9458 #hash 8 #() false nil nil 519 nil nil nil 13936 nil 8 1962103648 13714 nil nil nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[73 0 0 0 3 0 0 0 114 0 0 0 21 0 0 0] 193 13968 8 'C&lass' 13936 3 8 #() 1074 193 193 nil 27 8 'classMode' 11778 1074 21 7 1074 1 7 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 173 0 0 0 25 1 0 0 197 0 0 0] 193 13424 8 '' 13392 3 34 2 13504 13936 1074 193 193 nil 27 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 13312 34 2 8 1140850688 131073 14544 nil nil nil 31 nil nil nil 14544 818 ##(Smalltalk.MethodBrowser) #resource_Class_browser_method_list nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 0 0 0 0 25 1 0 0 173 0 0 0] 193 14576 8 '' 14544 3 1056 1074 193 193 nil 27 170 192 34 4 14544 8 'methods' 13392 8 'mode' nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[56 2 0 0 0 0 0 0 81 3 0 0 197 0 0 0] 193 13344 8 '' 13312 3 34 2 13392 14544 1074 193 193 nil 27 1074 193 193 nil 27 3008 3344 1074 193 193 nil 27 170 192 34 4 2384 8 'statusbar' 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 9 5954 nil true 34 10 6002 1 6034 #fileNew 8 '&New Workspace' 9373 1 6082 nil true 6128 8 'NewWorkspace.ico' 6176 nil nil 6002 1 6034 #fileOpen 8 '&Open Workspace...' 9375 1 6082 nil true 6128 8 'OpenWorkspace.ico' 6176 nil nil 6002 1 6034 #fileFileIn 8 '&File In...' 1 1 6082 nil true 6128 8 'FileIn.ico' 6176 nil nil 6322 4097 6002 1 6034 #browseExecutableManifest 8 'Open &Executable Manifest...' 1 1 6082 nil true 6128 8 'FileOpen.ico' 6176 nil nil 6322 4097 6002 1 6034 #saveImage 8 'Sa&ve Image' 1 1 6082 nil true 6128 8 'Snapshot.ico' 6176 nil nil 6002 1 6034 #smalltalkExit 8 'E&xit Dolphin' 1 1 6082 nil true 6128 8 'PowerSwitch.ico' 6176 nil nil 6322 4097 6002 1 6034 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 9361 nil nil 5954 nil true 34 13 6002 1 6034 #undo 8 '&Undo' 9397 1 6082 nil true 6128 8 'EditUndo.ico' 6176 nil nil 6322 4097 6002 1 6034 #cutSelection 8 'Cu&t' 9393 1 6082 nil true 6128 8 'EditCut.ico' 6176 nil nil 6002 1 6034 #copySelection 8 '&Copy' 9351 1 6082 nil true 6128 8 'EditCopy.ico' 6176 nil nil 6002 1 6034 #pasteClipboard 8 '&Paste' 9389 1 6082 nil true 6128 8 'EditPaste.ico' 6176 nil nil 6002 1 6034 #editDelete 8 '&Delete' 1 1 6082 nil true 6128 8 'EditClear.ico' 6176 nil nil 5954 nil true 34 2 6002 1 6034 #reformatSource 8 '&Source' 9391 1 nil nil nil 6002 1 6034 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 9377 nil nil 6322 4097 6002 1 6034 #selectAll 8 'Select &All' 9347 1 nil nil nil 6322 4097 6002 1 6034 #editFind 8 '&Find...' 9357 1 6082 nil true 6128 47 786694 ##(Smalltalk.ShellLibrary) nil nil 6002 1 6034 #findNext 8 'Find &Next' 1253 1 6082 nil true 6128 8 'FindNext.ico' 6176 nil nil 6002 1 6034 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 9387 nil nil 5954 nil true 34 15 6002 1 6034 #browseIt 8 '&Browse It' 9349 1 6082 nil true 6128 8 'ClassBrowserShell.ico' 6176 nil nil 6002 1 6034 #displayIt 8 '&Display It' 9353 1 6082 nil true 6128 8 'DisplayIt.ico' 6176 nil nil 6002 1 6034 #printIt 8 '&Print It' 9377 1 6082 nil true 6128 8 'PrintIt.ico' 6176 nil nil 6002 1 6034 #evaluateIt 8 '&Evaluate It' 9355 1 6082 nil true 6128 8 'EvaluateIt.ico' 6176 nil nil 6002 1 6034 #inspectIt 8 '&Inspect It' 9363 1 6082 nil true 6128 8 'InspectIt.ico' 6176 nil nil 6002 1 6034 #debugIt 8 'Deb&ug It' 1269 1 6082 nil true 6128 8 'Debugger.ico' 6176 nil nil 6002 1 6034 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 6322 4097 6002 1 6034 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 6002 1 6034 #browseReferences 8 '&References' 5367 1 nil nil nil 6322 4097 6002 2097153 6034 #accept 8 '&Accept' 9383 1 nil nil nil 6002 1 6034 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 6322 4097 5954 nil true 34 13 6002 1 6034 #renameVariable 8 'Re&name <1d>...' 1 1 6082 nil true 6128 8 'Rename.ico' 6176 nil nil 6322 4097 6002 1 6034 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 nil nil nil 6002 1 6034 #extractMethod 8 'E&xtract Method...' 9371 1 nil nil nil 6002 1 6034 #extractToComponent 8 'Extract to &Component...' 1 1 nil nil nil 6002 1 6034 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 6322 4097 6002 1 6034 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 6002 1 6034 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 6002 1 6034 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 6322 4097 6002 1 6034 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 6002 1 6034 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 6082 nil true 6128 8 'Refactoring.ico' 6176 nil 9431 nil nil 8 '&Workspace' nil 134217729 nil nil 9433 nil nil 5954 nil true 34 17 6002 2097153 6034 #findClass 8 'Find...' 1 1 6082 nil true 6128 8 'FindClass.ico' 6176 nil nil 5954 nil true 34 10 6002 1 6034 #browseClassPackage 8 'Package <1d>' 1 1 6082 nil true 6128 8 'Package.ico' 6176 nil nil 6322 4097 6002 2097153 6034 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 5954 nil true 8 #() 8 'Local Re&ferences To' #browseVariablesMenu 134217729 nil nil 9441 nil nil 6322 4097 6002 1 6034 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 6002 1 6034 #browseMethodHistoryForClass 8 'Method &History' 1 1 6082 nil true 6128 8 'MethodHistory.ico' 6176 nil nil 6322 4097 6002 1 6034 #browsePublishedEvents 8 'Published &events' 1 1 6082 nil true 6128 8 'Event.ico' 6176 nil nil 6002 1 6034 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil 9451 nil nil 6322 4097 6002 1 6034 #newClass 8 '&New...' 1 1 6082 nil true 6128 8 'NewClass.ico' 6176 nil nil 6002 1 6034 #deleteClassHierarchy 8 '&Delete' 1 1 6082 nil true 6128 8 'EditClear.ico' 6176 nil nil 5954 nil true 34 19 6002 1 6034 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 6002 2097153 6034 #renameClass 8 'Re&name...' 1 1 6082 nil true 6128 8 'Rename.ico' 6176 nil nil 6002 1 6034 #copyClass 8 'Cl&one...' 1 1 nil nil nil 6322 4097 6002 1 6034 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 6002 1 6034 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 5954 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil 9467 nil nil 5954 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil 9469 nil nil 6322 4097 5954 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil 9471 nil nil 5954 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil 9473 nil nil 6322 4097 5954 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil 9475 nil nil 5954 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil 9477 nil nil 5954 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil 9479 nil nil 6322 4097 6002 1 6034 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 6322 4097 6002 1 6034 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 6082 nil true 6128 8 'Refactoring.ico' 6176 nil 9485 nil nil 6322 4097 6002 1 6034 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 6002 1 6034 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 6322 4097 6002 1 6034 #fileInClass 8 'File &In...' 1 1 6082 nil true 6128 8 'FileIn.ico' 6176 nil nil 6002 1 6034 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 6322 4097 6002 1 6034 #classPackage 8 '&Package...' 1 1 6082 nil true 6128 8 'Package.ico' 6176 nil nil 6002 1 6034 #categorizeClass 8 '&Category...' 1 1 6082 nil true 6128 8 'Category.ico' 6176 nil nil 6322 4097 5954 nil true 34 4 6002 1 6034 #newView 8 '&New...' 1 1 nil nil nil 6322 4097 5954 nil true 8 #() 8 '&Edit' #viewsEditMenu 134217729 6082 nil true 6128 8 'ViewComposer.ico' 6176 nil 9501 nil nil 5954 nil true 8 #() 8 '&Show' #viewsShowMenu 1 6082 nil true 6128 8 'TestView.ico' 6176 nil 9503 nil nil 8 '&Views' #viewsMenu 134217729 6082 nil true 6128 8 'View.ico' 6176 nil 9505 nil nil 8 '&Class' nil 134217729 nil nil 9507 nil nil 5954 nil true 34 15 5954 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 9509 nil nil 5954 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 9511 nil nil 5954 nil true 34 16 6002 1 6034 #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 6002 1 6034 #browseContainingText 8 'C&ontaining Text...' 1 1 6082 nil true 6128 8 'SearchText.ico' 6176 nil nil 6002 1 6034 #browseMethodCategory 8 'Cate&gory...' 1 1 6082 nil true 6128 8 'Category.ico' 6176 nil nil 6002 1 6034 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 6002 1 6034 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 6322 4097 6002 1 6034 #browseMethodPackages 8 '&Package <s>' 1 1 6082 nil true 6128 8 'Package.ico' 6176 nil nil 6002 1 6034 #browseMethodClasses 8 'C&lass <s>' 1 1 nil nil nil 6322 4097 6002 1 6034 #browseMethodHistory 8 '&Change History' 1 1 6082 nil true 6128 8 'MethodHistory.ico' 6176 nil nil 6002 1 6034 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 6322 4097 6002 1 6034 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 6002 1 6034 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 6322 4097 6002 1 6034 #browseUnimplemented 8 'All U&nimplemented' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 9537 nil nil 6322 4097 6002 1 6034 #newMethod 8 '&New' 1 1 6082 nil true 6128 8 'NewMethod.ico' 6176 nil nil 6002 1 6034 #removeMethod 8 '&Delete' 1 1 6082 nil true 6128 8 'EditClear.ico' 6176 nil nil 5954 nil true 34 17 6002 1 6034 #renameMethod 8 'Re&name' 1 1 nil nil nil 6002 1 6034 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 6002 1 6034 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 6322 4097 6002 1 6034 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 5954 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 9551 nil nil 5954 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 9553 nil nil 5954 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 9555 nil nil 6322 4097 5954 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 9557 nil nil 5954 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 9559 nil nil 6322 4097 6002 1 6034 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 6002 1 6034 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 6002 1 6034 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 6002 1 6034 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 6002 1 6034 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 6082 nil true 6128 8 'Refactoring.ico' 6176 nil 9571 nil nil 6322 4097 6002 1 6034 #methodPackage 8 '&Package...' 1 1 6082 nil true 6128 8 'Package.ico' 6176 nil nil 5954 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 9575 nil nil 5954 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 9577 nil nil 6002 1 6034 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 6322 4097 6002 1 6034 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 6002 1 6034 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 9585 nil nil 5954 nil true 34 7 6002 1 6034 #undoChange 8 '&Undo <1d>' 1 1 6082 nil true 6128 8 'EditUndo.ico' 6176 nil nil 6002 1 6034 #redoChange 8 '&Redo <1d>' 1 1 6082 nil true 6128 8 'EditRedo.ico' 6176 nil nil 6002 1 6034 #clearChangeHistory 8 'Clear Change &History' 1 1 6082 nil true 6128 8 'MethodHistoryErase.ico' 6176 nil nil 6322 4097 6002 1 6034 #historyBack 8 'Back to <1d>' 1 1 6082 nil true 6128 8 'HistoryBack.ico' 6176 nil nil 6002 1 6034 #historyForward 8 'Forward to <1d>' 1 1 6082 nil true 6128 8 'HistoryForward.ico' 6176 nil nil 6002 1 6034 #historyClear 8 'Clear Visit History' 1 1 6082 nil true 6128 8 'HistoryErase.ico' 6176 nil nil 8 'H&istory' nil 134217729 nil nil 9599 nil nil 5954 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 9601 nil nil 5954 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 9603 nil nil 5954 nil true 34 15 6002 1 6034 #helpContents 8 '&Contents' 1025 1 6082 nil true 6128 8 'Help.ico' 6176 nil nil 6002 1 6034 #help 8 'On this &Tool' 1249 1 nil nil nil 6002 1 6034 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 6322 4097 6002 1 6034 #learnSmalltalk 8 'Learn Smalltalk' 1 1 15778 $\x1F393 nil 674 #orchid 674 #white nil nil 1 nil nil nil nil 6322 4097 6002 1 6034 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 6002 1 6034 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 6002 1 6034 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 6322 4097 6002 1 6034 #dolphinHomePage 8 'Dolphin Homepage' 1 1 6082 nil true 6128 8 '!!APPLICATION' 6176 nil nil 6002 1 6034 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 6002 1 6034 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 6322 4097 6002 1 6034 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 15778 $\x1F42C nil nil 674 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 9627 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[255 9 0 0 10 0 0 0 96 13 0 0 3 2 0 0] 193 448 8 '' 416 1 34 3 528 2848 2384 1074 193 193 nil 27 )!

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

!EnvironmentBrowserShell class categoriesForMethods!
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
initializeTool!initializing!private! !
onEnvironment:!instance creation!public! !
resource_Default_view!public!resources-views! !
toolDescription!constants!public! !
toolsFolderHelpId!constants!public! !
toolsFolderIcon!constants!public! !
!

