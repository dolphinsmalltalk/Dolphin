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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #toolBackground nil 567 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.Toolbar) 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 917510 ##(Graphics.Color) #default 8 1821628656 170 192 34 8 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Toolbar) #resource_Search_tools nil 1310982 ##(Core.MessageSequence) 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 615 1 866 437 51 672 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 8 #() 866 193 193 nil 27 8 'searchTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1008 nil nil nil 7 nil nil nil 1008 738 ##(UI.Toolbar) #resource_Smalltalk_tools nil 770 34 1 818 #createAt:extent: 34 2 866 63 1 866 553 51 1008 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 960 976 nil 27 8 'smalltalkTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1232 nil nil nil 7 nil nil nil 1232 738 ##(UI.Toolbar) #resource_Image_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 63 51 1232 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 960 976 nil 27 8 'imageTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1456 nil nil nil 7 nil nil nil 1456 738 ##(UI.Toolbar) #resource_Class_browser_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1051 1 866 353 51 1456 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 189 2 0 0 25 0 0 0] 960 976 nil 27 8 'classBrowserTools' nil nil nil 170 192 960 138 144 960 nil nil 1 nil 866 33 33 nil nil 852806 1 ##(UI.FlowLayout) 1 1 1 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 1459 51 528 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 25 0 0 0] 34 4 1232 1008 672 1456 976 nil 29 410 ##(UI.StatusBar) 34 21 nil 416 34 2 8 1140852996 1 1904 nil nil nil 7 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 866 193 193 nil 1904 nil 8 1821181968 170 192 34 8 1050438 1 ##(UI.StatusBarItem) 8193 401 1904 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'packageOfSelection' 2114 8193 45 1904 nil nil 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 6 1 2176 8 'doIt' 8 '[:modified | modified ifTrue: [SmalltalkSystem current changedIcon imageIndex]]' 8 #[34 105 17 122 45 159 160 161 106 60 106] 1442886 2 ##(Kernel.VariableBinding) #'Tools.SmalltalkSystem' ##(Tools.SmalltalkSystem) ##(Smalltalk) 1 #current #changedIcon #imageIndex #ifTrue: 2192 7 257 nil 2178 0 nil 2210 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [''Unsaved edits'']]' 8 #[30 105 17 119 29 106 60 106] 8 'Unsaved edits' 2320 #ifTrue: 7 257 nil 8 'modified' 2114 8705 351 1904 nil 786950 ##(Core.Message) #displayString 8 #() 2450 #iconImageIndex 8 #() 2178 0 nil 2210 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:namespace | ''Method namespace: '', namespace fullName]' 8 #[32 105 29 226 1 178 106] 8 'Method namespace: ' #fullName #, 2528 7 257 nil 8 'namespace' 2114 8193 -1 1904 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'message' nil nil nil 34 4 2128 2160 2640 2432 1311814 1 ##(UI.StatusBarNullItem) 8705 1 1904 nil nil 770 34 1 818 #createAt:extent: 34 2 866 1 643 866 1459 41 1904 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 217 2 0 0 85 1 0 0] 8 #() 976 nil 29 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2864 nil nil nil 7 nil nil nil 2864 1376774 ##(UI.ProportionalLayout) 138 ##(Core.Dictionary) 34 1 1049094 ##(Core.Association) 410 ##(UI.Splitter) 34 12 nil 2864 34 2 8 1140850688 1 3024 nil nil nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 3024 nil 1 #left nil nil nil 866 1 1 866 9 9 nil 3120 nil 770 34 1 818 #createAt:extent: 34 2 866 1 291 866 1459 11 3024 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 0 0 0 217 2 0 0 150 0 0 0] 8 #() 976 nil 27 1 true 170 192 34 4 410 ##(UI.ContainerView) 34 15 nil 2864 34 2 8 1140850688 131073 3328 nil nil nil 7 nil nil nil 3328 2930 138 ##(Core.Dictionary) 34 2 2994 410 ##(UI.Splitter) 34 12 nil 3328 34 2 8 1140850688 1 3456 nil nil nil 519 nil nil nil 3090 3456 nil 1 #left nil nil nil 3120 3136 nil 3120 nil 770 34 1 818 #createAt:extent: 34 2 866 1089 1 866 11 291 3456 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 2 0 0 0 0 0 0 37 2 0 0 145 0 0 0] 8 #() 976 nil 27 1 2994 410 ##(UI.Splitter) 34 12 nil 3328 34 2 8 1140850688 1 3696 nil nil nil 519 nil nil nil 3090 3696 nil 1 #left nil nil nil 3120 3136 nil 3120 nil 770 34 1 818 #createAt:extent: 34 2 866 723 1 866 11 291 3696 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 1 0 0 0 0 0 0 110 1 0 0 145 0 0 0] 8 #() 976 nil 27 1 false 170 192 34 6 410 ##(UI.SlideyInneyOuteyThing) 34 23 nil 3328 34 2 8 1140850688 131073 3952 nil nil nil 519 nil nil nil 3952 853318 1 ##(UI.CardLayout) 138 144 34 1 2994 787270 1 ##(UI.CardLabel) 8 'Packages' 818 #icon 8 #() ##(Kernel.Package) 21511 410 ##(UI.SlidingCardTray) 34 22 nil 3952 34 2 8 1140850688 131073 4176 nil nil nil 7 nil nil nil 4176 4018 138 144 34 1 2994 4098 8 'Packages' 818 #icon 8 #() ##(Kernel.Package) 21511 410 ##(UI.ReferenceView) 34 14 nil 4176 34 2 8 1140850688 131073 4368 nil nil nil 7 nil nil nil 4368 738 ##(Tools.PackageSelector) #resource_Default_view nil 770 34 1 818 #createAt:extent: 34 2 866 1 37 866 293 239 4368 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 146 0 0 0 137 0 0 0] 960 976 nil 27 4368 nil nil nil 170 192 34 2 4368 8 'packages' nil 410 ##(UI.TabViewXP) 34 28 nil 3952 34 2 8 1140916864 1 4624 787270 2 ##(UI.ListModel) 138 144 34 1 4304 nil 1769478 ##(Kernel.IdentitySearchPolicy) nil nil 1 nil nil nil 4624 nil 8 1821416304 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil #smallIcons nil nil nil nil nil 770 34 3 818 #createAt:extent: 34 2 866 1 1 866 357 291 4624 818 #setSingleSelection: 8 #(1) 4624 818 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4624 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 8 #() 976 nil 27 nil 3952 866 33 33 1246790 1 ##(UI.ButtonInteractor) 4176 nil 1 1180166 ##(Graphics.Rectangle) 866 257 3 866 289 35 nil 1377606 4 ##(UI.CommandDescription) #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 34 1 818 #createAt:extent: 34 2 866 57 9 866 293 275 4176 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 34 1 4368 976 nil 27 nil nil nil nil 170 192 960 nil 4624 4176 866 201 201 401 1 524319 nil nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 357 291 3952 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 34 2 4176 4624 976 nil 27 8 'packagesSlidey' 410 ##(UI.SlideyInneyOuteyThing) 34 23 nil 3328 34 2 8 1140850688 131073 5536 nil nil nil 519 nil nil nil 5536 4018 138 144 34 3 2994 4098 8 'Categories' 2178 0 nil 2210 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[MethodCategory icon]' 8 #[31 105 45 159 106] 2290 #'Core.MethodCategory' ##(Core.MethodCategory) ##(Smalltalk) 1 #icon 5696 7 1 nil 21481 410 ##(UI.TreeView) 34 27 nil 410 ##(UI.SlidingCardTray) 34 22 nil 5536 34 2 8 1140850688 131073 5824 nil nil nil 7 nil nil nil 5824 5600 170 192 34 6 5792 8 'categories' 410 ##(UI.ListView) 34 45 nil 5824 34 2 8 1140936777 1 5936 4690 138 144 960 nil 4768 608 nil 29 461638 4 ##(UI.Menu) nil true 34 7 1180742 2 ##(UI.CommandMenuItem) 1 5154 #browseSelectorsInProtocol 8 '&Selectors' 1 1 nil nil nil 6082 1 5154 #toggleProtocolReadOnly 8 '&Read Only' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 6082 1 5154 #addMethodProtocol 8 '&Add…' 1 1 nil nil nil 6034 nil true 34 2 6082 1 5154 #removeMethodProtocol 8 'Protocol' 1 1 nil nil nil 6082 1 5154 #removeMethodsInProtocol 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 6082 1 5154 #renameMethodProtocol 8 'Rename…' 1 1 nil nil nil 6082 1 5154 #browseMethodProtocol 8 'Browse' 1 1 nil nil nil 8 'Protocols' nil 134217729 nil nil nil nil nil nil nil 5936 nil 8 1821602992 2450 #name 8 #() ##(UI.IconicListAbstract) 4816 nil nil 2178 0 nil 2210 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 6576 7 257 nil 866 65 65 nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 'Protocols' 197 #left 2450 #name 8 #() 2450 #<= 8 #() nil nil 5936 nil 3 nil 2178 0 nil 2210 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 6816 7 257 nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 34 3 818 #createAt:extent: 34 2 866 1 37 866 197 239 5936 818 #contextMenu: 34 1 6048 5936 818 #text: 34 1 8 'Protocols' 5936 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 976 nil 35 8 'protocols' 410 ##(UI.ListView) 34 45 nil 5824 34 2 8 1140920395 1 7152 4690 138 144 960 nil 4768 608 nil 13 6034 nil true 34 10 6082 2097153 5154 #browseInstVarReferences 8 'Browse &References' 1 1 nil nil nil 6194 4097 6082 1 5154 #addInstanceVariable 8 '&Add…' 1 1 nil nil nil 6082 1 5154 #removeInstanceVariables 8 'Remo&ve' 1 1 nil nil nil 6082 1 5154 #renameInstanceVariable 8 'Re&name' 1 1 nil nil nil 6194 4097 6082 1 5154 #pushDownInstanceVariables 8 'Push &Down' 1 1 nil nil nil 6082 1 5154 #createAccessors 8 '&Create Accessors' 1 1 nil nil nil 6082 1 5154 #abstractInstanceVariables 8 'Ab&stract' 1 1 nil nil nil 6082 1 5154 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 7152 nil 8 1821602992 2450 #value 8 #() 2178 0 nil 2210 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] #key #icon #imageIndex 7744 7 257 nil 4816 nil 2178 0 nil 2210 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] #key #name 8 '.' #, 7824 7 257 nil nil 866 65 65 nil nil 138 144 34 1 6706 8 '' 201 #left ##(UI.BasicListAbstract) 2450 #<= 8 #() nil nil 7152 nil 1 nil nil #list 6896 nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 34 2 818 #createAt:extent: 34 2 866 1 37 866 197 239 7152 818 #contextMenu: 34 1 7248 7152 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 976 nil 35 8 'variables' nil 410 ##(UI.TabViewXP) 34 28 nil 5536 34 2 8 1140916864 1 8224 4690 138 144 34 3 5664 4098 8 'Protocols' 2178 0 nil 2210 6 1 16 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 2290 #CardLabel 4096 ##(Smalltalk) 1 8352 2290 #MethodProtocol ##(Kernel.MethodProtocol) ##(Smalltalk) 1 #icon #text:iconBlock: 8368 11 1 nil 21487 4098 8 'Variables' nil 21491 nil 4768 nil nil 1 nil nil nil 8224 nil 8 1821416304 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 4816 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 34 3 818 #createAt:extent: 34 2 866 1 1 866 357 291 8224 818 #setSingleSelection: 8 #(1) 8224 818 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8224 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 8 #() 976 nil 27 nil 5536 866 33 33 5058 5824 nil 1 5090 866 161 3 866 193 35 nil 5154 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 34 1 818 #createAt:extent: 34 2 866 153 9 866 197 275 5824 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 34 3 5792 5936 7152 976 nil 27 34 2 8 1140916771 1 5792 787526 3 ##(UI.TreeModel) nil 4768 721670 ##(UI.TreeNode) nil nil nil 170 192 960 608 nil 31 6034 nil true 34 4 6082 1 5154 #addMethodCategory 8 '&Add…' 1 1 nil nil nil 6034 nil true 34 2 6082 1 5154 #removeMethodCategory 8 'Category' 1 1 nil nil nil 6082 1 5154 #removeMethodsInCategory 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 6082 1 5154 #renameMethodCategory 8 'Rename…' 1 1 nil nil nil 6082 1 5154 #browseMethodCategory 8 'Browse' 1 1 nil nil nil 8 'Categories' nil 134217729 nil nil nil nil nil nil nil 5792 nil 8 1821380560 2450 #localName 8 #() ##(UI.IconicListAbstract) 4816 nil nil 2178 0 nil 2210 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawCategoryTree: 9488 7 257 nil nil nil 170 176 960 nil #noIcons 1 170 192 960 770 34 2 818 #createAt:extent: 34 2 866 1 37 866 197 239 5792 818 #contextMenu: 34 1 9104 5792 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 976 nil 27 2994 8336 5936 2994 8480 7152 5792 nil nil nil 170 192 34 2 5824 8 'filters' nil 8224 5824 866 201 201 401 1 524319 nil nil 770 34 1 818 #createAt:extent: 34 2 866 733 1 866 357 291 5536 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 1 0 0 0 0 0 0 32 2 0 0 145 0 0 0] 34 2 5824 8224 976 nil 27 8 'filtersSlidey' 410 ##(UI.ReferenceView) 34 14 nil 3328 34 2 8 1140916224 131073 10032 nil nil nil 7 6034 nil true 34 17 6082 1 5154 #findClass 8 'Find…' 1 1 852806 4 ##(Graphics.Icon) nil true 2819078 ##(Graphics.ImageFromStringResourceInitializer) 8 'FindClass.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr8.dll' nil 65541 nil nil nil 6034 nil true 34 10 6082 1 5154 #browseClassPackage 8 'Package <1d>' 1 1 10178 nil true 10210 8 'Package.ico' 10272 65541 nil nil nil 6194 4097 6082 2097153 5154 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 6034 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 6194 4097 6082 1 5154 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 6082 1 5154 #browseMethodHistoryForClass 8 'Method &History' 1 1 10178 nil true 10210 8 'MethodHistory.ico' 10272 65541 nil nil nil 6194 4097 6082 1 5154 #browsePublishedEvents 8 'Published &events' 1 1 10178 nil true 10210 8 'Event.ico' 10272 65541 nil nil nil 6082 1 5154 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 6194 4097 6082 1 5154 #newClass 8 '&New…' 1 1 10178 nil true 10210 8 'NewClass.ico' 10272 65541 nil nil nil 6082 1 5154 #removeClass 8 'Re&move' 1 1 10178 nil true 10210 8 'EditClear.ico' 10272 65541 nil nil nil 6034 nil true 34 17 6082 2097153 5154 #renameClass 8 'Re&name…' 1 1 10178 nil true 10210 8 'Rename.ico' 10272 65541 nil nil nil 6194 4097 6082 1 5154 #addInstanceVariable 8 'Add <1s>&Instance Variable…' 1 1 nil nil nil 6082 1 5154 #addClassVariable 8 'Add &Class Variable…' 1 1 nil nil nil 6034 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 6034 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 6194 4097 6034 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 6034 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 6194 4097 6034 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 6034 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 6034 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 6194 4097 6082 1 5154 #convertToSibling 8 'Con&vert to Sibling…' 1 1 nil nil nil 6194 4097 6082 1 5154 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 10178 nil true 10210 8 'Refactoring.ico' 10272 65541 nil nil nil nil nil 6194 4097 6082 1 5154 #createInstanceVariableAccessors 8 'Create &Accessors…' 1 1 nil nil nil 6082 1 5154 #reformatAll 8 'Re&format All' 1 1 nil nil nil 6194 4097 6082 1 5154 #fileInClass 8 'File &In…' 1 1 10178 nil true 10210 8 'FileIn.ico' 10272 65541 nil nil nil 6082 1 5154 #fileOutClass 8 'File &Out…' 1 1 nil nil nil 6194 4097 6082 1 5154 #classPackage 8 '&Package…' 1 1 10178 nil true 10210 8 'Package.ico' 10272 65541 nil nil nil 6082 1 5154 #categorizeClass 8 '&Category…' 1 1 10178 nil true 10210 8 'Category.ico' 10272 65541 nil nil nil 6194 4097 6034 nil true 34 4 6082 1 5154 #newView 8 '&New…' 1 1 nil nil nil 6194 4097 6034 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 10178 nil true 10210 8 'ViewComposer.ico' 10272 65541 nil nil nil nil nil 6034 nil true 8 #() 8 '&Show' #viewsShowMenu 1 10178 nil true 10210 8 'TestView.ico' 10272 65541 nil nil nil nil nil 8 '&Views' #viewsMenu 134217729 10178 nil true 10210 8 'View.ico' 10272 65541 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 10032 738 ##(Tools.ClassListSelector) #resource_Default_view nil 770 34 2 818 #createAt:extent: 34 2 866 367 1 866 357 291 10032 818 #contextMenu: 34 1 10096 10032 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 183 0 0 0 0 0 0 0 105 1 0 0 145 0 0 0] 960 976 nil 27 8 'classes' nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 1459 291 3328 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 34 7 3952 410 ##(UI.Splitter) 34 12 nil 3328 34 2 8 1140850688 1 13088 nil nil nil 519 nil nil nil 3090 13088 nil 1 #left nil nil nil 3120 3136 nil 3120 nil 770 34 1 818 #createAt:extent: 34 2 866 357 1 866 11 291 13088 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 0 0 0 0 183 0 0 0 145 0 0 0] 8 #() 976 nil 27 10032 3696 5536 3456 410 ##(UI.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 13312 nil nil nil 7 nil nil nil 13312 498 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 13312 34 2 8 1140850688 131073 13392 nil nil nil 535 nil nil nil 13392 1730 11 1 1 170 192 34 4 410 ##(UI.RadioButton) 34 16 nil 13392 34 2 8 1141055497 1 13504 918598 2 ##(UI.ValueHolder) nil nil 1704454 ##(Core.PluggableSearchPolicy) 2450 #= 8 #() 2450 #hash 8 #() false nil nil 7 nil nil nil 13504 nil 8 1821651072 1049094 ##(UI.NullConverter) nil nil nil 770 34 2 818 #createAt:extent: 34 2 866 161 1 866 111 51 13504 818 #text: 34 1 8 'C&lass' 13504 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 0 0 0 0 135 0 0 0 25 0 0 0] 8 #() 976 nil 27 8 'classMode' 410 ##(UI.RadioButton) 34 16 nil 13392 34 2 8 1141055497 1 13952 13570 nil nil 13602 2450 #= 8 #() 2450 #hash 8 #() false nil nil 7 nil nil nil 13952 nil 8 1821651072 13714 nil nil nil 770 34 2 818 #createAt:extent: 34 2 866 21 1 866 131 51 13952 818 #text: 34 1 8 'In&stance' 13952 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 75 0 0 0 25 0 0 0] 8 #() 976 nil 27 8 'instanceMode' 5090 866 21 1 866 1 1 770 34 1 818 #createAt:extent: 34 2 866 1 241 866 361 51 13392 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 120 0 0 0 180 0 0 0 145 0 0 0] 34 2 13952 13504 976 nil 27 nil nil 410 ##(UI.ReferenceView) 34 14 nil 13312 34 2 8 1140916224 131073 14544 nil nil nil 31 nil nil nil 14544 738 ##(Tools.MethodBrowser) #resource_Class_browser_method_list nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 361 241 14544 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 180 0 0 0 120 0 0 0] 960 976 nil 27 170 192 34 4 13392 8 'mode' 14544 8 'methods' nil 770 34 1 818 #createAt:extent: 34 2 866 1099 1 866 361 291 13312 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 37 2 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 34 2 14544 13392 976 nil 27 976 nil 27 8 'classes' 410 ##(UI.CardContainer) 34 16 nil 2864 34 2 8 1140850688 131073 14976 nil nil nil 23 6034 nil true 34 2 6034 nil true 34 4 6082 1025 5154 2450 #tabOrientation: 8 #(#top) 8 '&Top' 1 1 nil nil nil 6082 1025 5154 2450 #tabOrientation: 8 #(#bottom) 8 '&Bottom' 1 1 nil nil nil 6082 1025 5154 2450 #tabOrientation: 8 #(#left) 8 '&Left' 1 1 nil nil nil 6082 1025 5154 2450 #tabOrientation: 8 #(#right) 8 '&Right' 1 1 nil nil nil 8 '&Orientation' nil 134217729 nil nil nil nil nil 6034 nil true 34 6 6082 1025 5154 2450 #viewMode: 8 #(#noIcons) 8 '&No Icons' 1 1 nil nil nil 6082 1025 5154 2450 #viewMode: 8 #(#smallIcons) 8 '&Small Icons' 1 1 nil nil nil 6082 1025 5154 2450 #viewMode: 8 #(#mediumIcons) 8 '&Medium Icons' 1 1 nil nil nil 6082 1025 5154 2450 #viewMode: 8 #(#largeIcons) 8 '&Large Icons' 1 1 nil nil nil 6082 1025 5154 2450 #viewMode: 8 #(#tileIcons) 8 '&Tile Icons' 1 1 nil nil nil 6082 1 5154 2450 #viewMode: 8 #(#thumbnails) 8 'Thum&bnails' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 14976 4018 138 144 34 2 2994 4098 8 'Method source' 2178 0 nil 2210 7 1 4096 8 'doIt' 8 '(CardLabel text: ''Method source'' iconBlock: [Icon fromId: ''MethodSource.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 2290 #CardLabel 4096 ##(Smalltalk) 1 16064 2290 #Icon 10176 ##(Smalltalk) 1 8 'MethodSource.ico' #fromId: #text:iconBlock: 16080 11 1 nil nil 410 ##(UI.ReferenceView) 34 14 nil 14976 34 2 8 1140850688 131073 16208 nil nil nil 7 nil nil nil 16208 738 ##(Tools.MethodWorkspace) #resource_Default_view nil 770 34 1 818 #createAt:extent: 34 2 866 9 53 866 1443 233 16208 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 213 2 0 0 142 0 0 0] 960 976 nil 27 2994 4098 8 'Class definition' 2178 0 nil 2210 7 1 4096 8 'doIt' 8 '(CardLabel text: ''Class definition'' iconBlock: [Icon fromId: ''ClassDefinition.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 16160 16448 16176 8 'ClassDefinition.ico' #fromId: #text:iconBlock: 16464 11 1 nil nil 410 ##(UI.ReferenceView) 34 14 nil 14976 34 2 8 1140916224 131073 16560 nil 608 nil 21 nil nil nil 16560 738 ##(Tools.SmalltalkWorkspace) #resource_Default_view nil 770 34 1 818 #createAt:extent: 34 2 866 9 53 866 1443 233 16560 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 213 2 0 0 142 0 0 0] 960 976 nil 27 16208 nil nil nil 170 192 34 4 16208 8 'source' 16560 8 'definition' nil 410 ##(UI.TabViewXP) 34 28 nil 14976 34 2 8 1140916736 1 16832 4690 138 144 34 2 16048 16432 nil 4768 nil nil 17 nil nil nil 16832 nil 8 1821416304 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 4816 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 34 3 818 #createAt:extent: 34 2 866 1 1 866 1459 293 16832 818 #setSingleSelection: 8 #(1) 16832 818 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 16832 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 146 0 0 0] 8 #() 976 nil 27 770 34 2 818 #createAt:extent: 34 2 866 1 301 866 1459 293 14976 818 #contextMenu: 34 1 15040 14976 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 150 0 0 0 217 2 0 0 40 1 0 0] 34 3 16208 16560 16832 976 nil 27 8 'cards' nil 770 34 1 818 #createAt:extent: 34 2 866 1 51 866 1459 593 2864 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 217 2 0 0 65 1 0 0] 34 3 3328 3024 14976 976 nil 27 170 192 34 4 528 8 'toolbar' 1904 8 'statusbar' nil 658246 4 ##(UI.MenuBar) nil true 34 9 6034 nil true 34 8 6082 1 5154 #fileNew 8 '&New' 9373 1 10178 nil true 10210 8 'NewWorkspace.ico' 10272 65541 nil nil nil 6082 1 5154 #fileOpen 8 '&Open…' 9375 1 10178 nil true 10210 8 'OpenWorkspace.ico' 10272 65541 nil nil nil 6082 1 5154 #fileFileIn 8 '&File In…' 1 1 10178 nil true 10210 8 'FileIn.ico' 10272 65541 nil nil nil 6194 4097 6082 1 5154 #saveImage 8 'Sa&ve Image' 1 1 10178 nil true 10210 8 'Snapshot.ico' 10272 65541 nil nil nil 6082 1 5154 #smalltalkExit 8 'E&xit Dolphin' 1 1 10178 nil true 10210 8 'PowerSwitch.ico' 10272 65541 nil nil nil 6194 4097 6082 1 5154 #exit 8 '&Close' 17639 1 1378630 2 ##(Graphics.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 9471 nil nil 6034 nil true 34 13 6082 1 5154 #undo 8 '&Undo' 9397 1 10178 nil true 10210 8 'EditUndo.ico' 10272 65541 nil nil nil 6194 4097 6082 1 5154 #cutSelection 8 'Cu&t' 9393 1 10178 nil true 10210 8 'EditCut.ico' 10272 65541 nil nil nil 6082 1 5154 #copySelection 8 '&Copy' 9351 1 10178 nil true 10210 8 'EditCopy.ico' 10272 65541 nil nil nil 6082 1 5154 #pasteClipboard 8 '&Paste' 9389 1 10178 nil true 10210 8 'EditPaste.ico' 10272 65541 nil nil nil 6082 1 5154 #editDelete 8 '&Delete' 1 1 10178 nil true 10210 8 'EditClear.ico' 10272 65541 nil nil nil 6034 nil true 34 2 6082 1 5154 #reformatSource 8 '&Source' 9391 1 nil nil nil 6082 1 5154 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 9487 nil nil 6194 4097 6082 1 5154 #selectAll 8 'Select &All' 9347 1 nil nil nil 6194 4097 6082 1 5154 #editFind 8 '&Find…' 9357 1 10178 nil true 10210 8 'Find.ico' 10272 65541 nil nil nil 6082 1 5154 #findNext 8 'Find &Next' 1253 1 10178 nil true 10210 8 'FindNext.ico' 10272 65541 nil nil nil 6082 1 5154 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 9497 nil nil 6034 nil true 34 17 6082 1 5154 #browseIt 8 '&Browse It' 9349 1 10178 nil true 10210 8 'ClassBrowserShell.ico' 10272 65541 nil nil nil 6082 1 5154 #displayIt 8 '&Display It' 9353 1 10178 nil true 10210 8 'DisplayIt.ico' 10272 65541 nil nil nil 6082 1 5154 #printIt 8 '&Print It' 9377 1 10178 nil true 10210 8 'PrintIt.ico' 10272 65541 nil nil nil 6082 1 5154 #evaluateIt 8 '&Evaluate It' 9355 1 10178 nil true 10210 8 'EvaluateIt.ico' 10272 65541 nil nil nil 6082 1 5154 #inspectIt 8 '&Inspect It' 9363 1 10178 nil true 10210 8 'InspectIt.ico' 10272 65541 nil nil nil 6082 1 5154 #debugIt 8 'Deb&ug It' 1269 1 10178 nil true 10210 8 'Debugger.ico' 10272 65541 nil nil nil 6082 1 5154 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 6194 4097 6082 1 5154 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 6082 1 5154 #browseReferences 8 '&References' 5367 1 nil nil nil 6194 4097 6082 2097153 5154 #accept 8 '&Accept' 9383 1 nil nil nil 6082 1 5154 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 6194 4097 6034 nil true 34 14 6082 1 5154 #renameVariable 8 'Re&name <1d>…' 1 1 nil nil nil 6194 4097 6082 1 5154 #extractToTemporary 8 'Extract to &Temporary…' 9385 1 nil nil nil 6082 1 5154 #extractMethod 8 'E&xtract Method…' 9371 1 nil nil nil 6082 1 5154 #extractToComponent 8 'Extract to &Component…' 1 1 nil nil nil 6082 1 5154 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 6194 4097 6082 1 5154 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 6082 1 5154 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 6082 1 5154 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 6194 4097 6082 1 5154 #addParameterToMessage 8 '&Add Parameter to <1d>…' 1 1 nil nil nil 6082 1 5154 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 6082 1 5154 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 10178 nil true 10210 8 'Refactoring.ico' 10272 65541 nil nil 9543 nil nil 6194 4097 6034 nil true 34 7 6082 1 5154 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 6082 1 5154 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 6082 1 5154 #toggleLineEndings 8 'Line &Endings' 1 1 18210 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 6082 1 5154 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 6082 1 5154 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 6082 1 5154 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 6082 1 5154 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 10178 nil true 10210 8 'Preferences.ico' 10272 65541 nil nil 9559 nil nil 8 '&Workspace' nil 134217729 nil nil 9561 nil nil 6034 nil true 34 17 6082 2097153 5154 #findClass 8 'Find…' 1 1 10178 nil true 10210 8 'FindClass.ico' 10272 65541 nil nil nil 6034 nil true 34 10 6082 1 5154 #browseClassPackage 8 'Package <1d>' 1 1 10178 nil true 10210 8 'Package.ico' 10272 65541 nil nil nil 6194 4097 6082 2097153 5154 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 6034 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil 9569 nil nil 6194 4097 6082 1 5154 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 6082 1 5154 #browseMethodHistoryForClass 8 'Method &History' 1 1 10178 nil true 10210 8 'MethodHistory.ico' 10272 65541 nil nil nil 6194 4097 6082 1 5154 #browsePublishedEvents 8 'Published &events' 1 1 10178 nil true 10210 8 'Event.ico' 10272 65541 nil nil nil 6082 1 5154 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil 9579 nil nil 6194 4097 6082 1 5154 #newClass 8 '&New…' 1 1 10178 nil true 10210 8 'NewClass.ico' 10272 65541 nil nil nil 6082 1 5154 #removeClass 8 'Re&move' 1 1 10178 nil true 10210 8 'EditClear.ico' 10272 65541 nil nil nil 6034 nil true 34 18 6082 2097153 5154 #renameClass 8 'Re&name…' 1 1 10178 nil true 10210 8 'Rename.ico' 10272 65541 nil nil nil 6082 1 5154 #copyClass 8 'Cl&one…' 1 1 nil nil nil 6194 4097 6082 1 5154 #addInstanceVariable 8 'Add <1s>&Instance Variable…' 1 1 nil nil nil 6082 1 5154 #addClassVariable 8 'Add &Class Variable…' 1 1 nil nil nil 6034 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil 9593 nil nil 6034 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil 9595 nil nil 6194 4097 6034 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil 9597 nil nil 6034 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil 9599 nil nil 6194 4097 6034 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil 9601 nil nil 6034 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil 9603 nil nil 6034 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil 9605 nil nil 6194 4097 6082 1 5154 #convertToSibling 8 'Con&vert to Sibling…' 1 1 nil nil nil 6194 4097 6082 1 5154 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 10178 nil true 10210 8 'Refactoring.ico' 10272 65541 nil nil 9611 nil nil 6194 4097 6082 1 5154 #createInstanceVariableAccessors 8 'Create &Accessors…' 1 1 nil nil nil 6082 1 5154 #reformatAll 8 'Re&format All' 1 1 nil nil nil 6194 4097 6082 1 5154 #fileInClass 8 'File &In…' 1 1 10178 nil true 10210 8 'FileIn.ico' 10272 65541 nil nil nil 6082 1 5154 #fileOutClass 8 'File &Out…' 1 1 nil nil nil 6194 4097 6082 1 5154 #classPackage 8 '&Package…' 1 1 10178 nil true 10210 8 'Package.ico' 10272 65541 nil nil nil 6082 1 5154 #categorizeClass 8 '&Category…' 1 1 10178 nil true 10210 8 'Category.ico' 10272 65541 nil nil nil 6194 4097 6034 nil true 34 4 6082 1 5154 #newView 8 '&New…' 1 1 nil nil nil 6194 4097 6034 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 10178 nil true 10210 8 'ViewComposer.ico' 10272 65541 nil nil 9627 nil nil 6034 nil true 8 #() 8 '&Show' #viewsShowMenu 1 10178 nil true 10210 8 'TestView.ico' 10272 65541 nil nil 9629 nil nil 8 '&Views' #viewsMenu 134217729 10178 nil true 10210 8 'View.ico' 10272 65541 nil nil 9631 nil nil 8 '&Class' nil 134217729 nil nil 9633 nil nil 6034 nil true 34 15 6034 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 9635 nil nil 6034 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 9637 nil nil 6034 nil true 34 14 6082 1 5154 #browseReferencesToGlobal 8 'References to Global…' 1 1 nil nil nil 6082 1 5154 #browseContainingText 8 'C&ontaining Text…' 1 1 10178 nil true 10210 8 'SearchText.ico' 10272 65541 nil nil nil 6082 1 5154 #browseMethodCategory 8 'Cate&gory…' 1 1 10178 nil true 10210 8 'Category.ico' 10272 65541 nil nil nil 6082 1 5154 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 6082 1 5154 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 6194 4097 6082 1 5154 #browseMethodPackages 8 '&Package <s>' 1 1 10178 nil true 10210 8 'Package.ico' 10272 65541 nil nil nil 6082 1 5154 #browseMethodClasses 8 '&Class <s>' 1 1 nil nil nil 6194 4097 6082 1 5154 #browseMethodHistory 8 'Change &History' 1 1 10178 nil true 10210 8 'MethodHistory.ico' 10272 65541 nil nil nil 6082 1 5154 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 6194 4097 6082 1 5154 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 6082 1 5154 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 9661 nil nil 6194 4097 6082 1 5154 #newMethod 8 '&New' 1 1 10178 nil true 10210 8 'NewMethod.ico' 10272 65541 nil nil nil 6082 1 5154 #removeMethod 8 '&Delete' 1 1 10178 nil true 10210 8 'EditClear.ico' 10272 65541 nil nil nil 6034 nil true 34 16 6082 1 5154 #renameMethod 8 'Re&name' 1 1 10178 nil true 10210 8 'Rename.ico' 10272 65541 nil nil nil 6082 1 5154 #renameMethodReferences 8 'Rename Re&ferences…' 1 1 nil nil nil 6194 4097 6082 1 5154 #addParameter 8 'Add &Parameter…' 1 1 nil nil nil 6034 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 9673 nil nil 6034 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 9675 nil nil 6034 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 9677 nil nil 6194 4097 6034 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 9679 nil nil 6034 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 9681 nil nil 6194 4097 6082 1 5154 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 6082 1 5154 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 6082 1 5154 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 6082 1 5154 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 6082 1 5154 #moveMethod 8 'Move to &Component…' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 10178 nil true 10210 8 'Refactoring.ico' 10272 65541 nil nil 9693 nil nil 6194 4097 6082 1 5154 #methodPackage 8 '&Package…' 1 1 10178 nil true 10210 8 'Package.ico' 10272 65541 nil nil nil 6034 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 9697 nil nil 6034 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 9699 nil nil 6082 1 5154 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 6194 4097 6082 1 5154 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 6082 1 5154 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 9707 nil nil 6034 nil true 34 7 6082 1 5154 #undoChange 8 '&Undo <1d>' 1 1 10178 nil true 10210 8 'EditUndo.ico' 10272 65541 nil nil nil 6082 1 5154 #redoChange 8 '&Redo <1d>' 1 1 10178 nil true 10210 8 'EditRedo.ico' 10272 65541 nil nil nil 6082 1 5154 #clearChangeHistory 8 'Clear Change &History' 1 1 10178 nil true 10210 8 'MethodHistoryErase.ico' 10272 65541 nil nil nil 6194 4097 6082 1 5154 #historyBack 8 'Back to <1d>' 1 1 10178 nil true 10210 8 'HistoryBack.ico' 10272 65541 nil nil nil 6082 1 5154 #historyForward 8 'Forward to <1d>' 1 1 10178 nil true 10210 8 'HistoryForward.ico' 10272 65541 nil nil nil 6082 1 5154 #historyClear 8 'Clear Visit History' 1 1 10178 nil true 10210 8 'HistoryErase.ico' 10272 65541 nil nil nil 8 'H&istory' nil 134217729 nil nil 9721 nil nil 6034 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 9723 nil nil 6034 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 9725 nil nil 6034 nil true 34 15 6082 1 5154 #helpContents 8 '&Contents' 1025 1 10178 nil true 10210 8 'Help.ico' 10272 65541 nil nil nil 6082 1 5154 #help 8 'On this &Tool' 1249 1 nil nil nil 6082 1 5154 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 6194 4097 6082 1 5154 #learnSmalltalk 8 'Learn Smalltalk' 1 1 18210 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 6194 4097 6082 1 5154 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 6082 1 5154 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 6082 1 5154 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 6194 4097 6082 1 5154 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 10178 nil true 10210 8 '!!APPLICATION' 10272 65541 nil nil nil 6082 1 5154 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 6082 1 5154 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 6194 4097 6082 1 5154 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 18210 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 9749 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 34 2 818 #createAt:extent: 34 2 866 12287 21 866 1491 801 416 818 #text: 34 1 8 'System Browser' 416 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 232 26 0 0 154 1 0 0] 34 3 528 2864 1904 976 nil 27 )!

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

