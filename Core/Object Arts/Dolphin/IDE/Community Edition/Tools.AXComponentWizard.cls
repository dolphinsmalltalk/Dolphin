"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkToolShell subclass: #'Tools.AXComponentWizard'
	instanceVariableNames: 'typeLibs types description guid namespaceName packageName forcePackage cards libraryName libraryPath buffer generateTypelib typelibVariableName constantsPoolName highLevelWrappers classComments tracing defineProtocols defineFunctionTables lowercaseIdentifiers verboseTracing showStandard'
	classVariableNames: 'StandardEnums StandardInterfaces StandardStructs'
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

	^types selections first programObject browse!

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

chooseNamespace
	| choice namespaces |
	namespaces := ClassHierarchyModel withRoots: (Namespace subclasses copyWithout: SharedPool).
	choice := ValueConverter subject: namespaceName model
				typeConverter: (PluggableTypeConverter leftToRight: [:bindingRef | bindingRef valueOrNil]
						rightToLeft: [:class | class fullyQualifiedReference]).
	(ChooseClassDialog
		on: choice
		choices: namespaces
		caption: 'Select namespace...')
		allowNil: true;
		nilButtonCaption: '&Default';
		showModal!

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
	namespaceName := self add: TextPresenter new name: 'namespace'.
	generateTypelib := self add: BooleanPresenter new name: 'generateTypelib'.
	typelibVariableName := self add: TextPresenter new name: 'typelibVariableName'.
	constantsPoolName := self add: TextPresenter new name: 'constantsPoolName'.
	packageName := self add: TextPresenter new name: 'packageName'.
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
	types := self add: ListPresenter new name: 'types'.

	"Future use"
	forcePackage := self add: BooleanPresenter new name: 'forcePackage'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	typeLibs
		when: #selectionChanged
		send: #onTypeLibrarySelected
		to: self.
	generateTypelib
		when: #valueChanged
		send: #updateTypelibVariable
		to: self!

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
	generateTypelib model: (buffer aspectValue: #generateTypelibGlobal).
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
	typelibVariableName value: typelib variableName.
	description value: typelib helpstring.
	libraryName value: typelib name.

	"Pre-select the interfaces that have not yet been installed"
	self selectUninstalled!

finish
	"Close the receiver applying the changes back to the original model."

	self apply.
	self view close.

!

generatableEnumsInTlb: aTypeLibraryAnalyzer
	| generatable |
	generatable := aTypeLibraryAnalyzer enums.
	^showStandard
		ifTrue: [generatable]
		ifFalse: [generatable reject: [:each | StandardEnums includes: each name]]!

generatableInterfacesInTlb: aTypeLibraryAnalyzer
	| generatable |
	generatable := aTypeLibraryAnalyzer generatableInterfaces.
	^showStandard
		ifTrue: [generatable]
		ifFalse: [generatable reject: [:each | StandardInterfaces includes: each guid]]!

generatableStructsInTlb: aTypeLibraryAnalyzer
	| generatable |
	generatable := aTypeLibraryAnalyzer namedStructs.
	^showStandard
		ifTrue: [generatable]
		ifFalse: [generatable reject: [:each | StandardStructs includes: each name]]!

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

initialize
	super initialize.
	showStandard := false!

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
	description clear.
	packageName clear.
	libraryName clear!

onViewOpened
	"Received when the receiver's view is been connected. Refresh the
	list of current type libraries"

	super onViewOpened.
	cards := self view viewNamed: 'cards'.
	self refresh.
	typeLibs setFocus!

parametersNextCard
	"The user has configured the generation parameters is desirous of moving to the next card."

	self apply.
	^cards nextCard!

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
	(#(#choosePackage #browseIDL #inspectLibrary #chooseNamespace) identityIncludes: cmd)
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
			[aCommandQuery isEnabled: (selected size = 1 and: [selected first isVariableDefined]).
			^true].
	#toggleStandardTypes == cmd
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: showStandard.
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

standardInterfaces
	^StandardInterfaces!

toggleStandardTypes
	showStandard := showStandard not.
	self typeLib ifNotNil: [:typeLib | self updateTypesList: typeLib]!

typeLib
	"Answer the current selected type library, or nil if there is no selection."

	^typeLibs selectionOrNil!

typeLib: aTypeLibraryAnalyzerOrNil
	"Sets the current selected type library to aTypeLibraryAnalyzerOrNil"

	typeLibs selectionOrNil: aTypeLibraryAnalyzerOrNil!

typeLibHelp
	"Open the selected type-libraries help file."

	OS.ShellLibrary default shellOpen: self typeLib helpfile!

updateTypelibVariable
	"Private - The user has toggled on/off generation of the variable to hold the currently selected type library."

	typelibVariableName view isEnabled: generateTypelib value!

updateTypesList: typelib
	"Private - Populate the receiver's list of types that can be generated from the 
	<AXTypeLibraryAnalyzer>, typelib."

	| list |
	typelib clearCachedAnalyzers.
	list := Array writeStream.
	list
		nextPutAll: (self generatableInterfacesInTlb: typelib);
		nextPutAll: (self generatableStructsInTlb: typelib);
		nextPutAll: typelib generatableModules;
		nextPutAll: typelib namedUnions;
		nextPutAll: (self generatableEnumsInTlb: typelib).
	types list: (list contents asSortedCollection: [:a :b | a name <= b name])! !
!Tools.AXComponentWizard categoriesFor: #apply!operations!private! !
!Tools.AXComponentWizard categoriesFor: #browseIDL!commands!public! !
!Tools.AXComponentWizard categoriesFor: #browseTypeClass!commands!public! !
!Tools.AXComponentWizard categoriesFor: #browseTypesIDL!commands!public! !
!Tools.AXComponentWizard categoriesFor: #cancel!commands!public! !
!Tools.AXComponentWizard categoriesFor: #chooseNamespace!commands!private! !
!Tools.AXComponentWizard categoriesFor: #choosePackage!commands!public! !
!Tools.AXComponentWizard categoriesFor: #createComponents!initializing!public! !
!Tools.AXComponentWizard categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.AXComponentWizard categoriesFor: #displayInstalledTypeLib:!private!updating! !
!Tools.AXComponentWizard categoriesFor: #finish!commands!public! !
!Tools.AXComponentWizard categoriesFor: #generatableEnumsInTlb:!private!updating! !
!Tools.AXComponentWizard categoriesFor: #generatableInterfacesInTlb:!helpers!private! !
!Tools.AXComponentWizard categoriesFor: #generatableStructsInTlb:!helpers!private! !
!Tools.AXComponentWizard categoriesFor: #generate!commands!public! !
!Tools.AXComponentWizard categoriesFor: #initialize!initializing!private! !
!Tools.AXComponentWizard categoriesFor: #inspectIt!commands!public! !
!Tools.AXComponentWizard categoriesFor: #inspectItCommand!public! !
!Tools.AXComponentWizard categoriesFor: #inspectLibrary!commands!public! !
!Tools.AXComponentWizard categoriesFor: #inspectType!public! !
!Tools.AXComponentWizard categoriesFor: #libraryListNextCard!commands!public! !
!Tools.AXComponentWizard categoriesFor: #loadTypeLib!commands!public! !
!Tools.AXComponentWizard categoriesFor: #onTypeLibrarySelected!event handling!private! !
!Tools.AXComponentWizard categoriesFor: #onViewOpened!event handling!public! !
!Tools.AXComponentWizard categoriesFor: #parametersNextCard!commands!public! !
!Tools.AXComponentWizard categoriesFor: #queryCommand:!commands!private! !
!Tools.AXComponentWizard categoriesFor: #refresh!commands!public! !
!Tools.AXComponentWizard categoriesFor: #selectInstalled!commands!public! !
!Tools.AXComponentWizard categoriesFor: #selectUninstalled!commands!public! !
!Tools.AXComponentWizard categoriesFor: #standardInterfaces!private! !
!Tools.AXComponentWizard categoriesFor: #toggleStandardTypes!commands!private! !
!Tools.AXComponentWizard categoriesFor: #typeLib!accessing!public! !
!Tools.AXComponentWizard categoriesFor: #typeLib:!accessing!public! !
!Tools.AXComponentWizard categoriesFor: #typeLibHelp!commands!public! !
!Tools.AXComponentWizard categoriesFor: #updateTypelibVariable!private!updating! !
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
	self reuseIfOpen: true.
	StandardInterfaces := Set new.
	StandardStructs := #(#RemotableHandle #ExternalHandle) asSet.
	#(#{External.RECT} #{OS.OVERLAPPED} #{OS.FILETIME} #{OS.COM.IUnknown} #{OS.COM.IStream} #{OS.COM.IPersist} #{OS.COM.IDispatch} #{OS.COM.IConnectionPoint} #{OS.COM.IPropertyBag} #{Smalltalk.SOCKADDR})
		do: 
			[:each |
			each valueOrNil
				ifNotNil: 
					[:itf |
					itf owningPackage classes do: 
							[:class |
							(class inheritsFrom: Interface)
								ifTrue: [StandardInterfaces add: class guid]
								ifFalse: [(class inheritsFrom: External.Structure) ifTrue: [StandardStructs add: class name]]]]].
	StandardEnums := #(#TYPEKIND #VARKIND #INVOKEKIND #SECURITY_ATTRIBUTES #OVERLAPPED) asSet!

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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 39 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 nil nil nil nil 410 ##(UI.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 853318 1 ##(UI.CardLayout) 138 144 34 3 1049094 ##(Core.Association) 8 '1' 410 ##(UI.ContainerView) 34 15 nil 640 34 2 8 1140850688 131073 816 nil nil nil 7 nil nil nil 816 610 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 816 34 2 8 1140850688 131073 896 nil nil nil 7 nil nil nil 896 1048838 ##(UI.FramingLayout) 170 176 34 6 410 ##(UI.StaticRectangle) 34 14 nil 896 34 2 8 1140916487 262145 1024 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1024 nil 8 1838354144 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 1 1 578 689 5 1024 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 578 193 193 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 1 1394 #fixedParentRight 1 1394 #fixedParentTop 1 1394 #fixedViewTop 5 410 ##(UI.PushButton) 34 20 nil 896 34 2 8 1140924416 1 1472 nil 1104 nil 7 nil nil nil 1472 nil 8 1838505936 1377606 4 ##(UI.CommandDescription) #libraryListNextCard 8 '&Next >' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 385 31 578 141 51 1472 1202 #isEnabled: 8 #(false) 1472 1202 #text: 34 1 8 '&Next >' 1472 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1394 #fixedViewRight -139 1424 -163 1440 31 1456 51 410 ##(UI.PushButton) 34 20 nil 896 34 2 8 1140924416 1 1872 nil 1104 nil 7 nil nil nil 1872 nil 8 1838505936 1554 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 545 31 578 141 51 1872 1202 #isEnabled: 8 #(false) 1872 1202 #text: 34 1 8 'Cancel' 1872 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 15 0 0 0 86 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -3 1440 31 1456 51 170 192 8 #() nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 723 578 689 81 896 1202 #text: 34 1 8 'Buttons' 896 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 3 1472 1872 1024 1344 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 816 34 2 8 1140850688 131073 2480 nil nil nil 7 nil nil nil 2480 962 170 176 34 12 410 ##(UI.ListView) 34 45 nil 2480 34 2 8 1140953165 1025 2592 787270 2 ##(UI.ListModel) 138 144 2256 nil 1769478 ##(Kernel.IdentitySearchPolicy) 1104 nil 7 461638 4 ##(UI.Menu) nil true 34 3 1180742 2 ##(UI.CommandMenuItem) 1 1554 #browseIDL 8 '&Browse IDL' 1 1 nil nil nil 2786 1 1554 #inspectLibrary 8 '&Inspect' 1 1 nil nil nil 2786 1 1554 #typeLibHelp 8 '&Help' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2592 nil 8 1838441216 ##(UI.BasicListAbstract) nil 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 3 1117254 5 ##(UI.ListViewColumn) 8 'Library' 251 #left ##(UI.BasicListAbstract) 786950 ##(Core.Message) #<= 8 #() 3090 #name 8 #() nil 2592 nil 1 nil nil 3042 8 'Version' 101 #left 3090 #versionString 8 #() 3090 #<= 8 #() nil nil 2592 nil 1 nil nil 3042 8 'Description' 327 #left ##(UI.BasicListAbstract) 3090 #<= 8 #() 3090 #helpstring 3216 nil 2592 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 1 1 578 685 487 2592 1202 #contextMenu: 34 1 2752 2592 1202 #text: 34 1 8 'Library' 2592 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 8 #() 1344 nil 35 1362 1408 1 1424 -3 1440 1 1394 #fixedParentBottom -235 410 ##(UI.StaticText) 34 16 nil 2480 34 2 8 1140850946 1 3632 nil nil nil 7 nil nil nil 3632 nil 8 1838354144 1049094 ##(UI.NullConverter) nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 657 578 111 41 3632 1202 #text: 34 1 8 '&GUID:' 3632 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 8 #() 1344 nil 27 1362 1408 1 1394 #fixedViewLeft 111 1394 #fixedViewBottom -39 3616 -25 410 ##(UI.PushButton) 34 20 nil 2480 34 2 8 1140924416 1 4000 nil 1104 nil 7 nil nil nil 4000 nil 8 1838505936 1554 #loadTypeLib 8 'Bro&wse...' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 535 507 578 141 51 4000 1202 #isEnabled: 8 #(false) 4000 1202 #text: 34 1 8 'Bro&wse...' 4000 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -13 3984 -49 3616 -165 410 ##(UI.StaticText) 34 16 nil 2480 34 2 8 1140850944 1 4368 nil nil nil 7 nil nil nil 4368 nil 8 1838354144 3714 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 131 577 578 539 61 4368 1202 #text: 34 1 8 'Path of selected library here...
on two lines if necessary.' 4368 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 32 1 0 0 78 1 0 0 62 1 0 0] 8 #() 1344 nil 27 1362 1408 131 1424 -19 3984 -59 3616 -85 410 ##(UI.StaticText) 34 16 nil 2480 34 2 8 1140850944 1 4688 nil nil nil 7 nil nil nil 4688 nil 8 1838354144 3714 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 131 657 578 539 41 4688 1202 #text: 34 1 8 'GUID of selected library here...' 4688 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 72 1 0 0 78 1 0 0 92 1 0 0] 8 #() 1344 nil 27 1362 1408 131 1424 -19 3984 -39 3616 -25 410 ##(UI.StaticText) 34 16 nil 2480 34 2 8 1140850946 1 5008 nil nil nil 7 nil nil nil 5008 nil 8 1838354144 3714 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 577 578 111 51 5008 1202 #text: 34 1 8 '&Location:' 5008 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 8 #() 1344 nil 27 1362 1408 1 3968 111 3984 -49 3616 -95 170 192 34 6 4368 8 'libraryPath' 4688 8 'guid' 2592 8 'typeLibs' nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 1 1 578 689 723 2480 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 6 2592 4000 5008 4368 3632 4688 1344 nil 27 170 192 34 2 2480 8 'Libraries' nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 1 578 689 803 816 1202 #text: 34 1 8 'Step 1' 816 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 2480 896 1344 nil 27 770 8 '2' 410 ##(UI.ContainerView) 34 15 nil 640 34 2 8 1140850688 131073 5856 nil nil nil 5 nil nil nil 5856 610 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 5856 34 2 8 1140850688 131073 5936 nil nil nil 5 nil nil nil 5936 962 170 176 34 8 410 ##(UI.PushButton) 34 20 nil 5936 34 2 8 1140924416 1 6048 nil 1104 nil 5 nil nil nil 6048 nil 8 1838505936 1554 #parametersNextCard 8 '&Next >' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 385 31 578 141 51 6048 1202 #isEnabled: 8 #(false) 6048 1202 #text: 34 1 8 '&Next >' 6048 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -163 1440 31 1456 51 410 ##(UI.PushButton) 34 20 nil 5936 34 2 8 1140924416 1 6416 nil 1104 nil 5 nil nil nil 6416 nil 8 1838505936 1554 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 245 31 578 141 51 6416 1202 #text: 34 1 8 '< &Back' 6416 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -303 1440 31 1456 51 410 ##(UI.StaticRectangle) 34 14 nil 5936 34 2 8 1140916487 262145 6752 nil 1104 nil 5 nil nil nil 6752 nil 8 1838354144 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 1 1 578 689 5 6752 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1344 nil 27 1362 1408 1 1424 1 1440 1 1456 5 410 ##(UI.PushButton) 34 20 nil 5936 34 2 8 1140924416 1 7008 nil 1104 nil 5 nil nil nil 7008 nil 8 1838505936 1554 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 549 31 578 141 51 7008 1202 #isEnabled: 8 #(false) 7008 1202 #text: 34 1 8 'Cancel' 7008 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 1 1440 31 1456 51 170 192 2256 nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 723 578 689 81 5936 1202 #text: 34 1 8 'Buttons' 5936 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 4 6416 6048 7008 6752 1344 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 5856 34 2 8 1140850688 131073 7600 nil nil nil 5 nil nil nil 7600 962 170 176 34 42 410 ##(UI.ComboBox) 34 17 nil 7600 34 2 8 1144063491 1025 7712 2658 138 144 2256 nil 2720 1104 nil 5 nil nil nil 7712 nil 8 1838297120 ##(UI.BasicListAbstract) 3344 401 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 55 459 578 185 47 7712 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 229 0 0 0 119 0 0 0 252 0 0 0] 8 #() 1344 nil 27 1362 1408 55 1424 -449 1440 459 1456 47 410 ##(UI.CheckBox) 34 16 nil 7600 34 2 8 1140928291 1 8000 918598 2 ##(UI.ValueHolder) nil nil 1572870 ##(Kernel.NeverSearchPolicy) false nil nil 5 nil nil nil 8000 nil 8 1838505936 3714 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 415 459 578 211 41 8000 1202 #text: 34 1 8 'Verbose?' 8000 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 207 0 0 0 229 0 0 0 56 1 0 0 249 0 0 0] 8 #() 1344 nil 27 1362 1408 415 3968 211 1440 459 1456 41 410 ##(UI.StaticText) 34 16 nil 7600 34 2 8 1140850946 1 8384 nil nil nil 5 nil nil nil 8384 nil 8 1838354144 3714 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 85 79 578 181 41 8384 1202 #text: 34 1 8 'Default &Package:' 8384 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 42 0 0 0 39 0 0 0 132 0 0 0 59 0 0 0] 8 #() 1344 nil 27 1362 1408 85 3968 181 1440 79 1456 41 410 ##(UI.StaticText) 34 16 nil 7600 34 2 8 1140916480 262145 8704 nil nil nil 5 nil nil nil 8704 nil 8 1838354144 3714 nil nil nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 291 133 578 335 41 8704 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 66 0 0 0 56 1 0 0 86 0 0 0] 8 #() 1344 nil 27 1362 1408 291 1424 -63 1440 133 1456 41 410 ##(UI.PushButton) 34 20 nil 7600 34 2 8 1140924416 1 8976 nil 1104 nil 5 nil nil nil 8976 nil 8 1838505936 1554 #chooseNamespace 8 '...' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 645 11 578 41 41 8976 1202 #isEnabled: 8 #(false) 8976 1202 #text: 34 1 8 '...' 8976 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 66 1 0 0 5 0 0 0 86 1 0 0 25 0 0 0] 8 #() 1344 nil 29 1362 1856 -39 1424 -3 1394 #fixedPreviousTop -1 1456 41 410 ##(UI.CheckBox) 34 16 nil 7600 34 2 8 1140924451 1 9360 8066 nil nil 8112 false nil nil 5 nil nil nil 9360 nil 8 1838505936 3714 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 591 578 411 51 9360 1202 #text: 34 1 8 'Generate #&defineFunctions:' 9360 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 39 1 0 0 235 0 0 0 64 1 0 0] 8 #() 1344 nil 27 1362 1408 61 3968 411 1440 591 1456 51 410 ##(UI.ComboBox) 34 17 nil 7600 34 2 8 1144063491 1025 9696 2658 138 144 2256 nil 2720 1104 nil 5 nil nil nil 9696 nil 8 1838297120 ##(UI.BasicListAbstract) 3344 151 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 445 297 578 185 47 9696 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 222 0 0 0 148 0 0 0 58 1 0 0 171 0 0 0] 8 #() 1344 nil 27 1362 1408 445 1424 -59 1440 297 1456 47 410 ##(UI.TextEdit) 34 16 nil 7600 34 2 8 1140916224 262145 9984 nil 1104 nil 5 nil nil nil 9984 nil 8 1838497744 3714 nil nil 1 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 291 73 578 335 41 9984 1202 #setMarginWidths: 34 1 8 #(3 3) 9984 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 36 0 0 0 56 1 0 0 56 0 0 0] 8 #() 1344 nil 27 1362 1408 291 1424 -63 1440 73 1456 41 410 ##(UI.StaticText) 34 16 nil 7600 34 2 8 1140850944 1 10304 nil nil nil 5 nil nil nil 10304 nil 8 1838354144 3714 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 65 367 578 371 41 10304 1202 #text: 34 1 8 '&High-level wrapper methods:' 10304 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 0 0 0 183 0 0 0 217 0 0 0 203 0 0 0] 8 #() 1344 nil 27 1362 1408 65 3968 371 1440 367 1456 41 410 ##(UI.CheckBox) 34 16 nil 7600 34 2 8 1140927747 1 10624 8066 nil nil 8112 false nil nil 517 nil nil nil 10624 nil 8 1838505936 3714 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 67 133 578 201 41 10624 1202 #text: 34 1 8 'Typelib &variable:' 10624 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 33 0 0 0 66 0 0 0 133 0 0 0 86 0 0 0] 8 #() 1344 nil 27 1362 1408 67 3968 201 1440 133 1456 41 410 ##(UI.GroupBox) 34 14 nil 7600 34 2 8 1140850695 65 10960 nil nil nil 5 nil nil nil 10960 nil 8 1838505936 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 35 419 578 631 111 10960 1202 #text: 34 1 8 '&Tracing:' 10960 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 209 0 0 0 76 1 0 0 8 1 0 0] 8 #() 1344 nil 27 1362 1408 35 3968 631 1440 419 1456 111 410 ##(UI.StaticText) 34 16 nil 7600 34 2 8 1140850944 65 11264 nil nil nil 5 nil nil nil 11264 nil 8 1838354144 3714 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 65 307 578 281 41 11264 1202 #text: 34 1 8 '&Class Comments:' 11264 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 0 0 0 153 0 0 0 172 0 0 0 173 0 0 0] 8 #() 1344 nil 27 1362 1408 65 3968 281 1440 307 1456 41 410 ##(UI.TextEdit) 34 16 nil 7600 34 2 8 1140916224 262145 11584 nil 1104 nil 5 nil nil nil 11584 nil 8 1838497744 3714 nil nil 1 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 291 191 578 335 41 11584 1202 #setMarginWidths: 34 1 8 #(3 3) 11584 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 95 0 0 0 56 1 0 0 115 0 0 0] 8 #() 1344 nil 27 1362 1408 291 3968 335 1440 191 1456 41 410 ##(UI.StaticText) 34 16 nil 7600 34 2 8 1140850946 1 11904 nil nil nil 5 nil nil nil 11904 nil 8 1838354144 3714 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 85 197 578 181 41 11904 1202 #text: 34 1 8 'C&onstants Pool:
' 11904 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 42 0 0 0 98 0 0 0 132 0 0 0 118 0 0 0] 8 #() 1344 nil 27 1362 1408 85 3968 181 1440 197 1456 41 410 ##(UI.GroupBox) 34 14 nil 7600 34 2 8 1140850695 65 12224 nil nil nil 5 nil nil nil 12224 nil 8 1838505936 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 5 257 578 671 441 12224 1202 #text: 34 1 8 'Ad&vanced' 12224 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 128 0 0 0 81 1 0 0 92 1 0 0] 8 #() 1344 nil 27 1362 1408 5 1424 -13 1440 257 1456 441 410 ##(UI.StaticText) 34 16 nil 7600 34 2 8 1140916482 1 12528 8066 nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil nil nil 5 nil nil nil 12528 nil 8 1838354144 3714 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 85 19 578 181 41 12528 1202 #text: 34 1 8 '&Namespace:' 12528 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 42 0 0 0 9 0 0 0 132 0 0 0 29 0 0 0] 8 #() 1344 nil 27 1362 1408 85 3968 181 1440 19 1456 41 410 ##(UI.CheckBox) 34 16 nil 7600 34 2 8 1140924451 1 12896 8066 nil nil 8112 false nil nil 5 nil nil nil 12896 nil 8 1838505936 3714 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 541 578 411 61 12896 1202 #text: 34 1 8 'Define Method &Protocols:' 12896 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 14 1 0 0 235 0 0 0 44 1 0 0] 8 #() 1344 nil 27 1362 1408 61 3968 411 1440 541 1456 61 410 ##(UI.StaticText) 34 16 nil 7600 34 2 8 1140916480 262145 13232 8066 nil false 12624 nil 1104 nil 5 nil nil nil 13232 nil 8 1838354144 3714 nil nil nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 291 13 578 335 41 13232 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 6 0 0 0 56 1 0 0 26 0 0 0] 8 #() 1344 nil 27 1362 1408 291 1424 -63 1440 13 1456 41 410 ##(UI.CheckBox) 34 16 nil 7600 34 2 8 1140924451 1 13520 8066 nil nil 8112 false nil nil 5 nil nil nil 13520 nil 8 1838505936 3714 nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 61 631 578 411 61 13520 1202 #text: 34 1 8 '&Lowercase secondary keywords' 13520 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 59 1 0 0 235 0 0 0 89 1 0 0] 8 #() 1344 nil 27 1362 1408 61 3968 411 1440 631 1456 61 410 ##(UI.PushButton) 34 20 nil 7600 34 2 8 1140924416 1 13856 nil 1104 nil 5 nil nil nil 13856 nil 8 1838505936 1554 #choosePackage 8 '...' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 645 73 578 41 41 13856 1202 #isEnabled: 8 #(false) 13856 1202 #text: 34 1 8 '...' 13856 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 66 1 0 0 36 0 0 0 86 1 0 0 56 0 0 0] 8 #() 1344 nil 29 1362 1856 -39 1424 -3 9344 1 1456 41 410 ##(UI.ComboBox) 34 17 nil 7600 34 2 8 1144063491 1025 14224 2658 138 144 2256 nil 2720 1104 nil 5 nil nil nil 14224 nil 8 1838297120 ##(UI.BasicListAbstract) 3344 101 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 445 357 578 185 47 14224 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 222 0 0 0 178 0 0 0 58 1 0 0 201 0 0 0] 8 #() 1344 nil 27 1362 1408 445 1424 -59 1440 357 1456 47 170 192 34 24 13232 8 'namespace' 8704 8 'typelibVariableName' 11584 8 'constantsPoolName' 7712 8 'tracing' 12896 8 'defineProtocols' 8000 8 'verboseTrace' 9696 8 'commentGeneration' 9984 8 'packageName' 9360 8 'defineFunctions' 10624 8 'generateTypelib' 14224 8 'highLevelWrappers' 13520 8 'lowercaseKeywords' nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 1 578 689 723 7600 1202 #text: 34 1 8 'Generation Parameters' 7600 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 21 12528 13232 8976 8384 9984 13856 11264 9696 10304 14224 10960 7712 8000 9360 12896 13520 12224 8704 10624 11904 11584 1344 nil 27 170 192 2256 nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 1 578 689 803 5856 1202 #text: 34 1 8 'Step 2' 5856 1282 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 7600 5936 1344 nil 27 770 8 '3' 410 ##(UI.ContainerView) 34 15 nil 640 34 2 8 1140850688 131073 15200 nil nil nil 5 nil nil nil 15200 610 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 15200 34 2 8 1140850688 131073 15280 nil nil nil 5 nil nil nil 15280 962 170 176 34 8 410 ##(UI.PushButton) 34 20 nil 15280 34 2 8 1140924416 1 15392 nil 1104 nil 5 nil nil nil 15392 nil 8 1838505936 1554 #finish 8 '&Finish' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 385 31 578 141 51 15392 1202 #isEnabled: 8 #(false) 15392 1202 #text: 34 1 8 '&Finish' 15392 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -163 1440 31 1456 51 410 ##(UI.PushButton) 34 20 nil 15280 34 2 8 1140924416 1 15760 nil 1104 nil 5 nil nil nil 15760 nil 8 1838505936 1554 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 245 31 578 141 51 15760 1202 #text: 34 1 8 '< &Back' 15760 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -303 1440 31 1456 51 410 ##(UI.PushButton) 34 20 nil 15280 34 2 8 1140924416 1 16096 nil 1104 nil 5 nil nil nil 16096 nil 8 1838505936 1554 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 539 31 578 151 51 16096 1202 #isEnabled: 8 #(false) 16096 1202 #text: 34 1 8 'Cancel' 16096 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 1344 nil 29 1362 1856 -149 1424 1 1440 31 1456 51 410 ##(UI.StaticRectangle) 34 14 nil 15280 34 2 8 1140916487 262145 16464 nil 1104 nil 5 nil nil nil 16464 nil 8 1838354144 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 1 1 578 689 5 16464 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1344 nil 27 1362 1408 1 1424 1 1440 1 1456 5 170 192 2256 nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 723 578 689 81 15280 1202 #text: 34 1 8 'Buttons' 15280 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 4 15760 15392 16096 16464 1344 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 15200 34 2 8 1140850688 131073 16944 nil nil nil 5 nil nil nil 16944 962 170 176 34 4 410 ##(UI.PushButton) 34 20 nil 16944 34 2 8 1140924416 1 17056 nil 1104 nil 5 nil nil nil 17056 nil 8 1838505936 1554 #generate 8 '&Generate' 1 1 nil nil true nil nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 578 535 647 578 141 51 17056 1202 #isEnabled: 8 #(false) 17056 1202 #text: 34 1 8 '&Generate' 17056 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 67 1 0 0 81 1 0 0 92 1 0 0] 8 #() 1344 nil 29 1362 1856 -139 1424 -13 3984 -49 3616 -25 410 ##(UI.ListView) 34 45 nil 16944 34 2 8 1140920393 1025 17424 2658 138 144 2256 nil 2720 1104 nil 5 2738 nil true 34 8 2786 1 1554 #selectAll 8 'Select &All' 1 1 nil nil nil 2786 1 1554 #selectInstalled 8 'Select &Installed' 1 1 nil nil nil 2786 1 1554 #selectUninstalled 8 'Select &Uninstalled' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 2786 1 1554 #browseTypeClass 8 'Browse &Class' 1 1 nil nil nil 2786 1 1554 #browseTypesIDL 8 '&Browse IDL' 1 1 nil nil nil 17698 4097 2786 1 1554 #toggleStandardTypes 8 'Show &Standard Types' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 17424 nil 8 1838441216 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 2992 nil 3090 #helpstring 8 #() nil 578 65 65 nil nil 138 144 34 3 3042 8 'Name' 437 #left ##(UI.BasicListAbstract) 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] #name 18048 7 513 nil nil nil 17424 ##(UI.IconicListAbstract) 3 nil nil 3042 8 '' 41 #left nil 18034 0 nil 18066 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 18176 7 513 nil 18034 0 nil 18066 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:each | each isInstalled]' 8 #[30 105 17 158 106] #isInstalled 18256 7 257 nil nil 17424 18034 0 nil 18066 4 1 18032 8 'doIt' 8 '[:each | (each ?? Graphics.NullIcon) iconImageIndex]' 8 #[32 105 17 45 177 160 106] 1442886 2 ##(Kernel.VariableBinding) #NullIcon ##(Graphics.NullIcon) ##(Graphics) 1 #?? #iconImageIndex 18336 7 257 nil 1 nil nil 3042 8 'Type' 201 #left ##(UI.BasicListAbstract) 3090 #<= 8 #() 18034 0 nil 18066 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:each | each idlKeyword]' 8 #[30 105 17 158 106] #idlKeyword 18512 7 257 nil nil 17424 nil 1 nil nil #report 3344 nil 133157 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1138 138 144 34 4 1202 #createAt:extent: 34 2 578 1 1 578 685 617 17424 1202 #contextMenu: 34 1 17520 17424 1202 #text: 34 1 8 'Name' 17424 1202 #columnOrder: 34 1 8 #(2 1 3) 17424 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 52 1 0 0] 8 #() 1344 nil 35 1362 1408 1 1424 -3 1440 1 3616 -105 170 192 34 2 17424 8 'types' nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 1 1 578 689 723 16944 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 2 17424 17056 1344 nil 27 170 192 34 2 16944 8 'Classes' nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 1 1 578 689 803 15200 1202 #text: 34 1 8 'Step 3' 15200 1282 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 16944 15280 1344 nil 27 816 nil nil nil 170 192 2256 nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 578 21 21 578 689 803 640 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 155 1 0 0] 34 3 816 5856 15200 1344 nil 27 170 192 34 2 640 8 'cards' 1180166 ##(Graphics.Rectangle) 578 21 21 578 21 21 nil nil nil nil 22387 nil nil nil 578 681 901 1 nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 578 6143 21 578 761 921 416 1202 #text: 34 1 8 'COM Component Wizard' 416 1282 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 214 1 0 0] 34 1 640 1344 nil 27 )!

toolsFolderHelpId
	^10604! !
!Tools.AXComponentWizard class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!Tools.AXComponentWizard class categoriesFor: #displayOn:!displaying!public! !
!Tools.AXComponentWizard class categoriesFor: #icon!constants!public! !
!Tools.AXComponentWizard class categoriesFor: #initialize!initializing!private! !
!Tools.AXComponentWizard class categoriesFor: #registerServer!operations!public! !
!Tools.AXComponentWizard class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.AXComponentWizard class categoriesFor: #toolsFolderHelpId!public! !

