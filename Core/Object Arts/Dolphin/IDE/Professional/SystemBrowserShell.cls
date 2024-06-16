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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 533 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 517 nil nil nil 528 327686 ##(Smalltalk.Color) #default 8 1759112192 170 192 34 8 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 5 nil nil nil 672 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Class_browser_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[13 2 0 0 0 0 0 0 166 2 0 0 25 0 0 0] 193 704 8 '' 672 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'classBrowserTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1040 nil nil nil 5 nil nil nil 1040 738 ##(Smalltalk.Toolbar) #resource_Image_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 1072 8 '' 1040 3 976 994 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1296 nil nil nil 5 nil nil nil 1296 738 ##(Smalltalk.Toolbar) #resource_Search_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 193 1328 8 '' 1296 3 976 994 193 193 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1552 nil nil nil 5 nil nil nil 1552 738 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 1584 8 '' 1552 3 976 994 193 193 nil 27 8 'smalltalkTools' nil nil nil 170 192 976 138 144 976 nil nil 9 nil #smallIcons nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 217 2 0 0 25 0 0 0] 193 560 8 '' 528 3 34 4 1040 1552 1296 672 994 193 193 nil 31 410 ##(Smalltalk.StatusBar) 34 21 nil 416 34 2 8 1140852996 1 2048 nil nil nil 5 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 77 0 105 0 99 0 114 0 111 0 115 0 111 0 102 0 116 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2048 nil 8 1758805184 170 192 34 8 853830 1 ##(Smalltalk.StatusBarItem) 8193 45 2048 nil nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association) #Smalltalk ##(Smalltalk) #developmentSystem #changedIcon #imageIndex 2288 7 257 nil nil 8 'modified' 2242 8193 401 2048 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'packageOfSelection' 2242 8193 -1 2048 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 2274 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 2240 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] #iconImageIndex 2528 7 257 nil nil 8 'version' 2242 8193 841 2048 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'message' nil nil nil 34 4 2432 2256 2608 2464 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 2048 nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 65 1 0 0 217 2 0 0 85 1 0 0] 193 2080 8 '' 2048 3 8 #() 994 193 193 nil 29 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2864 nil nil nil 5 nil nil nil 2864 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 1 2386 410 ##(Smalltalk.Splitter) 34 12 nil 2864 34 2 8 1140850688 1 3008 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3008 nil 1 #left nil nil nil 994 1 1 994 9 9 nil 3104 nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 145 0 0 0 217 2 0 0 150 0 0 0] 193 3040 8 '' 3008 3 8 #() 994 193 193 nil 27 1 true 170 192 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 2864 34 2 8 1140850688 131073 3344 nil nil nil 5 nil nil nil 3344 2930 138 ##(Smalltalk.Dictionary) 34 2 2386 410 ##(Smalltalk.Splitter) 34 12 nil 3344 34 2 8 1140850688 1 3472 nil nil nil 517 nil nil nil 3074 3472 nil 1 #left nil nil nil 3104 3120 nil 3104 nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[105 1 0 0 0 0 0 0 110 1 0 0 145 0 0 0] 193 3504 8 '' 3472 3 8 #() 994 193 193 nil 27 1 2386 410 ##(Smalltalk.Splitter) 34 12 nil 3344 34 2 8 1140850688 1 3744 nil nil nil 517 nil nil nil 3074 3744 nil 1 #left nil nil nil 3104 3120 nil 3104 nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[32 2 0 0 0 0 0 0 37 2 0 0 145 0 0 0] 193 3776 8 '' 3744 3 8 #() 994 193 193 nil 27 1 false 170 192 34 6 410 ##(Smalltalk.ReferenceView) 34 14 nil 3344 34 2 8 1140916224 131073 4032 nil nil nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 17 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 4098 nil true 34 10 4146 1 4178 #browseClassPackage 8 'Package <1d>' 1 1 4226 nil true 4272 8 'Package.ico' 4320 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4146 2097153 4178 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 4098 nil true 8 #() 8 'Local Re&ferences To' #browseVariablesMenu 134217729 nil nil nil nil nil 4466 4097 4146 1 4178 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 4146 1 4178 #browseMethodHistoryForClass 8 'Method &History' 1 1 4226 nil true 4272 8 'MethodHistory.ico' 4320 nil nil 4466 4097 4146 1 4178 #browsePublishedEvents 8 'Published &events' 1 1 4226 nil true 4272 8 'Event.ico' 4320 nil nil 4146 1 4178 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil nil nil nil 4466 4097 4146 1 4178 #newClass 8 '&New...' 1 1 4226 nil true 4272 8 'NewClass.ico' 4320 nil nil 4146 1 4178 #deleteClassHierarchy 8 '&Delete' 1 1 4226 nil true 4272 8 'EditClear.ico' 4320 nil nil 4098 nil true 34 18 4146 1 4178 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 4146 2097153 4178 #renameClass 8 'Re&name...' 1 1 4226 nil true 4272 8 'Rename.ico' 4320 nil nil 4466 4097 4146 1 4178 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 4146 1 4178 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 4098 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil nil nil nil 4098 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil nil nil nil 4466 4097 4098 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil nil nil nil 4098 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil nil nil nil 4466 4097 4098 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil nil nil nil 4098 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil nil nil nil 4098 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil nil nil nil 4466 4097 4146 1 4178 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 4466 4097 4146 1 4178 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 4226 nil true 4272 8 'Refactoring.ico' 4320 nil nil nil nil 4466 4097 4146 1 4178 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 4146 1 4178 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 4466 4097 4146 1 4178 #fileInClass 8 'File &In...' 1 1 4226 nil true 4272 8 'FileIn.ico' 4320 nil nil 4146 1 4178 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 4466 4097 4146 1 4178 #classPackage 8 '&Package...' 1 1 4226 nil true 4272 8 'Package.ico' 4320 nil nil 4146 1 4178 #categorizeClass 8 '&Category...' 1 1 4226 nil true 4272 8 'Category.ico' 4320 nil nil 4466 4097 4098 nil true 34 4 4146 1 4178 #newView 8 '&New...' 1 1 nil nil nil 4466 4097 4098 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 4226 nil true 4272 8 'ViewComposer.ico' 4320 nil nil nil nil 4098 nil true 8 #() 8 '&Show' #viewsShowMenu 1 4226 nil true 4272 8 'TestView.ico' 4320 nil nil nil nil 8 '&Views' #viewsMenu 134217729 4226 nil true 4272 8 'View.ico' 4320 nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 4032 738 ##(Smalltalk.ClassListSelector) #resource_Default_view nil 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[183 0 0 0 0 0 0 0 105 1 0 0 145 0 0 0] 193 4064 8 '' 4032 834 #contextMenu: 34 1 4112 4032 3 976 994 193 193 nil 27 8 'classes' 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 3344 34 2 8 1140850688 131073 6880 nil nil nil 517 nil nil nil 6880 656710 1 ##(Smalltalk.CardLayout) 138 144 34 3 2386 590662 1 ##(Smalltalk.CardLabel) 8 'Categories' 2274 0 nil 2306 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[MethodCategory icon]' 8 #[31 105 45 159 106] 983558 ##(Smalltalk.VariableBinding) #MethodCategory ##(Smalltalk.MethodCategory) #icon 7072 7 1 nil 21481 410 ##(Smalltalk.TreeView) 34 27 nil 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 6880 34 2 8 1140850688 131073 7216 nil nil nil 5 nil nil nil 7216 6960 170 192 34 6 410 ##(Smalltalk.ListView) 34 45 nil 7216 34 2 8 1140936777 1 7312 590662 2 ##(Smalltalk.ListModel) 138 144 976 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 608 nil 29 4098 nil true 34 7 4146 1 4178 #browseSelectorsInProtocol 8 '&Selectors' 1 1 nil nil nil 4146 1 4178 #toggleProtocolReadOnly 8 '&Read Only' 1 1 nil nil nil 4466 4097 4146 1 4178 #addMethodProtocol 8 '&Add...' 1 1 nil nil nil 4098 nil true 34 2 4146 1 4178 #removeMethodProtocol 8 'Protocol' 1 1 nil nil nil 4146 1 4178 #removeMethodsInProtocol 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 4146 1 4178 #renameMethodProtocol 8 'Rename...' 1 1 nil nil nil 4146 1 4178 #browseMethodProtocol 8 'Browse' 1 1 nil nil nil 8 'Protocols' nil 134217729 nil nil nil nil nil nil nil 7312 nil 8 1759068368 2482 #name 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil 2274 0 nil 2306 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 7984 7 257 nil 994 65 65 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Protocols' 189 #left 2482 #name 8 #() 2482 #<= 8 #() nil nil 7312 nil 3 nil 2274 0 nil 2306 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 8224 7 257 nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 193 7344 8 'Protocols' 7312 834 #contextMenu: 34 1 7456 7312 1 8 #() 994 193 193 nil 35 8 'protocols' 7184 8 'categories' 410 ##(Smalltalk.ListView) 34 45 nil 7216 34 2 8 1140920395 1 8560 7378 138 144 976 nil 7440 608 nil 13 4098 nil true 34 10 4146 2097153 4178 #browseInstVarReferences 8 'Browse &References' 1 1 nil nil nil 4466 4097 4146 1 4178 #addInstanceVariable 8 '&Add...' 1 1 nil nil nil 4146 1 4178 #removeInstanceVariables 8 'Remo&ve' 1 1 nil nil nil 4146 1 4178 #renameInstanceVariable 8 'Re&name' 1 1 nil nil nil 4466 4097 4146 1 4178 #pushDownInstanceVariables 8 'Push &Down' 1 1 nil nil nil 4146 1 4178 #createAccessors 8 '&Create Accessors' 1 1 nil nil nil 4146 1 4178 #abstractInstanceVariables 8 'Ab&stract' 1 1 nil nil nil 4146 1 4178 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 8560 nil 8 1759068368 2482 #value 8 #() 2274 0 nil 2306 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] #key #icon #imageIndex 9152 7 257 nil 7968 nil 2274 0 nil 2306 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] #key #name 8 '.' #, 9232 7 257 nil nil 994 65 65 nil nil 138 144 34 1 8114 8 '' 201 #left ##(Smalltalk.BasicListAbstract) 2482 #<= 8 #() nil nil 8560 nil 1 nil nil #list 8304 nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 193 8592 8 '' 8560 834 #contextMenu: 34 1 8656 8560 1 8 #() 994 193 193 nil 35 8 'variables' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 6880 34 2 8 1140916864 1 9664 7378 138 144 34 3 7040 7026 8 'Protocols' 2274 0 nil 2306 6 1 16 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 7154 #CardLabel 7024 9792 7154 #MethodProtocol ##(Smalltalk.MethodProtocol) #icon #text:iconBlock: 9808 11 1 nil 21487 7026 8 'Variables' nil 21491 nil 7440 nil nil 1 nil nil nil 9664 nil 8 1758664336 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 7968 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 3 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 193 9696 8 '' 9664 834 #setSingleSelection: 8 #(1) 9664 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 9664 3 8 #() 994 193 193 nil 27 nil 6880 994 33 33 1050182 1 ##(Smalltalk.ButtonInteractor) 7216 nil 1 590342 ##(Smalltalk.Rectangle) 994 161 3 994 193 35 nil 4178 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[76 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 193 7248 8 '' 7216 3 34 3 7184 7312 8560 994 193 193 nil 27 34 2 8 1140916771 1 7184 590918 3 ##(Smalltalk.TreeModel) nil 7440 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 976 608 nil 29 4098 nil true 34 4 4146 1 4178 #addMethodCategory 8 '&Add...' 1 1 nil nil nil 4098 nil true 34 2 4146 1 4178 #removeMethodCategory 8 'Category' 1 1 nil nil nil 4146 1 4178 #removeMethodsInCategory 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 4146 1 4178 #renameMethodCategory 8 'Rename...' 1 1 nil nil nil 4146 1 4178 #browseMethodCategory 8 'Browse' 1 1 nil nil nil 8 'Categories' nil 134217729 nil nil nil nil nil nil nil 7184 nil 8 1758766000 2482 #localName 8 #() ##(Smalltalk.IconicListAbstract) 7968 nil nil 2274 0 nil 2306 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawCategoryTree: 11024 7 257 nil nil nil 170 176 976 nil #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 976 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 193 10528 8 '' 7184 834 #contextMenu: 34 1 10640 7184 3 8 #() 994 193 193 nil 27 2386 9776 7312 2386 9920 8560 7184 nil nil nil 170 192 34 2 7216 8 'filters' nil 9664 7216 994 201 201 401 1 524319 nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[110 1 0 0 0 0 0 0 32 2 0 0 145 0 0 0] 193 6912 8 '' 6880 3 34 2 7216 9664 994 193 193 nil 27 8 'filtersSlidey' 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 3344 34 2 8 1140850688 131073 11632 nil nil nil 517 nil nil nil 11632 6946 138 144 34 1 2386 7026 8 'Packages' 834 #icon 8 #() ##(Smalltalk.Package) 21511 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 11632 34 2 8 1140850688 131073 11824 nil nil nil 5 nil nil nil 11824 6946 138 144 34 1 2386 7026 8 'Packages' 834 #icon 8 #() ##(Smalltalk.Package) 21511 410 ##(Smalltalk.ReferenceView) 34 14 nil 11824 34 2 8 1140850688 131073 12016 nil nil nil 5 nil nil nil 12016 738 ##(Smalltalk.PackageSelector) #resource_Default_view nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 18 0 0 0 146 0 0 0 137 0 0 0] 193 12048 8 '' 12016 3 976 994 193 193 nil 27 12016 nil nil nil 170 192 34 2 12016 8 'packages' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 11632 34 2 8 1140916864 1 12304 7378 138 144 34 1 11952 nil 7440 nil nil 1 nil nil nil 12304 nil 8 1758664336 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 7968 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 3 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 193 12336 8 '' 12304 834 #setSingleSelection: 8 #(1) 12304 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 12304 3 8 #() 994 193 193 nil 27 nil 11632 994 33 33 10226 11824 nil 1 10258 994 257 3 994 289 35 nil 4178 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[28 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 193 11856 8 '' 11824 3 34 1 12016 994 193 193 nil 27 nil nil nil nil 170 192 976 nil 12304 11824 994 201 201 401 1 524319 nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 193 11664 8 '' 11632 3 34 2 11824 12304 994 193 193 nil 27 8 'packagesSlidey' nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 193 3376 8 '' 3344 3 34 7 11632 410 ##(Smalltalk.Splitter) 34 12 nil 3344 34 2 8 1140850688 1 13344 nil nil nil 517 nil nil nil 3074 13344 nil 1 #left nil nil nil 3104 3120 nil 3104 nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[178 0 0 0 0 0 0 0 183 0 0 0 145 0 0 0] 193 13376 8 '' 13344 3 8 #() 994 193 193 nil 27 4032 3472 6880 3744 410 ##(Smalltalk.ContainerView) 34 15 nil 3344 34 2 8 1140850688 131073 13600 nil nil nil 5 nil nil nil 13600 498 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 13600 34 2 8 1140850688 131073 13680 nil nil nil 533 nil nil nil 13680 1842 11 1 1 170 192 34 4 410 ##(Smalltalk.RadioButton) 34 16 nil 13680 34 2 8 1141055497 1 13792 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 2482 #= 8 #() 2482 #hash 8 #() false nil nil 517 nil nil nil 13792 nil 8 1759007584 852486 ##(Smalltalk.NullConverter) nil nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[80 0 0 0 3 0 0 0 128 0 0 0 22 0 0 0] 193 13824 8 'C&lass' 13792 3 8 #() 994 193 193 nil 27 8 'classMode' 410 ##(Smalltalk.RadioButton) 34 16 nil 13680 34 2 8 1141055497 1 14224 13858 nil nil 13890 2482 #= 8 #() 2482 #hash 8 #() false nil nil 517 nil nil nil 14224 nil 8 1759007584 14002 nil nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[10 0 0 0 3 0 0 0 75 0 0 0 22 0 0 0] 193 14256 8 'In&stance' 14224 3 8 #() 994 193 193 nil 27 8 'instanceMode' 10258 994 21 7 994 1 7 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 120 0 0 0 180 0 0 0 145 0 0 0] 193 13712 8 '' 13680 3 34 2 14224 13792 994 193 193 nil 27 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 13600 34 2 8 1140916224 131073 14832 nil nil nil 29 nil nil nil 14832 738 ##(Smalltalk.MethodBrowser) #resource_Class_browser_method_list nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 180 0 0 0 120 0 0 0] 193 14864 8 '' 14832 3 976 994 193 193 nil 27 170 192 34 4 14832 8 'methods' 13680 8 'mode' nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[37 2 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 193 13632 8 '' 13600 3 34 2 14832 13680 994 193 193 nil 27 994 193 193 nil 27 8 'classes' 410 ##(Smalltalk.CardContainer) 34 16 nil 2864 34 2 8 1140850688 131073 15344 nil nil nil 21 4098 nil true 34 2 4098 nil true 34 4 4146 1025 4178 2482 #tabOrientation: 8 #(#top) 8 '&Top' 1 1 nil nil nil 4146 1025 4178 2482 #tabOrientation: 8 #(#bottom) 8 '&Bottom' 1 1 nil nil nil 4146 1025 4178 2482 #tabOrientation: 8 #(#left) 8 '&Left' 1 1 nil nil nil 4146 1025 4178 2482 #tabOrientation: 8 #(#right) 8 '&Right' 1 1 nil nil nil 8 '&Orientation' nil 134217729 nil nil nil nil nil 4098 nil true 34 6 4146 1025 4178 2482 #viewMode: 8 #(#noIcons) 8 '&No Icons' 1 1 nil nil nil 4146 1025 4178 2482 #viewMode: 8 #(#smallIcons) 8 '&Small Icons' 1 1 nil nil nil 4146 1025 4178 2482 #viewMode: 8 #(#mediumIcons) 8 '&Medium Icons' 1 1 nil nil nil 4146 1025 4178 2482 #viewMode: 8 #(#largeIcons) 8 '&Large Icons' 1 1 nil nil nil 4146 1025 4178 2482 #viewMode: 8 #(#tileIcons) 8 '&Tile Icons' 1 1 nil nil nil 4146 1 4178 2482 #viewMode: 8 #(#thumbnails) 8 'Thum&bnails' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 15344 6946 138 144 34 2 2386 7026 8 'Method source' 2274 0 nil 2306 7 1 7024 8 'doIt' 8 '(CardLabel text: ''Method source'' iconBlock: [Icon fromId: ''MethodSource.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 7154 #CardLabel 7024 16432 7154 #Icon 4224 8 'MethodSource.ico' #fromId: #text:iconBlock: 16448 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 15344 34 2 8 1140850688 131073 16576 nil nil nil 5 nil nil nil 16576 738 ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[4 0 0 0 26 0 0 0 213 2 0 0 142 0 0 0] 193 16608 8 '' 16576 3 976 994 193 193 nil 27 2386 7026 8 'Class definition' 2274 0 nil 2306 7 1 7024 8 'doIt' 8 '(CardLabel text: ''Class definition'' iconBlock: [Icon fromId: ''ClassDefinition.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 16528 16848 16544 8 'ClassDefinition.ico' #fromId: #text:iconBlock: 16864 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 15344 34 2 8 1140916224 131073 16960 nil 608 nil 21 nil nil nil 16960 738 ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[4 0 0 0 26 0 0 0 213 2 0 0 142 0 0 0] 193 16992 8 '' 16960 1 976 994 193 193 nil 27 16576 nil nil nil 170 192 34 4 16960 8 'definition' 16576 8 'source' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 15344 34 2 8 1140916736 1 17264 7378 138 144 34 2 16416 16832 nil 7440 nil nil 17 nil nil nil 17264 nil 8 1758664336 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 7968 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 3 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 217 2 0 0 146 0 0 0] 193 17296 8 '' 17264 834 #setSingleSelection: 8 #(1) 17264 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 17264 3 8 #() 994 193 193 nil 27 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 150 0 0 0 217 2 0 0 40 1 0 0] 193 15376 8 '' 15344 834 #contextMenu: 34 1 15408 15344 3 34 3 16576 16960 17264 994 193 193 nil 27 8 'cards' nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 25 0 0 0 217 2 0 0 65 1 0 0] 193 2896 8 '' 2864 3 34 3 3344 3008 15344 994 193 193 nil 27 170 192 34 4 2048 8 'statusbar' 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 9 4098 nil true 34 8 4146 1 4178 #fileNew 8 '&New' 9373 1 4226 nil true 4272 8 'NewWorkspace.ico' 4320 nil nil 4146 1 4178 #fileOpen 8 '&Open...' 9375 1 4226 nil true 4272 8 'OpenWorkspace.ico' 4320 nil nil 4146 1 4178 #fileFileIn 8 '&File In...' 1 1 4226 nil true 4272 8 'FileIn.ico' 4320 nil nil 4466 4097 4146 1 4178 #saveImage 8 'Sa&ve Image' 1 1 4226 nil true 4272 8 'Snapshot.ico' 4320 nil nil 4146 1 4178 #smalltalkExit 8 'E&xit Dolphin' 1 1 4226 nil true 4272 8 'PowerSwitch.ico' 4320 nil nil 4466 4097 4146 1 4178 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 15473 nil nil 4098 nil true 34 13 4146 1 4178 #undo 8 '&Undo' 9397 1 4226 nil true 4272 8 'EditUndo.ico' 4320 nil nil 4466 4097 4146 1 4178 #cutSelection 8 'Cu&t' 9393 1 4226 nil true 4272 8 'EditCut.ico' 4320 nil nil 4146 1 4178 #copySelection 8 '&Copy' 9351 1 4226 nil true 4272 8 'EditCopy.ico' 4320 nil nil 4146 1 4178 #pasteClipboard 8 '&Paste' 9389 1 4226 nil true 4272 8 'EditPaste.ico' 4320 nil nil 4146 1 4178 #editDelete 8 '&Delete' 1 1 4226 nil true 4272 8 'EditClear.ico' 4320 nil nil 4098 nil true 34 2 4146 1 4178 #reformatSource 8 '&Source' 9391 1 nil nil nil 4146 1 4178 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 15489 nil nil 4466 4097 4146 1 4178 #selectAll 8 'Select &All' 9347 1 nil nil nil 4466 4097 4146 1 4178 #editFind 8 '&Find...' 9357 1 4226 nil true 4272 47 786694 ##(Smalltalk.ShellLibrary) nil nil 4146 1 4178 #findNext 8 'Find &Next' 1253 1 4226 nil true 4272 8 'FindNext.ico' 4320 nil nil 4146 1 4178 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 15499 nil nil 4098 nil true 34 17 4146 1 4178 #browseIt 8 '&Browse It' 9349 1 4226 nil true 4272 8 'ClassBrowserShell.ico' 4320 nil nil 4146 1 4178 #displayIt 8 '&Display It' 9353 1 4226 nil true 4272 8 'DisplayIt.ico' 4320 nil nil 4146 1 4178 #printIt 8 '&Print It' 9377 1 4226 nil true 4272 8 'PrintIt.ico' 4320 nil nil 4146 1 4178 #evaluateIt 8 '&Evaluate It' 9355 1 4226 nil true 4272 8 'EvaluateIt.ico' 4320 nil nil 4146 1 4178 #inspectIt 8 '&Inspect It' 9363 1 4226 nil true 4272 8 'InspectIt.ico' 4320 nil nil 4146 1 4178 #debugIt 8 'Deb&ug It' 1269 1 4226 nil true 4272 8 'Debugger.ico' 4320 nil nil 4146 1 4178 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 4466 4097 4146 1 4178 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 4146 1 4178 #browseReferences 8 '&References' 5367 1 nil nil nil 4466 4097 4146 2097153 4178 #accept 8 '&Accept' 9383 1 nil nil nil 4146 1 4178 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 4466 4097 4098 nil true 34 14 4146 1 4178 #renameVariable 8 'Re&name <1d>...' 1 1 nil nil nil 4466 4097 4146 1 4178 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 nil nil nil 4146 1 4178 #extractMethod 8 'E&xtract Method...' 9371 1 nil nil nil 4146 1 4178 #extractToComponent 8 'Extract to &Component...' 1 1 nil nil nil 4146 1 4178 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 4466 4097 4146 1 4178 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 4146 1 4178 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 4146 1 4178 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 4466 4097 4146 1 4178 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 nil nil nil 4146 1 4178 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 4146 1 4178 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 4226 nil true 4272 8 'Refactoring.ico' 4320 nil 15545 nil nil 4466 4097 4098 nil true 34 7 4146 1 4178 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4146 1 4178 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4146 1 4178 #toggleLineEndings 8 'Line &Endings' 1 1 18658 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 4146 1 4178 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4146 1 4178 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4146 1 4178 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4146 1 4178 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 4226 nil true 4272 8 'Preferences.ico' 4320 nil 15561 nil nil 8 '&Workspace' nil 134217729 nil nil 15563 nil nil 4098 nil true 34 17 4146 2097153 4178 #findClass 8 'Find...' 1 1 4226 nil true 4272 8 'FindClass.ico' 4320 nil nil 4098 nil true 34 10 4146 1 4178 #browseClassPackage 8 'Package <1d>' 1 1 4226 nil true 4272 8 'Package.ico' 4320 nil nil 4466 4097 4146 2097153 4178 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 4098 nil true 8 #() 8 'Local Re&ferences To' #browseVariablesMenu 134217729 nil nil 15571 nil nil 4466 4097 4146 1 4178 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 4146 1 4178 #browseMethodHistoryForClass 8 'Method &History' 1 1 4226 nil true 4272 8 'MethodHistory.ico' 4320 nil nil 4466 4097 4146 1 4178 #browsePublishedEvents 8 'Published &events' 1 1 4226 nil true 4272 8 'Event.ico' 4320 nil nil 4146 1 4178 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil 15581 nil nil 4466 4097 4146 1 4178 #newClass 8 '&New...' 1 1 4226 nil true 4272 8 'NewClass.ico' 4320 nil nil 4146 1 4178 #deleteClassHierarchy 8 '&Delete' 1 1 4226 nil true 4272 8 'EditClear.ico' 4320 nil nil 4098 nil true 34 19 4146 1 4178 #safeRemoveClass 8 '&Remove' 1 1 nil nil nil 4146 2097153 4178 #renameClass 8 'Re&name...' 1 1 4226 nil true 4272 8 'Rename.ico' 4320 nil nil 4146 1 4178 #copyClass 8 'Cl&one...' 1 1 nil nil nil 4466 4097 4146 1 4178 #addInstanceVariable 8 'Add <1s>&Instance Variable...' 1 1 nil nil nil 4146 1 4178 #addClassVariable 8 'Add &Class Variable...' 1 1 nil nil nil 4098 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil 15597 nil nil 4098 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil 15599 nil nil 4466 4097 4098 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil 15601 nil nil 4098 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil 15603 nil nil 4466 4097 4098 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil 15605 nil nil 4098 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil 15607 nil nil 4098 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil 15609 nil nil 4466 4097 4146 1 4178 #convertToSibling 8 'Con&vert to Sibling...' 1 1 nil nil nil 4466 4097 4146 1 4178 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 4226 nil true 4272 8 'Refactoring.ico' 4320 nil 15615 nil nil 4466 4097 4146 1 4178 #createInstanceVariableAccessors 8 'Create &Accessors...' 1 1 nil nil nil 4146 1 4178 #reformatAll 8 'Refor&mat All' 1 1 nil nil nil 4466 4097 4146 1 4178 #fileInClass 8 'File &In...' 1 1 4226 nil true 4272 8 'FileIn.ico' 4320 nil nil 4146 1 4178 #fileOutClass 8 'File &Out...' 1 1 nil nil nil 4466 4097 4146 1 4178 #classPackage 8 '&Package...' 1 1 4226 nil true 4272 8 'Package.ico' 4320 nil nil 4146 1 4178 #categorizeClass 8 '&Category...' 1 1 4226 nil true 4272 8 'Category.ico' 4320 nil nil 4466 4097 4098 nil true 34 4 4146 1 4178 #newView 8 '&New...' 1 1 nil nil nil 4466 4097 4098 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 4226 nil true 4272 8 'ViewComposer.ico' 4320 nil 15631 nil nil 4098 nil true 8 #() 8 '&Show' #viewsShowMenu 1 4226 nil true 4272 8 'TestView.ico' 4320 nil 15633 nil nil 8 '&Views' #viewsMenu 134217729 4226 nil true 4272 8 'View.ico' 4320 nil 15635 nil nil 8 '&Class' nil 134217729 nil nil 15637 nil nil 4098 nil true 34 15 4098 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 15639 nil nil 4098 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 15641 nil nil 4098 nil true 34 14 4146 1 4178 #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 4146 1 4178 #browseContainingText 8 'C&ontaining Text...' 1 1 4226 nil true 4272 8 'SearchText.ico' 4320 nil nil 4146 1 4178 #browseMethodCategory 8 'Cate&gory...' 1 1 4226 nil true 4272 8 'Category.ico' 4320 nil nil 4146 1 4178 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 4146 1 4178 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 4466 4097 4146 1 4178 #browseMethodPackages 8 '&Package <s>' 1 1 4226 nil true 4272 8 'Package.ico' 4320 nil nil 4146 1 4178 #browseMethodClasses 8 '&Class <s>' 1 1 nil nil nil 4466 4097 4146 1 4178 #browseMethodHistory 8 'Change &History' 1 1 4226 nil true 4272 8 'MethodHistory.ico' 4320 nil nil 4146 1 4178 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 4466 4097 4146 1 4178 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 4146 1 4178 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 15665 nil nil 4466 4097 4146 1 4178 #newMethod 8 '&New' 1 1 4226 nil true 4272 8 'NewMethod.ico' 4320 nil nil 4146 1 4178 #removeMethod 8 '&Delete' 1 1 4226 nil true 4272 8 'EditClear.ico' 4320 nil nil 4098 nil true 34 17 4146 1 4178 #renameMethod 8 'Re&name' 1 1 4226 nil true 4272 8 'Rename.ico' 4320 nil nil 4146 1 4178 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 4146 1 4178 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 4466 4097 4146 1 4178 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 4098 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 15679 nil nil 4098 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 15681 nil nil 4098 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 15683 nil nil 4466 4097 4098 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 15685 nil nil 4098 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 15687 nil nil 4466 4097 4146 1 4178 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 4146 1 4178 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 4146 1 4178 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 4146 1 4178 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 4146 1 4178 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 4226 nil true 4272 8 'Refactoring.ico' 4320 nil 15699 nil nil 4466 4097 4146 1 4178 #methodPackage 8 '&Package...' 1 1 4226 nil true 4272 8 'Package.ico' 4320 nil nil 4098 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 15703 nil nil 4098 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 15705 nil nil 4146 1 4178 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 4466 4097 4146 1 4178 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 4146 1 4178 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 15713 nil nil 4098 nil true 34 7 4146 1 4178 #undoChange 8 '&Undo <1d>' 1 1 4226 nil true 4272 8 'EditUndo.ico' 4320 nil nil 4146 1 4178 #redoChange 8 '&Redo <1d>' 1 1 4226 nil true 4272 8 'EditRedo.ico' 4320 nil nil 4146 1 4178 #clearChangeHistory 8 'Clear Change &History' 1 1 4226 nil true 4272 8 'MethodHistoryErase.ico' 4320 nil nil 4466 4097 4146 1 4178 #historyBack 8 'Back to <1d>' 1 1 4226 nil true 4272 8 'HistoryBack.ico' 4320 nil nil 4146 1 4178 #historyForward 8 'Forward to <1d>' 1 1 4226 nil true 4272 8 'HistoryForward.ico' 4320 nil nil 4146 1 4178 #historyClear 8 'Clear Visit History' 1 1 4226 nil true 4272 8 'HistoryErase.ico' 4320 nil nil 8 'H&istory' nil 134217729 nil nil 15727 nil nil 4098 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 15729 nil nil 4098 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 15731 nil nil 4098 nil true 34 15 4146 1 4178 #helpContents 8 '&Contents' 1025 1 4226 nil true 4272 8 'Help.ico' 4320 nil nil 4146 1 4178 #help 8 'On this &Tool' 1249 1 nil nil nil 4146 1 4178 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4466 4097 4146 1 4178 #learnSmalltalk 8 'Learn Smalltalk' 1 1 18658 $🎓 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 4466 4097 4146 1 4178 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4146 1 4178 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4146 1 4178 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4466 4097 4146 1 4178 #dolphinHomePage 8 'Dolphin Homepage' 1 1 4226 nil true 4272 8 '!!APPLICATION' 4320 nil nil 4146 1 4178 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4146 1 4178 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4466 4097 4146 1 4178 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 18658 $🐬 nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 15755 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 770 138 144 34 1 834 #createWindow: 34 1 882 10258 994 1 1 994 1491 801 193 448 8 'System Browser' 416 1 34 3 528 2864 2048 994 193 193 nil 27 )!

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

