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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 5 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 5 nil nil nil 640 656710 1 ##(Smalltalk.CardLayout) 138 144 34 3 721414 ##(Smalltalk.Association) 8 '1' 410 ##(Smalltalk.ContainerView) 34 15 nil 640 34 2 8 1140850688 131073 816 nil nil nil 5 nil nil nil 816 610 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 816 34 2 8 1140850688 131073 896 nil nil nil 5 nil nil nil 896 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.StaticRectangle) 34 14 nil 896 34 2 8 1140916487 262145 1024 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 1024 nil 8 1921544656 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 1 1 578 689 5 1024 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 578 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1394 #fixedParentRight 1 1394 #fixedParentTop 1 1394 #fixedViewTop 5 410 ##(Smalltalk.PushButton) 34 20 nil 896 34 2 8 1140924416 1 1472 nil 1104 nil 5 nil nil nil 1472 nil 8 1921579760 1180998 4 ##(Smalltalk.CommandDescription) #libraryListNextCard 8 '&Next >' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 385 31 578 141 51 1472 1202 #isEnabled: 8 #(false) 1472 1202 #text: 34 1 8 '&Next >' 1472 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1394 #fixedViewRight -139 1424 -163 1440 31 1456 51 410 ##(Smalltalk.PushButton) 34 20 nil 896 34 2 8 1140924416 1 1872 nil 1104 nil 5 nil nil nil 1872 nil 8 1921579760 1554 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 545 31 578 141 51 1872 1202 #isEnabled: 8 #(false) 1872 1202 #text: 34 1 8 'Cancel' 1872 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 15 0 0 0 86 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -3 1440 31 1456 51 170 192 8 #() nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 723 578 689 81 896 1202 #text: 34 1 8 'Buttons' 896 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 3 1472 1872 1024 1344 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 816 34 2 8 1140850688 131073 2480 nil nil nil 5 nil nil nil 2480 962 170 176 34 12 410 ##(Smalltalk.PushButton) 34 20 nil 2480 34 2 8 1140924416 1 2592 nil 1104 nil 5 nil nil nil 2592 nil 8 1921579760 1554 #loadTypeLib 8 'Bro&wse...' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 535 507 578 141 51 2592 1202 #isEnabled: 8 #(false) 2592 1202 #text: 34 1 8 'Bro&wse...' 2592 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -13 1394 #fixedViewBottom -49 1394 #fixedParentBottom -165 410 ##(Smalltalk.StaticText) 34 16 nil 2480 34 2 8 1140850946 1 2992 nil nil nil 5 nil nil nil 2992 nil 8 1921544656 852486 ##(Smalltalk.NullConverter) nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 657 578 111 41 2992 1202 #text: 34 1 8 '&GUID:' 2992 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 8 #() 1344 nil 27 1362 1408 1 1394 #fixedViewLeft 111 2960 -39 2976 -25 410 ##(Smalltalk.StaticText) 34 16 nil 2480 34 2 8 1140850946 1 3344 nil nil nil 5 nil nil nil 3344 nil 8 1921544656 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 577 578 111 51 3344 1202 #text: 34 1 8 '&Location:' 3344 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 8 #() 1344 nil 27 1362 1408 1 3328 111 2960 -49 2976 -95 410 ##(Smalltalk.ListView) 34 30 nil 2480 34 2 8 1140953165 1025 3664 590662 2 ##(Smalltalk.ListModel) 138 144 2256 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1104 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 3 984134 2 ##(Smalltalk.CommandMenuItem) 1 1554 #browseIDL 8 '&Browse IDL' 1 1 nil nil nil 3858 1 1554 #inspectLibrary 8 '&Inspect' 1 1 nil nil nil 3858 1 1554 #typeLibHelp 8 '&Help' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3664 nil 8 1921599248 ##(Smalltalk.BasicListAbstract) nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Library' 251 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() 4162 #name 8 #() nil 3664 nil 1 nil nil 4114 8 'Version' 101 #left 4162 #versionString 8 #() 4162 #<= 8 #() nil nil 3664 nil 1 nil nil 4114 8 'Description' 327 #left ##(Smalltalk.BasicListAbstract) 4162 #<= 8 #() 4162 #helpstring 4288 nil 3664 nil 3 nil nil #report 2256 nil 133185 nil 34 4 nil nil 578 1 1 nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 1 1 578 685 487 3664 1202 #contextMenu: 34 1 3824 3664 1202 #text: 34 1 8 'Library' 3664 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 8 #() 1344 nil 27 1362 1408 1 1424 -3 1440 1 2976 -235 410 ##(Smalltalk.StaticText) 34 16 nil 2480 34 2 8 1140850944 1 4704 nil nil nil 5 nil nil nil 4704 nil 8 1921544656 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 131 577 578 631 61 4704 1202 #text: 34 1 8 'Path of selected library here...
on two lines if necessary.' 4704 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 32 1 0 0 124 1 0 0 62 1 0 0] 8 #() 1344 nil 27 1362 1408 131 3328 631 2960 -59 2976 -85 410 ##(Smalltalk.StaticText) 34 16 nil 2480 34 2 8 1140850944 1 5024 nil nil nil 5 nil nil nil 5024 nil 8 1921544656 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 131 657 578 631 41 5024 1202 #text: 34 1 8 'GUID of selected library here...' 5024 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 72 1 0 0 124 1 0 0 92 1 0 0] 8 #() 1344 nil 27 1362 1408 131 3328 631 2960 -39 2976 -25 170 192 34 6 5024 8 'guid' 3664 8 'typeLibs' 4704 8 'libraryPath' nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 1 1 578 689 723 2480 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 6 3664 2592 3344 4704 2992 5024 1344 nil 27 170 192 34 2 2480 8 'Libraries' nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 1 578 689 803 816 1202 #text: 34 1 8 'Step 1' 816 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 2480 896 1344 nil 27 770 8 '2' 410 ##(Smalltalk.ContainerView) 34 15 nil 640 34 2 8 1140850688 131073 5872 nil nil nil 5 nil nil nil 5872 610 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 5872 34 2 8 1140850688 131073 5952 nil nil nil 5 nil nil nil 5952 962 170 176 34 8 410 ##(Smalltalk.StaticRectangle) 34 14 nil 5952 34 2 8 1140916487 262145 6064 nil 1104 nil 5 nil nil nil 6064 nil 8 1921544656 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 1 1 578 689 5 6064 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1344 nil 27 1362 1408 1 1424 1 1440 1 1456 5 410 ##(Smalltalk.PushButton) 34 20 nil 5952 34 2 8 1140924416 1 6320 nil 1104 nil 5 nil nil nil 6320 nil 8 1921579760 1554 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 385 31 578 141 51 6320 1202 #text: 34 1 8 '&Next >' 6320 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -163 1440 31 1456 51 410 ##(Smalltalk.PushButton) 34 20 nil 5952 34 2 8 1140924416 1 6656 nil 1104 nil 5 nil nil nil 6656 nil 8 1921579760 1554 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 245 31 578 141 51 6656 1202 #isEnabled: 8 #(false) 6656 1202 #text: 34 1 8 '< &Back' 6656 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -303 1440 31 1456 51 410 ##(Smalltalk.PushButton) 34 20 nil 5952 34 2 8 1140924416 1 7024 nil 1104 nil 5 nil nil nil 7024 nil 8 1921579760 1554 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 549 31 578 141 51 7024 1202 #isEnabled: 8 #(false) 7024 1202 #text: 34 1 8 'Cancel' 7024 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 1 1440 31 1456 51 170 192 2256 nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 723 578 689 81 5952 1202 #text: 34 1 8 'Buttons' 5952 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 4 6656 6320 7024 6064 1344 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 5872 34 2 8 1140850688 131073 7616 nil nil nil 5 nil nil nil 7616 962 170 176 34 40 410 ##(Smalltalk.GroupBox) 34 14 nil 7616 34 2 8 1140850695 65 7728 nil nil nil 5 nil nil nil 7728 nil 8 1921579760 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 43 431 578 621 101 7728 1202 #text: 34 1 8 '&Tracing:' 7728 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 21 0 0 0 215 0 0 0 75 1 0 0 9 1 0 0] 8 #() 1344 nil 27 1362 1408 43 3328 621 1440 431 1456 101 410 ##(Smalltalk.TextEdit) 34 16 nil 7616 34 2 8 1140916224 1025 8032 nil 1104 nil 5 nil nil nil 8032 nil 8 1921567088 3074 nil nil 1 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 291 11 578 335 41 8032 1202 #setMarginWidths: 34 1 8 #(3 3) 8032 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 5 0 0 0 56 1 0 0 25 0 0 0] 8 #() 1344 nil 27 1362 1408 291 1424 -63 1440 11 1456 41 410 ##(Smalltalk.TextEdit) 34 16 nil 7616 34 2 8 1140916224 1025 8352 nil 1104 nil 5 nil nil nil 8352 nil 8 1921567088 3074 nil nil 1 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 291 71 578 335 41 8352 1202 #setMarginWidths: 34 1 8 #(3 3) 8352 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 35 0 0 0 56 1 0 0 55 0 0 0] 8 #() 1344 nil 27 1362 1408 291 1424 -63 1440 71 1456 41 410 ##(Smalltalk.GroupBox) 34 14 nil 7616 34 2 8 1140850695 65 8672 nil nil nil 5 nil nil nil 8672 nil 8 1921579760 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 13 271 578 665 441 8672 1202 #text: 34 1 8 'Ad&vanced' 8672 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 135 0 0 0 82 1 0 0 99 1 0 0] 8 #() 1344 nil 27 1362 1408 13 1424 -11 1440 271 1456 441 410 ##(Smalltalk.PushButton) 34 20 nil 7616 34 2 8 1140924416 1 8976 nil 1104 nil 5 nil nil nil 8976 nil 8 1921579760 1554 #choosePackage 8 '...' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 645 71 578 41 41 8976 1202 #isEnabled: 8 #(false) 8976 1202 #text: 34 1 8 '...' 8976 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 66 1 0 0 35 0 0 0 86 1 0 0 55 0 0 0] 8 #() 1344 nil 29 1362 1856 -39 1424 -3 1440 71 1456 41 410 ##(Smalltalk.StaticText) 34 16 nil 7616 34 2 8 1140916480 1025 9344 nil nil nil 5 nil nil nil 9344 nil 8 1921544656 3074 nil nil nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 291 131 578 335 41 9344 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 65 0 0 0 56 1 0 0 85 0 0 0] 8 #() 1344 nil 27 1362 1408 291 1424 -63 1440 131 1456 41 410 ##(Smalltalk.CheckBox) 34 16 nil 7616 34 2 8 1140924451 1 9616 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 9616 nil 8 1921579760 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 539 578 411 61 9616 1202 #text: 34 1 8 'Define Method &Protocols:' 9616 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 13 1 0 0 235 0 0 0 43 1 0 0] 8 #() 1344 nil 27 1362 1408 61 3328 411 1440 539 1456 61 410 ##(Smalltalk.StaticText) 34 16 nil 7616 34 2 8 1140850944 1 10000 nil nil nil 5 nil nil nil 10000 nil 8 1921544656 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 81 71 578 181 31 10000 1202 #text: 34 1 8 'Default &Package:' 10000 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 35 0 0 0 130 0 0 0 50 0 0 0] 8 #() 1344 nil 27 1362 1408 81 3328 181 1440 71 1456 31 410 ##(Smalltalk.ComboBox) 34 17 nil 7616 34 2 8 1144063491 1025 10320 3730 138 144 2256 nil 3792 1104 nil 5 nil nil nil 10320 nil 8 1921433600 ##(Smalltalk.BasicListAbstract) 2256 101 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 441 381 578 185 47 10320 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 190 0 0 0 56 1 0 0 213 0 0 0] 8 #() 1344 nil 27 1362 1408 441 1424 -63 1440 381 1456 41 410 ##(Smalltalk.CheckBox) 34 16 nil 7616 34 2 8 1140924451 1 10608 9682 nil nil 9728 false nil nil 5 nil nil nil 10608 nil 8 1921579760 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 639 578 411 61 10608 1202 #text: 34 1 8 '&Lowercase secondary keywords' 10608 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 63 1 0 0 235 0 0 0 93 1 0 0] 8 #() 1344 nil 27 1362 1408 61 3328 411 1440 639 1456 61 410 ##(Smalltalk.StaticText) 34 16 nil 7616 34 2 8 1140850944 1 10944 nil nil nil 5 nil nil nil 10944 nil 8 1921544656 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 381 578 371 41 10944 1202 #text: 34 1 8 '&High-level wrapper methods:' 10944 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 190 0 0 0 215 0 0 0 210 0 0 0] 8 #() 1344 nil 27 1362 1408 61 3328 371 1440 381 1456 41 410 ##(Smalltalk.StaticText) 34 16 nil 7616 34 2 8 1140850944 65 11264 nil nil nil 5 nil nil nil 11264 nil 8 1921544656 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 321 578 281 41 11264 1202 #text: 34 1 8 '&Class Comments:' 11264 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 160 0 0 0 170 0 0 0 180 0 0 0] 8 #() 1344 nil 27 1362 1408 61 3328 281 1440 321 1456 41 410 ##(Smalltalk.CheckBox) 34 16 nil 7616 34 2 8 1140928291 1 11584 9682 nil nil 9728 false nil nil 5 nil nil nil 11584 nil 8 1921579760 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 421 471 578 211 41 11584 1202 #text: 34 1 8 'Verbose?' 11584 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 235 0 0 0 59 1 0 0 255 0 0 0] 8 #() 1344 nil 27 1362 1408 421 3328 211 1440 471 1456 41 410 ##(Smalltalk.ComboBox) 34 17 nil 7616 34 2 8 1144063491 1025 11920 3730 138 144 2256 nil 3792 1104 nil 5 nil nil nil 11920 nil 8 1921433600 ##(Smalltalk.BasicListAbstract) 2256 401 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 61 471 578 185 47 11920 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 235 0 0 0 122 0 0 0 2 1 0 0] 8 #() 1344 nil 27 1362 1408 61 1424 -443 1440 471 1456 43 410 ##(Smalltalk.CheckBox) 34 16 nil 7616 34 2 8 1140924419 1 12208 9682 nil nil 9728 false nil nil 5 nil nil nil 12208 nil 8 1921579760 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 41 131 578 241 43 12208 1202 #text: 34 1 8 'Typelib &global:' 12208 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 65 0 0 0 140 0 0 0 86 0 0 0] 8 #() 1344 nil 27 1362 1408 41 3328 241 1440 131 1456 43 410 ##(Smalltalk.TextEdit) 34 16 nil 7616 34 2 8 1140916352 1025 12544 nil 1104 nil 5 nil nil nil 12544 nil 8 1921567088 3074 nil nil 1 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 291 191 578 335 41 12544 1202 #setMarginWidths: 34 1 8 #(3 3) 12544 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 95 0 0 0 56 1 0 0 115 0 0 0] 8 #() 1344 nil 27 1362 1408 291 1424 -63 1440 191 1456 41 410 ##(Smalltalk.StaticText) 34 16 nil 7616 34 2 8 1140850944 1 12864 nil nil nil 5 nil nil nil 12864 nil 8 1921544656 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 81 191 578 171 43 12864 1202 #text: 34 1 8 'C&onstants pool:' 12864 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 95 0 0 0 125 0 0 0 116 0 0 0] 8 #() 1344 nil 27 1362 1408 81 3328 171 1440 191 1456 43 410 ##(Smalltalk.ComboBox) 34 17 nil 7616 34 2 8 1144063491 1025 13184 3730 138 144 2256 nil 3792 1104 nil 5 nil nil nil 13184 nil 8 1921433600 ##(Smalltalk.BasicListAbstract) 2256 151 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 441 321 578 185 47 13184 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 160 0 0 0 56 1 0 0 183 0 0 0] 8 #() 1344 nil 27 1362 1408 441 1424 -63 1440 321 1456 41 410 ##(Smalltalk.CheckBox) 34 16 nil 7616 34 2 8 1140924419 1 13472 9682 nil nil 9728 false nil nil 5 nil nil nil 13472 nil 8 1921579760 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 51 11 578 211 43 13472 1202 #text: 34 1 8 'Class pre&fix:' 13472 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 0 0 0 5 0 0 0 130 0 0 0 26 0 0 0] 8 #() 1344 nil 27 1362 1408 51 3328 211 1440 11 1456 43 410 ##(Smalltalk.CheckBox) 34 16 nil 7616 34 2 8 1140924451 1 13808 9682 nil nil 9728 false nil nil 5 nil nil nil 13808 nil 8 1921579760 3074 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 589 578 411 61 13808 1202 #text: 34 1 8 'Generate #&defineFunctions:' 13808 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 38 1 0 0 235 0 0 0 68 1 0 0] 8 #() 1344 nil 27 1362 1408 61 3328 411 1440 589 1456 61 170 192 34 26 8032 8 'prefix' 10320 8 'highLevelWrappers' 9616 8 'defineProtocols' 12544 8 'constantsPoolName' 11584 8 'verboseTrace' 13472 8 'prefixClasses' 13808 8 'defineFunctions' 8352 8 'packageName' 12208 8 'generateTypelib' 11920 8 'tracing' 9344 8 'globalName' 13184 8 'commentGeneration' 10608 8 'lowercaseKeywords' nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 1 578 689 723 7616 1202 #text: 34 1 8 'Generation Parameters' 7616 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 20 13472 8032 10000 8352 8976 12864 12208 9344 12544 8672 11264 13184 10944 10320 7728 11920 11584 9616 13808 10608 1344 nil 27 170 192 2256 nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 1 578 689 803 5872 1202 #text: 34 1 8 'Step 2' 5872 1282 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 7616 5952 1344 nil 27 770 8 '3' 410 ##(Smalltalk.ContainerView) 34 15 nil 640 34 2 8 1140850688 131073 14848 nil nil nil 5 nil nil nil 14848 610 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 14848 34 2 8 1140850688 131073 14928 nil nil nil 5 nil nil nil 14928 962 170 176 34 8 410 ##(Smalltalk.PushButton) 34 20 nil 14928 34 2 8 1140924416 1 15040 nil 1104 nil 5 nil nil nil 15040 nil 8 1921579760 1554 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 245 31 578 141 51 15040 1202 #isEnabled: 8 #(false) 15040 1202 #text: 34 1 8 '< &Back' 15040 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -303 1440 31 1456 51 410 ##(Smalltalk.PushButton) 34 20 nil 14928 34 2 8 1140924416 1 15408 nil 1104 nil 5 nil nil nil 15408 nil 8 1921579760 1554 #finish 8 '&Finish' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 385 31 578 141 51 15408 1202 #isEnabled: 8 #(false) 15408 1202 #text: 34 1 8 '&Finish' 15408 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -163 1440 31 1456 51 410 ##(Smalltalk.PushButton) 34 20 nil 14928 34 2 8 1140924416 1 15776 nil 1104 nil 5 nil nil nil 15776 nil 8 1921579760 1554 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 539 31 578 151 51 15776 1202 #isEnabled: 8 #(false) 15776 1202 #text: 34 1 8 'Cancel' 15776 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -149 1424 1 1440 31 1456 51 410 ##(Smalltalk.StaticRectangle) 34 14 nil 14928 34 2 8 1140916487 262145 16144 nil 1104 nil 5 nil nil nil 16144 nil 8 1921544656 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 1 1 578 689 5 16144 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1344 nil 27 1362 1408 1 1424 1 1440 1 1456 5 170 192 2256 nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 723 578 689 81 14928 1202 #text: 34 1 8 'Buttons' 14928 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 4 15040 15408 15776 16144 1344 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 14848 34 2 8 1140850688 131073 16624 nil nil nil 5 nil nil nil 16624 962 170 176 34 4 410 ##(Smalltalk.PushButton) 34 20 nil 16624 34 2 8 1140924416 1 16736 nil 1104 nil 5 nil nil nil 16736 nil 8 1921579760 1554 #generate 8 '&Generate' 1 1 nil nil true nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 535 647 578 141 51 16736 1202 #isEnabled: 8 #(false) 16736 1202 #text: 34 1 8 '&Generate' 16736 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 67 1 0 0 81 1 0 0 92 1 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -13 2960 -49 2976 -25 410 ##(Smalltalk.ListView) 34 30 nil 16624 34 2 8 1140920393 1025 17104 3730 138 144 2256 nil 3792 1104 nil 5 3810 nil true 34 6 3858 1 1554 #selectAll 8 'Select &All' 1 1 nil nil nil 3858 1 1554 #selectInstalled 8 'Select &Installed' 1 1 nil nil nil 3858 1 1554 #selectUninstalled 8 'Select &Uninstalled' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3858 1 1554 #browseTypeClass 8 'Browse &Class' 1 1 nil nil nil 3858 1 1554 #browseTypesIDL 8 '&Browse IDL' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 17104 nil 8 1921599248 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 4064 nil 4162 #helpstring 8 #() nil 578 65 65 nil nil 138 144 34 3 4114 8 'Name' 437 #left ##(Smalltalk.BasicListAbstract) 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] #name 17664 7 513 nil nil nil 17104 ##(Smalltalk.IconicListAbstract) 3 nil nil 4114 8 '' 41 #left nil 17650 0 nil 17682 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 17792 7 513 nil 17650 0 nil 17682 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each isInstalled]' 8 #[30 105 17 158 106] #isInstalled 17872 7 257 nil nil 17104 ##(Smalltalk.IconicListAbstract) 1 nil nil 4114 8 'Type' 201 #left ##(Smalltalk.BasicListAbstract) 4162 #<= 8 #() 17650 0 nil 17682 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each idlKeyword]' 8 #[30 105 17 158 106] #idlKeyword 18016 7 257 nil nil 17104 nil 1 nil nil #report 2256 nil 133157 nil 34 4 nil nil 578 1 1 nil 1138 138 144 34 4 1202 #createAt:extent: 34 2 578 1 1 578 685 617 17104 1202 #contextMenu: 34 1 17200 17104 1202 #text: 34 1 8 'Name' 17104 1202 #columnOrder: 34 1 8 #(2 1 3) 17104 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 52 1 0 0] 8 #() 1344 nil 27 1362 1408 1 1424 -3 1440 1 2976 -105 170 192 34 2 17104 8 'interfaces' nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 1 1 578 689 723 16624 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 2 17104 16736 1344 nil 27 170 192 34 2 16624 8 'Classes' nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 1 578 689 803 14848 1202 #text: 34 1 8 'Step 3' 14848 1282 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 16624 14928 1344 nil 27 816 nil nil nil 170 192 2256 nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 21 21 578 689 803 640 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 155 1 0 0] 34 3 816 5872 14848 1344 nil 27 170 192 34 2 640 8 'cards' 590342 ##(Smalltalk.Rectangle) 578 21 21 578 21 21 nil nil nil nil 15867 nil nil nil 578 681 901 1 nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 53 53 578 761 921 416 1202 #text: 34 1 8 'ActiveX Component Wizard' 416 1202 #updateMenuBar 2256 416 1282 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 26 0 0 0 26 0 0 0 150 1 0 0 230 1 0 0] 34 1 640 1344 nil 27 )!

toolsFolderHelpId
	^10604! !
!AXComponentWizard class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!AXComponentWizard class categoriesFor: #displayOn:!displaying!public! !
!AXComponentWizard class categoriesFor: #icon!constants!public! !
!AXComponentWizard class categoriesFor: #initialize!initializing!private! !
!AXComponentWizard class categoriesFor: #registerServer!operations!public! !
!AXComponentWizard class categoriesFor: #resource_Default_view!public!resources-views! !
!AXComponentWizard class categoriesFor: #toolsFolderHelpId!public! !

