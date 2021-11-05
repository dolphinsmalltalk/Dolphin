"Filed out from Dolphin Smalltalk"!

Tools.ClassBrowserAbstract subclass: #'Tools.SystemBrowserShell'
	instanceVariableNames: ''
	classVariableNames: 'AutoSelectPackages'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SystemBrowserShell guid: (Core.GUID fromString: '{4e96e0df-9db3-4d86-89d0-91d646c5209f}')!
Tools.SystemBrowserShell comment: 'SystemBrowserShell is a <SmalltalkToolShell> implementing the System Browser development tool. It displays a view of the system that allows for the filtering of classes by package ownership. Please note the System Browser is NOT intended to display unpackaged classes. Unpackaged classes can only be viewed and edited in the Class Hierarchy Browser (see <ClassBrowserShell>).

Class Variables:
	AutoSelectPackages		<Boolean>. Controls whether the packages in a folder are automatically selected when a new folder is selected (the default).

'!
!Tools.SystemBrowserShell categoriesForClass!MVP-Presenters! !
!Tools.SystemBrowserShell methodsFor!

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
	(self packages includes: package) ifFalse: [self packages: {package}].
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
	self packages: {aPackage}!

selectionEnvironment
	| classEnvironment |
	classEnvironment := super selectionEnvironment.
	^classEnvironment isSystem
		ifTrue: 
			[| pkgs |
			pkgs := self packages.
			Package manager packages asSet = pkgs asSet
				ifTrue: [classEnvironment]
				ifFalse: [classEnvironment forPackages: pkgs]]
		ifFalse: [classEnvironment]!

slideyPinNames
	^super slideyPinNames , #('packagesSlidey')! !
!Tools.SystemBrowserShell categoriesForMethods!
canSaveMethod!commands!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
hasPackageSelected!public!testing! !
isEditableMethod:!modes!public! !
onPackageSelected!event handling!private! !
packageForNewMethod!operations!private! !
packageNames!accessing!public! !
packages!accessing!public! !
queryCommand:!commands!private! !
resetForFoundClass:!commands!private! !
saveStateOn:!private!saved state! !
searchForPackage:!operations!public! !
selectionEnvironment!accessing!public! !
slideyPinNames!accessing!private! !
!

!Tools.SystemBrowserShell class methodsFor!

autoSelectPackages
	self ensureOptionsLoaded.
	^AutoSelectPackages!

autoSelectPackages: aBoolean
	self autoSelectPackages = aBoolean ifTrue: [^self].
	AutoSelectPackages := aBoolean.
	self persistOptions!

