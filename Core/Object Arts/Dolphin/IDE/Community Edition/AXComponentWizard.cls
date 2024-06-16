"Filed out from Dolphin Smalltalk"!

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

!AXComponentWizard categoriesForMethods!
apply!operations!private! !
browseIDL!commands!public! !
browseTypeClass!commands!public! !
browseTypesIDL!commands!public! !
cancel!commands!public! !
choosePackage!commands!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
displayInstalledTypeLib:!private!updating! !
finish!commands!public! !
generate!commands!public! !
inspectIt!commands!public! !
inspectItCommand!public! !
inspectLibrary!commands!public! !
inspectType!public! !
libraryListNextCard!commands!public! !
loadTypeLib!commands!public! !
onTypeLibrarySelected!event handling!private! !
onViewOpened!event handling!public! !
queryCommand:!commands!private! !
refresh!commands!public! !
selectInstalled!commands!public! !
selectUninstalled!commands!public! !
typeLib!accessing!public! !
typeLib:!accessing!public! !
typeLibHelp!commands!public! !
updateClassPrefix!private!updating! !
updateTypelibGlobal!private!updating! !
updateTypesList:!private!updating! !
!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 5 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 66 0 97 0 104 0 110 0 115 0 99 0 104 0 114 0 105 0 102 0 116 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 656710 1 ##(Smalltalk.CardLayout) 138 144 34 3 721414 ##(Smalltalk.Association) 8 '1' 410 ##(Smalltalk.ContainerView) 34 15 nil 608 34 2 8 1140850688 131073 784 nil nil nil 5 nil nil nil 784 578 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 784 34 2 8 1140850688 131073 864 nil nil nil 5 nil nil nil 864 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.PushButton) 34 20 nil 864 34 2 8 1140924416 1 992 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 992 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #libraryListNextCard 8 '&Next >' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 193 1024 8 '&Next >' 992 1218 #isEnabled: 8 #(false) 992 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedViewRight -139 1474 #fixedParentRight -163 1474 #fixedParentTop 31 1474 #fixedViewTop 51 410 ##(Smalltalk.StaticRectangle) 34 14 nil 864 34 2 8 1140916487 262145 1552 nil 1072 nil 5 nil nil nil 1552 nil 8 1759212608 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 193 1584 nil 1552 3 8 #() 1410 193 193 nil 27 1442 1474 #fixedParentLeft 1 1504 1 1520 1 1536 5 410 ##(Smalltalk.PushButton) 34 20 nil 864 34 2 8 1140924416 1 1824 nil 1072 nil 5 nil nil nil 1824 nil 8 1759007584 1106 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[16 1 0 0 15 0 0 0 86 1 0 0 40 0 0 0] 193 1856 8 'Cancel' 1824 1218 #isEnabled: 8 #(false) 1824 3 8 #() 1410 193 193 nil 29 1442 1488 -139 1504 -3 1520 31 1536 51 170 192 8 #() nil 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 193 896 8 'Buttons' 864 3 34 3 992 1824 1552 1410 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 784 34 2 8 1140850688 131073 2368 nil nil nil 5 nil nil nil 2368 930 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 nil 2368 34 2 8 1140850944 1 2480 nil nil nil 5 nil nil nil 2480 nil 8 1759212608 852486 ##(Smalltalk.NullConverter) nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[65 0 0 0 72 1 0 0 124 1 0 0 92 1 0 0] 193 2512 nil 2480 1218 #text: 34 1 8 'GUID of selected library here...' 2480 3 8 #() 1410 193 193 nil 27 1442 1808 131 1474 #fixedViewLeft 631 1474 #fixedViewBottom -39 1474 #fixedParentBottom -25 410 ##(Smalltalk.ListView) 34 45 nil 2368 34 2 8 1140953165 1025 2864 590662 2 ##(Smalltalk.ListModel) 138 144 2176 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1072 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 3 984134 2 ##(Smalltalk.CommandMenuItem) 1 1106 #browseIDL 8 '&Browse IDL' 1 1 nil nil nil 3058 1 1106 #inspectLibrary 8 '&Inspect' 1 1 nil nil nil 3058 1 1106 #typeLibHelp 8 '&Help' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2864 nil 8 1759068368 ##(Smalltalk.BasicListAbstract) nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Library' 251 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() 3362 #name 8 #() nil 2864 nil 1 nil nil 3314 8 'Version' 101 #left 3362 #versionString 8 #() 3362 #<= 8 #() nil nil 2864 nil 1 nil nil 3314 8 'Description' 327 #left ##(Smalltalk.BasicListAbstract) 3362 #<= 8 #() 3362 #helpstring 3488 nil 2864 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 193 2896 8 'Library' 2864 1218 #contextMenu: 34 1 3024 2864 3 8 #() 1410 193 193 nil 35 1442 1808 1 1504 -3 1520 1 2848 -235 410 ##(Smalltalk.StaticText) 34 16 nil 2368 34 2 8 1140850946 1 3856 nil nil nil 5 nil nil nil 3856 nil 8 1759212608 2562 nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 193 3888 nil 3856 1218 #text: 34 1 8 '&GUID:' 3856 3 8 #() 1410 193 193 nil 27 1442 1808 1 2816 111 2832 -39 2848 -25 410 ##(Smalltalk.StaticText) 34 16 nil 2368 34 2 8 1140850944 1 4176 nil nil nil 5 nil nil nil 4176 nil 8 1759212608 2562 nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[65 0 0 0 32 1 0 0 124 1 0 0 62 1 0 0] 193 4208 nil 4176 1218 #text: 34 1 8 'Path of selected library here...
on two lines if necessary.' 4176 3 8 #() 1410 193 193 nil 27 1442 1808 131 2816 631 2832 -59 2848 -85 410 ##(Smalltalk.PushButton) 34 20 nil 2368 34 2 8 1140924416 1 4496 nil 1072 nil 5 nil nil nil 4496 nil 8 1759007584 1106 #loadTypeLib 8 'Bro&wse...' 1 1 nil nil false nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 193 4528 8 'Bro&wse...' 4496 1218 #isEnabled: 8 #(false) 4496 3 8 #() 1410 193 193 nil 29 1442 1488 -139 1504 -13 2832 -49 2848 -165 410 ##(Smalltalk.StaticText) 34 16 nil 2368 34 2 8 1140850946 1 4832 nil nil nil 5 nil nil nil 4832 nil 8 1759212608 2562 nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 193 4864 nil 4832 1218 #text: 34 1 8 '&Location:' 4832 3 8 #() 1410 193 193 nil 27 1442 1808 1 2816 111 2832 -49 2848 -95 170 192 34 6 2480 8 'guid' 2864 8 'typeLibs' 4176 8 'libraryPath' nil 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 193 2400 8 '' 2368 3 34 6 2864 4496 4832 4176 3856 2480 1410 193 193 nil 27 170 192 34 2 2368 8 'Libraries' nil 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 193 816 8 'Step 1' 784 3 34 2 2368 864 1410 193 193 nil 27 738 8 '2' 410 ##(Smalltalk.ContainerView) 34 15 nil 608 34 2 8 1140850688 131073 5664 nil nil nil 5 nil nil nil 5664 578 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 5664 34 2 8 1140850688 131073 5744 nil nil nil 5 nil nil nil 5744 930 170 176 34 8 410 ##(Smalltalk.PushButton) 34 20 nil 5744 34 2 8 1140924416 1 5856 nil 1072 nil 5 nil nil nil 5856 nil 8 1759007584 1106 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[18 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 193 5888 8 'Cancel' 5856 1218 #isEnabled: 8 #(false) 5856 3 8 #() 1410 193 193 nil 29 1442 1488 -139 1504 1 1520 31 1536 51 410 ##(Smalltalk.PushButton) 34 20 nil 5744 34 2 8 1140924416 1 6192 nil 1072 nil 5 nil nil nil 6192 nil 8 1759007584 1106 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 193 6224 8 '< &Back' 6192 1218 #isEnabled: 8 #(false) 6192 3 8 #() 1410 193 193 nil 29 1442 1488 -139 1504 -303 1520 31 1536 51 410 ##(Smalltalk.PushButton) 34 20 nil 5744 34 2 8 1140924416 1 6528 nil 1072 nil 5 nil nil nil 6528 nil 8 1759007584 1106 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 193 6560 8 '&Next >' 6528 3 8 #() 1410 193 193 nil 29 1442 1488 -139 1504 -163 1520 31 1536 51 410 ##(Smalltalk.StaticRectangle) 34 14 nil 5744 34 2 8 1140916487 262145 6832 nil 1072 nil 5 nil nil nil 6832 nil 8 1759212608 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 193 6864 nil 6832 3 8 #() 1410 193 193 nil 27 1442 1808 1 1504 1 1520 1 1536 5 170 192 2176 nil 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 193 5776 8 'Buttons' 5744 3 34 4 6192 6528 5856 6832 1410 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 5664 34 2 8 1140850688 131073 7280 nil nil nil 5 nil nil nil 7280 930 170 176 34 40 410 ##(Smalltalk.TextEdit) 34 16 nil 7280 34 2 8 1140916224 1025 7392 nil 1072 nil 5 nil nil nil 7392 nil 8 1759000288 2562 nil nil 1 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[145 0 0 0 5 0 0 0 56 1 0 0 25 0 0 0] 193 7424 nil 7392 1218 #setMarginWidths: 34 1 8 #(3 3) 7392 3 8 #() 1410 193 193 nil 27 1442 1808 291 1504 -63 1520 11 1536 41 410 ##(Smalltalk.CheckBox) 34 16 nil 7280 34 2 8 1140924451 1 7712 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 7712 nil 8 1759007584 2562 nil nil nil 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[30 0 0 0 38 1 0 0 235 0 0 0 68 1 0 0] 193 7744 8 'Generate #&defineFunctions:' 7712 3 8 #() 1410 193 193 nil 27 1442 1808 61 2816 411 1520 589 1536 61 410 ##(Smalltalk.StaticText) 34 16 nil 7280 34 2 8 1140850944 1 8064 nil nil nil 5 nil nil nil 8064 nil 8 1759212608 2562 nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[40 0 0 0 95 0 0 0 125 0 0 0 116 0 0 0] 193 8096 nil 8064 1218 #text: 34 1 8 'C&onstants pool:' 8064 3 8 #() 1410 193 193 nil 27 1442 1808 81 2816 171 1520 191 1536 43 410 ##(Smalltalk.TextEdit) 34 16 nil 7280 34 2 8 1140916352 1025 8384 nil 1072 nil 5 nil nil nil 8384 nil 8 1759000288 2562 nil nil 1 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[145 0 0 0 95 0 0 0 56 1 0 0 115 0 0 0] 193 8416 nil 8384 1218 #setMarginWidths: 34 1 8 #(3 3) 8384 3 8 #() 1410 193 193 nil 27 1442 1808 291 1504 -63 1520 191 1536 41 410 ##(Smalltalk.ComboBox) 34 17 nil 7280 34 2 8 1144063491 1025 8704 2930 138 144 2176 nil 2992 1072 nil 5 nil nil nil 8704 nil 8 1758616864 ##(Smalltalk.BasicListAbstract) 3616 151 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[220 0 0 0 160 0 0 0 56 1 0 0 3 1 0 0] 193 8736 8 '' 8704 3 8 #() 1410 193 193 nil 27 1442 1808 441 1504 -63 1520 321 1536 41 410 ##(Smalltalk.CheckBox) 34 16 nil 7280 34 2 8 1140924451 1 9008 7778 nil nil 7824 false nil nil 5 nil nil nil 9008 nil 8 1759007584 2562 nil nil nil 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[30 0 0 0 63 1 0 0 235 0 0 0 93 1 0 0] 193 9040 8 '&Lowercase secondary keywords' 9008 3 8 #() 1410 193 193 nil 27 1442 1808 61 2816 411 1520 639 1536 61 410 ##(Smalltalk.ComboBox) 34 17 nil 7280 34 2 8 1144063491 1025 9312 2930 138 144 2176 nil 2992 1072 nil 5 nil nil nil 9312 nil 8 1758616864 ##(Smalltalk.BasicListAbstract) 3616 401 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[30 0 0 0 235 0 0 0 122 0 0 0 203 1 0 0] 193 9344 8 '' 9312 3 8 #() 1410 193 193 nil 27 1442 1808 61 1504 -443 1520 471 1536 43 410 ##(Smalltalk.GroupBox) 34 14 nil 7280 34 2 8 1140850695 65 9616 nil nil nil 5 nil nil nil 9616 nil 8 1759007584 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[21 0 0 0 215 0 0 0 75 1 0 0 9 1 0 0] 193 9648 8 '&Tracing:' 9616 3 8 #() 1410 193 193 nil 27 1442 1808 43 2816 621 1520 431 1536 101 410 ##(Smalltalk.CheckBox) 34 16 nil 7280 34 2 8 1140928291 1 9888 7778 nil nil 7824 false nil nil 5 nil nil nil 9888 nil 8 1759007584 2562 nil nil nil 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[210 0 0 0 235 0 0 0 59 1 0 0 255 0 0 0] 193 9920 8 'Verbose?' 9888 3 8 #() 1410 193 193 nil 27 1442 1808 421 2816 211 1520 471 1536 41 410 ##(Smalltalk.StaticText) 34 16 nil 7280 34 2 8 1140850944 1 10192 nil nil nil 5 nil nil nil 10192 nil 8 1759212608 2562 nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[40 0 0 0 35 0 0 0 130 0 0 0 50 0 0 0] 193 10224 nil 10192 1218 #text: 34 1 8 'Default &Package:' 10192 3 8 #() 1410 193 193 nil 27 1442 1808 81 2816 181 1520 71 1536 31 410 ##(Smalltalk.StaticText) 34 16 nil 7280 34 2 8 1140850944 1 10512 nil nil nil 5 nil nil nil 10512 nil 8 1759212608 2562 nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[30 0 0 0 190 0 0 0 215 0 0 0 210 0 0 0] 193 10544 nil 10512 1218 #text: 34 1 8 '&High-level wrapper methods:' 10512 3 8 #() 1410 193 193 nil 27 1442 1808 61 2816 371 1520 381 1536 41 410 ##(Smalltalk.PushButton) 34 20 nil 7280 34 2 8 1140924416 1 10832 nil 1072 nil 5 nil nil nil 10832 nil 8 1759007584 1106 #choosePackage 8 '...' 1 1 nil nil false nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[66 1 0 0 35 0 0 0 86 1 0 0 55 0 0 0] 193 10864 8 '...' 10832 1218 #isEnabled: 8 #(false) 10832 3 8 #() 1410 193 193 nil 29 1442 1488 -39 1504 -3 1520 71 1536 41 410 ##(Smalltalk.CheckBox) 34 16 nil 7280 34 2 8 1140924419 1 11168 7778 nil nil 7824 false nil nil 5 nil nil nil 11168 nil 8 1759007584 2562 nil nil nil 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[25 0 0 0 5 0 0 0 130 0 0 0 26 0 0 0] 193 11200 8 'Class pre&fix:' 11168 3 8 #() 1410 193 193 nil 27 1442 1808 51 2816 211 1520 11 1536 43 410 ##(Smalltalk.GroupBox) 34 14 nil 7280 34 2 8 1140850695 65 11472 nil nil nil 5 nil nil nil 11472 nil 8 1759007584 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[6 0 0 0 135 0 0 0 82 1 0 0 99 1 0 0] 193 11504 8 'Ad&vanced' 11472 3 8 #() 1410 193 193 nil 27 1442 1808 13 1504 -11 1520 271 1536 441 410 ##(Smalltalk.TextEdit) 34 16 nil 7280 34 2 8 1140916224 1025 11744 nil 1072 nil 5 nil nil nil 11744 nil 8 1759000288 2562 nil nil 1 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[145 0 0 0 35 0 0 0 56 1 0 0 55 0 0 0] 193 11776 nil 11744 1218 #setMarginWidths: 34 1 8 #(3 3) 11744 3 8 #() 1410 193 193 nil 27 1442 1808 291 1504 -63 1520 71 1536 41 410 ##(Smalltalk.ComboBox) 34 17 nil 7280 34 2 8 1144063491 1025 12064 2930 138 144 2176 nil 2992 1072 nil 5 nil nil nil 12064 nil 8 1758616864 ##(Smalltalk.BasicListAbstract) 3616 101 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[220 0 0 0 190 0 0 0 56 1 0 0 8 1 0 0] 193 12096 8 '' 12064 3 8 #() 1410 193 193 nil 27 1442 1808 441 1504 -63 1520 381 1536 41 410 ##(Smalltalk.StaticText) 34 16 nil 7280 34 2 8 1140850944 65 12368 nil nil nil 5 nil nil nil 12368 nil 8 1759212608 2562 nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[30 0 0 0 160 0 0 0 170 0 0 0 180 0 0 0] 193 12400 nil 12368 1218 #text: 34 1 8 '&Class Comments:' 12368 3 8 #() 1410 193 193 nil 27 1442 1808 61 2816 281 1520 321 1536 41 410 ##(Smalltalk.CheckBox) 34 16 nil 7280 34 2 8 1140924419 1 12688 7778 nil nil 7824 false nil nil 5 nil nil nil 12688 nil 8 1759007584 2562 nil nil nil 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[20 0 0 0 65 0 0 0 140 0 0 0 86 0 0 0] 193 12720 8 'Typelib &global:' 12688 3 8 #() 1410 193 193 nil 27 1442 1808 41 2816 241 1520 131 1536 43 410 ##(Smalltalk.CheckBox) 34 16 nil 7280 34 2 8 1140924451 1 12992 7778 nil nil 7824 false nil nil 5 nil nil nil 12992 nil 8 1759007584 2562 nil nil nil 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[30 0 0 0 13 1 0 0 235 0 0 0 43 1 0 0] 193 13024 8 'Define Method &Protocols:' 12992 3 8 #() 1410 193 193 nil 27 1442 1808 61 2816 411 1520 539 1536 61 410 ##(Smalltalk.StaticText) 34 16 nil 7280 34 2 8 1140916480 1025 13296 nil nil nil 5 nil nil nil 13296 nil 8 1759212608 2562 nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[145 0 0 0 65 0 0 0 56 1 0 0 85 0 0 0] 193 13328 nil 13296 1218 #text: 34 1 8 '' 13296 3 8 #() 1410 193 193 nil 27 1442 1808 291 1504 -63 1520 131 1536 41 170 192 34 26 7392 8 'prefix' 9888 8 'verboseTrace' 11168 8 'prefixClasses' 9312 8 'tracing' 8704 8 'commentGeneration' 12064 8 'highLevelWrappers' 9008 8 'lowercaseKeywords' 13296 8 'globalName' 12688 8 'generateTypelib' 7712 8 'defineFunctions' 11744 8 'packageName' 12992 8 'defineProtocols' 8384 8 'constantsPoolName' nil 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 193 7312 8 'Generation Parameters' 7280 3 34 20 11168 7392 10192 11744 10832 8064 12688 13296 8384 11472 12368 8704 10512 12064 9616 9312 9888 12992 7712 9008 1410 193 193 nil 27 170 192 2176 nil 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 193 5696 8 'Step 2' 5664 1 34 2 7280 5744 1410 193 193 nil 27 738 8 '3' 410 ##(Smalltalk.ContainerView) 34 15 nil 608 34 2 8 1140850688 131073 14256 nil nil nil 5 nil nil nil 14256 578 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 14256 34 2 8 1140850688 131073 14336 nil nil nil 5 nil nil nil 14336 930 170 176 34 8 410 ##(Smalltalk.PushButton) 34 20 nil 14336 34 2 8 1140924416 1 14448 nil 1072 nil 5 nil nil nil 14448 nil 8 1759007584 1106 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[13 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 193 14480 8 'Cancel' 14448 1218 #isEnabled: 8 #(false) 14448 3 8 #() 1410 193 193 nil 29 1442 1488 -149 1504 1 1520 31 1536 51 410 ##(Smalltalk.PushButton) 34 20 nil 14336 34 2 8 1140924416 1 14784 nil 1072 nil 5 nil nil nil 14784 nil 8 1759007584 1106 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 193 14816 8 '< &Back' 14784 1218 #isEnabled: 8 #(false) 14784 3 8 #() 1410 193 193 nil 29 1442 1488 -139 1504 -303 1520 31 1536 51 410 ##(Smalltalk.PushButton) 34 20 nil 14336 34 2 8 1140924416 1 15120 nil 1072 nil 5 nil nil nil 15120 nil 8 1759007584 1106 #finish 8 '&Finish' 1 1 nil nil false nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 193 15152 8 '&Finish' 15120 1218 #isEnabled: 8 #(false) 15120 3 8 #() 1410 193 193 nil 29 1442 1488 -139 1504 -163 1520 31 1536 51 410 ##(Smalltalk.StaticRectangle) 34 14 nil 14336 34 2 8 1140916487 262145 15456 nil 1072 nil 5 nil nil nil 15456 nil 8 1759212608 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 193 15488 nil 15456 3 8 #() 1410 193 193 nil 27 1442 1808 1 1504 1 1520 1 1536 5 170 192 2176 nil 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 193 14368 8 'Buttons' 14336 3 34 4 14784 15120 14448 15456 1410 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 14256 34 2 8 1140850688 131073 15904 nil nil nil 5 nil nil nil 15904 930 170 176 34 4 410 ##(Smalltalk.ListView) 34 45 nil 15904 34 2 8 1140920393 1025 16016 2930 138 144 2176 nil 2992 1072 nil 5 3010 nil true 34 6 3058 1 1106 #selectAll 8 'Select &All' 1 1 nil nil nil 3058 1 1106 #selectInstalled 8 'Select &Installed' 1 1 nil nil nil 3058 1 1106 #selectUninstalled 8 'Select &Uninstalled' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3058 1 1106 #browseTypeClass 8 'Browse &Class' 1 1 nil nil nil 3058 1 1106 #browseTypesIDL 8 '&Browse IDL' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 16016 nil 8 1759068368 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 3264 nil 3362 #helpstring 8 #() nil 1410 65 65 nil nil 138 144 34 3 3314 8 'Name' 437 #left ##(Smalltalk.BasicListAbstract) 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] #name 16576 7 513 nil nil nil 16016 ##(Smalltalk.IconicListAbstract) 3 nil nil 3314 8 '' 41 #left nil 16562 0 nil 16594 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 16704 7 513 nil 16562 0 nil 16594 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each isInstalled]' 8 #[30 105 17 158 106] #isInstalled 16784 7 257 nil nil 16016 ##(Smalltalk.IconicListAbstract) 1 nil nil 3314 8 'Type' 201 #left ##(Smalltalk.BasicListAbstract) 3362 #<= 8 #() 16562 0 nil 16594 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each idlKeyword]' 8 #[30 105 17 158 106] #idlKeyword 16928 7 257 nil nil 16016 nil 1 nil nil #report 3616 nil 133157 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1154 138 144 34 3 1218 #createWindow: 34 1 1266 1298 8 #[0 0 0 0 0 0 0 0 86 1 0 0 52 1 0 0] 193 16048 8 'Name' 16016 1218 #contextMenu: 34 1 16112 16016 1218 #columnOrder: 34 1 8 #(2 1 3) 16016 3 8 #() 1410 193 193 nil 35 1442 1808 1 1504 -3 1520 1 2848 -105 410 ##(Smalltalk.PushButton) 34 20 nil 15904 34 2 8 1140924416 1 17280 nil 1072 nil 5 nil nil nil 17280 nil 8 1759007584 1106 #generate 8 '&Generate' 1 1 nil nil true nil nil nil 1154 138 144 34 2 1218 #createWindow: 34 1 1266 1298 8 #[11 1 0 0 67 1 0 0 81 1 0 0 92 1 0 0] 193 17312 8 '&Generate' 17280 1218 #isEnabled: 8 #(false) 17280 3 8 #() 1410 193 193 nil 29 1442 1488 -139 1504 -13 2832 -49 2848 -25 170 192 34 2 16016 8 'interfaces' nil 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 193 15936 8 '' 15904 3 34 2 16016 17280 1410 193 193 nil 27 170 192 34 2 15904 8 'Classes' nil 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 193 14288 8 'Step 3' 14256 1 34 2 15904 14336 1410 193 193 nil 27 784 nil nil nil 170 192 2176 nil 1154 138 144 34 1 1218 #createWindow: 34 1 1266 1298 8 #[10 0 0 0 10 0 0 0 98 1 0 0 155 1 0 0] 193 640 8 '' 608 3 34 3 784 5664 14256 1410 193 193 nil 27 170 192 34 2 608 8 'cards' 590342 ##(Smalltalk.Rectangle) 1410 21 21 1410 21 21 nil nil nil nil 10395 nil nil nil 1410 681 901 1 nil 193 1154 138 144 34 1 1218 #createWindow: 34 1 1266 18306 1410 1 1 1410 761 921 193 448 8 'ActiveX Component Wizard' 416 1 34 1 608 1410 193 193 nil 27 )!

toolsFolderHelpId
	^10604! !

!AXComponentWizard class categoriesForMethods!
defaultAdditionalAccelerators!constants!private! !
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
registerServer!operations!public! !
resource_Default_view!public!resources-views! !
toolsFolderHelpId!public! !
!

