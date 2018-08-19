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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 565 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 28 198 63 1 0 0 204 53 63 1 3 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point) 193 193 nil 528 786694 ##(Smalltalk.ColorDefault) 8 4278190080 8 1906044272 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 800 nil nil nil 7 nil nil nil 800 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Image_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 1 1 674 63 51 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1136 nil nil nil 7 nil nil nil 1136 866 ##(Smalltalk.Toolbar) #resource_Class_browser_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 247 51 674 261 51 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 123 0 0 0 25 0 0 0 253 0 0 0 50 0 0 0] 1088 1104 nil 27 8 'classBrowserTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1376 nil nil nil 7 nil nil nil 1376 866 ##(Smalltalk.Toolbar) #resource_Edit_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 51 674 247 51 1376 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 1088 1104 nil 27 8 'editTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1616 nil nil nil 7 nil nil nil 1616 866 ##(Smalltalk.Toolbar) #resource_Search_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 615 1 674 437 51 1616 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 1088 1104 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1856 nil nil nil 7 nil nil nil 1856 866 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 63 1 674 553 51 1856 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 1088 1104 nil 27 8 'smalltalkTools' 170 192 1088 138 144 1088 nil nil 1 nil 674 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 898 138 144 34 2 962 #createAt:extent: 34 2 674 1 1 674 1169 101 528 962 #updateSizePosted 1088 528 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 50 0 0 0] 34 5 800 1856 1616 1376 1136 1104 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140853004 1 2352 nil nil nil 7 nil 594 nil true 626 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 674 193 193 nil 2352 nil 8 1905776576 170 192 34 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 2352 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'message' 2530 1 501 2352 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2576 8 'packageOfSelection' 34 2 2608 2544 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2352 nil nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 643 674 1169 41 2352 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 8 #() 1104 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2848 nil nil nil 7 nil nil nil 2848 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 2848 34 2 8 1140850688 1 3008 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3008 nil 1 #left nil nil nil 674 1 1 674 9 9 nil 3104 nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 267 674 1169 11 3008 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 133 0 0 0 72 2 0 0 138 0 0 0] 8 #() 1104 nil 27 1 true 170 192 34 2 410 ##(Smalltalk.CardContainer) 34 16 nil 2848 34 2 8 1140850688 131073 3328 nil nil nil 7 nil nil nil 3328 655878 ##(Smalltalk.CardLayout) 138 144 34 2 2978 590662 1 ##(Smalltalk.CardLabel) 8 'Method Source' 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 7 1 3472 8 'doIt' 8 '(CardLabel text: ''Method Source'' iconBlock: [Icon fromId: ''MethodSource.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 983558 ##(Smalltalk.VariableBinding) #CardLabel 3472 3504 3634 #Icon ##(Smalltalk.Icon) 8 'MethodSource.ico' #fromId: #text:iconBlock: 3536 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 3328 34 2 8 1140850688 131073 3696 nil nil nil 5 nil nil nil 3696 866 ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 9 53 674 1153 207 3696 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 68 2 0 0 129 0 0 0] 1088 1104 nil 27 2978 3474 8 'Class definition' 3522 0 nil 3554 7 1 3472 8 'doIt' 8 '(CardLabel text: ''Class definition'' iconBlock: [Icon fromId: ''ClassDefinition.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 3648 3952 3664 8 'ClassDefinition.ico' #fromId: #text:iconBlock: 3968 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 3328 34 2 8 1140916224 131073 4064 nil 720 nil 23 nil nil nil 4064 866 ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 9 53 674 1153 207 4064 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 68 2 0 0 129 0 0 0] 1088 1104 nil 27 4064 170 192 34 4 3696 8 'source' 4064 8 'definition' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 3328 34 2 8 1140916736 1 4352 590662 2 ##(Smalltalk.ListModel) 138 144 34 2 3488 3936 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 1 nil nil nil 4352 nil 8 1905866672 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2576 nil nil nil nil nil #smallIcons nil nil nil nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 674 1 1 674 1169 267 4352 962 #basicSelectionsByIndex: 34 1 8 #(2) 4352 962 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4352 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 133 0 0 0] 8 #() 1104 nil 27 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 277 674 1169 267 3328 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 138 0 0 0 72 2 0 0 15 1 0 0] 34 3 3696 4064 4352 1104 nil 27 8 'cards' nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 101 674 1169 543 2848 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 72 2 0 0 65 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2848 34 2 8 1140850688 131073 5104 nil nil nil 7 nil nil nil 5104 2914 138 ##(Smalltalk.Dictionary) 34 2 2978 410 ##(Smalltalk.Splitter) 34 12 nil 5104 34 2 8 1140850688 1 5232 nil nil nil 519 nil nil nil 3074 5232 nil 1 #left nil nil nil 3104 3120 nil 3104 nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 775 1 674 11 267 5232 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 131 1 0 0 0 0 0 0 136 1 0 0 133 0 0 0] 8 #() 1104 nil 27 1 2978 410 ##(Smalltalk.Splitter) 34 12 nil 5104 34 2 8 1140850688 1 5488 nil nil nil 519 nil nil nil 3074 5488 nil 1 #left nil nil nil 3104 3120 nil 3104 nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 383 1 674 11 267 5488 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 0 0 0 0 0 0 0 196 0 0 0 133 0 0 0] 8 #() 1104 nil 27 1 false 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 5104 34 2 8 1140850688 131073 5760 nil nil nil 31 265030 4 ##(Smalltalk.Menu) nil true 34 17 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 5826 nil true 34 10 5874 1 5906 #browseClassPackage 8 'Package <1d>' 1 1 5954 nil true 6000 8 'Package.ico' 6048 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 5874 2097153 5906 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 5826 nil true 8 #() 8 'Local Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 6194 4097 5874 1 5906 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 5874 1 5906 #browseMethodHistoryForClass 8 'Method &History' 1 1 nil nil nil 6194 4097 5874 1 5906 #browsePublishedEvents 8 'Published &events' 1 1 nil nil nil 5874 1 5906 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 6194 4097 5874 1 5906 #newClass 8 '&New...' 1 1 5954 nil true 6000 8 'NewClass.ico' 6048 nil nil 5874 1 5906 #deleteClassHierarchy 8 '&Delete' 1 1 5954 nil true 6000 8 'EditClear.ico' 6048 nil nil 5826 nil true 34 18 5874 1 5906 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 5874 2097153 5906 #renameClass 8 'Re&name...' 1 1 nil nil nil 6194 4097 5874 1 5906 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 5874 1 5906 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 5826 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 5826 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 6194 4097 5826 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 5826 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 6194 4097 5826 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 5826 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 5826 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 6194 4097 5874 1 5906 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 6194 4097 5874 1 5906 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 5954 nil true 6000 8 'Refactoring.ico' 6048 nil nil nil nil 6194 4097 5874 1 5906 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 5874 1 5906 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 6194 4097 5874 1 5906 #fileInClass 8 'File &In...' 1 1 nil nil nil 5874 1 5906 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 6194 4097 5874 1 5906 #classPackage 8 '&Package...' 1 1 5954 nil true 6000 8 'Package.ico' 6048 nil nil 5874 1 5906 #categorizeClass 8 '&Category...' 1 1 nil nil nil 6194 4097 5826 nil true 34 4 5874 1 5906 #newView 8 '&New...' 1 1 nil nil nil 6194 4097 5826 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 nil nil nil nil nil 5826 nil true 8 #() 8 '&Show' #viewsShowMenu 1 nil nil nil nil nil 8 '&Views' #viewsMenu 1 5954 nil true 6000 8 'View.ico' 6048 nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 5760 866 ##(Smalltalk.ClassListSelector) #resource_Default_view nil 898 138 144 34 2 962 #createAt:extent: 34 2 674 1 1 674 383 267 5760 962 #contextMenu: 34 1 5840 5760 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 191 0 0 0 133 0 0 0] 1088 1104 nil 27 8 'classes' 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 5104 34 2 8 1140850688 131073 8368 nil nil nil 519 nil nil nil 8368 3394 138 144 34 3 2978 3474 8 'Categories' 3522 0 nil 3554 3 1 3520 8 'doIt' 8 '[MethodCategory icon]
' 8 #[31 105 45 159 106] 3634 #MethodCategory ##(Smalltalk.MethodCategory) #icon 8528 7 1 nil 21481 410 ##(Smalltalk.TreeView) 34 27 nil 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 8368 34 2 8 1140850688 131073 8656 nil nil nil 7 nil nil nil 8656 8432 170 192 34 6 410 ##(Smalltalk.ListView) 34 30 nil 8656 34 2 8 1140936777 1 8752 4418 138 144 1088 nil 4496 720 nil 29 5826 nil true 34 7 5874 1 5906 #browseSelectorsInProtocol 8 '&Selectors' 1 1 nil nil nil 5874 1 5906 #toggleProtocolReadOnly 8 '&Read Only' 1 1 nil nil nil 6194 4097 5874 1 5906 #addMethodProtocol 8 '&Add...' 1 1 nil nil nil 5826 nil true 34 2 5874 1 5906 #removeMethodProtocol 8 'Protocol' 1 1 nil nil nil 5874 1 5906 #removeMethodsInProtocol 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 5874 1 5906 #renameMethodProtocol 8 'Rename...' 1 1 nil nil nil 5874 1 5906 #browseMethodProtocol 8 'Browse' 1 1 nil nil nil 8 'Protocols' nil 134217729 nil nil nil nil nil nil nil 8752 nil 8 1906050064 459270 ##(Smalltalk.Message) #name 8 #() ##(Smalltalk.IconicListAbstract) 2576 nil nil 3522 0 nil 3554 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 9360 7 257 nil 674 65 65 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Protocols' 215 #left 9314 #name 8 #() ##(Smalltalk.SortedCollection) nil nil 8752 nil 3 nil 3522 0 nil 3554 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 9568 7 257 nil #report 1088 nil 133217 nil 34 4 nil nil 674 1 1 nil 898 138 144 34 3 962 #createAt:extent: 34 2 674 1 37 674 223 215 8752 962 #contextMenu: 34 1 8848 8752 962 #text: 34 1 8 'Protocols' 8752 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 111 0 0 0 125 0 0 0] 8 #() 1104 nil 27 8 'protocols' 410 ##(Smalltalk.ListView) 34 30 nil 8656 34 2 8 1140920395 1 9936 4418 138 144 1088 nil 4496 720 nil 13 5826 nil true 34 10 5874 2097153 5906 #browseInstVarReferences 8 'Browse &References' 1 1 nil nil nil 6194 4097 5874 1 5906 #addInstanceVariable 8 '&Add...' 1 1 nil nil nil 5874 1 5906 #removeInstanceVariables 8 'Remo&ve' 1 1 nil nil nil 5874 1 5906 #renameInstanceVariable 8 'Re&name' 1 1 nil nil nil 6194 4097 5874 1 5906 #pushDownInstanceVariables 8 'Push &Down' 1 1 nil nil nil 5874 1 5906 #createAccessors 8 '&Create Accessors' 1 1 nil nil nil 5874 1 5906 #abstractInstanceVariables 8 'Ab&stract' 1 1 nil nil nil 5874 1 5906 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 9936 nil 8 1906050064 9314 #value 8 #() 3522 0 nil 3554 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] #key #icon #imageIndex 10528 7 257 nil 2576 nil 3522 0 nil 3554 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] #key #name 8 '.' #, 10608 7 257 nil nil 674 65 65 nil nil 138 144 34 1 9490 8 '' 201 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) nil nil 9936 nil 1 nil nil #list 1088 nil 133217 nil 34 4 nil nil 674 1 1 nil 898 138 144 34 2 962 #createAt:extent: 34 2 674 1 37 674 223 215 9936 962 #contextMenu: 34 1 10032 9936 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 111 0 0 0 125 0 0 0] 8 #() 1104 nil 27 8 'variables' 8624 8 'categories' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 8368 34 2 8 1140916864 1 11040 4418 138 144 34 3 8496 3474 8 'Protocols' 3522 0 nil 3554 6 1 16 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 3634 #CardLabel 3472 11168 3634 #MethodProtocol ##(Smalltalk.MethodProtocol) #icon #text:iconBlock: 11184 11 1 nil 21487 3474 8 'Variables' nil 21491 nil 4496 nil nil 1 nil nil nil 11040 nil 8 1905866672 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2576 nil nil nil nil nil #smallIcons nil nil nil nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 674 1 1 674 383 267 11040 962 #basicSelectionsByIndex: 34 1 8 #(1) 11040 962 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 11040 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 191 0 0 0 133 0 0 0] 8 #() 1104 nil 27 nil 8368 674 33 33 1050182 1 ##(Smalltalk.ButtonInteractor) 8656 nil 1 590342 ##(Smalltalk.Rectangle) 674 187 3 674 219 35 nil 5906 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 153 9 674 223 251 8656 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 0 0 0 4 0 0 0 187 0 0 0 129 0 0 0] 34 3 8624 8752 9936 1104 nil 27 34 2 8 1140916771 1 8624 590918 3 ##(Smalltalk.TreeModel) nil 4496 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 1088 720 nil 31 5826 nil true 34 4 5874 1 5906 #addMethodCategory 8 '&Add...' 1 1 nil nil nil 5826 nil true 34 2 5874 1 5906 #removeMethodCategory 8 'Category' 1 1 nil nil nil 5874 1 5906 #removeMethodsInCategory 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 5874 1 5906 #renameMethodCategory 8 'Rename...' 1 1 nil nil nil 5874 1 5906 #browseMethodCategory 8 'Browse' 1 1 nil nil nil 8 'Categories' nil 134217729 nil nil nil nil nil nil nil 8624 nil 8 1905908752 9314 #localName 8 #() ##(Smalltalk.IconicListAbstract) 2576 nil nil 3522 0 nil 3554 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawCategoryTree: 12384 7 257 nil nil nil 170 176 1088 17 #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 1088 898 138 144 34 2 962 #createAt:extent: 34 2 674 1 37 674 223 215 8624 962 #contextMenu: 34 1 12000 8624 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 111 0 0 0 125 0 0 0] 8 #() 1104 nil 27 2978 11152 8752 2978 11296 9936 8624 170 192 34 2 8656 8 'filters' nil 11040 8656 674 201 201 401 1 524319 nil nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 393 1 674 383 267 8368 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 196 0 0 0 0 0 0 0 131 1 0 0 133 0 0 0] 34 2 8656 11040 1104 nil 27 8 'filtersSlidey' nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 1 674 1169 267 5104 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 133 0 0 0] 34 5 5760 5488 8368 5232 410 ##(Smalltalk.ContainerView) 34 15 nil 5104 34 2 8 1140850688 131073 13120 nil nil nil 7 nil nil nil 13120 498 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 13120 34 2 8 1140850688 131073 13200 nil nil nil 535 nil nil nil 13200 2146 11 1 1 170 192 34 4 410 ##(Smalltalk.RadioButton) 34 16 nil 13200 34 2 8 1141055497 1 13312 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 9314 #= 8 #() 9314 #hash 8 #() false nil nil 7 nil nil nil 13312 nil 8 1905974928 852486 ##(Smalltalk.NullConverter) nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 674 21 1 674 131 51 13312 962 #text: 34 1 8 'In&stance' 13312 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 75 0 0 0 25 0 0 0] 8 #() 1104 nil 27 8 'instanceMode' 410 ##(Smalltalk.RadioButton) 34 16 nil 13200 34 2 8 1141055497 1 13776 13378 nil nil 13410 9314 #= 8 #() 9314 #hash 8 #() false nil nil 7 nil nil nil 13776 nil 8 1905974928 13522 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 674 161 1 674 111 51 13776 962 #text: 34 1 8 'C&lass' 13776 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 0 0 0 0 135 0 0 0 25 0 0 0] 8 #() 1104 nil 27 8 'classMode' 11634 674 21 1 674 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 217 674 385 51 13200 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 108 0 0 0 192 0 0 0 133 0 0 0] 34 2 13312 13776 1104 nil 27 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 13120 34 2 8 1140850688 131073 14400 nil nil nil 31 nil nil nil 14400 866 ##(Smalltalk.MethodBrowser) #resource_Class_browser_method_list nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 1 674 385 217 14400 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 192 0 0 0 108 0 0 0] 1088 1104 nil 27 170 192 34 4 13200 8 'mode' 14400 8 'methods' nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 785 1 674 385 267 13120 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 0 0 0 0 72 2 0 0 133 0 0 0] 34 2 13200 14400 1104 nil 27 1104 nil 27 3008 3328 1104 nil 27 170 192 34 4 528 8 'toolbar' 2352 8 'statusbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 9 5826 nil true 34 10 5874 1 5906 #fileNew 8 '&New Workspace' 9373 1 5954 nil true 6000 8 'NewWorkspace.ico' 6048 nil nil 5874 1 5906 #fileOpen 8 '&Open Workspace...' 9375 1 5954 nil true 6000 8 'OpenWorkspace.ico' 6048 nil nil 5874 1 5906 #fileFileIn 8 '&File In...' 1 1 5954 nil true 6000 8 'FileIn.ico' 6048 nil nil 6194 4097 5874 1 5906 #browseExecutableManifest 8 'Open &Executable Manifest...' 1 1 5954 nil true 6000 8 'FileOpen.ico' 6048 nil nil 6194 4097 5874 1 5906 #saveImage 8 'Sa&ve Image' 1 1 5954 nil true 6000 8 'Snapshot.ico' 6048 nil nil 5874 1 5906 #smalltalkExit 8 'E&xit Dolphin' 1 1 5954 nil true 6000 8 'PowerSwitch.ico' 6048 nil nil 6194 4097 5874 1 5906 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 15283 nil nil 5826 nil true 34 13 5874 1 5906 #undo 8 '&Undo' 9397 1 5954 nil true 6000 8 'EditUndo.ico' 6048 nil nil 6194 4097 5874 1 5906 #cutSelection 8 'Cu&t' 9393 1 5954 nil true 6000 8 'EditCut.ico' 6048 nil nil 5874 1 5906 #copySelection 8 '&Copy' 9351 1 5954 nil true 6000 8 'EditCopy.ico' 6048 nil nil 5874 1 5906 #pasteClipboard 8 '&Paste' 9389 1 5954 nil true 6000 8 'EditPaste.ico' 6048 nil nil 5874 1 5906 #editDelete 8 '&Delete' 1 1 5954 nil true 6000 8 'EditClear.ico' 6048 nil nil 5826 nil true 34 2 5874 1 5906 #reformatSource 8 '&Source' 9391 1 nil nil nil 5874 1 5906 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 15299 nil nil 6194 4097 5874 1 5906 #selectAll 8 'Select &All' 9347 1 nil nil nil 6194 4097 5874 1 5906 #editFind 8 '&Find...' 9357 1 5954 nil true 6000 47 786694 ##(Smalltalk.ShellLibrary) nil nil 5874 1 5906 #findNext 8 'Find &Next' 1253 1 5954 nil true 6000 8 'FindNext.ico' 6048 nil nil 5874 1 5906 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 15309 nil nil 5826 nil true 34 14 5874 1 5906 #browseIt 8 '&Browse It' 9349 1 5954 nil true 6000 8 'ClassBrowserShell.ico' 6048 nil nil 5874 1 5906 #displayIt 8 '&Display It' 9353 1 5954 nil true 6000 8 'DisplayIt.ico' 6048 nil nil 5874 1 5906 #evaluateIt 8 '&Evaluate It' 9355 1 5954 nil true 6000 8 'EvaluateIt.ico' 6048 nil nil 5874 1 5906 #inspectIt 8 '&Inspect It' 9363 1 5954 nil true 6000 8 'InspectIt.ico' 6048 nil nil 5874 1 5906 #debugIt 8 'Deb&ug It' 1269 1 5954 nil true 6000 8 'Debugger.ico' 6048 nil nil 5874 1 5906 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 6194 4097 5874 1 5906 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 5874 1 5906 #browseReferences 8 '&References' 5367 1 nil nil nil 6194 4097 5874 2097153 5906 #accept 8 '&Accept' 9383 1 nil nil nil 5874 1 5906 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 6194 4097 5826 nil true 34 13 5874 1 5906 #renameVariable 8 'Re&name <1d>...' 1 1 5954 nil true 6000 8 'Rename.ico' 6048 nil nil 6194 4097 5874 1 5906 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 nil nil nil 5874 1 5906 #extractMethod 8 'E&xtract Method...' 9371 1 nil nil nil 5874 1 5906 #extractToComponent 8 'Extract to &Component...' 1 1 nil nil nil 5874 1 5906 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 6194 4097 5874 1 5906 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 5874 1 5906 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 5874 1 5906 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 6194 4097 5874 1 5906 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 5874 1 5906 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 5954 nil true 6000 8 'Refactoring.ico' 6048 nil 15351 nil nil 8 '&Workspace' nil 134217729 nil nil 15353 nil nil 5826 nil true 34 17 5874 2097153 5906 #findClass 8 'Find...' 1 1 5954 nil true 6000 8 'FindClass.ico' 6048 nil nil 5826 nil true 34 10 5874 1 5906 #browseClassPackage 8 'Package <1d>' 1 1 5954 nil true 6000 8 'Package.ico' 6048 nil nil 6194 4097 5874 2097153 5906 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 5826 nil true 8 #() 8 'Local Re&ferences To' #browseVariablesMenu 134217729 nil nil 15361 nil nil 6194 4097 5874 1 5906 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 5874 1 5906 #browseMethodHistoryForClass 8 'Method &History' 1 1 5954 nil true 6000 8 'MethodHistory.ico' 6048 nil nil 6194 4097 5874 1 5906 #browsePublishedEvents 8 'Published &events' 1 1 5954 nil true 6000 8 'Event.ico' 6048 nil nil 5874 1 5906 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil 15371 nil nil 6194 4097 5874 1 5906 #newClass 8 '&New...' 1 1 5954 nil true 6000 8 'NewClass.ico' 6048 nil nil 5874 1 5906 #deleteClassHierarchy 8 '&Delete' 1 1 5954 nil true 6000 8 'EditClear.ico' 6048 nil nil 5826 nil true 34 19 5874 1 5906 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 5874 2097153 5906 #renameClass 8 'Re&name...' 1 1 5954 nil true 6000 8 'Rename.ico' 6048 nil nil 5874 1 5906 #copyClass 8 'Cl&one...' 1 1 nil nil nil 6194 4097 5874 1 5906 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 5874 1 5906 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 5826 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil 15387 nil nil 5826 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil 15389 nil nil 6194 4097 5826 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil 15391 nil nil 5826 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil 15393 nil nil 6194 4097 5826 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil 15395 nil nil 5826 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil 15397 nil nil 5826 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil 15399 nil nil 6194 4097 5874 1 5906 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 6194 4097 5874 1 5906 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 5954 nil true 6000 8 'Refactoring.ico' 6048 nil 15405 nil nil 6194 4097 5874 1 5906 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 5874 1 5906 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 6194 4097 5874 1 5906 #fileInClass 8 'File &In...' 1 1 5954 nil true 6000 8 'FileIn.ico' 6048 nil nil 5874 1 5906 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 6194 4097 5874 1 5906 #classPackage 8 '&Package...' 1 1 5954 nil true 6000 8 'Package.ico' 6048 nil nil 5874 1 5906 #categorizeClass 8 '&Category...' 1 1 5954 nil true 6000 8 'Category.ico' 6048 nil nil 6194 4097 5826 nil true 34 4 5874 1 5906 #newView 8 '&New...' 1 1 nil nil nil 6194 4097 5826 nil true 8 #() 8 '&Edit' #viewsEditMenu 134217729 5954 nil true 6000 8 'ViewComposer.ico' 6048 nil 15421 nil nil 5826 nil true 8 #() 8 '&Show' #viewsShowMenu 1 5954 nil true 6000 8 'TestView.ico' 6048 nil 15423 nil nil 8 '&Views' #viewsMenu 134217729 5954 nil true 6000 8 'View.ico' 6048 nil 15425 nil nil 8 '&Class' nil 134217729 nil nil 15427 nil nil 5826 nil true 34 15 5826 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 15429 nil nil 5826 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 15431 nil nil 5826 nil true 34 14 5874 1 5906 #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 5874 1 5906 #browseContainingText 8 'C&ontaining Text...' 1 1 5954 nil true 6000 8 'SearchText.ico' 6048 nil nil 5874 1 5906 #browseMethodCategory 8 'Cate&gory...' 1 1 5954 nil true 6000 8 'Category.ico' 6048 nil nil 5874 1 5906 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 5874 1 5906 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 6194 4097 5874 1 5906 #browseMethodPackages 8 'Package <s>' 1 1 5954 nil true 6000 8 'Package.ico' 6048 nil nil 5874 1 5906 #browseMethodClasses 8 'Class <s>' 1 1 nil nil nil 6194 4097 5874 1 5906 #browseMethodHistory 8 '&Change History' 1 1 5954 nil true 6000 8 'MethodHistory.ico' 6048 nil nil 5874 1 5906 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 6194 4097 5874 1 5906 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 5874 1 5906 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 15455 nil nil 6194 4097 5874 1 5906 #newMethod 8 '&New' 1 1 5954 nil true 6000 8 'NewMethod.ico' 6048 nil nil 5874 1 5906 #removeMethod 8 '&Delete' 1 1 5954 nil true 6000 8 'EditClear.ico' 6048 nil nil 5826 nil true 34 17 5874 1 5906 #renameMethod 8 'Re&name' 1 1 nil nil nil 5874 1 5906 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 5874 1 5906 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 6194 4097 5874 1 5906 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 5826 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 15469 nil nil 5826 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 15471 nil nil 5826 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 15473 nil nil 6194 4097 5826 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 15475 nil nil 5826 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 15477 nil nil 6194 4097 5874 1 5906 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 5874 1 5906 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 5874 1 5906 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 5874 1 5906 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 5874 1 5906 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 5954 nil true 6000 8 'Refactoring.ico' 6048 nil 15489 nil nil 6194 4097 5874 1 5906 #methodPackage 8 '&Package...' 1 1 5954 nil true 6000 8 'Package.ico' 6048 nil nil 5826 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 15493 nil nil 5826 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 15495 nil nil 5874 1 5906 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 6194 4097 5874 1 5906 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 5874 1 5906 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 15503 nil nil 5826 nil true 34 7 5874 1 5906 #undoChange 8 '&Undo <1d>' 1 1 5954 nil true 6000 8 'EditUndo.ico' 6048 nil nil 5874 1 5906 #redoChange 8 '&Redo <1d>' 1 1 5954 nil true 6000 8 'EditRedo.ico' 6048 nil nil 5874 1 5906 #clearChangeHistory 8 'Clear Change &History' 1 1 5954 nil true 6000 8 'MethodHistoryErase.ico' 6048 nil nil 6194 4097 5874 1 5906 #historyBack 8 'Back to <1d>' 1 1 5954 nil true 6000 8 'HistoryBack.ico' 6048 nil nil 5874 1 5906 #historyForward 8 'Forward to <1d>' 1 1 5954 nil true 6000 8 'HistoryForward.ico' 6048 nil nil 5874 1 5906 #historyClear 8 'Clear Visit History' 1 1 5954 nil true 6000 8 'HistoryErase.ico' 6048 nil nil 8 'H&istory' nil 134217729 nil nil 15517 nil nil 5826 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 15519 nil nil 5826 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 15521 nil nil 5826 nil true 34 15 5874 1 5906 #helpContents 8 '&Contents' 1025 1 5954 nil true 6000 8 'Help.ico' 6048 nil nil 5874 1 5906 #help 8 'On this &Tool' 1249 1 nil nil nil 5874 1 5906 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 6194 4097 5874 1 5906 #learnSmalltalk 8 'Learn Smalltalk' 1 1 15570 $\x1F393 nil 262406 ##(Smalltalk.ARGB) 8 4292695180 786694 ##(Smalltalk.IndexedColor) 33554471 nil nil 1 nil nil nil nil 6194 4097 5874 1 5906 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 5874 1 5906 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 5874 1 5906 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 6194 4097 5874 1 5906 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 5954 nil true 6000 8 '!!APPLICATION' 6048 nil nil 5874 1 5906 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 5874 1 5906 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 6194 4097 5874 1 5906 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 15570 $\x1F42C nil nil 196934 1 ##(Smalltalk.RGB) 17741887 nil nil 1 nil nil nil nil 8 '&Help' nil 134217729 nil nil 15545 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 674 3839 21 674 1201 801 416 962 #updateMenuBar 1088 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 3 528 2848 2352 1104 nil 27 )!

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

