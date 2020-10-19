"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkToolShell subclass: #'Tools.AXComponentWizard'
	instanceVariableNames: 'typeLibs types description guid globalName namespaceName packageName forcePackage cards libraryName libraryPath buffer typelibGlobal constantsPoolName highLevelWrappers classComments tracing defineProtocols defineFunctionTables lowercaseIdentifiers verboseTracing'
	classVariableNames: ''
	imports: #(#{OS.COM private})
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
		language: #null;
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
	namespaceName := self add: ChoicePresenter new name: 'namespace'.
	namespaceName choices: (ListModel on: ((Namespace allSubclasses reject: [:each | each isAbstract or: [each includesBehavior: SharedPool]]) collect: [:each | each fullName]) asSortedCollection searchPolicy: SearchPolicy equality).

	packageName := self add: TextPresenter new name: 'packageName'.
	typelibGlobal := self add: BooleanPresenter new name: 'generateTypelib'.
	globalName := self add: TextPresenter new name: 'globalName'.
	constantsPoolName := self add: TextPresenter new name: 'constantsPoolName'.
	highLevelWrappers := self add: (ChoicePresenter new
						choices: TypeLibraryAnalyzer highLevelWrapperStyles asSortedCollection;
						yourself)
				name: 'highLevelWrappers'.
	classComments := self add: (ChoicePresenter new
						choices: TypeLibraryAnalyzer classCommentStyles asSortedCollection;
						yourself)
				name: 'commentGeneration'.
	tracing := self add: (ChoicePresenter new
						choices: TypeLibraryAnalyzer tracingStyles asSortedCollection;
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
	typelibGlobal when: #valueChanged send: #updateTypelibGlobal to: self


	!

displayInstalledTypeLib: typelib
	"Private - Populate the receiver with details from the <AXTypeLibraryAnalyzer>, typelib."

	self updateTypesList: typelib.
	buffer := AspectBuffer subject: typelib.
	namespaceName model: (buffer aspectValue: #namespaceName).
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
	globalName value: typelib variableName.
	description value: typelib helpstring.
	libraryName value: typelib name.
	self updateTypelibGlobal.

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
	typeLibrary
		namespaceName: namespaceName value;
		packageName: packageName value.
	selected := types selections.
	step := 100 / selected size.
	progress := ProgressDialog create.
	progress operation: 
			[:p |
			
			[selected keysAndValuesDo: 
					[:i :each |
					| pct |
					pct := (i * step) rounded.
					progress text: 'Generating ' , each variableName.
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
	namespaceName clear.
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

	typeLibs
		list: (TypeLibraryAnalyzer allOpenableTypeLibs asSortedCollection: [:x :y | x name < y name])!

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

	^TypeLibraryAnalyzer icon!

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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 37 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 nil nil nil nil 410 ##(UI.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 853318 1 ##(UI.CardLayout) 138 144 34 3 1049094 ##(Core.Association) 8 '1' 410 ##(UI.ContainerView) 34 15 nil 640 34 2 8 1140850688 131073 816 nil nil nil 5 nil nil nil 816 610 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 816 34 2 8 1140850688 131073 896 nil nil nil 5 nil nil nil 896 1048838 ##(UI.FramingLayout) 170 176 34 6 410 ##(UI.StaticRectangle) 34 14 nil 896 34 2 8 1140916487 262145 1024 nil 917510 ##(Graphics.Color) #default nil 5 nil nil nil 1024 nil 8 1801195232 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 1 1 578 689 5 1024 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 578 193 193 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 1 1394 #fixedParentRight 1 1394 #fixedParentTop 1 1394 #fixedViewTop 5 410 ##(UI.PushButton) 34 20 nil 896 34 2 8 1140924416 1 1472 nil 1104 nil 5 nil nil nil 1472 nil 8 1801347024 1377606 4 ##(UI.CommandDescription) #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 545 31 578 141 51 1472 1202 #isEnabled: 8 #(false) 1472 1202 #text: 34 1 8 'Cancel' 1472 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 15 0 0 0 86 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1394 #fixedViewRight -139 1424 -3 1440 31 1456 51 410 ##(UI.PushButton) 34 20 nil 896 34 2 8 1140924416 1 1872 nil 1104 nil 5 nil nil nil 1872 nil 8 1801347024 1554 #libraryListNextCard 8 '&Next >' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 385 31 578 141 51 1872 1202 #isEnabled: 8 #(false) 1872 1202 #text: 34 1 8 '&Next >' 1872 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -163 1440 31 1456 51 170 192 8 #() nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 723 578 689 81 896 1202 #text: 34 1 8 'Buttons' 896 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 3 1872 1472 1024 1344 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 816 34 2 8 1140850688 131073 2480 nil nil nil 5 nil nil nil 2480 962 170 176 34 12 410 ##(UI.StaticText) 34 16 nil 2480 34 2 8 1140850946 1 2592 nil nil nil 5 nil nil nil 2592 nil 8 1801195232 1049094 ##(UI.NullConverter) nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 577 578 111 51 2592 1202 #text: 34 1 8 '&Location:' 2592 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 8 #() 1344 nil 27 1362 1408 1 1394 #fixedViewLeft 111 1394 #fixedViewBottom -49 1394 #fixedParentBottom -95 410 ##(UI.ListView) 34 45 nil 2480 34 2 8 1140953165 1025 2976 787270 2 ##(UI.ListModel) 138 144 2256 nil 1769478 ##(Kernel.IdentitySearchPolicy) 1104 nil 5 461638 4 ##(UI.Menu) nil true 34 3 1180742 2 ##(UI.CommandMenuItem) 1 1554 #browseIDL 8 '&Browse IDL' 1 1 nil nil nil 3170 1 1554 #inspectLibrary 8 '&Inspect' 1 1 nil nil nil 3170 1 1554 #typeLibHelp 8 '&Help' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2976 nil 8 1801282304 ##(UI.BasicListAbstract) nil 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 3 1117254 5 ##(UI.ListViewColumn) 8 'Library' 251 #left ##(UI.BasicListAbstract) 786950 ##(Core.Message) #<= 8 #() 3474 #name 8 #() nil 2976 nil 1 nil nil 3426 8 'Version' 101 #left 3474 #versionString 8 #() 3474 #<= 8 #() nil nil 2976 nil 1 nil nil 3426 8 'Description' 327 #left ##(UI.BasicListAbstract) 3474 #<= 8 #() 3474 #helpstring 3600 nil 2976 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 1 1 578 685 487 2976 1202 #contextMenu: 34 1 3136 2976 1202 #text: 34 1 8 'Library' 2976 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 8 #() 1344 nil 35 1362 1408 1 1424 -3 1440 1 2960 -235 410 ##(UI.PushButton) 34 20 nil 2480 34 2 8 1140924416 1 4000 nil 1104 nil 5 nil nil nil 4000 nil 8 1801347024 1554 #loadTypeLib 8 'Bro&wse...' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 535 507 578 141 51 4000 1202 #isEnabled: 8 #(false) 4000 1202 #text: 34 1 8 'Bro&wse...' 4000 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -13 2944 -49 2960 -165 410 ##(UI.StaticText) 34 16 nil 2480 34 2 8 1140850944 1 4368 nil nil nil 5 nil nil nil 4368 nil 8 1801195232 2674 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 131 657 578 631 41 4368 1202 #text: 34 1 8 'GUID of selected library here...' 4368 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 72 1 0 0 124 1 0 0 92 1 0 0] 8 #() 1344 nil 27 1362 1408 131 2928 631 2944 -39 2960 -25 410 ##(UI.StaticText) 34 16 nil 2480 34 2 8 1140850946 1 4688 nil nil nil 5 nil nil nil 4688 nil 8 1801195232 2674 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 657 578 111 41 4688 1202 #text: 34 1 8 '&GUID:' 4688 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 8 #() 1344 nil 27 1362 1408 1 2928 111 2944 -39 2960 -25 410 ##(UI.StaticText) 34 16 nil 2480 34 2 8 1140850944 1 5008 nil nil nil 5 nil nil nil 5008 nil 8 1801195232 2674 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 131 577 578 631 61 5008 1202 #text: 34 1 8 'Path of selected library here...
on two lines if necessary.' 5008 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 32 1 0 0 124 1 0 0 62 1 0 0] 8 #() 1344 nil 27 1362 1408 131 2928 631 2944 -59 2960 -85 170 192 34 6 4368 8 'guid' 5008 8 'libraryPath' 2976 8 'typeLibs' nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 1 1 578 689 723 2480 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 6 2976 4000 2592 5008 4688 4368 1344 nil 27 170 192 34 2 2480 8 'Libraries' nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 1 578 689 803 816 1202 #text: 34 1 8 'Step 1' 816 1282 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 2480 896 1344 nil 27 770 8 '2' 410 ##(UI.ContainerView) 34 15 nil 640 34 2 8 1140850688 131073 5856 nil nil nil 7 nil nil nil 5856 610 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 5856 34 2 8 1140850688 131073 5936 nil nil nil 7 nil nil nil 5936 962 170 176 34 8 410 ##(UI.PushButton) 34 20 nil 5936 34 2 8 1140924416 1 6048 nil 1104 nil 7 nil nil nil 6048 nil 8 1801347024 1554 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 385 31 578 141 51 6048 1202 #text: 34 1 8 '&Next >' 6048 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -163 1440 31 1456 51 410 ##(UI.PushButton) 34 20 nil 5936 34 2 8 1140924416 1 6384 nil 1104 nil 7 nil nil nil 6384 nil 8 1801347024 1554 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 549 31 578 141 51 6384 1202 #isEnabled: 8 #(false) 6384 1202 #text: 34 1 8 'Cancel' 6384 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 1 1440 31 1456 51 410 ##(UI.StaticRectangle) 34 14 nil 5936 34 2 8 1140916487 262145 6752 nil 1104 nil 7 nil nil nil 6752 nil 8 1801195232 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 1 1 578 689 5 6752 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1344 nil 27 1362 1408 1 1424 1 1440 1 1456 5 410 ##(UI.PushButton) 34 20 nil 5936 34 2 8 1140924416 1 7008 nil 1104 nil 7 nil nil nil 7008 nil 8 1801347024 1554 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 245 31 578 141 51 7008 1202 #text: 34 1 8 '< &Back' 7008 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -303 1440 31 1456 51 170 192 2256 nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 723 578 689 81 5936 1202 #text: 34 1 8 'Buttons' 5936 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 4 7008 6048 6384 6752 1344 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 5856 34 2 8 1140850688 131073 7568 nil nil nil 7 nil nil nil 7568 962 170 176 34 40 410 ##(UI.StaticText) 34 16 nil 7568 34 2 8 1140916480 1025 7680 nil nil nil 7 nil nil nil 7680 nil 8 1801195232 2674 nil nil nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 291 131 578 335 41 7680 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 65 0 0 0 56 1 0 0 85 0 0 0] 8 #() 1344 nil 27 1362 1408 291 1424 -63 1440 131 1456 41 410 ##(UI.CheckBox) 34 16 nil 7568 34 2 8 1140924451 1 7952 918598 2 ##(UI.ValueHolder) nil nil 1572870 ##(Kernel.NeverSearchPolicy) false nil nil 7 nil nil nil 7952 nil 8 1801347024 2674 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 539 578 411 61 7952 1202 #text: 34 1 8 'Define Method &Protocols:' 7952 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 13 1 0 0 235 0 0 0 43 1 0 0] 8 #() 1344 nil 27 1362 1408 61 2928 411 1440 539 1456 61 410 ##(UI.CheckBox) 34 16 nil 7568 34 2 8 1140924419 1 8336 8018 nil nil 8064 false nil nil 7 nil nil nil 8336 nil 8 1801347024 2674 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 69 129 578 221 41 8336 1202 #text: 34 1 8 'Typelib &global:' 8336 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 34 0 0 0 64 0 0 0 144 0 0 0 84 0 0 0] 8 #() 1344 nil 27 1362 1408 69 2928 221 1440 129 1456 41 410 ##(UI.GroupBox) 34 14 nil 7568 34 2 8 1140850695 65 8672 nil nil nil 7 nil nil nil 8672 nil 8 1801347024 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 43 431 578 621 101 8672 1202 #text: 34 1 8 '&Tracing:' 8672 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 21 0 0 0 215 0 0 0 75 1 0 0 9 1 0 0] 8 #() 1344 nil 27 1362 1408 43 2928 621 1440 431 1456 101 410 ##(UI.GroupBox) 34 14 nil 7568 34 2 8 1140850695 65 8976 nil nil nil 7 nil nil nil 8976 nil 8 1801347024 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 13 271 578 665 441 8976 1202 #text: 34 1 8 'Ad&vanced' 8976 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 135 0 0 0 82 1 0 0 99 1 0 0] 8 #() 1344 nil 27 1362 1408 13 1424 -11 1440 271 1456 441 410 ##(UI.StaticText) 34 16 nil 7568 34 2 8 1140850944 1 9280 nil nil nil 7 nil nil nil 9280 nil 8 1801195232 2674 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 83 191 578 171 43 9280 1202 #text: 34 1 8 'C&onstants pool:' 9280 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 41 0 0 0 95 0 0 0 126 0 0 0 116 0 0 0] 8 #() 1344 nil 27 1362 1408 83 2928 171 1440 191 1456 43 410 ##(UI.StaticText) 34 16 nil 7568 34 2 8 1140850944 1 9600 nil nil nil 7 nil nil nil 9600 nil 8 1801195232 2674 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 79 71 578 181 41 9600 1202 #text: 34 1 8 'Default &Package:' 9600 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 39 0 0 0 35 0 0 0 129 0 0 0 55 0 0 0] 8 #() 1344 nil 27 1362 1408 79 2928 181 1440 71 1456 41 410 ##(UI.TextEdit) 34 16 nil 7568 34 2 8 1140916224 1025 9920 nil 1104 nil 7 nil nil nil 9920 nil 8 1801338832 2674 nil nil 1 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 291 69 578 335 41 9920 1202 #setMarginWidths: 34 1 8 #(3 3) 9920 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 34 0 0 0 56 1 0 0 54 0 0 0] 8 #() 1344 nil 27 1362 1408 291 1424 -63 1440 69 1456 41 410 ##(UI.CheckBox) 34 16 nil 7568 34 2 8 1140924451 1 10240 8018 nil nil 8064 false nil nil 7 nil nil nil 10240 nil 8 1801347024 2674 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 639 578 411 61 10240 1202 #text: 34 1 8 '&Lowercase secondary keywords' 10240 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 63 1 0 0 235 0 0 0 93 1 0 0] 8 #() 1344 nil 27 1362 1408 61 2928 411 1440 639 1456 61 410 ##(UI.ComboBox) 34 17 nil 7568 34 2 8 1144063491 1025 10576 3042 138 144 2256 nil 3104 1104 nil 7 nil nil nil 10576 nil 8 1801138208 ##(UI.BasicListAbstract) 3728 401 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 61 471 578 185 47 10576 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 235 0 0 0 122 0 0 0 2 1 0 0] 8 #() 1344 nil 27 1362 1408 61 1424 -443 1440 471 1456 43 410 ##(UI.ComboBox) 34 17 nil 7568 34 2 8 1144063491 1025 10864 3042 138 144 2256 nil 3104 1104 nil 7 nil nil nil 10864 nil 8 1801138208 ##(UI.BasicListAbstract) 3728 151 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 441 321 578 185 47 10864 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 160 0 0 0 56 1 0 0 183 0 0 0] 8 #() 1344 nil 27 1362 1408 441 1424 -63 1440 321 1456 41 410 ##(UI.CheckBox) 34 16 nil 7568 34 2 8 1140928291 1 11152 8018 nil nil 8064 false nil nil 7 nil nil nil 11152 nil 8 1801347024 2674 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 421 471 578 211 41 11152 1202 #text: 34 1 8 'Verbose?' 11152 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 235 0 0 0 59 1 0 0 255 0 0 0] 8 #() 1344 nil 27 1362 1408 421 2928 211 1440 471 1456 41 410 ##(UI.StaticText) 34 16 nil 7568 34 2 8 1140850944 65 11488 nil nil nil 7 nil nil nil 11488 nil 8 1801195232 2674 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 321 578 281 41 11488 1202 #text: 34 1 8 '&Class Comments:' 11488 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 160 0 0 0 170 0 0 0 180 0 0 0] 8 #() 1344 nil 27 1362 1408 61 2928 281 1440 321 1456 41 410 ##(UI.CheckBox) 34 16 nil 7568 34 2 8 1140924451 1 11808 8018 nil nil 8064 false nil nil 7 nil nil nil 11808 nil 8 1801347024 2674 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 589 578 411 61 11808 1202 #text: 34 1 8 'Generate #&defineFunctions:' 11808 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 38 1 0 0 235 0 0 0 68 1 0 0] 8 #() 1344 nil 27 1362 1408 61 2928 411 1440 589 1456 61 410 ##(UI.ComboBox) 34 17 nil 7568 34 2 8 1144063491 1025 12144 3042 138 144 2256 nil 3104 1104 nil 7 nil nil nil 12144 nil 8 1801138208 ##(UI.BasicListAbstract) 3728 101 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 441 381 578 185 47 12144 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 190 0 0 0 56 1 0 0 213 0 0 0] 8 #() 1344 nil 27 1362 1408 441 1424 -63 1440 381 1456 41 410 ##(UI.StaticText) 34 16 nil 7568 34 2 8 1140850944 1 12432 nil nil nil 7 nil nil nil 12432 nil 8 1801195232 2674 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 381 578 371 41 12432 1202 #text: 34 1 8 '&High-level wrapper methods:' 12432 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 190 0 0 0 215 0 0 0 210 0 0 0] 8 #() 1344 nil 27 1362 1408 61 2928 371 1440 381 1456 41 410 ##(UI.StaticText) 34 16 nil 7568 34 2 8 1140916482 1 12752 8018 nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil nil nil 7 nil nil nil 12752 nil 8 1801195232 2674 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 75 11 578 181 41 12752 1202 #text: 34 1 8 '&Namespace:' 12752 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 37 0 0 0 5 0 0 0 127 0 0 0 25 0 0 0] 8 #() 1344 nil 27 1362 1408 75 2928 181 1440 11 1456 41 410 ##(UI.TextEdit) 34 16 nil 7568 34 2 8 1140916352 1025 13120 nil 1104 nil 7 nil nil nil 13120 nil 8 1801338832 2674 nil nil 1 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 291 191 578 335 41 13120 1202 #setMarginWidths: 34 1 8 #(3 3) 13120 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 95 0 0 0 56 1 0 0 115 0 0 0] 8 #() 1344 nil 27 1362 1408 291 1424 -63 1440 191 1456 41 410 ##(UI.ComboBox) 34 17 nil 7568 34 2 8 1144063490 1025 13440 3042 138 144 2256 nil 3104 1104 nil 7 nil nil nil 13440 nil 8 1801138208 1246566 3 ##(Kernel.BlockClosure) 0 nil 1377574 ##(Kernel.CompiledMethod) 2 3 ##(UI.ListControlView) #defaultGetTextBlock 434206339 8 #[30 105 226 0 106] #displayString 13568 7 257 nil 2256 401 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 291 7 578 335 47 13440 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 3 0 0 0 56 1 0 0 26 0 0 0] 8 #() 1344 nil 27 1362 1408 291 1424 -63 1440 7 1456 47 410 ##(UI.PushButton) 34 20 nil 7568 34 2 8 1140924416 1 13808 nil 1104 nil 7 nil nil nil 13808 nil 8 1801347024 1554 #choosePackage 8 '...' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 645 71 578 41 41 13808 1202 #isEnabled: 8 #(false) 13808 1202 #text: 34 1 8 '...' 13808 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 66 1 0 0 35 0 0 0 86 1 0 0 55 0 0 0] 8 #() 1344 nil 29 1362 1856 -39 1424 -3 1440 71 1456 41 170 192 34 24 11808 8 'defineFunctions' 11152 8 'verboseTrace' 13440 8 'namespace' 7680 8 'globalName' 12144 8 'highLevelWrappers' 9920 8 'packageName' 10240 8 'lowercaseKeywords' 7952 8 'defineProtocols' 8336 8 'generateTypelib' 10576 8 'tracing' 13120 8 'constantsPoolName' 10864 8 'commentGeneration' nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 1 578 689 723 7568 1202 #text: 34 1 8 'Generation Parameters' 7568 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 20 12752 13440 9600 9920 13808 9280 8336 7680 13120 8976 11488 10864 12432 12144 8672 10576 11152 7952 11808 10240 1344 nil 27 170 192 2256 nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 1 578 689 803 5856 1202 #text: 34 1 8 'Step 2' 5856 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 7568 5936 1344 nil 27 770 8 '3' 410 ##(UI.ContainerView) 34 15 nil 640 34 2 8 1140850688 131073 14864 nil nil nil 5 nil nil nil 14864 610 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 14864 34 2 8 1140850688 131073 14944 nil nil nil 5 nil nil nil 14944 962 170 176 34 8 410 ##(UI.StaticRectangle) 34 14 nil 14944 34 2 8 1140916487 262145 15056 nil 1104 nil 5 nil nil nil 15056 nil 8 1801195232 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 1 1 578 689 5 15056 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1344 nil 27 1362 1408 1 1424 1 1440 1 1456 5 410 ##(UI.PushButton) 34 20 nil 14944 34 2 8 1140924416 1 15312 nil 1104 nil 5 nil nil nil 15312 nil 8 1801347024 1554 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 539 31 578 151 51 15312 1202 #isEnabled: 8 #(false) 15312 1202 #text: 34 1 8 'Cancel' 15312 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -149 1424 1 1440 31 1456 51 410 ##(UI.PushButton) 34 20 nil 14944 34 2 8 1140924416 1 15680 nil 1104 nil 5 nil nil nil 15680 nil 8 1801347024 1554 #finish 8 '&Finish' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 385 31 578 141 51 15680 1202 #isEnabled: 8 #(false) 15680 1202 #text: 34 1 8 '&Finish' 15680 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -163 1440 31 1456 51 410 ##(UI.PushButton) 34 20 nil 14944 34 2 8 1140924416 1 16048 nil 1104 nil 5 nil nil nil 16048 nil 8 1801347024 1554 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 245 31 578 141 51 16048 1202 #text: 34 1 8 '< &Back' 16048 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -303 1440 31 1456 51 170 192 2256 nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 723 578 689 81 14944 1202 #text: 34 1 8 'Buttons' 14944 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 4 16048 15680 15312 15056 1344 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 14864 34 2 8 1140850688 131073 16608 nil nil nil 5 nil nil nil 16608 962 170 176 34 4 410 ##(UI.ListView) 34 45 nil 16608 34 2 8 1140920393 1025 16720 3042 138 144 2256 nil 3104 1104 nil 5 3122 nil true 34 6 3170 1 1554 #selectAll 8 'Select &All' 1 1 nil nil nil 3170 1 1554 #selectInstalled 8 'Select &Installed' 1 1 nil nil nil 3170 1 1554 #selectUninstalled 8 'Select &Uninstalled' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 3170 1 1554 #browseTypeClass 8 'Browse &Class' 1 1 nil nil nil 3170 1 1554 #browseTypesIDL 8 '&Browse IDL' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 16720 nil 8 1801282304 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 3376 nil 3474 #helpstring 8 #() nil 578 65 65 nil nil 138 144 34 3 3426 8 'Name' 437 #left ##(UI.BasicListAbstract) 13554 0 nil 1639718 ##(Kernel.CompiledExpression) 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] #name 17264 7 513 nil nil nil 16720 ##(UI.IconicListAbstract) 3 nil nil 3426 8 '' 41 #left nil 13554 0 nil 17282 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 17392 7 513 nil 13554 0 nil 17282 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:each | each isInstalled]' 8 #[30 105 17 158 106] #isInstalled 17472 7 257 nil nil 16720 ##(UI.IconicListAbstract) 1 nil nil 3426 8 'Type' 201 #left ##(UI.BasicListAbstract) 3474 #<= 8 #() 13554 0 nil 17282 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:each | each idlKeyword]' 8 #[30 105 17 158 106] #idlKeyword 17616 7 257 nil nil 16720 nil 1 nil nil #report 3728 nil 133157 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1138 138 144 34 4 1202 #createAt:extent: 34 2 578 1 1 578 685 617 16720 1202 #contextMenu: 34 1 16816 16720 1202 #text: 34 1 8 'Name' 16720 1202 #columnOrder: 34 1 8 #(2 1 3) 16720 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 52 1 0 0] 8 #() 1344 nil 35 1362 1408 1 1424 -3 1440 1 2960 -105 410 ##(UI.PushButton) 34 20 nil 16608 34 2 8 1140924416 1 18000 nil 1104 nil 5 nil nil nil 18000 nil 8 1801347024 1554 #generate 8 '&Generate' 1 1 nil nil true nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 535 647 578 141 51 18000 1202 #isEnabled: 8 #(false) 18000 1202 #text: 34 1 8 '&Generate' 18000 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 67 1 0 0 81 1 0 0 92 1 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -13 2944 -49 2960 -25 170 192 34 2 16720 8 'interfaces' nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 1 1 578 689 723 16608 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 2 16720 18000 1344 nil 27 170 192 34 2 16608 8 'Classes' nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 1 578 689 803 14864 1202 #text: 34 1 8 'Step 3' 14864 1282 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 16608 14944 1344 nil 27 5856 nil nil nil 170 192 2256 nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 21 21 578 689 803 640 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 155 1 0 0] 34 3 816 5856 14864 1344 nil 27 170 192 34 2 640 8 'cards' 1180166 ##(Graphics.Rectangle) 578 21 21 578 21 21 nil nil nil nil 10159 nil nil nil 578 681 901 1 nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 6143 21 578 761 921 416 1202 #text: 34 1 8 'ActiveX Component Wizard' 416 1282 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 214 1 0 0] 34 1 640 1344 nil 27 )!

toolsFolderHelpId
	^10604! !
!Tools.AXComponentWizard class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!Tools.AXComponentWizard class categoriesFor: #displayOn:!displaying!public! !
!Tools.AXComponentWizard class categoriesFor: #icon!constants!public! !
!Tools.AXComponentWizard class categoriesFor: #initialize!initializing!private! !
!Tools.AXComponentWizard class categoriesFor: #registerServer!operations!public! !
!Tools.AXComponentWizard class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.AXComponentWizard class categoriesFor: #toolsFolderHelpId!public! !

