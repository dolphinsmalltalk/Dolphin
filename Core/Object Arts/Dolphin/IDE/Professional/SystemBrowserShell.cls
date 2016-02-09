"Filed out from Dolphin Smalltalk 7"!

ClassBrowserAbstract subclass: #SystemBrowserShell
	instanceVariableNames: ''
	classVariableNames: 'AutoSelectPackages'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SystemBrowserShell guid: (GUID fromString: '{4E96E0DF-9DB3-4D86-89D0-91D646C5209F}')!
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

plugins
	"CodeMentorPlugin requires IE component"

	^NTLibrary isWine 
		ifTrue: [super plugins reject: [:each | each name == #CodeMentorPlugin]]
		ifFalse: [super plugins]!

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 196934 1 ##(Smalltalk.RGB) 8 4294967295 0 567 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851532 131073 560 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 28 198 63 1 0 0 204 53 63 1 3 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point) 193 193 0 560 642 672 8 4294902647 234 256 98 6 410 8 ##(Smalltalk.ReferenceView) 98 14 0 560 98 2 8 1140850688 131073 864 0 0 0 7 0 0 0 864 1180166 ##(Smalltalk.ResourceIdentifier) 576 8 #resource_Class_browser_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 770 1053 1 770 307 51 864 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 2 0 0 0 0 0 0 167 2 0 0 25 0 0 0] 98 0 770 193 193 0 27 8 'classBrowserTools' 410 880 98 14 0 560 98 2 8 1140850688 131073 1248 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 0 0 1248 946 576 8 #resource_Smalltalk_tools 0 994 202 208 98 1 1058 1088 98 2 770 63 1 770 991 51 1248 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1200 1216 0 27 8 'smalltalkTools' 410 880 98 14 0 560 98 2 8 1140850688 131073 1536 0 1314 31 0 7 0 0 0 1536 946 576 8 #resource_Image_tools 0 994 202 208 98 1 1058 1088 98 2 770 1 1 770 63 51 1536 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1200 1216 0 27 8 'imageTools' 234 256 1200 202 208 1200 234 240 1200 0 1 0 770 33 33 770 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 994 202 208 98 2 1058 1088 98 2 770 1 1 770 1459 51 560 1058 8 #updateSizePosted 1200 560 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 25 0 0 0] 98 3 1536 1248 864 1216 0 27 410 8 ##(Smalltalk.StatusBar) 98 18 0 416 98 2 8 1140852996 1 2112 0 642 8 4278190080 0 7 0 690 0 16 722 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 770 193 193 0 2112 0 8 4294902455 234 256 98 8 853766 ##(Smalltalk.StatusBarItem) 1 401 2112 0 8 ##(Smalltalk.BasicListAbstract) 8 ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'packageOfSelection' 2338 1 841 2112 0 2368 2384 2416 8 'message' 2338 1 45 2112 0 0 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 5 1 8 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association) 8 #Smalltalk 48 8 #developmentSystem 8 #changedIcon 8 #imageIndex 2512 7 257 0 0 8 'modified' 2338 1 -1 2112 0 459270 ##(Smalltalk.Message) 8 #displayString 98 0 2498 0 0 918822 ##(Smalltalk.CompiledMethod) 2 3 2336 8 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] 8 #iconImageIndex 2816 7 257 0 0 8 'version' 98 4 2352 2480 2448 2736 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2112 0 0 994 202 208 98 1 1058 1088 98 2 770 1 643 770 1459 41 2112 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 217 2 0 0 85 1 0 0] 98 0 1216 0 27 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 3136 0 0 0 7 0 0 0 3136 1180166 ##(Smalltalk.ProportionalLayout) 202 8 ##(Smalltalk.Dictionary) 98 1 2626 410 8 ##(Smalltalk.Splitter) 98 12 0 3136 98 2 8 1140850688 1 3312 0 642 672 0 519 0 0 0 3312 994 202 208 98 1 1058 1088 98 2 770 1 291 770 1459 11 3312 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 0 0 0 217 2 0 0 150 0 0 0] 98 0 1216 0 27 1 16 234 256 98 4 410 3152 98 15 0 3136 98 2 8 1140850688 131073 3600 0 0 0 7 0 0 0 3600 3218 202 3264 98 2 2626 410 3328 98 12 0 3600 98 2 8 1140850688 1 3728 0 642 672 0 519 0 0 0 3728 994 202 208 98 1 1058 1088 98 2 770 1087 1 770 11 291 3728 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 2 0 0 0 0 0 0 36 2 0 0 145 0 0 0] 98 0 1216 0 27 1 2626 410 3328 98 12 0 3600 98 2 8 1140850688 1 3984 0 642 672 0 519 0 0 0 3984 994 202 208 98 1 1058 1088 98 2 770 721 1 770 11 291 3984 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 104 1 0 0 0 0 0 0 109 1 0 0 145 0 0 0] 98 0 1216 0 27 1 32 234 256 98 6 410 8 ##(Smalltalk.SlideyInneyOuteyThing) 98 23 0 3600 98 2 8 1140850688 131073 4256 0 0 0 519 0 0 0 4256 655878 ##(Smalltalk.CardLayout) 202 208 98 3 2626 590662 1 ##(Smalltalk.CardLabel) 8 'Categories' 0 21481 410 8 ##(Smalltalk.TreeView) 98 27 0 410 8 ##(Smalltalk.SlidingCardTray) 98 22 0 4256 98 2 8 1140850688 131073 4512 0 917766 ##(Smalltalk.PluggableColor) 1058 8 #toolBackgroundColor 98 0 8 ##(Smalltalk.SmalltalkSystem) 0 7 0 0 0 4512 4352 234 256 98 6 410 8 ##(Smalltalk.ListView) 98 30 0 4512 98 2 8 1140936777 1 4720 590662 2 ##(Smalltalk.ListModel) 202 208 1200 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 642 8 4278190080 0 29 265030 4 ##(Smalltalk.Menu) 0 16 98 7 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #browseSelectorsInProtocol 8 '&Selectors' 1 1 0 0 0 4962 1 4994 8 #toggleProtocolReadOnly 8 '&Read Only' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4962 1 4994 8 #addMethodProtocol 8 '&Add...' 1 1 0 0 0 4914 0 16 98 2 4962 1 4994 8 #removeMethodProtocol 8 'Protocol' 1 1 0 0 0 4962 1 4994 8 #removeMethodsInProtocol 8 'Methods' 1 1 0 0 0 8 'Remove' 0 1 0 0 0 0 0 4962 1 4994 8 #renameMethodProtocol 8 'Rename...' 1 1 0 0 0 4962 1 4994 8 #browseMethodProtocol 8 'Browse' 1 1 0 0 0 8 'Protocols' 0 134217729 0 0 0 0 0 0 0 4720 0 8 4294902537 2754 8 #name 98 0 2384 2416 0 0 2498 0 0 2530 5 1 2560 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] 8 #view 8 #presenter 8 #parentPresenter 8 #customDrawProtocols: 5600 7 257 0 770 65 65 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Protocols' 201 8 #left 2754 5568 98 0 8 ##(Smalltalk.SortedCollection) 0 0 4720 0 3 0 2498 0 0 2530 5 1 2560 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] 5680 5696 5712 5728 5904 7 257 0 8 #report 1200 0 133217 0 98 1 0 994 202 208 98 3 1058 1088 98 2 770 1 37 770 209 239 4720 1058 8 #contextMenu: 98 1 4928 4720 1058 8 #text: 98 1 8 'Protocols' 4720 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 104 0 0 0 137 0 0 0] 98 0 1216 0 27 8 'protocols' 410 4736 98 30 0 4512 98 2 8 1140920395 1 6304 4802 202 208 1200 0 4864 642 8 4278190080 0 13 4914 0 16 98 10 4962 2097153 4994 8 #browseInstVarReferences 8 'Browse &References' 1 1 0 0 0 5122 4097 4962 1 4994 8 #addInstanceVariable 8 '&Add...' 1 1 0 0 0 4962 1 4994 8 #removeInstanceVariables 8 'Remo&ve' 1 1 0 0 0 4962 1 4994 8 #renameInstanceVariable 8 'Re&name' 1 1 0 0 0 5122 4097 4962 1 4994 8 #pushDownInstanceVariables 8 'Push &Down' 1 1 0 0 0 4962 1 4994 8 #createAccessors 8 '&Create Accessors' 1 1 0 0 0 4962 1 4994 8 #abstractInstanceVariables 8 'Ab&stract' 1 1 0 0 0 4962 1 4994 8 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 0 0 0 0 0 134217729 0 0 0 0 0 0 0 6304 0 8 4294902537 2754 8 #value 98 0 2498 0 0 2530 4 1 2560 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] 8 #key 8 #icon 2704 7072 7 257 0 2416 0 2498 0 0 2530 5 1 2560 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] 7152 5568 8 '.' 8 #, 7184 7 257 0 0 770 65 65 0 0 202 208 98 1 5794 8 '' 201 5840 2368 5888 0 0 6304 0 1 0 0 8 #list 1200 0 133217 0 98 1 0 994 202 208 98 2 1058 1088 98 2 770 1 37 770 209 239 6304 1058 6144 98 1 6432 6304 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 104 0 0 0 137 0 0 0] 98 0 1216 0 27 8 'variables' 4464 8 'categories' 0 410 8 ##(Smalltalk.TabViewXP) 98 28 0 4256 98 2 8 1140916864 1 7632 4802 202 208 98 3 4432 4418 8 'Protocols' 2498 0 0 2530 6 1 80 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 983558 ##(Smalltalk.VariableBinding) 8 #CardLabel 4416 7776 7874 8 #MethodProtocol 8 ##(Smalltalk.MethodProtocol) 7168 8 #text:iconBlock: 7792 11 1 0 21487 4418 8 'Variables' 0 21491 0 4864 4608 0 1 0 0 0 7632 0 8 4294902189 2368 2384 2416 0 0 0 0 0 8 #smallIcons 0 0 0 0 0 994 202 208 98 3 1058 1088 98 2 770 1 1 770 357 291 7632 1058 8 #basicSelectionsByIndex: 98 1 98 1 3 7632 1058 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 7632 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 98 0 1216 0 27 0 4256 770 33 33 1049862 ##(Smalltalk.ButtonInteractor) 4512 0 590342 ##(Smalltalk.Rectangle) 770 173 3 770 205 35 1 4994 8 #togglePin 8 'Pin or Unpin the tray' 1 1 0 0 0 994 202 208 98 1 1058 1088 98 2 770 141 9 770 209 275 4512 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 98 3 4464 4720 6304 1216 0 27 98 2 8 1140916771 1 4464 590918 3 ##(Smalltalk.TreeModel) 0 4864 525062 ##(Smalltalk.TreeNode) 0 0 0 234 256 1200 642 8 4278190080 0 31 4914 0 16 98 4 4962 1 4994 8 #addMethodCategory 8 '&Add...' 1 1 0 0 0 4914 0 16 98 2 4962 1 4994 8 #removeMethodCategory 8 'Category' 1 1 0 0 0 4962 1 4994 8 #removeMethodsInCategory 8 'Methods' 1 1 0 0 0 8 'Remove' 0 1 0 0 0 0 0 4962 1 4994 8 #renameMethodCategory 8 'Rename...' 1 1 0 0 0 4962 1 4994 8 #browseMethodCategory 8 'Browse' 1 1 0 0 0 8 'Categories' 0 134217729 0 0 0 0 0 0 0 4464 0 8 4294902263 2754 8 #localName 98 0 2384 2416 0 0 2498 0 0 2530 5 1 2560 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] 5680 5696 5712 8 #customDrawCategoryTree: 9264 7 257 0 0 0 234 240 1200 17 8 #noIcons 1 0 994 202 208 98 2 1058 1088 98 2 770 1 37 770 209 239 4464 1058 6144 98 1 8784 4464 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 104 0 0 0 137 0 0 0] 98 0 1216 0 27 2626 7760 4720 2626 7984 6304 4464 234 256 98 2 4512 8 'filters' 0 7632 4512 770 201 201 401 1 524319 0 0 994 202 208 98 1 1058 1088 98 2 770 731 1 770 357 291 4256 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 109 1 0 0 0 0 0 0 31 2 0 0 145 0 0 0] 98 2 4512 7632 1216 0 27 8 'filtersSlidey' 410 4272 98 23 0 3600 98 2 8 1140850688 131073 9856 0 0 0 519 0 0 0 9856 4338 202 208 98 1 2626 4418 8 'Packages' 1058 7168 98 0 8 ##(Smalltalk.Package) 21511 410 4528 98 22 0 9856 98 2 8 1140850688 131073 10064 0 4594 1058 4640 98 0 4672 0 7 0 0 0 10064 4338 202 208 98 1 2626 4418 8 'Packages' 1058 7168 98 0 10048 21511 410 880 98 14 0 10064 98 2 8 1140850688 131073 10304 0 0 0 7 0 0 0 10304 946 8 ##(Smalltalk.PackageSelector) 8 #resource_Default_view 0 994 202 208 98 1 1058 1088 98 2 770 1 37 770 297 239 10304 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 148 0 0 0 137 0 0 0] 1200 1216 0 27 10304 234 256 98 2 10304 8 'packages' 0 410 7648 98 28 0 9856 98 2 8 1140916864 1 10608 4802 202 208 98 1 10240 0 4864 10128 0 1 0 0 0 10608 0 8 4294902189 2368 2384 2416 0 0 0 0 0 8032 0 0 0 0 0 994 202 208 98 3 1058 1088 98 2 770 1 1 770 357 291 10608 1058 8176 98 1 98 1 3 10608 1058 8240 98 2 -1 1 10608 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 98 0 1216 0 27 0 9856 770 33 33 8338 10064 0 8370 770 261 3 770 293 35 1 4994 8448 8 'Pin or Unpin the tray' 1 1 0 0 0 994 202 208 98 1 1058 1088 98 2 770 53 9 770 297 275 10064 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 26 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 98 1 10304 1216 0 27 0 234 256 1200 0 10608 10064 770 201 201 401 1 524319 0 0 994 202 208 98 1 1058 1088 98 2 770 1 1 770 357 291 9856 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 98 2 10064 10608 1216 0 27 8 'packagesSlidey' 410 880 98 14 0 3600 98 2 8 1140916224 131073 11456 0 4594 1058 4640 98 0 4672 0 7 4914 0 16 98 20 4962 1 4994 8 #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 4914 0 16 98 10 4962 1 4994 8 #browseClassPackage 8 'Package <1d>' 1 1 11666 0 16 11712 8 'Package.ico' 11760 0 0 5122 4097 4962 2097153 4994 8 #browseClassReferences 8 '&Class References' 1 1 0 0 0 4914 0 16 98 0 8 'Local Re&ferences To' 8 #browseVariablesMenu 134217729 0 0 0 0 0 5122 4097 4962 1 4994 8 #browseChangedMethods 8 'Changed &Methods' 1 1 0 0 0 4962 1 4994 8 #browseMethodHistoryForClass 8 'Method &History' 1 1 0 0 0 5122 4097 4962 1 4994 8 #browsePublishedEvents 8 'Published &events' 1 1 0 0 0 4962 1 4994 8 #browsePublishedAspects 8 'Published &aspects' 1 1 0 0 0 8 '&Browse' 8 #browseMenu 134217729 0 0 0 0 0 5122 4097 4962 1 4994 8 #newClass 8 '&New...' 1 1 11666 0 16 11712 8 'NewClass.ico' 11760 0 0 4962 1 4994 8 #deleteClassHierarchy 8 '&Delete' 1 1 11666 0 16 11712 8 'EditClear.ico' 11760 0 0 4914 0 16 98 18 4962 1 4994 8 #safeRemoveClass 8 '&Remove' 1 1 0 0 0 4962 2097153 4994 8 #renameClass 8 'Re&name...' 1 1 0 0 0 5122 4097 4962 1 4994 6576 8 'Add <1s>&Instance Variable...' 1 1 0 0 0 4962 1 4994 8 #addClassVariable 8 'Add &Class Variable...' 1 1 0 0 0 4914 0 16 98 0 8 'Re&move Variable' 8 #removeVariables 134217729 0 0 0 0 0 4914 0 16 98 0 8 'Ren&ame Variable' 8 #renameVariables 134217729 0 0 0 0 0 5122 4097 4914 0 16 98 0 8 'Push &Down' 8 #pushDownVariables 134217729 0 0 0 0 0 4914 0 16 98 0 8 'Pull &Up' 8 #pullUpVariables 134217729 0 0 0 0 0 5122 4097 4914 0 16 98 0 8 'Cr&eate Accessors' 8 #createVariableAccessors 134217729 0 0 0 0 0 4914 0 16 98 0 8 'A&bstract' 8 #abstractVariables 134217729 0 0 0 0 0 4914 0 16 98 0 8 '&Protect/Concrete' 8 #protectVariables 134217729 0 0 0 0 0 5122 4097 4962 1 4994 8 #convertToSibling 8 'Con&vert to Sibling...' 1 1 0 0 0 5122 4097 4962 1 4994 8 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 0 0 0 8 '&Refactorings' 8 #classRefactoringsMenu 134217729 11666 0 16 11712 8 'Refactoring.ico' 11760 0 0 0 0 5122 4097 4962 1 4994 8 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 0 0 0 4962 1 4994 8 #reformatAll 8 'Refor&mat All' 1 1 0 0 0 5122 4097 4962 1 4994 8 #fileInClass 8 'File &In...' 1 1 0 0 0 4962 1 4994 8 #fileOutClass 8 'File &Out...' 1 1 0 0 0 5122 4097 4962 1 4994 8 #classPackage 8 '&Package...' 1 1 11666 0 16 11712 8 'Package.ico' 11760 0 0 4962 1 4994 8 #categorizeClass 8 '&Category...' 1 1 0 0 0 5122 4097 4962 1 4994 8 #browseClassEditions 8 'Browse &Editions' 1 1 0 0 0 4962 1 4994 8 #compareClass 8 'Compare with...' 1 1 0 0 0 5122 4097 4914 0 16 98 4 4962 1 4994 8 #newView 8 '&New...' 1 1 0 0 0 5122 4097 4914 0 16 98 0 8 '&Edit' 8 #viewsEditMenu 1 0 0 0 0 0 4914 0 16 98 0 8 '&Show' 8 #viewsShowMenu 1 0 0 0 0 0 8 '&Views' 8 #viewsMenu 1 11666 0 16 11712 8 'View.ico' 11760 0 0 0 0 8 '&Class' 0 134217729 0 0 0 0 0 0 0 11456 946 8 ##(Smalltalk.ClassListSelector) 10400 0 994 202 208 98 2 1058 1088 98 2 770 365 1 770 357 291 11456 1058 6144 98 1 11568 11456 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 182 0 0 0 0 0 0 0 104 1 0 0 145 0 0 0] 1200 1216 0 27 8 'classes' 0 994 202 208 98 1 1058 1088 98 2 770 1 1 770 1459 291 3600 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 98 7 9856 410 3328 98 12 0 3600 98 2 8 1140850688 1 14912 0 642 8 4278190080 0 7 0 0 0 14912 994 202 208 98 1 1058 1088 98 2 770 357 1 770 9 291 14912 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 0 0 0 0 182 0 0 0 145 0 0 0] 98 0 1216 0 27 11456 3984 4256 3728 410 3152 98 15 0 3600 98 2 8 1140850688 131073 15168 0 0 0 7 0 0 0 15168 530 1 1 0 410 576 98 25 0 15168 98 2 8 1140886340 131137 15248 0 642 8 4278190080 0 535 0 0 0 15248 642 8 4278190080 8 4294902647 234 256 98 4 410 8 ##(Smalltalk.RadioButton) 98 16 0 15248 98 2 8 1141055497 1 15424 721990 2 ##(Smalltalk.ValueHolder) 0 0 1376774 ##(Smalltalk.PluggableSearchPolicy) 2754 8 #= 98 0 2754 8 #hash 98 0 32 0 0 7 0 0 0 15424 0 8 4294902067 852486 ##(Smalltalk.NullConverter) 0 0 0 994 202 208 98 2 1058 1088 98 2 770 21 1 770 131 51 15424 1058 6192 98 1 8 'In&stance' 15424 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 75 0 0 0 25 0 0 0] 98 0 1216 0 27 8 'instanceMode' 410 15440 98 16 0 15248 98 2 8 1141055497 1 15936 15506 0 0 15538 2754 15584 98 0 2754 15632 98 0 32 0 0 7 0 0 0 15936 0 8 4294902067 15682 0 0 0 994 202 208 98 2 1058 1088 98 2 770 161 1 770 111 51 15936 1058 6192 98 1 8 'C&lass' 15936 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 0 0 0 0 135 0 0 0 25 0 0 0] 98 0 1216 0 27 8 'classMode' 234 256 1200 98 0 234 240 1200 8370 770 21 1 770 1 1 1 0 770 33 31 770 45 45 0 1890 11 1 1 994 202 208 98 2 1058 1088 98 2 770 1 241 770 363 51 15248 1058 2048 1200 15248 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 120 0 0 0 181 0 0 0 145 0 0 0] 98 2 15424 15936 1216 0 27 0 0 410 880 98 14 0 15168 98 2 8 1140916224 131073 16672 0 0 0 31 0 0 0 16672 946 8 ##(Smalltalk.MethodBrowser) 8 #resource_Class_browser_method_list 0 994 202 208 98 1 1058 1088 98 2 770 1 1 770 363 241 16672 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 181 0 0 0 120 0 0 0] 1200 1216 0 27 234 256 98 4 16672 8 'methods' 15248 8 'mode' 0 994 202 208 98 1 1058 1088 98 2 770 1097 1 770 363 291 15168 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 36 2 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 98 2 16672 15248 1216 0 27 1216 0 27 8 'classes' 410 8 ##(Smalltalk.CardContainer) 98 16 0 3136 98 2 8 1140850688 131073 17168 0 4594 1058 4640 98 0 4672 0 23 4914 0 16 98 2 4914 0 16 98 4 4962 1025 4994 2754 8 #tabOrientation: 98 1 8 #top 8 '&Top' 1 1 0 0 0 4962 1025 4994 2754 17408 98 1 8 #bottom 8 '&Bottom' 1 1 0 0 0 4962 1025 4994 2754 17408 98 1 5840 8 '&Left' 1 1 0 0 0 4962 1025 4994 2754 17408 98 1 8 #right 8 '&Right' 1 1 0 0 0 8 '&Orientation' 0 134217729 0 0 0 0 0 4914 0 16 98 5 4962 1025 4994 2754 8 #viewMode: 98 1 9376 8 '&No Icons' 1 1 0 0 0 4962 1025 4994 2754 17840 98 1 8032 8 '&Small Icons' 1 1 0 0 0 4962 1025 4994 2754 17840 98 1 8 #mediumIcons 8 'Medium Icons' 1 1 0 0 0 4962 1025 4994 2754 17840 98 1 8 #largeIcons 8 '&Large Icons' 1 1 0 0 0 4962 1 4994 2754 17840 98 1 8 #tileIcons 8 'Tile Icons' 1 1 0 0 0 8 '&View' 0 134217729 0 0 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 17168 4338 202 208 98 2 2626 4418 8 'Method source' 1058 7168 98 0 2832 20981 410 880 98 14 0 17168 98 2 8 1140850688 131073 18416 0 0 0 5 0 0 0 18416 946 8 ##(Smalltalk.MethodWorkspace) 10400 0 994 202 208 98 1 1058 1088 98 2 770 9 55 770 1443 231 18416 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 213 2 0 0 142 0 0 0] 1200 1216 0 27 2626 4418 8 'Class definition' 1058 7168 98 0 8 ##(Smalltalk.Class) 21493 410 880 98 14 0 17168 98 2 8 1140916224 131073 18752 0 0 0 23 0 0 0 18752 946 8 ##(Smalltalk.SmalltalkWorkspace) 10400 0 994 202 208 98 1 1058 1088 98 2 770 9 55 770 1443 231 18752 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 213 2 0 0 142 0 0 0] 1200 1216 0 27 18752 234 256 98 4 18752 8 'definition' 18416 8 'source' 0 410 7648 98 28 0 17168 98 2 8 1140916736 1 19056 4802 202 208 98 2 18352 18672 0 4864 17248 0 17 0 0 0 19056 0 8 4294902189 2368 2384 2416 0 0 0 0 0 8032 0 0 0 0 0 994 202 208 98 3 1058 1088 98 2 770 1 1 770 1459 293 19056 1058 8176 98 1 98 1 5 19056 1058 8240 98 2 -1 1 19056 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 146 0 0 0] 98 0 1216 0 27 994 202 208 98 2 1058 1088 98 2 770 1 301 770 1459 293 17168 1058 6144 98 1 17296 17168 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 150 0 0 0 217 2 0 0 40 1 0 0] 98 3 18416 18752 19056 1216 0 27 8 'cards' 0 994 202 208 98 1 1058 1088 98 2 770 1 51 770 1459 593 3136 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 217 2 0 0 65 1 0 0] 98 3 3600 3312 17168 1216 0 27 234 256 98 4 2112 8 'statusbar' 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 9 4914 0 16 98 8 4962 1 4994 8 #fileNew 8 '&New' 9373 1 11666 0 16 11712 8 'FileNew.ico' 11760 0 0 4962 1 4994 8 #fileOpen 8 '&Open...' 9375 1 11666 0 16 11712 8 'FileOpen.ico' 11760 0 0 4962 1 4994 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 5122 4097 4962 1 4994 8 #saveImage 8 'Sa&ve Image' 1 1 11666 0 16 11712 8 'Snapshot.ico' 11760 0 0 4962 1 4994 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 11666 0 16 11712 8 'PowerSwitch.ico' 11760 0 0 5122 4097 4962 1 4994 8 #exit 8 '&Close' 17639 1 11666 0 16 11712 8 'CloseWindow.ico' 11760 0 0 8 '&File' 0 134217729 0 0 27361 0 0 4914 0 16 98 13 4962 1 4994 8 #undo 8 '&Undo' 9397 1 11666 0 16 11712 8 'EditUndo.ico' 11760 0 0 5122 4097 4962 1 4994 8 #cutSelection 8 'Cu&t' 9393 1 11666 0 16 11712 8 'EditCut.ico' 11760 0 0 4962 1 4994 8 #copySelection 8 '&Copy' 9351 1 11666 0 16 11712 8 'EditCopy.ico' 11760 0 0 4962 1 4994 8 #pasteClipboard 8 '&Paste' 9389 1 11666 0 16 11712 8 'EditPaste.ico' 11760 0 0 4962 1 4994 8 #editDelete 8 '&Delete' 1 1 11666 0 16 11712 8 'EditClear.ico' 11760 0 0 4914 0 16 98 2 4962 1 4994 8 #reformatSource 8 '&Source' 9391 1 0 0 0 4962 1 4994 8 #reformatComment 8 '&Comment' 9367 1 0 0 0 8 'Ref&ormat' 0 134217729 0 0 27377 0 0 5122 4097 4962 1 4994 8 #selectAll 8 'Select &All' 9347 1 0 0 0 5122 4097 4962 1 4994 8 #editFind 8 '&Find...' 9357 1 11666 0 16 11712 47 786694 ##(Smalltalk.ShellLibrary) 0 0 4962 1 4994 8 #findNext 8 'Find &Next' 1253 1 11666 0 16 11712 8 'FindNext.ico' 11760 0 0 4962 1 4994 8 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 134217729 0 0 27387 0 0 4914 0 16 98 16 4962 1 4994 8 #browseIt 8 '&Browse It' 9349 1 11666 0 16 11712 8 'ClassBrowserShell.ico' 11760 0 0 4962 1 4994 8 #displayIt 8 '&Display It' 9353 1 11666 0 16 11712 8 'DisplayIt.ico' 11760 0 0 4962 1 4994 8 #evaluateIt 8 '&Evaluate It' 9355 1 11666 0 16 11712 8 'EvaluateIt.ico' 11760 0 0 4962 1 4994 8 #inspectIt 8 '&Inspect It' 9363 1 11666 0 16 11712 8 'InspectIt.ico' 11760 0 0 4962 1 4994 8 #debugIt 8 'Deb&ug It' 1269 1 11666 0 16 11712 8 'Debugger.ico' 11760 0 0 4962 1 4994 8 #fileItIn 8 'Fi&le It In' 1 1 0 0 0 5122 4097 4962 1 4994 8 #browseDefinitions 8 'Defi&nitions' 1271 1 0 0 0 4962 1 4994 8 #browseReferences 8 '&References' 5367 1 0 0 0 5122 4097 4962 2097153 4994 8 #accept 8 '&Accept' 9383 1 0 0 0 4962 1 4994 8 #reformatAccept 8 'Refor&mat/Accept' 13479 1 0 0 0 5122 4097 4914 0 16 98 14 4962 1 4994 8 #renameVariable 8 'Re&name <1d>...' 1 1 0 0 0 5122 4097 4962 1 4994 8 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 0 0 0 4962 1 4994 8 #extractMethod 8 'E&xtract Method...' 9371 1 0 0 0 4962 1 4994 8 #extractToComponent 8 'Extract to &Component...' 1 1 0 0 0 4962 1 4994 8 #inlineMessage 8 'Inline &Message' 13467 1 0 0 0 5122 4097 4962 1 4994 8 #inlineTemporary 8 '&Inline Temporary' 13481 1 0 0 0 4962 1 4994 8 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 0 0 0 4962 1 4994 8 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 0 0 0 5122 4097 4962 1 4994 8 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 0 0 0 4962 1 4994 8 #inlineParameter 8 'In&line Parameter' 1 1 0 0 0 4962 1 4994 8 #removeParameter 8 'Remove &Parameter' 1 1 0 0 0 8 'Re&factorings' 8 #codeRefactoringsMenu 134217729 11666 0 16 11712 8 'Refactoring.ico' 11760 0 27431 0 0 5122 4097 4914 0 16 98 7 4962 1 4994 8 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 4962 1 4994 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 4962 1 4994 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 4962 1 4994 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 4962 1 4994 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 4962 1 4994 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 4962 1 4994 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 8 '&Options' 0 134217729 0 0 27447 0 0 8 '&Workspace' 0 134217729 0 0 27449 0 0 4914 0 16 98 20 4962 2097153 4994 11632 8 'Find...' 1 1 11666 0 16 11712 8 'FindClass.ico' 11760 0 0 4914 0 16 98 10 4962 1 4994 11856 8 'Package <1d>' 1 1 11666 0 16 11712 8 'Package.ico' 11760 0 0 5122 4097 4962 2097153 4994 11968 8 '&Class References' 1 1 0 0 0 4914 0 16 98 0 8 'Local Re&ferences To' 12048 134217729 0 0 27457 0 0 5122 4097 4962 1 4994 12112 8 'Changed &Methods' 1 1 0 0 0 4962 1 4994 12176 8 'Method &History' 1 1 0 0 0 5122 4097 4962 1 4994 12256 8 'Published &events' 1 1 0 0 0 4962 1 4994 12320 8 'Published &aspects' 1 1 0 0 0 8 '&Browse' 12368 134217729 0 0 27467 0 0 5122 4097 4962 1 4994 12432 8 '&New...' 1 1 11666 0 16 11712 8 'NewClass.ico' 11760 0 0 4962 1 4994 12528 8 '&Delete' 1 1 11666 0 16 11712 8 'EditClear.ico' 11760 0 0 4914 0 16 98 19 4962 1 4994 12656 8 '&Remove' 1 1 0 0 0 4962 2097153 4994 12720 8 'Re&name...' 1 1 0 0 0 4962 1 4994 8 #copyClass 8 'Cl&one...' 1 1 0 0 0 5122 4097 4962 1 4994 6576 8 'Add <1s>&Instance Variable...' 1 1 0 0 0 4962 1 4994 12848 8 'Add &Class Variable...' 1 1 0 0 0 4914 0 16 98 0 8 'Re&move Variable' 12928 134217729 0 0 27483 0 0 4914 0 16 98 0 8 'Ren&ame Variable' 12992 134217729 0 0 27485 0 0 5122 4097 4914 0 16 98 0 8 'Push &Down' 13072 134217729 0 0 27487 0 0 4914 0 16 98 0 8 'Pull &Up' 13136 134217729 0 0 27489 0 0 5122 4097 4914 0 16 98 0 8 'Cr&eate Accessors' 13216 134217729 0 0 27491 0 0 4914 0 16 98 0 8 'A&bstract' 13280 134217729 0 0 27493 0 0 4914 0 16 98 0 8 '&Protect/Concrete' 13344 134217729 0 0 27495 0 0 5122 4097 4962 1 4994 13408 8 'Con&vert to Sibling...' 1 1 0 0 0 5122 4097 4962 1 4994 13488 8 'Remove Dup&licate Methods' 1 1 0 0 0 8 '&Refactorings' 13536 134217729 11666 0 16 11712 8 'Refactoring.ico' 11760 0 27501 0 0 5122 4097 4962 1 4994 13632 8 'Create &Accessors...' 1 1 0 0 0 4962 1 4994 13696 8 'Refor&mat All' 1 1 0 0 0 5122 4097 4962 1 4994 13776 8 'File &In...' 1 1 0 0 0 4962 1 4994 13840 8 'File &Out...' 1 1 0 0 0 5122 4097 4962 1 4994 13920 8 '&Package...' 1 1 11666 0 16 11712 8 'Package.ico' 11760 0 0 4962 1 4994 14016 8 '&Category...' 1 1 0 0 0 5122 4097 4962 1 4994 14096 8 'Browse &Editions' 1 1 0 0 0 4962 1 4994 14160 8 'Compare with...' 1 1 0 0 0 5122 4097 4914 0 16 98 4 4962 1 4994 14272 8 '&New...' 1 1 0 0 0 5122 4097 4914 0 16 98 0 8 '&Edit' 14368 1 0 0 27521 0 0 4914 0 16 98 0 8 '&Show' 14432 1 0 0 27523 0 0 8 '&Views' 14464 1 11666 0 16 11712 8 'View.ico' 11760 0 27525 0 0 8 '&Class' 0 134217729 0 0 27527 0 0 4914 0 16 98 18 4914 0 16 98 0 8 'De&finitions of' 8 #definitionsMenu 1 0 0 27529 0 0 4914 0 16 98 0 8 '&References to' 8 #referencesMenu 1 0 0 27531 0 0 4914 0 16 98 14 4962 1 4994 8 #browseReferencesToGlobal 8 'References to Global...' 1 1 0 0 0 4962 1 4994 8 #browseContainingText 8 'C&ontaining Text...' 1 1 11666 0 16 11712 8 'SearchText.ico' 11760 0 0 4962 1 4994 9152 8 'Cate&gory...' 1 1 0 0 0 4962 1 4994 8 #browseCompilationFailures 8 'Compilation &Failures' 1 1 0 0 0 4962 1 4994 8 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 0 0 0 5122 4097 4962 1 4994 8 #browseMethodPackages 8 '&Package <s>' 1 1 0 0 0 4962 1 4994 8 #browseMethodClasses 8 '&Class <s>' 1 1 0 0 0 5122 4097 4962 1 4994 8 #browseMethodHistory 8 'Change &History' 1 1 0 0 0 4962 1 4994 8 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 0 0 0 5122 4097 4962 1 4994 8 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 0 0 0 4962 1 4994 8 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 0 0 0 8 '&Browse other' 0 134217729 0 0 27555 0 0 5122 4097 4962 1 4994 8 #newMethod 8 '&New' 1 1 11666 0 16 11712 8 'NewMethod.ico' 11760 0 0 4962 1 4994 8 #removeMethod 8 '&Delete' 1 1 11666 0 16 11712 8 'EditClear.ico' 11760 0 0 4914 0 16 98 17 4962 1 4994 8 #renameMethod 8 'Re&name' 1 1 0 0 0 4962 1 4994 8 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 0 0 0 4962 1 4994 8 #safeRemoveMethods 8 'Rem&ove' 1 1 0 0 0 5122 4097 4962 1 4994 8 #addParameter 8 'Add &Parameter...' 1 1 0 0 0 4914 0 16 98 0 8 'Remo&ve Parameter' 8 #removeParameterMenu 134217729 0 0 27569 0 0 4914 0 16 98 0 8 'Rena&me Parameter' 8 #renameParameterMenu 134217729 0 0 27571 0 0 4914 0 16 98 0 8 '&Inline Parameter' 8 #inlineParameterMenu 134217729 0 0 27573 0 0 5122 4097 4914 0 16 98 0 8 'Rename &Temporary' 8 #renameTempMenu 134217729 0 0 27575 0 0 4914 0 16 98 0 8 'Convert Temp to Inst. Var.' 8 #convertTempToInstVarMenu 134217729 0 0 27577 0 0 5122 4097 4962 1 4994 8 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 0 0 0 4962 1 4994 8 #pushUpMethods 8 'Push &Up' 9325 1 0 0 0 4962 1 4994 8 #pushDownMethods 8 'Push &Down' 9327 1 0 0 0 4962 1 4994 8 #overrideMethods 8 'Ove&rride <1d>' 1 1 0 0 0 4962 1 4994 8 #moveMethod 8 'Move to &Component...' 1 1 0 0 0 8 'Refactorin&gs' 8 #methodRefactoringsMenu 134217729 11666 0 16 11712 8 'Refactoring.ico' 11760 0 27589 0 0 5122 4097 4962 1 4994 8 #methodPackage 8 '&Package...' 1 1 11666 0 16 11712 8 'Package.ico' 11760 0 0 4914 0 16 98 0 8 'Add to &Category' 8 #addCategoryMenu 134217729 0 0 27593 0 0 4914 0 16 98 0 8 'Re&move from Category' 8 #removeCategoryMenu 134217729 0 0 27595 0 0 4962 1 4994 8 #togglePrivate 8 'Pri&vate' 1 1 0 0 0 5122 4097 4962 1 4994 8 #browseMethodEditions 8 'Browse &Editions' 1 1 0 0 0 4962 1 4994 8 #browseAvailableMethods 8 'Browse Available Editions' 1 1 0 0 0 5122 4097 4962 1 4994 8 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 0 0 0 4962 1 4994 8 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 0 0 0 8 '&Method' 0 134217729 0 0 27607 0 0 4914 0 16 98 7 4962 1 4994 8 #undoChange 8 '&Undo <1d>' 1 1 11666 0 16 11712 8 'EditUndo.ico' 11760 0 0 4962 1 4994 8 #redoChange 8 '&Redo <1d>' 1 1 11666 0 16 11712 8 'EditRedo.ico' 11760 0 0 4962 1 4994 8 #clearChangeHistory 8 'Clear Change &History' 1 1 0 0 0 5122 4097 4962 1 4994 8 #historyBack 8 'Back to <1d>' 1 1 11666 0 16 11712 8 'HistoryBack.ico' 11760 0 0 4962 1 4994 8 #historyForward 8 'Forward to <1d>' 1 1 11666 0 16 11712 8 'HistoryForward.ico' 11760 0 0 4962 1 4994 8 #historyClear 8 'Clear Visit History' 1 1 0 0 0 8 'H&istory' 0 134217729 0 0 27621 0 0 4914 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 27623 0 0 4914 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 27625 0 0 4914 0 16 98 16 4962 1 4994 8 #helpContents 8 '&Contents' 1025 1 11666 0 16 11712 49 21424 0 0 4962 1 4994 8 #help 8 'On this &Tool' 1249 1 0 0 0 4962 1 4994 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 5122 4097 4962 1 4994 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 5122 4097 4962 1 4994 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 4962 1 4994 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 4962 1 4994 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 4914 0 16 98 4 4962 2097153 4994 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 11666 0 16 11712 8 'TipOfTheDay.ico' 11760 0 0 4962 1 4994 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 11666 0 16 11712 8 'TipOfTheDay.ico' 11760 0 0 5122 4097 4962 1 4994 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 27647 0 0 5122 4097 4962 1 4994 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 4962 1 4994 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 4962 1 4994 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 5122 4097 4962 1 4994 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 11666 0 16 11712 8 '!!APPLICATION' 11760 0 0 8 '&Help' 0 134217729 0 0 27657 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 994 202 208 98 3 1058 1088 98 2 770 4999 21 770 1491 801 416 1058 6192 98 1 8 'System Browser' 416 1058 8 #updateMenuBar 1200 416 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 9 0 0 10 0 0 0 172 12 0 0 154 1 0 0] 98 3 560 3136 2112 1216 0 27)!

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
!SystemBrowserShell class categoriesFor: #plugins!accessing!wine fix!public! !
!SystemBrowserShell class categoriesFor: #publishedAspects!development!public! !
!SystemBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !
!SystemBrowserShell class categoriesFor: #toolsFolderHelpId!constants!public! !
!SystemBrowserShell class categoriesFor: #uninitialize!class hierarchy-removing!private! !

