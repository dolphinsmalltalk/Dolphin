"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkToolShell subclass: #'Tools.AXComponentWizard'
	instanceVariableNames: 'typeLibs types description guid globalName prefix packageName forcePackage cards libraryName libraryPath prefixClasses buffer typelibGlobal constantsPoolName highLevelWrappers classComments tracing defineProtocols defineFunctionTables lowercaseIdentifiers verboseTracing'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.AXComponentWizard guid: (Core.GUID fromString: '{164b0031-3910-11d3-9fe6-00a0cc3e4a32}')!
Tools.AXComponentWizard comment: 'AXComponentWizard is a <SmalltalkToolShell> that manages the creation of interface classes for ActiveX components. To bring up an AXComponentWizard, open the appropriate icon in System Folder/Additional Tools/ActiveX Wizards or evaluate:

	AXComponentWizard show

When initially displayed, the AXComponentWizard presents a list of all of the current instances of <AXTypeLibraryAnalyzer> in the image. Dolphin uses <AXTypeLibraryAnalyzer>s to scan the contents of type libraries and to generate Smalltalk classes for the types they contain. Using the wizard, you can choose to generate (or re-generate) wrapper objects (usually classes) for the types at any time.

If the particular type library required is not yet installed in this image, it can be added by clicking on the ''Browse...'' button. This will bring up a  prompter allowing you to choose a type library registered on the current machine to be added to the image. An instance of AXTypeLibraryAnalyzer is created and will be assigned to a unique global should you later generate any interfaces or structures from the library.

Before generating the interface classes, the wizard allows you to choose a prefix that will be applied to the generated class names (the default is the name of the type library) and the package into which the classes will be generated. If these interface classes already exist then you may later be prompted as to whether to leave them in their current package, or move them. The globals holding the instances of <AXTypeLibraryAnalyzer> are also assigned to packages allowing them to be exported from the image along with the generated classes that they manage.

The next step is to choose the interfaces and/or structures for which you wish to generate wrapper classes. The wizard displays a list of the available interfaces and structures. Types which already have wrapper classes in the image are ticked with a check mark, but note that these may not be fully generated wrapper classes (the wizard sometimes generates empty stub classes where another wrapper class needs to refer to the type). You may choose a multiple selection of interfaces to be (re-)generated.

Click ''Generate'' to install the classes for the chosen interfaces. The operation may take some time depending on the complexity of the type library and the interfaces selected.

Instance Variables:
	typeLibs		<ListPresenter> holding the list of currently loaded type libraries.
	types		<ListPresenter> displaying a list of types for the currently selected type library.
	description	<TextPresenter> displaying the description of the currently selected type library.
	guid		<TextPresenter> displaying the GUID of the currently selected type library.
	globalName	<TextPresenter> displaying the name of the currently selected typed library.
	prefix		<TextPresenter> holding a prefix for all generated class names.
	packageName	<TextPresenter> holding a default package name into which all classes will be generated.
	forcePackage	<BooleanPresenter> reserved for future use.
	cards		<WizardCardContainer>. The container of the wizard''s card stack.
	libraryName	<TextPresenter> displaying the name of the currently selected typlib.
	libraryVersion	<TextPresenter> displaying the version of the currently selected typelib.
	libraryPath	<TextPresenter> displaying the location of the currently selected typelib.
	prefixClasses 	<BooleanPresenter>. Whether prefix will be preprended to generated class names.
	buffer 		<AspectBuffer>
	typelibGlobal 	<BooleanPresenter>. Whether a global variable will be generated to represent the typelib.
	constantsPoolName 	<TextPresenter>. Name of the <PoolConstantsDictionary> generated to hold consts from the typelib.
	highLevelWrappers 	<ChoicePresenter>. Verbosity of high-level method wrapper generation.
	classComments 	<ChoicePresenter>. Level of class comment to generate.
	tracing		<ChoicePresenter>. Tracing level.
	defineProtocols 	<BooleanPresenter>. Whether to generate Dolphin method protocols for COM interfaces.
	defineFunctionTables	<BooleanPresenter>. Whether to generate #defineFunctions methods to enable Dolphin COM servers
'!
!Tools.AXComponentWizard categoriesForClass!MVP-Presenters! !
!Tools.AXComponentWizard methodsFor!

apply
	"Private - Apply the attribute changes."

	buffer apply
!

browseIDL
	"Open a new workspace populated with the IDL for the currently selected library."

	| lib stm |
	lib := self typeLib.
	stm := ReadWriteStream on: (String new: 2048).
	lib printIDLOn: stm.
	stm reset.
	(Smalltalk developmentSystem workspaceShellClass show)
		language: #text;
		streamIn: stm!

browseTypeClass
	"Open a new class browser on the class of the selected type."

	^types selections first global browse!

browseTypesIDL
	"Open a new workspace populated with the IDL for the currently selected types."

	| stm |
	stm := ReadWriteStream on: (String new: 2048).
	types selections do: 
			[:type | 
			type printIDLOn: stm.
			stm cr].
	stm reset.
	Smalltalk developmentSystem workspaceShellClass show streamIn: stm!

cancel
	"Close the receiver without applying the changes back to the original model"

	self view close.

!

