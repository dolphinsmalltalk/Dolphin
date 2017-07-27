"Filed out from Dolphin Smalltalk 7"!

ClassBrowserAbstract subclass: #SystemBrowserShell
	instanceVariableNames: ''
	classVariableNames: 'AutoSelectPackages'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SystemBrowserShell guid: (GUID fromString: '{4e96e0df-9db3-4d86-89d0-91d646c5209f}')!
SystemBrowserShell comment: 'SystemBrowserShell is a <SmalltalkToolShell> implementing the System Browser development tool. It displays a view of the system that allows for the filtering of classes by package ownership. Please note the System Browser is NOT intended to display unpackaged classes. Unpackaged classes can only be viewed and edited in the Class Hierarchy Browser (see <ClassBrowserShell>).

Class Variables:
	AutoSelectPackages		<Boolean>. Controls whether the packages in a folder are automatically selected when a new folder is selected (the default).

'!
!SystemBrowserShell categoriesForClass!Development! !
!SystemBrowserShell methodsFor!

canSaveMethod
	"We allow a method to be saved even if there is no class selected, as this is a handy way 
	to allow loose methods on new classes to be defined (though a separate prompt is needed 
	for the class)."

	^self hasMethodSelected 
		ifTrue: [self isEditableMethod: self method]
		ifFalse: [self hasClassSelected or: [self packages size = 1]]!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	classesPresenter := self add: PackagedClassSelector new name: 'classes'.
	classesPresenter packagesPresenter helpId: 10755.
	classesPresenter classesPresenter classesListPresenter helpId: 10754.
	classesPresenter classesPresenter helpId: 10500.
	classesPresenter autoSelectPackages: self class autoSelectPackages!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	classesPresenter
		when: #packageSelected
			send: #onPackageSelected
			to: self
!

hasPackageSelected
	"Answer true if the receiver has a single (i.e. not multiple) package selected"

	^self packages size=1!

isEditableMethod: aCompiledMethod
	"Answer true if aCompiledMethod should be judged as being editable"

	^(self isInheritedMethod: aCompiledMethod) not
		and: [self packages includes: aCompiledMethod owningPackage]!

onPackageSelected
	"Private - The method selected within the receiver has changed"

	self onClassSelected.
	self trigger: #packageSelected!

packageForNewMethod
	| packages |
	packages := self packages.
	^packages size = 1 ifTrue: [packages first] ifFalse: [super packageForNewMethod]!

packageNames
	"Answer the <Array> of package names selected in the receiver"

	^self packages collect: [:each | each name]!

packages
	"Answer the <Array> of packages selected in the receiver"

	^classesPresenter packages!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver into the 
	<CommandQuery>."

	| command |
	command := aCommandQuery commandSymbol.
	#forgetSize == command 
		ifTrue: 
			[aCommandQuery isEnabled: self class defaultExtent notNil.
			^true].
	command == #historyBack 
		ifTrue: 
			[aCommandQuery isEnabled: self hasPast.
			^true].
	command == #historyForward 
		ifTrue: 
			[aCommandQuery isEnabled: self hasFuture.
			^true].
	^super queryCommand: aCommandQuery!

resetForFoundClass: aClass 
	"Private - Reset the receiver to place it into a state required to display aClass
	that has just been searched for. This should first navigate the receiver 
	to the class's owning package."

	| package |
	package := aClass owningPackage.
	package isNil ifTrue: [^self].
	(self packages includes: package) ifFalse: [self packages: (Array with: package)].
	super resetForFoundClass: aClass!

saveStateOn: aWriteStream 
	"Private - Write the source of a monadic block that will configure an instance of the receiver's class
	to match the state current receiver, to aWriteStream. The block expects a fresh instance of
	the receiver's class as it's parameter"

	aWriteStream nextPutAll: '[:aSystemBrowser | '.
	self 
		saveStateAspects: #(#packageNames)
		for: 'aSystemBrowser'
		on: aWriteStream.
	aWriteStream
		nextPut: $.;
		cr.
	super saveStateOn: aWriteStream.
	aWriteStream nextPutAll: ' value: aSystemBrowser.'.
	aWriteStream nextPut: $]!

searchForPackage: aPackage 
	self packages: (Array with: aPackage)!

selectionEnvironment
	| classEnvironment |
	classEnvironment := super selectionEnvironment.
	^classEnvironment isSystem 
		ifTrue: [classEnvironment forPackages: self packages]
		ifFalse: [classEnvironment]!

slideyPinNames
	^super slideyPinNames , #('packagesSlidey')!

updateCategories
	"Overridden to select the appropriate loose category when viewing a non-owned class"

	| class package |

	class := self actualClass.
	self hasPackageSelected ifTrue: [package := self packages anyOne].
	(class notNil and: [package notNil and: [package includesLooseMethodsFor: class]]) ifFalse: [^super updateCategories].

	categoriesPresenter model list: self actualClassChainCategories asOrderedCollection.
	categoriesPresenter expand: self allCategory.
	(LooseMethodCategory forPackage: package) 
		ifNil: [super updateCategories]
		ifNotNil: [ :cat | categoriesPresenter selection: cat ifAbsent: [super updateCategories]]! !
!SystemBrowserShell categoriesFor: #canSaveMethod!commands!private! !
!SystemBrowserShell categoriesFor: #createComponents!initializing!public! !
!SystemBrowserShell categoriesFor: #createSchematicWiring!initializing!public! !
!SystemBrowserShell categoriesFor: #hasPackageSelected!public!testing! !
!SystemBrowserShell categoriesFor: #isEditableMethod:!modes!public! !
!SystemBrowserShell categoriesFor: #onPackageSelected!event handling!private! !
!SystemBrowserShell categoriesFor: #packageForNewMethod!operations!private! !
!SystemBrowserShell categoriesFor: #packageNames!accessing!public! !
!SystemBrowserShell categoriesFor: #packages!accessing!public! !
!SystemBrowserShell categoriesFor: #queryCommand:!commands!private! !
!SystemBrowserShell categoriesFor: #resetForFoundClass:!commands!private! !
!SystemBrowserShell categoriesFor: #saveStateOn:!private!saved state! !
!SystemBrowserShell categoriesFor: #searchForPackage:!operations!public! !
!SystemBrowserShell categoriesFor: #selectionEnvironment!accessing!public! !
!SystemBrowserShell categoriesFor: #slideyPinNames!accessing!private! !
!SystemBrowserShell categoriesFor: #updateCategories!private!updating! !

