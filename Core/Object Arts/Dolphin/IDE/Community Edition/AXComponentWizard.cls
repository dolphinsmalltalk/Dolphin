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
!AXComponentWizard categoriesForClass!MVP-Presenters! !
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

	aStream nextPutAll: 'COM Component Wizard'!

icon
	"Answers an Icon that can be used to represent this class."

	^AXTypeLibraryAnalyzer icon!

initialize
	"Private - Initialize the receiver.

		self initialize.
	"

	Smalltalk developmentSystem
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 5 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 5 nil nil nil 640 655878 ##(Smalltalk.CardLayout) 138 144 34 3 721414 ##(Smalltalk.Association) 8 '1' 410 ##(Smalltalk.ContainerView) 34 15 nil 640 34 2 8 1140850688 131073 816 nil nil nil 5 nil nil nil 816 610 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 816 34 2 8 1140850688 131073 896 nil nil nil 5 nil nil nil 896 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.PushButton) 34 20 nil 896 34 2 8 1140924416 1 1024 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil nil nil 1024 nil 8 1915188384 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 545 31 578 141 51 1024 1266 #isEnabled: 8 #(false) 1024 1266 #text: 34 1 8 'Cancel' 1024 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 15 0 0 0 86 1 0 0 40 0 0 0] 8 #() 578 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedViewRight -139 1538 #fixedParentRight -3 1538 #fixedParentTop 31 1538 #fixedViewTop 51 410 ##(Smalltalk.StaticRectangle) 34 14 nil 896 34 2 8 1140916487 262145 1616 nil 1104 nil 5 nil nil nil 1616 nil 8 1915124368 1202 138 144 34 1 1266 #createAt:extent: 34 2 578 1 1 578 689 5 1616 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1488 nil 27 1506 1538 #fixedParentLeft 1 1568 1 1584 1 1600 5 410 ##(Smalltalk.PushButton) 34 20 nil 896 34 2 8 1140924416 1 1888 nil 1104 nil 5 nil nil nil 1888 nil 8 1915188384 1154 #libraryListNextCard 8 '&Next >' 1 1 nil nil false nil nil nil 1202 138 144 34 3 1266 #createAt:extent: 34 2 578 385 31 578 141 51 1888 1266 #isEnabled: 8 #(false) 1888 1266 #text: 34 1 8 '&Next >' 1888 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1488 nil 29 1506 1552 -139 1568 -163 1584 31 1600 51 170 192 8 #() nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 1 723 578 689 81 896 1266 #text: 34 1 8 'Buttons' 896 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 3 1888 1024 1616 1488 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 816 34 2 8 1140850688 131073 2496 nil nil nil 5 nil nil nil 2496 962 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 nil 2496 34 2 8 1140850946 1 2608 nil nil nil 5 nil nil nil 2608 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 1 577 578 111 51 2608 1266 #text: 34 1 8 '&Location:' 2608 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 8 #() 1488 nil 27 1506 1872 1 1538 #fixedViewLeft 111 1538 #fixedViewBottom -49 1538 #fixedParentBottom -95 410 ##(Smalltalk.ListView) 34 30 nil 2496 34 2 8 1140953165 1025 2992 590662 2 ##(Smalltalk.ListModel) 138 144 2272 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1104 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 3 984134 2 ##(Smalltalk.CommandMenuItem) 1 1154 #browseIDL 8 '&Browse IDL' 1 1 nil nil nil 3186 1 1154 #inspectLibrary 8 '&Inspect' 1 1 nil nil nil 3186 1 1154 #typeLibHelp 8 '&Help' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2992 nil 8 1915211424 ##(Smalltalk.BasicListAbstract) nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Library' 251 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 459270 ##(Smalltalk.Message) #name 8 #() nil 2992 nil 1 nil nil 3442 8 'Version' 101 #left 3490 #versionString 8 #() ##(Smalltalk.SortedCollection) nil nil 2992 nil 1 nil nil 3442 8 'Description' 327 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 3490 #helpstring 3584 nil 2992 nil 3 nil nil #report 2272 nil 133185 nil 34 4 nil nil 578 1 1 nil 1202 138 144 34 3 1266 #createAt:extent: 34 2 578 1 1 578 685 487 2992 1266 #contextMenu: 34 1 3152 2992 1266 #text: 34 1 8 'Library' 2992 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 8 #() 1488 nil 27 1506 1872 1 1568 -3 1584 1 2976 -235 410 ##(Smalltalk.StaticText) 34 16 nil 2496 34 2 8 1140850944 1 3936 nil nil nil 5 nil nil nil 3936 nil 8 1915124368 2690 nil nil nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 131 657 578 631 41 3936 1266 #text: 34 1 8 'GUID of selected library here...' 3936 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 72 1 0 0 124 1 0 0 92 1 0 0] 8 #() 1488 nil 27 1506 1872 131 2944 631 2960 -39 2976 -25 410 ##(Smalltalk.PushButton) 34 20 nil 2496 34 2 8 1140924416 1 4256 nil 1104 nil 5 nil nil nil 4256 nil 8 1915188384 1154 #loadTypeLib 8 'Bro&wse...' 1 1 nil nil false nil nil nil 1202 138 144 34 3 1266 #createAt:extent: 34 2 578 535 507 578 141 51 4256 1266 #isEnabled: 8 #(false) 4256 1266 #text: 34 1 8 'Bro&wse...' 4256 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 8 #() 1488 nil 29 1506 1552 -139 1568 -13 2960 -49 2976 -165 410 ##(Smalltalk.StaticText) 34 16 nil 2496 34 2 8 1140850946 1 4624 nil nil nil 5 nil nil nil 4624 nil 8 1915124368 2690 nil nil nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 1 657 578 111 41 4624 1266 #text: 34 1 8 '&GUID:' 4624 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 8 #() 1488 nil 27 1506 1872 1 2944 111 2960 -39 2976 -25 410 ##(Smalltalk.StaticText) 34 16 nil 2496 34 2 8 1140850944 1 4944 nil nil nil 5 nil nil nil 4944 nil 8 1915124368 2690 nil nil nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 131 577 578 631 61 4944 1266 #text: 34 1 8 'Path of selected library here...
on two lines if necessary.' 4944 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 32 1 0 0 124 1 0 0 62 1 0 0] 8 #() 1488 nil 27 1506 1872 131 2944 631 2960 -59 2976 -85 170 192 34 6 4944 8 'libraryPath' 2992 8 'typeLibs' 3936 8 'guid' nil 1202 138 144 34 1 1266 #createAt:extent: 34 2 578 1 1 578 689 723 2496 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 6 2992 4256 2608 4944 4624 3936 1488 nil 27 170 192 34 2 2496 8 'Libraries' nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 1 1 578 689 803 816 1266 #text: 34 1 8 'Step 1' 816 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 2496 896 1488 nil 27 770 8 '2' 410 ##(Smalltalk.ContainerView) 34 15 nil 640 34 2 8 1140850688 131073 5792 nil nil nil 5 nil nil nil 5792 610 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 5792 34 2 8 1140850688 131073 5872 nil nil nil 5 nil nil nil 5872 962 170 176 34 8 410 ##(Smalltalk.PushButton) 34 20 nil 5872 34 2 8 1140924416 1 5984 nil 1104 nil 5 nil nil nil 5984 nil 8 1915188384 1154 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1202 138 144 34 3 1266 #createAt:extent: 34 2 578 549 31 578 141 51 5984 1266 #isEnabled: 8 #(false) 5984 1266 #text: 34 1 8 'Cancel' 5984 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 1488 nil 29 1506 1552 -139 1568 1 1584 31 1600 51 410 ##(Smalltalk.PushButton) 34 20 nil 5872 34 2 8 1140924416 1 6352 nil 1104 nil 5 nil nil nil 6352 nil 8 1915188384 1154 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 1202 138 144 34 3 1266 #createAt:extent: 34 2 578 245 31 578 141 51 6352 1266 #isEnabled: 8 #(false) 6352 1266 #text: 34 1 8 '< &Back' 6352 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 1488 nil 29 1506 1552 -139 1568 -303 1584 31 1600 51 410 ##(Smalltalk.PushButton) 34 20 nil 5872 34 2 8 1140924416 1 6720 nil 1104 nil 5 nil nil nil 6720 nil 8 1915188384 1154 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 385 31 578 141 51 6720 1266 #text: 34 1 8 '&Next >' 6720 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1488 nil 29 1506 1552 -139 1568 -163 1584 31 1600 51 410 ##(Smalltalk.StaticRectangle) 34 14 nil 5872 34 2 8 1140916487 262145 7056 nil 1104 nil 5 nil nil nil 7056 nil 8 1915124368 1202 138 144 34 1 1266 #createAt:extent: 34 2 578 1 1 578 689 5 7056 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1488 nil 27 1506 1872 1 1568 1 1584 1 1600 5 170 192 2272 nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 1 723 578 689 81 5872 1266 #text: 34 1 8 'Buttons' 5872 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 4 6352 6720 5984 7056 1488 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 5792 34 2 8 1140850688 131073 7536 nil nil nil 5 nil nil nil 7536 962 170 176 34 40 410 ##(Smalltalk.CheckBox) 34 16 nil 7536 34 2 8 1140924419 1 7648 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 7648 nil 8 1915188384 2690 nil nil nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 41 131 578 241 43 7648 1266 #text: 34 1 8 'Typelib &global:' 7648 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 65 0 0 0 140 0 0 0 86 0 0 0] 8 #() 1488 nil 27 1506 1872 41 2944 241 1584 131 1600 43 410 ##(Smalltalk.CheckBox) 34 16 nil 7536 34 2 8 1140924419 1 8032 7714 nil nil 7760 false nil nil 5 nil nil nil 8032 nil 8 1915188384 2690 nil nil nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 51 11 578 211 43 8032 1266 #text: 34 1 8 'Class pre&fix:' 8032 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 0 0 0 5 0 0 0 130 0 0 0 26 0 0 0] 8 #() 1488 nil 27 1506 1872 51 2944 211 1584 11 1600 43 410 ##(Smalltalk.StaticText) 34 16 nil 7536 34 2 8 1140850944 1 8368 nil nil nil 5 nil nil nil 8368 nil 8 1915124368 2690 nil nil nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 61 381 578 371 41 8368 1266 #text: 34 1 8 '&High-level wrapper methods:' 8368 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 190 0 0 0 215 0 0 0 210 0 0 0] 8 #() 1488 nil 27 1506 1872 61 2944 371 1584 381 1600 41 410 ##(Smalltalk.CheckBox) 34 16 nil 7536 34 2 8 1140924451 1 8688 7714 nil nil 7760 false nil nil 5 nil nil nil 8688 nil 8 1915188384 2690 nil nil nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 61 589 578 411 61 8688 1266 #text: 34 1 8 'Generate #&defineFunctions:' 8688 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 38 1 0 0 235 0 0 0 68 1 0 0] 8 #() 1488 nil 27 1506 1872 61 2944 411 1584 589 1600 61 410 ##(Smalltalk.ComboBox) 34 17 nil 7536 34 2 8 1144063491 1025 9024 3058 138 144 2272 nil 3120 1104 nil 5 nil nil nil 9024 nil 8 1915002384 ##(Smalltalk.BasicListAbstract) 2272 151 1202 138 144 34 1 1266 #createAt:extent: 34 2 578 441 321 578 185 47 9024 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 160 0 0 0 56 1 0 0 183 0 0 0] 8 #() 1488 nil 27 1506 1872 441 1568 -63 1584 321 1600 41 410 ##(Smalltalk.StaticText) 34 16 nil 7536 34 2 8 1140850944 65 9312 nil nil nil 5 nil nil nil 9312 nil 8 1915124368 2690 nil nil nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 61 321 578 281 41 9312 1266 #text: 34 1 8 '&Class Comments:' 9312 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 160 0 0 0 170 0 0 0 180 0 0 0] 8 #() 1488 nil 27 1506 1872 61 2944 281 1584 321 1600 41 410 ##(Smalltalk.TextEdit) 34 16 nil 7536 34 2 8 1140916224 1025 9632 nil 1104 nil 5 nil nil nil 9632 nil 8 1915280032 2690 nil nil 1 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 291 11 578 335 41 9632 1266 #setMarginWidths: 34 1 8 #(3 3) 9632 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 5 0 0 0 56 1 0 0 25 0 0 0] 8 #() 1488 nil 27 1506 1872 291 1568 -63 1584 11 1600 41 410 ##(Smalltalk.ComboBox) 34 17 nil 7536 34 2 8 1144063491 1025 9952 3058 138 144 2272 nil 3120 1104 nil 5 nil nil nil 9952 nil 8 1915002384 ##(Smalltalk.BasicListAbstract) 2272 401 1202 138 144 34 1 1266 #createAt:extent: 34 2 578 61 471 578 185 47 9952 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 235 0 0 0 122 0 0 0 2 1 0 0] 8 #() 1488 nil 27 1506 1872 61 1568 -443 1584 471 1600 43 410 ##(Smalltalk.TextEdit) 34 16 nil 7536 34 2 8 1140916352 1025 10240 nil 1104 nil 5 nil nil nil 10240 nil 8 1915280032 2690 nil nil 1 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 291 191 578 335 41 10240 1266 #setMarginWidths: 34 1 8 #(3 3) 10240 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 95 0 0 0 56 1 0 0 115 0 0 0] 8 #() 1488 nil 27 1506 1872 291 1568 -63 1584 191 1600 41 410 ##(Smalltalk.StaticText) 34 16 nil 7536 34 2 8 1140850944 1 10560 nil nil nil 5 nil nil nil 10560 nil 8 1915124368 2690 nil nil nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 81 191 578 171 43 10560 1266 #text: 34 1 8 'C&onstants pool:' 10560 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 95 0 0 0 125 0 0 0 116 0 0 0] 8 #() 1488 nil 27 1506 1872 81 2944 171 1584 191 1600 43 410 ##(Smalltalk.PushButton) 34 20 nil 7536 34 2 8 1140924416 1 10880 nil 1104 nil 5 nil nil nil 10880 nil 8 1915188384 1154 #choosePackage 8 '...' 1 1 nil nil false nil nil nil 1202 138 144 34 3 1266 #createAt:extent: 34 2 578 645 71 578 41 41 10880 1266 #isEnabled: 8 #(false) 10880 1266 #text: 34 1 8 '...' 10880 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 66 1 0 0 35 0 0 0 86 1 0 0 55 0 0 0] 8 #() 1488 nil 29 1506 1552 -39 1568 -3 1584 71 1600 41 410 ##(Smalltalk.ComboBox) 34 17 nil 7536 34 2 8 1144063491 1025 11248 3058 138 144 2272 nil 3120 1104 nil 5 nil nil nil 11248 nil 8 1915002384 ##(Smalltalk.BasicListAbstract) 2272 101 1202 138 144 34 1 1266 #createAt:extent: 34 2 578 441 381 578 185 47 11248 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 190 0 0 0 56 1 0 0 213 0 0 0] 8 #() 1488 nil 27 1506 1872 441 1568 -63 1584 381 1600 41 410 ##(Smalltalk.StaticText) 34 16 nil 7536 34 2 8 1140850944 1 11536 nil nil nil 5 nil nil nil 11536 nil 8 1915124368 2690 nil nil nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 81 71 578 181 31 11536 1266 #text: 34 1 8 'Default &Package:' 11536 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 35 0 0 0 130 0 0 0 50 0 0 0] 8 #() 1488 nil 27 1506 1872 81 2944 181 1584 71 1600 31 410 ##(Smalltalk.GroupBox) 34 14 nil 7536 34 2 8 1140850695 65 11856 nil nil nil 5 nil nil nil 11856 nil 8 1915188384 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 13 271 578 665 441 11856 1266 #text: 34 1 8 'Ad&vanced' 11856 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 135 0 0 0 82 1 0 0 99 1 0 0] 8 #() 1488 nil 27 1506 1872 13 1568 -11 1584 271 1600 441 410 ##(Smalltalk.CheckBox) 34 16 nil 7536 34 2 8 1140924451 1 12160 7714 nil nil 7760 false nil nil 5 nil nil nil 12160 nil 8 1915188384 2690 nil nil nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 61 539 578 411 61 12160 1266 #text: 34 1 8 'Define Method &Protocols:' 12160 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 13 1 0 0 235 0 0 0 43 1 0 0] 8 #() 1488 nil 27 1506 1872 61 2944 411 1584 539 1600 61 410 ##(Smalltalk.GroupBox) 34 14 nil 7536 34 2 8 1140850695 65 12496 nil nil nil 5 nil nil nil 12496 nil 8 1915188384 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 43 431 578 621 101 12496 1266 #text: 34 1 8 '&Tracing:' 12496 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 21 0 0 0 215 0 0 0 75 1 0 0 9 1 0 0] 8 #() 1488 nil 27 1506 1872 43 2944 621 1584 431 1600 101 410 ##(Smalltalk.CheckBox) 34 16 nil 7536 34 2 8 1140924451 1 12800 7714 nil nil 7760 false nil nil 5 nil nil nil 12800 nil 8 1915188384 2690 nil nil nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 61 639 578 411 61 12800 1266 #text: 34 1 8 '&Lowercase secondary keywords' 12800 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 63 1 0 0 235 0 0 0 93 1 0 0] 8 #() 1488 nil 27 1506 1872 61 2944 411 1584 639 1600 61 410 ##(Smalltalk.StaticText) 34 16 nil 7536 34 2 8 1140916480 1025 13136 nil nil nil 5 nil nil nil 13136 nil 8 1915124368 2690 nil nil nil 1202 138 144 34 1 1266 #createAt:extent: 34 2 578 291 131 578 335 41 13136 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 65 0 0 0 56 1 0 0 85 0 0 0] 8 #() 1488 nil 27 1506 1872 291 1568 -63 1584 131 1600 41 410 ##(Smalltalk.CheckBox) 34 16 nil 7536 34 2 8 1140928291 1 13408 7714 nil nil 7760 false nil nil 5 nil nil nil 13408 nil 8 1915188384 2690 nil nil nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 421 471 578 211 41 13408 1266 #text: 34 1 8 'Verbose?' 13408 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 235 0 0 0 59 1 0 0 255 0 0 0] 8 #() 1488 nil 27 1506 1872 421 2944 211 1584 471 1600 41 410 ##(Smalltalk.TextEdit) 34 16 nil 7536 34 2 8 1140916224 1025 13744 nil 1104 nil 5 nil nil nil 13744 nil 8 1915280032 2690 nil nil 1 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 291 71 578 335 41 13744 1266 #setMarginWidths: 34 1 8 #(3 3) 13744 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 35 0 0 0 56 1 0 0 55 0 0 0] 8 #() 1488 nil 27 1506 1872 291 1568 -63 1584 71 1600 41 170 192 34 26 12800 8 'lowercaseKeywords' 9632 8 'prefix' 13408 8 'verboseTrace' 8688 8 'defineFunctions' 13744 8 'packageName' 11248 8 'highLevelWrappers' 9952 8 'tracing' 7648 8 'generateTypelib' 12160 8 'defineProtocols' 13136 8 'globalName' 8032 8 'prefixClasses' 10240 8 'constantsPoolName' 9024 8 'commentGeneration' nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 1 1 578 689 723 7536 1266 #text: 34 1 8 'Generation Parameters' 7536 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 20 8032 9632 11536 13744 10880 10560 7648 13136 10240 11856 9312 9024 8368 11248 12496 9952 13408 12160 8688 12800 1488 nil 27 170 192 2272 nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 1 1 578 689 803 5792 1266 #text: 34 1 8 'Step 2' 5792 1426 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 7536 5872 1488 nil 27 770 8 '3' 410 ##(Smalltalk.ContainerView) 34 15 nil 640 34 2 8 1140850688 131073 14768 nil nil nil 5 nil nil nil 14768 610 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 14768 34 2 8 1140850688 131073 14848 nil nil nil 5 nil nil nil 14848 962 170 176 34 8 410 ##(Smalltalk.PushButton) 34 20 nil 14848 34 2 8 1140924416 1 14960 nil 1104 nil 5 nil nil nil 14960 nil 8 1915188384 1154 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 1202 138 144 34 3 1266 #createAt:extent: 34 2 578 245 31 578 141 51 14960 1266 #isEnabled: 8 #(false) 14960 1266 #text: 34 1 8 '< &Back' 14960 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 1488 nil 29 1506 1552 -139 1568 -303 1584 31 1600 51 410 ##(Smalltalk.PushButton) 34 20 nil 14848 34 2 8 1140924416 1 15328 nil 1104 nil 5 nil nil nil 15328 nil 8 1915188384 1154 #finish 8 '&Finish' 1 1 nil nil false nil nil nil 1202 138 144 34 3 1266 #createAt:extent: 34 2 578 385 31 578 141 51 15328 1266 #isEnabled: 8 #(false) 15328 1266 #text: 34 1 8 '&Finish' 15328 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1488 nil 29 1506 1552 -139 1568 -163 1584 31 1600 51 410 ##(Smalltalk.StaticRectangle) 34 14 nil 14848 34 2 8 1140916487 262145 15696 nil 1104 nil 5 nil nil nil 15696 nil 8 1915124368 1202 138 144 34 1 1266 #createAt:extent: 34 2 578 1 1 578 689 5 15696 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1488 nil 27 1506 1872 1 1568 1 1584 1 1600 5 410 ##(Smalltalk.PushButton) 34 20 nil 14848 34 2 8 1140924416 1 15952 nil 1104 nil 5 nil nil nil 15952 nil 8 1915188384 1154 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1202 138 144 34 3 1266 #createAt:extent: 34 2 578 539 31 578 151 51 15952 1266 #isEnabled: 8 #(false) 15952 1266 #text: 34 1 8 'Cancel' 15952 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 1488 nil 29 1506 1552 -149 1568 1 1584 31 1600 51 170 192 2272 nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 1 723 578 689 81 14848 1266 #text: 34 1 8 'Buttons' 14848 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 4 14960 15328 15952 15696 1488 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 14768 34 2 8 1140850688 131073 16544 nil nil nil 5 nil nil nil 16544 962 170 176 34 4 410 ##(Smalltalk.ListView) 34 30 nil 16544 34 2 8 1140920393 1025 16656 3058 138 144 2272 nil 3120 1104 nil 5 3138 nil true 34 6 3186 1 1154 #selectAll 8 'Select &All' 1 1 nil nil nil 3186 1 1154 #selectInstalled 8 'Select &Installed' 1 1 nil nil nil 3186 1 1154 #selectUninstalled 8 'Select &Uninstalled' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3186 1 1154 #browseTypeClass 8 'Browse &Class' 1 1 nil nil nil 3186 1 1154 #browseTypesIDL 8 '&Browse IDL' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 16656 nil 8 1915211424 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 3392 nil 3490 #helpstring 8 #() nil 578 65 65 nil nil 138 144 34 3 3442 8 'Name' 437 #left ##(Smalltalk.BasicListAbstract) 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] #name 17216 7 513 nil nil nil 16656 ##(Smalltalk.IconicListAbstract) 3 nil nil 3442 8 '' 41 #left nil 17202 0 nil 17234 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 17344 7 513 nil 17202 0 nil 17234 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each isInstalled]' 8 #[30 105 17 158 106] #isInstalled 17424 7 257 nil nil 16656 ##(Smalltalk.IconicListAbstract) 1 nil nil 3442 8 'Type' 201 #left ##(Smalltalk.BasicListAbstract) 17202 0 nil 918822 ##(Smalltalk.CompiledMethod) 1 83886081 106 8 'Dolphin' 8 'SortedCollection' #defaultSortBlock 1512711171 8 #[29 105 233 1 130 106] 17536 7 513 nil 17202 0 nil 17234 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each idlKeyword]' 8 #[30 105 17 158 106] #idlKeyword 17648 7 257 nil nil 16656 nil 1 nil nil #report 2272 nil 133157 nil 8 #(nil) 1202 138 144 34 4 1266 #createAt:extent: 34 2 578 1 1 578 685 617 16656 1266 #contextMenu: 34 1 16752 16656 1266 #text: 34 1 8 'Name' 16656 1266 #columnOrder: 34 1 8 #(2 1 3) 16656 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 52 1 0 0] 8 #() 1488 nil 27 1506 1872 1 1568 -3 1584 1 2976 -105 410 ##(Smalltalk.PushButton) 34 20 nil 16544 34 2 8 1140924416 1 18048 nil 1104 nil 5 nil nil nil 18048 nil 8 1915188384 1154 #generate 8 '&Generate' 1 1 nil nil true nil nil nil 1202 138 144 34 3 1266 #createAt:extent: 34 2 578 535 647 578 141 51 18048 1266 #isEnabled: 8 #(false) 18048 1266 #text: 34 1 8 '&Generate' 18048 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 67 1 0 0 81 1 0 0 92 1 0 0] 8 #() 1488 nil 29 1506 1552 -139 1568 -13 2960 -49 2976 -25 170 192 34 2 16656 8 'interfaces' nil 1202 138 144 34 1 1266 #createAt:extent: 34 2 578 1 1 578 689 723 16544 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 2 16656 18048 1488 nil 27 170 192 34 2 16544 8 'Classes' nil 1202 138 144 34 2 1266 #createAt:extent: 34 2 578 1 1 578 689 803 14768 1266 #text: 34 1 8 'Step 3' 14768 1426 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 16544 14848 1488 nil 27 816 170 192 2272 nil 1202 138 144 34 1 1266 #createAt:extent: 34 2 578 21 21 578 689 803 640 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 155 1 0 0] 34 3 816 5792 14768 1488 nil 27 170 192 34 2 640 8 'cards' 590342 ##(Smalltalk.Rectangle) 578 21 21 578 21 21 nil nil nil nil 9855 nil nil nil 578 681 901 1 nil nil 1202 138 144 34 3 1266 #createAt:extent: 34 2 578 313 313 578 761 921 416 1266 #text: 34 1 8 'ActiveX Component Wizard' 416 1266 #updateMenuBar 2272 416 1426 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 156 0 0 0 156 0 0 0 24 2 0 0 104 2 0 0] 34 1 640 1488 nil 27 )!

toolsFolderHelpId
	^10604!

uninitialize
	"Private - Un-register the system tools folder icon for the receiver to allow clean
	removal of this class from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
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

