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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 535 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 160 nil nil nil 519 nil nil nil 160 6 #{Graphics.Color} #default 8 1853287488 550 #{Core.IdentityDictionary} 4 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 304 nil nil nil 7 nil nil nil 304 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Search_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 615 1 498 437 51 304 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 8 #() 498 193 193 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 370 #{UI.Toolbar} #resource_Smalltalk_tools nil 402 50 1 450 #createAt:extent: 50 2 498 63 1 498 553 51 640 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 592 608 nil 27 8 'smalltalkTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 864 nil nil nil 7 nil nil nil 864 370 #{UI.Toolbar} #resource_Class_browser_tools nil 402 50 1 450 #createAt:extent: 50 2 498 1051 1 498 353 51 864 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 189 2 0 0 25 0 0 0] 592 608 nil 27 8 'classBrowserTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1088 nil nil nil 7 nil nil nil 1088 370 #{UI.Toolbar} #resource_Image_tools nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 63 51 1088 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 592 608 nil 27 8 'imageTools' nil nil nil 274 0 550 #{Core.OrderedCollection} 0 nil nil 1 nil 498 33 33 nil nil 838 1 #{UI.FlowLayout} 1 1 1 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 1459 51 160 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 25 0 0 0] 50 4 1088 640 304 864 608 nil 29 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140852996 1 1552 nil nil nil 7 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONT} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 498 193 193 nil 1552 nil 8 1852980448 274 4 1862 1 #{UI.StatusBarItem} 8193 -1 1552 nil 518 #{Core.Message} #displayString 8 #() 1778 #iconImageIndex 1808 nil 8 'message' 1746 8193 45 1552 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 5 1 1872 8 'doIt' 8 '[:modified | modified ifTrue: [Tools.SmalltalkSystem changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 1094 2 #{Kernel.VariableBinding} #SmalltalkSystem #{Tools.SmalltalkSystem} #{Tools} 1 #changedIcon #imageIndex 1888 #ifTrue: 7 257 nil 1874 0 nil 1906 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:modified | modified ifTrue: [''Unsaved edits'']]' 8 #[30 105 17 119 29 106 60 106] 8 'Unsaved edits' 2016 #ifTrue: 7 257 nil 8 'modified' 1746 8705 351 1552 nil 1778 #displayString 8 #() 1778 #iconImageIndex 8 #() 1874 0 nil 1906 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:namespace | ''Method namespace: '', namespace fullName]' 8 #[32 105 29 226 1 178 106] 8 'Method namespace: ' #fullName #, 2208 7 257 nil 8 'namespace' 1746 8193 401 1552 nil 1778 #displayString 8 #() 1778 #iconImageIndex 8 #() nil 8 'packageOfSelection' nil nil nil 50 4 2320 1856 1760 2128 1094 1 #{UI.StatusBarNullItem} 8705 1 1552 nil nil 402 50 1 450 #createAt:extent: 50 2 498 1 643 498 1459 41 1552 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 217 2 0 0 85 1 0 0] 8 #() 608 nil 29 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2608 nil nil nil 7 nil nil nil 2608 518 #{UI.ProportionalLayout} 294 #{Core.Dictionary} 1 518 #{Core.Association} 18 #{UI.Splitter} 50 12 nil 2608 50 2 8 1140850688 1 2768 nil nil nil 519 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2768 nil 1 #left nil nil nil 498 1 1 498 9 9 nil 2864 nil 402 50 1 450 #createAt:extent: 50 2 498 1 291 498 1459 11 2768 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 0 0 0 217 2 0 0 150 0 0 0] 8 #() 608 nil 27 1 true 274 2 18 #{UI.CardContainer} 50 16 nil 2608 50 2 8 1140850688 131073 3056 nil nil nil 23 2886 4 #{UI.Menu} nil true 50 2 3122 nil true 50 4 1094 2 #{UI.CommandMenuItem} 1025 1350 4 #{UI.CommandDescription} 1778 #tabOrientation: 8 #(#top) 8 '&Top' 1 1 nil nil nil 3202 1025 3234 1778 #tabOrientation: 8 #(#bottom) 8 '&Bottom' 1 1 nil nil nil 3202 1025 3234 1778 #tabOrientation: 8 #(#left) 8 '&Left' 1 1 nil nil nil 3202 1025 3234 1778 #tabOrientation: 8 #(#right) 8 '&Right' 1 1 nil nil nil 8 '&Orientation' nil 134217729 nil nil nil nil nil 3122 nil true 50 6 3202 1025 3234 1778 #viewMode: 8 #(#noIcons) 8 '&No Icons' 1 1 nil nil nil 3202 1025 3234 1778 #viewMode: 8 #(#smallIcons) 8 '&Small Icons' 1 1 nil nil nil 3202 1025 3234 1778 #viewMode: 8 #(#mediumIcons) 8 '&Medium Icons' 1 1 nil nil nil 3202 1025 3234 1778 #viewMode: 8 #(#largeIcons) 8 '&Large Icons' 1 1 nil nil nil 3202 1025 3234 1778 #viewMode: 8 #(#tileIcons) 8 '&Tile Icons' 1 1 nil nil nil 3202 1 3234 1778 #viewMode: 8 #(#thumbnails) 8 'Thum&bnails' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3056 1350 1 #{UI.CardLayout} 1330 2 2738 838 1 #{UI.CardLabel} 8 'Method source' 1874 0 nil 1906 7 1 4176 8 'doIt' 8 '(CardLabel text: ''Method source'' iconBlock: [Icon fromId: ''MethodSource.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 1986 #CardLabel 4176 #{Smalltalk} 1 4208 1986 #Icon #{Graphics.Icon} #{Smalltalk} 1 8 'MethodSource.ico' #fromId: #text:iconBlock: 4224 11 1 nil nil 18 #{UI.ReferenceView} 50 14 nil 3056 50 2 8 1140850688 131073 4352 nil nil nil 7 nil nil nil 4352 370 #{Tools.MethodWorkspace} #resource_Default_view nil 402 50 1 450 #createAt:extent: 50 2 498 9 53 498 1443 233 4352 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 213 2 0 0 142 0 0 0] 592 608 nil 27 2738 4178 8 'Class definition' 1874 0 nil 1906 7 1 4176 8 'doIt' 8 '(CardLabel text: ''Class definition'' iconBlock: [Icon fromId: ''ClassDefinition.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 4304 4592 4320 8 'ClassDefinition.ico' #fromId: #text:iconBlock: 4608 11 1 nil nil 18 #{UI.ReferenceView} 50 14 nil 3056 50 2 8 1140916224 131073 4704 nil 240 nil 21 nil nil nil 4704 370 #{Tools.SmalltalkWorkspace} #resource_Default_view nil 402 50 1 450 #createAt:extent: 50 2 498 9 53 498 1443 233 4704 546 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 213 2 0 0 142 0 0 0] 592 608 nil 27 4352 nil nil nil 274 2 4352 8 'source' 4704 8 'definition' nil 18 #{UI.TabViewXP} 50 28 nil 3056 50 2 8 1140916736 1 4960 838 2 #{UI.ListModel} 1330 2 4192 4576 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 17 nil nil nil 4960 nil 8 1852839600 1792 1778 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil #smallIcons nil nil nil nil nil 402 50 3 450 #createAt:extent: 50 2 498 1 1 498 1459 293 4960 450 #setSingleSelection: 8 #(1) 4960 450 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4960 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 146 0 0 0] 8 #() 608 nil 27 402 50 1 450 #createAt:extent: 50 2 498 1 301 498 1459 293 3056 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 150 0 0 0 217 2 0 0 40 1 0 0] 50 3 4352 4704 4960 608 nil 27 8 'cards' 18 #{UI.ContainerView} 50 15 nil 2608 50 2 8 1140850688 131073 5552 nil nil nil 7 nil nil nil 5552 2674 2706 2 2738 18 #{UI.Splitter} 50 12 nil 5552 50 2 8 1140850688 1 5664 nil nil nil 519 nil nil nil 2834 5664 nil 1 #left nil nil nil 2864 2880 nil 2864 nil 402 50 1 450 #createAt:extent: 50 2 498 1089 1 498 11 291 5664 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 2 0 0 0 0 0 0 37 2 0 0 145 0 0 0] 8 #() 608 nil 27 1 2738 18 #{UI.Splitter} 50 12 nil 5552 50 2 8 1140850688 1 5904 nil nil nil 519 nil nil nil 2834 5904 nil 1 #left nil nil nil 2864 2880 nil 2864 nil 402 50 1 450 #createAt:extent: 50 2 498 723 1 498 11 291 5904 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 1 0 0 0 0 0 0 110 1 0 0 145 0 0 0] 8 #() 608 nil 27 1 false 274 3 18 #{UI.ReferenceView} 50 14 nil 5552 50 2 8 1140916224 131073 6144 nil nil nil 7 nil nil nil 6144 370 #{Tools.ClassListSelector} #resource_Default_view nil 402 50 1 450 #createAt:extent: 50 2 498 367 1 498 357 291 6144 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 183 0 0 0 0 0 0 0 105 1 0 0 145 0 0 0] 592 608 nil 27 8 'classes' 18 #{UI.SlideyInneyOuteyThing} 50 23 nil 5552 50 2 8 1140850688 131073 6368 nil nil nil 519 nil nil nil 6368 4114 1330 1 2738 4178 8 'Packages' 450 #icon 8 #() #{Kernel.Package} 21511 18 #{UI.SlidingCardTray} 50 22 nil 6368 50 2 8 1140850688 131073 6544 nil nil nil 7 nil nil nil 6544 4114 1330 1 2738 4178 8 'Packages' 450 #icon 8 #() #{Kernel.Package} 21511 18 #{UI.ReferenceView} 50 14 nil 6544 50 2 8 1140850688 131073 6720 nil nil nil 7 nil nil nil 6720 370 #{Tools.PackageSelector} #resource_Default_view nil 402 50 1 450 #createAt:extent: 50 2 498 1 37 498 293 239 6720 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 146 0 0 0 137 0 0 0] 592 608 nil 27 6720 nil nil nil 274 1 6720 8 'packages' nil 18 #{UI.TabViewXP} 50 28 nil 6368 50 2 8 1140916864 1 6960 5026 1330 1 6656 nil 5088 nil nil 1 nil nil nil 6960 nil 8 1852839600 1792 1778 #iconImageIndex 8 #() 5168 nil nil nil nil nil #smallIcons nil nil nil nil nil 402 50 3 450 #createAt:extent: 50 2 498 1 1 498 357 291 6960 450 #setSingleSelection: 8 #(1) 6960 450 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 6960 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 8 #() 608 nil 27 nil 6368 498 33 33 1606 1 #{UI.ButtonInteractor} 6544 nil 1 518 #{Graphics.Rectangle} 498 257 3 498 289 35 nil 3234 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 402 50 1 450 #createAt:extent: 50 2 498 57 9 498 293 275 6544 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 50 1 6720 608 nil 27 nil nil nil nil 274 0 nil 6960 6544 498 201 201 401 1 524319 nil nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 357 291 6368 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 50 2 6544 6960 608 nil 27 8 'packagesSlidey' 18 #{UI.SlideyInneyOuteyThing} 50 23 nil 5552 50 2 8 1140850688 131073 7792 nil nil nil 519 nil nil nil 7792 4114 1330 3 2738 4178 8 'Categories' 1874 0 nil 1906 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[MethodCategory icon]' 8 #[31 105 45 159 106] 1986 #'Core.MethodCategory' #{Core.MethodCategory} #{Smalltalk} 1 #icon 7936 7 1 nil 21481 18 #{UI.TreeView} 50 27 nil 18 #{UI.SlidingCardTray} 50 22 nil 7792 50 2 8 1140850688 131073 8064 nil nil nil 7 nil nil nil 8064 7856 274 3 18 #{UI.ListView} 50 45 nil 8064 50 2 8 1140936777 1 8144 5026 1330 0 nil 5088 240 nil 29 3122 nil true 50 7 3202 1 3234 #browseSelectorsInProtocol 8 '&Selectors' 1 1 nil nil nil 3202 1 3234 #toggleProtocolReadOnly 8 '&Read Only' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 3202 1 3234 #addMethodProtocol 8 '&Add…' 1 1 nil nil nil 3122 nil true 50 2 3202 1 3234 #removeMethodProtocol 8 'Protocol' 1 1 nil nil nil 3202 1 3234 #removeMethodsInProtocol 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 3202 1 3234 #renameMethodProtocol 8 'Rename…' 1 1 nil nil nil 3202 1 3234 #browseMethodProtocol 8 'Browse' 1 1 nil nil nil 8 'Protocols' nil 134217729 nil nil nil nil nil nil nil 8144 nil 8 1853243664 1778 #name 8 #() 1778 #iconImageIndex 8 #() 5168 nil nil 1874 0 nil 1906 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 8784 7 257 nil 498 65 65 nil nil 1330 1 3142 5 #{UI.ListViewColumn} 8 'Protocols' 197 #left 1778 #name 8 #() 1778 #<= 8 #() nil nil 8144 nil 3 nil 1874 0 nil 1906 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 9008 7 257 nil #report 8 #() nil 133217 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 402 50 2 450 #createAt:extent: 50 2 498 1 37 498 197 239 8144 450 #text: 50 1 8 'Protocols' 8144 546 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 608 nil 35 8 'protocols' 18 #{UI.ListView} 50 45 nil 8064 50 2 8 1140920395 1 9312 5026 1330 0 nil 5088 240 nil 13 3122 nil true 50 10 3202 2097153 3234 #browseInstanceVariableReferences 8 'Browse &References' 1 1 nil nil nil 8370 4097 3202 1 3234 #addInstanceVariable 8 '&Add…' 1 1 nil nil nil 3202 1 3234 #removeInstanceVariables 8 'Remo&ve' 1 1 nil nil nil 3202 1 3234 #renameInstanceVariable 8 'Re&name' 1 1 nil nil nil 8370 4097 3202 1 3234 #pushDownInstanceVariables 8 'Push &Down' 1 1 nil nil nil 3202 1 3234 #createAccessors 8 '&Create Accessors' 1 1 nil nil nil 3202 1 3234 #abstractInstanceVariables 8 'Ab&stract' 1 1 nil nil nil 3202 1 3234 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 9312 nil 8 1853243664 1778 #value 8 #() 1874 0 nil 1906 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] #key #icon #imageIndex 9904 7 257 nil 5168 nil 1874 0 nil 1906 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] #key #name 8 '.' #, 9984 7 257 nil nil 498 65 65 nil nil 1330 1 8898 8 '' 201 #left 1792 1778 #<= 8 #() nil nil 9312 nil 1 nil nil #list 9088 nil 133217 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 402 50 1 450 #createAt:extent: 50 2 498 1 37 498 197 239 9312 546 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 608 nil 35 8 'variables' 8032 8 'categories' nil 18 #{UI.TabViewXP} 50 28 nil 7792 50 2 8 1140916864 1 10352 5026 1330 3 7904 4178 8 'Protocols' 1874 0 nil 1906 6 1 #{Core.AnsiString} 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 1986 #CardLabel 4176 #{Smalltalk} 1 10464 1986 #MethodProtocol #{Kernel.MethodProtocol} #{Smalltalk} 1 #icon #text:iconBlock: 10480 11 1 nil 21487 4178 8 'Variables' nil 21491 nil 5088 nil nil 1 nil nil nil 10352 nil 8 1852839600 1792 1778 #iconImageIndex 8 #() 5168 nil nil nil nil nil #smallIcons nil nil nil nil nil 402 50 3 450 #createAt:extent: 50 2 498 1 1 498 357 291 10352 450 #setSingleSelection: 8 #(1) 10352 450 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 10352 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 8 #() 608 nil 27 nil 7792 498 33 33 7330 8064 nil 1 7362 498 161 3 498 193 35 nil 3234 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 402 50 1 450 #createAt:extent: 50 2 498 153 9 498 197 275 8064 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 50 3 8032 8144 9312 608 nil 27 50 2 8 1140916771 1 8032 1094 3 #{UI.TreeModel} nil 5088 774 #{UI.TreeNode} nil nil nil 274 0 240 nil 31 3122 nil true 50 4 3202 1 3234 #addMethodCategory 8 '&Add…' 1 1 nil nil nil 3122 nil true 50 2 3202 1 3234 #removeMethodCategory 8 'Category' 1 1 nil nil nil 3202 1 3234 #removeMethodsInCategory 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 3202 1 3234 #renameMethodCategory 8 'Rename…' 1 1 nil nil nil 3202 1 3234 #browseMethodCategory 8 'Browse' 1 1 nil nil nil 8 'Categories' nil 134217729 nil nil nil nil nil nil nil 8032 nil 8 1852941248 1778 #localName 8 #() 1824 5168 nil nil 1874 0 nil 1906 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawCategoryTree: 11632 7 257 nil nil nil 550 #{Core.LookupTable} 0 nil #noIcons 1 274 0 402 50 1 450 #createAt:extent: 50 2 498 1 37 498 197 239 8032 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 608 nil 27 2738 10448 8144 2738 10592 9312 8032 nil nil nil 274 1 8064 8 'filters' nil 10352 8064 498 201 201 401 1 524319 nil nil 402 50 1 450 #createAt:extent: 50 2 498 733 1 498 357 291 7792 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 1 0 0 0 0 0 0 32 2 0 0 145 0 0 0] 50 2 8064 10352 608 nil 27 8 'filtersSlidey' nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 1459 291 5552 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 50 7 6368 18 #{UI.Splitter} 50 12 nil 5552 50 2 8 1140850688 1 12288 nil nil nil 519 nil nil nil 2834 12288 nil 1 #left nil nil nil 2864 2880 nil 2864 nil 402 50 1 450 #createAt:extent: 50 2 498 357 1 498 11 291 12288 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 0 0 0 0 183 0 0 0 145 0 0 0] 8 #() 608 nil 27 6144 5904 7792 5664 18 #{UI.ContainerView} 50 15 nil 5552 50 2 8 1140850688 131073 12512 nil nil nil 7 nil nil nil 12512 130 1 1 nil 18 #{UI.ContainerView} 50 15 nil 12512 50 2 8 1140850688 131073 12592 nil nil nil 535 nil nil nil 12592 1378 11 1 1 274 2 18 #{UI.RadioButton} 50 16 nil 12592 50 2 8 1141055497 1 12688 1094 2 #{UI.ValueHolder} nil nil 518 #{Kernel.PluggableSearchPolicy} 1778 #= 8 #() 1778 #hash 8 #() false nil nil 519 nil nil nil 12688 nil 8 1853182784 518 #{UI.NullConverter} nil nil nil 402 50 2 450 #createAt:extent: 50 2 498 161 7 498 97 39 12688 450 #text: 50 1 8 'C&lass' 12688 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 3 0 0 0 128 0 0 0 22 0 0 0] 8 #() 608 nil 27 8 'classMode' 18 #{UI.RadioButton} 50 16 nil 12592 50 2 8 1141055497 1 13136 12754 nil nil 12786 1778 #= 8 #() 1778 #hash 8 #() false nil nil 519 nil nil nil 13136 nil 8 1853182784 12898 nil nil nil 402 50 2 450 #createAt:extent: 50 2 498 21 7 498 131 39 13136 450 #text: 50 1 8 'In&stance' 13136 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 3 0 0 0 75 0 0 0 22 0 0 0] 8 #() 608 nil 27 8 'instanceMode' 7362 498 21 7 498 1 7 402 50 1 450 #createAt:extent: 50 2 498 1 241 498 361 51 12592 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 120 0 0 0 180 0 0 0 145 0 0 0] 50 2 13136 12688 608 nil 27 nil nil 18 #{UI.ReferenceView} 50 14 nil 12512 50 2 8 1140916224 131073 13728 nil nil nil 31 nil nil nil 13728 370 #{Tools.MethodBrowser} #resource_Class_browser_method_list nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 361 241 13728 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 180 0 0 0 120 0 0 0] 592 608 nil 27 274 2 12592 8 'mode' 13728 8 'methods' nil 402 50 1 450 #createAt:extent: 50 2 498 1099 1 498 361 291 12512 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 37 2 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 50 2 13728 12592 608 nil 27 608 nil 27 8 'classes' nil 402 50 1 450 #createAt:extent: 50 2 498 1 51 498 1459 593 2608 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 217 2 0 0 65 1 0 0] 50 3 5552 2768 3056 608 nil 27 274 2 1552 8 'statusbar' 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 9 3122 nil true 50 8 3202 1 3234 #fileNew 8 '&New' 9373 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'NewWorkspace.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 3202 1 3234 #fileOpen 8 '&Open…' 9375 1 14466 nil true 14498 8 'OpenWorkspace.ico' 14560 65541 nil nil nil 3202 1 3234 #fileFileIn 8 '&File In…' 1 1 14466 nil true 14498 8 'FileIn.ico' 14560 65541 nil nil nil 8370 4097 3202 1 3234 #saveImage 8 'Sa&ve Image' 1 1 14466 nil true 14498 8 'Snapshot.ico' 14560 65541 nil nil nil 3202 1 3234 #smalltalkExit 8 'E&xit Dolphin' 1 1 14466 nil true 14498 8 'PowerSwitch.ico' 14560 65541 nil nil nil 8370 4097 3202 1 3234 #exit 8 '&Close' 17639 1 2374 2 #{Graphics.TextTileIcon} 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 50883 nil nil 3122 nil true 50 13 3202 1 3234 #undo 8 '&Undo' 9397 1 14466 nil true 14498 8 'EditUndo.ico' 14560 65541 nil nil nil 8370 4097 3202 1 3234 #cutSelection 8 'Cu&t' 9393 1 14466 nil true 14498 8 'EditCut.ico' 14560 65541 nil nil nil 3202 1 3234 #copySelection 8 '&Copy' 9351 1 14466 nil true 14498 8 'EditCopy.ico' 14560 65541 nil nil nil 3202 1 3234 #pasteClipboard 8 '&Paste' 9389 1 14466 nil true 14498 8 'EditPaste.ico' 14560 65541 nil nil nil 3202 1 3234 #editDelete 8 '&Delete' 1 1 14466 nil true 14498 8 'EditClear.ico' 14560 65541 nil nil nil 3122 nil true 50 2 3202 1 3234 #reformatSource 8 '&Source' 9391 1 nil nil nil 3202 1 3234 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 50899 nil nil 8370 4097 3202 1 3234 #selectAll 8 'Select &All' 9347 1 nil nil nil 8370 4097 3202 1 3234 #editFind 8 '&Find…' 9357 1 14466 nil true 14498 8 'Find.ico' 14560 65541 nil nil nil 3202 1 3234 #findNext 8 'Find &Next' 1253 1 14466 nil true 14498 8 'FindNext.ico' 14560 65541 nil nil nil 3202 1 3234 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 50909 nil nil 3122 nil true 50 17 3202 1 3234 #browseIt 8 '&Browse It' 9349 1 14466 nil true 14498 8 'ClassBrowserShell.ico' 14560 65541 nil nil nil 3202 1 3234 #displayIt 8 '&Display It' 9353 1 14466 nil true 14498 8 'DisplayIt.ico' 14560 65541 nil nil nil 3202 1 3234 #printIt 8 '&Print It' 9377 1 14466 nil true 14498 8 'PrintIt.ico' 14560 65541 nil nil nil 3202 1 3234 #evaluateIt 8 '&Evaluate It' 9355 1 14466 nil true 14498 8 'EvaluateIt.ico' 14560 65541 nil nil nil 3202 1 3234 #inspectIt 8 '&Inspect It' 9363 1 14466 nil true 14498 8 'InspectIt.ico' 14560 65541 nil nil nil 3202 1 3234 #debugIt 8 'Deb&ug It' 1269 1 14466 nil true 14498 8 'Debugger.ico' 14560 65541 nil nil nil 3202 1 3234 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 8370 4097 3202 1 3234 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 3202 1 3234 #browseReferences 8 'Re&ferences' 5367 1 nil nil nil 8370 4097 3202 2097153 3234 #accept 8 '&Accept' 9383 1 nil nil nil 3202 1 3234 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 8370 4097 3122 nil true 50 14 3202 1 3234 #renameVariable 8 'Re&name <1d>…' 1 1 nil nil nil 8370 4097 3202 1 3234 #extractToTemporary 8 'Extract to &Temporary…' 9385 1 nil nil nil 3202 1 3234 #extractMethod 8 'E&xtract Method…' 9371 1 nil nil nil 3202 1 3234 #extractToComponent 8 'Extract to &Component…' 1 1 nil nil nil 3202 1 3234 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 8370 4097 3202 1 3234 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 3202 1 3234 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 3202 1 3234 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 8370 4097 3202 1 3234 #addParameterToMessage 8 '&Add Parameter to <1d>…' 1 1 nil nil nil 3202 1 3234 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 3202 1 3234 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 '&Refactorings' #codeRefactoringsMenu 134217729 14466 nil true 14498 8 'Refactoring.ico' 14560 65541 nil nil 50955 nil nil 8370 4097 3122 nil true 50 7 3202 1 3234 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3202 1 3234 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3202 1 3234 #toggleLineEndings 8 'Line &Endings' 1 1 15058 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 3202 1 3234 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3202 1 3234 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3202 1 3234 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3202 1 3234 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 14466 nil true 14498 8 'Preferences.ico' 14560 65541 nil nil 50971 nil nil 8 '&Workspace' nil 134217729 nil nil 50973 nil nil 3122 nil true 50 17 3202 2097153 3234 #findClass 8 'Find…' 1 1 14466 nil true 14498 8 'FindClass.ico' 14560 65541 nil nil nil 3122 nil true 50 10 3202 1 3234 #browseClassPackage 8 'Package <1d>' 1 1 14466 nil true 14498 8 'Package.ico' 14560 65541 nil nil nil 8370 4097 3202 2097153 3234 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 3122 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil 50981 nil nil 8370 4097 3202 1 3234 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 3202 1 3234 #browseMethodHistoryForClass 8 'Method &History' 1 1 14466 nil true 14498 8 'MethodHistory.ico' 14560 65541 nil nil nil 8370 4097 3202 1 3234 #browsePublishedEvents 8 'Published &events' 1 1 14466 nil true 14498 8 'Event.ico' 14560 65541 nil nil nil 3202 1 3234 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil 50991 nil nil 8370 4097 3202 1 3234 #newClass 8 '&New…' 1 1 14466 nil true 14498 8 'NewClass.ico' 14560 65541 nil nil nil 3202 1 3234 #removeClass 8 'Re&move' 1 1 14466 nil true 14498 8 'ClassDelete.ico' 14560 65541 nil nil nil 3122 nil true 50 18 3202 2097153 3234 #renameClass 8 'Re&name…' 1 1 14466 nil true 14498 8 'Rename.ico' 14560 65541 nil nil nil 3202 1 3234 #copyClass 8 'Cl&one…' 1 1 nil nil nil 8370 4097 3202 1 3234 #addInstanceVariable 8 'Add <1s>&Instance Variable…' 1 1 nil nil nil 3202 1 3234 #addClassVariable 8 'Add &Class Variable…' 1 1 nil nil nil 3122 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil 51005 nil nil 3122 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil 51007 nil nil 8370 4097 3122 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil 51009 nil nil 3122 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil 51011 nil nil 8370 4097 3122 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil 51013 nil nil 3122 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil 51015 nil nil 3122 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil 51017 nil nil 8370 4097 3202 1 3234 #convertToSibling 8 'Con&vert to Sibling…' 1 1 nil nil nil 8370 4097 3202 1 3234 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 14466 nil true 14498 8 'Refactoring.ico' 14560 65541 nil nil 51023 nil nil 8370 4097 3202 1 3234 #createInstanceVariableAccessors 8 'Create &Accessors…' 1 1 nil nil nil 3202 1 3234 #reformatAll 8 'Re&format All' 1 1 nil nil nil 8370 4097 3202 1 3234 #fileInClass 8 'File &In…' 1 1 14466 nil true 14498 8 'FileIn.ico' 14560 65541 nil nil nil 3202 1 3234 #fileOutClass 8 'File &Out…' 1 1 nil nil nil 8370 4097 3202 1 3234 #classPackage 8 '&Package…' 1 1 14466 nil true 14498 8 'Package.ico' 14560 65541 nil nil nil 3202 1 3234 #categorizeClass 8 '&Category…' 1 1 14466 nil true 14498 8 'Category.ico' 14560 65541 nil nil nil 8370 4097 3122 nil true 50 4 3202 1 3234 #newView 8 '&New…' 1 1 nil nil nil 8370 4097 3122 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 14466 nil true 14498 8 'ViewComposer.ico' 14560 65541 nil nil 51039 nil nil 3122 nil true 8 #() 8 '&Show' #viewsShowMenu 1 14466 nil true 14498 8 'TestView.ico' 14560 65541 nil nil 51041 nil nil 8 '&Views' #viewsMenu 134217729 14466 nil true 14498 8 'View.ico' 14560 65541 nil nil 51043 nil nil 8 '&Class' nil 134217729 nil nil 51045 nil nil 3122 nil true 50 15 3122 nil true 8 #() 8 '&Definitions of' #definitionsMenu 1 nil nil 51047 nil nil 3122 nil true 8 #() 8 'Re&ferences to' #referencesMenu 1 nil nil 51049 nil nil 3122 nil true 50 14 3202 1 3234 #browseReferencesToGlobal 8 'References to Global…' 1 1 nil nil nil 3202 1 3234 #browseContainingText 8 'C&ontaining Text…' 1 1 14466 nil true 14498 8 'SearchText.ico' 14560 65541 nil nil nil 3202 1 3234 #browseMethodCategory 8 'Cate&gory…' 1 1 14466 nil true 14498 8 'Category.ico' 14560 65541 nil nil nil 3202 1 3234 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 3202 1 3234 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 8370 4097 3202 1 3234 #browseMethodPackages 8 '&Package <s>' 1 1 14466 nil true 14498 8 'Package.ico' 14560 65541 nil nil nil 3202 1 3234 #browseMethodClasses 8 '&Class <s>' 1 1 nil nil nil 8370 4097 3202 1 3234 #browseMethodHistory 8 'Change &History' 1 1 14466 nil true 14498 8 'MethodHistory.ico' 14560 65541 nil nil nil 3202 1 3234 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8370 4097 3202 1 3234 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 3202 1 3234 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 51073 nil nil 8370 4097 3202 1 3234 #newMethod 8 '&New' 1 1 14466 nil true 14498 8 'NewMethod.ico' 14560 65541 nil nil nil 3202 1 3234 #removeMethod 8 'Re&move' 1 1 14466 nil true 14498 8 'MethodDelete.ico' 14560 65541 nil nil nil 3122 nil true 50 16 3202 1 3234 #renameMethod 8 'Re&name' 1 1 14466 nil true 14498 8 'Rename.ico' 14560 65541 nil nil nil 3202 1 3234 #renameMethodReferences 8 'Rename Re&ferences…' 1 1 nil nil nil 8370 4097 3202 1 3234 #addParameter 8 'Add &Parameter…' 1 1 nil nil nil 3122 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 51085 nil nil 3122 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 51087 nil nil 3122 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 51089 nil nil 8370 4097 3122 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 51091 nil nil 3122 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 51093 nil nil 8370 4097 3202 1 3234 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 3202 1 3234 #pushUpMethods 8 'Push &Up' 13421 1 nil nil nil 3202 1 3234 #pushDownMethods 8 'Push &Down' 13423 1 nil nil nil 3202 1 3234 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 3202 1 3234 #moveMethod 8 'Move to &Component…' 1 1 nil nil nil 8 '&Refactorings' #methodRefactoringsMenu 134217729 14466 nil true 14498 8 'Refactoring.ico' 14560 65541 nil nil 51105 nil nil 8370 4097 3202 1 3234 #methodPackage 8 '&Package…' 1 1 14466 nil true 14498 8 'Package.ico' 14560 65541 nil nil nil 3122 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 51109 nil nil 3122 nil true 8 #() 8 'Remo&ve from Category' #removeCategoryMenu 134217729 nil nil 51111 nil nil 3202 1 3234 #togglePrivate 8 'Priva&te' 1 1 nil nil nil 8370 4097 3202 1 3234 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 3202 1 3234 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 51119 nil nil 3122 nil true 50 7 3202 1 3234 #undoChange 8 '&Undo <1d>' 1 1 14466 nil true 14498 8 'EditUndo.ico' 14560 65541 nil nil nil 3202 1 3234 #redoChange 8 '&Redo <1d>' 1 1 14466 nil true 14498 8 'EditRedo.ico' 14560 65541 nil nil nil 3202 1 3234 #clearChangeHistory 8 'Clear Change &History' 1 1 14466 nil true 14498 8 'MethodHistoryErase.ico' 14560 65541 nil nil nil 8370 4097 3202 1 3234 #historyBack 8 'Back to <1d>' 1 1 14466 nil true 14498 8 'HistoryBack.ico' 14560 65541 nil nil nil 3202 1 3234 #historyForward 8 'Forward to <1d>' 1 1 14466 nil true 14498 8 'HistoryForward.ico' 14560 65541 nil nil nil 3202 1 3234 #historyClear 8 'Clear Visit History' 1 1 14466 nil true 14498 8 'HistoryErase.ico' 14560 65541 nil nil nil 8 'H&istory' nil 134217729 nil nil 51133 nil nil 3122 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 51135 nil nil 3122 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 51137 nil nil 3122 nil true 50 15 3202 1 3234 #helpContents 8 '&Contents' 1025 1 14466 nil true 14498 8 'Help.ico' 14560 65541 nil nil nil 3202 1 3234 #help 8 'On this &Tool' 1249 1 nil nil nil 3202 1 3234 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 8370 4097 3202 1 3234 #learnSmalltalk 8 'Learn Smalltalk' 1 1 15058 8 $🎓 nil 226 #orchid 226 #white nil nil 1 nil nil nil nil 8370 4097 3202 1 3234 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3202 1 3234 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3202 1 3234 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 8370 4097 3202 1 3234 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 14466 nil true 14498 8 '!!APPLICATION' 14560 65541 nil nil nil 3202 1 3234 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3202 1 3234 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 8370 4097 3202 1 3234 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 15058 8 $🐬 nil nil 226 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 51161 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 402 50 2 450 #createAt:extent: 50 2 498 6143 21 498 1491 801 32 450 #text: 50 1 8 'System Browser' 32 546 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 232 14 0 0 154 1 0 0] 50 3 160 2608 1552 608 nil 27)!

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