!SystemBrowserShell class methodsFor!

autoSelectPackages
	^AutoSelectPackages!

autoSelectPackages: aBoolean
	AutoSelectPackages := aBoolean!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'System Browser'!

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
	self autoSelectPackages: true.
	(Smalltalk developmentSystem)
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		add: (Aspect boolean: #autoSelectPackages);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 196934 1 ##(Smalltalk.RGB) 8 4294967295 0 567 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851532 131073 560 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 28 198 63 1 0 0 204 53 63 1 3 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point) 193 193 0 560 642 672 8 4294903529 234 256 98 6 410 8 ##(Smalltalk.ReferenceView) 98 14 0 560 98 2 8 1140850688 131073 864 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 0 0 864 1180166 ##(Smalltalk.ResourceIdentifier) 576 8 #resource_Image_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 770 1 1 770 63 51 864 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 98 0 770 193 193 0 27 8 'imageTools' 410 880 98 14 0 560 98 2 8 1140850688 131073 1280 0 946 31 0 7 0 0 0 1280 978 576 8 #resource_Smalltalk_tools 0 1026 202 208 98 1 1090 1120 98 2 770 63 1 770 991 51 1280 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1232 1248 0 27 8 'smalltalkTools' 410 880 98 14 0 560 98 2 8 1140850688 131073 1552 0 0 0 7 0 0 0 1552 978 576 8 #resource_Class_browser_tools 0 1026 202 208 98 1 1090 1120 98 2 770 1053 1 770 307 51 1552 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 2 0 0 0 0 0 0 167 2 0 0 25 0 0 0] 1232 1248 0 27 8 'classBrowserTools' 234 256 1232 202 208 1232 234 240 1232 0 1 0 770 33 33 770 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1026 202 208 98 2 1090 1120 98 2 770 1 1 770 1459 51 560 1090 8 #updateSizePosted 1232 560 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 25 0 0 0] 98 3 864 1280 1552 1248 0 27 410 8 ##(Smalltalk.StatusBar) 98 18 0 416 98 2 8 1140852996 1 2112 0 642 8 4278190080 0 7 0 690 0 16 722 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 770 193 193 0 2112 0 8 4294905391 234 256 98 8 853766 ##(Smalltalk.StatusBarItem) 1 401 2112 0 8 ##(Smalltalk.BasicListAbstract) 8 ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'packageOfSelection' 2338 1 841 2112 0 2368 2384 2416 8 'message' 2338 1 45 2112 0 0 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 5 1 8 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association) 8 #Smalltalk 48 8 #developmentSystem 8 #changedIcon 8 #imageIndex 2512 7 257 0 0 8 'modified' 2338 1 -1 2112 0 459270 ##(Smalltalk.Message) 8 #displayString 98 0 2498 0 0 918822 ##(Smalltalk.CompiledMethod) 2 3 2336 8 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] 8 #iconImageIndex 2816 7 257 0 0 8 'version' 98 4 2352 2480 2448 2736 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2112 0 0 1026 202 208 98 1 1090 1120 98 2 770 1 643 770 1459 41 2112 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 217 2 0 0 85 1 0 0] 98 0 1248 0 27 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 3136 0 0 0 7 0 0 0 3136 1180166 ##(Smalltalk.ProportionalLayout) 202 8 ##(Smalltalk.Dictionary) 98 1 2626 410 8 ##(Smalltalk.Splitter) 98 12 0 3136 98 2 8 1140850688 1 3312 0 642 672 0 519 0 0 0 3312 1026 202 208 98 1 1090 1120 98 2 770 1 291 770 1459 11 3312 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 0 0 0 217 2 0 0 150 0 0 0] 98 0 1248 0 27 1 16 234 256 98 4 410 8 ##(Smalltalk.CardContainer) 98 16 0 3136 98 2 8 1140850688 131073 3600 0 917766 ##(Smalltalk.PluggableColor) 1090 8 #toolBackgroundColor 98 0 8 ##(Smalltalk.SmalltalkSystem) 0 23 265030 4 ##(Smalltalk.Menu) 0 16 98 2 3778 0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem) 1025 1180998 4 ##(Smalltalk.CommandDescription) 2754 8 #tabOrientation: 98 1 8 #top 8 '&Top' 1 1 0 0 0 3858 1025 3890 2754 3936 98 1 8 #bottom 8 '&Bottom' 1 1 0 0 0 3858 1025 3890 2754 3936 98 1 8 #left 8 '&Left' 1 1 0 0 0 3858 1025 3890 2754 3936 98 1 8 #right 8 '&Right' 1 1 0 0 0 8 '&Orientation' 0 134217729 0 0 0 0 0 3778 0 16 98 5 3858 1025 3890 2754 8 #viewMode: 98 1 8 #noIcons 8 '&No Icons' 1 1 0 0 0 3858 1025 3890 2754 4384 98 1 8 #smallIcons 8 '&Small Icons' 1 1 0 0 0 3858 1025 3890 2754 4384 98 1 8 #mediumIcons 8 'Medium Icons' 1 1 0 0 0 3858 1025 3890 2754 4384 98 1 8 #largeIcons 8 '&Large Icons' 1 1 0 0 0 3858 1 3890 2754 4384 98 1 8 #tileIcons 8 'Tile Icons' 1 1 0 0 0 8 '&View' 0 134217729 0 0 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 3600 655878 ##(Smalltalk.CardLayout) 202 208 98 2 2626 590662 1 ##(Smalltalk.CardLabel) 8 'Method source' 1090 8 #icon 98 0 2832 20981 410 880 98 14 0 3600 98 2 8 1140850688 131073 5040 0 0 0 5 0 0 0 5040 978 8 ##(Smalltalk.MethodWorkspace) 8 #resource_Default_view 0 1026 202 208 98 1 1090 1120 98 2 770 9 55 770 1443 231 5040 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 213 2 0 0 142 0 0 0] 1232 1248 0 27 2626 4946 8 'Class definition' 1090 5008 98 0 8 ##(Smalltalk.Class) 21493 410 880 98 14 0 3600 98 2 8 1140916224 131073 5392 0 0 0 23 0 0 0 5392 978 8 ##(Smalltalk.SmalltalkWorkspace) 5136 0 1026 202 208 98 1 1090 1120 98 2 770 9 55 770 1443 231 5392 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 213 2 0 0 142 0 0 0] 1232 1248 0 27 5392 234 256 98 4 5392 8 'definition' 5040 8 'source' 0 410 8 ##(Smalltalk.TabViewXP) 98 28 0 3600 98 2 8 1140916736 1 5696 590662 2 ##(Smalltalk.ListModel) 202 208 98 2 4960 5312 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 3696 0 17 0 0 0 5696 0 8 4294903943 2368 2384 2416 0 0 0 0 0 4512 0 0 0 0 0 1026 202 208 98 3 1090 1120 98 2 770 1 1 770 1459 293 5696 1090 8 #basicSelectionsByIndex: 98 1 98 1 5 5696 1090 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 5696 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 146 0 0 0] 98 0 1248 0 27 1026 202 208 98 2 1090 1120 98 2 770 1 301 770 1459 293 3600 1090 8 #contextMenu: 98 1 3792 3600 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 150 0 0 0 217 2 0 0 40 1 0 0] 98 3 5040 5392 5696 1248 0 27 8 'cards' 410 3152 98 15 0 3136 98 2 8 1140850688 131073 6384 0 0 0 7 0 0 0 6384 3218 202 3264 98 2 2626 410 3328 98 12 0 6384 98 2 8 1140850688 1 6512 0 642 672 0 519 0 0 0 6512 1026 202 208 98 1 1090 1120 98 2 770 1087 1 770 11 291 6512 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 2 0 0 0 0 0 0 36 2 0 0 145 0 0 0] 98 0 1248 0 27 1 2626 410 3328 98 12 0 6384 98 2 8 1140850688 1 6768 0 642 672 0 519 0 0 0 6768 1026 202 208 98 1 1090 1120 98 2 770 721 1 770 11 291 6768 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 104 1 0 0 0 0 0 0 109 1 0 0 145 0 0 0] 98 0 1248 0 27 1 32 234 256 98 6 410 8 ##(Smalltalk.SlideyInneyOuteyThing) 98 23 0 6384 98 2 8 1140850688 131073 7040 0 0 0 519 0 0 0 7040 4866 202 208 98 3 2626 4946 8 'Categories' 0 21481 410 8 ##(Smalltalk.TreeView) 98 27 0 410 8 ##(Smalltalk.SlidingCardTray) 98 22 0 7040 98 2 8 1140850688 131073 7264 0 3682 1090 3728 98 0 3760 0 7 0 0 0 7264 7120 234 256 98 6 410 8 ##(Smalltalk.ListView) 98 30 0 7264 98 2 8 1140936777 1 7424 5778 202 208 1232 0 5856 642 8 4278190080 0 29 3778 0 16 98 7 3858 1 3890 8 #browseSelectorsInProtocol 8 '&Selectors' 1 1 0 0 0 3858 1 3890 8 #toggleProtocolReadOnly 8 '&Read Only' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3858 1 3890 8 #addMethodProtocol 8 '&Add...' 1 1 0 0 0 3778 0 16 98 2 3858 1 3890 8 #removeMethodProtocol 8 'Protocol' 1 1 0 0 0 3858 1 3890 8 #removeMethodsInProtocol 8 'Methods' 1 1 0 0 0 8 'Remove' 0 1 0 0 0 0 0 3858 1 3890 8 #renameMethodProtocol 8 'Rename...' 1 1 0 0 0 3858 1 3890 8 #browseMethodProtocol 8 'Browse' 1 1 0 0 0 8 'Protocols' 0 134217729 0 0 0 0 0 0 0 7424 0 8 4294909021 2754 8 #name 98 0 2384 2416 0 0 2498 0 0 2530 5 1 2560 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] 8 #view 8 #presenter 8 #parentPresenter 8 #customDrawProtocols: 8208 7 257 0 770 65 65 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Protocols' 201 4160 2754 8176 98 0 8 ##(Smalltalk.SortedCollection) 0 0 7424 0 3 0 2498 0 0 2530 5 1 2560 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] 8288 8304 8320 8336 8496 7 257 0 8 #report 1232 0 133217 0 98 1 0 1026 202 208 98 3 1090 1120 98 2 770 1 37 770 209 239 7424 1090 6288 98 1 7568 7424 1090 8 #text: 98 1 8 'Protocols' 7424 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 104 0 0 0 137 0 0 0] 98 0 1248 0 27 8 'protocols' 410 7440 98 30 0 7264 98 2 8 1140920395 1 8880 5778 202 208 1232 0 5856 642 8 4278190080 0 13 3778 0 16 98 10 3858 2097153 3890 8 #browseInstVarReferences 8 'Browse &References' 1 1 0 0 0 7730 4097 3858 1 3890 8 #addInstanceVariable 8 '&Add...' 1 1 0 0 0 3858 1 3890 8 #removeInstanceVariables 8 'Remo&ve' 1 1 0 0 0 3858 1 3890 8 #renameInstanceVariable 8 'Re&name' 1 1 0 0 0 7730 4097 3858 1 3890 8 #pushDownInstanceVariables 8 'Push &Down' 1 1 0 0 0 3858 1 3890 8 #createAccessors 8 '&Create Accessors' 1 1 0 0 0 3858 1 3890 8 #abstractInstanceVariables 8 'Ab&stract' 1 1 0 0 0 3858 1 3890 8 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 0 0 0 0 0 134217729 0 0 0 0 0 0 0 8880 0 8 4294909021 2754 8 #value 98 0 2498 0 0 2530 4 1 2560 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] 8 #key 5008 2704 9648 7 257 0 2416 0 2498 0 0 2530 5 1 2560 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] 9728 8176 8 '.' 8 #, 9744 7 257 0 0 770 65 65 0 0 202 208 98 1 8402 8 '' 201 4160 2368 8480 0 0 8880 0 1 0 0 8 #list 1232 0 133217 0 98 1 0 1026 202 208 98 2 1090 1120 98 2 770 1 37 770 209 239 8880 1090 6288 98 1 9008 8880 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 104 0 0 0 137 0 0 0] 98 0 1248 0 27 8 'variables' 7216 8 'categories' 0 410 5712 98 28 0 7040 98 2 8 1140916864 1 10192 5778 202 208 98 3 7184 4946 8 'Protocols' 2498 0 0 2530 6 1 80 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 983558 ##(Smalltalk.VariableBinding) 8 #CardLabel 4944 10320 10418 8 #MethodProtocol 8 ##(Smalltalk.MethodProtocol) 5008 8 #text:iconBlock: 10336 11 1 0 21487 4946 8 'Variables' 0 21491 0 5856 7344 0 1 0 0 0 10192 0 8 4294903943 2368 2384 2416 0 0 0 0 0 4512 0 0 0 0 0 1026 202 208 98 3 1090 1120 98 2 770 1 1 770 357 291 10192 1090 6016 98 1 98 1 3 10192 1090 6080 98 2 -1 1 10192 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 98 0 1248 0 27 0 7040 770 33 33 1049862 ##(Smalltalk.ButtonInteractor) 7264 0 590342 ##(Smalltalk.Rectangle) 770 173 3 770 205 35 1 3890 8 #togglePin 8 'Pin or Unpin the tray' 1 1 0 0 0 1026 202 208 98 1 1090 1120 98 2 770 141 9 770 209 275 7264 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 98 3 7216 7424 8880 1248 0 27 98 2 8 1140916771 1 7216 590918 3 ##(Smalltalk.TreeModel) 0 5856 525062 ##(Smalltalk.TreeNode) 0 0 0 234 256 1232 642 8 4278190080 0 31 3778 0 16 98 4 3858 1 3890 8 #addMethodCategory 8 '&Add...' 1 1 0 0 0 3778 0 16 98 2 3858 1 3890 8 #removeMethodCategory 8 'Category' 1 1 0 0 0 3858 1 3890 8 #removeMethodsInCategory 8 'Methods' 1 1 0 0 0 8 'Remove' 0 1 0 0 0 0 0 3858 1 3890 8 #renameMethodCategory 8 'Rename...' 1 1 0 0 0 3858 1 3890 8 #browseMethodCategory 8 'Browse' 1 1 0 0 0 8 'Categories' 0 134217729 0 0 0 0 0 0 0 7216 0 8 4294904491 2754 8 #localName 98 0 2384 2416 0 0 2498 0 0 2530 5 1 2560 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] 8288 8304 8320 8 #customDrawCategoryTree: 11760 7 257 0 0 0 234 240 1232 17 4416 1 0 1026 202 208 98 2 1090 1120 98 2 770 1 37 770 209 239 7216 1090 6288 98 1 11280 7216 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 104 0 0 0 137 0 0 0] 98 0 1248 0 27 2626 10304 7424 2626 10528 8880 7216 234 256 98 2 7264 8 'filters' 0 10192 7264 770 201 201 401 1 524319 0 0 1026 202 208 98 1 1090 1120 98 2 770 731 1 770 357 291 7040 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 109 1 0 0 0 0 0 0 31 2 0 0 145 0 0 0] 98 2 7264 10192 1248 0 27 8 'filtersSlidey' 410 880 98 14 0 6384 98 2 8 1140916224 131073 12336 0 3682 1090 3728 98 0 3760 0 7 3778 0 16 98 20 3858 1 3890 8 #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 3778 0 16 98 10 3858 1 3890 8 #browseClassPackage 8 'Package <1d>' 1 1 12546 0 16 12592 8 'Package.ico' 12640 0 0 7730 4097 3858 2097153 3890 8 #browseClassReferences 8 '&Class References' 1 1 0 0 0 3778 0 16 98 0 8 'Local Re&ferences To' 8 #browseVariablesMenu 134217729 0 0 0 0 0 7730 4097 3858 1 3890 8 #browseChangedMethods 8 'Changed &Methods' 1 1 0 0 0 3858 1 3890 8 #browseMethodHistoryForClass 8 'Method &History' 1 1 0 0 0 7730 4097 3858 1 3890 8 #browsePublishedEvents 8 'Published &events' 1 1 0 0 0 3858 1 3890 8 #browsePublishedAspects 8 'Published &aspects' 1 1 0 0 0 8 '&Browse' 8 #browseMenu 134217729 0 0 0 0 0 7730 4097 3858 1 3890 8 #newClass 8 '&New...' 1 1 12546 0 16 12592 8 'NewClass.ico' 12640 0 0 3858 1 3890 8 #deleteClassHierarchy 8 '&Delete' 1 1 12546 0 16 12592 8 'EditClear.ico' 12640 0 0 3778 0 16 98 18 3858 1 3890 8 #safeRemoveClass 8 '&Remove' 1 1 0 0 0 3858 2097153 3890 8 #renameClass 8 'Re&name...' 1 1 0 0 0 7730 4097 3858 1 3890 9152 8 'Add <1s>&Instance Variable...' 1 1 0 0 0 3858 1 3890 8 #addClassVariable 8 'Add &Class Variable...' 1 1 0 0 0 3778 0 16 98 0 8 'Re&move Variable' 8 #removeVariables 134217729 0 0 0 0 0 3778 0 16 98 0 8 'Ren&ame Variable' 8 #renameVariables 134217729 0 0 0 0 0 7730 4097 3778 0 16 98 0 8 'Push &Down' 8 #pushDownVariables 134217729 0 0 0 0 0 3778 0 16 98 0 8 'Pull &Up' 8 #pullUpVariables 134217729 0 0 0 0 0 7730 4097 3778 0 16 98 0 8 'Cr&eate Accessors' 8 #createVariableAccessors 134217729 0 0 0 0 0 3778 0 16 98 0 8 'A&bstract' 8 #abstractVariables 134217729 0 0 0 0 0 3778 0 16 98 0 8 '&Protect/Concrete' 8 #protectVariables 134217729 0 0 0 0 0 7730 4097 3858 1 3890 8 #convertToSibling 8 'Con&vert to Sibling...' 1 1 0 0 0 7730 4097 3858 1 3890 8 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 0 0 0 8 '&Refactorings' 8 #classRefactoringsMenu 134217729 12546 0 16 12592 8 'Refactoring.ico' 12640 0 0 0 0 7730 4097 3858 1 3890 8 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 0 0 0 3858 1 3890 8 #reformatAll 8 'Refor&mat All' 1 1 0 0 0 7730 4097 3858 1 3890 8 #fileInClass 8 'File &In...' 1 1 0 0 0 3858 1 3890 8 #fileOutClass 8 'File &Out...' 1 1 0 0 0 7730 4097 3858 1 3890 8 #classPackage 8 '&Package...' 1 1 12546 0 16 12592 8 'Package.ico' 12640 0 0 3858 1 3890 8 #categorizeClass 8 '&Category...' 1 1 0 0 0 7730 4097 3858 1 3890 8 #browseClassEditions 8 'Browse &Editions' 1 1 0 0 0 3858 1 3890 8 #compareClass 8 'Compare with...' 1 1 0 0 0 7730 4097 3778 0 16 98 4 3858 1 3890 8 #newView 8 '&New...' 1 1 0 0 0 7730 4097 3778 0 16 98 0 8 '&Edit' 8 #viewsEditMenu 1 0 0 0 0 0 3778 0 16 98 0 8 '&Show' 8 #viewsShowMenu 1 0 0 0 0 0 8 '&Views' 8 #viewsMenu 1 12546 0 16 12592 8 'View.ico' 12640 0 0 0 0 8 '&Class' 0 134217729 0 0 0 0 0 0 0 12336 978 8 ##(Smalltalk.ClassListSelector) 5136 0 1026 202 208 98 2 1090 1120 98 2 770 365 1 770 357 291 12336 1090 6288 98 1 12448 12336 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 182 0 0 0 0 0 0 0 104 1 0 0 145 0 0 0] 1232 1248 0 27 8 'classes' 410 7056 98 23 0 6384 98 2 8 1140850688 131073 15632 0 0 0 519 0 0 0 15632 4866 202 208 98 1 2626 4946 8 'Packages' 1090 5008 98 0 8 ##(Smalltalk.Package) 21511 410 7280 98 22 0 15632 98 2 8 1140850688 131073 15840 0 3682 1090 3728 98 0 3760 0 7 0 0 0 15840 4866 202 208 98 1 2626 4946 8 'Packages' 1090 5008 98 0 15824 21511 410 880 98 14 0 15840 98 2 8 1140850688 131073 16080 0 0 0 7 0 0 0 16080 978 8 ##(Smalltalk.PackageSelector) 5136 0 1026 202 208 98 1 1090 1120 98 2 770 1 37 770 297 239 16080 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 148 0 0 0 137 0 0 0] 1232 1248 0 27 16080 234 256 98 2 16080 8 'packages' 0 410 5712 98 28 0 15632 98 2 8 1140916864 1 16368 5778 202 208 98 1 16016 0 5856 15904 0 1 0 0 0 16368 0 8 4294903943 2368 2384 2416 0 0 0 0 0 4512 0 0 0 0 0 1026 202 208 98 3 1090 1120 98 2 770 1 1 770 357 291 16368 1090 6016 98 1 98 1 3 16368 1090 6080 98 2 -1 1 16368 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 98 0 1248 0 27 0 15632 770 33 33 10834 15840 0 10866 770 261 3 770 293 35 1 3890 10944 8 'Pin or Unpin the tray' 1 1 0 0 0 1026 202 208 98 1 1090 1120 98 2 770 53 9 770 297 275 15840 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 26 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 98 1 16080 1248 0 27 0 234 256 1232 0 16368 15840 770 201 201 401 1 524319 0 0 1026 202 208 98 1 1090 1120 98 2 770 1 1 770 357 291 15632 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 98 2 15840 16368 1248 0 27 8 'packagesSlidey' 0 1026 202 208 98 1 1090 1120 98 2 770 1 1 770 1459 291 6384 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 98 7 15632 410 3328 98 12 0 6384 98 2 8 1140850688 1 17376 0 642 8 4278190080 0 7 0 0 0 17376 1026 202 208 98 1 1090 1120 98 2 770 357 1 770 9 291 17376 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 0 0 0 0 182 0 0 0 145 0 0 0] 98 0 1248 0 27 12336 6768 7040 6512 410 3152 98 15 0 6384 98 2 8 1140850688 131073 17632 0 0 0 7 0 0 0 17632 530 1 1 0 410 576 98 25 0 17632 98 2 8 1140886340 131137 17712 0 642 8 4278190080 0 535 0 0 0 17712 642 8 4278190080 8 4294903529 234 256 98 4 410 8 ##(Smalltalk.RadioButton) 98 16 0 17712 98 2 8 1141055497 1 17888 721990 2 ##(Smalltalk.ValueHolder) 0 0 1376774 ##(Smalltalk.PluggableSearchPolicy) 2754 8 #= 98 0 2754 8 #hash 98 0 32 0 0 7 0 0 0 17888 0 8 4294907745 852486 ##(Smalltalk.NullConverter) 0 0 0 1026 202 208 98 2 1090 1120 98 2 770 161 1 770 111 51 17888 1090 8768 98 1 8 'C&lass' 17888 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 0 0 0 0 135 0 0 0 25 0 0 0] 98 0 1248 0 27 8 'classMode' 410 17904 98 16 0 17712 98 2 8 1141055497 1 18400 17970 0 0 18002 2754 18048 98 0 2754 18096 98 0 32 0 0 7 0 0 0 18400 0 8 4294907745 18146 0 0 0 1026 202 208 98 2 1090 1120 98 2 770 21 1 770 131 51 18400 1090 8768 98 1 8 'In&stance' 18400 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 75 0 0 0 25 0 0 0] 98 0 1248 0 27 8 'instanceMode' 234 256 1232 98 0 234 240 1232 10866 770 21 1 770 1 1 1 0 770 33 31 770 45 45 0 1890 11 1 1 1026 202 208 98 2 1090 1120 98 2 770 1 241 770 363 51 17712 1090 2048 1232 17712 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 120 0 0 0 181 0 0 0 145 0 0 0] 98 2 18400 17888 1248 0 27 0 0 410 880 98 14 0 17632 98 2 8 1140916224 131073 19136 0 0 0 31 0 0 0 19136 978 8 ##(Smalltalk.MethodBrowser) 8 #resource_Class_browser_method_list 0 1026 202 208 98 1 1090 1120 98 2 770 1 1 770 363 241 19136 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 181 0 0 0 120 0 0 0] 1232 1248 0 27 234 256 98 4 17712 8 'mode' 19136 8 'methods' 0 1026 202 208 98 1 1090 1120 98 2 770 1097 1 770 363 291 17632 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 36 2 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 98 2 19136 17712 1248 0 27 1248 0 27 8 'classes' 0 1026 202 208 98 1 1090 1120 98 2 770 1 51 770 1459 593 3136 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 217 2 0 0 65 1 0 0] 98 3 6384 3312 3600 1248 0 27 234 256 98 4 2112 8 'statusbar' 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 9 3778 0 16 98 8 3858 1 3890 8 #fileNew 8 '&New' 9373 1 12546 0 16 12592 8 'FileNew.ico' 12640 0 0 3858 1 3890 8 #fileOpen 8 '&Open...' 9375 1 12546 0 16 12592 8 'FileOpen.ico' 12640 0 0 3858 1 3890 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 7730 4097 3858 1 3890 8 #saveImage 8 'Sa&ve Image' 1 1 12546 0 16 12592 8 'Snapshot.ico' 12640 0 0 3858 1 3890 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 12546 0 16 12592 8 'PowerSwitch.ico' 12640 0 0 7730 4097 3858 1 3890 8 #exit 8 '&Close' 17639 1 12546 0 16 12592 8 'CloseWindow.ico' 12640 0 0 8 '&File' 0 134217729 0 0 27525 0 0 3778 0 16 98 13 3858 1 3890 8 #undo 8 '&Undo' 9397 1 12546 0 16 12592 8 'EditUndo.ico' 12640 0 0 7730 4097 3858 1 3890 8 #cutSelection 8 'Cu&t' 9393 1 12546 0 16 12592 8 'EditCut.ico' 12640 0 0 3858 1 3890 8 #copySelection 8 '&Copy' 9351 1 12546 0 16 12592 8 'EditCopy.ico' 12640 0 0 3858 1 3890 8 #pasteClipboard 8 '&Paste' 9389 1 12546 0 16 12592 8 'EditPaste.ico' 12640 0 0 3858 1 3890 8 #editDelete 8 '&Delete' 1 1 12546 0 16 12592 8 'EditClear.ico' 12640 0 0 3778 0 16 98 2 3858 1 3890 8 #reformatSource 8 '&Source' 9391 1 0 0 0 3858 1 3890 8 #reformatComment 8 '&Comment' 9367 1 0 0 0 8 'Ref&ormat' 0 134217729 0 0 27541 0 0 7730 4097 3858 1 3890 8 #selectAll 8 'Select &All' 9347 1 0 0 0 7730 4097 3858 1 3890 8 #editFind 8 '&Find...' 9357 1 12546 0 16 12592 47 786694 ##(Smalltalk.ShellLibrary) 0 0 3858 1 3890 8 #findNext 8 'Find &Next' 1253 1 12546 0 16 12592 8 'FindNext.ico' 12640 0 0 3858 1 3890 8 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 134217729 0 0 27551 0 0 3778 0 16 98 16 3858 1 3890 8 #browseIt 8 '&Browse It' 9349 1 12546 0 16 12592 8 'ClassBrowserShell.ico' 12640 0 0 3858 1 3890 8 #displayIt 8 '&Display It' 9353 1 12546 0 16 12592 8 'DisplayIt.ico' 12640 0 0 3858 1 3890 8 #evaluateIt 8 '&Evaluate It' 9355 1 12546 0 16 12592 8 'EvaluateIt.ico' 12640 0 0 3858 1 3890 8 #inspectIt 8 '&Inspect It' 9363 1 12546 0 16 12592 8 'InspectIt.ico' 12640 0 0 3858 1 3890 8 #debugIt 8 'Deb&ug It' 1269 1 12546 0 16 12592 8 'Debugger.ico' 12640 0 0 3858 1 3890 8 #fileItIn 8 'Fi&le It In' 1 1 0 0 0 7730 4097 3858 1 3890 8 #browseDefinitions 8 'Defi&nitions' 1271 1 0 0 0 3858 1 3890 8 #browseReferences 8 '&References' 5367 1 0 0 0 7730 4097 3858 2097153 3890 8 #accept 8 '&Accept' 9383 1 0 0 0 3858 1 3890 8 #reformatAccept 8 'Refor&mat/Accept' 13479 1 0 0 0 7730 4097 3778 0 16 98 14 3858 1 3890 8 #renameVariable 8 'Re&name <1d>...' 1 1 0 0 0 7730 4097 3858 1 3890 8 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 0 0 0 3858 1 3890 8 #extractMethod 8 'E&xtract Method...' 9371 1 0 0 0 3858 1 3890 8 #extractToComponent 8 'Extract to &Component...' 1 1 0 0 0 3858 1 3890 8 #inlineMessage 8 'Inline &Message' 13467 1 0 0 0 7730 4097 3858 1 3890 8 #inlineTemporary 8 '&Inline Temporary' 13481 1 0 0 0 3858 1 3890 8 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 0 0 0 3858 1 3890 8 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 0 0 0 7730 4097 3858 1 3890 8 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 0 0 0 3858 1 3890 8 #inlineParameter 8 'In&line Parameter' 1 1 0 0 0 3858 1 3890 8 #removeParameter 8 'Remove &Parameter' 1 1 0 0 0 8 'Re&factorings' 8 #codeRefactoringsMenu 134217729 12546 0 16 12592 8 'Refactoring.ico' 12640 0 27595 0 0 7730 4097 3778 0 16 98 7 3858 1 3890 8 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 3858 1 3890 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 3858 1 3890 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 3858 1 3890 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 3858 1 3890 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 3858 1 3890 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 3858 1 3890 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 8 '&Options' 0 134217729 0 0 27611 0 0 8 '&Workspace' 0 134217729 0 0 27613 0 0 3778 0 16 98 20 3858 2097153 3890 12512 8 'Find...' 1 1 12546 0 16 12592 8 'FindClass.ico' 12640 0 0 3778 0 16 98 10 3858 1 3890 12736 8 'Package <1d>' 1 1 12546 0 16 12592 8 'Package.ico' 12640 0 0 7730 4097 3858 2097153 3890 12848 8 '&Class References' 1 1 0 0 0 3778 0 16 98 0 8 'Local Re&ferences To' 12928 134217729 0 0 27621 0 0 7730 4097 3858 1 3890 12992 8 'Changed &Methods' 1 1 0 0 0 3858 1 3890 13056 8 'Method &History' 1 1 0 0 0 7730 4097 3858 1 3890 13136 8 'Published &events' 1 1 0 0 0 3858 1 3890 13200 8 'Published &aspects' 1 1 0 0 0 8 '&Browse' 13248 134217729 0 0 27631 0 0 7730 4097 3858 1 3890 13312 8 '&New...' 1 1 12546 0 16 12592 8 'NewClass.ico' 12640 0 0 3858 1 3890 13408 8 '&Delete' 1 1 12546 0 16 12592 8 'EditClear.ico' 12640 0 0 3778 0 16 98 19 3858 1 3890 13536 8 '&Remove' 1 1 0 0 0 3858 2097153 3890 13600 8 'Re&name...' 1 1 0 0 0 3858 1 3890 8 #copyClass 8 'Cl&one...' 1 1 0 0 0 7730 4097 3858 1 3890 9152 8 'Add <1s>&Instance Variable...' 1 1 0 0 0 3858 1 3890 13728 8 'Add &Class Variable...' 1 1 0 0 0 3778 0 16 98 0 8 'Re&move Variable' 13808 134217729 0 0 27647 0 0 3778 0 16 98 0 8 'Ren&ame Variable' 13872 134217729 0 0 27649 0 0 7730 4097 3778 0 16 98 0 8 'Push &Down' 13952 134217729 0 0 27651 0 0 3778 0 16 98 0 8 'Pull &Up' 14016 134217729 0 0 27653 0 0 7730 4097 3778 0 16 98 0 8 'Cr&eate Accessors' 14096 134217729 0 0 27655 0 0 3778 0 16 98 0 8 'A&bstract' 14160 134217729 0 0 27657 0 0 3778 0 16 98 0 8 '&Protect/Concrete' 14224 134217729 0 0 27659 0 0 7730 4097 3858 1 3890 14288 8 'Con&vert to Sibling...' 1 1 0 0 0 7730 4097 3858 1 3890 14368 8 'Remove Dup&licate Methods' 1 1 0 0 0 8 '&Refactorings' 14416 134217729 12546 0 16 12592 8 'Refactoring.ico' 12640 0 27665 0 0 7730 4097 3858 1 3890 14512 8 'Create &Accessors...' 1 1 0 0 0 3858 1 3890 14576 8 'Refor&mat All' 1 1 0 0 0 7730 4097 3858 1 3890 14656 8 'File &In...' 1 1 0 0 0 3858 1 3890 14720 8 'File &Out...' 1 1 0 0 0 7730 4097 3858 1 3890 14800 8 '&Package...' 1 1 12546 0 16 12592 8 'Package.ico' 12640 0 0 3858 1 3890 14896 8 '&Category...' 1 1 0 0 0 7730 4097 3858 1 3890 14976 8 'Browse &Editions' 1 1 0 0 0 3858 1 3890 15040 8 'Compare with...' 1 1 0 0 0 7730 4097 3778 0 16 98 4 3858 1 3890 15152 8 '&New...' 1 1 0 0 0 7730 4097 3778 0 16 98 0 8 '&Edit' 15248 1 0 0 27685 0 0 3778 0 16 98 0 8 '&Show' 15312 1 0 0 27687 0 0 8 '&Views' 15344 1 12546 0 16 12592 8 'View.ico' 12640 0 27689 0 0 8 '&Class' 0 134217729 0 0 27691 0 0 3778 0 16 98 18 3778 0 16 98 0 8 'De&finitions of' 8 #definitionsMenu 1 0 0 27693 0 0 3778 0 16 98 0 8 '&References to' 8 #referencesMenu 1 0 0 27695 0 0 3778 0 16 98 14 3858 1 3890 8 #browseReferencesToGlobal 8 'References to Global...' 1 1 0 0 0 3858 1 3890 8 #browseContainingText 8 'C&ontaining Text...' 1 1 12546 0 16 12592 8 'SearchText.ico' 12640 0 0 3858 1 3890 11648 8 'Cate&gory...' 1 1 0 0 0 3858 1 3890 8 #browseCompilationFailures 8 'Compilation &Failures' 1 1 0 0 0 3858 1 3890 8 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 0 0 0 7730 4097 3858 1 3890 8 #browseMethodPackages 8 '&Package <s>' 1 1 0 0 0 3858 1 3890 8 #browseMethodClasses 8 '&Class <s>' 1 1 0 0 0 7730 4097 3858 1 3890 8 #browseMethodHistory 8 'Change &History' 1 1 0 0 0 3858 1 3890 8 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 0 0 0 7730 4097 3858 1 3890 8 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 0 0 0 3858 1 3890 8 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 0 0 0 8 '&Browse other' 0 134217729 0 0 27719 0 0 7730 4097 3858 1 3890 8 #newMethod 8 '&New' 1 1 12546 0 16 12592 8 'NewMethod.ico' 12640 0 0 3858 1 3890 8 #removeMethod 8 '&Delete' 1 1 12546 0 16 12592 8 'EditClear.ico' 12640 0 0 3778 0 16 98 17 3858 1 3890 8 #renameMethod 8 'Re&name' 1 1 0 0 0 3858 1 3890 8 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 0 0 0 3858 1 3890 8 #safeRemoveMethods 8 'Rem&ove' 1 1 0 0 0 7730 4097 3858 1 3890 8 #addParameter 8 'Add &Parameter...' 1 1 0 0 0 3778 0 16 98 0 8 'Remo&ve Parameter' 8 #removeParameterMenu 134217729 0 0 27733 0 0 3778 0 16 98 0 8 'Rena&me Parameter' 8 #renameParameterMenu 134217729 0 0 27735 0 0 3778 0 16 98 0 8 '&Inline Parameter' 8 #inlineParameterMenu 134217729 0 0 27737 0 0 7730 4097 3778 0 16 98 0 8 'Rename &Temporary' 8 #renameTempMenu 134217729 0 0 27739 0 0 3778 0 16 98 0 8 'Convert Temp to Inst. Var.' 8 #convertTempToInstVarMenu 134217729 0 0 27741 0 0 7730 4097 3858 1 3890 8 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 0 0 0 3858 1 3890 8 #pushUpMethods 8 'Push &Up' 9325 1 0 0 0 3858 1 3890 8 #pushDownMethods 8 'Push &Down' 9327 1 0 0 0 3858 1 3890 8 #overrideMethods 8 'Ove&rride <1d>' 1 1 0 0 0 3858 1 3890 8 #moveMethod 8 'Move to &Component...' 1 1 0 0 0 8 'Refactorin&gs' 8 #methodRefactoringsMenu 134217729 12546 0 16 12592 8 'Refactoring.ico' 12640 0 27753 0 0 7730 4097 3858 1 3890 8 #methodPackage 8 '&Package...' 1 1 12546 0 16 12592 8 'Package.ico' 12640 0 0 3778 0 16 98 0 8 'Add to &Category' 8 #addCategoryMenu 134217729 0 0 27757 0 0 3778 0 16 98 0 8 'Re&move from Category' 8 #removeCategoryMenu 134217729 0 0 27759 0 0 3858 1 3890 8 #togglePrivate 8 'Pri&vate' 1 1 0 0 0 7730 4097 3858 1 3890 8 #browseMethodEditions 8 'Browse &Editions' 1 1 0 0 0 3858 1 3890 8 #browseAvailableMethods 8 'Browse Available Editions' 1 1 0 0 0 7730 4097 3858 1 3890 8 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 0 0 0 3858 1 3890 8 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 0 0 0 8 '&Method' 0 134217729 0 0 27771 0 0 3778 0 16 98 7 3858 1 3890 8 #undoChange 8 '&Undo <1d>' 1 1 12546 0 16 12592 8 'EditUndo.ico' 12640 0 0 3858 1 3890 8 #redoChange 8 '&Redo <1d>' 1 1 12546 0 16 12592 8 'EditRedo.ico' 12640 0 0 3858 1 3890 8 #clearChangeHistory 8 'Clear Change &History' 1 1 0 0 0 7730 4097 3858 1 3890 8 #historyBack 8 'Back to <1d>' 1 1 12546 0 16 12592 8 'HistoryBack.ico' 12640 0 0 3858 1 3890 8 #historyForward 8 'Forward to <1d>' 1 1 12546 0 16 12592 8 'HistoryForward.ico' 12640 0 0 3858 1 3890 8 #historyClear 8 'Clear Visit History' 1 1 0 0 0 8 'H&istory' 0 134217729 0 0 27785 0 0 3778 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 27787 0 0 3778 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 27789 0 0 3778 0 16 98 15 3858 1 3890 8 #helpContents 8 '&Contents' 1025 1 12546 0 16 12592 49 21424 0 0 3858 1 3890 8 #help 8 'On this &Tool' 1249 1 0 0 0 3858 1 3890 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 7730 4097 3858 1 3890 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 7730 4097 3858 1 3890 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 3858 1 3890 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 3858 1 3890 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 7730 4097 3858 1 3890 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 3858 1 3890 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 3858 1 3890 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 7730 4097 3858 1 3890 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 12546 0 16 12592 8 '!!APPLICATION' 12640 0 0 8 '&Help' 0 134217729 0 0 27813 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1026 202 208 98 3 1090 1120 98 2 770 3839 21 770 1491 801 416 1090 8768 98 1 8 'System Browser' 416 1090 8 #updateMenuBar 1232 416 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 104 10 0 0 154 1 0 0] 98 3 560 3136 2112 1248 0 27 )!

toolsFolderHelpId
	^10595!

uninitialize
	"Private - Uninitialize the receiver prior to remove from the system.
		self uninitialize
	"

	| devsys |
	devsys := Smalltalk developmentSystem.
	devsys systemBrowserClass == self ifTrue: [devsys systemBrowserClass: nil].
	devsys
		removeSystemFolderIconNamed: self toolDescription;
		unregisterTool: self! !
!SystemBrowserShell class categoriesFor: #autoSelectPackages!accessing!private! !
!SystemBrowserShell class categoriesFor: #autoSelectPackages:!accessing!private! !
!SystemBrowserShell class categoriesFor: #displayOn:!displaying!public! !
!SystemBrowserShell class categoriesFor: #icon!constants!public! !
!SystemBrowserShell class categoriesFor: #initialize!initializing!private! !
!SystemBrowserShell class categoriesFor: #publishedAspects!development!public! !
!SystemBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !
!SystemBrowserShell class categoriesFor: #toolsFolderHelpId!constants!public! !
!SystemBrowserShell class categoriesFor: #uninitialize!class hierarchy-removing!private! !

