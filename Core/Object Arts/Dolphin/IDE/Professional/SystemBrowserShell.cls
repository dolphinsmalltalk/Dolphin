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
		ifTrue: 
			[| pkgs |
			pkgs := self packages.
			Package manager packages asSet = pkgs asSet
				ifTrue: [classEnvironment]
				ifFalse: [classEnvironment forPackages: pkgs]]
		ifFalse: [classEnvironment]!

slideyPinNames
	^super slideyPinNames , #('packagesSlidey')! !
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786950 ##(Smalltalk.DefaultColor) #toolBackground nil 567 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 28 198 63 1 0 0 204 53 63 1 3 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point) 193 193 nil 528 524550 ##(Smalltalk.ColorRef) 8 4278190080 8 1912794480 170 192 34 8 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 800 nil nil nil 7 nil nil nil 800 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 63 1 674 599 51 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 74 1 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1136 nil nil nil 7 nil nil nil 1136 866 ##(Smalltalk.Toolbar) #resource_Class_browser_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1093 1 674 307 51 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 34 2 0 0 0 0 0 0 187 2 0 0 25 0 0 0] 1088 1104 nil 27 8 'classBrowserTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1376 nil nil nil 7 nil nil nil 1376 866 ##(Smalltalk.Toolbar) #resource_Image_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 1 674 63 51 1376 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1088 1104 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1616 nil nil nil 7 nil nil nil 1616 866 ##(Smalltalk.Toolbar) #resource_Search_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 661 1 674 433 51 1616 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 1 0 0 0 0 0 0 34 2 0 0 25 0 0 0] 1088 1104 nil 27 8 'searchTools' 170 192 1088 138 144 1088 170 176 1088 nil 1 nil 674 33 33 674 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 898 138 144 34 2 962 #createAt:extent: 34 2 674 1 1 674 1459 51 528 962 #updateSizePosted 1088 528 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 25 0 0 0] 34 4 1376 800 1616 1136 1104 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140852996 1 2144 nil nil nil 7 nil 594 nil true 626 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 674 193 193 nil 2144 nil 8 1912526784 170 192 34 8 853766 ##(Smalltalk.StatusBarItem) 1 401 2144 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1050182 1 ##(Smalltalk.IconImageManager) 8 'packageOfSelection' 2322 1 45 2144 nil nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association) #Smalltalk ##(Smalltalk) #developmentSystem #changedIcon #imageIndex 2432 7 257 nil nil 8 'modified' 2322 1 -1 2144 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 2418 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 2320 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] #iconImageIndex 2640 7 257 nil nil 8 'version' 2322 1 841 2144 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2368 8 'message' 34 4 2336 2400 2720 2576 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2144 nil nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 643 674 1459 41 2144 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 217 2 0 0 85 1 0 0] 8 #() 1104 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2960 nil nil nil 7 nil nil nil 2960 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 1 2530 410 ##(Smalltalk.Splitter) 34 12 nil 2960 34 2 8 1140850688 1 3104 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3104 nil 1 #left nil nil nil 674 1 1 674 9 9 nil 3200 nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 291 674 1459 11 3104 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 0 0 0 217 2 0 0 150 0 0 0] 8 #() 1104 nil 27 1 true 170 192 34 4 410 ##(Smalltalk.CardContainer) 34 16 nil 2960 34 2 8 1140850688 131073 3424 nil nil nil 23 265030 4 ##(Smalltalk.Menu) nil true 34 2 3490 nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1025 1180998 4 ##(Smalltalk.CommandDescription) 2594 #tabOrientation: 8 #(#top) 8 '&Top' 1 1 nil nil nil 3570 1025 3602 2594 #tabOrientation: 8 #(#bottom) 8 '&Bottom' 1 1 nil nil nil 3570 1025 3602 2594 #tabOrientation: 8 #(#left) 8 '&Left' 1 1 nil nil nil 3570 1025 3602 2594 #tabOrientation: 8 #(#right) 8 '&Right' 1 1 nil nil nil 8 '&Orientation' nil 134217729 nil nil nil nil nil 3490 nil true 34 5 3570 1025 3602 2594 #viewMode: 8 #(#noIcons) 8 '&No Icons' 1 1 nil nil nil 3570 1025 3602 2594 #viewMode: 8 #(#smallIcons) 8 '&Small Icons' 1 1 nil nil nil 3570 1025 3602 2594 #viewMode: 8 #(#mediumIcons) 8 'Medium Icons' 1 1 nil nil nil 3570 1025 3602 2594 #viewMode: 8 #(#largeIcons) 8 '&Large Icons' 1 1 nil nil nil 3570 1 3602 2594 #viewMode: 8 #(#tileIcons) 8 'Tile Icons' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3424 655878 ##(Smalltalk.CardLayout) 138 144 34 2 2530 590662 1 ##(Smalltalk.CardLabel) 8 'Method source' 962 #icon 8 #() 2656 20981 410 ##(Smalltalk.ReferenceView) 34 14 nil 3424 34 2 8 1140850688 131073 4560 nil nil nil 7 nil nil nil 4560 866 ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 9 53 674 1443 233 4560 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 213 2 0 0 142 0 0 0] 1088 1104 nil 27 2530 4482 8 'Class definition' 962 #icon 8 #() ##(Smalltalk.Class) 21493 410 ##(Smalltalk.ReferenceView) 34 14 nil 3424 34 2 8 1140916224 131073 4864 nil 706 8 4278190080 nil 21 nil nil nil 4864 866 ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 9 53 674 1443 233 4864 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 213 2 0 0 142 0 0 0] 1088 1104 nil 27 4560 170 192 34 4 4864 8 'definition' 4560 8 'source' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 3424 34 2 8 1140916736 1 5184 590662 2 ##(Smalltalk.ListModel) 138 144 34 2 4496 4800 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 17 nil nil nil 5184 nil 8 1912616880 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2368 nil nil nil nil nil #smallIcons nil nil nil nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 674 1 1 674 1459 293 5184 962 #basicSelectionsByIndex: 34 1 8 #(1) 5184 962 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 5184 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 146 0 0 0] 8 #() 1104 nil 27 898 138 144 34 2 962 #createAt:extent: 34 2 674 1 301 674 1459 293 3424 962 #contextMenu: 34 1 3504 3424 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 150 0 0 0 217 2 0 0 40 1 0 0] 34 3 4560 4864 5184 1104 nil 27 8 'cards' 410 ##(Smalltalk.ContainerView) 34 15 nil 2960 34 2 8 1140850688 131073 5808 nil nil nil 7 nil nil nil 5808 3026 138 ##(Smalltalk.Dictionary) 34 2 2530 410 ##(Smalltalk.Splitter) 34 12 nil 5808 34 2 8 1140850688 1 5936 nil nil nil 519 nil nil nil 3170 5936 nil 1 #left nil nil nil 674 1 1 3216 nil 6016 nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1089 1 674 11 291 5936 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 2 0 0 0 0 0 0 37 2 0 0 145 0 0 0] 8 #() 1104 nil 27 1 2530 410 ##(Smalltalk.Splitter) 34 12 nil 5808 34 2 8 1140850688 1 6208 nil nil nil 519 nil nil nil 3170 6208 nil 1 #left nil nil nil 674 1 1 3216 nil 6288 nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 723 1 674 11 291 6208 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 1 0 0 0 0 0 0 110 1 0 0 145 0 0 0] 8 #() 1104 nil 27 1 false 170 192 34 6 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 5808 34 2 8 1140850688 131073 6496 nil nil nil 519 nil nil nil 6496 4402 138 144 34 1 2530 4482 8 'Packages' 962 #icon 8 #() ##(Smalltalk.Package) 21511 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 6496 34 2 8 1140850688 131073 6688 nil nil nil 7 nil nil nil 6688 4402 138 144 34 1 2530 4482 8 'Packages' 962 #icon 8 #() ##(Smalltalk.Package) 21511 410 ##(Smalltalk.ReferenceView) 34 14 nil 6688 34 2 8 1140850688 131073 6880 nil nil nil 7 nil nil nil 6880 866 ##(Smalltalk.PackageSelector) #resource_Default_view nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 37 674 293 239 6880 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 146 0 0 0 137 0 0 0] 1088 1104 nil 27 6880 170 192 34 2 6880 8 'packages' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 6496 34 2 8 1140916864 1 7152 5250 138 144 34 1 6816 nil 5328 nil nil 1 nil nil nil 7152 nil 8 1912616880 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2368 nil nil nil nil nil #smallIcons nil nil nil nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 674 1 1 674 357 291 7152 962 #basicSelectionsByIndex: 34 1 8 #(1) 7152 962 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 7152 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 8 #() 1104 nil 27 nil 6496 674 33 33 1050182 1 ##(Smalltalk.ButtonInteractor) 6688 nil 1 590342 ##(Smalltalk.Rectangle) 674 257 3 674 289 35 nil 3602 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 57 9 674 293 275 6688 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 34 1 6880 1104 nil 27 nil 170 192 1088 nil 7152 6688 674 201 201 401 1 524319 nil nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 1 674 357 291 6496 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 34 2 6688 7152 1104 nil 27 8 'packagesSlidey' 410 ##(Smalltalk.ReferenceView) 34 14 nil 5808 34 2 8 1140916224 131073 8032 nil nil nil 7 3490 nil true 34 20 3570 1 3602 #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 3490 nil true 34 10 3570 1 3602 #browseClassPackage 8 'Package <1d>' 1 1 8178 nil true 8224 8 'Package.ico' 8272 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3570 2097153 3602 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 3490 nil true 8 #() 8 'Local Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 8418 4097 3570 1 3602 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 3570 1 3602 #browseMethodHistoryForClass 8 'Method &History' 1 1 nil nil nil 8418 4097 3570 1 3602 #browsePublishedEvents 8 'Published &events' 1 1 nil nil nil 3570 1 3602 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 8418 4097 3570 1 3602 #newClass 8 '&New...' 1 1 8178 nil true 8224 8 'NewClass.ico' 8272 nil nil 3570 1 3602 #deleteClassHierarchy 8 '&Delete' 1 1 8178 nil true 8224 8 'EditClear.ico' 8272 nil nil 3490 nil true 34 18 3570 1 3602 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 3570 2097153 3602 #renameClass 8 'Re&name...' 1 1 nil nil nil 8418 4097 3570 1 3602 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 3570 1 3602 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 3490 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 3490 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 8418 4097 3490 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 3490 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 8418 4097 3490 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 3490 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 3490 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 8418 4097 3570 1 3602 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 8418 4097 3570 1 3602 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 8178 nil true 8224 8 'Refactoring.ico' 8272 nil nil nil nil 8418 4097 3570 1 3602 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 3570 1 3602 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 8418 4097 3570 1 3602 #fileInClass 8 'File &In...' 1 1 nil nil nil 3570 1 3602 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 8418 4097 3570 1 3602 #classPackage 8 '&Package...' 1 1 8178 nil true 8224 8 'Package.ico' 8272 nil nil 3570 1 3602 #categorizeClass 8 '&Category...' 1 1 nil nil nil 8418 4097 3570 1 3602 #browseClassEditions 8 'Browse &Editions' 1 1 nil nil nil 3570 1 3602 #compareClass 8 'Compare with...' 1 1 nil nil nil 8418 4097 3490 nil true 34 4 3570 1 3602 #newView 8 '&New...' 1 1 nil nil nil 8418 4097 3490 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 nil nil nil nil nil 3490 nil true 8 #() 8 '&Show' #viewsShowMenu 1 nil nil nil nil nil 8 '&Views' #viewsMenu 1 8178 nil true 8224 8 'View.ico' 8272 nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 8032 866 ##(Smalltalk.ClassListSelector) #resource_Default_view nil 898 138 144 34 2 962 #createAt:extent: 34 2 674 367 1 674 357 291 8032 962 #contextMenu: 34 1 8096 8032 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 183 0 0 0 0 0 0 0 105 1 0 0 145 0 0 0] 1088 1104 nil 27 8 'classes' 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 5808 34 2 8 1140850688 131073 10704 nil nil nil 519 nil nil nil 10704 4402 138 144 34 3 2530 4482 8 'Categories' nil 21481 410 ##(Smalltalk.TreeView) 34 27 nil 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 10704 34 2 8 1140850688 131073 10896 nil nil nil 7 nil nil nil 10896 10768 170 192 34 6 10864 8 'categories' 410 ##(Smalltalk.ListView) 34 30 nil 10896 34 2 8 1140936777 1 11008 5250 138 144 1088 nil 5328 706 8 4278190080 nil 29 3490 nil true 34 7 3570 1 3602 #browseSelectorsInProtocol 8 '&Selectors' 1 1 nil nil nil 3570 1 3602 #toggleProtocolReadOnly 8 '&Read Only' 1 1 nil nil nil 8418 4097 3570 1 3602 #addMethodProtocol 8 '&Add...' 1 1 nil nil nil 3490 nil true 34 2 3570 1 3602 #removeMethodProtocol 8 'Protocol' 1 1 nil nil nil 3570 1 3602 #removeMethodsInProtocol 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 3570 1 3602 #renameMethodProtocol 8 'Rename...' 1 1 nil nil nil 3570 1 3602 #browseMethodProtocol 8 'Browse' 1 1 nil nil nil 8 'Protocols' nil 134217729 nil nil nil nil nil nil nil 11008 nil 8 1912800272 2594 #name 8 #() ##(Smalltalk.IconicListAbstract) 2368 nil nil 2418 0 nil 2450 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 11632 7 257 nil 674 65 65 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Protocols' 189 #left 2594 #name 8 #() ##(Smalltalk.SortedCollection) nil nil 11008 nil 3 nil 2418 0 nil 2450 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 11840 7 257 nil #report 1088 nil 133217 nil 8 #(nil) 898 138 144 34 3 962 #createAt:extent: 34 2 674 1 37 674 197 239 11008 962 #contextMenu: 34 1 11136 11008 962 #text: 34 1 8 'Protocols' 11008 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 1104 nil 27 8 'protocols' 410 ##(Smalltalk.ListView) 34 30 nil 10896 34 2 8 1140920395 1 12192 5250 138 144 1088 nil 5328 706 8 4278190080 nil 13 3490 nil true 34 10 3570 2097153 3602 #browseInstVarReferences 8 'Browse &References' 1 1 nil nil nil 8418 4097 3570 1 3602 #addInstanceVariable 8 '&Add...' 1 1 nil nil nil 3570 1 3602 #removeInstanceVariables 8 'Remo&ve' 1 1 nil nil nil 3570 1 3602 #renameInstanceVariable 8 'Re&name' 1 1 nil nil nil 8418 4097 3570 1 3602 #pushDownInstanceVariables 8 'Push &Down' 1 1 nil nil nil 3570 1 3602 #createAccessors 8 '&Create Accessors' 1 1 nil nil nil 3570 1 3602 #abstractInstanceVariables 8 'Ab&stract' 1 1 nil nil nil 3570 1 3602 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 12192 nil 8 1912800272 2594 #value 8 #() 2418 0 nil 2450 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] #key #icon #imageIndex 12816 7 257 nil 2368 nil 2418 0 nil 2450 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] #key #name 8 '.' #, 12896 7 257 nil nil 674 65 65 nil nil 138 144 34 1 11762 8 '' 201 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) nil nil 12192 nil 1 nil nil #list 1088 nil 133217 nil 8 #(nil) 898 138 144 34 2 962 #createAt:extent: 34 2 674 1 37 674 197 239 12192 962 #contextMenu: 34 1 12320 12192 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 1104 nil 27 8 'variables' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 10704 34 2 8 1140916864 1 13296 5250 138 144 34 3 10832 4482 8 'Protocols' 2418 0 nil 2450 6 1 16 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 983558 ##(Smalltalk.VariableBinding) #CardLabel 4480 13424 13522 #MethodProtocol ##(Smalltalk.MethodProtocol) #icon #text:iconBlock: 13440 11 1 nil 21487 4482 8 'Variables' nil 21491 nil 5328 nil nil 1 nil nil nil 13296 nil 8 1912616880 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2368 nil nil nil nil nil #smallIcons nil nil nil nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 674 1 1 674 357 291 13296 962 #basicSelectionsByIndex: 34 1 8 #(1) 13296 962 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 13296 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 8 #() 1104 nil 27 nil 10704 674 33 33 7538 10896 nil 1 7570 674 161 3 674 193 35 nil 3602 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 153 9 674 197 275 10896 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 34 3 10864 11008 12192 1104 nil 27 34 2 8 1140916771 1 10864 590918 3 ##(Smalltalk.TreeModel) nil 5328 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 1088 706 8 4278190080 nil 31 3490 nil true 34 4 3570 1 3602 #addMethodCategory 8 '&Add...' 1 1 nil nil nil 3490 nil true 34 2 3570 1 3602 #removeMethodCategory 8 'Category' 1 1 nil nil nil 3570 1 3602 #removeMethodsInCategory 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 3570 1 3602 #renameMethodCategory 8 'Rename...' 1 1 nil nil nil 3570 1 3602 #browseMethodCategory 8 'Browse' 1 1 nil nil nil 8 'Categories' nil 134217729 nil nil nil nil nil nil nil 10864 nil 8 1912658960 2594 #localName 8 #() ##(Smalltalk.IconicListAbstract) 2368 nil nil 2418 0 nil 2450 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawCategoryTree: 14656 7 257 nil nil nil 170 176 1088 17 #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 1088 898 138 144 34 2 962 #createAt:extent: 34 2 674 1 37 674 197 239 10864 962 #contextMenu: 34 1 14272 10864 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 1104 nil 27 2530 13408 11008 2530 13568 12192 10864 170 192 34 2 10896 8 'filters' nil 13296 10896 674 201 201 401 1 524319 nil nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 733 1 674 357 291 10704 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 1 0 0 0 0 0 0 32 2 0 0 145 0 0 0] 34 2 10896 13296 1104 nil 27 8 'filtersSlidey' nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 1 674 1459 291 5808 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 34 7 6496 410 ##(Smalltalk.Splitter) 34 12 nil 5808 34 2 8 1140850688 1 15392 nil nil nil 519 nil nil nil 3170 15392 nil 1 #left nil nil nil 674 1 1 3216 nil 15472 nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 357 1 674 11 291 15392 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 0 0 0 0 183 0 0 0 145 0 0 0] 8 #() 1104 nil 27 8032 6208 10704 5936 410 ##(Smalltalk.ContainerView) 34 15 nil 5808 34 2 8 1140850688 131073 15648 nil nil nil 7 nil nil nil 15648 498 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 15648 34 2 8 1140850688 131073 15728 nil nil nil 535 nil nil nil 15728 1938 11 1 1 170 192 34 4 410 ##(Smalltalk.RadioButton) 34 16 nil 15728 34 2 8 1141055497 1 15840 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 2594 #= 8 #() 2594 #hash 8 #() false nil nil 7 nil nil nil 15840 nil 8 1912725136 852486 ##(Smalltalk.NullConverter) nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 674 161 1 674 111 51 15840 962 #text: 34 1 8 'C&lass' 15840 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 0 0 0 0 135 0 0 0 25 0 0 0] 8 #() 1104 nil 27 8 'classMode' 410 ##(Smalltalk.RadioButton) 34 16 nil 15728 34 2 8 1141055497 1 16304 15906 nil nil 15938 2594 #= 8 #() 2594 #hash 8 #() false nil nil 7 nil nil nil 16304 nil 8 1912725136 16050 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 674 21 1 674 131 51 16304 962 #text: 34 1 8 'In&stance' 16304 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 75 0 0 0 25 0 0 0] 8 #() 1104 nil 27 8 'instanceMode' 7570 674 21 1 674 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 241 674 361 51 15728 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 120 0 0 0 180 0 0 0 145 0 0 0] 34 2 16304 15840 1104 nil 27 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 15648 34 2 8 1140916224 131073 16928 nil nil nil 31 nil nil nil 16928 866 ##(Smalltalk.MethodBrowser) #resource_Class_browser_method_list nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 1 674 361 241 16928 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 180 0 0 0 120 0 0 0] 1088 1104 nil 27 170 192 34 4 15728 8 'mode' 16928 8 'methods' nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1099 1 674 361 291 15648 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 37 2 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 34 2 16928 15728 1104 nil 27 1104 nil 27 8 'classes' nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 51 674 1459 593 2960 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 217 2 0 0 65 1 0 0] 34 3 5808 3104 3424 1104 nil 27 170 192 34 4 2144 8 'statusbar' 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 9 3490 nil true 34 8 3570 1 3602 #fileNew 8 '&New' 9373 1 8178 nil true 8224 8 'FileNew.ico' 8272 nil nil 3570 1 3602 #fileOpen 8 '&Open...' 9375 1 8178 nil true 8224 8 'FileOpen.ico' 8272 nil nil 3570 1 3602 #fileFileIn 8 '&File In...' 1 1 nil nil nil 8418 4097 3570 1 3602 #saveImage 8 'Sa&ve Image' 1 1 8178 nil true 8224 8 'Snapshot.ico' 8272 nil nil 3570 1 3602 #smalltalkExit 8 'E&xit Dolphin' 1 1 8178 nil true 8224 8 'PowerSwitch.ico' 8272 nil nil 8418 4097 3570 1 3602 #exit 8 '&Close' 17639 1 8178 nil true 8224 8 'CloseWindow.ico' 8272 nil nil 8 '&File' nil 134217729 nil nil 50311 nil nil 3490 nil true 34 13 3570 1 3602 #undo 8 '&Undo' 9397 1 8178 nil true 8224 8 'EditUndo.ico' 8272 nil nil 8418 4097 3570 1 3602 #cutSelection 8 'Cu&t' 9393 1 8178 nil true 8224 8 'EditCut.ico' 8272 nil nil 3570 1 3602 #copySelection 8 '&Copy' 9351 1 8178 nil true 8224 8 'EditCopy.ico' 8272 nil nil 3570 1 3602 #pasteClipboard 8 '&Paste' 9389 1 8178 nil true 8224 8 'EditPaste.ico' 8272 nil nil 3570 1 3602 #editDelete 8 '&Delete' 1 1 8178 nil true 8224 8 'EditClear.ico' 8272 nil nil 3490 nil true 34 2 3570 1 3602 #reformatSource 8 '&Source' 9391 1 nil nil nil 3570 1 3602 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 50327 nil nil 8418 4097 3570 1 3602 #selectAll 8 'Select &All' 9347 1 nil nil nil 8418 4097 3570 1 3602 #editFind 8 '&Find...' 9357 1 8178 nil true 8224 47 786694 ##(Smalltalk.ShellLibrary) nil nil 3570 1 3602 #findNext 8 'Find &Next' 1253 1 8178 nil true 8224 8 'FindNext.ico' 8272 nil nil 3570 1 3602 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 50337 nil nil 3490 nil true 34 16 3570 1 3602 #browseIt 8 '&Browse It' 9349 1 8178 nil true 8224 8 'ClassBrowserShell.ico' 8272 nil nil 3570 1 3602 #displayIt 8 '&Display It' 9353 1 8178 nil true 8224 8 'DisplayIt.ico' 8272 nil nil 3570 1 3602 #evaluateIt 8 '&Evaluate It' 9355 1 8178 nil true 8224 8 'EvaluateIt.ico' 8272 nil nil 3570 1 3602 #inspectIt 8 '&Inspect It' 9363 1 8178 nil true 8224 8 'InspectIt.ico' 8272 nil nil 3570 1 3602 #debugIt 8 'Deb&ug It' 1269 1 8178 nil true 8224 8 'Debugger.ico' 8272 nil nil 3570 1 3602 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 8418 4097 3570 1 3602 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 3570 1 3602 #browseReferences 8 '&References' 5367 1 nil nil nil 8418 4097 3570 2097153 3602 #accept 8 '&Accept' 9383 1 nil nil nil 3570 1 3602 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 8418 4097 3490 nil true 34 14 3570 1 3602 #renameVariable 8 'Re&name <1d>...' 1 1 nil nil nil 8418 4097 3570 1 3602 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 nil nil nil 3570 1 3602 #extractMethod 8 'E&xtract Method...' 9371 1 nil nil nil 3570 1 3602 #extractToComponent 8 'Extract to &Component...' 1 1 nil nil nil 3570 1 3602 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 8418 4097 3570 1 3602 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 3570 1 3602 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 3570 1 3602 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 8418 4097 3570 1 3602 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 nil nil nil 3570 1 3602 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 3570 1 3602 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 8178 nil true 8224 8 'Refactoring.ico' 8272 nil 50381 nil nil 8418 4097 3490 nil true 34 7 3570 1 3602 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3570 1 3602 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3570 1 3602 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 3570 1 3602 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3570 1 3602 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3570 1 3602 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3570 1 3602 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 nil nil 50397 nil nil 8 '&Workspace' nil 134217729 nil nil 50399 nil nil 3490 nil true 34 20 3570 2097153 3602 #findClass 8 'Find...' 1 1 8178 nil true 8224 8 'FindClass.ico' 8272 nil nil 3490 nil true 34 10 3570 1 3602 #browseClassPackage 8 'Package <1d>' 1 1 8178 nil true 8224 8 'Package.ico' 8272 nil nil 8418 4097 3570 2097153 3602 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 3490 nil true 8 #() 8 'Local Re&ferences To' #browseVariablesMenu 134217729 nil nil 50407 nil nil 8418 4097 3570 1 3602 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 3570 1 3602 #browseMethodHistoryForClass 8 'Method &History' 1 1 nil nil nil 8418 4097 3570 1 3602 #browsePublishedEvents 8 'Published &events' 1 1 nil nil nil 3570 1 3602 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil 50417 nil nil 8418 4097 3570 1 3602 #newClass 8 '&New...' 1 1 8178 nil true 8224 8 'NewClass.ico' 8272 nil nil 3570 1 3602 #deleteClassHierarchy 8 '&Delete' 1 1 8178 nil true 8224 8 'EditClear.ico' 8272 nil nil 3490 nil true 34 19 3570 1 3602 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 3570 2097153 3602 #renameClass 8 'Re&name...' 1 1 nil nil nil 3570 1 3602 #copyClass 8 'Cl&one...' 1 1 nil nil nil 8418 4097 3570 1 3602 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 3570 1 3602 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 3490 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil 50433 nil nil 3490 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil 50435 nil nil 8418 4097 3490 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil 50437 nil nil 3490 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil 50439 nil nil 8418 4097 3490 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil 50441 nil nil 3490 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil 50443 nil nil 3490 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil 50445 nil nil 8418 4097 3570 1 3602 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 8418 4097 3570 1 3602 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 8178 nil true 8224 8 'Refactoring.ico' 8272 nil 50451 nil nil 8418 4097 3570 1 3602 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 3570 1 3602 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 8418 4097 3570 1 3602 #fileInClass 8 'File &In...' 1 1 nil nil nil 3570 1 3602 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 8418 4097 3570 1 3602 #classPackage 8 '&Package...' 1 1 8178 nil true 8224 8 'Package.ico' 8272 nil nil 3570 1 3602 #categorizeClass 8 '&Category...' 1 1 nil nil nil 8418 4097 3570 1 3602 #browseClassEditions 8 'Browse &Editions' 1 1 nil nil nil 3570 1 3602 #compareClass 8 'Compare with...' 1 1 nil nil nil 8418 4097 3490 nil true 34 4 3570 1 3602 #newView 8 '&New...' 1 1 nil nil nil 8418 4097 3490 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 nil nil 50471 nil nil 3490 nil true 8 #() 8 '&Show' #viewsShowMenu 1 nil nil 50473 nil nil 8 '&Views' #viewsMenu 1 8178 nil true 8224 8 'View.ico' 8272 nil 50475 nil nil 8 '&Class' nil 134217729 nil nil 50477 nil nil 3490 nil true 34 18 3490 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 50479 nil nil 3490 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 50481 nil nil 3490 nil true 34 14 3570 1 3602 #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 3570 1 3602 #browseContainingText 8 'C&ontaining Text...' 1 1 8178 nil true 8224 8 'SearchText.ico' 8272 nil nil 3570 1 3602 #browseMethodCategory 8 'Cate&gory...' 1 1 nil nil nil 3570 1 3602 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 3570 1 3602 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 8418 4097 3570 1 3602 #browseMethodPackages 8 '&Package <s>' 1 1 nil nil nil 3570 1 3602 #browseMethodClasses 8 '&Class <s>' 1 1 nil nil nil 8418 4097 3570 1 3602 #browseMethodHistory 8 'Change &History' 1 1 nil nil nil 3570 1 3602 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8418 4097 3570 1 3602 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 3570 1 3602 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 50505 nil nil 8418 4097 3570 1 3602 #newMethod 8 '&New' 1 1 8178 nil true 8224 8 'NewMethod.ico' 8272 nil nil 3570 1 3602 #removeMethod 8 '&Delete' 1 1 8178 nil true 8224 8 'EditClear.ico' 8272 nil nil 3490 nil true 34 17 3570 1 3602 #renameMethod 8 'Re&name' 1 1 nil nil nil 3570 1 3602 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 3570 1 3602 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 8418 4097 3570 1 3602 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 3490 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 50519 nil nil 3490 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 50521 nil nil 3490 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 50523 nil nil 8418 4097 3490 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 50525 nil nil 3490 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 50527 nil nil 8418 4097 3570 1 3602 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 3570 1 3602 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 3570 1 3602 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 3570 1 3602 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 3570 1 3602 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 8178 nil true 8224 8 'Refactoring.ico' 8272 nil 50539 nil nil 8418 4097 3570 1 3602 #methodPackage 8 '&Package...' 1 1 8178 nil true 8224 8 'Package.ico' 8272 nil nil 3490 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 50543 nil nil 3490 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 50545 nil nil 3570 1 3602 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 8418 4097 3570 1 3602 #browseMethodEditions 8 'Browse &Editions' 1 1 nil nil nil 3570 1 3602 #browseAvailableMethods 8 'Browse Available Editions' 1 1 nil nil nil 8418 4097 3570 1 3602 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 3570 1 3602 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 50557 nil nil 3490 nil true 34 7 3570 1 3602 #undoChange 8 '&Undo <1d>' 1 1 8178 nil true 8224 8 'EditUndo.ico' 8272 nil nil 3570 1 3602 #redoChange 8 '&Redo <1d>' 1 1 8178 nil true 8224 8 'EditRedo.ico' 8272 nil nil 3570 1 3602 #clearChangeHistory 8 'Clear Change &History' 1 1 nil nil nil 8418 4097 3570 1 3602 #historyBack 8 'Back to <1d>' 1 1 8178 nil true 8224 8 'HistoryBack.ico' 8272 nil nil 3570 1 3602 #historyForward 8 'Forward to <1d>' 1 1 8178 nil true 8224 8 'HistoryForward.ico' 8272 nil nil 3570 1 3602 #historyClear 8 'Clear Visit History' 1 1 nil nil nil 8 'H&istory' nil 134217729 nil nil 50571 nil nil 3490 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 50573 nil nil 3490 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 50575 nil nil 3490 nil true 34 15 3570 1 3602 #helpContents 8 '&Contents' 1025 1 8178 nil true 8224 49 18944 nil nil 3570 1 3602 #help 8 'On this &Tool' 1249 1 nil nil nil 3570 1 3602 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 8418 4097 3570 1 3602 #learnSmalltalk 8 'Learn Smalltalk' 1 1 nil nil nil 8418 4097 3570 1 3602 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3570 1 3602 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3570 1 3602 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 8418 4097 3570 1 3602 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 nil nil nil 3570 1 3602 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3570 1 3602 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 8418 4097 3570 1 3602 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 8178 nil true 8224 8 '!!APPLICATION' 8272 nil nil 8 '&Help' nil 134217729 nil nil 50599 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 674 3839 21 674 1491 801 416 962 #text: 34 1 8 'System Browser' 416 962 #updateMenuBar 1088 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 104 10 0 0 154 1 0 0] 34 3 528 2960 2144 1104 nil 27 )!

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

