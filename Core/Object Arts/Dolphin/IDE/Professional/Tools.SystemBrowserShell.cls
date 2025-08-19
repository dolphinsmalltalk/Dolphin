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

	^(super isEditableMethod: aCompiledMethod)
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 533 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 160 nil nil nil 517 nil nil nil 160 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 8 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 304 nil nil nil 5 nil nil nil 304 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Class_browser_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[11 2 0 0 0 0 0 0 187 2 0 0 25 0 0 0] 193 336 8 '' 304 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 8 'classBrowserTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 656 nil nil nil 5 nil nil nil 656 370 #{UI.Toolbar} #resource_Image_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 688 8 '' 656 3 592 610 193 193 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 896 nil nil nil 5 nil nil nil 896 370 #{UI.Toolbar} #resource_Search_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[51 1 0 0 0 0 0 0 11 2 0 0 25 0 0 0] 193 928 8 '' 896 3 592 610 193 193 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1136 nil nil nil 5 nil nil nil 1136 370 #{UI.Toolbar} #resource_Smalltalk_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 1168 8 '' 1136 3 592 610 193 193 nil 27 8 'smalltalkTools' nil nil nil nil 550 #{Core.OrderedCollection} 0 nil nil 9 1399 #smallIcons nil nil 838 1 #{UI.FlowLayout} 1 1 1 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 217 2 0 0 25 0 0 0] 193 192 8 '' 160 3 50 4 656 1136 896 304 610 193 193 nil 31 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140852996 1 1600 nil nil nil 5 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 77 0 105 0 99 0 114 0 111 0 115 0 111 0 102 0 116 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1600 nil nil 258 #{Core.IdentityDictionary} 50 8 1862 1 #{UI.StatusBarItem} 8193 -1 1600 nil 518 #{Core.Message} #displayString 8 #() 1810 #iconImageIndex 1840 nil 8 'message' 1778 8193 45 1600 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 5 1 1904 8 'doIt' 8 '[:modified | modified ifTrue: [Tools.SmalltalkSystem changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 1094 2 #{Kernel.VariableBinding} #SmalltalkSystem #{Tools.SmalltalkSystem} #{Tools} 1 #changedIcon #imageIndex 1920 #ifTrue: 7 257 nil 1906 0 nil 1938 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:modified | modified ifTrue: [''Unsaved edits'']]' 8 #[30 105 17 119 29 106 60 106] 8 'Unsaved edits' 2048 #ifTrue: 7 257 nil 8 'modified' 1778 8705 351 1600 nil 1810 #displayString 8 #() 1810 #iconImageIndex 8 #() 1906 0 nil 1938 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:namespace | ''Method namespace: '', namespace fullName]' 8 #[32 105 29 226 1 178 106] 8 'Method namespace: ' #fullName #, 2240 7 257 nil 8 'namespace' 1778 8193 401 1600 nil 1810 #displayString 8 #() 1810 #iconImageIndex 8 #() nil 8 'packageOfSelection' nil nil nil 50 4 2352 1888 1792 2160 1094 1 #{UI.StatusBarNullItem} 8705 1 1600 nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 65 1 0 0 217 2 0 0 85 1 0 0] 193 1632 8 '' 1600 3 8 #() 610 193 193 nil 29 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2656 nil nil nil 5 nil nil nil 2656 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 1 518 #{Core.Association} 18 #{UI.Splitter} 50 12 nil 2656 50 2 8 1140850688 1 2832 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2832 nil 1 #left nil nil nil 610 1 1 610 9 9 nil 2928 nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 145 0 0 0 217 2 0 0 150 0 0 0] 193 2864 8 '' 2832 3 8 #() 610 193 193 nil 27 1 true 258 #{Core.IdentityDictionary} 50 4 18 #{UI.CardContainer} 50 16 nil 2656 50 2 8 1140850688 131073 3152 nil nil nil 21 2886 4 #{UI.Menu} nil true 50 2 3218 nil true 50 4 1094 2 #{UI.CommandMenuItem} 1025 1350 4 #{UI.CommandDescription} 1810 #tabOrientation: 8 #(#top) 8 '&Top' 1 1 nil nil nil 3298 1025 3330 1810 #tabOrientation: 8 #(#bottom) 8 '&Bottom' 1 1 nil nil nil 3298 1025 3330 1810 #tabOrientation: 8 #(#left) 8 '&Left' 1 1 nil nil nil 3298 1025 3330 1810 #tabOrientation: 8 #(#right) 8 '&Right' 1 1 nil nil nil 8 '&Orientation' nil 134217729 nil nil nil nil nil 3218 nil true 50 6 3298 1025 3330 1810 #viewMode: 8 #(#noIcons) 8 '&No Icons' 1 1 nil nil nil 3298 1025 3330 1810 #viewMode: 8 #(#smallIcons) 8 '&Small Icons' 1 1 nil nil nil 3298 1025 3330 1810 #viewMode: 8 #(#mediumIcons) 8 '&Medium Icons' 1 1 nil nil nil 3298 1025 3330 1810 #viewMode: 8 #(#largeIcons) 8 '&Large Icons' 1 1 nil nil nil 3298 1025 3330 1810 #viewMode: 8 #(#tileIcons) 8 '&Tile Icons' 1 1 nil nil nil 3298 1 3330 1810 #viewMode: 8 #(#thumbnails) 8 'Thum&bnails' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3152 1350 1 #{UI.CardLayout} 1378 2 2802 838 1 #{UI.CardLabel} 8 'Method source' 1906 0 nil 1938 7 1 4272 8 'doIt' 8 '(CardLabel text: ''Method source'' iconBlock: [Icon fromId: ''MethodSource.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 2018 #CardLabel 4272 #{UI} 1 4304 2018 #Icon #{Graphics.Icon} #{Graphics} 1 8 'MethodSource.ico' #fromId: #text:iconBlock: 4320 11 1 nil nil 18 #{UI.ReferenceView} 50 14 nil 3152 50 2 8 1140850688 131073 4448 nil nil nil 5 nil nil nil 4448 370 #{Tools.MethodWorkspace} #resource_Default_view nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[4 0 0 0 24 0 0 0 213 2 0 0 142 0 0 0] 193 4480 8 '' 4448 3 592 610 193 193 nil 27 2802 4274 8 'Class definition' 1906 0 nil 1938 7 1 4272 8 'doIt' 8 '(CardLabel text: ''Class definition'' iconBlock: [Icon fromId: ''ClassDefinition.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 4400 4704 4416 8 'ClassDefinition.ico' #fromId: #text:iconBlock: 4720 11 1 nil nil 18 #{UI.ReferenceView} 50 14 nil 3152 50 2 8 1140916224 131073 4816 nil 240 nil 21 nil nil nil 4816 370 #{Tools.SmalltalkWorkspace} #resource_Default_view nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[4 0 0 0 24 0 0 0 213 2 0 0 142 0 0 0] 193 4848 8 '' 4816 1 592 610 193 193 nil 27 4448 nil nil nil 258 #{Core.IdentityDictionary} 50 4 4816 8 'definition' 4448 8 'source' nil 18 #{UI.TabViewXP} 50 28 nil 3152 50 2 8 1140916736 1 5104 838 2 #{UI.ListModel} 1378 2 4288 4688 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 17 nil nil nil 5104 nil nil 1824 1810 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil #smallIcons nil nil nil nil nil 402 50 3 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 217 2 0 0 146 0 0 0] 193 5136 8 '' 5104 450 #setSingleSelection: 8 #(1) 5104 450 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 5104 3 8 #() 610 193 193 nil 27 402 50 2 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 150 0 0 0 217 2 0 0 40 1 0 0] 193 3184 8 '' 3152 450 #contextMenu: 50 1 3232 3152 3 50 3 4448 4816 5104 610 193 193 nil 27 8 'cards' 18 #{UI.ContainerView} 50 15 nil 2656 50 2 8 1140850688 131073 5744 nil nil nil 5 nil nil nil 5744 2722 2754 #{Core.Dictionary} 50 2 2802 18 #{UI.Splitter} 50 12 nil 5744 50 2 8 1140850688 1 5872 nil nil nil 517 nil nil nil 2898 5872 nil 1 #left nil nil nil 2928 2944 nil 2928 nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[105 1 0 0 0 0 0 0 110 1 0 0 145 0 0 0] 193 5904 8 '' 5872 3 8 #() 610 193 193 nil 27 1 2802 18 #{UI.Splitter} 50 12 nil 5744 50 2 8 1140850688 1 6128 nil nil nil 517 nil nil nil 2898 6128 nil 1 #left nil nil nil 2928 2944 nil 2928 nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[32 2 0 0 0 0 0 0 37 2 0 0 145 0 0 0] 193 6160 8 '' 6128 3 8 #() 610 193 193 nil 27 1 false 258 #{Core.IdentityDictionary} 50 6 18 #{UI.ReferenceView} 50 14 nil 5744 50 2 8 1140916224 131073 6400 nil nil nil 5 nil nil nil 6400 370 #{Tools.ClassListSelector} #resource_Default_view nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[183 0 0 0 0 0 0 0 105 1 0 0 145 0 0 0] 193 6432 8 '' 6400 3 592 610 193 193 nil 27 8 'classes' 18 #{UI.SlideyInneyOuteyThing} 50 23 nil 5744 50 2 8 1140850688 131073 6640 nil nil nil 517 nil nil nil 6640 4210 1378 3 2802 4274 8 'Categories' 1906 0 nil 1938 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[MethodCategory icon]' 8 #[31 105 45 159 106] 2018 #MethodCategory #{Core.MethodCategory} #{Core} 1 #icon 6784 7 1 nil 21481 18 #{UI.TreeView} 50 35 nil 18 #{UI.SlidingCardTray} 50 22 nil 6640 50 2 8 1140850688 131073 6912 nil nil nil 5 nil nil nil 6912 6704 258 #{Core.IdentityDictionary} 50 6 6880 8 'categories' 18 #{UI.ListView} 50 45 nil 6912 50 2 8 1140936777 1 7024 5170 1378 0 nil 5232 240 nil 29 3218 nil true 50 7 3298 1 3330 #browseSelectorsInProtocol 8 '&Selectors' 1 1 nil nil nil 3298 1 3330 #toggleProtocolReadOnly 8 '&Read Only' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 3298 1 3330 #addMethodProtocol 8 '&Add…' 1 1 nil nil nil 3218 nil true 50 2 3298 1 3330 #removeMethodProtocol 8 'Protocol' 1 1 nil nil nil 3298 1 3330 #removeMethodsInProtocol 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 3298 1 3330 #renameMethodProtocol 8 'Rename…' 1 1 nil nil nil 3298 1 3330 #browseMethodProtocol 8 'Browse' 1 1 nil nil nil 8 'Protocols' nil 134217729 nil nil nil nil nil nil nil 7024 nil nil 1810 #name 8 #() 1810 #iconImageIndex 8 #() 5296 nil nil 1906 0 nil 1938 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 7648 7 257 nil 610 65 65 nil nil 1378 1 3142 5 #{UI.ListViewColumn} 8 'Protocols' 203 #left 1810 #name 8 #() 1810 #<= 8 #() nil nil 7024 nil 3 nil 1906 0 nil 1938 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 7872 7 257 nil #report 8 #() nil 133217 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 7024 nil nil nil nil nil nil nil nil nil 402 50 2 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 18 0 0 0 101 0 0 0 137 0 0 0] 193 7056 8 'Protocols' 7024 450 #contextMenu: 50 1 7120 7024 1 8 #() 610 193 193 nil 35 8 'protocols' 18 #{UI.ListView} 50 45 nil 6912 50 2 8 1140920395 1 8208 5170 1378 0 nil 5232 240 nil 13 3218 nil true 50 10 3298 2097153 3330 #browseInstanceVariableReferences 8 'Browse &References' 1 1 nil nil nil 7250 4097 3298 1 3330 #addInstanceVariable 8 '&Add…' 1 1 nil nil nil 3298 1 3330 #removeInstanceVariables 8 'Remo&ve' 1 1 nil nil nil 3298 1 3330 #renameInstanceVariable 8 'Re&name' 1 1 nil nil nil 7250 4097 3298 1 3330 #pushDownInstanceVariables 8 'Push &Down' 1 1 nil nil nil 3298 1 3330 #createAccessors 8 '&Create Accessors' 1 1 nil nil nil 3298 1 3330 #abstractInstanceVariables 8 'Ab&stract' 1 1 nil nil nil 3298 1 3330 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 8208 nil nil 1810 #value 8 #() 1906 0 nil 1938 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] #key #icon #imageIndex 8784 7 257 nil 5296 nil 1906 0 nil 1938 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] #key #name 8 '.' #, 8864 7 257 nil nil 610 65 65 nil nil 1378 1 7762 8 '' 201 #left 1824 1810 #<= 8 #() nil nil 8208 nil 1 nil nil #list 7952 nil 133217 nil 1 nil nil nil nil 1 7970 8208 nil nil nil nil nil nil nil nil nil 402 50 2 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 18 0 0 0 101 0 0 0 137 0 0 0] 193 8240 8 '' 8208 450 #contextMenu: 50 1 8304 8208 1 8 #() 610 193 193 nil 35 8 'variables' nil 18 #{UI.TabViewXP} 50 28 nil 6640 50 2 8 1140916864 1 9280 5170 1378 3 6752 4274 8 'Protocols' 1906 0 nil 1938 6 1 #{Core.AnsiString} 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 4400 9392 2018 #MethodProtocol #{Kernel.MethodProtocol} #{Kernel} 1 #icon #text:iconBlock: 9408 11 1 nil 21487 4274 8 'Variables' nil 21491 nil 5232 nil nil 1 nil nil nil 9280 nil nil 1824 1810 #iconImageIndex 8 #() 5296 nil nil nil nil nil #smallIcons nil nil nil nil nil 402 50 3 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 193 9312 8 '' 9280 450 #setSingleSelection: 8 #(1) 9280 450 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 9280 3 8 #() 610 193 193 nil 27 nil 6640 610 33 33 1606 1 #{UI.ButtonInteractor} 6912 nil 1 518 #{Graphics.Rectangle} 610 167 3 610 199 35 nil 3330 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[73 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 193 6944 8 '' 6912 3 50 3 6880 7024 8208 610 193 193 nil 27 50 2 8 1140916771 1 6880 1094 3 #{UI.TreeModel} nil 5232 774 #{UI.TreeNode} nil nil nil 550 #{Core.IdentityDictionary} 0 240 nil 29 3218 nil true 50 4 3298 1 3330 #addMethodCategory 8 '&Add…' 1 1 nil nil nil 3218 nil true 50 2 3298 1 3330 #removeMethodCategory 8 'Category' 1 1 nil nil nil 3298 1 3330 #removeMethodsInCategory 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 3298 1 3330 #renameMethodCategory 8 'Rename…' 1 1 nil nil nil 3298 1 3330 #browseMethodCategory 8 'Browse' 1 1 nil nil nil 8 'Categories' nil 134217729 nil nil nil nil nil nil nil 6880 nil nil 1810 #localName 8 #() 1856 5296 nil nil 1906 0 nil 1938 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawCategoryTree: 10592 7 257 nil nil nil 550 #{Core.LookupTable} 0 nil #noIcons 1 10194 0 1 262 #{UI.TreeViewDynamicUpdateMode} 6880 nil nil nil nil nil nil 402 50 2 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 18 0 0 0 101 0 0 0 137 0 0 0] 193 10096 8 '' 6880 450 #contextMenu: 50 1 10224 6880 3 8 #() 610 193 193 nil 29 2802 9376 7024 2802 9504 8208 6880 nil nil nil 258 10192 50 2 6912 8 'filters' nil 9280 6912 610 201 201 401 1 524319 nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[110 1 0 0 0 0 0 0 32 2 0 0 145 0 0 0] 193 6672 8 '' 6640 3 50 2 6912 9280 610 193 193 nil 27 8 'filtersSlidey' 18 #{UI.SlideyInneyOuteyThing} 50 23 nil 5744 50 2 8 1140850688 131073 11216 nil nil nil 517 nil nil nil 11216 4210 1378 1 2802 4274 8 'Packages' 450 #icon 8 #() #{Kernel.Package} 21511 18 #{UI.SlidingCardTray} 50 22 nil 11216 50 2 8 1140850688 131073 11392 nil nil nil 5 nil nil nil 11392 4210 1378 1 2802 4274 8 'Packages' 450 #icon 8 #() #{Kernel.Package} 21511 18 #{UI.ReferenceView} 50 14 nil 11392 50 2 8 1140850688 131073 11568 nil nil nil 5 nil nil nil 11568 370 #{Tools.PackageSelector} #resource_Default_view nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 18 0 0 0 147 0 0 0 137 0 0 0] 193 11600 8 '' 11568 3 592 610 193 193 nil 27 11568 nil nil nil 258 10192 50 2 11568 8 'packages' nil 18 #{UI.TabViewXP} 50 28 nil 11216 50 2 8 1140916864 1 11840 5170 1378 1 11504 nil 5232 nil nil 1 nil nil nil 11840 nil nil 1824 1810 #iconImageIndex 8 #() 5296 nil nil nil nil nil #smallIcons nil nil nil nil nil 402 50 3 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 193 11872 8 '' 11840 450 #setSingleSelection: 8 #(1) 11840 450 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 11840 3 8 #() 610 193 193 nil 27 nil 11216 610 33 33 9810 11392 nil 1 9842 610 259 3 610 291 35 nil 3330 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[27 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 193 11424 8 '' 11392 3 50 1 11568 610 193 193 nil 27 nil nil nil nil 10194 0 nil 11840 11392 610 201 201 401 1 524319 nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 193 11248 8 '' 11216 3 50 2 11392 11840 610 193 193 nil 27 8 'packagesSlidey' nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 193 5776 8 '' 5744 3 50 7 11216 18 #{UI.Splitter} 50 12 nil 5744 50 2 8 1140850688 1 12816 nil nil nil 517 nil nil nil 2898 12816 nil 1 #left nil nil nil 2928 2944 nil 2928 nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[178 0 0 0 0 0 0 0 183 0 0 0 145 0 0 0] 193 12848 8 '' 12816 3 8 #() 610 193 193 nil 27 6400 5872 6640 6128 18 #{UI.ContainerView} 50 15 nil 5744 50 2 8 1140850688 131073 13056 nil nil nil 5 nil nil nil 13056 130 1 1 nil 18 #{UI.ContainerView} 50 15 nil 13056 50 2 8 1140850688 131073 13136 nil nil nil 533 nil nil nil 13136 1410 11 1 1 258 10192 50 4 18 #{UI.RadioButton} 50 16 nil 13136 50 2 8 1141055497 1 13248 1094 2 #{UI.ValueHolder} nil nil 518 #{Kernel.PluggableSearchPolicy} 1810 #= 8 #() 1810 #hash 8 #() false nil nil 517 nil nil nil 13248 nil nil 518 #{UI.NullConverter} nil nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[77 0 0 0 3 0 0 0 122 0 0 0 20 0 0 0] 193 13280 8 'C&lass' 13248 3 8 #() 610 193 193 nil 27 8 'classMode' 18 #{UI.RadioButton} 50 16 nil 13136 50 2 8 1141055497 1 13648 13314 nil nil 13346 1810 #= 8 #() 1810 #hash 8 #() false nil nil 517 nil nil nil 13648 nil nil 13442 nil nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[10 0 0 0 3 0 0 0 72 0 0 0 20 0 0 0] 193 13680 8 'In&stance' 13648 3 8 #() 610 193 193 nil 27 8 'instanceMode' 9842 610 21 7 610 1 7 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 122 0 0 0 180 0 0 0 145 0 0 0] 193 13168 8 '' 13136 3 50 2 13648 13248 610 193 193 nil 27 nil nil 18 #{UI.ReferenceView} 50 14 nil 13056 50 2 8 1140916224 131073 14208 nil nil nil 29 nil nil nil 14208 370 #{Tools.MethodBrowser} #resource_Class_browser_method_list nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 180 0 0 0 122 0 0 0] 193 14240 8 '' 14208 3 592 610 193 193 nil 27 258 10192 50 4 14208 8 'methods' 13136 8 'mode' nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[37 2 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 193 13088 8 '' 13056 3 50 2 14208 13136 610 193 193 nil 27 610 193 193 nil 27 8 'classes' nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 25 0 0 0 217 2 0 0 65 1 0 0] 193 2688 8 '' 2656 3 50 3 5744 2832 3152 610 193 193 nil 27 258 10192 50 4 1600 8 'statusbar' 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 9 3218 nil true 50 8 3298 1 3330 #fileNew 8 '&New' 9373 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'NewWorkspace.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 3298 1 3330 #fileOpen 8 '&Open…' 9375 1 15042 nil true 15074 8 'OpenWorkspace.ico' 15136 65541 nil nil nil 3298 1 3330 #fileFileIn 8 '&File In…' 1 1 15042 nil true 15074 8 'FileIn.ico' 15136 65541 nil nil nil 7250 4097 3298 1 3330 #saveImage 8 'Sa&ve Image' 1 1 15042 nil true 15074 8 'Snapshot.ico' 15136 65541 nil nil nil 3298 1 3330 #smalltalkExit 8 'E&xit Dolphin' 1 1 15042 nil true 15074 8 'PowerSwitch.ico' 15136 65541 nil nil nil 7250 4097 3298 1 3330 #exit 8 '&Close' 17639 1 2374 2 #{Graphics.TextTileIcon} 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 3218 nil true 50 13 3298 1 3330 #undo 8 '&Undo' 9397 1 15042 nil true 15074 8 'EditUndo.ico' 15136 65541 nil nil nil 7250 4097 3298 1 3330 #cutSelection 8 'Cu&t' 9393 1 15042 nil true 15074 8 'EditCut.ico' 15136 65541 nil nil nil 3298 1 3330 #copySelection 8 '&Copy' 9351 1 15042 nil true 15074 8 'EditCopy.ico' 15136 65541 nil nil nil 3298 1 3330 #pasteClipboard 8 '&Paste' 9389 1 15042 nil true 15074 8 'EditPaste.ico' 15136 65541 nil nil nil 3298 1 3330 #editDelete 8 '&Delete' 1 1 15042 nil true 15074 8 'EditClear.ico' 15136 65541 nil nil nil 3218 nil true 50 2 3298 1 3330 #reformatSource 8 '&Source' 9391 1 nil nil nil 3298 1 3330 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil nil nil nil 7250 4097 3298 1 3330 #selectAll 8 'Select &All' 9347 1 nil nil nil 7250 4097 3298 1 3330 #editFind 8 '&Find…' 9357 1 15042 nil true 15074 8 'Find.ico' 15136 65541 nil nil nil 3298 1 3330 #findNext 8 'Find &Next' 1253 1 15042 nil true 15074 8 'FindNext.ico' 15136 65541 nil nil nil 3298 1 3330 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 3218 nil true 50 17 3298 1 3330 #browseIt 8 '&Browse <d:It>' 9349 17 15042 nil true 15074 8 'ClassBrowserShell.ico' 15136 65541 nil nil nil 3298 1 3330 #displayIt 8 '&Display It' 9353 1 15042 nil true 15074 8 'DisplayIt.ico' 15136 65541 nil nil nil 3298 1 3330 #printIt 8 '&Print It' 9377 1 15042 nil true 15074 8 'PrintIt.ico' 15136 65541 nil nil nil 3298 1 3330 #evaluateIt 8 '&Evaluate It' 9355 1 15042 nil true 15074 8 'EvaluateIt.ico' 15136 65541 nil nil nil 3298 1 3330 #inspectIt 8 '&Inspect It' 9363 1 15042 nil true 15074 8 'InspectIt.ico' 15136 65541 nil nil nil 3298 1 3330 #debugIt 8 'Deb&ug It' 1269 1 15042 nil true 15074 8 'Debugger.ico' 15136 65541 nil nil nil 3298 1 3330 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 7250 4097 3298 1 3330 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 3298 1 3330 #browseReferences 8 'Re&ferences' 5367 1 nil nil nil 7250 4097 3298 2097153 3330 #accept 8 '&Accept' 9383 1 nil nil nil 3298 1 3330 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 7250 4097 3218 nil true 50 14 3298 1 3330 #renameVariable 8 'Re&name <d:Variable>…' 1 17 nil nil nil 7250 4097 3298 1 3330 #extractToTemporary 8 'Extract to &Temporary…' 9385 1 nil nil nil 3298 1 3330 #extractMethod 8 'E&xtract Method…' 9371 1 nil nil nil 3298 1 3330 #extractToComponent 8 'Extract to &Component…' 1 1 nil nil nil 3298 1 3330 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 7250 4097 3298 1 3330 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 3298 1 3330 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 3298 1 3330 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 7250 4097 3298 1 3330 #addParameterToMessage 8 '&Add Parameter to <d:Message>…' 1 17 nil nil nil 3298 1 3330 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 3298 1 3330 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 '&Refactorings' #codeRefactoringsMenu 134217729 15042 nil true 15074 8 'Refactoring.ico' 15136 65541 nil nil nil nil nil 7250 4097 3218 nil true 50 7 3298 1 3330 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3298 1 3330 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3298 1 3330 #toggleLineEndings 8 'Line &Endings' 1 1 15634 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 3298 1 3330 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3298 1 3330 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3298 1 3330 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3298 1 3330 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 15042 nil true 15074 8 'Preferences.ico' 15136 65541 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 3218 nil true 50 17 3298 2097153 3330 #findClass 8 'Find…' 1 1 15042 nil true 15074 8 'FindClass.ico' 15136 65541 nil nil nil 3218 nil true 50 10 3298 1 3330 #browseClassPackage 8 'Package <d>' 1 17 15042 nil true 15074 8 'Package.ico' 15136 65541 nil nil nil 7250 4097 3298 2097153 3330 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 3218 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 7250 4097 3298 1 3330 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 3298 1 3330 #browseMethodHistoryForClass 8 'Method &History' 1 1 15042 nil true 15074 8 'MethodHistory.ico' 15136 65541 nil nil nil 7250 4097 3298 1 3330 #browsePublishedEvents 8 'Published &events' 1 1 15042 nil true 15074 8 'Event.ico' 15136 65541 nil nil nil 3298 1 3330 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 7250 4097 3298 1 3330 #newClass 8 '&New…' 1 1 15042 nil true 15074 8 'NewClass.ico' 15136 65541 nil nil nil 3298 1 3330 #removeClass 8 'Re&move' 1 1 15042 nil true 15074 8 'ClassDelete.ico' 15136 65541 nil nil nil 3218 nil true 50 18 3298 2097153 3330 #renameClass 8 'Re&name…' 1 1 15042 nil true 15074 8 'Rename.ico' 15136 65541 nil nil nil 3298 1 3330 #copyClass 8 'Cl&one…' 1 1 nil nil nil 7250 4097 3298 1 3330 #addInstanceVariable 8 'Add <1s>&Instance Variable…' 1 1 nil nil nil 3298 1 3330 #addClassVariable 8 'Add &Class Variable…' 1 1 nil nil nil 3218 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 3218 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 7250 4097 3218 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 3218 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 7250 4097 3218 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 3218 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 3218 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 7250 4097 3298 1 3330 #convertToSibling 8 'Con&vert to Sibling…' 1 1 nil nil nil 7250 4097 3298 1 3330 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 15042 nil true 15074 8 'Refactoring.ico' 15136 65541 nil nil nil nil nil 7250 4097 3298 1 3330 #createInstanceVariableAccessors 8 'Create &Accessors…' 1 1 nil nil nil 3298 1 3330 #reformatAll 8 'Re&format All' 1 1 nil nil nil 7250 4097 3298 1 3330 #fileInClass 8 'File &In…' 1 1 15042 nil true 15074 8 'FileIn.ico' 15136 65541 nil nil nil 3298 1 3330 #fileOutClass 8 'File &Out…' 1 1 nil nil nil 7250 4097 3298 1 3330 #classPackage 8 '&Package…' 1 1 15042 nil true 15074 8 'Package.ico' 15136 65541 nil nil nil 3298 1 3330 #categorizeClass 8 '&Category…' 1 1 15042 nil true 15074 8 'Category.ico' 15136 65541 nil nil nil 7250 4097 3218 nil true 50 4 3298 1 3330 #newView 8 '&New…' 1 1 nil nil nil 7250 4097 3218 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 15042 nil true 15074 8 'ViewComposer.ico' 15136 65541 nil nil nil nil nil 3218 nil true 8 #() 8 '&Show' #viewsShowMenu 1 15042 nil true 15074 8 'TestView.ico' 15136 65541 nil nil nil nil nil 8 '&Views' #viewsMenu 134217729 15042 nil true 15074 8 'View.ico' 15136 65541 nil nil nil nil nil 8 '&Class' #classMenu 134217729 nil nil nil nil nil 3218 nil true 50 15 3218 nil true 8 #() 8 '&Definitions of' #definitionsMenu 1 nil nil nil nil nil 3218 nil true 8 #() 8 'Re&ferences to' #referencesMenu 1 nil nil nil nil nil 3218 nil true 50 14 3298 1 3330 #browseReferencesToGlobal 8 'References to Global…' 1 1 nil nil nil 3298 1 3330 #browseContainingText 8 'C&ontaining Text…' 1 1 15042 nil true 15074 8 'SearchText.ico' 15136 65541 nil nil nil 3298 1 3330 #browseMethodCategory 8 'Cate&gory…' 1 1 15042 nil true 15074 8 'Category.ico' 15136 65541 nil nil nil 3298 1 3330 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 3298 1 3330 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 7250 4097 3298 1 3330 #browseMethodPackages 8 '&Package <s>' 1 17 15042 nil true 15074 8 'Package.ico' 15136 65541 nil nil nil 3298 1 3330 #browseMethodClasses 8 '&Class <s>' 1 17 nil nil nil 7250 4097 3298 1 3330 #browseMethodHistory 8 'Change &History' 1 1 15042 nil true 15074 8 'MethodHistory.ico' 15136 65541 nil nil nil 3298 1 3330 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 7250 4097 3298 1 3330 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 3298 1 3330 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil nil nil nil 7250 4097 3298 1 3330 #newMethod 8 '&New <s:Method>' 1 17 15042 nil true 15074 8 'NewMethod.ico' 15136 65541 nil nil nil 3298 1 3330 #removeMethod 8 'Re&move' 1 1 15042 nil true 15074 8 'MethodDelete.ico' 15136 65541 nil nil nil 3218 nil true 50 16 3298 1 3330 #renameMethod 8 'Re&name' 1 1 15042 nil true 15074 8 'Rename.ico' 15136 65541 nil nil nil 3298 1 3330 #renameMethodReferences 8 'Rename Re&ferences…' 1 1 nil nil nil 7250 4097 3298 1 3330 #addParameter 8 'Add &Parameter…' 1 1 nil nil nil 3218 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil nil nil nil 3218 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil nil nil nil 3218 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil nil nil nil 7250 4097 3218 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil nil nil nil 3218 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil nil nil nil 7250 4097 3298 1 3330 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 3298 1 3330 #pushUpMethods 8 'Push &Up' 13421 1 nil nil nil 3298 1 3330 #pushDownMethods 8 'Push &Down' 13423 1 nil nil nil 3298 1 3330 #overrideMethods 8 'Ove&rride <d:Methods>' 1 17 nil nil nil 3298 1 3330 #moveMethod 8 'Move to &Component…' 1 1 nil nil nil 8 '&Refactorings' #methodRefactoringsMenu 134217729 15042 nil true 15074 8 'Refactoring.ico' 15136 65541 nil nil nil nil nil 7250 4097 3298 1 3330 #methodPackage 8 '&Package…' 1 1 15042 nil true 15074 8 'Package.ico' 15136 65541 nil nil nil 3218 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil nil nil nil 3218 nil true 8 #() 8 'Remo&ve from Category' #removeCategoryMenu 134217729 nil nil nil nil nil 3298 1 3330 #togglePrivate 8 'Priva&te' 1 1 nil nil nil 7250 4097 3298 1 3330 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 3298 1 3330 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' #methodMenu 134217729 nil nil nil nil nil 3218 nil true 50 7 3298 1 3330 #undoChange 8 '&Undo <d>' 1 17 15042 nil true 15074 8 'EditUndo.ico' 15136 65541 nil nil nil 3298 1 3330 #redoChange 8 '&Redo <d>' 1 17 15042 nil true 15074 8 'EditRedo.ico' 15136 65541 nil nil nil 3298 1 3330 #clearChangeHistory 8 'Clear Change &History' 1 1 15042 nil true 15074 8 'MethodHistoryErase.ico' 15136 65541 nil nil nil 7250 4097 3298 1 3330 #historyBack 8 'Back to <d:…>' 1 17 15042 nil true 15074 8 'HistoryBack.ico' 15136 65541 nil nil nil 3298 1 3330 #historyForward 8 'Forward to <d:…>' 1 17 15042 nil true 15074 8 'HistoryForward.ico' 15136 65541 nil nil nil 3298 1 3330 #historyClear 8 'Clear Visit History' 1 1 15042 nil true 15074 8 'HistoryErase.ico' 15136 65541 nil nil nil 8 'H&istory' nil 134217729 nil nil nil nil nil 3218 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil nil nil nil 3218 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil nil nil nil 3218 nil true 50 15 3298 1 3330 #helpContents 8 '&Contents' 1025 1 15042 nil true 15074 8 'Help.ico' 15136 65541 nil nil nil 3298 1 3330 #help 8 'On this &Tool' 1249 1 nil nil nil 3298 1 3330 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 7250 4097 3298 1 3330 #learnSmalltalk 8 'Learn Smalltalk' 1 1 15634 8 $🎓 nil 226 #orchid 226 #white nil nil 1 nil nil nil nil 7250 4097 3298 1 3330 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3298 1 3330 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3298 1 3330 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 7250 4097 3298 1 3330 #dolphinHomePage 8 'Dolphin Homepage' 1 1 15042 nil true 15074 8 '!!APPLICATION' 15136 65541 nil nil nil 3298 1 3330 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3298 1 3330 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 7250 4097 3298 1 3330 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 15634 8 $🐬 nil nil 226 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 402 50 1 450 #createWindow: 50 1 498 9842 610 7679 21 610 9169 821 193 80 8 'System Browser' 32 1 50 3 160 2656 1600 610 193 193 nil 27)!

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

