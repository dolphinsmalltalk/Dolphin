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
	^AutoSelectPackages!

autoSelectPackages: aBoolean
	AutoSelectPackages := aBoolean!

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

	self defaultShowInheritedMethods: false.
	self defaultFilterObjectMethods: true.
	self canUseIdeaSpace: true.
	self autoSelectPackages: true.
	SmalltalkSystem current
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: (Aspect boolean: #autoSelectPackages);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #toolBackground nil 567 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 917510 ##(Graphics.Color) #default 8 1886172432 170 192 34 8 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Toolbar) #resource_Search_tools nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 615 1 882 437 51 672 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 8 #() 882 193 193 nil 27 8 'searchTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 738 ##(UI.Toolbar) #resource_Image_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 63 51 1024 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 976 992 nil 27 8 'imageTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 738 ##(UI.Toolbar) #resource_Smalltalk_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 63 1 882 553 51 1264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 976 992 nil 27 8 'smalltalkTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1504 nil nil nil 7 nil nil nil 1504 738 ##(UI.Toolbar) #resource_Class_browser_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1051 1 882 353 51 1504 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 189 2 0 0 25 0 0 0] 976 992 nil 27 8 'classBrowserTools' 170 192 976 138 144 976 nil nil 1 nil 882 33 33 nil nil 852806 1 ##(UI.FlowLayout) 1 1 1 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1459 51 528 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 25 0 0 0] 34 4 1024 1264 672 1504 992 nil 27 410 ##(UI.StatusBar) 34 18 nil 416 34 2 8 1140852996 1 1984 nil nil nil 7 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 882 193 193 nil 1984 nil 8 1885871984 170 192 34 8 1050438 1 ##(UI.StatusBarItem) 8193 401 1984 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'packageOfSelection' 2194 8705 351 1984 nil 786950 ##(Core.Message) #displayString 8 #() 2258 #iconImageIndex 8 #() 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:namespace | ''Method namespace: '', namespace fullName]' 8 #[32 105 29 226 1 178 106] 8 'Method namespace: ' #fullName #, 2352 7 257 nil 8 'namespace' 2194 8193 -1 1984 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'message' 2194 8193 45 1984 nil nil 2338 0 nil 2370 6 1 2336 8 'doIt' 8 '[:modified | modified ifTrue: [SmalltalkSystem current changedIcon imageIndex]]' 8 #[34 105 17 122 45 159 160 161 106 60 106] 1442886 2 ##(Kernel.VariableBinding) #'Tools.SmalltalkSystem' ##(Tools.SmalltalkSystem) ##(Smalltalk) 1 #current #changedIcon #imageIndex #ifTrue: 2528 7 257 nil 2338 0 nil 2370 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [''Unsaved edits'']]' 8 #[30 105 17 119 29 106 60 106] 8 'Unsaved edits' 2640 #ifTrue: 7 257 nil 8 'modified' 34 4 2208 2512 2480 2240 1311814 1 ##(UI.StatusBarNullItem) 8705 1 1984 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 643 882 1459 41 1984 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 217 2 0 0 85 1 0 0] 8 #() 992 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2960 nil nil nil 7 nil nil nil 2960 1376774 ##(UI.ProportionalLayout) 138 ##(Core.Dictionary) 34 1 1049094 ##(Core.Association) 410 ##(UI.Splitter) 34 12 nil 2960 34 2 8 1140850688 1 3120 nil nil nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 3120 nil 1 #left nil nil nil 882 1 1 882 9 9 nil 3216 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 291 882 1459 11 3120 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 0 0 0 217 2 0 0 150 0 0 0] 8 #() 992 nil 27 1 true 170 192 34 4 410 ##(UI.CardContainer) 34 16 nil 2960 34 2 8 1140850688 131073 3440 nil nil nil 23 461638 4 ##(UI.Menu) nil true 34 2 3506 nil true 34 4 1180742 2 ##(UI.CommandMenuItem) 1025 1377606 4 ##(UI.CommandDescription) 2258 #tabOrientation: 8 #(#top) 8 '&Top' 1 1 nil nil nil 3586 1025 3618 2258 #tabOrientation: 8 #(#bottom) 8 '&Bottom' 1 1 nil nil nil 3586 1025 3618 2258 #tabOrientation: 8 #(#left) 8 '&Left' 1 1 nil nil nil 3586 1025 3618 2258 #tabOrientation: 8 #(#right) 8 '&Right' 1 1 nil nil nil 8 '&Orientation' nil 134217729 nil nil nil nil nil 3506 nil true 34 6 3586 1025 3618 2258 #viewMode: 8 #(#noIcons) 8 '&No Icons' 1 1 nil nil nil 3586 1025 3618 2258 #viewMode: 8 #(#smallIcons) 8 '&Small Icons' 1 1 nil nil nil 3586 1025 3618 2258 #viewMode: 8 #(#mediumIcons) 8 '&Medium Icons' 1 1 nil nil nil 3586 1025 3618 2258 #viewMode: 8 #(#largeIcons) 8 '&Large Icons' 1 1 nil nil nil 3586 1025 3618 2258 #viewMode: 8 #(#tileIcons) 8 '&Tile Icons' 1 1 nil nil nil 3586 1 3618 2258 #viewMode: 8 #(#thumbnails) 8 'Thum&bnails' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3440 853318 1 ##(UI.CardLayout) 138 144 34 2 3090 787270 1 ##(UI.CardLabel) 8 'Method source' 2338 0 nil 2370 7 1 4576 8 'doIt' 8 '(CardLabel text: ''Method source'' iconBlock: [Icon fromId: ''MethodSource.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 2610 #CardLabel 4576 ##(Smalltalk) 1 4608 2610 #Icon ##(Graphics.Icon) ##(Smalltalk) 1 8 'MethodSource.ico' #fromId: #text:iconBlock: 4624 11 1 nil nil 410 ##(UI.ReferenceView) 34 14 nil 3440 34 2 8 1140850688 131073 4752 nil nil nil 7 nil nil nil 4752 738 ##(Tools.MethodWorkspace) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 9 53 882 1443 233 4752 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 213 2 0 0 142 0 0 0] 976 992 nil 27 3090 4578 8 'Class definition' 2338 0 nil 2370 7 1 4576 8 'doIt' 8 '(CardLabel text: ''Class definition'' iconBlock: [Icon fromId: ''ClassDefinition.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 4704 5008 4720 8 'ClassDefinition.ico' #fromId: #text:iconBlock: 5024 11 1 nil nil 410 ##(UI.ReferenceView) 34 14 nil 3440 34 2 8 1140916224 131073 5120 nil 608 nil 21 nil nil nil 5120 738 ##(Tools.SmalltalkWorkspace) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 9 53 882 1443 233 5120 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 213 2 0 0 142 0 0 0] 976 992 nil 27 4752 nil nil nil 170 192 34 4 4752 8 'source' 5120 8 'definition' nil 410 ##(UI.TabViewXP) 34 28 nil 3440 34 2 8 1140916736 1 5408 787270 2 ##(UI.ListModel) 138 144 34 2 4592 4992 nil 1769478 ##(Kernel.IdentitySearchPolicy) nil nil 17 nil nil nil 5408 nil 8 1885916928 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 1 1 882 1459 293 5408 834 #setSingleSelection: 8 #(1) 5408 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 5408 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 146 0 0 0] 8 #() 992 nil 27 770 138 144 34 2 834 #createAt:extent: 34 2 882 1 301 882 1459 293 3440 834 #contextMenu: 34 1 3520 3440 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 150 0 0 0 217 2 0 0 40 1 0 0] 34 3 4752 5120 5408 992 nil 27 8 'cards' 410 ##(UI.ContainerView) 34 15 nil 2960 34 2 8 1140850688 131073 6048 nil nil nil 7 nil nil nil 6048 3026 138 ##(Core.Dictionary) 34 2 3090 410 ##(UI.Splitter) 34 12 nil 6048 34 2 8 1140850688 1 6176 nil nil nil 519 nil nil nil 3186 6176 nil 1 #left nil nil nil 3216 3232 nil 3216 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1089 1 882 11 291 6176 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 2 0 0 0 0 0 0 37 2 0 0 145 0 0 0] 8 #() 992 nil 27 1 3090 410 ##(UI.Splitter) 34 12 nil 6048 34 2 8 1140850688 1 6432 nil nil nil 519 nil nil nil 3186 6432 nil 1 #left nil nil nil 3216 3232 nil 3216 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 723 1 882 11 291 6432 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 1 0 0 0 0 0 0 110 1 0 0 145 0 0 0] 8 #() 992 nil 27 1 false 170 192 34 6 410 ##(UI.ReferenceView) 34 14 nil 6048 34 2 8 1140916224 131073 6704 nil nil nil 7 3506 nil true 34 17 3586 1 3618 #findClass 8 'Find…' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'FindClass.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 3506 nil true 34 10 3586 1 3618 #browseClassPackage 8 'Package <1d>' 1 1 6850 nil true 6896 8 'Package.ico' 6944 nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 3586 2097153 3618 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 3506 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 7090 4097 3586 1 3618 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 3586 1 3618 #browseMethodHistoryForClass 8 'Method &History' 1 1 6850 nil true 6896 8 'MethodHistory.ico' 6944 nil nil 7090 4097 3586 1 3618 #browsePublishedEvents 8 'Published &events' 1 1 6850 nil true 6896 8 'Event.ico' 6944 nil nil 3586 1 3618 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 7090 4097 3586 1 3618 #newClass 8 '&New…' 1 1 6850 nil true 6896 8 'NewClass.ico' 6944 nil nil 3586 1 3618 #deleteClassHierarchy 8 '&Delete' 1 1 6850 nil true 6896 8 'EditClear.ico' 6944 nil nil 3506 nil true 34 18 3586 1 3618 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 3586 2097153 3618 #renameClass 8 'Re&name…' 1 1 6850 nil true 6896 8 'Rename.ico' 6944 nil nil 7090 4097 3586 1 3618 #addInstanceVariable 8 'Add <1s>&Instance Variable…' 1 1 nil nil nil 3586 1 3618 #addClassVariable 8 'Add &Class Variable…' 1 1 nil nil nil 3506 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 3506 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 7090 4097 3506 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 3506 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 7090 4097 3506 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 3506 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 3506 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 7090 4097 3586 1 3618 #convertToSibling 8 'Con&vert to Sibling…' 1 1 nil nil nil 7090 4097 3586 1 3618 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 6850 nil true 6896 8 'Refactoring.ico' 6944 nil nil nil nil 7090 4097 3586 1 3618 #createInstanceVariableAccessors 8 'Create &Accessors…' 1 1 nil nil nil 3586 1 3618 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 7090 4097 3586 1 3618 #fileInClass 8 'File &In…' 1 1 6850 nil true 6896 8 'FileIn.ico' 6944 nil nil 3586 1 3618 #fileOutClass 8 'File &Out…' 1 1 nil nil nil 7090 4097 3586 1 3618 #classPackage 8 '&Package…' 1 1 6850 nil true 6896 8 'Package.ico' 6944 nil nil 3586 1 3618 #categorizeClass 8 '&Category…' 1 1 6850 nil true 6896 8 'Category.ico' 6944 nil nil 7090 4097 3506 nil true 34 4 3586 1 3618 #newView 8 '&New…' 1 1 nil nil nil 7090 4097 3506 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 6850 nil true 6896 8 'ViewComposer.ico' 6944 nil nil nil nil 3506 nil true 8 #() 8 '&Show' #viewsShowMenu 1 6850 nil true 6896 8 'TestView.ico' 6944 nil nil nil nil 8 '&Views' #viewsMenu 134217729 6850 nil true 6896 8 'View.ico' 6944 nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 6704 738 ##(Tools.ClassListSelector) #resource_Default_view nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 367 1 882 357 291 6704 834 #contextMenu: 34 1 6768 6704 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 183 0 0 0 0 0 0 0 105 1 0 0 145 0 0 0] 976 992 nil 27 8 'classes' 410 ##(UI.SlideyInneyOuteyThing) 34 23 nil 6048 34 2 8 1140850688 131073 9488 nil nil nil 519 nil nil nil 9488 4498 138 144 34 1 3090 4578 8 'Packages' 834 #icon 8 #() ##(Kernel.Package) 21511 410 ##(UI.SlidingCardTray) 34 22 nil 9488 34 2 8 1140850688 131073 9680 nil nil nil 7 nil nil nil 9680 4498 138 144 34 1 3090 4578 8 'Packages' 834 #icon 8 #() ##(Kernel.Package) 21511 410 ##(UI.ReferenceView) 34 14 nil 9680 34 2 8 1140850688 131073 9872 nil nil nil 7 nil nil nil 9872 738 ##(Tools.PackageSelector) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 37 882 293 239 9872 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 146 0 0 0 137 0 0 0] 976 992 nil 27 9872 nil nil nil 170 192 34 2 9872 8 'packages' nil 410 ##(UI.TabViewXP) 34 28 nil 9488 34 2 8 1140916864 1 10144 5474 138 144 34 1 9808 nil 5552 nil nil 1 nil nil nil 10144 nil 8 1885916928 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 5600 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 1 1 882 357 291 10144 834 #setSingleSelection: 8 #(1) 10144 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 10144 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 8 #() 992 nil 27 nil 9488 882 33 33 1246790 1 ##(UI.ButtonInteractor) 9680 nil 1 1180166 ##(Graphics.Rectangle) 882 257 3 882 289 35 nil 3618 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 57 9 882 293 275 9680 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 34 1 9872 992 nil 27 nil nil nil nil 170 192 976 nil 10144 9680 882 201 201 401 1 524319 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 357 291 9488 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 34 2 9680 10144 992 nil 27 8 'packagesSlidey' 410 ##(UI.SlideyInneyOuteyThing) 34 23 nil 6048 34 2 8 1140850688 131073 11008 nil nil nil 519 nil nil nil 11008 4498 138 144 34 3 3090 4578 8 'Categories' 2338 0 nil 2370 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[MethodCategory icon]' 8 #[31 105 45 159 106] 2610 #'Core.MethodCategory' ##(Core.MethodCategory) ##(Smalltalk) 1 #icon 11168 7 1 nil 21481 410 ##(UI.TreeView) 34 27 nil 410 ##(UI.SlidingCardTray) 34 22 nil 11008 34 2 8 1140850688 131073 11296 nil nil nil 7 nil nil nil 11296 11072 170 192 34 6 11264 8 'categories' 410 ##(UI.ListView) 34 45 nil 11296 34 2 8 1140920395 1 11408 5474 138 144 976 nil 5552 608 nil 13 3506 nil true 34 10 3586 2097153 3618 #browseInstVarReferences 8 'Browse &References' 1 1 nil nil nil 7090 4097 3586 1 3618 #addInstanceVariable 8 '&Add…' 1 1 nil nil nil 3586 1 3618 #removeInstanceVariables 8 'Remo&ve' 1 1 nil nil nil 3586 1 3618 #renameInstanceVariable 8 'Re&name' 1 1 nil nil nil 7090 4097 3586 1 3618 #pushDownInstanceVariables 8 'Push &Down' 1 1 nil nil nil 3586 1 3618 #createAccessors 8 '&Create Accessors' 1 1 nil nil nil 3586 1 3618 #abstractInstanceVariables 8 'Ab&stract' 1 1 nil nil nil 3586 1 3618 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 11408 nil 8 1886148704 2258 #value 8 #() 2338 0 nil 2370 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] #key #icon #imageIndex 12000 7 257 nil 5600 nil 2338 0 nil 2370 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] #key #name 8 '.' #, 12080 7 257 nil nil 882 65 65 nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 '' 201 #left ##(UI.BasicListAbstract) 2258 #<= 8 #() nil nil 11408 nil 1 nil nil #list 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 1 37 882 197 239 11408 834 #contextMenu: 34 1 11504 11408 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 992 nil 35 8 'variables' 410 ##(UI.ListView) 34 45 nil 11296 34 2 8 1140936777 1 12528 5474 138 144 976 nil 5552 608 nil 29 3506 nil true 34 7 3586 1 3618 #browseSelectorsInProtocol 8 '&Selectors' 1 1 nil nil nil 3586 1 3618 #toggleProtocolReadOnly 8 '&Read Only' 1 1 nil nil nil 7090 4097 3586 1 3618 #addMethodProtocol 8 '&Add…' 1 1 nil nil nil 3506 nil true 34 2 3586 1 3618 #removeMethodProtocol 8 'Protocol' 1 1 nil nil nil 3586 1 3618 #removeMethodsInProtocol 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 3586 1 3618 #renameMethodProtocol 8 'Rename…' 1 1 nil nil nil 3586 1 3618 #browseMethodProtocol 8 'Browse' 1 1 nil nil nil 8 'Protocols' nil 134217729 nil nil nil nil nil nil nil 12528 nil 8 1886148704 2258 #name 8 #() ##(UI.IconicListAbstract) 5600 nil nil 2338 0 nil 2370 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 13120 7 257 nil 882 65 65 nil nil 138 144 34 1 12226 8 'Protocols' 189 #left 2258 #name 8 #() 2258 #<= 8 #() nil nil 12528 nil 3 nil 2338 0 nil 2370 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 13344 7 257 nil #report 12304 nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 1 37 882 197 239 12528 834 #contextMenu: 34 1 12624 12528 834 #text: 34 1 8 'Protocols' 12528 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 992 nil 35 8 'protocols' nil 410 ##(UI.TabViewXP) 34 28 nil 11008 34 2 8 1140916864 1 13680 5474 138 144 34 3 11136 4578 8 'Protocols' 2338 0 nil 2370 6 1 16 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 2610 #CardLabel 4576 ##(Smalltalk) 1 13808 2610 #MethodProtocol ##(Kernel.MethodProtocol) ##(Smalltalk) 1 #icon #text:iconBlock: 13824 11 1 nil 21487 4578 8 'Variables' nil 21491 nil 5552 nil nil 1 nil nil nil 13680 nil 8 1885916928 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 5600 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 1 1 882 357 291 13680 834 #setSingleSelection: 8 #(1) 13680 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 13680 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 8 #() 992 nil 27 nil 11008 882 33 33 10514 11296 nil 1 10546 882 161 3 882 193 35 nil 3618 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 153 9 882 197 275 11296 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 34 3 11264 12528 11408 992 nil 27 34 2 8 1140916771 1 11264 787526 3 ##(UI.TreeModel) nil 5552 721670 ##(UI.TreeNode) nil nil nil 170 192 976 608 nil 31 3506 nil true 34 4 3586 1 3618 #addMethodCategory 8 '&Add…' 1 1 nil nil nil 3506 nil true 34 2 3586 1 3618 #removeMethodCategory 8 'Category' 1 1 nil nil nil 3586 1 3618 #removeMethodsInCategory 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 3586 1 3618 #renameMethodCategory 8 'Rename…' 1 1 nil nil nil 3586 1 3618 #browseMethodCategory 8 'Browse' 1 1 nil nil nil 8 'Categories' nil 134217729 nil nil nil nil nil nil nil 11264 nil 8 1885992864 2258 #localName 8 #() ##(UI.IconicListAbstract) 5600 nil nil 2338 0 nil 2370 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawCategoryTree: 14976 7 257 nil nil nil 170 176 976 nil #noIcons 1 170 192 976 770 138 144 34 2 834 #createAt:extent: 34 2 882 1 37 882 197 239 11264 834 #contextMenu: 34 1 14592 11264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 992 nil 27 3090 13792 12528 3090 13936 11408 11264 nil nil nil 170 192 34 2 11296 8 'filters' nil 13680 11296 882 201 201 401 1 524319 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 733 1 882 357 291 11008 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 1 0 0 0 0 0 0 32 2 0 0 145 0 0 0] 34 2 11296 13680 992 nil 27 8 'filtersSlidey' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1459 291 6048 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 34 7 9488 410 ##(UI.Splitter) 34 12 nil 6048 34 2 8 1140850688 1 15712 nil nil nil 519 nil nil nil 3186 15712 nil 1 #left nil nil nil 3216 3232 nil 3216 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 357 1 882 11 291 15712 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 0 0 0 0 183 0 0 0 145 0 0 0] 8 #() 992 nil 27 6704 6432 11008 6176 410 ##(UI.ContainerView) 34 15 nil 6048 34 2 8 1140850688 131073 15952 nil nil nil 7 nil nil nil 15952 498 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 15952 34 2 8 1140850688 131073 16032 nil nil nil 535 nil nil nil 16032 1794 11 1 1 170 192 34 4 410 ##(UI.RadioButton) 34 16 nil 16032 34 2 8 1141055497 1 16144 918598 2 ##(UI.ValueHolder) nil nil 1704454 ##(Core.PluggableSearchPolicy) 2258 #= 8 #() 2258 #hash 8 #() false nil nil 7 nil nil nil 16144 nil 8 1886213424 1049094 ##(UI.NullConverter) nil nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 161 1 882 111 51 16144 834 #text: 34 1 8 'C&lass' 16144 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 0 0 0 0 135 0 0 0 25 0 0 0] 8 #() 992 nil 27 8 'classMode' 410 ##(UI.RadioButton) 34 16 nil 16032 34 2 8 1141055497 1 16608 16210 nil nil 16242 2258 #= 8 #() 2258 #hash 8 #() false nil nil 7 nil nil nil 16608 nil 8 1886213424 16354 nil nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 21 1 882 131 51 16608 834 #text: 34 1 8 'In&stance' 16608 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 75 0 0 0 25 0 0 0] 8 #() 992 nil 27 8 'instanceMode' 10546 882 21 1 882 1 1 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 241 882 361 51 16032 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 120 0 0 0 180 0 0 0 145 0 0 0] 34 2 16608 16144 992 nil 27 nil nil 410 ##(UI.ReferenceView) 34 14 nil 15952 34 2 8 1140916224 131073 17232 nil nil nil 31 nil nil nil 17232 738 ##(Tools.MethodBrowser) #resource_Class_browser_method_list nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 361 241 17232 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 180 0 0 0 120 0 0 0] 976 992 nil 27 170 192 34 4 17232 8 'methods' 16032 8 'mode' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1099 1 882 361 291 15952 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 37 2 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 34 2 17232 16032 992 nil 27 992 nil 27 8 'classes' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 51 882 1459 593 2960 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 217 2 0 0 65 1 0 0] 34 3 6048 3120 3440 992 nil 27 170 192 34 4 1984 8 'statusbar' 528 8 'toolbar' nil 658246 4 ##(UI.MenuBar) nil true 34 9 3506 nil true 34 8 3586 1 3618 #fileNew 8 '&New' 9373 1 6850 nil true 6896 8 'NewWorkspace.ico' 6944 nil nil 3586 1 3618 #fileOpen 8 '&Open…' 9375 1 6850 nil true 6896 8 'OpenWorkspace.ico' 6944 nil nil 3586 1 3618 #fileFileIn 8 '&File In…' 1 1 6850 nil true 6896 8 'FileIn.ico' 6944 nil nil 7090 4097 3586 1 3618 #saveImage 8 'Sa&ve Image' 1 1 6850 nil true 6896 8 'Snapshot.ico' 6944 nil nil 3586 1 3618 #smalltalkExit 8 'E&xit Dolphin' 1 1 6850 nil true 6896 8 'PowerSwitch.ico' 6944 nil nil 7090 4097 3586 1 3618 #exit 8 '&Close' 17639 1 1378630 2 ##(Graphics.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 50331 nil nil 3506 nil true 34 13 3586 1 3618 #undo 8 '&Undo' 9397 1 6850 nil true 6896 8 'EditUndo.ico' 6944 nil nil 7090 4097 3586 1 3618 #cutSelection 8 'Cu&t' 9393 1 6850 nil true 6896 8 'EditCut.ico' 6944 nil nil 3586 1 3618 #copySelection 8 '&Copy' 9351 1 6850 nil true 6896 8 'EditCopy.ico' 6944 nil nil 3586 1 3618 #pasteClipboard 8 '&Paste' 9389 1 6850 nil true 6896 8 'EditPaste.ico' 6944 nil nil 3586 1 3618 #editDelete 8 '&Delete' 1 1 6850 nil true 6896 8 'EditClear.ico' 6944 nil nil 3506 nil true 34 2 3586 1 3618 #reformatSource 8 '&Source' 9391 1 nil nil nil 3586 1 3618 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 50361 nil nil 7090 4097 3586 1 3618 #selectAll 8 'Select &All' 9347 1 nil nil nil 7090 4097 3586 1 3618 #editFind 8 '&Find…' 9357 1 6850 nil true  6896 8 'Find.ico' 6944 nil nil 3586 1 3618 #findNext 8 'Find &Next' 1253 1 6850 nil true 6896 8 'FindNext.ico' 6944 nil nil 3586 1 3618 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 50437 nil nil 3506 nil true 34 17 3586 1 3618 #browseIt 8 '&Browse It' 9349 1 6850 nil true 6896 8 'ClassBrowserShell.ico' 6944 nil nil 3586 1 3618 #displayIt 8 '&Display It' 9353 1 6850 nil true 6896 8 'DisplayIt.ico' 6944 nil nil 3586 1 3618 #printIt 8 '&Print It' 9377 1 6850 nil true 6896 8 'PrintIt.ico' 6944 nil nil 3586 1 3618 #evaluateIt 8 '&Evaluate It' 9355 1 6850 nil true 6896 8 'EvaluateIt.ico' 6944 nil nil 3586 1 3618 #inspectIt 8 '&Inspect It' 9363 1 6850 nil true 6896 8 'InspectIt.ico' 6944 nil nil 3586 1 3618 #debugIt 8 'Deb&ug It' 1269 1 6850 nil true 6896 8 'Debugger.ico' 6944 nil nil 3586 1 3618 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 7090 4097 3586 1 3618 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 3586 1 3618 #browseReferences 8 '&References' 5367 1 nil nil nil 7090 4097 3586 2097153 3618 #accept 8 '&Accept' 9383 1 nil nil nil 3586 1 3618 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 7090 4097 3506 nil true 34 14 3586 1 3618 #renameVariable 8 'Re&name <1d>…' 1 1 nil nil nil 7090 4097 3586 1 3618 #extractToTemporary 8 'Extract to &Temporary…' 9385 1 nil nil nil 3586 1 3618 #extractMethod 8 'E&xtract Method…' 9371 1 nil nil nil 3586 1 3618 #extractToComponent 8 'Extract to &Component…' 1 1 nil nil nil 3586 1 3618 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 7090 4097 3586 1 3618 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 3586 1 3618 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 3586 1 3618 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 7090 4097 3586 1 3618 #addParameterToMessage 8 '&Add Parameter to <1d>…' 1 1 nil nil nil 3586 1 3618 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 3586 1 3618 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 6850 nil true 6896 8 'Refactoring.ico' 6944 nil 50483 nil nil 7090 4097 3506 nil true 34 7 3586 1 3618 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3586 1 3618 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3586 1 3618 #toggleLineEndings 8 'Line &Endings' 1 1 18482 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 3586 1 3618 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3586 1 3618 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3586 1 3618 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3586 1 3618 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 6850 nil true 6896 8 'Preferences.ico' 6944 nil 50499 nil nil 8 '&Workspace' nil 134217729 nil nil 50501 nil nil 3506 nil true 34 17 3586 2097153 3618 #findClass 8 'Find…' 1 1 6850 nil true 6896 8 'FindClass.ico' 6944 nil nil 3506 nil true 34 10 3586 1 3618 #browseClassPackage 8 'Package <1d>' 1 1 6850 nil true 6896 8 'Package.ico' 6944 nil nil 7090 4097 3586 2097153 3618 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 3506 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil 50509 nil nil 7090 4097 3586 1 3618 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 3586 1 3618 #browseMethodHistoryForClass 8 'Method &History' 1 1 6850 nil true 6896 8 'MethodHistory.ico' 6944 nil nil 7090 4097 3586 1 3618 #browsePublishedEvents 8 'Published &events' 1 1 6850 nil true 6896 8 'Event.ico' 6944 nil nil 3586 1 3618 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil 50519 nil nil 7090 4097 3586 1 3618 #newClass 8 '&New…' 1 1 6850 nil true 6896 8 'NewClass.ico' 6944 nil nil 3586 1 3618 #deleteClassHierarchy 8 '&Delete' 1 1 6850 nil true 6896 8 'EditClear.ico' 6944 nil nil 3506 nil true 34 19 3586 1 3618 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 3586 2097153 3618 #renameClass 8 'Re&name…' 1 1 6850 nil true 6896 8 'Rename.ico' 6944 nil nil 3586 1 3618 #copyClass 8 'Cl&one…' 1 1 nil nil nil 7090 4097 3586 1 3618 #addInstanceVariable 8 'Add <1s>&Instance Variable…' 1 1 nil nil nil 3586 1 3618 #addClassVariable 8 'Add &Class Variable…' 1 1 nil nil nil 3506 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil 50535 nil nil 3506 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil 50537 nil nil 7090 4097 3506 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil 50539 nil nil 3506 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil 50541 nil nil 7090 4097 3506 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil 50543 nil nil 3506 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil 50545 nil nil 3506 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil 50547 nil nil 7090 4097 3586 1 3618 #convertToSibling 8 'Con&vert to Sibling…' 1 1 nil nil nil 7090 4097 3586 1 3618 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 6850 nil true 6896 8 'Refactoring.ico' 6944 nil 50553 nil nil 7090 4097 3586 1 3618 #createInstanceVariableAccessors 8 'Create &Accessors…' 1 1 nil nil nil 3586 1 3618 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 7090 4097 3586 1 3618 #fileInClass 8 'File &In…' 1 1 6850 nil true 6896 8 'FileIn.ico' 6944 nil nil 3586 1 3618 #fileOutClass 8 'File &Out…' 1 1 nil nil nil 7090 4097 3586 1 3618 #classPackage 8 '&Package…' 1 1 6850 nil true 6896 8 'Package.ico' 6944 nil nil 3586 1 3618 #categorizeClass 8 '&Category…' 1 1 6850 nil true 6896 8 'Category.ico' 6944 nil nil 7090 4097 3506 nil true 34 4 3586 1 3618 #newView 8 '&New…' 1 1 nil nil nil 7090 4097 3506 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 6850 nil true 6896 8 'ViewComposer.ico' 6944 nil 50569 nil nil 3506 nil true 8 #() 8 '&Show' #viewsShowMenu 1 6850 nil true 6896 8 'TestView.ico' 6944 nil 50571 nil nil 8 '&Views' #viewsMenu 134217729 6850 nil true 6896 8 'View.ico' 6944 nil 50573 nil nil 8 '&Class' nil 134217729 nil nil 50575 nil nil 3506 nil true 34 15 3506 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 50577 nil nil 3506 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 50579 nil nil 3506 nil true 34 14 3586 1 3618 #browseReferencesToGlobal 8 'References to Global…' 1 1 nil nil nil 3586 1 3618 #browseContainingText 8 'C&ontaining Text…' 1 1 6850 nil true 6896 8 'SearchText.ico' 6944 nil nil 3586 1 3618 #browseMethodCategory 8 'Cate&gory…' 1 1 6850 nil true 6896 8 'Category.ico' 6944 nil nil 3586 1 3618 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 3586 1 3618 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 7090 4097 3586 1 3618 #browseMethodPackages 8 '&Package <s>' 1 1 6850 nil true 6896 8 'Package.ico' 6944 nil nil 3586 1 3618 #browseMethodClasses 8 '&Class <s>' 1 1 nil nil nil 7090 4097 3586 1 3618 #browseMethodHistory 8 'Change &History' 1 1 6850 nil true 6896 8 'MethodHistory.ico' 6944 nil nil 3586 1 3618 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 7090 4097 3586 1 3618 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 3586 1 3618 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 50603 nil nil 7090 4097 3586 1 3618 #newMethod 8 '&New' 1 1 6850 nil true 6896 8 'NewMethod.ico' 6944 nil nil 3586 1 3618 #removeMethod 8 '&Delete' 1 1 6850 nil true 6896 8 'EditClear.ico' 6944 nil nil 3506 nil true 34 17 3586 1 3618 #renameMethod 8 'Re&name' 1 1 6850 nil true 6896 8 'Rename.ico' 6944 nil nil 3586 1 3618 #renameMethodReferences 8 'Rename Re&ferences…' 1 1 nil nil nil 3586 1 3618 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 7090 4097 3586 1 3618 #addParameter 8 'Add &Parameter…' 1 1 nil nil nil 3506 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 50617 nil nil 3506 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 50619 nil nil 3506 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 50621 nil nil 7090 4097 3506 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 50623 nil nil 3506 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 50625 nil nil 7090 4097 3586 1 3618 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 3586 1 3618 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 3586 1 3618 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 3586 1 3618 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 3586 1 3618 #moveMethod 8 'Move to &Component…' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 6850 nil true 6896 8 'Refactoring.ico' 6944 nil 50637 nil nil 7090 4097 3586 1 3618 #methodPackage 8 '&Package…' 1 1 6850 nil true 6896 8 'Package.ico' 6944 nil nil 3506 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 50641 nil nil 3506 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 50643 nil nil 3586 1 3618 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 7090 4097 3586 1 3618 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 3586 1 3618 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 50651 nil nil 3506 nil true 34 7 3586 1 3618 #undoChange 8 '&Undo <1d>' 1 1 6850 nil true 6896 8 'EditUndo.ico' 6944 nil nil 3586 1 3618 #redoChange 8 '&Redo <1d>' 1 1 6850 nil true 6896 8 'EditRedo.ico' 6944 nil nil 3586 1 3618 #clearChangeHistory 8 'Clear Change &History' 1 1 6850 nil true 6896 8 'MethodHistoryErase.ico' 6944 nil nil 7090 4097 3586 1 3618 #historyBack 8 'Back to <1d>' 1 1 6850 nil true 6896 8 'HistoryBack.ico' 6944 nil nil 3586 1 3618 #historyForward 8 'Forward to <1d>' 1 1 6850 nil true 6896 8 'HistoryForward.ico' 6944 nil nil 3586 1 3618 #historyClear 8 'Clear Visit History' 1 1 6850 nil true 6896 8 'HistoryErase.ico' 6944 nil nil 8 'H&istory' nil 134217729 nil nil 50665 nil nil 3506 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 50667 nil nil 3506 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 50669 nil nil 3506 nil true 34 15 3586 1 3618 #helpContents 8 '&Contents' 1025 1 6850 nil true 6896 8 'Help.ico' 6944 nil nil 3586 1 3618 #help 8 'On this &Tool' 1249 1 nil nil nil 3586 1 3618 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 7090 4097 3586 1 3618 #learnSmalltalk 8 'Learn Smalltalk' 1 1 18482 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 7090 4097 3586 1 3618 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3586 1 3618 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3586 1 3618 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 7090 4097 3586 1 3618 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 6850 nil true 6896 8 '!!APPLICATION' 6944 nil nil 3586 1 3618 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3586 1 3618 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 7090 4097 3586 1 3618 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 18482 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 50693 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 6143 21 882 1491 801 416 834 #text: 34 1 8 'System Browser' 416 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 232 14 0 0 154 1 0 0] 34 3 528 2960 1984 992 nil 27 )!

toolsFolderHelpId
	^10595!

uninitialize
	"Private - Uninitialize the receiver prior to remove from the system.
		self uninitialize
	"

	SmalltalkSystem.Current
		ifNotNil: [:devsys | devsys systemBrowserClass == self ifTrue: [devsys systemBrowserClass: nil]]! !
!Tools.SystemBrowserShell class categoriesForMethods!
autoSelectPackages!accessing!private! !
autoSelectPackages:!accessing!private! !
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
toolsFolderHelpId!constants!public! !
uninitialize!class hierarchy-removing!private! !
!

