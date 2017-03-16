"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #AXComponentWizard
	instanceVariableNames: 'typeLibs types description guid globalName prefix packageName forcePackage cards libraryName libraryPath prefixClasses buffer typelibGlobal constantsPoolName highLevelWrappers classComments tracing defineProtocols defineFunctionTables lowercaseIdentifiers verboseTracing'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AXComponentWizard guid: (GUID fromString: '{164b0031-3910-11d3-9fe6-00a0cc3e4a32}')!
AXComponentWizard comment: 'AXComponentWizard is a <SmalltalkToolShell> that manages the creation of interface classes for ActiveX components. To bring up an AXComponentWizard, open the appropriate icon in System Folder/Additional Tools/ActiveX Wizards or evaluate:

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
!AXComponentWizard categoriesForClass!Development!MVP-Presenters! !
!AXComponentWizard methodsFor!

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
		default: nil) ifNotNil: 
				[:choice | 
				packageName value: (choice = Package uncommitted ifTrue: [''] ifFalse: [choice name])]!

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
						choices: AXTypeLibraryAnalyzer highLevelWrapperStyles asSortedCollection;
						yourself)
				name: 'highLevelWrappers'.
	classComments := self add: ((ChoicePresenter new)
						choices: AXTypeLibraryAnalyzer classCommentStyles asSortedCollection;
						yourself)
				name: 'commentGeneration'.
	tracing := self add: ((ChoicePresenter new)
						choices: AXTypeLibraryAnalyzer tracingStyles asSortedCollection;
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

	typeLibs list: (AXTypeLibraryAnalyzer allOpenableTypeLibs
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

	ShellLibrary default shellOpen: self typeLib helpfile!

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
!AXComponentWizard categoriesFor: #apply!operations!private! !
!AXComponentWizard categoriesFor: #browseIDL!commands!public! !
!AXComponentWizard categoriesFor: #browseTypeClass!commands!public! !
!AXComponentWizard categoriesFor: #browseTypesIDL!commands!public! !
!AXComponentWizard categoriesFor: #cancel!commands!public! !
!AXComponentWizard categoriesFor: #choosePackage!commands!public! !
!AXComponentWizard categoriesFor: #createComponents!initializing!public! !
!AXComponentWizard categoriesFor: #createSchematicWiring!initializing!public! !
!AXComponentWizard categoriesFor: #displayInstalledTypeLib:!private!updating! !
!AXComponentWizard categoriesFor: #finish!commands!public! !
!AXComponentWizard categoriesFor: #generate!commands!public! !
!AXComponentWizard categoriesFor: #inspectIt!commands!public! !
!AXComponentWizard categoriesFor: #inspectItCommand!public! !
!AXComponentWizard categoriesFor: #inspectLibrary!commands!public! !
!AXComponentWizard categoriesFor: #inspectType!public! !
!AXComponentWizard categoriesFor: #libraryListNextCard!commands!public! !
!AXComponentWizard categoriesFor: #loadTypeLib!commands!public! !
!AXComponentWizard categoriesFor: #onTypeLibrarySelected!event handling!private! !
!AXComponentWizard categoriesFor: #onViewOpened!event handling!public! !
!AXComponentWizard categoriesFor: #queryCommand:!commands!private! !
!AXComponentWizard categoriesFor: #refresh!commands!public! !
!AXComponentWizard categoriesFor: #selectInstalled!commands!public! !
!AXComponentWizard categoriesFor: #selectUninstalled!commands!public! !
!AXComponentWizard categoriesFor: #typeLib!accessing!public! !
!AXComponentWizard categoriesFor: #typeLib:!accessing!public! !
!AXComponentWizard categoriesFor: #typeLibHelp!commands!public! !
!AXComponentWizard categoriesFor: #updateClassPrefix!private!updating! !
!AXComponentWizard categoriesFor: #updateTypelibGlobal!private!updating! !
!AXComponentWizard categoriesFor: #updateTypesList:!private!updating! !

!AXComponentWizard class methodsFor!

defaultAdditionalAccelerators
	^super defaultAdditionalAccelerators 
		, #(#(#help 'F1') #(#refresh 'F5') #(#selectAll 'Ctrl+A') #(#inspectIt 'Ctrl+I'))!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Active-X Component Wizard'!

icon
	"Answers an Icon that can be used to represent this class."

	^AXTypeLibraryAnalyzer icon!

initialize
	"Private - Initialize the receiver.

		self initialize.
	"

	(Smalltalk developmentSystem)
		addAdditionalToolsFolderIcon: (SmalltalkSystemIcon 
					icon: self icon
					description: 'Register Type Library'
					openBlock: [:folder :item | AXTypeLibraryAnalyzer registerTypeLib]
					helpId: 10614);
		addAdditionalToolsFolderIcon: (SmalltalkSystemIcon 
					icon: self icon
					description: 'Register ActiveX Control'
					openBlock: [:folder :item | self registerServer]
					helpId: 10602);
		addAdditionalToolsFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self reuseIfOpen: true!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		add: (Aspect boolean: #reuseIfOpen);
		yourself!

registerServer
	"Browse for a DLL, and register it as a COM component
		self registerServer
	"

	| dllpath entrypoint |
	dllpath := (FileOpenDialog new)
				fileTypes: #(#('Components (*.dll,*.ocx)' '*.dll;*.ocx') #('All Files (*.*)' '*.*'));
				defaultExtension: 'dll';
				showModal.
	dllpath isNil ifTrue: [^nil].
	entrypoint := #DllRegisterServer.
	
	[| lib |
	lib := ExternalLibrary open: dllpath.
	
	[| method proc |
	proc := lib getProcAddress: entrypoint
				ifAbsent: 
					[self 
						error: ('<1s> was loaded but the <2s> entry point could not be found.<n><n>This file cannot be registered' 
								expandMacrosWith: dllpath
								with: entrypoint)].
	method := (lib class compiledMethodAt: #DllRegisterServer) copy.
	method literalAt: 1
		put: (((method literalAt: 1) copy)
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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 0 39 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.WizardCardContainer)  98 15 0 416 98 2 8 1140850688 131073 656 0 482 31 0 7 0 0 0 656 655878 ##(Smalltalk.CardLayout)  202 208 98 3 721414 ##(Smalltalk.Association)  8 '1' 410 8 ##(Smalltalk.ContainerView)  98 15 0 656 98 2 8 1140850688 131073 864 0 482 31 0 7 0 0 0 864 626 1 1 0 410 880 98 15 0 864 98 2 8 1140850688 131073 976 0 482 31 0 7 0 0 0 976 852230 ##(Smalltalk.FramingLayout)  234 240 98 6 410 8 ##(Smalltalk.StaticRectangle)  98 14 0 976 98 2 8 1140916487 262145 1120 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 0 0 0 1120 0 8 4294903625 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 594 1 1 594 705 5 1120 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 96 1 0 0 2 0 0 0] 98 0 594 193 193 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedParentLeft 1 1538 8 #fixedParentRight 1 1538 8 #fixedParentTop 1 1538 8 #fixedViewTop 5 410 8 ##(Smalltalk.PushButton)  98 17 0 976 98 2 8 1140924416 1 1680 0 1202 1232 0 7 0 0 0 1680 0 8 4294903631 1180998 4 ##(Smalltalk.CommandDescription)  8 #cancel 8 'Cancel' 1 1 0 0 32 1266 202 208 98 3 1330 1360 98 2 594 561 31 594 141 51 1680 1330 8 #isEnabled: 98 1 32 1680 1330 8 #text: 98 1 8 'Cancel' 1680 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 24 1 0 0 15 0 0 0 94 1 0 0 40 0 0 0] 98 0 1488 0 27 1506 1538 8 #fixedViewRight -139 1584 -3 1616 31 1648 51 410 1696 98 17 0 976 98 2 8 1140924416 1 2176 0 1202 1232 0 7 0 0 0 2176 0 8 4294903631 1794 8 #libraryListNextCard 8 '&Next >' 1 1 0 0 32 1266 202 208 98 3 1330 1360 98 2 594 401 31 594 141 51 2176 1330 1984 98 1 32 2176 1330 2032 98 1 8 '&Next >' 2176 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 200 0 0 0 15 0 0 0 14 1 0 0 40 0 0 0] 98 0 1488 0 27 1506 2144 -139 1584 -163 1616 31 1648 51 234 256 98 0 0 1266 202 208 98 2 1330 1360 98 2 594 1 733 594 705 81 976 1330 2032 98 1 8 'Buttons' 976 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 110 1 0 0 96 1 0 0 150 1 0 0] 98 3 2176 1680 1120 1488 0 27 0 0 410 880 98 15 0 864 98 2 8 1140850688 131073 2816 0 482 31 0 7 0 0 0 2816 1058 234 240 98 12 410 8 ##(Smalltalk.StaticText)  98 16 0 2816 98 2 8 1140850944 1 2944 0 0 0 7 0 0 0 2944 0 8 4294903625 852486 ##(Smalltalk.NullConverter)  0 0 0 1266 202 208 98 2 1330 1360 98 2 594 131 667 594 631 41 2944 1330 2032 98 1 8 'GUID of selected library here...' 2944 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 77 1 0 0 124 1 0 0 97 1 0 0] 98 0 1488 0 27 1506 1552 131 1538 8 #fixedViewLeft 631 1538 8 #fixedViewBottom -39 1538 8 #fixedParentBottom -25 410 8 ##(Smalltalk.ListView)  98 30 0 2816 98 2 8 1140953165 1025 3392 590662 2 ##(Smalltalk.ListModel)  202 208 2592 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  1202 1232 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 3 984134 2 ##(Smalltalk.CommandMenuItem)  1 1794 8 #browseIDL 8 '&Browse IDL' 1 1 0 0 0 3618 1 1794 8 #inspectLibrary 8 '&Inspect' 1 1 0 0 0 3618 1 1794 8 #typeLibHelp 8 '&Help' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 3392 0 8 4294903801 8 ##(Smalltalk.BasicListAbstract)  0 1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 3 920646 5 ##(Smalltalk.ListViewColumn)  8 'Library' 251 8 #left 3856 8 ##(Smalltalk.SortedCollection)  459270 ##(Smalltalk.Message)  8 #name 98 0 0 3392 0 1 0 0 3938 8 'Version' 101 3984 4018 8 #versionString 98 0 4000 0 0 3392 0 1 0 0 3938 8 'Description' 343 3984 3856 4000 4018 8 #helpstring 4144 0 3392 0 3 0 0 8 #report 2592 0 133185 0 0 1266 202 208 98 3 1330 1360 98 2 594 1 1 594 701 497 3392 1330 8 #contextMenu: 98 1 3584 3392 1330 2032 98 1 8 'Library' 3392 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 248 0 0 0] 98 0 1488 0 27 1506 1552 1 1584 -3 1616 1 3360 -235 410 1696 98 17 0 2816 98 2 8 1140924416 1 4512 0 1202 1232 0 7 0 0 0 4512 0 8 4294903631 1794 8 #loadTypeLib 8 'Bro&wse...' 1 1 0 0 32 1266 202 208 98 3 1330 1360 98 2 594 551 517 594 141 51 4512 1330 1984 98 1 32 4512 1330 2032 98 1 8 'Bro&wse...' 4512 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 19 1 0 0 2 1 0 0 89 1 0 0 27 1 0 0] 98 0 1488 0 27 1506 2144 -139 1584 -13 3328 -49 3360 -165 410 2960 98 16 0 2816 98 2 8 1140850946 1 4912 0 0 0 7 0 0 0 4912 0 8 4294903625 3042 0 0 0 1266 202 208 98 2 1330 1360 98 2 594 1 587 594 111 51 4912 1330 2032 98 1 8 '&Location:' 4912 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 37 1 0 0 55 0 0 0 62 1 0 0] 98 0 1488 0 27 1506 1552 1 3296 111 3328 -49 3360 -95 410 2960 98 16 0 2816 98 2 8 1140850944 1 5232 0 0 0 7 0 0 0 5232 0 8 4294903625 3042 0 0 0 1266 202 208 98 2 1330 1360 98 2 594 131 587 594 631 61 5232 1330 2032 98 1 8 'Path of selected library here...
on two lines if necessary.' 5232 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 37 1 0 0 124 1 0 0 67 1 0 0] 98 0 1488 0 27 1506 1552 131 3296 631 3328 -59 3360 -85 410 2960 98 16 0 2816 98 2 8 1140850946 1 5552 0 0 0 7 0 0 0 5552 0 8 4294903625 3042 0 0 0 1266 202 208 98 2 1330 1360 98 2 594 1 667 594 111 41 5552 1330 2032 98 1 8 '&GUID:' 5552 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 77 1 0 0 55 0 0 0 97 1 0 0] 98 0 1488 0 27 1506 1552 1 3296 111 3328 -39 3360 -25 234 256 98 6 5232 8 'libraryPath' 2944 8 'guid' 3392 8 'typeLibs' 0 1266 202 208 98 1 1330 1360 98 2 594 1 1 594 705 733 2816 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 96 1 0 0 110 1 0 0] 98 6 3392 4512 4912 5232 5552 2944 1488 0 27 234 256 98 2 2816 8 'Libraries' 0 1266 202 208 98 2 1330 1360 98 2 594 1 1 594 705 813 864 1330 2032 98 1 8 'Step 1' 864 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 96 1 0 0 150 1 0 0] 98 2 2816 976 1488 0 27 818 8 '2' 410 880 98 15 0 656 98 2 8 1140850688 131073 6400 0 482 31 0 5 0 0 0 6400 626 1 1 0 410 880 98 15 0 6400 98 2 8 1140850688 131073 6496 0 482 31 0 5 0 0 0 6496 1058 234 240 98 8 410 1696 98 17 0 6496 98 2 8 1140924416 1 6624 0 1202 1232 0 5 0 0 0 6624 0 8 4294903631 1794 1824 8 'Cancel' 1 1 0 0 32 1266 202 208 98 3 1330 1360 98 2 594 565 31 594 141 51 6624 1330 1984 98 1 32 6624 1330 2032 98 1 8 'Cancel' 6624 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 26 1 0 0 15 0 0 0 96 1 0 0 40 0 0 0] 98 0 1488 0 27 1506 2144 -139 1584 1 1616 31 1648 51 410 1696 98 17 0 6496 98 2 8 1140924416 1 7008 0 1202 1232 0 5 0 0 0 7008 0 8 4294903631 1794 8 #nextCard 8 '&Next >' 1 1 0 0 32 1266 202 208 98 2 1330 1360 98 2 594 401 31 594 141 51 7008 1330 2032 98 1 8 '&Next >' 7008 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 200 0 0 0 15 0 0 0 14 1 0 0 40 0 0 0] 98 0 1488 0 27 1506 2144 -139 1584 -163 1616 31 1648 51 410 1136 98 14 0 6496 98 2 8 1140916487 262145 7376 0 1202 1232 0 5 0 0 0 7376 0 8 4294903625 1266 202 208 98 1 1330 1360 98 2 594 1 1 594 705 5 7376 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 96 1 0 0 2 0 0 0] 98 0 1488 0 27 1506 1552 1 1584 1 1616 1 1648 5 410 1696 98 17 0 6496 98 2 8 1140924416 1 7648 0 1202 1232 0 5 0 0 0 7648 0 8 4294903631 1794 8 #previousCard 8 '< &Back' 1 1 0 0 32 1266 202 208 98 3 1330 1360 98 2 594 261 31 594 141 51 7648 1330 1984 98 1 32 7648 1330 2032 98 1 8 '< &Back' 7648 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 130 0 0 0 15 0 0 0 200 0 0 0 40 0 0 0] 98 0 1488 0 27 1506 2144 -139 1584 -303 1616 31 1648 51 234 256 2592 0 1266 202 208 98 2 1330 1360 98 2 594 1 733 594 705 81 6496 1330 2032 98 1 8 'Buttons' 6496 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 110 1 0 0 96 1 0 0 150 1 0 0] 98 4 7648 7008 6624 7376 1488 0 27 0 0 410 880 98 15 0 6400 98 2 8 1140850688 131073 8272 0 482 31 0 5 0 0 0 8272 1058 234 240 98 40 410 2960 98 16 0 8272 98 2 8 1140850944 1 8400 0 0 0 5 0 0 0 8400 0 8 4294903625 3042 0 0 0 1266 202 208 98 2 1330 1360 98 2 594 81 191 594 171 43 8400 1330 2032 98 1 8 'C&onstants pool:' 8400 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 95 0 0 0 125 0 0 0 116 0 0 0] 98 0 1488 0 27 1506 1552 81 3296 171 1616 191 1648 43 410 8 ##(Smalltalk.ComboBox)  98 17 0 8272 98 2 8 1144063491 1025 8720 3474 202 208 2592 0 3536 1202 1232 0 5 0 0 0 8720 0 8 4294903803 3856 2592 101 1266 202 208 98 1 1330 1360 98 2 594 441 381 594 201 43 8720 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 190 0 0 0 64 1 0 0 211 0 0 0] 98 0 1488 0 27 1506 1552 441 1584 -63 1616 381 1648 41 410 8736 98 17 0 8272 98 2 8 1144063491 1025 9040 3474 202 208 2592 0 3536 1202 1232 0 5 0 0 0 9040 0 8 4294903803 3856 2592 151 1266 202 208 98 1 1330 1360 98 2 594 441 321 594 201 43 9040 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 160 0 0 0 64 1 0 0 181 0 0 0] 98 0 1488 0 27 1506 1552 441 1584 -63 1616 321 1648 41 410 8 ##(Smalltalk.TextEdit)  98 16 0 8272 98 2 8 1140916224 1025 9344 0 1202 1232 0 5 0 0 0 9344 0 8 4294903807 3042 0 0 1 1266 202 208 98 3 1330 1360 98 2 594 291 11 594 351 41 9344 1330 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 9344 1330 8 #isTextModified: 98 1 32 9344 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 5 0 0 0 64 1 0 0 25 0 0 0] 98 0 1488 0 27 1506 1552 291 1584 -63 1616 11 1648 41 410 8736 98 17 0 8272 98 2 8 1144063491 1025 9776 3474 202 208 2592 0 3536 1202 1232 0 5 0 0 0 9776 0 8 4294903803 3856 2592 401 1266 202 208 98 1 1330 1360 98 2 594 61 471 594 201 43 9776 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 235 0 0 0 130 0 0 0 0 1 0 0] 98 0 1488 0 27 1506 1552 61 1584 -443 1616 471 1648 43 410 8 ##(Smalltalk.CheckBox)  98 16 0 8272 98 2 8 1140924419 1 10080 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  32 1202 1232 0 5 0 0 0 10080 0 8 4294903631 3042 0 0 0 1266 202 208 98 2 1330 1360 98 2 594 51 11 594 211 43 10080 1330 2032 98 1 8 'Class pre&fix:' 10080 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 0 0 0 5 0 0 0 130 0 0 0 26 0 0 0] 98 0 1488 0 27 1506 1552 51 3296 211 1616 11 1648 43 410 8 ##(Smalltalk.GroupBox)  98 14 0 8272 98 2 8 1140850695 65 10496 0 1202 1232 0 5 0 0 0 10496 0 8 4294903631 1266 202 208 98 2 1330 1360 98 2 594 13 271 594 681 441 10496 1330 2032 98 1 8 'Ad&vanced' 10496 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 135 0 0 0 90 1 0 0 99 1 0 0] 98 0 1488 0 27 1506 1552 13 1584 -11 1616 271 1648 441 410 2960 98 16 0 8272 98 2 8 1140850944 1 10832 0 0 0 5 0 0 0 10832 0 8 4294903625 3042 0 0 0 1266 202 208 98 2 1330 1360 98 2 594 61 381 594 371 41 10832 1330 2032 98 1 8 '&High-level wrapper methods:' 10832 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 190 0 0 0 215 0 0 0 210 0 0 0] 98 0 1488 0 27 1506 1552 61 3296 371 1616 381 1648 41 410 10096 98 16 0 8272 98 2 8 1140924419 1 11152 10162 0 0 10208 32 1202 1232 0 5 0 0 0 11152 0 8 4294903631 3042 0 0 0 1266 202 208 98 2 1330 1360 98 2 594 41 131 594 241 43 11152 1330 2032 98 1 8 'Typelib &global:' 11152 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 65 0 0 0 140 0 0 0 86 0 0 0] 98 0 1488 0 27 1506 1552 41 3296 241 1616 131 1648 43 410 2960 98 16 0 8272 98 2 8 1140850944 1 11504 0 0 0 5 0 0 0 11504 0 8 4294903625 3042 0 0 0 1266 202 208 98 2 1330 1360 98 2 594 81 71 594 181 31 11504 1330 2032 98 1 8 'Default &Package:' 11504 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 35 0 0 0 130 0 0 0 50 0 0 0] 98 0 1488 0 27 1506 1552 81 3296 181 1616 71 1648 31 410 2960 98 16 0 8272 98 2 8 1140850944 65 11824 0 0 0 5 0 0 0 11824 0 8 4294903625 3042 0 0 0 1266 202 208 98 2 1330 1360 98 2 594 61 321 594 281 41 11824 1330 2032 98 1 8 '&Class Comments:' 11824 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 160 0 0 0 170 0 0 0 180 0 0 0] 98 0 1488 0 27 1506 1552 61 3296 281 1616 321 1648 41 410 9360 98 16 0 8272 98 2 8 1140916224 1025 12144 0 1202 1232 0 5 0 0 0 12144 0 8 4294903807 3042 0 0 1 1266 202 208 98 3 1330 1360 98 2 594 291 71 594 351 41 12144 1330 9600 98 1 9634 3 1 3 12144 1330 9680 98 1 32 12144 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 35 0 0 0 64 1 0 0 55 0 0 0] 98 0 1488 0 27 1506 1552 291 1584 -63 1616 71 1648 41 410 9360 98 16 0 8272 98 2 8 1140916352 1025 12512 0 1202 1232 0 5 0 0 0 12512 0 8 4294903807 3042 0 0 1 1266 202 208 98 3 1330 1360 98 2 594 291 191 594 351 41 12512 1330 9600 98 1 9634 3 1 3 12512 1330 9680 98 1 32 12512 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 95 0 0 0 64 1 0 0 115 0 0 0] 98 0 1488 0 27 1506 1552 291 1584 -63 1616 191 1648 41 410 1696 98 17 0 8272 98 2 8 1140924416 1 12880 0 1202 1232 0 5 0 0 0 12880 0 8 4294903631 1794 8 #choosePackage 8 '...' 1 1 0 0 32 1266 202 208 98 3 1330 1360 98 2 594 661 71 594 41 41 12880 1330 1984 98 1 32 12880 1330 2032 98 1 8 '...' 12880 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 1 0 0 35 0 0 0 94 1 0 0 55 0 0 0] 98 0 1488 0 27 1506 2144 -39 1584 -3 1616 71 1648 41 410 10512 98 14 0 8272 98 2 8 1140850695 65 13280 0 0 0 5 0 0 0 13280 0 8 4294903631 1266 202 208 98 2 1330 1360 98 2 594 43 431 594 621 101 13280 1330 2032 98 1 8 '&Tracing:' 13280 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 21 0 0 0 215 0 0 0 75 1 0 0 9 1 0 0] 98 0 1488 0 27 1506 1552 43 3296 621 1616 431 1648 101 410 2960 98 16 0 8272 98 2 8 1140916480 1025 13584 0 0 0 5 0 0 0 13584 0 8 4294903625 3042 0 0 0 1266 202 208 98 1 1330 1360 98 2 594 291 131 594 351 41 13584 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 65 0 0 0 64 1 0 0 85 0 0 0] 98 0 1488 0 27 1506 1552 291 1584 -63 1616 131 1648 41 410 10096 98 16 0 8272 98 2 8 1140924451 1 13856 10162 0 0 10208 32 1202 1232 0 5 0 0 0 13856 0 8 4294903631 3042 0 0 0 1266 202 208 98 2 1330 1360 98 2 594 61 589 594 411 61 13856 1330 2032 98 1 8 'Generate #&defineFunctions:' 13856 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 38 1 0 0 235 0 0 0 68 1 0 0] 98 0 1488 0 27 1506 1552 61 3296 411 1616 589 1648 61 410 10096 98 16 0 8272 98 2 8 1140928291 1 14208 10162 0 0 10208 32 1202 1232 0 5 0 0 0 14208 0 8 4294903631 3042 0 0 0 1266 202 208 98 2 1330 1360 98 2 594 421 471 594 211 41 14208 1330 2032 98 1 8 'Verbose?' 14208 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 235 0 0 0 59 1 0 0 255 0 0 0] 98 0 1488 0 27 1506 1552 421 3296 211 1616 471 1648 41 410 10096 98 16 0 8272 98 2 8 1140924451 1 14560 10162 0 0 10208 32 1202 1232 0 5 0 0 0 14560 0 8 4294903631 3042 0 0 0 1266 202 208 98 2 1330 1360 98 2 594 61 639 594 411 61 14560 1330 2032 98 1 8 '&Lowercase secondary keywords' 14560 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 63 1 0 0 235 0 0 0 93 1 0 0] 98 0 1488 0 27 1506 1552 61 3296 411 1616 639 1648 61 410 10096 98 16 0 8272 98 2 8 1140924451 1 14912 10162 0 0 10208 32 1202 1232 0 5 0 0 0 14912 0 8 4294903631 3042 0 0 0 1266 202 208 98 2 1330 1360 98 2 594 61 539 594 411 61 14912 1330 2032 98 1 8 'Define Method &Protocols:' 14912 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 13 1 0 0 235 0 0 0 43 1 0 0] 98 0 1488 0 27 1506 1552 61 3296 411 1616 539 1648 61 234 256 98 26 14560 8 'lowercaseKeywords' 10080 8 'prefixClasses' 8720 8 'highLevelWrappers' 9776 8 'tracing' 9344 8 'prefix' 12144 8 'packageName' 14912 8 'defineProtocols' 13856 8 'defineFunctions' 9040 8 'commentGeneration' 11152 8 'generateTypelib' 14208 8 'verboseTrace' 13584 8 'globalName' 12512 8 'constantsPoolName' 0 1266 202 208 98 2 1330 1360 98 2 594 1 1 594 705 733 8272 1330 2032 98 1 8 'Generation Parameters' 8272 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 96 1 0 0 110 1 0 0] 98 20 10080 9344 11504 12144 12880 8400 11152 13584 12512 10496 11824 9040 10832 8720 13280 9776 14208 14912 13856 14560 1488 0 27 234 256 2592 0 1266 202 208 98 2 1330 1360 98 2 594 1 1 594 705 813 6400 1330 2032 98 1 8 'Step 2' 6400 1426 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 96 1 0 0 150 1 0 0] 98 2 8272 6496 1488 0 27 818 8 '3' 410 880 98 15 0 656 98 2 8 1140850688 131073 15968 0 482 31 0 5 0 0 0 15968 626 1 1 0 410 880 98 15 0 15968 98 2 8 1140850688 131073 16064 0 482 31 0 5 0 0 0 16064 1058 234 240 98 8 410 1696 98 17 0 16064 98 2 8 1140924416 1 16192 0 1202 1232 0 5 0 0 0 16192 0 8 4294903631 1794 1824 8 'Cancel' 1 1 0 0 32 1266 202 208 98 3 1330 1360 98 2 594 555 31 594 151 51 16192 1330 1984 98 1 32 16192 1330 2032 98 1 8 'Cancel' 16192 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 21 1 0 0 15 0 0 0 96 1 0 0 40 0 0 0] 98 0 1488 0 27 1506 2144 -149 1584 1 1616 31 1648 51 410 1136 98 14 0 16064 98 2 8 1140916487 262145 16576 0 1202 1232 0 5 0 0 0 16576 0 8 4294903625 1266 202 208 98 1 1330 1360 98 2 594 1 1 594 705 5 16576 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 96 1 0 0 2 0 0 0] 98 0 1488 0 27 1506 1552 1 1584 1 1616 1 1648 5 410 1696 98 17 0 16064 98 2 8 1140924416 1 16848 0 1202 1232 0 5 0 0 0 16848 0 8 4294903631 1794 8 #finish 8 '&Finish' 1 1 0 0 32 1266 202 208 98 3 1330 1360 98 2 594 401 31 594 141 51 16848 1330 1984 98 1 32 16848 1330 2032 98 1 8 '&Finish' 16848 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 200 0 0 0 15 0 0 0 14 1 0 0 40 0 0 0] 98 0 1488 0 27 1506 2144 -139 1584 -163 1616 31 1648 51 410 1696 98 17 0 16064 98 2 8 1140924416 1 17248 0 1202 1232 0 5 0 0 0 17248 0 8 4294903631 1794 7760 8 '< &Back' 1 1 0 0 32 1266 202 208 98 3 1330 1360 98 2 594 261 31 594 141 51 17248 1330 1984 98 1 32 17248 1330 2032 98 1 8 '< &Back' 17248 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 130 0 0 0 15 0 0 0 200 0 0 0 40 0 0 0] 98 0 1488 0 27 1506 2144 -139 1584 -303 1616 31 1648 51 234 256 2592 0 1266 202 208 98 2 1330 1360 98 2 594 1 733 594 705 81 16064 1330 2032 98 1 8 'Buttons' 16064 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 110 1 0 0 96 1 0 0 150 1 0 0] 98 4 17248 16848 16192 16576 1488 0 27 0 0 410 880 98 15 0 15968 98 2 8 1140850688 131073 17856 0 482 31 0 5 0 0 0 17856 1058 234 240 98 4 410 1696 98 17 0 17856 98 2 8 1140924416 1 17984 0 1202 1232 0 5 0 0 0 17984 0 8 4294903631 1794 8 #generate 8 '&Generate' 1 1 0 0 16 1266 202 208 98 3 1330 1360 98 2 594 551 657 594 141 51 17984 1330 1984 98 1 32 17984 1330 2032 98 1 8 '&Generate' 17984 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 19 1 0 0 72 1 0 0 89 1 0 0 97 1 0 0] 98 0 1488 0 27 1506 2144 -139 1584 -13 3328 -49 3360 -25 410 3408 98 30 0 17856 98 2 8 1140920393 1025 18384 3474 202 208 2592 0 3536 1202 1232 0 5 3570 0 16 98 6 3618 1 1794 8 #selectAll 8 'Select &All' 1 1 0 0 0 3618 1 1794 8 #selectInstalled 8 'Select &Installed' 1 1 0 0 0 3618 1 1794 8 #selectUninstalled 8 'Select &Uninstalled' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 3618 1 1794 8 #browseTypeClass 8 'Browse &Class' 1 1 0 0 0 3618 1 1794 8 #browseTypesIDL 8 '&Browse IDL' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 18384 0 8 4294903801 3856 8 ##(Smalltalk.IconicListAbstract)  3888 0 4018 4208 98 0 0 594 65 65 0 0 202 208 98 3 3938 8 'Name' 453 3984 3856 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  2 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] 4048 19056 7 513 0 0 0 18384 18912 3 0 0 3938 8 '' 41 3984 0 19042 0 0 19074 3 1 19104 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] 8 #not 8 #& 19200 7 513 0 19042 0 0 19074 2 1 19104 8 'doIt' 8 '[:each | each isInstalled]' 8 #[30 105 17 158 106] 8 #isInstalled 19312 7 257 0 0 18384 18912 1 0 0 3938 8 'Type' 201 3984 3856 19042 0 0 918822 ##(Smalltalk.CompiledMethod)  1 83886081 170 8 'Dolphin' 8 'SortedCollection' 8 #defaultSortBlock 1512711171 8 #[29 105 233 1 130 106] 19440 7 513 0 19042 0 0 19074 2 1 19104 8 'doIt' 8 '[:each | each idlKeyword]' 8 #[30 105 17 158 106] 8 #idlKeyword 19568 7 257 0 0 18384 0 1 0 0 4224 2592 0 133157 0 0 1266 202 208 98 4 1330 1360 98 2 594 1 1 594 701 627 18384 1330 4368 98 1 18496 18384 1330 2032 98 1 8 'Name' 18384 1330 8 #columnOrder: 98 1 98 3 5 3 7 18384 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 57 1 0 0] 98 0 1488 0 27 1506 1552 1 1584 -3 1616 1 3360 -105 234 256 98 2 18384 8 'interfaces' 0 1266 202 208 98 1 1330 1360 98 2 594 1 1 594 705 733 17856 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 96 1 0 0 110 1 0 0] 98 2 18384 17984 1488 0 27 234 256 98 2 17856 8 'Classes' 0 1266 202 208 98 2 1330 1360 98 2 594 1 1 594 705 813 15968 1330 2032 98 1 8 'Step 3' 15968 1426 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 96 1 0 0 150 1 0 0] 98 2 17856 16064 1488 0 27 864 234 256 2592 0 1266 202 208 98 1 1330 1360 98 2 594 21 21 594 705 813 656 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 106 1 0 0 160 1 0 0] 98 3 864 6400 15968 1488 0 27 234 256 98 2 656 8 'cards' 590342 ##(Smalltalk.Rectangle)  594 21 21 594 21 21 0 0 0 0 32605 0 0 0 594 681 901 1 0 0 1266 202 208 98 3 1330 1360 98 2 594 2799 21 594 761 921 416 1330 2032 98 1 8 'ActiveX Component Wizard' 416 1330 8 #updateMenuBar 2592 416 1426 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 243 6 0 0 214 1 0 0] 98 1 656 1488 0 27 )!

toolsFolderHelpId
	^10604!

uninitialize
	"Private - Un-register the system tools folder icon for the receiver to allow clean
	removal of this class from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: 'Register Type Library';
		removeSystemFolderIconNamed: 'Register ActiveX Control';
		removeSystemFolderIconNamed: self toolDescription;
		unregisterTool: self! !
!AXComponentWizard class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!AXComponentWizard class categoriesFor: #displayOn:!displaying!public! !
!AXComponentWizard class categoriesFor: #icon!constants!public! !
!AXComponentWizard class categoriesFor: #initialize!initializing!private! !
!AXComponentWizard class categoriesFor: #publishedAspects!constants!development!public! !
!AXComponentWizard class categoriesFor: #registerServer!operations!public! !
!AXComponentWizard class categoriesFor: #resource_Default_view!public!resources-views! !
!AXComponentWizard class categoriesFor: #toolsFolderHelpId!public! !
!AXComponentWizard class categoriesFor: #uninitialize!class hierarchy-removing!private! !