choosePackage
	"Sets the package name from a choice of all the available packages"

	| oldPkg |
	oldPkg := packageName value isEmpty
				ifTrue: [nil]
				ifFalse: [Package manager packageNamed: packageName value ifNone: []].
	(PackagePrompter
		showModalOn: oldPkg asValue
		caption: 'Select default package...'
		default: nil)
			ifNotNil: [:choice | packageName value: (choice = Package uncommitted ifTrue: [''] ifFalse: [choice name])]!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	"Page 1"
	typeLibs := self add: ListPresenter new name: 'typeLibs'.
	description := self add: TextPresenter new name: 'description'.
	guid := self add: TextPresenter new name: 'guid'.

	"Page 2"
	libraryName := self add: TextPresenter new name: 'libraryName'.
	libraryPath := self add: TextPresenter new name: 'libraryPath'.
	prefix := self add: TextPresenter new name: 'prefix'.
	prefixClasses := self add: BooleanPresenter new name: 'prefixClasses'.
	packageName := self add: TextPresenter new name: 'packageName'.
	typelibGlobal := self add: BooleanPresenter new name: 'generateTypelib'.
	globalName := self add: TextPresenter new name: 'globalName'.
	constantsPoolName := self add: TextPresenter new name: 'constantsPoolName'.
	highLevelWrappers := self add: ((ChoicePresenter new)
						choices: Smalltalk.AXTypeLibraryAnalyzer highLevelWrapperStyles asSortedCollection;
						yourself)
				name: 'highLevelWrappers'.
	classComments := self add: ((ChoicePresenter new)
						choices: Smalltalk.AXTypeLibraryAnalyzer classCommentStyles asSortedCollection;
						yourself)
				name: 'commentGeneration'.
	tracing := self add: ((ChoicePresenter new)
						choices: Smalltalk.AXTypeLibraryAnalyzer tracingStyles asSortedCollection;
						yourself)
				name: 'tracing'.
	verboseTracing := self add: BooleanPresenter new name: 'verboseTrace'.
	defineProtocols := self add: BooleanPresenter new name: 'defineProtocols'.
	defineFunctionTables := self add: BooleanPresenter new name: 'defineFunctions'.
	lowercaseIdentifiers := self add: BooleanPresenter new name: 'lowercaseKeywords'.

	"Page 3 - The list of interfaces, etc"
	types := self add: ListPresenter new name: 'interfaces'.

	"Future use"
	forcePackage := self add: BooleanPresenter new name: 'forcePackage'!

createSchematicWiring
	"Create the trigger wiring for the receiver"
	
	super createSchematicWiring.
	typeLibs when: #selectionChanged send: #onTypeLibrarySelected to: self.

	prefixClasses when: #valueChanged send: #updateClassPrefix to: self.
	typelibGlobal when: #valueChanged send: #updateTypelibGlobal to: self


	!