defaultDefaultSlideyPinsMap
	^##(IdentityDictionary new
		at: #filtersSlidey put: true;
		at: #packagesSlidey put: true;
		yourself)!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'System Browser'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	SmalltalkSystem current
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: ((Aspect boolean: #autoSelectPackages)
					defaultValue: true;
					yourself);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #toolBackground nil 567 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.Toolbar) 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 917510 ##(Graphics.Color) #default 8 1852037360 170 192 34 8 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Toolbar) #resource_Search_tools nil 1310982 ##(Core.MessageSequence) 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 615 1 866 437 51 672 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 8 #() 866 193 193 nil 27 8 'searchTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1008 nil nil nil 7 nil nil nil 1008 738 ##(UI.Toolbar) #resource_Smalltalk_tools nil 770 34 1 818 #createAt:extent: 34 2 866 63 1 866 553 51 1008 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 960 976 nil 27 8 'smalltalkTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1232 nil nil nil 7 nil nil nil 1232 738 ##(UI.Toolbar) #resource_Image_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 63 51 1232 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 960 976 nil 27 8 'imageTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1456 nil nil nil 7 nil nil nil 1456 738 ##(UI.Toolbar) #resource_Class_browser_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1051 1 866 353 51 1456 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 189 2 0 0 25 0 0 0] 960 976 nil 27 8 'classBrowserTools' nil nil nil 170 192 960 138 144 960 nil nil 1 nil 866 33 33 nil nil 852806 1 ##(UI.FlowLayout) 1 1 1 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 1459 51 528 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 25 0 0 0] 34 4 1232 1008 672 1456 976 nil 29 410 ##(UI.StatusBar) 34 21 nil 416 34 2 8 1140852996 1 1904 nil nil nil 7 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 866 193 193 nil 1904 nil 8 1851590672 170 192 34 8 1050438 1 ##(UI.StatusBarItem) 8705 351 1904 nil 786950 ##(Core.Message) #displayString 8 #() 2146 #iconImageIndex 8 #() 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:namespace | ''Method namespace: '', namespace fullName]' 8 #[32 105 29 226 1 178 106] 8 'Method namespace: ' #fullName #, 2240 7 257 nil 8 'namespace' 2114 8193 -1 1904 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'message' 2114 8193 45 1904 nil nil 2226 0 nil 2258 6 1 2224 8 'doIt' 8 '[:modified | modified ifTrue: [SmalltalkSystem current changedIcon imageIndex]]' 8 #[34 105 17 122 45 159 160 161 106 60 106] 1442886 2 ##(Kernel.VariableBinding) #'Tools.SmalltalkSystem' ##(Tools.SmalltalkSystem) ##(Smalltalk) 1 #current #changedIcon #imageIndex #ifTrue: 2416 7 257 nil 2226 0 nil 2258 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [''Unsaved edits'']]' 8 #[30 105 17 119 29 106 60 106] 8 'Unsaved edits' 2528 #ifTrue: 7 257 nil 8 'modified' 2114 8193 401 1904 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'packageOfSelection' nil nil nil 34 4 2640 2400 2368 2128 1311814 1 ##(UI.StatusBarNullItem) 8705 1 1904 nil nil 770 34 1 818 #createAt:extent: 34 2 866 1 643 866 1459 41 1904 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 217 2 0 0 85 1 0 0] 8 #() 976 nil 29 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2864 nil nil nil 7 nil nil nil 2864 1376774 ##(UI.ProportionalLayout) 138 ##(Core.Dictionary) 34 1 1049094 ##(Core.Association) 410 ##(UI.Splitter) 34 12 nil 2864 34 2 8 1140850688 1 3024 nil nil nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 3024 nil 1 #left nil nil nil 866 1 1 866 9 9 nil 3120 nil 770 34 1 818 #createAt:extent: 34 2 866 1 291 866 1459 11 3024 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 0 0 0 217 2 0 0 150 0 0 0] 8 #() 976 nil 27 1 true 170 192 34 4 410 ##(UI.CardContainer) 34 16 nil 2864 34 2 8 1140850688 131073 3328 nil nil nil 23 461638 4 ##(UI.Menu) nil true 34 2 3394 nil true 34 4 1180742 2 ##(UI.CommandMenuItem) 1025 1377606 4 ##(UI.CommandDescription) 2146 #tabOrientation: 8 #(#top) 8 '&Top' 1 1 nil nil nil 3474 1025 3506 2146 #tabOrientation: 8 #(#bottom) 8 '&Bottom' 1 1 nil nil nil 3474 1025 3506 2146 #tabOrientation: 8 #(#left) 8 '&Left' 1 1 nil nil nil 3474 1025 3506 2146 #tabOrientation: 8 #(#right) 8 '&Right' 1 1 nil nil nil 8 '&Orientation' nil 134217729 nil nil nil nil nil 3394 nil true 34 6 3474 1025 3506 2146 #viewMode: 8 #(#noIcons) 8 '&No Icons' 1 1 nil nil nil 3474 1025 3506 2146 #viewMode: 8 #(#smallIcons) 8 '&Small Icons' 1 1 nil nil nil 3474 1025 3506 2146 #viewMode: 8 #(#mediumIcons) 8 '&Medium Icons' 1 1 nil nil nil 3474 1025 3506 2146 #viewMode: 8 #(#largeIcons) 8 '&Large Icons' 1 1 nil nil nil 3474 1025 3506 2146 #viewMode: 8 #(#tileIcons) 8 '&Tile Icons' 1 1 nil nil nil 3474 1 3506 2146 #viewMode: 8 #(#thumbnails) 8 'Thum&bnails' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3328 853318 1 ##(UI.CardLayout) 138 144 34 2 2994 787270 1 ##(UI.CardLabel) 8 'Method source' 2226 0 nil 2258 7 1 4464 8 'doIt' 8 '(CardLabel text: ''Method source'' iconBlock: [Icon fromId: ''MethodSource.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 2498 #CardLabel 4464 ##(Smalltalk) 1 4496 2498 #Icon ##(Graphics.Icon) ##(Smalltalk) 1 8 'MethodSource.ico' #fromId: #text:iconBlock: 4512 11 1 nil nil 410 ##(UI.ReferenceView) 34 14 nil 3328 34 2 8 1140850688 131073 4640 nil nil nil 7 nil nil nil 4640 738 ##(Tools.MethodWorkspace) #resource_Default_view nil 770 34 1 818 #createAt:extent: 34 2 866 9 51 866 1443 235 4640 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 25 0 0 0 213 2 0 0 142 0 0 0] 960 976 nil 27 2994 4466 8 'Class definition' 2226 0 nil 2258 7 1 4464 8 'doIt' 8 '(CardLabel text: ''Class definition'' iconBlock: [Icon fromId: ''ClassDefinition.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 4592 4880 4608 8 'ClassDefinition.ico' #fromId: #text:iconBlock: 4896 11 1 nil nil 410 ##(UI.ReferenceView) 34 14 nil 3328 34 2 8 1140916224 131073 4992 nil 608 nil 21 nil nil nil 4992 738 ##(Tools.SmalltalkWorkspace) #resource_Default_view nil 770 34 1 818 #createAt:extent: 34 2 866 9 51 866 1443 235 4992 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 25 0 0 0 213 2 0 0 142 0 0 0] 960 976 nil 27 4640 nil nil nil 170 192 34 4 4640 8 'source' 4992 8 'definition' nil 410 ##(UI.TabViewXP) 34 28 nil 3328 34 2 8 1140916736 1 5264 787270 2 ##(UI.ListModel) 138 144 34 2 4480 4864 nil 1769478 ##(Kernel.IdentitySearchPolicy) nil nil 17 nil nil nil 5264 nil 8 1851825008 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil #smallIcons nil nil nil nil nil 770 34 3 818 #createAt:extent: 34 2 866 1 1 866 1459 293 5264 818 #setSingleSelection: 8 #(1) 5264 818 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 5264 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 146 0 0 0] 8 #() 976 nil 27 770 34 2 818 #createAt:extent: 34 2 866 1 301 866 1459 293 3328 818 #contextMenu: 34 1 3408 3328 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 150 0 0 0 217 2 0 0 40 1 0 0] 34 3 4640 4992 5264 976 nil 27 8 'cards' 410 ##(UI.ContainerView) 34 15 nil 2864 34 2 8 1140850688 131073 5872 nil nil nil 7 nil nil nil 5872 2930 138 ##(Core.Dictionary) 34 2 2994 410 ##(UI.Splitter) 34 12 nil 5872 34 2 8 1140850688 1 6000 nil nil nil 519 nil nil nil 3090 6000 nil 1 #left nil nil nil 3120 3136 nil 3120 nil 770 34 1 818 #createAt:extent: 34 2 866 1089 1 866 11 291 6000 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 2 0 0 0 0 0 0 37 2 0 0 145 0 0 0] 8 #() 976 nil 27 1 2994 410 ##(UI.Splitter) 34 12 nil 5872 34 2 8 1140850688 1 6240 nil nil nil 519 nil nil nil 3090 6240 nil 1 #left nil nil nil 3120 3136 nil 3120 nil 770 34 1 818 #createAt:extent: 34 2 866 723 1 866 11 291 6240 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 1 0 0 0 0 0 0 110 1 0 0 145 0 0 0] 8 #() 976 nil 27 1 false 170 192 34 6 410 ##(UI.SlideyInneyOuteyThing) 34 23 nil 5872 34 2 8 1140850688 131073 6496 nil nil nil 519 nil nil nil 6496 4386 138 144 34 3 2994 4466 8 'Categories' 2226 0 nil 2258 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[MethodCategory icon]' 8 #[31 105 45 159 106] 2498 #'Core.MethodCategory' ##(Core.MethodCategory) ##(Smalltalk) 1 #icon 6656 7 1 nil 21481 410 ##(UI.TreeView) 34 27 nil 410 ##(UI.SlidingCardTray) 34 22 nil 6496 34 2 8 1140850688 131073 6784 nil nil nil 7 nil nil nil 6784 6560 170 192 34 6 410 ##(UI.ListView) 34 45 nil 6784 34 2 8 1140936777 1 6880 5330 138 144 960 nil 5408 608 nil 29 3394 nil true 34 7 3474 1 3506 #browseSelectorsInProtocol 8 '&Selectors' 1 1 nil nil nil 3474 1 3506 #toggleProtocolReadOnly 8 '&Read Only' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 3474 1 3506 #addMethodProtocol 8 '&Add…' 1 1 nil nil nil 3394 nil true 34 2 3474 1 3506 #removeMethodProtocol 8 'Protocol' 1 1 nil nil nil 3474 1 3506 #removeMethodsInProtocol 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 3474 1 3506 #renameMethodProtocol 8 'Rename…' 1 1 nil nil nil 3474 1 3506 #browseMethodProtocol 8 'Browse' 1 1 nil nil nil 8 'Protocols' nil 134217729 nil nil nil nil nil nil nil 6880 nil 8 1852011696 2146 #name 8 #() ##(UI.IconicListAbstract) 5456 nil nil 2226 0 nil 2258 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 7488 7 257 nil 866 65 65 nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 'Protocols' 209 #left 2146 #name 8 #() 2146 #<= 8 #() nil nil 6880 nil 3 nil 2226 0 nil 2258 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 7728 7 257 nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 34 3 818 #createAt:extent: 34 2 866 1 37 866 209 239 6880 818 #contextMenu: 34 1 6976 6880 818 #text: 34 1 8 'Protocols' 6880 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 104 0 0 0 137 0 0 0] 8 #() 976 nil 35 8 'protocols' 410 ##(UI.ListView) 34 45 nil 6784 34 2 8 1140920395 1 8064 5330 138 144 960 nil 5408 608 nil 13 3394 nil true 34 10 3474 2097153 3506 #browseInstVarReferences 8 'Browse &References' 1 1 nil nil nil 7106 4097 3474 1 3506 #addInstanceVariable 8 '&Add…' 1 1 nil nil nil 3474 1 3506 #removeInstanceVariables 8 'Remo&ve' 1 1 nil nil nil 3474 1 3506 #renameInstanceVariable 8 'Re&name' 1 1 nil nil nil 7106 4097 3474 1 3506 #pushDownInstanceVariables 8 'Push &Down' 1 1 nil nil nil 3474 1 3506 #createAccessors 8 '&Create Accessors' 1 1 nil nil nil 3474 1 3506 #abstractInstanceVariables 8 'Ab&stract' 1 1 nil nil nil 3474 1 3506 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 8064 nil 8 1852011696 2146 #value 8 #() 2226 0 nil 2258 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] #key #icon #imageIndex 8656 7 257 nil 5456 nil 2226 0 nil 2258 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] #key #name 8 '.' #, 8736 7 257 nil nil 866 65 65 nil nil 138 144 34 1 7618 8 '' 201 #left ##(UI.BasicListAbstract) 2146 #<= 8 #() nil nil 8064 nil 1 nil nil #list 7808 nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 34 2 818 #createAt:extent: 34 2 866 1 37 866 209 239 8064 818 #contextMenu: 34 1 8160 8064 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 104 0 0 0 137 0 0 0] 8 #() 976 nil 35 8 'variables' 6752 8 'categories' nil 410 ##(UI.TabViewXP) 34 28 nil 6496 34 2 8 1140916864 1 9152 5330 138 144 34 3 6624 4466 8 'Protocols' 2226 0 nil 2258 6 1 16 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 2498 #CardLabel 4464 ##(Smalltalk) 1 9280 2498 #MethodProtocol ##(Kernel.MethodProtocol) ##(Smalltalk) 1 #icon #text:iconBlock: 9296 11 1 nil 21487 4466 8 'Variables' nil 21491 nil 5408 nil nil 1 nil nil nil 9152 nil 8 1851825008 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 5456 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 34 3 818 #createAt:extent: 34 2 866 1 1 866 357 291 9152 818 #setSingleSelection: 8 #(1) 9152 818 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 9152 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 8 #() 976 nil 27 nil 6496 866 33 33 1246790 1 ##(UI.ButtonInteractor) 6784 nil 1 1180166 ##(Graphics.Rectangle) 866 173 3 866 205 35 nil 3506 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 34 1 818 #createAt:extent: 34 2 866 141 9 866 209 275 6784 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 34 3 6752 6880 8064 976 nil 27 34 2 8 1140916771 1 6752 787526 3 ##(UI.TreeModel) nil 5408 721670 ##(UI.TreeNode) nil nil nil 170 192 960 608 nil 31 3394 nil true 34 4 3474 1 3506 #addMethodCategory 8 '&Add…' 1 1 nil nil nil 3394 nil true 34 2 3474 1 3506 #removeMethodCategory 8 'Category' 1 1 nil nil nil 3474 1 3506 #removeMethodsInCategory 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 3474 1 3506 #renameMethodCategory 8 'Rename…' 1 1 nil nil nil 3474 1 3506 #browseMethodCategory 8 'Browse' 1 1 nil nil nil 8 'Categories' nil 134217729 nil nil nil nil nil nil nil 6752 nil 8 1851789264 2146 #localName 8 #() ##(UI.IconicListAbstract) 5456 nil nil 2226 0 nil 2258 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawCategoryTree: 10448 7 257 nil nil nil 170 176 960 nil #noIcons 1 170 192 960 770 34 2 818 #createAt:extent: 34 2 866 1 37 866 209 239 6752 818 #contextMenu: 34 1 10064 6752 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 104 0 0 0 137 0 0 0] 8 #() 976 nil 27 2994 9264 6880 2994 9408 8064 6752 nil nil nil 170 192 34 2 6784 8 'filters' nil 9152 6784 866 201 201 401 1 524319 nil nil 770 34 1 818 #createAt:extent: 34 2 866 733 1 866 357 291 6496 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 1 0 0 0 0 0 0 32 2 0 0 145 0 0 0] 34 2 6784 9152 976 nil 27 8 'filtersSlidey' 410 ##(UI.SlideyInneyOuteyThing) 34 23 nil 5872 34 2 8 1140850688 131073 10992 nil nil nil 519 nil nil nil 10992 4386 138 144 34 1 2994 4466 8 'Packages' 818 #icon 8 #() ##(Kernel.Package) 21511 410 ##(UI.SlidingCardTray) 34 22 nil 10992 34 2 8 1140850688 131073 11184 nil nil nil 7 nil nil nil 11184 4386 138 144 34 1 2994 4466 8 'Packages' 818 #icon 8 #() ##(Kernel.Package) 21511 410 ##(UI.ReferenceView) 34 14 nil 11184 34 2 8 1140850688 131073 11376 nil nil nil 7 nil nil nil 11376 738 ##(Tools.PackageSelector) #resource_Default_view nil 770 34 1 818 #createAt:extent: 34 2 866 1 37 866 297 239 11376 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 148 0 0 0 137 0 0 0] 960 976 nil 27 11376 nil nil nil 170 192 34 2 11376 8 'packages' nil 410 ##(UI.TabViewXP) 34 28 nil 10992 34 2 8 1140916864 1 11632 5330 138 144 34 1 11312 nil 5408 nil nil 1 nil nil nil 11632 nil 8 1851825008 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 5456 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 34 3 818 #createAt:extent: 34 2 866 1 1 866 357 291 11632 818 #setSingleSelection: 8 #(1) 11632 818 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 11632 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 8 #() 976 nil 27 nil 10992 866 33 33 9682 11184 nil 1 9714 866 261 3 866 293 35 nil 3506 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 34 1 818 #createAt:extent: 34 2 866 53 9 866 297 275 11184 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 26 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 34 1 11376 976 nil 27 nil nil nil nil 170 192 960 nil 11632 11184 866 201 201 401 1 524319 nil nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 357 291 10992 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 34 2 11184 11632 976 nil 27 8 'packagesSlidey' 410 ##(UI.ReferenceView) 34 14 nil 5872 34 2 8 1140916224 131073 12416 nil nil nil 7 3394 nil true 34 17 3474 1 3506 #findClass 8 'Find…' 1 1 852806 4 ##(Graphics.Icon) nil true 2819078 ##(Graphics.ImageFromStringResourceInitializer) 8 'FindClass.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr8.dll' nil 65541 nil nil nil 3394 nil true 34 10 3474 1 3506 #browseClassPackage 8 'Package <1d>' 1 1 12562 nil true 12594 8 'Package.ico' 12656 65541 nil nil nil 7106 4097 3474 2097153 3506 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 3394 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 7106 4097 3474 1 3506 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 3474 1 3506 #browseMethodHistoryForClass 8 'Method &History' 1 1 12562 nil true 12594 8 'MethodHistory.ico' 12656 65541 nil nil nil 7106 4097 3474 1 3506 #browsePublishedEvents 8 'Published &events' 1 1 12562 nil true 12594 8 'Event.ico' 12656 65541 nil nil nil 3474 1 3506 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 7106 4097 3474 1 3506 #newClass 8 '&New…' 1 1 12562 nil true 12594 8 'NewClass.ico' 12656 65541 nil nil nil 3474 1 3506 #deleteClassHierarchy 8 '&Delete' 1 1 12562 nil true 12594 8 'EditClear.ico' 12656 65541 nil nil nil 3394 nil true 34 18 3474 1 3506 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 3474 2097153 3506 #renameClass 8 'Re&name…' 1 1 12562 nil true 12594 8 'Rename.ico' 12656 65541 nil nil nil 7106 4097 3474 1 3506 #addInstanceVariable 8 'Add <1s>&Instance Variable…' 1 1 nil nil nil 3474 1 3506 #addClassVariable 8 'Add &Class Variable…' 1 1 nil nil nil 3394 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 3394 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 7106 4097 3394 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 3394 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 7106 4097 3394 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 3394 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 3394 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 7106 4097 3474 1 3506 #convertToSibling 8 'Con&vert to Sibling…' 1 1 nil nil nil 7106 4097 3474 1 3506 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 12562 nil true 12594 8 'Refactoring.ico' 12656 65541 nil nil nil nil nil 7106 4097 3474 1 3506 #createInstanceVariableAccessors 8 'Create &Accessors…' 1 1 nil nil nil 3474 1 3506 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 7106 4097 3474 1 3506 #fileInClass 8 'File &In…' 1 1 12562 nil true 12594 8 'FileIn.ico' 12656 65541 nil nil nil 3474 1 3506 #fileOutClass 8 'File &Out…' 1 1 nil nil nil 7106 4097 3474 1 3506 #classPackage 8 '&Package…' 1 1 12562 nil true 12594 8 'Package.ico' 12656 65541 nil nil nil 3474 1 3506 #categorizeClass 8 '&Category…' 1 1 12562 nil true 12594 8 'Category.ico' 12656 65541 nil nil nil 7106 4097 3394 nil true 34 4 3474 1 3506 #newView 8 '&New…' 1 1 nil nil nil 7106 4097 3394 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 12562 nil true 12594 8 'ViewComposer.ico' 12656 65541 nil nil nil nil nil 3394 nil true 8 #() 8 '&Show' #viewsShowMenu 1 12562 nil true 12594 8 'TestView.ico' 12656 65541 nil nil nil nil nil 8 '&Views' #viewsMenu 134217729 12562 nil true 12594 8 'View.ico' 12656 65541 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 12416 738 ##(Tools.ClassListSelector) #resource_Default_view nil 770 34 2 818 #createAt:extent: 34 2 866 367 1 866 357 291 12416 818 #contextMenu: 34 1 12480 12416 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 183 0 0 0 0 0 0 0 105 1 0 0 145 0 0 0] 960 976 nil 27 8 'classes' nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 1459 291 5872 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 34 7 10992 410 ##(UI.Splitter) 34 12 nil 5872 34 2 8 1140850688 1 15520 nil nil nil 519 nil nil nil 3090 15520 nil 1 #left nil nil nil 3120 3136 nil 3120 nil 770 34 1 818 #createAt:extent: 34 2 866 357 1 866 11 291 15520 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 0 0 0 0 183 0 0 0 145 0 0 0] 8 #() 976 nil 27 12416 6240 6496 6000 410 ##(UI.ContainerView) 34 15 nil 5872 34 2 8 1140850688 131073 15744 nil nil nil 7 nil nil nil 15744 498 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 15744 34 2 8 1140850688 131073 15824 nil nil nil 535 nil nil nil 15824 1730 11 1 1 170 192 34 4 410 ##(UI.RadioButton) 34 16 nil 15824 34 2 8 1141055497 1 15936 918598 2 ##(UI.ValueHolder) nil nil 1704454 ##(Core.PluggableSearchPolicy) 2146 #= 8 #() 2146 #hash 8 #() false nil nil 7 nil nil nil 15936 nil 8 1852059776 1049094 ##(UI.NullConverter) nil nil nil 770 34 2 818 #createAt:extent: 34 2 866 21 1 866 131 51 15936 818 #text: 34 1 8 'In&stance' 15936 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 75 0 0 0 25 0 0 0] 8 #() 976 nil 27 8 'instanceMode' 410 ##(UI.RadioButton) 34 16 nil 15824 34 2 8 1141055497 1 16384 16002 nil nil 16034 2146 #= 8 #() 2146 #hash 8 #() false nil nil 7 nil nil nil 16384 nil 8 1852059776 16146 nil nil nil 770 34 2 818 #createAt:extent: 34 2 866 161 1 866 111 51 16384 818 #text: 34 1 8 'C&lass' 16384 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 0 0 0 0 135 0 0 0 25 0 0 0] 8 #() 976 nil 27 8 'classMode' 9714 866 21 1 866 1 1 770 34 1 818 #createAt:extent: 34 2 866 1 241 866 361 51 15824 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 120 0 0 0 180 0 0 0 145 0 0 0] 34 2 15936 16384 976 nil 27 nil nil 410 ##(UI.ReferenceView) 34 14 nil 15744 34 2 8 1140916224 131073 16976 nil nil nil 31 nil nil nil 16976 738 ##(Tools.MethodBrowser) #resource_Class_browser_method_list nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 361 241 16976 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 180 0 0 0 120 0 0 0] 960 976 nil 27 170 192 34 4 16976 8 'methods' 15824 8 'mode' nil 770 34 1 818 #createAt:extent: 34 2 866 1099 1 866 361 291 15744 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 37 2 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 34 2 16976 15824 976 nil 27 976 nil 27 8 'classes' nil 770 34 1 818 #createAt:extent: 34 2 866 1 51 866 1459 593 2864 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 217 2 0 0 65 1 0 0] 34 3 5872 3024 3328 976 nil 27 170 192 34 4 528 8 'toolbar' 1904 8 'statusbar' nil 658246 4 ##(UI.MenuBar) nil true 34 9 3394 nil true 34 8 3474 1 3506 #fileNew 8 '&New' 9373 1 12562 nil true 12594 8 'NewWorkspace.ico' 12656 65541 nil nil nil 3474 1 3506 #fileOpen 8 '&Open…' 9375 1 12562 nil true 12594 8 'OpenWorkspace.ico' 12656 65541 nil nil nil 3474 1 3506 #fileFileIn 8 '&File In…' 1 1 12562 nil true 12594 8 'FileIn.ico' 12656 65541 nil nil nil 7106 4097 3474 1 3506 #saveImage 8 'Sa&ve Image' 1 1 12562 nil true 12594 8 'Snapshot.ico' 12656 65541 nil nil nil 3474 1 3506 #smalltalkExit 8 'E&xit Dolphin' 1 1 12562 nil true 12594 8 'PowerSwitch.ico' 12656 65541 nil nil nil 7106 4097 3474 1 3506 #exit 8 '&Close' 17639 1 1378630 2 ##(Graphics.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 65431 nil nil 3394 nil true 34 13 3474 1 3506 #undo 8 '&Undo' 9397 1 12562 nil true 12594 8 'EditUndo.ico' 12656 65541 nil nil nil 7106 4097 3474 1 3506 #cutSelection 8 'Cu&t' 9393 1 12562 nil true 12594 8 'EditCut.ico' 12656 65541 nil nil nil 3474 1 3506 #copySelection 8 '&Copy' 9351 1 12562 nil true 12594 8 'EditCopy.ico' 12656 65541 nil nil nil 3474 1 3506 #pasteClipboard 8 '&Paste' 9389 1 12562 nil true 12594 8 'EditPaste.ico' 12656 65541 nil nil nil 3474 1 3506 #editDelete 8 '&Delete' 1 1 12562 nil true 12594 8 'EditClear.ico' 12656 65541 nil nil nil 3394 nil true 34 2 3474 1 3506 #reformatSource 8 '&Source' 9391 1 nil nil nil 3474 1 3506 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 65447 nil nil 7106 4097 3474 1 3506 #selectAll 8 'Select &All' 9347 1 nil nil nil 7106 4097 3474 1 3506 #editFind 8 '&Find…' 9357 1 12562 nil true 12594 8 'Find.ico' 12656 65541 nil nil nil 3474 1 3506 #findNext 8 'Find &Next' 1253 1 12562 nil true 12594 8 'FindNext.ico' 12656 65541 nil nil nil 3474 1 3506 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 65457 nil nil 3394 nil true 34 17 3474 1 3506 #browseIt 8 '&Browse It' 9349 1 12562 nil true 12594 8 'ClassBrowserShell.ico' 12656 65541 nil nil nil 3474 1 3506 #displayIt 8 '&Display It' 9353 1 12562 nil true 12594 8 'DisplayIt.ico' 12656 65541 nil nil nil 3474 1 3506 #printIt 8 '&Print It' 9377 1 12562 nil true 12594 8 'PrintIt.ico' 12656 65541 nil nil nil 3474 1 3506 #evaluateIt 8 '&Evaluate It' 9355 1 12562 nil true 12594 8 'EvaluateIt.ico' 12656 65541 nil nil nil 3474 1 3506 #inspectIt 8 '&Inspect It' 9363 1 12562 nil true 12594 8 'InspectIt.ico' 12656 65541 nil nil nil 3474 1 3506 #debugIt 8 'Deb&ug It' 1269 1 12562 nil true 12594 8 'Debugger.ico' 12656 65541 nil nil nil 3474 1 3506 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 7106 4097 3474 1 3506 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 3474 1 3506 #browseReferences 8 '&References' 5367 1 nil nil nil 7106 4097 3474 2097153 3506 #accept 8 '&Accept' 9383 1 nil nil nil 3474 1 3506 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 7106 4097 3394 nil true 34 14 3474 1 3506 #renameVariable 8 'Re&name <1d>…' 1 1 nil nil nil 7106 4097 3474 1 3506 #extractToTemporary 8 'Extract to &Temporary…' 9385 1 nil nil nil 3474 1 3506 #extractMethod 8 'E&xtract Method…' 9371 1 nil nil nil 3474 1 3506 #extractToComponent 8 'Extract to &Component…' 1 1 nil nil nil 3474 1 3506 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 7106 4097 3474 1 3506 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 3474 1 3506 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 3474 1 3506 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 7106 4097 3474 1 3506 #addParameterToMessage 8 '&Add Parameter to <1d>…' 1 1 nil nil nil 3474 1 3506 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 3474 1 3506 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 12562 nil true 12594 8 'Refactoring.ico' 12656 65541 nil nil 65503 nil nil 7106 4097 3394 nil true 34 7 3474 1 3506 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3474 1 3506 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3474 1 3506 #toggleLineEndings 8 'Line &Endings' 1 1 18258 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 3474 1 3506 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3474 1 3506 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3474 1 3506 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3474 1 3506 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 12562 nil true 12594 8 'Preferences.ico' 12656 65541 nil nil 65519 nil nil 8 '&Workspace' nil 134217729 nil nil 65521 nil nil 3394 nil true 34 17 3474 2097153 3506 #findClass 8 'Find…' 1 1 12562 nil true 12594 8 'FindClass.ico' 12656 65541 nil nil nil 3394 nil true 34 10 3474 1 3506 #browseClassPackage 8 'Package <1d>' 1 1 12562 nil true 12594 8 'Package.ico' 12656 65541 nil nil nil 7106 4097 3474 2097153 3506 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 3394 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil 65529 nil nil 7106 4097 3474 1 3506 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 3474 1 3506 #browseMethodHistoryForClass 8 'Method &History' 1 1 12562 nil true 12594 8 'MethodHistory.ico' 12656 65541 nil nil nil 7106 4097 3474 1 3506 #browsePublishedEvents 8 'Published &events' 1 1 12562 nil true 12594 8 'Event.ico' 12656 65541 nil nil nil 3474 1 3506 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil 8017 nil nil 7106 4097 3474 1 3506 #newClass 8 '&New…' 1 1 12562 nil true 12594 8 'NewClass.ico' 12656 65541 nil nil nil 3474 1 3506 #deleteClassHierarchy 8 '&Delete' 1 1 12562 nil true 12594 8 'EditClear.ico' 12656 65541 nil nil nil 3394 nil true 34 19 3474 1 3506 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 3474 2097153 3506 #renameClass 8 'Re&name…' 1 1 12562 nil true 12594 8 'Rename.ico' 12656 65541 nil nil nil 3474 1 3506 #copyClass 8 'Cl&one…' 1 1 nil nil nil 7106 4097 3474 1 3506 #addInstanceVariable 8 'Add <1s>&Instance Variable…' 1 1 nil nil nil 3474 1 3506 #addClassVariable 8 'Add &Class Variable…' 1 1 nil nil nil 3394 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil 8133 nil nil 3394 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil 8135 nil nil 7106 4097 3394 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil 8159 nil nil 3394 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil 8163 nil nil 7106 4097 3394 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil 8165 nil nil 3394 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil 8167 nil nil 3394 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil 8169 nil nil 7106 4097 3474 1 3506 #convertToSibling 8 'Con&vert to Sibling…' 1 1 nil nil nil 7106 4097 3474 1 3506 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 12562 nil true 12594 8 'Refactoring.ico' 12656 65541 nil nil 8175 nil nil 7106 4097 3474 1 3506 #createInstanceVariableAccessors 8 'Create &Accessors…' 1 1 nil nil nil 3474 1 3506 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 7106 4097 3474 1 3506 #fileInClass 8 'File &In…' 1 1 12562 nil true 12594 8 'FileIn.ico' 12656 65541 nil nil nil 3474 1 3506 #fileOutClass 8 'File &Out…' 1 1 nil nil nil 7106 4097 3474 1 3506 #classPackage 8 '&Package…' 1 1 12562 nil true 12594 8 'Package.ico' 12656 65541 nil nil nil 3474 1 3506 #categorizeClass 8 '&Category…' 1 1 12562 nil true 12594 8 'Category.ico' 12656 65541 nil nil nil 7106 4097 3394 nil true 34 4 3474 1 3506 #newView 8 '&New…' 1 1 nil nil nil 7106 4097 3394 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 12562 nil true 12594 8 'ViewComposer.ico' 12656 65541 nil nil 8191 nil nil 3394 nil true 8 #() 8 '&Show' #viewsShowMenu 1 12562 nil true 12594 8 'TestView.ico' 12656 65541 nil nil 8193 nil nil 8 '&Views' #viewsMenu 134217729 12562 nil true 12594 8 'View.ico' 12656 65541 nil nil 8195 nil nil 8 '&Class' nil 134217729 nil nil 8197 nil nil 3394 nil true 34 15 3394 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 8199 nil nil 3394 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 8201 nil nil 3394 nil true 34 14 3474 1 3506 #browseReferencesToGlobal 8 'References to Global…' 1 1 nil nil nil 3474 1 3506 #browseContainingText 8 'C&ontaining Text…' 1 1 12562 nil true 12594 8 'SearchText.ico' 12656 65541 nil nil nil 3474 1 3506 #browseMethodCategory 8 'Cate&gory…' 1 1 12562 nil true 12594 8 'Category.ico' 12656 65541 nil nil nil 3474 1 3506 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 3474 1 3506 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 7106 4097 3474 1 3506 #browseMethodPackages 8 '&Package <s>' 1 1 12562 nil true 12594 8 'Package.ico' 12656 65541 nil nil nil 3474 1 3506 #browseMethodClasses 8 '&Class <s>' 1 1 nil nil nil 7106 4097 3474 1 3506 #browseMethodHistory 8 'Change &History' 1 1 12562 nil true 12594 8 'MethodHistory.ico' 12656 65541 nil nil nil 3474 1 3506 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 7106 4097 3474 1 3506 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 3474 1 3506 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 8225 nil nil 7106 4097 3474 1 3506 #newMethod 8 '&New' 1 1 12562 nil true 12594 8 'NewMethod.ico' 12656 65541 nil nil nil 3474 1 3506 #removeMethod 8 '&Delete' 1 1 12562 nil true 12594 8 'EditClear.ico' 12656 65541 nil nil nil 3394 nil true 34 16 3474 1 3506 #renameMethod 8 'Re&name' 1 1 12562 nil true 12594 8 'Rename.ico' 12656 65541 nil nil nil 3474 1 3506 #renameMethodReferences 8 'Rename Re&ferences…' 1 1 nil nil nil 7106 4097 3474 1 3506 #addParameter 8 'Add &Parameter…' 1 1 nil nil nil 3394 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 8237 nil nil 3394 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 8239 nil nil 3394 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 8241 nil nil 7106 4097 3394 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 8243 nil nil 3394 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 8245 nil nil 7106 4097 3474 1 3506 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 3474 1 3506 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 3474 1 3506 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 3474 1 3506 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 3474 1 3506 #moveMethod 8 'Move to &Component…' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 12562 nil true 12594 8 'Refactoring.ico' 12656 65541 nil nil 8257 nil nil 7106 4097 3474 1 3506 #methodPackage 8 '&Package…' 1 1 12562 nil true 12594 8 'Package.ico' 12656 65541 nil nil nil 3394 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 8261 nil nil 3394 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 8263 nil nil 3474 1 3506 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 7106 4097 3474 1 3506 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 3474 1 3506 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 8271 nil nil 3394 nil true 34 7 3474 1 3506 #undoChange 8 '&Undo <1d>' 1 1 12562 nil true 12594 8 'EditUndo.ico' 12656 65541 nil nil nil 3474 1 3506 #redoChange 8 '&Redo <1d>' 1 1 12562 nil true 12594 8 'EditRedo.ico' 12656 65541 nil nil nil 3474 1 3506 #clearChangeHistory 8 'Clear Change &History' 1 1 12562 nil true 12594 8 'MethodHistoryErase.ico' 12656 65541 nil nil nil 7106 4097 3474 1 3506 #historyBack 8 'Back to <1d>' 1 1 12562 nil true 12594 8 'HistoryBack.ico' 12656 65541 nil nil nil 3474 1 3506 #historyForward 8 'Forward to <1d>' 1 1 12562 nil true 12594 8 'HistoryForward.ico' 12656 65541 nil nil nil 3474 1 3506 #historyClear 8 'Clear Visit History' 1 1 12562 nil true 12594 8 'HistoryErase.ico' 12656 65541 nil nil nil 8 'H&istory' nil 134217729 nil nil 8285 nil nil 3394 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 8287 nil nil 3394 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 8289 nil nil 3394 nil true 34 15 3474 1 3506 #helpContents 8 '&Contents' 1025 1 12562 nil true 12594 8 'Help.ico' 12656 65541 nil nil nil 3474 1 3506 #help 8 'On this &Tool' 1249 1 nil nil nil 3474 1 3506 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 7106 4097 3474 1 3506 #learnSmalltalk 8 'Learn Smalltalk' 1 1 18258 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 7106 4097 3474 1 3506 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3474 1 3506 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3474 1 3506 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 7106 4097 3474 1 3506 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 12562 nil true 12594 8 '!!APPLICATION' 12656 65541 nil nil nil 3474 1 3506 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3474 1 3506 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 7106 4097 3474 1 3506 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 18258 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 8313 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 34 2 818 #createAt:extent: 34 2 866 12287 21 866 1491 801 416 818 #text: 34 1 8 'System Browser' 416 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 232 26 0 0 154 1 0 0] 34 3 528 2864 1904 976 nil 27 )!

toolsFolderHelpId
	^10595!

uninitialize
	"Private - Uninitialize the receiver prior to remove from the system.
		self uninitialize
	"

	SmalltalkSystem.Current
		ifNotNil: [:devsys | devsys systemBrowserClass == self ifTrue: [devsys systemBrowserClass: nil]]! !
!Tools.SystemBrowserShell class categoriesForMethods!
autoSelectPackages!accessing!options!public! !
autoSelectPackages:!accessing!options!public! !
defaultDefaultSlideyPinsMap!initializing!private! !
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
toolsFolderHelpId!constants!public! !
uninitialize!class hierarchy-removing!private! !
!

