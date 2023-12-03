"Filed out from Dolphin Smalltalk"!

Tools.ClassBrowserAbstract
	subclass: #'Tools.SystemBrowserShell'
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

canShowLocalHierarchy
	^false!

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
canSaveMethod!private!testing! !
canShowLocalHierarchy!private!testing! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
hasPackageSelected!public!testing! !
isEditableMethod:!modes!public! !
onPackageSelected!event handling!private! !
packageForNewMethod!operations!private! !
packageNames!accessing!public! !
packages!accessing!public! !
resetForFoundClass:!operations!private! !
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 533 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 160 nil nil nil 517 nil nil nil 160 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 8 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 304 nil nil nil 5 nil nil nil 304 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Class_browser_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1051 1 498 353 51 304 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 189 2 0 0 25 0 0 0] 8 #() 498 193 193 nil 27 8 'classBrowserTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 640 nil nil nil 5 nil nil nil 640 370 #{UI.Toolbar} #resource_Image_tools nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 63 51 640 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 592 608 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 864 nil nil nil 5 nil nil nil 864 370 #{UI.Toolbar} #resource_Search_tools nil 402 50 1 450 #createAt:extent: 50 2 498 615 1 498 437 51 864 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 592 608 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1088 nil nil nil 5 nil nil nil 1088 370 #{UI.Toolbar} #resource_Smalltalk_tools nil 402 50 1 450 #createAt:extent: 50 2 498 63 1 498 553 51 1088 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 592 608 nil 27 8 'smalltalkTools' nil nil nil nil 550 #{Core.OrderedCollection} 0 nil nil 1 nil 498 33 33 nil nil 838 1 #{UI.FlowLayout} 1 1 1 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 1459 51 160 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 25 0 0 0] 50 4 640 1088 864 304 608 nil 29 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140852996 1 1536 nil nil nil 5 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 77 0 105 0 99 0 114 0 111 0 115 0 111 0 102 0 116 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 1536 nil nil 258 #{Core.IdentityDictionary} 50 8 1862 1 #{UI.StatusBarItem} 8193 -1 1536 nil 518 #{Core.Message} #displayString 8 #() 1762 #iconImageIndex 1792 nil 8 'message' 1730 8193 45 1536 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 5 1 1856 8 'doIt' 8 '[:modified | modified ifTrue: [Tools.SmalltalkSystem changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 1094 2 #{Kernel.VariableBinding} #SmalltalkSystem #{Tools.SmalltalkSystem} #{Tools} 1 #changedIcon #imageIndex 1872 #ifTrue: 7 257 nil 1858 0 nil 1890 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:modified | modified ifTrue: [''Unsaved edits'']]' 8 #[30 105 17 119 29 106 60 106] 8 'Unsaved edits' 2000 #ifTrue: 7 257 nil 8 'modified' 1730 8705 351 1536 nil 1762 #displayString 8 #() 1762 #iconImageIndex 8 #() 1858 0 nil 1890 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:namespace | ''Method namespace: '', namespace fullName]' 8 #[32 105 29 226 1 178 106] 8 'Method namespace: ' #fullName #, 2192 7 257 nil 8 'namespace' 1730 8193 401 1536 nil 1762 #displayString 8 #() 1762 #iconImageIndex 8 #() nil 8 'packageOfSelection' nil nil nil 50 4 2304 1840 1744 2112 1094 1 #{UI.StatusBarNullItem} 8705 1 1536 nil nil 402 50 1 450 #createAt:extent: 50 2 498 1 643 498 1459 41 1536 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 217 2 0 0 85 1 0 0] 8 #() 608 nil 29 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2592 nil nil nil 5 nil nil nil 2592 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 1 518 #{Core.Association} 18 #{UI.Splitter} 50 12 nil 2592 50 2 8 1140850688 1 2768 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2768 nil 1 #left nil nil nil 498 1 1 498 9 9 nil 2864 nil 402 50 1 450 #createAt:extent: 50 2 498 1 291 498 1459 11 2768 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 0 0 0 217 2 0 0 150 0 0 0] 8 #() 608 nil 27 1 true 258 #{Core.IdentityDictionary} 50 4 18 #{UI.CardContainer} 50 16 nil 2592 50 2 8 1140850688 131073 3072 nil nil nil 21 2886 4 #{UI.Menu} nil true 50 2 3138 nil true 50 4 1094 2 #{UI.CommandMenuItem} 1025 1350 4 #{UI.CommandDescription} 1762 #tabOrientation: 8 #(#top) 8 '&Top' 1 1 nil nil nil 3218 1025 3250 1762 #tabOrientation: 8 #(#bottom) 8 '&Bottom' 1 1 nil nil nil 3218 1025 3250 1762 #tabOrientation: 8 #(#left) 8 '&Left' 1 1 nil nil nil 3218 1025 3250 1762 #tabOrientation: 8 #(#right) 8 '&Right' 1 1 nil nil nil 8 '&Orientation' nil 134217729 nil nil nil nil nil 3138 nil true 50 6 3218 1025 3250 1762 #viewMode: 8 #(#noIcons) 8 '&No Icons' 1 1 nil nil nil 3218 1025 3250 1762 #viewMode: 8 #(#smallIcons) 8 '&Small Icons' 1 1 nil nil nil 3218 1025 3250 1762 #viewMode: 8 #(#mediumIcons) 8 '&Medium Icons' 1 1 nil nil nil 3218 1025 3250 1762 #viewMode: 8 #(#largeIcons) 8 '&Large Icons' 1 1 nil nil nil 3218 1025 3250 1762 #viewMode: 8 #(#tileIcons) 8 '&Tile Icons' 1 1 nil nil nil 3218 1 3250 1762 #viewMode: 8 #(#thumbnails) 8 'Thum&bnails' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3072 1350 1 #{UI.CardLayout} 1314 2 2738 838 1 #{UI.CardLabel} 8 'Method source' 1858 0 nil 1890 7 1 4192 8 'doIt' 8 '(CardLabel text: ''Method source'' iconBlock: [Icon fromId: ''MethodSource.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 1970 #CardLabel 4192 #{UI} 1 4224 1970 #Icon #{Graphics.Icon} #{Graphics} 1 8 'MethodSource.ico' #fromId: #text:iconBlock: 4240 11 1 nil nil 18 #{UI.ReferenceView} 50 14 nil 3072 50 2 8 1140850688 131073 4368 nil nil nil 5 nil nil nil 4368 370 #{Tools.MethodWorkspace} #resource_Default_view nil 402 50 1 450 #createAt:extent: 50 2 498 9 53 498 1443 233 4368 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 213 2 0 0 142 0 0 0] 592 608 nil 27 2738 4194 8 'Class definition' 1858 0 nil 1890 7 1 4192 8 'doIt' 8 '(CardLabel text: ''Class definition'' iconBlock: [Icon fromId: ''ClassDefinition.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 4320 4608 4336 8 'ClassDefinition.ico' #fromId: #text:iconBlock: 4624 11 1 nil nil 18 #{UI.ReferenceView} 50 14 nil 3072 50 2 8 1140916224 131073 4720 nil 240 nil 21 nil nil nil 4720 370 #{Tools.SmalltalkWorkspace} #resource_Default_view nil 402 50 1 450 #createAt:extent: 50 2 498 9 53 498 1443 233 4720 546 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 213 2 0 0 142 0 0 0] 592 608 nil 27 4368 nil nil nil 258 #{Core.IdentityDictionary} 50 4 4720 8 'definition' 4368 8 'source' nil 18 #{UI.TabViewXP} 50 28 nil 3072 50 2 8 1140916736 1 4992 838 2 #{UI.ListModel} 1314 2 4208 4592 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 17 nil nil nil 4992 nil nil 1776 1762 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil #smallIcons nil nil nil nil nil 402 50 3 450 #createAt:extent: 50 2 498 1 1 498 1459 293 4992 450 #setSingleSelection: 8 #(1) 4992 450 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4992 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 146 0 0 0] 8 #() 608 nil 27 402 50 1 450 #createAt:extent: 50 2 498 1 301 498 1459 293 3072 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 150 0 0 0 217 2 0 0 40 1 0 0] 50 3 4368 4720 4992 608 nil 27 8 'cards' 18 #{UI.ContainerView} 50 15 nil 2592 50 2 8 1140850688 131073 5568 nil nil nil 5 nil nil nil 5568 2658 2690 #{Core.Dictionary} 50 2 2738 18 #{UI.Splitter} 50 12 nil 5568 50 2 8 1140850688 1 5696 nil nil nil 517 nil nil nil 2834 5696 nil 1 #left nil nil nil 2864 2880 nil 2864 nil 402 50 1 450 #createAt:extent: 50 2 498 723 1 498 11 291 5696 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 1 0 0 0 0 0 0 110 1 0 0 145 0 0 0] 8 #() 608 nil 27 1 2738 18 #{UI.Splitter} 50 12 nil 5568 50 2 8 1140850688 1 5936 nil nil nil 517 nil nil nil 2834 5936 nil 1 #left nil nil nil 2864 2880 nil 2864 nil 402 50 1 450 #createAt:extent: 50 2 498 1089 1 498 11 291 5936 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 2 0 0 0 0 0 0 37 2 0 0 145 0 0 0] 8 #() 608 nil 27 1 false 258 #{Core.IdentityDictionary} 50 6 18 #{UI.ReferenceView} 50 14 nil 5568 50 2 8 1140916224 131073 6192 nil nil nil 5 nil nil nil 6192 370 #{Tools.ClassListSelector} #resource_Default_view nil 402 50 1 450 #createAt:extent: 50 2 498 367 1 498 357 291 6192 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 183 0 0 0 0 0 0 0 105 1 0 0 145 0 0 0] 592 608 nil 27 8 'classes' 18 #{UI.SlideyInneyOuteyThing} 50 23 nil 5568 50 2 8 1140850688 131073 6416 nil nil nil 517 nil nil nil 6416 4130 1314 3 2738 4194 8 'Categories' 1858 0 nil 1890 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[MethodCategory icon]' 8 #[31 105 45 159 106] 1970 #MethodCategory #{Core.MethodCategory} #{Core} 1 #icon 6560 7 1 nil 21481 18 #{UI.TreeView} 50 27 nil 18 #{UI.SlidingCardTray} 50 22 nil 6416 50 2 8 1140850688 131073 6688 nil nil nil 5 nil nil nil 6688 6480 258 #{Core.IdentityDictionary} 50 6 6656 8 'categories' 18 #{UI.ListView} 50 45 nil 6688 50 2 8 1140936777 1 6800 5058 1314 0 nil 5120 240 nil 29 3138 nil true 50 7 3218 1 3250 #browseSelectorsInProtocol 8 '&Selectors' 1 1 nil nil nil 3218 1 3250 #toggleProtocolReadOnly 8 '&Read Only' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 3218 1 3250 #addMethodProtocol 8 '&Add…' 1 1 nil nil nil 3138 nil true 50 2 3218 1 3250 #removeMethodProtocol 8 'Protocol' 1 1 nil nil nil 3218 1 3250 #removeMethodsInProtocol 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 3218 1 3250 #renameMethodProtocol 8 'Rename…' 1 1 nil nil nil 3218 1 3250 #browseMethodProtocol 8 'Browse' 1 1 nil nil nil 8 'Protocols' nil 134217729 nil nil nil nil nil nil nil 6800 nil nil 1762 #name 8 #() 1762 #iconImageIndex 8 #() 5184 nil nil 1858 0 nil 1890 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 7424 7 257 nil 498 65 65 nil nil 1314 1 3142 5 #{UI.ListViewColumn} 8 'Protocols' 197 #left 1762 #name 8 #() 1762 #<= 8 #() nil nil 6800 nil 3 nil 1858 0 nil 1890 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 7648 7 257 nil #report 8 #() nil 133217 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 402 50 2 450 #createAt:extent: 50 2 498 1 37 498 197 239 6800 450 #text: 50 1 8 'Protocols' 6800 546 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 608 nil 35 8 'protocols' 18 #{UI.ListView} 50 45 nil 6688 50 2 8 1140920395 1 7952 5058 1314 0 nil 5120 240 nil 13 3138 nil true 50 10 3218 2097153 3250 #browseInstanceVariableReferences 8 'Browse &References' 1 1 nil nil nil 7026 4097 3218 1 3250 #addInstanceVariable 8 '&Add…' 1 1 nil nil nil 3218 1 3250 #removeInstanceVariables 8 'Remo&ve' 1 1 nil nil nil 3218 1 3250 #renameInstanceVariable 8 'Re&name' 1 1 nil nil nil 7026 4097 3218 1 3250 #pushDownInstanceVariables 8 'Push &Down' 1 1 nil nil nil 3218 1 3250 #createAccessors 8 '&Create Accessors' 1 1 nil nil nil 3218 1 3250 #abstractInstanceVariables 8 'Ab&stract' 1 1 nil nil nil 3218 1 3250 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 7952 nil nil 1762 #value 8 #() 1858 0 nil 1890 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] #key #icon #imageIndex 8528 7 257 nil 5184 nil 1858 0 nil 1890 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] #key #name 8 '.' #, 8608 7 257 nil nil 498 65 65 nil nil 1314 1 7538 8 '' 201 #left 1776 1762 #<= 8 #() nil nil 7952 nil 1 nil nil #list 7728 nil 133217 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 402 50 1 450 #createAt:extent: 50 2 498 1 37 498 197 239 7952 546 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 608 nil 35 8 'variables' nil 18 #{UI.TabViewXP} 50 28 nil 6416 50 2 8 1140916864 1 8960 5058 1314 3 6528 4194 8 'Protocols' 1858 0 nil 1890 6 1 #{Core.AnsiString} 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 4320 9072 1970 #MethodProtocol #{Kernel.MethodProtocol} #{Kernel} 1 #icon #text:iconBlock: 9088 11 1 nil 21487 4194 8 'Variables' nil 21491 nil 5120 nil nil 1 nil nil nil 8960 nil nil 1776 1762 #iconImageIndex 8 #() 5184 nil nil nil nil nil #smallIcons nil nil nil nil nil 402 50 3 450 #createAt:extent: 50 2 498 1 1 498 357 291 8960 450 #setSingleSelection: 8 #(1) 8960 450 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8960 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 8 #() 608 nil 27 nil 6416 498 33 33 1606 1 #{UI.ButtonInteractor} 6688 nil 1 518 #{Graphics.Rectangle} 498 161 3 498 193 35 nil 3250 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 402 50 1 450 #createAt:extent: 50 2 498 153 9 498 197 275 6688 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 50 3 6656 6800 7952 608 nil 27 50 2 8 1140916771 1 6656 1094 3 #{UI.TreeModel} nil 5120 774 #{UI.TreeNode} nil nil nil 550 #{Core.IdentityDictionary} 0 240 nil 29 3138 nil true 50 4 3218 1 3250 #addMethodCategory 8 '&Add…' 1 1 nil nil nil 3138 nil true 50 2 3218 1 3250 #removeMethodCategory 8 'Category' 1 1 nil nil nil 3218 1 3250 #removeMethodsInCategory 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 3218 1 3250 #renameMethodCategory 8 'Rename…' 1 1 nil nil nil 3218 1 3250 #browseMethodCategory 8 'Browse' 1 1 nil nil nil 8 'Categories' nil 134217729 nil nil nil nil nil nil nil 6656 nil nil 1762 #localName 8 #() 1808 5184 nil nil 1858 0 nil 1890 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawCategoryTree: 10240 7 257 nil nil nil 550 #{Core.LookupTable} 0 nil #noIcons 1 9842 0 402 50 1 450 #createAt:extent: 50 2 498 1 37 498 197 239 6656 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 608 nil 27 2738 9056 6800 2738 9184 7952 6656 nil nil nil 258 9840 50 2 6688 8 'filters' nil 8960 6688 498 201 201 401 1 524319 nil nil 402 50 1 450 #createAt:extent: 50 2 498 733 1 498 357 291 6416 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 1 0 0 0 0 0 0 32 2 0 0 145 0 0 0] 50 2 6688 8960 608 nil 27 8 'filtersSlidey' 18 #{UI.SlideyInneyOuteyThing} 50 23 nil 5568 50 2 8 1140850688 131073 10768 nil nil nil 517 nil nil nil 10768 4130 1314 1 2738 4194 8 'Packages' 450 #icon 8 #() #{Kernel.Package} 21511 18 #{UI.SlidingCardTray} 50 22 nil 10768 50 2 8 1140850688 131073 10944 nil nil nil 5 nil nil nil 10944 4130 1314 1 2738 4194 8 'Packages' 450 #icon 8 #() #{Kernel.Package} 21511 18 #{UI.ReferenceView} 50 14 nil 10944 50 2 8 1140850688 131073 11120 nil nil nil 5 nil nil nil 11120 370 #{Tools.PackageSelector} #resource_Default_view nil 402 50 1 450 #createAt:extent: 50 2 498 1 37 498 293 239 11120 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 146 0 0 0 137 0 0 0] 592 608 nil 27 11120 nil nil nil 258 9840 50 2 11120 8 'packages' nil 18 #{UI.TabViewXP} 50 28 nil 10768 50 2 8 1140916864 1 11376 5058 1314 1 11056 nil 5120 nil nil 1 nil nil nil 11376 nil nil 1776 1762 #iconImageIndex 8 #() 5184 nil nil nil nil nil #smallIcons nil nil nil nil nil 402 50 3 450 #createAt:extent: 50 2 498 1 1 498 357 291 11376 450 #setSingleSelection: 8 #(1) 11376 450 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 11376 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 8 #() 608 nil 27 nil 10768 498 33 33 9474 10944 nil 1 9506 498 257 3 498 289 35 nil 3250 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 402 50 1 450 #createAt:extent: 50 2 498 57 9 498 293 275 10944 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 50 1 11120 608 nil 27 nil nil nil nil 9842 0 nil 11376 10944 498 201 201 401 1 524319 nil nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 357 291 10768 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 50 2 10944 11376 608 nil 27 8 'packagesSlidey' nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 1459 291 5568 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 50 7 10768 18 #{UI.Splitter} 50 12 nil 5568 50 2 8 1140850688 1 12304 nil nil nil 517 nil nil nil 2834 12304 nil 1 #left nil nil nil 2864 2880 nil 2864 nil 402 50 1 450 #createAt:extent: 50 2 498 357 1 498 11 291 12304 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 0 0 0 0 183 0 0 0 145 0 0 0] 8 #() 608 nil 27 6192 5696 6416 5936 18 #{UI.ContainerView} 50 15 nil 5568 50 2 8 1140850688 131073 12528 nil nil nil 5 nil nil nil 12528 130 1 1 nil 18 #{UI.ContainerView} 50 15 nil 12528 50 2 8 1140850688 131073 12608 nil nil nil 533 nil nil nil 12608 1362 11 1 1 258 9840 50 4 18 #{UI.RadioButton} 50 16 nil 12608 50 2 8 1141055497 1 12720 1094 2 #{UI.ValueHolder} nil nil 518 #{Kernel.PluggableSearchPolicy} 1762 #= 8 #() 1762 #hash 8 #() false nil nil 517 nil nil nil 12720 nil nil 518 #{UI.NullConverter} nil nil nil 402 50 2 450 #createAt:extent: 50 2 498 161 7 498 97 39 12720 450 #text: 50 1 8 'C&lass' 12720 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 3 0 0 0 128 0 0 0 22 0 0 0] 8 #() 608 nil 27 8 'classMode' 18 #{UI.RadioButton} 50 16 nil 12608 50 2 8 1141055497 1 13152 12786 nil nil 12818 1762 #= 8 #() 1762 #hash 8 #() false nil nil 517 nil nil nil 13152 nil nil 12914 nil nil nil 402 50 2 450 #createAt:extent: 50 2 498 21 7 498 131 39 13152 450 #text: 50 1 8 'In&stance' 13152 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 3 0 0 0 75 0 0 0 22 0 0 0] 8 #() 608 nil 27 8 'instanceMode' 9506 498 21 7 498 1 7 402 50 1 450 #createAt:extent: 50 2 498 1 241 498 361 51 12608 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 120 0 0 0 180 0 0 0 145 0 0 0] 50 2 13152 12720 608 nil 27 nil nil 18 #{UI.ReferenceView} 50 14 nil 12528 50 2 8 1140916224 131073 13728 nil nil nil 29 nil nil nil 13728 370 #{Tools.MethodBrowser} #resource_Class_browser_method_list nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 361 241 13728 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 180 0 0 0 120 0 0 0] 592 608 nil 27 258 9840 50 4 13728 8 'methods' 12608 8 'mode' nil 402 50 1 450 #createAt:extent: 50 2 498 1099 1 498 361 291 12528 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 37 2 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 50 2 13728 12608 608 nil 27 608 nil 27 8 'classes' nil 402 50 1 450 #createAt:extent: 50 2 498 1 51 498 1459 593 2592 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 217 2 0 0 65 1 0 0] 50 3 5568 2768 3072 608 nil 27 258 9840 50 4 1536 8 'statusbar' 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 9 3138 nil true 50 8 3218 1 3250 #fileNew 8 '&New' 9373 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'NewWorkspace.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 3218 1 3250 #fileOpen 8 '&Open…' 9375 1 14498 nil true 14530 8 'OpenWorkspace.ico' 14592 65541 nil nil nil 3218 1 3250 #fileFileIn 8 '&File In…' 1 1 14498 nil true 14530 8 'FileIn.ico' 14592 65541 nil nil nil 7026 4097 3218 1 3250 #saveImage 8 'Sa&ve Image' 1 1 14498 nil true 14530 8 'Snapshot.ico' 14592 65541 nil nil nil 3218 1 3250 #smalltalkExit 8 'E&xit Dolphin' 1 1 14498 nil true 14530 8 'PowerSwitch.ico' 14592 65541 nil nil nil 7026 4097 3218 1 3250 #exit 8 '&Close' 17639 1 2374 2 #{Graphics.TextTileIcon} 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 3138 nil true 50 13 3218 1 3250 #undo 8 '&Undo' 9397 1 14498 nil true 14530 8 'EditUndo.ico' 14592 65541 nil nil nil 7026 4097 3218 1 3250 #cutSelection 8 'Cu&t' 9393 1 14498 nil true 14530 8 'EditCut.ico' 14592 65541 nil nil nil 3218 1 3250 #copySelection 8 '&Copy' 9351 1 14498 nil true 14530 8 'EditCopy.ico' 14592 65541 nil nil nil 3218 1 3250 #pasteClipboard 8 '&Paste' 9389 1 14498 nil true 14530 8 'EditPaste.ico' 14592 65541 nil nil nil 3218 1 3250 #editDelete 8 '&Delete' 1 1 14498 nil true 14530 8 'EditClear.ico' 14592 65541 nil nil nil 3138 nil true 50 2 3218 1 3250 #reformatSource 8 '&Source' 9391 1 nil nil nil 3218 1 3250 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil nil nil nil 7026 4097 3218 1 3250 #selectAll 8 'Select &All' 9347 1 nil nil nil 7026 4097 3218 1 3250 #editFind 8 '&Find…' 9357 1 14498 nil true 14530 8 'Find.ico' 14592 65541 nil nil nil 3218 1 3250 #findNext 8 'Find &Next' 1253 1 14498 nil true 14530 8 'FindNext.ico' 14592 65541 nil nil nil 3218 1 3250 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 3138 nil true 50 17 3218 1 3250 #browseIt 8 '&Browse It' 9349 1 14498 nil true 14530 8 'ClassBrowserShell.ico' 14592 65541 nil nil nil 3218 1 3250 #displayIt 8 '&Display It' 9353 1 14498 nil true 14530 8 'DisplayIt.ico' 14592 65541 nil nil nil 3218 1 3250 #printIt 8 '&Print It' 9377 1 14498 nil true 14530 8 'PrintIt.ico' 14592 65541 nil nil nil 3218 1 3250 #evaluateIt 8 '&Evaluate It' 9355 1 14498 nil true 14530 8 'EvaluateIt.ico' 14592 65541 nil nil nil 3218 1 3250 #inspectIt 8 '&Inspect It' 9363 1 14498 nil true 14530 8 'InspectIt.ico' 14592 65541 nil nil nil 3218 1 3250 #debugIt 8 'Deb&ug It' 1269 1 14498 nil true 14530 8 'Debugger.ico' 14592 65541 nil nil nil 3218 1 3250 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 7026 4097 3218 1 3250 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 3218 1 3250 #browseReferences 8 'Re&ferences' 5367 1 nil nil nil 7026 4097 3218 2097153 3250 #accept 8 '&Accept' 9383 1 nil nil nil 3218 1 3250 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 7026 4097 3138 nil true 50 14 3218 1 3250 #renameVariable 8 'Re&name <1d>…' 1 1 nil nil nil 7026 4097 3218 1 3250 #extractToTemporary 8 'Extract to &Temporary…' 9385 1 nil nil nil 3218 1 3250 #extractMethod 8 'E&xtract Method…' 9371 1 nil nil nil 3218 1 3250 #extractToComponent 8 'Extract to &Component…' 1 1 nil nil nil 3218 1 3250 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 7026 4097 3218 1 3250 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 3218 1 3250 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 3218 1 3250 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 7026 4097 3218 1 3250 #addParameterToMessage 8 '&Add Parameter to <1d>…' 1 1 nil nil nil 3218 1 3250 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 3218 1 3250 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 '&Refactorings' #codeRefactoringsMenu 134217729 14498 nil true 14530 8 'Refactoring.ico' 14592 65541 nil nil nil nil nil 7026 4097 3138 nil true 50 7 3218 1 3250 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3218 1 3250 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3218 1 3250 #toggleLineEndings 8 'Line &Endings' 1 1 15090 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 3218 1 3250 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3218 1 3250 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3218 1 3250 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3218 1 3250 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 14498 nil true 14530 8 'Preferences.ico' 14592 65541 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 3138 nil true 50 17 3218 2097153 3250 #findClass 8 'Find…' 1 1 14498 nil true 14530 8 'FindClass.ico' 14592 65541 nil nil nil 3138 nil true 50 10 3218 1 3250 #browseClassPackage 8 'Package <1d>' 1 1 14498 nil true 14530 8 'Package.ico' 14592 65541 nil nil nil 7026 4097 3218 2097153 3250 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 3138 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 7026 4097 3218 1 3250 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 3218 1 3250 #browseMethodHistoryForClass 8 'Method &History' 1 1 14498 nil true 14530 8 'MethodHistory.ico' 14592 65541 nil nil nil 7026 4097 3218 1 3250 #browsePublishedEvents 8 'Published &events' 1 1 14498 nil true 14530 8 'Event.ico' 14592 65541 nil nil nil 3218 1 3250 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 7026 4097 3218 1 3250 #newClass 8 '&New…' 1 1 14498 nil true 14530 8 'NewClass.ico' 14592 65541 nil nil nil 3218 1 3250 #removeClass 8 'Re&move' 1 1 14498 nil true 14530 8 'ClassDelete.ico' 14592 65541 nil nil nil 3138 nil true 50 18 3218 2097153 3250 #renameClass 8 'Re&name…' 1 1 14498 nil true 14530 8 'Rename.ico' 14592 65541 nil nil nil 3218 1 3250 #copyClass 8 'Cl&one…' 1 1 nil nil nil 7026 4097 3218 1 3250 #addInstanceVariable 8 'Add <1s>&Instance Variable…' 1 1 nil nil nil 3218 1 3250 #addClassVariable 8 'Add &Class Variable…' 1 1 nil nil nil 3138 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 3138 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 7026 4097 3138 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 3138 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 7026 4097 3138 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 3138 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 3138 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 7026 4097 3218 1 3250 #convertToSibling 8 'Con&vert to Sibling…' 1 1 nil nil nil 7026 4097 3218 1 3250 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 14498 nil true 14530 8 'Refactoring.ico' 14592 65541 nil nil nil nil nil 7026 4097 3218 1 3250 #createInstanceVariableAccessors 8 'Create &Accessors…' 1 1 nil nil nil 3218 1 3250 #reformatAll 8 'Re&format All' 1 1 nil nil nil 7026 4097 3218 1 3250 #fileInClass 8 'File &In…' 1 1 14498 nil true 14530 8 'FileIn.ico' 14592 65541 nil nil nil 3218 1 3250 #fileOutClass 8 'File &Out…' 1 1 nil nil nil 7026 4097 3218 1 3250 #classPackage 8 '&Package…' 1 1 14498 nil true 14530 8 'Package.ico' 14592 65541 nil nil nil 3218 1 3250 #categorizeClass 8 '&Category…' 1 1 14498 nil true 14530 8 'Category.ico' 14592 65541 nil nil nil 7026 4097 3138 nil true 50 4 3218 1 3250 #newView 8 '&New…' 1 1 nil nil nil 7026 4097 3138 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 14498 nil true 14530 8 'ViewComposer.ico' 14592 65541 nil nil nil nil nil 3138 nil true 8 #() 8 '&Show' #viewsShowMenu 1 14498 nil true 14530 8 'TestView.ico' 14592 65541 nil nil nil nil nil 8 '&Views' #viewsMenu 134217729 14498 nil true 14530 8 'View.ico' 14592 65541 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil 3138 nil true 50 15 3138 nil true 8 #() 8 '&Definitions of' #definitionsMenu 1 nil nil nil nil nil 3138 nil true 8 #() 8 'Re&ferences to' #referencesMenu 1 nil nil nil nil nil 3138 nil true 50 14 3218 1 3250 #browseReferencesToGlobal 8 'References to Global…' 1 1 nil nil nil 3218 1 3250 #browseContainingText 8 'C&ontaining Text…' 1 1 14498 nil true 14530 8 'SearchText.ico' 14592 65541 nil nil nil 3218 1 3250 #browseMethodCategory 8 'Cate&gory…' 1 1 14498 nil true 14530 8 'Category.ico' 14592 65541 nil nil nil 3218 1 3250 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 3218 1 3250 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 7026 4097 3218 1 3250 #browseMethodPackages 8 '&Package <s>' 1 1 14498 nil true 14530 8 'Package.ico' 14592 65541 nil nil nil 3218 1 3250 #browseMethodClasses 8 '&Class <s>' 1 1 nil nil nil 7026 4097 3218 1 3250 #browseMethodHistory 8 'Change &History' 1 1 14498 nil true 14530 8 'MethodHistory.ico' 14592 65541 nil nil nil 3218 1 3250 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 7026 4097 3218 1 3250 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 3218 1 3250 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil nil nil nil 7026 4097 3218 1 3250 #newMethod 8 '&New' 1 1 14498 nil true 14530 8 'NewMethod.ico' 14592 65541 nil nil nil 3218 1 3250 #removeMethod 8 'Re&move' 1 1 14498 nil true 14530 8 'MethodDelete.ico' 14592 65541 nil nil nil 3138 nil true 50 16 3218 1 3250 #renameMethod 8 'Re&name' 1 1 14498 nil true 14530 8 'Rename.ico' 14592 65541 nil nil nil 3218 1 3250 #renameMethodReferences 8 'Rename Re&ferences…' 1 1 nil nil nil 7026 4097 3218 1 3250 #addParameter 8 'Add &Parameter…' 1 1 nil nil nil 3138 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil nil nil nil 3138 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil nil nil nil 3138 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil nil nil nil 7026 4097 3138 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil nil nil nil 3138 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil nil nil nil 7026 4097 3218 1 3250 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 3218 1 3250 #pushUpMethods 8 'Push &Up' 13421 1 nil nil nil 3218 1 3250 #pushDownMethods 8 'Push &Down' 13423 1 nil nil nil 3218 1 3250 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 3218 1 3250 #moveMethod 8 'Move to &Component…' 1 1 nil nil nil 8 '&Refactorings' #methodRefactoringsMenu 134217729 14498 nil true 14530 8 'Refactoring.ico' 14592 65541 nil nil nil nil nil 7026 4097 3218 1 3250 #methodPackage 8 '&Package…' 1 1 14498 nil true 14530 8 'Package.ico' 14592 65541 nil nil nil 3138 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil nil nil nil 3138 nil true 8 #() 8 'Remo&ve from Category' #removeCategoryMenu 134217729 nil nil nil nil nil 3218 1 3250 #togglePrivate 8 'Priva&te' 1 1 nil nil nil 7026 4097 3218 1 3250 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 3218 1 3250 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil nil nil nil 3138 nil true 50 7 3218 1 3250 #undoChange 8 '&Undo <1d>' 1 1 14498 nil true 14530 8 'EditUndo.ico' 14592 65541 nil nil nil 3218 1 3250 #redoChange 8 '&Redo <1d>' 1 1 14498 nil true 14530 8 'EditRedo.ico' 14592 65541 nil nil nil 3218 1 3250 #clearChangeHistory 8 'Clear Change &History' 1 1 14498 nil true 14530 8 'MethodHistoryErase.ico' 14592 65541 nil nil nil 7026 4097 3218 1 3250 #historyBack 8 'Back to <1d>' 1 1 14498 nil true 14530 8 'HistoryBack.ico' 14592 65541 nil nil nil 3218 1 3250 #historyForward 8 'Forward to <1d>' 1 1 14498 nil true 14530 8 'HistoryForward.ico' 14592 65541 nil nil nil 3218 1 3250 #historyClear 8 'Clear Visit History' 1 1 14498 nil true 14530 8 'HistoryErase.ico' 14592 65541 nil nil nil 8 'H&istory' nil 134217729 nil nil nil nil nil 3138 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil nil nil nil 3138 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil nil nil nil 3138 nil true 50 15 3218 1 3250 #helpContents 8 '&Contents' 1025 1 14498 nil true 14530 8 'Help.ico' 14592 65541 nil nil nil 3218 1 3250 #help 8 'On this &Tool' 1249 1 nil nil nil 3218 1 3250 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 7026 4097 3218 1 3250 #learnSmalltalk 8 'Learn Smalltalk' 1 1 15090 8 $🎓 nil 226 #orchid 226 #white nil nil 1 nil nil nil nil 7026 4097 3218 1 3250 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3218 1 3250 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3218 1 3250 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 7026 4097 3218 1 3250 #dolphinHomePage 8 'Dolphin Homepage' 1 1 14498 nil true 14530 8 '!!APPLICATION' 14592 65541 nil nil nil 3218 1 3250 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3218 1 3250 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 7026 4097 3218 1 3250 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 15090 8 $🐬 nil nil 226 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 402 50 2 450 #createAt:extent: 50 2 498 6143 21 498 1491 801 32 450 #text: 50 1 8 'System Browser' 32 546 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 232 14 0 0 154 1 0 0] 50 3 160 2592 1536 608 nil 27)!

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