displayInstalledTypeLib: typelib 
	"Private - Populate the receiver with details from the <AXTypeLibraryAnalyzer>, typelib."

	self updateTypesList: typelib.
	buffer := AspectBuffer subject: typelib.
	prefix model: (buffer aspectValue: #prefix).
	prefixClasses model: (buffer aspectValue: #prefixGlobalNames).
	packageName model: (buffer aspectValue: #packageName).
	typelib definesSymbolicConstants 
		ifTrue: 
			[constantsPoolName model: (buffer aspectValue: #constantsPoolName).
			constantsPoolName view enable]
		ifFalse: 
			[constantsPoolName model: nil.
			constantsPoolName view disable].
	typelibGlobal model: (buffer aspectValue: #generateTypelibGlobal).
	highLevelWrappers model: (buffer aspectValue: #highLevelWrappers).
	classComments model: (buffer aspectValue: #classComments).
	tracing model: (buffer aspectValue: #tracing).
	verboseTracing model: (buffer aspectValue: #isTracingVerbose).
	defineProtocols model: (buffer aspectValue: #defineMethodProtocols).
	defineFunctionTables model: (buffer aspectValue: #defineFunctionTables).
	lowercaseIdentifiers model: (buffer aspectValue: #forceLowercaseIdentifiers).

	"Read-only aspects"
	guid value: typelib guid asString.
	libraryPath value: typelib path.
	globalName value: typelib globalName.
	description value: typelib helpstring.
	libraryName value: typelib name.
	self
		updateClassPrefix;
		updateTypelibGlobal.

	"Pre-select the interfaces that have not yet been installed"
	self selectUninstalled!

finish
	"Close the receiver applying the changes back to the original model."

	self apply.
	self view close.

!

generate
	"Apply the attribute changes and attempt to generate the requested interfaces"

	| typeLibrary selected progress step |
	self apply.
	typeLibrary := self typeLib.
	typeLibrary prefix: prefix value.
	typeLibrary packageName: packageName value.
	selected := types selections.
	step := 100 / selected size.
	progress := ProgressDialog create.
	progress operation: 
			[:p | 
			
			[selected keysAndValuesDo: 
					[:i :each | 
					| pct |
					pct := (i * step) rounded.
					progress text: 'Generating ' , each globalName.
					each generate.
					p value: pct]] 
					on: OperationAborted
					do: 
						[:ex | 
						ex toTrace.
						typeLibrary reset]].
	progress caption: 'Please wait...'.
	progress showModal.
	types view updateAll!

inspectIt
	"Open an inspector on the currently selected library or type."

	self perform: self inspectItCommand!

inspectItCommand

	| focus |
	focus := View focus.
	focus == typeLibs view ifTrue: [^#inspectLibrary].
	focus == types view view ifTrue: [^#inspectType].
	^nil!

inspectLibrary
	"Open an inspector on the <AXTypeLibraryAnalyzer> representing the currently
	selected library."

	self typeLib inspect!

inspectType
	| selections |
	selections := types selections.
	(selections size = 1 ifTrue: [selections first] ifFalse: [selections]) inspect!

libraryListNextCard
	"The user has selected a library and is desirous of moving to the next card."

	^cards nextCard!

loadTypeLib
	"Prompts for a new type library to load. The result is that a new AXTypeLibraryAnalyzer is 
	instantiated but is not assigned to any global or package."

	| tlb |
	"Instantiate a new AXTypeLibraryAnalyser. The existence of this (assigned to a temporary)
	is sufficient to allow the receiver to display the library on a refresh. Note that, if the receiver
	is closed without Applying the changes, then the loaded analyzer will be GC'd and will
	not appear in subsequent invocations of the AXComponent wizard"
	tlb := AXTypeLibraryPrompter showModal.
	self refresh.
	self typeLib: tlb.
	typeLibs setFocus!

onTypeLibrarySelected
	"Private - A type library has been selected. Refresh the information about
	it, including the list of available interfaces."

	self invalidateUserInterface.
	self typeLib 
		ifNil: 
			[libraryPath clear.
			guid clear]
		ifNotNil: 
			[:tlb | 
			tlb isInstalled 
				ifTrue: [^self displayInstalledTypeLib: tlb]
				ifFalse: 
					[guid value: tlb guid asString.
					libraryPath value: '<not currently installed>']].
	types clear.
	globalName clear.
	description clear.
	prefix clear.
	packageName clear.
	libraryName clear!

onViewOpened
	"Received when the receiver's view is been connected. Refresh the
	list of current type libraries"

	super onViewOpened.
	cards := self view viewNamed: 'cards'.
	self refresh.
	typeLibs setFocus!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery>."

	| selected cmd lib |
	cmd := aCommandQuery commandSymbol.
	lib := self typeLib.
	#inspectIt == cmd 
		ifTrue: 
			[cmd := self inspectItCommand.
			cmd isNil 
				ifTrue: 
					[aCommandQuery isEnabled: false.
					^false]].
	#typeLibHelp == cmd 
		ifTrue: 
			[aCommandQuery isEnabled: (lib notNil and: [lib helpfile notEmpty]).
			^true].
	#libraryListNextCard == cmd 
		ifTrue: 
			[aCommandQuery isEnabled: (lib notNil and: [lib isInstalled]).
			^true].
	(#(#choosePackage #browseIDL #inspectLibrary) identityIncludes: cmd) 
		ifTrue: 
			[aCommandQuery isEnabled: lib notNil.
			^true].
	selected := types selections.
	(#(#generate #browseTypesIDL #inspectType) identityIncludes: cmd) 
		ifTrue: 
			[aCommandQuery isEnabled: selected notEmpty.
			^true].
	#browseTypeClass == cmd 
		ifTrue: 
			[aCommandQuery isEnabled: (selected size = 1 and: [selected first isGlobalDefined]).
			^true].
	^super queryCommand: aCommandQuery!

refresh
	"Refresh the list of current AXTypeLibraryAnalyzers in the image"

	typeLibs list: (Smalltalk.AXTypeLibraryAnalyzer allOpenableTypeLibs
				asSortedCollection: [:x :y | x name < y name])!

selectInstalled
	"In the types list, select those interfaces that have already been
	generated into this image"

	types selections: (types list select: [:each | each isInstalled])!

selectUninstalled
	"In the types list, select those types that have not yet been
	generated into this image"

	types selections: (types list reject: [:each | each isInstalled])!

typeLib
	"Answer the current selected type library, or nil if there is no selection."

	^typeLibs selectionOrNil!

typeLib: aTypeLibraryAnalyzerOrNil
	"Sets the current selected type library to aTypeLibraryAnalyzerOrNil"

	typeLibs selectionOrNil: aTypeLibraryAnalyzerOrNil!

typeLibHelp
	"Open the selected type-libraries help file."

	OS.ShellLibrary default shellOpen: self typeLib helpfile!

updateClassPrefix
	"Private - The user has toggled on/off generation of the global variable to hold the currently selected type library."

	(prefix view)
		refreshContents;
		isEnabled: prefixClasses value!

updateTypelibGlobal
	"Private - The user has toggled on/off generation of the global variable to hold the currently selected type library."

	globalName view isEnabled: typelibGlobal value!

updateTypesList: typelib
	"Private - Populate the receiver's list of types that can be generated from the 
	<AXTypeLibraryAnalyzer>, typelib."

	| list |
	typelib clearCachedAnalyzers.
	list := Array writeStream.
	list
		nextPutAll: typelib generatableInterfaces;
		nextPutAll: typelib namedStructs;
		nextPutAll: typelib generatableModules;
		nextPutAll: typelib namedUnions.
	types list: (list contents asSortedCollection: [:a :b | a name <= b name])! !
!Tools.AXComponentWizard categoriesFor: #apply!operations!private! !
!Tools.AXComponentWizard categoriesFor: #browseIDL!commands!public! !
!Tools.AXComponentWizard categoriesFor: #browseTypeClass!commands!public! !
!Tools.AXComponentWizard categoriesFor: #browseTypesIDL!commands!public! !
!Tools.AXComponentWizard categoriesFor: #cancel!commands!public! !
!Tools.AXComponentWizard categoriesFor: #choosePackage!commands!public! !
!Tools.AXComponentWizard categoriesFor: #createComponents!initializing!public! !
!Tools.AXComponentWizard categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.AXComponentWizard categoriesFor: #displayInstalledTypeLib:!private!updating! !
!Tools.AXComponentWizard categoriesFor: #finish!commands!public! !
!Tools.AXComponentWizard categoriesFor: #generate!commands!public! !
!Tools.AXComponentWizard categoriesFor: #inspectIt!commands!public! !
!Tools.AXComponentWizard categoriesFor: #inspectItCommand!public! !
!Tools.AXComponentWizard categoriesFor: #inspectLibrary!commands!public! !
!Tools.AXComponentWizard categoriesFor: #inspectType!public! !
!Tools.AXComponentWizard categoriesFor: #libraryListNextCard!commands!public! !
!Tools.AXComponentWizard categoriesFor: #loadTypeLib!commands!public! !
!Tools.AXComponentWizard categoriesFor: #onTypeLibrarySelected!event handling!private! !
!Tools.AXComponentWizard categoriesFor: #onViewOpened!event handling!public! !
!Tools.AXComponentWizard categoriesFor: #queryCommand:!commands!private! !
!Tools.AXComponentWizard categoriesFor: #refresh!commands!public! !
!Tools.AXComponentWizard categoriesFor: #selectInstalled!commands!public! !
!Tools.AXComponentWizard categoriesFor: #selectUninstalled!commands!public! !
!Tools.AXComponentWizard categoriesFor: #typeLib!accessing!public! !
!Tools.AXComponentWizard categoriesFor: #typeLib:!accessing!public! !
!Tools.AXComponentWizard categoriesFor: #typeLibHelp!commands!public! !
!Tools.AXComponentWizard categoriesFor: #updateClassPrefix!private!updating! !
!Tools.AXComponentWizard categoriesFor: #updateTypelibGlobal!private!updating! !
!Tools.AXComponentWizard categoriesFor: #updateTypesList:!private!updating! !

!Tools.AXComponentWizard class methodsFor!

defaultAdditionalAccelerators
	^super defaultAdditionalAccelerators 
		, #(#(#help 'F1') #(#refresh 'F5') #(#selectAll 'Ctrl+A') #(#inspectIt 'Ctrl+I'))!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'COM Component Wizard'!

icon
	"Answers an Icon that can be used to represent this class."

	^Smalltalk.AXTypeLibraryAnalyzer icon!

initialize
	"Private - Initialize the receiver.

		self initialize.
	"

	Smalltalk developmentSystem
		addAdditionalToolsFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self reuseIfOpen: true!

registerServer
	"Browse for a DLL, and register it as a COM component
		self registerServer
	"

	| dllpath entrypoint |
	dllpath := FileOpenDialog new
				fileTypes: #(#('Components (*.dll,*.ocx)' '*.dll;*.ocx') #('All Files (*.*)' '*.*'));
				defaultExtension: 'dll';
				showModal.
	dllpath isNil ifTrue: [^nil].
	entrypoint := #DllRegisterServer.
	
	[| lib |
	lib := External.DynamicLinkLibrary open: dllpath.
	
	[| method proc |
	proc := lib getProcAddress: entrypoint
				ifAbsent: 
					[self
						error: ('<1s> was loaded but the <2s> entry point could not be found.<n><n>This file cannot be registered'
								expandMacrosWith: dllpath
								with: entrypoint)].
	method := (lib class compiledMethodAt: #DllRegisterServer) copy.
	method literalAt: 1
		put: ((method literalAt: 1) copy
				dwordAtOffset: 0 put: proc;
				yourself).
	method value: lib withArguments: #()]
			ensure: [lib close].
	MessageBox new notify: ('<1s> in <2s> succeeded.' expandMacrosWith: entrypoint with: dllpath)]
			on: Error
			do: [:each | MessageBox errorMsg: each description]!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 37 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 nil nil nil nil 410 ##(UI.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 853318 1 ##(UI.CardLayout) 138 144 34 3 1049094 ##(Core.Association) 8 '1' 410 ##(UI.ContainerView) 34 15 nil 640 34 2 8 1140850688 131073 816 nil nil nil 7 nil nil nil 816 610 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 816 34 2 8 1140850688 131073 896 nil nil nil 7 nil nil nil 896 1048838 ##(UI.FramingLayout) 170 176 34 6 410 ##(UI.StaticRectangle) 34 14 nil 896 34 2 8 1140916487 262145 1024 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1024 nil 8 1801195232 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 1 1 578 689 5 1024 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 578 193 193 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 1 1394 #fixedParentRight 1 1394 #fixedParentTop 1 1394 #fixedViewTop 5 410 ##(UI.PushButton) 34 20 nil 896 34 2 8 1140924416 1 1472 nil 1104 nil 7 nil nil nil 1472 nil 8 1801347024 1377606 4 ##(UI.CommandDescription) #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 545 31 578 141 51 1472 1202 #isEnabled: 8 #(false) 1472 1202 #text: 34 1 8 'Cancel' 1472 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 15 0 0 0 86 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1394 #fixedViewRight -139 1424 -3 1440 31 1456 51 410 ##(UI.PushButton) 34 20 nil 896 34 2 8 1140924416 1 1872 nil 1104 nil 7 nil nil nil 1872 nil 8 1801347024 1554 #libraryListNextCard 8 '&Next >' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 385 31 578 141 51 1872 1202 #isEnabled: 8 #(false) 1872 1202 #text: 34 1 8 '&Next >' 1872 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -163 1440 31 1456 51 170 192 8 #() nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 723 578 689 81 896 1202 #text: 34 1 8 'Buttons' 896 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 3 1872 1472 1024 1344 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 816 34 2 8 1140850688 131073 2480 nil nil nil 7 nil nil nil 2480 962 170 176 34 12 410 ##(UI.PushButton) 34 20 nil 2480 34 2 8 1140924416 1 2592 nil 1104 nil 7 nil nil nil 2592 nil 8 1801347024 1554 #loadTypeLib 8 'Bro&wse...' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 535 507 578 141 51 2592 1202 #isEnabled: 8 #(false) 2592 1202 #text: 34 1 8 'Bro&wse...' 2592 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -13 1394 #fixedViewBottom -49 1394 #fixedParentBottom -165 410 ##(UI.StaticText) 34 16 nil 2480 34 2 8 1140850946 1 2992 nil nil nil 7 nil nil nil 2992 nil 8 1801195232 1049094 ##(UI.NullConverter) nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 577 578 111 51 2992 1202 #text: 34 1 8 '&Location:' 2992 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 8 #() 1344 nil 27 1362 1408 1 1394 #fixedViewLeft 111 2960 -49 2976 -95 410 ##(UI.StaticText) 34 16 nil 2480 34 2 8 1140850944 1 3344 nil nil nil 7 nil nil nil 3344 nil 8 1801195232 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 131 577 578 631 61 3344 1202 #text: 34 1 8 'Path of selected library here...
on two lines if necessary.' 3344 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 32 1 0 0 124 1 0 0 62 1 0 0] 8 #() 1344 nil 27 1362 1408 131 3328 631 2960 -59 2976 -85 410 ##(UI.ListView) 34 45 nil 2480 34 2 8 1140953165 1025 3664 787270 2 ##(UI.ListModel) 138 144 2256 nil 1769478 ##(Kernel.IdentitySearchPolicy) 1104 nil 7 461638 4 ##(UI.Menu) nil true 34 3 1180742 2 ##(UI.CommandMenuItem) 1 1554 #browseIDL 8 '&Browse IDL' 1 1 nil nil nil 3858 1 1554 #inspectLibrary 8 '&Inspect' 1 1 nil nil nil 3858 1 1554 #typeLibHelp 8 '&Help' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3664 nil 8 1801282304 ##(UI.BasicListAbstract) nil 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 3 1117254 5 ##(UI.ListViewColumn) 8 'Library' 251 #left ##(UI.BasicListAbstract) 786950 ##(Core.Message) #<= 8 #() 4162 #name 8 #() nil 3664 nil 1 nil nil 4114 8 'Version' 101 #left 4162 #versionString 8 #() 4162 #<= 8 #() nil nil 3664 nil 1 nil nil 4114 8 'Description' 327 #left ##(UI.BasicListAbstract) 4162 #<= 8 #() 4162 #helpstring 4288 nil 3664 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 1 1 578 685 487 3664 1202 #contextMenu: 34 1 3824 3664 1202 #text: 34 1 8 'Library' 3664 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 8 #() 1344 nil 35 1362 1408 1 1424 -3 1440 1 2976 -235 410 ##(UI.StaticText) 34 16 nil 2480 34 2 8 1140850946 1 4688 nil nil nil 7 nil nil nil 4688 nil 8 1801195232 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 657 578 111 41 4688 1202 #text: 34 1 8 '&GUID:' 4688 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 8 #() 1344 nil 27 1362 1408 1 3328 111 2960 -39 2976 -25 410 ##(UI.StaticText) 34 16 nil 2480 34 2 8 1140850944 1 5008 nil nil nil 7 nil nil nil 5008 nil 8 1801195232 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 131 657 578 631 41 5008 1202 #text: 34 1 8 'GUID of selected library here...' 5008 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 72 1 0 0 124 1 0 0 92 1 0 0] 8 #() 1344 nil 27 1362 1408 131 3328 631 2960 -39 2976 -25 170 192 34 6 3344 8 'libraryPath' 5008 8 'guid' 3664 8 'typeLibs' nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 1 1 578 689 723 2480 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 6 3664 2592 2992 3344 4688 5008 1344 nil 27 170 192 34 2 2480 8 'Libraries' nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 1 578 689 803 816 1202 #text: 34 1 8 'Step 1' 816 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 2480 896 1344 nil 27 770 8 '2' 410 ##(UI.ContainerView) 34 15 nil 640 34 2 8 1140850688 131073 5856 nil nil nil 5 nil nil nil 5856 610 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 5856 34 2 8 1140850688 131073 5936 nil nil nil 5 nil nil nil 5936 962 170 176 34 8 410 ##(UI.PushButton) 34 20 nil 5936 34 2 8 1140924416 1 6048 nil 1104 nil 5 nil nil nil 6048 nil 8 1801347024 1554 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 245 31 578 141 51 6048 1202 #isEnabled: 8 #(false) 6048 1202 #text: 34 1 8 '< &Back' 6048 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -303 1440 31 1456 51 410 ##(UI.PushButton) 34 20 nil 5936 34 2 8 1140924416 1 6416 nil 1104 nil 5 nil nil nil 6416 nil 8 1801347024 1554 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 549 31 578 141 51 6416 1202 #isEnabled: 8 #(false) 6416 1202 #text: 34 1 8 'Cancel' 6416 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 1 1440 31 1456 51 410 ##(UI.StaticRectangle) 34 14 nil 5936 34 2 8 1140916487 262145 6784 nil 1104 nil 5 nil nil nil 6784 nil 8 1801195232 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 1 1 578 689 5 6784 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1344 nil 27 1362 1408 1 1424 1 1440 1 1456 5 410 ##(UI.PushButton) 34 20 nil 5936 34 2 8 1140924416 1 7040 nil 1104 nil 5 nil nil nil 7040 nil 8 1801347024 1554 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 385 31 578 141 51 7040 1202 #text: 34 1 8 '&Next >' 7040 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -163 1440 31 1456 51 170 192 2256 nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 723 578 689 81 5936 1202 #text: 34 1 8 'Buttons' 5936 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 4 6048 7040 6416 6784 1344 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 5856 34 2 8 1140850688 131073 7600 nil nil nil 5 nil nil nil 7600 962 170 176 34 40 410 ##(UI.CheckBox) 34 16 nil 7600 34 2 8 1140924419 1 7712 918598 2 ##(UI.ValueHolder) nil nil 1572870 ##(Kernel.NeverSearchPolicy) false nil nil 5 nil nil nil 7712 nil 8 1801347024 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 41 131 578 241 43 7712 1202 #text: 34 1 8 'Typelib &global:' 7712 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 65 0 0 0 140 0 0 0 86 0 0 0] 8 #() 1344 nil 27 1362 1408 41 3328 241 1440 131 1456 43 410 ##(UI.TextEdit) 34 16 nil 7600 34 2 8 1140916224 1025 8096 nil 1104 nil 5 nil nil nil 8096 nil 8 1801338832 3074 nil nil 1 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 291 11 578 335 41 8096 1202 #setMarginWidths: 34 1 8 #(3 3) 8096 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 5 0 0 0 56 1 0 0 25 0 0 0] 8 #() 1344 nil 27 1362 1408 291 1424 -63 1440 11 1456 41 410 ##(UI.CheckBox) 34 16 nil 7600 34 2 8 1140924419 1 8416 7778 nil nil 7824 false nil nil 5 nil nil nil 8416 nil 8 1801347024 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 51 11 578 211 43 8416 1202 #text: 34 1 8 'Class pre&fix:' 8416 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 0 0 0 5 0 0 0 130 0 0 0 26 0 0 0] 8 #() 1344 nil 27 1362 1408 51 3328 211 1440 11 1456 43 410 ##(UI.GroupBox) 34 14 nil 7600 34 2 8 1140850695 65 8752 nil nil nil 5 nil nil nil 8752 nil 8 1801347024 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 43 431 578 621 101 8752 1202 #text: 34 1 8 '&Tracing:' 8752 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 21 0 0 0 215 0 0 0 75 1 0 0 9 1 0 0] 8 #() 1344 nil 27 1362 1408 43 3328 621 1440 431 1456 101 410 ##(UI.CheckBox) 34 16 nil 7600 34 2 8 1140924451 1 9056 7778 nil nil 7824 false nil nil 5 nil nil nil 9056 nil 8 1801347024 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 639 578 411 61 9056 1202 #text: 34 1 8 '&Lowercase secondary keywords' 9056 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 63 1 0 0 235 0 0 0 93 1 0 0] 8 #() 1344 nil 27 1362 1408 61 3328 411 1440 639 1456 61 410 ##(UI.StaticText) 34 16 nil 7600 34 2 8 1140850944 65 9392 nil nil nil 5 nil nil nil 9392 nil 8 1801195232 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 321 578 281 41 9392 1202 #text: 34 1 8 '&Class Comments:' 9392 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 160 0 0 0 170 0 0 0 180 0 0 0] 8 #() 1344 nil 27 1362 1408 61 3328 281 1440 321 1456 41 410 ##(UI.GroupBox) 34 14 nil 7600 34 2 8 1140850695 65 9712 nil nil nil 5 nil nil nil 9712 nil 8 1801347024 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 13 271 578 665 441 9712 1202 #text: 34 1 8 'Ad&vanced' 9712 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 135 0 0 0 82 1 0 0 99 1 0 0] 8 #() 1344 nil 27 1362 1408 13 1424 -11 1440 271 1456 441 410 ##(UI.ComboBox) 34 17 nil 7600 34 2 8 1144063491 1025 10016 3730 138 144 2256 nil 3792 1104 nil 5 nil nil nil 10016 nil 8 1801138208 ##(UI.BasicListAbstract) 4416 151 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 441 321 578 185 47 10016 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 160 0 0 0 56 1 0 0 183 0 0 0] 8 #() 1344 nil 27 1362 1408 441 1424 -63 1440 321 1456 41 410 ##(UI.StaticText) 34 16 nil 7600 34 2 8 1140850944 1 10304 nil nil nil 5 nil nil nil 10304 nil 8 1801195232 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 81 71 578 181 31 10304 1202 #text: 34 1 8 'Default &Package:' 10304 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 35 0 0 0 130 0 0 0 50 0 0 0] 8 #() 1344 nil 27 1362 1408 81 3328 181 1440 71 1456 31 410 ##(UI.ComboBox) 34 17 nil 7600 34 2 8 1144063491 1025 10624 3730 138 144 2256 nil 3792 1104 nil 5 nil nil nil 10624 nil 8 1801138208 ##(UI.BasicListAbstract) 4416 101 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 441 381 578 185 47 10624 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 190 0 0 0 56 1 0 0 213 0 0 0] 8 #() 1344 nil 27 1362 1408 441 1424 -63 1440 381 1456 41 410 ##(UI.ComboBox) 34 17 nil 7600 34 2 8 1144063491 1025 10912 3730 138 144 2256 nil 3792 1104 nil 5 nil nil nil 10912 nil 8 1801138208 ##(UI.BasicListAbstract) 4416 401 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 61 471 578 185 47 10912 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 235 0 0 0 122 0 0 0 2 1 0 0] 8 #() 1344 nil 27 1362 1408 61 1424 -443 1440 471 1456 43 410 ##(UI.TextEdit) 34 16 nil 7600 34 2 8 1140916352 1025 11200 nil 1104 nil 5 nil nil nil 11200 nil 8 1801338832 3074 nil nil 1 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 291 191 578 335 41 11200 1202 #setMarginWidths: 34 1 8 #(3 3) 11200 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 95 0 0 0 56 1 0 0 115 0 0 0] 8 #() 1344 nil 27 1362 1408 291 1424 -63 1440 191 1456 41 410 ##(UI.StaticText) 34 16 nil 7600 34 2 8 1140850944 1 11520 nil nil nil 5 nil nil nil 11520 nil 8 1801195232 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 381 578 371 41 11520 1202 #text: 34 1 8 '&High-level wrapper methods:' 11520 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 190 0 0 0 215 0 0 0 210 0 0 0] 8 #() 1344 nil 27 1362 1408 61 3328 371 1440 381 1456 41 410 ##(UI.CheckBox) 34 16 nil 7600 34 2 8 1140928291 1 11840 7778 nil nil 7824 false nil nil 5 nil nil nil 11840 nil 8 1801347024 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 421 471 578 211 41 11840 1202 #text: 34 1 8 'Verbose?' 11840 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 235 0 0 0 59 1 0 0 255 0 0 0] 8 #() 1344 nil 27 1362 1408 421 3328 211 1440 471 1456 41 410 ##(UI.CheckBox) 34 16 nil 7600 34 2 8 1140924451 1 12176 7778 nil nil 7824 false nil nil 5 nil nil nil 12176 nil 8 1801347024 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 539 578 411 61 12176 1202 #text: 34 1 8 'Define Method &Protocols:' 12176 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 13 1 0 0 235 0 0 0 43 1 0 0] 8 #() 1344 nil 27 1362 1408 61 3328 411 1440 539 1456 61 410 ##(UI.TextEdit) 34 16 nil 7600 34 2 8 1140916224 1025 12512 nil 1104 nil 5 nil nil nil 12512 nil 8 1801338832 3074 nil nil 1 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 291 71 578 335 41 12512 1202 #setMarginWidths: 34 1 8 #(3 3) 12512 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 35 0 0 0 56 1 0 0 55 0 0 0] 8 #() 1344 nil 27 1362 1408 291 1424 -63 1440 71 1456 41 410 ##(UI.StaticText) 34 16 nil 7600 34 2 8 1140850944 1 12832 nil nil nil 5 nil nil nil 12832 nil 8 1801195232 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 81 191 578 171 43 12832 1202 #text: 34 1 8 'C&onstants pool:' 12832 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 95 0 0 0 125 0 0 0 116 0 0 0] 8 #() 1344 nil 27 1362 1408 81 3328 171 1440 191 1456 43 410 ##(UI.PushButton) 34 20 nil 7600 34 2 8 1140924416 1 13152 nil 1104 nil 5 nil nil nil 13152 nil 8 1801347024 1554 #choosePackage 8 '...' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 645 71 578 41 41 13152 1202 #isEnabled: 8 #(false) 13152 1202 #text: 34 1 8 '...' 13152 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 66 1 0 0 35 0 0 0 86 1 0 0 55 0 0 0] 8 #() 1344 nil 29 1362 1856 -39 1424 -3 1440 71 1456 41 410 ##(UI.StaticText) 34 16 nil 7600 34 2 8 1140916480 1025 13520 nil nil nil 5 nil nil nil 13520 nil 8 1801195232 3074 nil nil nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 291 131 578 335 41 13520 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 65 0 0 0 56 1 0 0 85 0 0 0] 8 #() 1344 nil 27 1362 1408 291 1424 -63 1440 131 1456 41 410 ##(UI.CheckBox) 34 16 nil 7600 34 2 8 1140924451 1 13792 7778 nil nil 7824 false nil nil 5 nil nil nil 13792 nil 8 1801347024 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 589 578 411 61 13792 1202 #text: 34 1 8 'Generate #&defineFunctions:' 13792 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 38 1 0 0 235 0 0 0 68 1 0 0] 8 #() 1344 nil 27 1362 1408 61 3328 411 1440 589 1456 61 170 192 34 26 13520 8 'globalName' 9056 8 'lowercaseKeywords' 11200 8 'constantsPoolName' 12512 8 'packageName' 10016 8 'commentGeneration' 10912 8 'tracing' 13792 8 'defineFunctions' 11840 8 'verboseTrace' 8096 8 'prefix' 7712 8 'generateTypelib' 8416 8 'prefixClasses' 12176 8 'defineProtocols' 10624 8 'highLevelWrappers' nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 1 578 689 723 7600 1202 #text: 34 1 8 'Generation Parameters' 7600 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 20 8416 8096 10304 12512 13152 12832 7712 13520 11200 9712 9392 10016 11520 10624 8752 10912 11840 12176 13792 9056 1344 nil 27 170 192 2256 nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 1 578 689 803 5856 1202 #text: 34 1 8 'Step 2' 5856 1282 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 7600 5936 1344 nil 27 770 8 '3' 410 ##(UI.ContainerView) 34 15 nil 640 34 2 8 1140850688 131073 14832 nil nil nil 5 nil nil nil 14832 610 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 14832 34 2 8 1140850688 131073 14912 nil nil nil 5 nil nil nil 14912 962 170 176 34 8 410 ##(UI.PushButton) 34 20 nil 14912 34 2 8 1140924416 1 15024 nil 1104 nil 5 nil nil nil 15024 nil 8 1801347024 1554 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 245 31 578 141 51 15024 1202 #isEnabled: 8 #(false) 15024 1202 #text: 34 1 8 '< &Back' 15024 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -303 1440 31 1456 51 410 ##(UI.PushButton) 34 20 nil 14912 34 2 8 1140924416 1 15392 nil 1104 nil 5 nil nil nil 15392 nil 8 1801347024 1554 #finish 8 '&Finish' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 385 31 578 141 51 15392 1202 #isEnabled: 8 #(false) 15392 1202 #text: 34 1 8 '&Finish' 15392 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -163 1440 31 1456 51 410 ##(UI.PushButton) 34 20 nil 14912 34 2 8 1140924416 1 15760 nil 1104 nil 5 nil nil nil 15760 nil 8 1801347024 1554 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 539 31 578 151 51 15760 1202 #isEnabled: 8 #(false) 15760 1202 #text: 34 1 8 'Cancel' 15760 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -149 1424 1 1440 31 1456 51 410 ##(UI.StaticRectangle) 34 14 nil 14912 34 2 8 1140916487 262145 16128 nil 1104 nil 5 nil nil nil 16128 nil 8 1801195232 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 1 1 578 689 5 16128 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1344 nil 27 1362 1408 1 1424 1 1440 1 1456 5 170 192 2256 nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 723 578 689 81 14912 1202 #text: 34 1 8 'Buttons' 14912 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 4 15024 15392 15760 16128 1344 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 14832 34 2 8 1140850688 131073 16608 nil nil nil 5 nil nil nil 16608 962 170 176 34 4 410 ##(UI.ListView) 34 45 nil 16608 34 2 8 1140920393 1025 16720 3730 138 144 2256 nil 3792 1104 nil 5 3810 nil true 34 6 3858 1 1554 #selectAll 8 'Select &All' 1 1 nil nil nil 3858 1 1554 #selectInstalled 8 'Select &Installed' 1 1 nil nil nil 3858 1 1554 #selectUninstalled 8 'Select &Uninstalled' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 3858 1 1554 #browseTypeClass 8 'Browse &Class' 1 1 nil nil nil 3858 1 1554 #browseTypesIDL 8 '&Browse IDL' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 16720 nil 8 1801282304 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 4064 nil 4162 #helpstring 8 #() nil 578 65 65 nil nil 138 144 34 3 4114 8 'Name' 437 #left ##(UI.BasicListAbstract) 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] #name 17280 7 513 nil nil nil 16720 ##(UI.IconicListAbstract) 3 nil nil 4114 8 '' 41 #left nil 17266 0 nil 17298 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 17408 7 513 nil 17266 0 nil 17298 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:each | each isInstalled]' 8 #[30 105 17 158 106] #isInstalled 17488 7 257 nil nil 16720 ##(UI.IconicListAbstract) 1 nil nil 4114 8 'Type' 201 #left ##(UI.BasicListAbstract) 4162 #<= 8 #() 17266 0 nil 17298 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:each | each idlKeyword]' 8 #[30 105 17 158 106] #idlKeyword 17632 7 257 nil nil 16720 nil 1 nil nil #report 4416 nil 133157 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1138 138 144 34 4 1202 #createAt:extent: 34 2 578 1 1 578 685 617 16720 1202 #contextMenu: 34 1 16816 16720 1202 #text: 34 1 8 'Name' 16720 1202 #columnOrder: 34 1 8 #(2 1 3) 16720 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 52 1 0 0] 8 #() 1344 nil 35 1362 1408 1 1424 -3 1440 1 2976 -105 410 ##(UI.PushButton) 34 20 nil 16608 34 2 8 1140924416 1 18016 nil 1104 nil 5 nil nil nil 18016 nil 8 1801347024 1554 #generate 8 '&Generate' 1 1 nil nil true nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 535 647 578 141 51 18016 1202 #isEnabled: 8 #(false) 18016 1202 #text: 34 1 8 '&Generate' 18016 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 67 1 0 0 81 1 0 0 92 1 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -13 2960 -49 2976 -25 170 192 34 2 16720 8 'interfaces' nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 1 1 578 689 723 16608 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 2 16720 18016 1344 nil 27 170 192 34 2 16608 8 'Classes' nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 1 578 689 803 14832 1202 #text: 34 1 8 'Step 3' 14832 1282 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 16608 14912 1344 nil 27 816 nil nil nil 170 192 2256 nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 21 21 578 689 803 640 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 155 1 0 0] 34 3 816 5856 14832 1344 nil 27 170 192 34 2 640 8 'cards' 1180166 ##(Graphics.Rectangle) 578 21 21 578 21 21 nil nil nil nil 29699 nil nil nil 578 681 901 1 nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 6143 21 578 761 921 416 1202 #text: 34 1 8 'ActiveX Component Wizard' 416 1282 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 214 1 0 0] 34 1 640 1344 nil 27 )!

toolsFolderHelpId
	^10604! !
!Tools.AXComponentWizard class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!Tools.AXComponentWizard class categoriesFor: #displayOn:!displaying!public! !
!Tools.AXComponentWizard class categoriesFor: #icon!constants!public! !
!Tools.AXComponentWizard class categoriesFor: #initialize!initializing!private! !
!Tools.AXComponentWizard class categoriesFor: #registerServer!operations!public! !
!Tools.AXComponentWizard class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.AXComponentWizard class categoriesFor: #toolsFolderHelpId!public! !

