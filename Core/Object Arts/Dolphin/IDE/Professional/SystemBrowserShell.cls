"Filed out from Dolphin Smalltalk"!

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

!SystemBrowserShell categoriesForClass!MVP-Presenters! !

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

!SystemBrowserShell categoriesForMethods!
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 565 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 327686 ##(Smalltalk.Color) #default 8 1814090816 170 192 34 8 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Image_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 882 63 51 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 882 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 738 ##(Smalltalk.Toolbar) #resource_Class_browser_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1051 1 882 307 51 1024 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 166 2 0 0 25 0 0 0] 976 992 nil 27 8 'classBrowserTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 738 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 63 1 882 553 51 1264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 976 992 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1504 nil nil nil 7 nil nil nil 1504 738 ##(Smalltalk.Toolbar) #resource_Search_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 615 1 882 437 51 1504 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 976 992 nil 27 8 'searchTools' 170 192 976 138 144 976 nil nil 1 nil 882 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1459 51 528 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 25 0 0 0] 34 4 672 1264 1504 1024 992 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140852996 1 1984 nil nil nil 7 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 882 193 193 nil 1984 nil 8 1813784320 170 192 34 8 853766 ##(Smalltalk.StatusBarItem) 1 -1 1984 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 2192 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] #iconImageIndex 2288 7 257 nil nil 8 'version' 2194 1 45 1984 nil nil 2274 0 nil 1180966 ##(Smalltalk.CompiledExpression) 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association) #Smalltalk ##(Smalltalk) #developmentSystem #changedIcon #imageIndex 2384 7 257 nil nil 8 'modified' 2194 1 401 1984 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'packageOfSelection' 2194 1 841 1984 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'message' 34 4 2528 2368 2560 2208 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 1984 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 643 882 1459 41 1984 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 217 2 0 0 85 1 0 0] 8 #() 992 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2800 nil nil nil 7 nil nil nil 2800 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 1 2482 410 ##(Smalltalk.Splitter) 34 12 nil 2800 34 2 8 1140850688 1 2944 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2944 nil 1 #left nil nil nil 882 1 1 882 9 9 nil 3040 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 291 882 1459 11 2944 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 0 0 0 217 2 0 0 150 0 0 0] 8 #() 992 nil 27 1 true 170 192 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 2800 34 2 8 1140850688 131073 3264 nil nil nil 7 nil nil nil 3264 2866 138 ##(Smalltalk.Dictionary) 34 2 2482 410 ##(Smalltalk.Splitter) 34 12 nil 3264 34 2 8 1140850688 1 3392 nil nil nil 519 nil nil nil 3010 3392 nil 1 #left nil nil nil 3040 3056 nil 3040 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1089 1 882 11 291 3392 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 2 0 0 0 0 0 0 37 2 0 0 145 0 0 0] 8 #() 992 nil 27 1 2482 410 ##(Smalltalk.Splitter) 34 12 nil 3264 34 2 8 1140850688 1 3648 nil nil nil 519 nil nil nil 3010 3648 nil 1 #left nil nil nil 3040 3056 nil 3040 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 723 1 882 11 291 3648 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 1 0 0 0 0 0 0 110 1 0 0 145 0 0 0] 8 #() 992 nil 27 1 false 170 192 34 6 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 3264 34 2 8 1140850688 131073 3920 nil nil nil 519 nil nil nil 3920 656710 1 ##(Smalltalk.CardLayout) 138 144 34 3 2482 590662 1 ##(Smalltalk.CardLabel) 8 'Categories' 2274 0 nil 2402 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[MethodCategory icon]' 8 #[31 105 45 159 106] 983558 ##(Smalltalk.VariableBinding) #MethodCategory ##(Smalltalk.MethodCategory) #icon 4112 7 1 nil 21481 410 ##(Smalltalk.TreeView) 34 27 nil 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 3920 34 2 8 1140850688 131073 4256 nil nil nil 7 nil nil nil 4256 4000 170 192 34 6 410 ##(Smalltalk.ListView) 34 45 nil 4256 34 2 8 1140936777 1 4352 590662 2 ##(Smalltalk.ListModel) 138 144 976 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 608 nil 29 265030 4 ##(Smalltalk.Menu) nil true 34 7 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #browseSelectorsInProtocol 8 '&Selectors' 1 1 nil nil nil 4546 1 4578 #toggleProtocolReadOnly 8 '&Read Only' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4546 1 4578 #addMethodProtocol 8 '&Add...' 1 1 nil nil nil 4498 nil true 34 2 4546 1 4578 #removeMethodProtocol 8 'Protocol' 1 1 nil nil nil 4546 1 4578 #removeMethodsInProtocol 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 4546 1 4578 #renameMethodProtocol 8 'Rename...' 1 1 nil nil nil 4546 1 4578 #browseMethodProtocol 8 'Browse' 1 1 nil nil nil 8 'Protocols' nil 134217729 nil nil nil nil nil nil nil 4352 nil 8 1814046992 2226 #name 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil 2274 0 nil 2402 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 5088 7 257 nil 882 65 65 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Protocols' 189 #left 2226 #name 8 #() 2226 #<= 8 #() nil nil 4352 nil 3 nil 2274 0 nil 2402 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 5328 7 257 nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 1 37 882 197 239 4352 834 #contextMenu: 34 1 4512 4352 834 #text: 34 1 8 'Protocols' 4352 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 992 nil 35 8 'protocols' 4224 8 'categories' 410 ##(Smalltalk.ListView) 34 45 nil 4256 34 2 8 1140920395 1 5696 4418 138 144 976 nil 4480 608 nil 13 4498 nil true 34 10 4546 2097153 4578 #browseInstVarReferences 8 'Browse &References' 1 1 nil nil nil 4674 4097 4546 1 4578 #addInstanceVariable 8 '&Add...' 1 1 nil nil nil 4546 1 4578 #removeInstanceVariables 8 'Remo&ve' 1 1 nil nil nil 4546 1 4578 #renameInstanceVariable 8 'Re&name' 1 1 nil nil nil 4674 4097 4546 1 4578 #pushDownInstanceVariables 8 'Push &Down' 1 1 nil nil nil 4546 1 4578 #createAccessors 8 '&Create Accessors' 1 1 nil nil nil 4546 1 4578 #abstractInstanceVariables 8 'Ab&stract' 1 1 nil nil nil 4546 1 4578 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 5696 nil 8 1814046992 2226 #value 8 #() 2274 0 nil 2402 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] #key #icon #imageIndex 6288 7 257 nil 5072 nil 2274 0 nil 2402 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] #key #name 8 '.' #, 6368 7 257 nil nil 882 65 65 nil nil 138 144 34 1 5218 8 '' 201 #left ##(Smalltalk.BasicListAbstract) 2226 #<= 8 #() nil nil 5696 nil 1 nil nil #list 5408 nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 1 37 882 197 239 5696 834 #contextMenu: 34 1 5792 5696 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 992 nil 35 8 'variables' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 3920 34 2 8 1140916864 1 6784 4418 138 144 34 3 4080 4066 8 'Protocols' 2274 0 nil 2402 6 1 16 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 4194 #CardLabel 4064 6912 4194 #MethodProtocol ##(Smalltalk.MethodProtocol) #icon #text:iconBlock: 6928 11 1 nil 21487 4066 8 'Variables' nil 21491 nil 4480 nil nil 1 nil nil nil 6784 nil 8 1813643504 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 5072 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 1 1 882 357 291 6784 834 #setSingleSelection: 8 #(1) 6784 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 6784 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 8 #() 992 nil 27 nil 3920 882 33 33 1050182 1 ##(Smalltalk.ButtonInteractor) 4256 nil 1 590342 ##(Smalltalk.Rectangle) 882 161 3 882 193 35 nil 4578 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 153 9 882 197 275 4256 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 34 3 4224 4352 5696 992 nil 27 34 2 8 1140916771 1 4224 590918 3 ##(Smalltalk.TreeModel) nil 4480 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 976 608 nil 31 4498 nil true 34 4 4546 1 4578 #addMethodCategory 8 '&Add...' 1 1 nil nil nil 4498 nil true 34 2 4546 1 4578 #removeMethodCategory 8 'Category' 1 1 nil nil nil 4546 1 4578 #removeMethodsInCategory 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 4546 1 4578 #renameMethodCategory 8 'Rename...' 1 1 nil nil nil 4546 1 4578 #browseMethodCategory 8 'Browse' 1 1 nil nil nil 8 'Categories' nil 134217729 nil nil nil nil nil nil nil 4224 nil 8 1813745136 2226 #localName 8 #() ##(Smalltalk.IconicListAbstract) 5072 nil nil 2274 0 nil 2402 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawCategoryTree: 8112 7 257 nil nil nil 170 176 976 nil #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 976 770 138 144 34 2 834 #createAt:extent: 34 2 882 1 37 882 197 239 4224 834 #contextMenu: 34 1 7728 4224 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 992 nil 27 2482 6896 4352 2482 7040 5696 4224 nil nil nil 170 192 34 2 4256 8 'filters' nil 6784 4256 882 201 201 401 1 524319 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 733 1 882 357 291 3920 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 1 0 0 0 0 0 0 32 2 0 0 145 0 0 0] 34 2 4256 6784 992 nil 27 8 'filtersSlidey' 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 3264 34 2 8 1140850688 131073 8688 nil nil nil 519 nil nil nil 8688 3986 138 144 34 1 2482 4066 8 'Packages' 834 #icon 8 #() ##(Smalltalk.Package) 21511 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 8688 34 2 8 1140850688 131073 8880 nil nil nil 7 nil nil nil 8880 3986 138 144 34 1 2482 4066 8 'Packages' 834 #icon 8 #() ##(Smalltalk.Package) 21511 410 ##(Smalltalk.ReferenceView) 34 14 nil 8880 34 2 8 1140850688 131073 9072 nil nil nil 7 nil nil nil 9072 738 ##(Smalltalk.PackageSelector) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 37 882 293 239 9072 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 146 0 0 0 137 0 0 0] 976 992 nil 27 9072 nil nil nil 170 192 34 2 9072 8 'packages' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 8688 34 2 8 1140916864 1 9344 4418 138 144 34 1 9008 nil 4480 nil nil 1 nil nil nil 9344 nil 8 1813643504 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 5072 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 1 1 882 357 291 9344 834 #setSingleSelection: 8 #(1) 9344 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 9344 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 8 #() 992 nil 27 nil 8688 882 33 33 7330 8880 nil 1 7362 882 257 3 882 289 35 nil 4578 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 57 9 882 293 275 8880 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 34 1 9072 992 nil 27 nil nil nil nil 170 192 976 nil 9344 8880 882 201 201 401 1 524319 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 357 291 8688 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 34 2 8880 9344 992 nil 27 8 'packagesSlidey' 410 ##(Smalltalk.ReferenceView) 34 14 nil 3264 34 2 8 1140916224 131073 10176 nil nil nil 7 4498 nil true 34 17 4546 1 4578 #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 4498 nil true 34 10 4546 1 4578 #browseClassPackage 8 'Package <1d>' 1 1 10322 nil true 10368 8 'Package.ico' 10416 nil nil 4674 4097 4546 2097153 4578 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 4498 nil true 8 #() 8 'Local Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 4674 4097 4546 1 4578 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 4546 1 4578 #browseMethodHistoryForClass 8 'Method &History' 1 1 10322 nil true 10368 8 'MethodHistory.ico' 10416 nil nil 4674 4097 4546 1 4578 #browsePublishedEvents 8 'Published &events' 1 1 10322 nil true 10368 8 'Event.ico' 10416 nil nil 4546 1 4578 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 4674 4097 4546 1 4578 #newClass 8 '&New...' 1 1 10322 nil true 10368 8 'NewClass.ico' 10416 nil nil 4546 1 4578 #deleteClassHierarchy 8 '&Delete' 1 1 10322 nil true 10368 8 'EditClear.ico' 10416 nil nil 4498 nil true 34 18 4546 1 4578 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 4546 2097153 4578 #renameClass 8 'Re&name...' 1 1 10322 nil true 10368 8 'Rename.ico' 10416 nil nil 4674 4097 4546 1 4578 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 4546 1 4578 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 4498 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 4498 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 4674 4097 4498 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 4498 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 4674 4097 4498 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 4498 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 4498 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 4674 4097 4546 1 4578 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 4674 4097 4546 1 4578 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 10322 nil true 10368 8 'Refactoring.ico' 10416 nil nil nil nil 4674 4097 4546 1 4578 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 4546 1 4578 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 4674 4097 4546 1 4578 #fileInClass 8 'File &In...' 1 1 10322 nil true 10368 8 'FileIn.ico' 10416 nil nil 4546 1 4578 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 4674 4097 4546 1 4578 #classPackage 8 '&Package...' 1 1 10322 nil true 10368 8 'Package.ico' 10416 nil nil 4546 1 4578 #categorizeClass 8 '&Category...' 1 1 10322 nil true 10368 8 'Category.ico' 10416 nil nil 4674 4097 4498 nil true 34 4 4546 1 4578 #newView 8 '&New...' 1 1 nil nil nil 4674 4097 4498 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 10322 nil true 10368 8 'ViewComposer.ico' 10416 nil nil nil nil 4498 nil true 8 #() 8 '&Show' #viewsShowMenu 1 10322 nil true 10368 8 'TestView.ico' 10416 nil nil nil nil 8 '&Views' #viewsMenu 134217729 10322 nil true 10368 8 'View.ico' 10416 nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 10176 738 ##(Smalltalk.ClassListSelector) #resource_Default_view nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 367 1 882 357 291 10176 834 #contextMenu: 34 1 10240 10176 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 183 0 0 0 0 0 0 0 105 1 0 0 145 0 0 0] 976 992 nil 27 8 'classes' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1459 291 3264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 34 7 8688 410 ##(Smalltalk.Splitter) 34 12 nil 3264 34 2 8 1140850688 1 13104 nil nil nil 519 nil nil nil 3010 13104 nil 1 #left nil nil nil 3040 3056 nil 3040 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 357 1 882 11 291 13104 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 0 0 0 0 183 0 0 0 145 0 0 0] 8 #() 992 nil 27 10176 3648 3920 3392 410 ##(Smalltalk.ContainerView) 34 15 nil 3264 34 2 8 1140850688 131073 13344 nil nil nil 7 nil nil nil 13344 498 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 13344 34 2 8 1140850688 131073 13424 nil nil nil 535 nil nil nil 13424 1794 11 1 1 170 192 34 4 410 ##(Smalltalk.RadioButton) 34 16 nil 13424 34 2 8 1141055497 1 13536 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 2226 #= 8 #() 2226 #hash 8 #() false nil nil 519 nil nil nil 13536 nil 8 1813986672 852486 ##(Smalltalk.NullConverter) nil nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 161 7 882 97 39 13536 834 #text: 34 1 8 'C&lass' 13536 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 3 0 0 0 128 0 0 0 22 0 0 0] 8 #() 992 nil 27 8 'classMode' 410 ##(Smalltalk.RadioButton) 34 16 nil 13424 34 2 8 1141055497 1 14000 13602 nil nil 13634 2226 #= 8 #() 2226 #hash 8 #() false nil nil 519 nil nil nil 14000 nil 8 1813986672 13746 nil nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 21 7 882 131 39 14000 834 #text: 34 1 8 'In&stance' 14000 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 3 0 0 0 75 0 0 0 22 0 0 0] 8 #() 992 nil 27 8 'instanceMode' 7362 882 21 7 882 1 7 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 241 882 361 51 13424 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 120 0 0 0 180 0 0 0 145 0 0 0] 34 2 14000 13536 992 nil 27 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 13344 34 2 8 1140916224 131073 14624 nil nil nil 31 nil nil nil 14624 738 ##(Smalltalk.MethodBrowser) #resource_Class_browser_method_list nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 361 241 14624 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 180 0 0 0 120 0 0 0] 976 992 nil 27 170 192 34 4 14624 8 'methods' 13424 8 'mode' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1099 1 882 361 291 13344 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 37 2 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 34 2 14624 13424 992 nil 27 992 nil 27 8 'classes' 410 ##(Smalltalk.CardContainer) 34 16 nil 2800 34 2 8 1140850688 131073 15088 nil nil nil 23 4498 nil true 34 2 4498 nil true 34 4 4546 1025 4578 2226 #tabOrientation: 8 #(#top) 8 '&Top' 1 1 nil nil nil 4546 1025 4578 2226 #tabOrientation: 8 #(#bottom) 8 '&Bottom' 1 1 nil nil nil 4546 1025 4578 2226 #tabOrientation: 8 #(#left) 8 '&Left' 1 1 nil nil nil 4546 1025 4578 2226 #tabOrientation: 8 #(#right) 8 '&Right' 1 1 nil nil nil 8 '&Orientation' nil 134217729 nil nil nil nil nil 4498 nil true 34 6 4546 1025 4578 2226 #viewMode: 8 #(#noIcons) 8 '&No Icons' 1 1 nil nil nil 4546 1025 4578 2226 #viewMode: 8 #(#smallIcons) 8 '&Small Icons' 1 1 nil nil nil 4546 1025 4578 2226 #viewMode: 8 #(#mediumIcons) 8 '&Medium Icons' 1 1 nil nil nil 4546 1025 4578 2226 #viewMode: 8 #(#largeIcons) 8 '&Large Icons' 1 1 nil nil nil 4546 1025 4578 2226 #viewMode: 8 #(#tileIcons) 8 '&Tile Icons' 1 1 nil nil nil 4546 1 4578 2226 #viewMode: 8 #(#thumbnails) 8 'Thum&bnails' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 15088 3986 138 144 34 2 2482 4066 8 'Method source' 2274 0 nil 2402 7 1 4064 8 'doIt' 8 '(CardLabel text: ''Method source'' iconBlock: [Icon fromId: ''MethodSource.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 4194 #CardLabel 4064 16176 4194 #Icon 10320 8 'MethodSource.ico' #fromId: #text:iconBlock: 16192 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 15088 34 2 8 1140850688 131073 16320 nil nil nil 7 nil nil nil 16320 738 ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 9 53 882 1443 233 16320 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 213 2 0 0 142 0 0 0] 976 992 nil 27 2482 4066 8 'Class definition' 2274 0 nil 2402 7 1 4064 8 'doIt' 8 '(CardLabel text: ''Class definition'' iconBlock: [Icon fromId: ''ClassDefinition.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 16272 16576 16288 8 'ClassDefinition.ico' #fromId: #text:iconBlock: 16592 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 15088 34 2 8 1140916224 131073 16688 nil 608 nil 21 nil nil nil 16688 738 ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 9 53 882 1443 233 16688 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 213 2 0 0 142 0 0 0] 976 992 nil 27 16320 nil nil nil 170 192 34 4 16320 8 'source' 16688 8 'definition' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 15088 34 2 8 1140916736 1 16976 4418 138 144 34 2 16160 16560 nil 4480 nil nil 17 nil nil nil 16976 nil 8 1813643504 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 5072 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 1 1 882 1459 293 16976 834 #setSingleSelection: 8 #(1) 16976 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 16976 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 146 0 0 0] 8 #() 992 nil 27 770 138 144 34 2 834 #createAt:extent: 34 2 882 1 301 882 1459 293 15088 834 #contextMenu: 34 1 15152 15088 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 150 0 0 0 217 2 0 0 40 1 0 0] 34 3 16320 16688 16976 992 nil 27 8 'cards' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 51 882 1459 593 2800 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 217 2 0 0 65 1 0 0] 34 3 3264 2944 15088 992 nil 27 170 192 34 4 528 8 'toolbar' 1984 8 'statusbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 9 4498 nil true 34 8 4546 1 4578 #fileNew 8 '&New' 9373 1 10322 nil true 10368 8 'NewWorkspace.ico' 10416 nil nil 4546 1 4578 #fileOpen 8 '&Open...' 9375 1 10322 nil true 10368 8 'OpenWorkspace.ico' 10416 nil nil 4546 1 4578 #fileFileIn 8 '&File In...' 1 1 10322 nil true 10368 8 'FileIn.ico' 10416 nil nil 4674 4097 4546 1 4578 #saveImage 8 'Sa&ve Image' 1 1 10322 nil true 10368 8 'Snapshot.ico' 10416 nil nil 4546 1 4578 #smalltalkExit 8 'E&xit Dolphin' 1 1 10322 nil true 10368 8 'PowerSwitch.ico' 10416 nil nil 4674 4097 4546 1 4578 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 19515 nil nil 4498 nil true 34 13 4546 1 4578 #undo 8 '&Undo' 9397 1 10322 nil true 10368 8 'EditUndo.ico' 10416 nil nil 4674 4097 4546 1 4578 #cutSelection 8 'Cu&t' 9393 1 10322 nil true 10368 8 'EditCut.ico' 10416 nil nil 4546 1 4578 #copySelection 8 '&Copy' 9351 1 10322 nil true 10368 8 'EditCopy.ico' 10416 nil nil 4546 1 4578 #pasteClipboard 8 '&Paste' 9389 1 10322 nil true 10368 8 'EditPaste.ico' 10416 nil nil 4546 1 4578 #editDelete 8 '&Delete' 1 1 10322 nil true 10368 8 'EditClear.ico' 10416 nil nil 4498 nil true 34 2 4546 1 4578 #reformatSource 8 '&Source' 9391 1 nil nil nil 4546 1 4578 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 19531 nil nil 4674 4097 4546 1 4578 #selectAll 8 'Select &All' 9347 1 nil nil nil 4674 4097 4546 1 4578 #editFind 8 '&Find...' 9357 1 10322 nil true 10368 47 786694 ##(Smalltalk.ShellLibrary) nil nil 4546 1 4578 #findNext 8 'Find &Next' 1253 1 10322 nil true 10368 8 'FindNext.ico' 10416 nil nil 4546 1 4578 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 19541 nil nil 4498 nil true 34 17 4546 1 4578 #browseIt 8 '&Browse It' 9349 1 10322 nil true 10368 8 'ClassBrowserShell.ico' 10416 nil nil 4546 1 4578 #displayIt 8 '&Display It' 9353 1 10322 nil true 10368 8 'DisplayIt.ico' 10416 nil nil 4546 1 4578 #printIt 8 '&Print It' 9377 1 10322 nil true 10368 8 'PrintIt.ico' 10416 nil nil 4546 1 4578 #evaluateIt 8 '&Evaluate It' 9355 1 10322 nil true 10368 8 'EvaluateIt.ico' 10416 nil nil 4546 1 4578 #inspectIt 8 '&Inspect It' 9363 1 10322 nil true 10368 8 'InspectIt.ico' 10416 nil nil 4546 1 4578 #debugIt 8 'Deb&ug It' 1269 1 10322 nil true 10368 8 'Debugger.ico' 10416 nil nil 4546 1 4578 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 4674 4097 4546 1 4578 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 4546 1 4578 #browseReferences 8 '&References' 5367 1 nil nil nil 4674 4097 4546 2097153 4578 #accept 8 '&Accept' 9383 1 nil nil nil 4546 1 4578 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 4674 4097 4498 nil true 34 14 4546 1 4578 #renameVariable 8 'Re&name <1d>...' 1 1 nil nil nil 4674 4097 4546 1 4578 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 nil nil nil 4546 1 4578 #extractMethod 8 'E&xtract Method...' 9371 1 nil nil nil 4546 1 4578 #extractToComponent 8 'Extract to &Component...' 1 1 nil nil nil 4546 1 4578 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 4674 4097 4546 1 4578 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 4546 1 4578 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 4546 1 4578 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 4674 4097 4546 1 4578 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 nil nil nil 4546 1 4578 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 4546 1 4578 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 10322 nil true 10368 8 'Refactoring.ico' 10416 nil 19587 nil nil 4674 4097 4498 nil true 34 7 4546 1 4578 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4546 1 4578 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4546 1 4578 #toggleLineEndings 8 'Line &Endings' 1 1 18322 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 4546 1 4578 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4546 1 4578 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4546 1 4578 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4546 1 4578 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 10322 nil true 10368 8 'Preferences.ico' 10416 nil 19603 nil nil 8 '&Workspace' nil 134217729 nil nil 19605 nil nil 4498 nil true 34 17 4546 2097153 4578 #findClass 8 'Find...' 1 1 10322 nil true 10368 8 'FindClass.ico' 10416 nil nil 4498 nil true 34 10 4546 1 4578 #browseClassPackage 8 'Package <1d>' 1 1 10322 nil true 10368 8 'Package.ico' 10416 nil nil 4674 4097 4546 2097153 4578 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 4498 nil true 8 #() 8 'Local Re&ferences To' #browseVariablesMenu 134217729 nil nil 19613 nil nil 4674 4097 4546 1 4578 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 4546 1 4578 #browseMethodHistoryForClass 8 'Method &History' 1 1 10322 nil true 10368 8 'MethodHistory.ico' 10416 nil nil 4674 4097 4546 1 4578 #browsePublishedEvents 8 'Published &events' 1 1 10322 nil true 10368 8 'Event.ico' 10416 nil nil 4546 1 4578 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil 19623 nil nil 4674 4097 4546 1 4578 #newClass 8 '&New...' 1 1 10322 nil true 10368 8 'NewClass.ico' 10416 nil nil 4546 1 4578 #deleteClassHierarchy 8 '&Delete' 1 1 10322 nil true 10368 8 'EditClear.ico' 10416 nil nil 4498 nil true 34 19 4546 1 4578 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 4546 2097153 4578 #renameClass 8 'Re&name...' 1 1 10322 nil true 10368 8 'Rename.ico' 10416 nil nil 4546 1 4578 #copyClass 8 'Cl&one...' 1 1 nil nil nil 4674 4097 4546 1 4578 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 4546 1 4578 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 4498 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil 19639 nil nil 4498 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil 19641 nil nil 4674 4097 4498 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil 19643 nil nil 4498 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil 19645 nil nil 4674 4097 4498 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil 19647 nil nil 4498 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil 19649 nil nil 4498 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil 19651 nil nil 4674 4097 4546 1 4578 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 4674 4097 4546 1 4578 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 10322 nil true 10368 8 'Refactoring.ico' 10416 nil 19657 nil nil 4674 4097 4546 1 4578 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 4546 1 4578 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 4674 4097 4546 1 4578 #fileInClass 8 'File &In...' 1 1 10322 nil true 10368 8 'FileIn.ico' 10416 nil nil 4546 1 4578 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 4674 4097 4546 1 4578 #classPackage 8 '&Package...' 1 1 10322 nil true 10368 8 'Package.ico' 10416 nil nil 4546 1 4578 #categorizeClass 8 '&Category...' 1 1 10322 nil true 10368 8 'Category.ico' 10416 nil nil 4674 4097 4498 nil true 34 4 4546 1 4578 #newView 8 '&New...' 1 1 nil nil nil 4674 4097 4498 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 10322 nil true 10368 8 'ViewComposer.ico' 10416 nil 19673 nil nil 4498 nil true 8 #() 8 '&Show' #viewsShowMenu 1 10322 nil true 10368 8 'TestView.ico' 10416 nil 19675 nil nil 8 '&Views' #viewsMenu 134217729 10322 nil true 10368 8 'View.ico' 10416 nil 19677 nil nil 8 '&Class' nil 134217729 nil nil 19679 nil nil 4498 nil true 34 15 4498 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 19681 nil nil 4498 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 19683 nil nil 4498 nil true 34 14 4546 1 4578 #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 4546 1 4578 #browseContainingText 8 'C&ontaining Text...' 1 1 10322 nil true 10368 8 'SearchText.ico' 10416 nil nil 4546 1 4578 #browseMethodCategory 8 'Cate&gory...' 1 1 10322 nil true 10368 8 'Category.ico' 10416 nil nil 4546 1 4578 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 4546 1 4578 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 4674 4097 4546 1 4578 #browseMethodPackages 8 '&Package <s>' 1 1 10322 nil true 10368 8 'Package.ico' 10416 nil nil 4546 1 4578 #browseMethodClasses 8 '&Class <s>' 1 1 nil nil nil 4674 4097 4546 1 4578 #browseMethodHistory 8 'Change &History' 1 1 10322 nil true 10368 8 'MethodHistory.ico' 10416 nil nil 4546 1 4578 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 4674 4097 4546 1 4578 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 4546 1 4578 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 19707 nil nil 4674 4097 4546 1 4578 #newMethod 8 '&New' 1 1 10322 nil true 10368 8 'NewMethod.ico' 10416 nil nil 4546 1 4578 #removeMethod 8 '&Delete' 1 1 10322 nil true 10368 8 'EditClear.ico' 10416 nil nil 4498 nil true 34 17 4546 1 4578 #renameMethod 8 'Re&name' 1 1 10322 nil true 10368 8 'Rename.ico' 10416 nil nil 4546 1 4578 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 4546 1 4578 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 4674 4097 4546 1 4578 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 4498 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 19721 nil nil 4498 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 19723 nil nil 4498 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 19725 nil nil 4674 4097 4498 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 19727 nil nil 4498 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 19729 nil nil 4674 4097 4546 1 4578 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 4546 1 4578 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 4546 1 4578 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 4546 1 4578 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 4546 1 4578 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 10322 nil true 10368 8 'Refactoring.ico' 10416 nil 19741 nil nil 4674 4097 4546 1 4578 #methodPackage 8 '&Package...' 1 1 10322 nil true 10368 8 'Package.ico' 10416 nil nil 4498 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 19745 nil nil 4498 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 19747 nil nil 4546 1 4578 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 4674 4097 4546 1 4578 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 4546 1 4578 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 19755 nil nil 4498 nil true 34 7 4546 1 4578 #undoChange 8 '&Undo <1d>' 1 1 10322 nil true 10368 8 'EditUndo.ico' 10416 nil nil 4546 1 4578 #redoChange 8 '&Redo <1d>' 1 1 10322 nil true 10368 8 'EditRedo.ico' 10416 nil nil 4546 1 4578 #clearChangeHistory 8 'Clear Change &History' 1 1 10322 nil true 10368 8 'MethodHistoryErase.ico' 10416 nil nil 4674 4097 4546 1 4578 #historyBack 8 'Back to <1d>' 1 1 10322 nil true 10368 8 'HistoryBack.ico' 10416 nil nil 4546 1 4578 #historyForward 8 'Forward to <1d>' 1 1 10322 nil true 10368 8 'HistoryForward.ico' 10416 nil nil 4546 1 4578 #historyClear 8 'Clear Visit History' 1 1 10322 nil true 10368 8 'HistoryErase.ico' 10416 nil nil 8 'H&istory' nil 134217729 nil nil 19769 nil nil 4498 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 19771 nil nil 4498 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 19773 nil nil 4498 nil true 34 15 4546 1 4578 #helpContents 8 '&Contents' 1025 1 10322 nil true 10368 8 'Help.ico' 10416 nil nil 4546 1 4578 #help 8 'On this &Tool' 1249 1 nil nil nil 4546 1 4578 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4674 4097 4546 1 4578 #learnSmalltalk 8 'Learn Smalltalk' 1 1 18322 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 4674 4097 4546 1 4578 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4546 1 4578 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4546 1 4578 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4674 4097 4546 1 4578 #dolphinHomePage 8 'Dolphin Homepage' 1 1 10322 nil true 10368 8 '!!APPLICATION' 10416 nil nil 4546 1 4578 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4546 1 4578 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4674 4097 4546 1 4578 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 18322 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 19797 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 6143 21 882 1491 801 416 834 #text: 34 1 8 'System Browser' 416 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 232 14 0 0 154 1 0 0] 34 3 528 2800 1984 992 nil 27)!

toolsFolderHelpId
	^10595!

uninitialize
	"Private - Uninitialize the receiver prior to remove from the system.
		self uninitialize
	"

	| devsys |
	devsys := Smalltalk developmentSystem.
	devsys systemBrowserClass == self ifTrue: [devsys systemBrowserClass: nil]! !

!SystemBrowserShell class categoriesForMethods!
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

