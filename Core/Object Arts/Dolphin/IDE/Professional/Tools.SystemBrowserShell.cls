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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 #{Graphics.ThemeColor} #toolBackground nil 567 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.Toolbar} 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 917510 #{Graphics.Color} #default 8 1809897712 170 192 34 8 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1376838 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Image_tools nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1 1 866 63 51 672 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 866 193 193 nil 27 8 'imageTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1008 nil nil nil 7 nil nil nil 1008 738 #{UI.Toolbar} #resource_Class_browser_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1051 1 866 353 51 1008 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 189 2 0 0 25 0 0 0] 960 976 nil 27 8 'classBrowserTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1232 nil nil nil 7 nil nil nil 1232 738 #{UI.Toolbar} #resource_Search_tools nil 770 34 1 818 #createAt:extent: 34 2 866 615 1 866 437 51 1232 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 960 976 nil 27 8 'searchTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1456 nil nil nil 7 nil nil nil 1456 738 #{UI.Toolbar} #resource_Smalltalk_tools nil 770 34 1 818 #createAt:extent: 34 2 866 63 1 866 553 51 1456 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 960 976 nil 27 8 'smalltalkTools' nil nil nil 170 192 960 138 144 960 nil nil 1 nil 866 33 33 nil nil 852806 1 #{UI.FlowLayout} 1 1 1 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 1459 51 528 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 25 0 0 0] 34 4 672 1456 1232 1008 976 nil 29 410 #{UI.StatusBar} 34 21 nil 416 34 2 8 1140852996 1 1904 nil nil nil 7 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 866 193 193 nil 1904 nil 8 1809451024 170 192 34 8 1050438 1 #{UI.StatusBarItem} 8705 351 1904 nil 786950 #{Core.Message} #displayString 8 #() 2146 #iconImageIndex 8 #() 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:namespace | ''Method namespace: '', namespace fullName]' 8 #[32 105 29 226 1 178 106] 8 'Method namespace: ' #fullName #, 2240 7 257 nil 8 'namespace' 2114 8193 45 1904 nil nil 2226 0 nil 2258 5 1 2224 8 'doIt' 8 '[:modified | modified ifTrue: [Tools.SmalltalkSystem changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 1442886 2 #{Kernel.VariableBinding} #SmalltalkSystem #{Tools.SmalltalkSystem} #{Tools} 1 #changedIcon #imageIndex 2384 #ifTrue: 7 257 nil 2226 0 nil 2258 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:modified | modified ifTrue: [''Unsaved edits'']]' 8 #[30 105 17 119 29 106 60 106] 8 'Unsaved edits' 2496 #ifTrue: 7 257 nil 8 'modified' 2114 8193 -1 1904 nil 2146 #displayString 8 #() 2146 #iconImageIndex 2640 nil 8 'message' 2114 8193 401 1904 nil 2146 #displayString 8 #() 2146 #iconImageIndex 8 #() nil 8 'packageOfSelection' nil nil nil 34 4 2688 2368 2608 2128 1311814 1 #{UI.StatusBarNullItem} 8705 1 1904 nil nil 770 34 1 818 #createAt:extent: 34 2 866 1 643 866 1459 41 1904 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 217 2 0 0 85 1 0 0] 8 #() 976 nil 29 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 2976 nil nil nil 7 nil nil nil 2976 1376774 #{UI.ProportionalLayout} 138 #{Core.Dictionary} 34 1 1049094 #{Core.Association} 410 #{UI.Splitter} 34 12 nil 2976 34 2 8 1140850688 1 3136 nil nil nil 519 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 3136 nil 1 #left nil nil nil 866 1 1 866 9 9 nil 3232 nil 770 34 1 818 #createAt:extent: 34 2 866 1 291 866 1459 11 3136 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 0 0 0 217 2 0 0 150 0 0 0] 8 #() 976 nil 27 1 true 170 192 34 4 410 #{UI.ContainerView} 34 15 nil 2976 34 2 8 1140850688 131073 3440 nil nil nil 7 nil nil nil 3440 3042 138 #{Core.Dictionary} 34 2 3106 410 #{UI.Splitter} 34 12 nil 3440 34 2 8 1140850688 1 3568 nil nil nil 519 nil nil nil 3202 3568 nil 1 #left nil nil nil 3232 3248 nil 3232 nil 770 34 1 818 #createAt:extent: 34 2 866 723 1 866 11 291 3568 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 1 0 0 0 0 0 0 110 1 0 0 145 0 0 0] 8 #() 976 nil 27 1 3106 410 #{UI.Splitter} 34 12 nil 3440 34 2 8 1140850688 1 3808 nil nil nil 519 nil nil nil 3202 3808 nil 1 #left nil nil nil 3232 3248 nil 3232 nil 770 34 1 818 #createAt:extent: 34 2 866 1089 1 866 11 291 3808 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 2 0 0 0 0 0 0 37 2 0 0 145 0 0 0] 8 #() 976 nil 27 1 false 170 192 34 6 410 #{UI.SlideyInneyOuteyThing} 34 23 nil 3440 34 2 8 1140850688 131073 4064 nil nil nil 519 nil nil nil 4064 853318 1 #{UI.CardLayout} 138 144 34 1 3106 787270 1 #{UI.CardLabel} 8 'Packages' 818 #icon 8 #() #{Kernel.Package} 21511 410 #{UI.SlidingCardTray} 34 22 nil 4064 34 2 8 1140850688 131073 4288 nil nil nil 7 nil nil nil 4288 4130 138 144 34 1 3106 4210 8 'Packages' 818 #icon 8 #() #{Kernel.Package} 21511 410 #{UI.ReferenceView} 34 14 nil 4288 34 2 8 1140850688 131073 4480 nil nil nil 7 nil nil nil 4480 738 #{Tools.PackageSelector} #resource_Default_view nil 770 34 1 818 #createAt:extent: 34 2 866 1 37 866 293 239 4480 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 146 0 0 0 137 0 0 0] 960 976 nil 27 4480 nil nil nil 170 192 34 2 4480 8 'packages' nil 410 #{UI.TabViewXP} 34 28 nil 4064 34 2 8 1140916864 1 4736 787270 2 #{UI.ListModel} 138 144 34 1 4416 nil 1769478 #{Kernel.IdentitySearchPolicy} nil nil 1 nil nil nil 4736 nil 8 1809685360 2624 2146 #iconImageIndex 8 #() 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil #smallIcons nil nil nil nil nil 770 34 3 818 #createAt:extent: 34 2 866 1 1 866 357 291 4736 818 #setSingleSelection: 8 #(1) 4736 818 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4736 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 8 #() 976 nil 27 nil 4064 866 33 33 1246790 1 #{UI.ButtonInteractor} 4288 nil 1 1180166 #{Graphics.Rectangle} 866 257 3 866 289 35 nil 1377606 4 #{UI.CommandDescription} #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 34 1 818 #createAt:extent: 34 2 866 57 9 866 293 275 4288 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 34 1 4480 976 nil 27 nil nil nil nil 170 192 960 nil 4736 4288 866 201 201 401 1 524319 nil nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 357 291 4064 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 34 2 4288 4736 976 nil 27 8 'packagesSlidey' 410 #{UI.SlideyInneyOuteyThing} 34 23 nil 3440 34 2 8 1140850688 131073 5680 nil nil nil 519 nil nil nil 5680 4130 138 144 34 3 3106 4210 8 'Categories' 2226 0 nil 2258 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[MethodCategory icon]' 8 #[31 105 45 159 106] 2466 #'Core.MethodCategory' #{Core.MethodCategory} #{Smalltalk} 1 #icon 5840 7 1 nil 21481 410 #{UI.TreeView} 34 27 nil 410 #{UI.SlidingCardTray} 34 22 nil 5680 34 2 8 1140850688 131073 5968 nil nil nil 7 nil nil nil 5968 5744 170 192 34 6 410 #{UI.ListView} 34 45 nil 5968 34 2 8 1140920395 1 6064 4802 138 144 960 nil 4880 608 nil 13 461638 4 #{UI.Menu} nil true 34 10 1180742 2 #{UI.CommandMenuItem} 2097153 5298 #browseInstVarReferences 8 'Browse &References' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 6210 1 5298 #addInstanceVariable 8 '&Add…' 1 1 nil nil nil 6210 1 5298 #removeInstanceVariables 8 'Remo&ve' 1 1 nil nil nil 6210 1 5298 #renameInstanceVariable 8 'Re&name' 1 1 nil nil nil 6274 4097 6210 1 5298 #pushDownInstanceVariables 8 'Push &Down' 1 1 nil nil nil 6210 1 5298 #createAccessors 8 '&Create Accessors' 1 1 nil nil nil 6210 1 5298 #abstractInstanceVariables 8 'Ab&stract' 1 1 nil nil nil 6210 1 5298 #protectInstanceVariables 8 '&Protect/Concrete' 1 1 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 6064 nil 8 1809872048 2146 #value 8 #() 2226 0 nil 2258 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a | a key icon imageIndex]' 8 #[32 105 17 158 159 160 106] #key #icon #imageIndex 6704 7 257 nil 4960 nil 2226 0 nil 2258 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a | a key name, ''.'', a value]' 8 #[33 105 17 158 159 31 179 17 142 179 106] #key #name 8 '.' #, 6784 7 257 nil nil 866 65 65 nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 '' 201 #left 2624 2146 #<= 8 #() nil nil 6064 nil 1 nil nil #list 8 #() nil 133217 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 770 34 2 818 #createAt:extent: 34 2 866 1 37 866 197 239 6064 818 #contextMenu: 34 1 6176 6064 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 976 nil 35 8 'variables' 410 #{UI.ListView} 34 45 nil 5968 34 2 8 1140936777 1 7216 4802 138 144 960 nil 4880 608 nil 29 6162 nil true 34 7 6210 1 5298 #browseSelectorsInProtocol 8 '&Selectors' 1 1 nil nil nil 6210 1 5298 #toggleProtocolReadOnly 8 '&Read Only' 1 1 nil nil nil 6274 4097 6210 1 5298 #addMethodProtocol 8 '&Add…' 1 1 nil nil nil 6162 nil true 34 2 6210 1 5298 #removeMethodProtocol 8 'Protocol' 1 1 nil nil nil 6210 1 5298 #removeMethodsInProtocol 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 6210 1 5298 #renameMethodProtocol 8 'Rename…' 1 1 nil nil nil 6210 1 5298 #browseMethodProtocol 8 'Browse' 1 1 nil nil nil 8 'Protocols' nil 134217729 nil nil nil nil nil nil nil 7216 nil 8 1809872048 2146 #name 8 #() 2146 #iconImageIndex 8 #() 4960 nil nil 2226 0 nil 2258 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 7840 7 257 nil 866 65 65 nil nil 138 144 34 1 6930 8 'Protocols' 197 #left 2146 #name 8 #() 2146 #<= 8 #() nil nil 7216 nil 3 nil 2226 0 nil 2258 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawProtocols: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawProtocols: 8064 7 257 nil #report 7008 nil 133217 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 770 34 3 818 #createAt:extent: 34 2 866 1 37 866 197 239 7216 818 #contextMenu: 34 1 7312 7216 818 #text: 34 1 8 'Protocols' 7216 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 976 nil 35 8 'protocols' 5936 8 'categories' nil 410 #{UI.TabViewXP} 34 28 nil 5680 34 2 8 1140916864 1 8400 4802 138 144 34 3 5808 4210 8 'Protocols' 2226 0 nil 2258 6 1 16 8 'doIt' 8 'CardLabel text: ''Protocols'' iconBlock: [MethodProtocol icon]' 8 #[45 30 34 112 47 161 106 194 105] 2466 #CardLabel 4208 #{Smalltalk} 1 8528 2466 #MethodProtocol #{Kernel.MethodProtocol} #{Smalltalk} 1 #icon #text:iconBlock: 8544 11 1 nil 21487 4210 8 'Variables' nil 21491 nil 4880 nil nil 1 nil nil nil 8400 nil 8 1809685360 2624 2146 #iconImageIndex 8 #() 4960 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 34 3 818 #createAt:extent: 34 2 866 1 1 866 357 291 8400 818 #setSingleSelection: 8 #(1) 8400 818 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8400 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 0 0 0 145 0 0 0] 8 #() 976 nil 27 nil 5680 866 33 33 5202 5968 nil 1 5234 866 161 3 866 193 35 nil 5298 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 34 1 818 #createAt:extent: 34 2 866 153 9 866 197 275 5968 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 0 0 0 4 0 0 0 174 0 0 0 141 0 0 0] 34 3 5936 7216 6064 976 nil 27 34 2 8 1140916771 1 5936 787526 3 #{UI.TreeModel} nil 4880 721670 #{UI.TreeNode} nil nil nil 170 192 960 608 nil 31 6162 nil true 34 4 6210 1 5298 #addMethodCategory 8 '&Add…' 1 1 nil nil nil 6162 nil true 34 2 6210 1 5298 #removeMethodCategory 8 'Category' 1 1 nil nil nil 6210 1 5298 #removeMethodsInCategory 8 'Methods' 1 1 nil nil nil 8 'Remove' nil 1 nil nil nil nil nil 6210 1 5298 #renameMethodCategory 8 'Rename…' 1 1 nil nil nil 6210 1 5298 #browseMethodCategory 8 'Browse' 1 1 nil nil nil 8 'Categories' nil 134217729 nil nil nil nil nil nil nil 5936 nil 8 1809649616 2146 #localName 8 #() 2656 4960 nil nil 2226 0 nil 2258 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx view presenter parentPresenter customDrawCategoryTree: ctx]' 8 #[33 105 226 0 159 160 17 179 106] #view #presenter #parentPresenter #customDrawCategoryTree: 9696 7 257 nil nil nil 170 176 960 nil #noIcons 1 170 192 960 770 34 2 818 #createAt:extent: 34 2 866 1 37 866 197 239 5936 818 #contextMenu: 34 1 9312 5936 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 98 0 0 0 137 0 0 0] 8 #() 976 nil 27 3106 8512 7216 3106 8656 6064 5936 nil nil nil 170 192 34 2 5968 8 'filters' nil 8400 5968 866 201 201 401 1 524319 nil nil 770 34 1 818 #createAt:extent: 34 2 866 733 1 866 357 291 5680 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 1 0 0 0 0 0 0 32 2 0 0 145 0 0 0] 34 2 5968 8400 976 nil 27 8 'filtersSlidey' 410 #{UI.ReferenceView} 34 14 nil 3440 34 2 8 1140916224 131073 10240 nil nil nil 7 nil nil nil 10240 738 #{Tools.ClassListSelector} #resource_Default_view nil 770 34 1 818 #createAt:extent: 34 2 866 367 1 866 357 291 10240 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 183 0 0 0 0 0 0 0 105 1 0 0 145 0 0 0] 960 976 nil 27 8 'classes' nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 1459 291 3440 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 34 7 4064 410 #{UI.Splitter} 34 12 nil 3440 34 2 8 1140850688 1 10608 nil nil nil 519 nil nil nil 3202 10608 nil 1 #left nil nil nil 3232 3248 nil 3232 nil 770 34 1 818 #createAt:extent: 34 2 866 357 1 866 11 291 10608 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 0 0 0 0 183 0 0 0 145 0 0 0] 8 #() 976 nil 27 10240 3568 5680 3808 410 #{UI.ContainerView} 34 15 nil 3440 34 2 8 1140850688 131073 10832 nil nil nil 7 nil nil nil 10832 498 1 1 nil 410 #{UI.ContainerView} 34 15 nil 10832 34 2 8 1140850688 131073 10912 nil nil nil 535 nil nil nil 10912 1730 11 1 1 170 192 34 4 410 #{UI.RadioButton} 34 16 nil 10912 34 2 8 1141055497 1 11024 918598 2 #{UI.ValueHolder} nil nil 1835526 #{Kernel.PluggableSearchPolicy} 2146 #= 8 #() 2146 #hash 8 #() false nil nil 7 nil nil nil 11024 nil 8 1809920128 1049094 #{UI.NullConverter} nil nil nil 770 34 2 818 #createAt:extent: 34 2 866 161 1 866 111 51 11024 818 #text: 34 1 8 'C&lass' 11024 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 0 0 0 0 135 0 0 0 25 0 0 0] 8 #() 976 nil 27 8 'classMode' 410 #{UI.RadioButton} 34 16 nil 10912 34 2 8 1141055497 1 11472 11090 nil nil 11122 2146 #= 8 #() 2146 #hash 8 #() false nil nil 7 nil nil nil 11472 nil 8 1809920128 11234 nil nil nil 770 34 2 818 #createAt:extent: 34 2 866 21 1 866 131 51 11472 818 #text: 34 1 8 'In&stance' 11472 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 75 0 0 0 25 0 0 0] 8 #() 976 nil 27 8 'instanceMode' 5234 866 21 1 866 1 1 770 34 1 818 #createAt:extent: 34 2 866 1 241 866 361 51 10912 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 120 0 0 0 180 0 0 0 145 0 0 0] 34 2 11472 11024 976 nil 27 nil nil 410 #{UI.ReferenceView} 34 14 nil 10832 34 2 8 1140916224 131073 12064 nil nil nil 31 nil nil nil 12064 738 #{Tools.MethodBrowser} #resource_Class_browser_method_list nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 361 241 12064 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 180 0 0 0 120 0 0 0] 960 976 nil 27 170 192 34 4 12064 8 'methods' 10912 8 'mode' nil 770 34 1 818 #createAt:extent: 34 2 866 1099 1 866 361 291 10832 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 37 2 0 0 0 0 0 0 217 2 0 0 145 0 0 0] 34 2 12064 10912 976 nil 27 976 nil 27 8 'classes' 410 #{UI.CardContainer} 34 16 nil 2976 34 2 8 1140850688 131073 12496 nil nil nil 23 6162 nil true 34 2 6162 nil true 34 4 6210 1025 5298 2146 #tabOrientation: 8 #(#top) 8 '&Top' 1 1 nil nil nil 6210 1025 5298 2146 #tabOrientation: 8 #(#bottom) 8 '&Bottom' 1 1 nil nil nil 6210 1025 5298 2146 #tabOrientation: 8 #(#left) 8 '&Left' 1 1 nil nil nil 6210 1025 5298 2146 #tabOrientation: 8 #(#right) 8 '&Right' 1 1 nil nil nil 8 '&Orientation' nil 134217729 nil nil nil nil nil 6162 nil true 34 6 6210 1025 5298 2146 #viewMode: 8 #(#noIcons) 8 '&No Icons' 1 1 nil nil nil 6210 1025 5298 2146 #viewMode: 8 #(#smallIcons) 8 '&Small Icons' 1 1 nil nil nil 6210 1025 5298 2146 #viewMode: 8 #(#mediumIcons) 8 '&Medium Icons' 1 1 nil nil nil 6210 1025 5298 2146 #viewMode: 8 #(#largeIcons) 8 '&Large Icons' 1 1 nil nil nil 6210 1025 5298 2146 #viewMode: 8 #(#tileIcons) 8 '&Tile Icons' 1 1 nil nil nil 6210 1 5298 2146 #viewMode: 8 #(#thumbnails) 8 'Thum&bnails' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 12496 4130 138 144 34 2 3106 4210 8 'Method source' 2226 0 nil 2258 7 1 4208 8 'doIt' 8 '(CardLabel text: ''Method source'' iconBlock: [Icon fromId: ''MethodSource.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 2466 #CardLabel 4208 #{Smalltalk} 1 13584 2466 #Icon #{Graphics.Icon} #{Smalltalk} 1 8 'MethodSource.ico' #fromId: #text:iconBlock: 13600 11 1 nil nil 410 #{UI.ReferenceView} 34 14 nil 12496 34 2 8 1140850688 131073 13728 nil nil nil 7 nil nil nil 13728 738 #{Tools.MethodWorkspace} #resource_Default_view nil 770 34 1 818 #createAt:extent: 34 2 866 9 53 866 1443 233 13728 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 213 2 0 0 142 0 0 0] 960 976 nil 27 3106 4210 8 'Class definition' 2226 0 nil 2258 7 1 4208 8 'doIt' 8 '(CardLabel text: ''Class definition'' iconBlock: [Icon fromId: ''ClassDefinition.ico''])' 8 #[45 30 35 113 47 32 180 106 195 105] 13680 13968 13696 8 'ClassDefinition.ico' #fromId: #text:iconBlock: 13984 11 1 nil nil 410 #{UI.ReferenceView} 34 14 nil 12496 34 2 8 1140916224 131073 14080 nil 608 nil 21 nil nil nil 14080 738 #{Tools.SmalltalkWorkspace} #resource_Default_view nil 770 34 1 818 #createAt:extent: 34 2 866 9 53 866 1443 233 14080 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 213 2 0 0 142 0 0 0] 960 976 nil 27 13728 nil nil nil 170 192 34 4 14080 8 'definition' 13728 8 'source' nil 410 #{UI.TabViewXP} 34 28 nil 12496 34 2 8 1140916736 1 14352 4802 138 144 34 2 13568 13952 nil 4880 nil nil 17 nil nil nil 14352 nil 8 1809685360 2624 2146 #iconImageIndex 8 #() 4960 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 34 3 818 #createAt:extent: 34 2 866 1 1 866 1459 293 14352 818 #setSingleSelection: 8 #(1) 14352 818 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 14352 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 217 2 0 0 146 0 0 0] 8 #() 976 nil 27 770 34 2 818 #createAt:extent: 34 2 866 1 301 866 1459 293 12496 818 #contextMenu: 34 1 12560 12496 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 150 0 0 0 217 2 0 0 40 1 0 0] 34 3 13728 14080 14352 976 nil 27 8 'cards' nil 770 34 1 818 #createAt:extent: 34 2 866 1 51 866 1459 593 2976 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 217 2 0 0 65 1 0 0] 34 3 3440 3136 12496 976 nil 27 170 192 34 4 1904 8 'statusbar' 528 8 'toolbar' nil 658246 4 #{UI.MenuBar} nil true 34 9 6162 nil true 34 8 6210 1 5298 #fileNew 8 '&New' 9373 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'NewWorkspace.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 6210 1 5298 #fileOpen 8 '&Open…' 9375 1 15250 nil true 15282 8 'OpenWorkspace.ico' 15344 65541 nil nil nil 6210 1 5298 #fileFileIn 8 '&File In…' 1 1 15250 nil true 15282 8 'FileIn.ico' 15344 65541 nil nil nil 6274 4097 6210 1 5298 #saveImage 8 'Sa&ve Image' 1 1 15250 nil true 15282 8 'Snapshot.ico' 15344 65541 nil nil nil 6210 1 5298 #smalltalkExit 8 'E&xit Dolphin' 1 1 15250 nil true 15282 8 'PowerSwitch.ico' 15344 65541 nil nil nil 6274 4097 6210 1 5298 #exit 8 '&Close' 17639 1 1378630 2 #{Graphics.TextTileIcon} $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 16975 nil nil 6162 nil true 34 13 6210 1 5298 #undo 8 '&Undo' 9397 1 15250 nil true 15282 8 'EditUndo.ico' 15344 65541 nil nil nil 6274 4097 6210 1 5298 #cutSelection 8 'Cu&t' 9393 1 15250 nil true 15282 8 'EditCut.ico' 15344 65541 nil nil nil 6210 1 5298 #copySelection 8 '&Copy' 9351 1 15250 nil true 15282 8 'EditCopy.ico' 15344 65541 nil nil nil 6210 1 5298 #pasteClipboard 8 '&Paste' 9389 1 15250 nil true 15282 8 'EditPaste.ico' 15344 65541 nil nil nil 6210 1 5298 #editDelete 8 '&Delete' 1 1 15250 nil true 15282 8 'EditClear.ico' 15344 65541 nil nil nil 6162 nil true 34 2 6210 1 5298 #reformatSource 8 '&Source' 9391 1 nil nil nil 6210 1 5298 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 16991 nil nil 6274 4097 6210 1 5298 #selectAll 8 'Select &All' 9347 1 nil nil nil 6274 4097 6210 1 5298 #editFind 8 '&Find…' 9357 1 15250 nil true 15282 8 'Find.ico' 15344 65541 nil nil nil 6210 1 5298 #findNext 8 'Find &Next' 1253 1 15250 nil true 15282 8 'FindNext.ico' 15344 65541 nil nil nil 6210 1 5298 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 17001 nil nil 6162 nil true 34 17 6210 1 5298 #browseIt 8 '&Browse It' 9349 1 15250 nil true 15282 8 'ClassBrowserShell.ico' 15344 65541 nil nil nil 6210 1 5298 #displayIt 8 '&Display It' 9353 1 15250 nil true 15282 8 'DisplayIt.ico' 15344 65541 nil nil nil 6210 1 5298 #printIt 8 '&Print It' 9377 1 15250 nil true 15282 8 'PrintIt.ico' 15344 65541 nil nil nil 6210 1 5298 #evaluateIt 8 '&Evaluate It' 9355 1 15250 nil true 15282 8 'EvaluateIt.ico' 15344 65541 nil nil nil 6210 1 5298 #inspectIt 8 '&Inspect It' 9363 1 15250 nil true 15282 8 'InspectIt.ico' 15344 65541 nil nil nil 6210 1 5298 #debugIt 8 'Deb&ug It' 1269 1 15250 nil true 15282 8 'Debugger.ico' 15344 65541 nil nil nil 6210 1 5298 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 6274 4097 6210 1 5298 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 6210 1 5298 #browseReferences 8 'Re&ferences' 5367 1 nil nil nil 6274 4097 6210 2097153 5298 #accept 8 '&Accept' 9383 1 nil nil nil 6210 1 5298 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 6274 4097 6162 nil true 34 14 6210 1 5298 #renameVariable 8 'Re&name <1d>…' 1 1 nil nil nil 6274 4097 6210 1 5298 #extractToTemporary 8 'Extract to &Temporary…' 9385 1 nil nil nil 6210 1 5298 #extractMethod 8 'E&xtract Method…' 9371 1 nil nil nil 6210 1 5298 #extractToComponent 8 'Extract to &Component…' 1 1 nil nil nil 6210 1 5298 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 6274 4097 6210 1 5298 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 6210 1 5298 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 6210 1 5298 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 6274 4097 6210 1 5298 #addParameterToMessage 8 '&Add Parameter to <1d>…' 1 1 nil nil nil 6210 1 5298 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 6210 1 5298 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 '&Refactorings' #codeRefactoringsMenu 134217729 15250 nil true 15282 8 'Refactoring.ico' 15344 65541 nil nil 17047 nil nil 6274 4097 6162 nil true 34 7 6210 1 5298 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 6210 1 5298 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 6210 1 5298 #toggleLineEndings 8 'Line &Endings' 1 1 15842 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 6210 1 5298 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 6210 1 5298 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 6210 1 5298 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 6210 1 5298 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 15250 nil true 15282 8 'Preferences.ico' 15344 65541 nil nil 17063 nil nil 8 '&Workspace' nil 134217729 nil nil 17065 nil nil 6162 nil true 34 17 6210 2097153 5298 #findClass 8 'Find…' 1 1 15250 nil true 15282 8 'FindClass.ico' 15344 65541 nil nil nil 6162 nil true 34 10 6210 1 5298 #browseClassPackage 8 'Package <1d>' 1 1 15250 nil true 15282 8 'Package.ico' 15344 65541 nil nil nil 6274 4097 6210 2097153 5298 #browseClassReferences 8 '&Class References' 1 1 nil nil nil 6162 nil true 8 #() 8 'Re&ferences To' #browseVariablesMenu 134217729 nil nil 17073 nil nil 6274 4097 6210 1 5298 #browseChangedMethods 8 'Changed &Methods' 1 1 nil nil nil 6210 1 5298 #browseMethodHistoryForClass 8 'Method &History' 1 1 15250 nil true 15282 8 'MethodHistory.ico' 15344 65541 nil nil nil 6274 4097 6210 1 5298 #browsePublishedEvents 8 'Published &events' 1 1 15250 nil true 15282 8 'Event.ico' 15344 65541 nil nil nil 6210 1 5298 #browsePublishedAspects 8 'Published &aspects' 1 1 nil nil nil 8 '&Browse' #browseMenu 134217729 nil nil 17083 nil nil 6274 4097 6210 1 5298 #newClass 8 '&New…' 1 1 15250 nil true 15282 8 'NewClass.ico' 15344 65541 nil nil nil 6210 1 5298 #removeClass 8 'Re&move' 1 1 15250 nil true 15282 8 'ClassDelete.ico' 15344 65541 nil nil nil 6162 nil true 34 18 6210 2097153 5298 #renameClass 8 'Re&name…' 1 1 15250 nil true 15282 8 'Rename.ico' 15344 65541 nil nil nil 6210 1 5298 #copyClass 8 'Cl&one…' 1 1 nil nil nil 6274 4097 6210 1 5298 #addInstanceVariable 8 'Add <1s>&Instance Variable…' 1 1 nil nil nil 6210 1 5298 #addClassVariable 8 'Add &Class Variable…' 1 1 nil nil nil 6162 nil true 8 #() 8 'Re&move Variable' #removeVariables 134217729 nil nil 17097 nil nil 6162 nil true 8 #() 8 'Ren&ame Variable' #renameVariables 134217729 nil nil 17099 nil nil 6274 4097 6162 nil true 8 #() 8 'Push &Down' #pushDownVariables 134217729 nil nil 17101 nil nil 6162 nil true 8 #() 8 'Pull &Up' #pullUpVariables 134217729 nil nil 17103 nil nil 6274 4097 6162 nil true 8 #() 8 'Cr&eate Accessors' #createVariableAccessors 134217729 nil nil 17105 nil nil 6162 nil true 8 #() 8 'A&bstract' #abstractVariables 134217729 nil nil 17107 nil nil 6162 nil true 8 #() 8 '&Protect/Concrete' #protectVariables 134217729 nil nil 17109 nil nil 6274 4097 6210 1 5298 #convertToSibling 8 'Con&vert to Sibling…' 1 1 nil nil nil 6274 4097 6210 1 5298 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 15250 nil true 15282 8 'Refactoring.ico' 15344 65541 nil nil 17115 nil nil 6274 4097 6210 1 5298 #createInstanceVariableAccessors 8 'Create &Accessors…' 1 1 nil nil nil 6210 1 5298 #reformatAll 8 'Re&format All' 1 1 nil nil nil 6274 4097 6210 1 5298 #fileInClass 8 'File &In…' 1 1 15250 nil true 15282 8 'FileIn.ico' 15344 65541 nil nil nil 6210 1 5298 #fileOutClass 8 'File &Out…' 1 1 nil nil nil 6274 4097 6210 1 5298 #classPackage 8 '&Package…' 1 1 15250 nil true 15282 8 'Package.ico' 15344 65541 nil nil nil 6210 1 5298 #categorizeClass 8 '&Category…' 1 1 15250 nil true 15282 8 'Category.ico' 15344 65541 nil nil nil 6274 4097 6162 nil true 34 4 6210 1 5298 #newView 8 '&New…' 1 1 nil nil nil 6274 4097 6162 nil true 8 #() 8 '&Edit' #viewsEditMenu 1 15250 nil true 15282 8 'ViewComposer.ico' 15344 65541 nil nil 17131 nil nil 6162 nil true 8 #() 8 '&Show' #viewsShowMenu 1 15250 nil true 15282 8 'TestView.ico' 15344 65541 nil nil 17133 nil nil 8 '&Views' #viewsMenu 134217729 15250 nil true 15282 8 'View.ico' 15344 65541 nil nil 17135 nil nil 8 '&Class' nil 134217729 nil nil 17137 nil nil 6162 nil true 34 15 6162 nil true 8 #() 8 '&Definitions of' #definitionsMenu 1 nil nil 17139 nil nil 6162 nil true 8 #() 8 'Re&ferences to' #referencesMenu 1 nil nil 17141 nil nil 6162 nil true 34 14 6210 1 5298 #browseReferencesToGlobal 8 'References to Global…' 1 1 nil nil nil 6210 1 5298 #browseContainingText 8 'C&ontaining Text…' 1 1 15250 nil true 15282 8 'SearchText.ico' 15344 65541 nil nil nil 6210 1 5298 #browseMethodCategory 8 'Cate&gory…' 1 1 15250 nil true 15282 8 'Category.ico' 15344 65541 nil nil nil 6210 1 5298 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 6210 1 5298 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 6274 4097 6210 1 5298 #browseMethodPackages 8 '&Package <s>' 1 1 15250 nil true 15282 8 'Package.ico' 15344 65541 nil nil nil 6210 1 5298 #browseMethodClasses 8 '&Class <s>' 1 1 nil nil nil 6274 4097 6210 1 5298 #browseMethodHistory 8 'Change &History' 1 1 15250 nil true 15282 8 'MethodHistory.ico' 15344 65541 nil nil nil 6210 1 5298 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 6274 4097 6210 1 5298 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 6210 1 5298 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 17165 nil nil 6274 4097 6210 1 5298 #newMethod 8 '&New' 1 1 15250 nil true 15282 8 'NewMethod.ico' 15344 65541 nil nil nil 6210 1 5298 #removeMethod 8 'Re&move' 1 1 15250 nil true 15282 8 'MethodDelete.ico' 15344 65541 nil nil nil 6162 nil true 34 16 6210 1 5298 #renameMethod 8 'Re&name' 1 1 15250 nil true 15282 8 'Rename.ico' 15344 65541 nil nil nil 6210 1 5298 #renameMethodReferences 8 'Rename Re&ferences…' 1 1 nil nil nil 6274 4097 6210 1 5298 #addParameter 8 'Add &Parameter…' 1 1 nil nil nil 6162 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 17177 nil nil 6162 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 17179 nil nil 6162 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 17181 nil nil 6274 4097 6162 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 17183 nil nil 6162 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 17185 nil nil 6274 4097 6210 1 5298 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 6210 1 5298 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 6210 1 5298 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 6210 1 5298 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 6210 1 5298 #moveMethod 8 'Move to &Component…' 1 1 nil nil nil 8 '&Refactorings' #methodRefactoringsMenu 134217729 15250 nil true 15282 8 'Refactoring.ico' 15344 65541 nil nil 17197 nil nil 6274 4097 6210 1 5298 #methodPackage 8 '&Package…' 1 1 15250 nil true 15282 8 'Package.ico' 15344 65541 nil nil nil 6162 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 17201 nil nil 6162 nil true 8 #() 8 'Remo&ve from Category' #removeCategoryMenu 134217729 nil nil 17203 nil nil 6210 1 5298 #togglePrivate 8 'Priva&te' 1 1 nil nil nil 6274 4097 6210 1 5298 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 6210 1 5298 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 17211 nil nil 6162 nil true 34 7 6210 1 5298 #undoChange 8 '&Undo <1d>' 1 1 15250 nil true 15282 8 'EditUndo.ico' 15344 65541 nil nil nil 6210 1 5298 #redoChange 8 '&Redo <1d>' 1 1 15250 nil true 15282 8 'EditRedo.ico' 15344 65541 nil nil nil 6210 1 5298 #clearChangeHistory 8 'Clear Change &History' 1 1 15250 nil true 15282 8 'MethodHistoryErase.ico' 15344 65541 nil nil nil 6274 4097 6210 1 5298 #historyBack 8 'Back to <1d>' 1 1 15250 nil true 15282 8 'HistoryBack.ico' 15344 65541 nil nil nil 6210 1 5298 #historyForward 8 'Forward to <1d>' 1 1 15250 nil true 15282 8 'HistoryForward.ico' 15344 65541 nil nil nil 6210 1 5298 #historyClear 8 'Clear Visit History' 1 1 15250 nil true 15282 8 'HistoryErase.ico' 15344 65541 nil nil nil 8 'H&istory' nil 134217729 nil nil 17225 nil nil 6162 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 17227 nil nil 6162 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 17229 nil nil 6162 nil true 34 15 6210 1 5298 #helpContents 8 '&Contents' 1025 1 15250 nil true 15282 8 'Help.ico' 15344 65541 nil nil nil 6210 1 5298 #help 8 'On this &Tool' 1249 1 nil nil nil 6210 1 5298 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 6274 4097 6210 1 5298 #learnSmalltalk 8 'Learn Smalltalk' 1 1 15842 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 6274 4097 6210 1 5298 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 6210 1 5298 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 6210 1 5298 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 6274 4097 6210 1 5298 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 15250 nil true 15282 8 '!!APPLICATION' 15344 65541 nil nil nil 6210 1 5298 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 6210 1 5298 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 6274 4097 6210 1 5298 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 15842 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 17253 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 34 2 818 #createAt:extent: 34 2 866 12287 21 866 1491 801 416 818 #text: 34 1 8 'System Browser' 416 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 232 26 0 0 154 1 0 0] 34 3 528 2976 1904 976 nil 27)!

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

