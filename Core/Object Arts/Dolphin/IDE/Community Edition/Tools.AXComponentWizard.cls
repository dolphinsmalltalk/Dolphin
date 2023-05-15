"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell
	subclass: #'Tools.AXComponentWizard'
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

	<commandQuery: #hasLibrarySelected>
	| lib stm |
	lib := self typeLib.
	stm := ReadWriteStream on: (String new: 2048).
	lib printIDLOn: stm.
	stm reset.
	SmalltalkSystem current workspaceShellClass show
		language: #null;
		streamIn: stm!

browseTypeClass
	"Open a new class browser on the class of the selected type."

	<commandQuery: #hasTypeWithClass>
	^types selections first programObject browse!

browseTypesIDL
	"Open a new workspace populated with the IDL for the currently selected types."

	<commandQuery: #hasTypesSelected>
	| stm |
	stm := ReadWriteStream on: (String new: 2048).
	types selections do: 
			[:type |
			type printIDLOn: stm.
			stm cr].
	stm reset.
	SmalltalkSystem current workspaceShellClass show streamIn: stm!

cancel
	"Close the receiver without applying the changes back to the original model"

	self view close.

!

chooseNamespace
	<commandQuery: #hasLibrarySelected>
	| choice namespaces |
	namespaces := ClassHierarchyModel withRoots: (Namespace subclasses copyWithout: SharedPool).
	choice := ValueConverter subject: namespaceName model
				typeConverter: (PluggableTypeConverter leftToRight: [:bindingRef | bindingRef valueOrNil]
						rightToLeft: [:class | class fullyQualifiedReference]).
	(ChooseClassDialog
		on: choice
		choices: namespaces
		caption: 'Select Namespace…')
		allowNil: true;
		nilButtonCaption: '&Default';
		showModal!

choosePackage
	"Sets the package name from a choice of all the available packages"

	<commandQuery: #hasLibrarySelected>
	| oldPkg |
	oldPkg := packageName value isEmpty
				ifTrue: [nil]
				ifFalse: [Package manager packageNamed: packageName value ifNone: nil].
	(PackagePrompter
		showModalOn: oldPkg asValue
		caption: 'Select default package…'
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

	<commandQuery: #hasTypesSelected>
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
	progress caption: 'Please wait…'.
	progress showModal.
	types view updateAll!

hasInstalledTypeLib
	| tlb |
	tlb := self typeLib.
	^tlb notNil and: [tlb isInstalled]!

hasLibrarySelected
	^self typeLib notNil!

hasTypeLibWithHelp
	| tlb |
	tlb := self typeLib.
	^tlb notNil and: [tlb helpfile notEmpty]!

hasTypesSelected
	^types selections notEmpty!

hasTypeWithClass
	| selectedTypes |
	selectedTypes := types selections.
	^selectedTypes size = 1 and: [selectedTypes first isVariableDefined]!

initialize
	super initialize.
	showStandard := false!

inspectItCommand
	| focus |
	focus := View focus.
	focus == typeLibs view ifTrue: [^#inspectLibrary].
	focus == types view view ifTrue: [^#inspectType].
	^nil!

inspectLibrary
	"Open an inspector on the <AXTypeLibraryAnalyzer> representing the currently
	selected library."

	<commandQuery: #hasLibrarySelected>
	self typeLib inspect!

inspectType
	<commandQuery: #hasTypesSelected>
	| selections |
	selections := types selections.
	(selections size = 1 ifTrue: [selections first] ifFalse: [selections]) inspect!

libraryListNextCard
	"The user has selected a library and is desirous of moving to the next card."

	<commandQuery: #hasInstalledTypeLib>
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

queryToggleStandardTypes: aCommandQuery
	aCommandQuery
		isEnabled: true;
		isChecked: showStandard!

refresh
	"Refresh the list of current AXTypeLibraryAnalyzers in the image"

	<acceleratorKey: 'F5'>
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
	<commandQuery: #queryToggleStandardTypes:>
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

	<commandQuery: #hasTypeLibWithHelp>
	OS.Shell32 shellOpen: self typeLib helpfile!

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
!Tools.AXComponentWizard categoriesForMethods!
apply!operations!private! !
browseIDL!commands-actions!public! !
browseTypeClass!commands-actions!public! !
browseTypesIDL!commands-actions!public! !
cancel!commands-actions!public! !
chooseNamespace!commands-actions!public! !
choosePackage!commands-actions!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
displayInstalledTypeLib:!private!updating! !
finish!commands-actions!public! !
generatableEnumsInTlb:!private!updating! !
generatableInterfacesInTlb:!helpers!private! !
generatableStructsInTlb:!helpers!private! !
generate!commands-actions!public! !
hasInstalledTypeLib!private!testing! !
hasLibrarySelected!private!testing! !
hasTypeLibWithHelp!private!testing! !
hasTypesSelected!private!testing! !
hasTypeWithClass!private!testing! !
initialize!initializing!private! !
inspectItCommand!public! !
inspectLibrary!commands-actions!public! !
inspectType!public! !
libraryListNextCard!commands-actions!public! !
loadTypeLib!commands-actions!public! !
onTypeLibrarySelected!event handling!private! !
onViewOpened!event handling!public! !
parametersNextCard!commands-actions!public! !
queryToggleStandardTypes:!commands-queries!private! !
refresh!commands-actions!public! !
selectInstalled!commands-actions!public! !
selectUninstalled!commands-actions!public! !
standardInterfaces!private! !
toggleStandardTypes!commands-actions!private! !
typeLib!accessing!public! !
typeLib:!accessing!public! !
typeLibHelp!commands-actions!public! !
updateTypelibVariable!private!updating! !
updateTypesList:!private!updating! !
!

!Tools.AXComponentWizard class methodsFor!

defaultAdditionalAccelerators
	^super defaultAdditionalAccelerators 
		, #(#(#selectAll 'Ctrl+A'))!

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

	SmalltalkSystem current
		addAdditionalToolsFolderIcon: self toolsFolderIcon;
		registerTool: self.
	StandardInterfaces := Set new.
	StandardStructs := #(#RemotableHandle #ExternalHandle) asSet.
	#(#{Smalltalk.RECT} #{OS.OVERLAPPED} #{OS.FILETIME} #{OS.COM.IUnknown} #{OS.COM.IStream} #{OS.COM.IPersist} #{OS.COM.IDispatch} #{OS.COM.IConnectionPoint} #{OS.COM.IPropertyBag} #{Smalltalk.SOCKADDR})
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

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	(aspects at: #reuseIfOpen) defaultValue: true.
	^aspects!

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
				uint32AtOffset: 0 put: proc;
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 39 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil nil nil nil 410 #{UI.WizardCardContainer} 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 853318 1 #{UI.CardLayout} 138 144 34 3 1049094 #{Core.Association} 8 '1' 410 #{UI.ContainerView} 34 15 nil 640 34 2 8 1140850688 131073 816 nil nil nil 7 nil nil nil 816 610 1 1 nil 410 #{UI.ContainerView} 34 15 nil 816 34 2 8 1140850688 131073 896 nil nil nil 7 nil nil nil 896 1048838 #{UI.FramingLayout} 170 176 34 6 410 #{UI.PushButton} 34 20 nil 896 34 2 8 1140924416 1 1024 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 1024 nil 8 1819032944 1377606 4 #{UI.CommandDescription} #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1310982 #{Core.MessageSequence} 34 3 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 545 31 578 141 51 1024 1234 #isEnabled: 8 #(false) 1024 1234 #text: 34 1 8 'Cancel' 1024 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 15 0 0 0 86 1 0 0 40 0 0 0] 8 #() 578 193 193 nil 29 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedViewRight -139 1506 #fixedParentRight -3 1506 #fixedParentTop 31 1506 #fixedViewTop 51 410 #{UI.StaticRectangle} 34 14 nil 896 34 2 8 1140916487 262145 1584 nil 1104 nil 7 nil nil nil 1584 nil 8 1819237552 1186 34 1 1234 #createAt:extent: 34 2 578 1 1 578 689 5 1584 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1456 nil 27 1474 1506 #fixedParentLeft 1 1536 1 1552 1 1568 5 410 #{UI.PushButton} 34 20 nil 896 34 2 8 1140924416 1 1840 nil 1104 nil 7 nil nil nil 1840 nil 8 1819032944 1138 #libraryListNextCard 8 '&Next >' 1 1 nil nil false nil nil nil 1186 34 3 1234 #createAt:extent: 34 2 578 385 31 578 141 51 1840 1234 #isEnabled: 8 #(false) 1840 1234 #text: 34 1 8 '&Next >' 1840 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1456 nil 29 1474 1520 -139 1536 -163 1552 31 1568 51 170 192 8 #() nil 1186 34 2 1234 #createAt:extent: 34 2 578 1 723 578 689 81 896 1234 #text: 34 1 8 'Buttons' 896 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 3 1840 1024 1584 1456 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 816 34 2 8 1140850688 131073 2416 nil nil nil 7 nil nil nil 2416 962 170 176 34 12 410 #{UI.StaticText} 34 16 nil 2416 34 2 8 1140850946 1 2528 nil nil nil 7 nil nil nil 2528 nil 8 1819237552 1049094 #{UI.NullConverter} nil nil nil 1186 34 2 1234 #createAt:extent: 34 2 578 1 577 578 111 51 2528 1234 #text: 34 1 8 '&Location:' 2528 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 8 #() 1456 nil 27 1474 1824 1 1506 #fixedViewLeft 111 1506 #fixedViewBottom -49 1506 #fixedParentBottom -95 410 #{UI.StaticText} 34 16 nil 2416 34 2 8 1140850944 1 2896 nil nil nil 7 nil nil nil 2896 nil 8 1819237552 2610 nil nil nil 1186 34 2 1234 #createAt:extent: 34 2 578 131 657 578 539 41 2896 1234 #text: 34 1 8 'GUID of selected library here…' 2896 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 72 1 0 0 78 1 0 0 92 1 0 0] 8 #() 1456 nil 27 1474 1824 131 1536 -19 2864 -39 2880 -25 410 #{UI.StaticText} 34 16 nil 2416 34 2 8 1140850944 1 3200 nil nil nil 7 nil nil nil 3200 nil 8 1819237552 2610 nil nil nil 1186 34 2 1234 #createAt:extent: 34 2 578 131 577 578 539 61 3200 1234 #text: 34 1 8 'Path of selected library here…
on two lines if necessary.' 3200 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 32 1 0 0 78 1 0 0 62 1 0 0] 8 #() 1456 nil 27 1474 1824 131 1536 -19 2864 -59 2880 -85 410 #{UI.PushButton} 34 20 nil 2416 34 2 8 1140924416 1 3504 nil 1104 nil 7 nil nil nil 3504 nil 8 1819032944 1138 #loadTypeLib 8 'Bro&wse…' 1 1 nil nil false nil nil nil 1186 34 3 1234 #createAt:extent: 34 2 578 535 507 578 141 51 3504 1234 #isEnabled: 8 #(false) 3504 1234 #text: 34 1 8 'Bro&wse…' 3504 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 8 #() 1456 nil 29 1474 1520 -139 1536 -13 2864 -49 2880 -165 410 #{UI.StaticText} 34 16 nil 2416 34 2 8 1140850946 1 3856 nil nil nil 7 nil nil nil 3856 nil 8 1819237552 2610 nil nil nil 1186 34 2 1234 #createAt:extent: 34 2 578 1 657 578 111 41 3856 1234 #text: 34 1 8 '&GUID:' 3856 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 8 #() 1456 nil 27 1474 1824 1 2848 111 2864 -39 2880 -25 410 #{UI.ListView} 34 45 nil 2416 34 2 8 1140953165 1025 4160 787270 2 #{UI.ListModel} 138 144 2208 nil 1769478 #{Kernel.IdentitySearchPolicy} 1104 nil 7 461638 4 #{UI.Menu} nil true 34 3 1180742 2 #{UI.CommandMenuItem} 1 1138 #browseIDL 8 '&Browse IDL' 1 1 nil nil nil 4354 1 1138 #inspectLibrary 8 '&Inspect' 1 1 nil nil nil 4354 1 1138 #typeLibHelp 8 '&Help' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 4160 nil 8 1819093264 786950 #{Core.Message} #displayString 8 #() nil 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 3 1117254 5 #{UI.ListViewColumn} 8 'Library' 251 #left 4560 4546 #<= 8 #() 4546 #name 8 #() nil 4160 nil 1 nil nil 4658 8 'Version' 101 #left 4546 #versionString 8 #() 4546 #<= 8 #() nil nil 4160 nil 1 nil nil 4658 8 'Description' 327 #left 4560 4546 #<= 8 #() 4546 #helpstring 4816 nil 4160 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 1186 34 2 1234 #createAt:extent: 34 2 578 1 1 578 685 487 4160 1234 #text: 34 1 8 'Library' 4160 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 8 #() 1456 nil 35 1474 1824 1 1536 -3 1552 1 2880 -235 170 192 34 6 4160 8 'typeLibs' 3200 8 'libraryPath' 2896 8 'guid' nil 1186 34 1 1234 #createAt:extent: 34 2 578 1 1 578 689 723 2416 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 6 4160 3504 2528 3200 3856 2896 1456 nil 27 170 192 34 2 2416 8 'Libraries' nil 1186 34 2 1234 #createAt:extent: 34 2 578 1 1 578 689 803 816 1234 #text: 34 1 8 'Step 1' 816 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 2416 896 1456 nil 27 770 8 '2' 410 #{UI.ContainerView} 34 15 nil 640 34 2 8 1140850688 131073 5664 nil nil nil 5 nil nil nil 5664 610 1 1 nil 410 #{UI.ContainerView} 34 15 nil 5664 34 2 8 1140850688 131073 5744 nil nil nil 5 nil nil nil 5744 962 170 176 34 8 410 #{UI.PushButton} 34 20 nil 5744 34 2 8 1140924416 1 5856 nil 1104 nil 5 nil nil nil 5856 nil 8 1819032944 1138 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 1186 34 3 1234 #createAt:extent: 34 2 578 245 31 578 141 51 5856 1234 #isEnabled: 8 #(false) 5856 1234 #text: 34 1 8 '< &Back' 5856 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 1456 nil 29 1474 1520 -139 1536 -303 1552 31 1568 51 410 #{UI.PushButton} 34 20 nil 5744 34 2 8 1140924416 1 6208 nil 1104 nil 5 nil nil nil 6208 nil 8 1819032944 1138 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1186 34 3 1234 #createAt:extent: 34 2 578 549 31 578 141 51 6208 1234 #isEnabled: 8 #(false) 6208 1234 #text: 34 1 8 'Cancel' 6208 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 1456 nil 29 1474 1520 -139 1536 1 1552 31 1568 51 410 #{UI.StaticRectangle} 34 14 nil 5744 34 2 8 1140916487 262145 6560 nil 1104 nil 5 nil nil nil 6560 nil 8 1819237552 1186 34 1 1234 #createAt:extent: 34 2 578 1 1 578 689 5 6560 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1456 nil 27 1474 1824 1 1536 1 1552 1 1568 5 410 #{UI.PushButton} 34 20 nil 5744 34 2 8 1140924416 1 6800 nil 1104 nil 5 nil nil nil 6800 nil 8 1819032944 1138 #parametersNextCard 8 '&Next >' 1 1 nil nil false nil nil nil 1186 34 3 1234 #createAt:extent: 34 2 578 385 31 578 141 51 6800 1234 #isEnabled: 8 #(false) 6800 1234 #text: 34 1 8 '&Next >' 6800 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1456 nil 29 1474 1520 -139 1536 -163 1552 31 1568 51 170 192 2208 nil 1186 34 2 1234 #createAt:extent: 34 2 578 1 723 578 689 81 5744 1234 #text: 34 1 8 'Buttons' 5744 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 4 5856 6800 6208 6560 1456 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 5664 34 2 8 1140850688 131073 7360 nil nil nil 5 nil nil nil 7360 962 170 176 34 42 410 #{UI.CheckBox} 34 16 nil 7360 34 2 8 1140924451 1 7472 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 7472 nil 8 1819032944 2610 nil nil nil 1186 34 2 1234 #createAt:extent: 34 2 578 61 631 578 411 61 7472 1234 #text: 34 1 8 '&Lowercase secondary keywords' 7472 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 59 1 0 0 235 0 0 0 89 1 0 0] 8 #() 1456 nil 27 1474 1824 61 2848 411 1552 631 1568 61 410 #{UI.StaticText} 34 16 nil 7360 34 2 8 1140850946 1 7840 nil nil nil 5 nil nil nil 7840 nil 8 1819237552 2610 nil nil nil 1186 34 2 1234 #createAt:extent: 34 2 578 85 79 578 181 41 7840 1234 #text: 34 1 8 'Default &Package:' 7840 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 42 0 0 0 39 0 0 0 132 0 0 0 59 0 0 0] 8 #() 1456 nil 27 1474 1824 85 2848 181 1552 79 1568 41 410 #{UI.PushButton} 34 20 nil 7360 34 2 8 1140924416 1 8144 nil 1104 nil 5 nil nil nil 8144 nil 8 1819032944 1138 #chooseNamespace 8 '…' 1 1 nil nil false nil nil nil 1186 34 3 1234 #createAt:extent: 34 2 578 645 11 578 41 41 8144 1234 #isEnabled: 8 #(false) 8144 1234 #text: 34 1 8 '…' 8144 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 66 1 0 0 5 0 0 0 86 1 0 0 25 0 0 0] 8 #() 1456 nil 29 1474 1520 -39 1536 -3 1506 #fixedPreviousTop -1 1568 41 410 #{UI.PushButton} 34 20 nil 7360 34 2 8 1140924416 1 8512 nil 1104 nil 5 nil nil nil 8512 nil 8 1819032944 1138 #choosePackage 8 '…' 1 1 nil nil false nil nil nil 1186 34 3 1234 #createAt:extent: 34 2 578 645 73 578 41 41 8512 1234 #isEnabled: 8 #(false) 8512 1234 #text: 34 1 8 '…' 8512 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 66 1 0 0 36 0 0 0 86 1 0 0 56 0 0 0] 8 #() 1456 nil 29 1474 1520 -39 1536 -3 8496 1 1568 41 410 #{UI.ComboBox} 34 17 nil 7360 34 2 8 1144063491 1025 8864 4226 138 144 2208 nil 4288 1104 nil 5 nil nil nil 8864 nil 8 1818642288 4560 4944 401 1186 34 1 1234 #createAt:extent: 34 2 578 55 459 578 185 47 8864 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 229 0 0 0 119 0 0 0 252 0 0 0] 8 #() 1456 nil 27 1474 1824 55 1536 -449 1552 459 1568 47 410 #{UI.StaticText} 34 16 nil 7360 34 2 8 1140916482 1 9136 7538 nil false 1769478 #{Kernel.EqualitySearchPolicy} nil nil nil 5 nil nil nil 9136 nil 8 1819237552 2610 nil nil nil 1186 34 2 1234 #createAt:extent: 34 2 578 85 19 578 181 41 9136 1234 #text: 34 1 8 '&Namespace:' 9136 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 42 0 0 0 9 0 0 0 132 0 0 0 29 0 0 0] 8 #() 1456 nil 27 1474 1824 85 2848 181 1552 19 1568 41 410 #{UI.ComboBox} 34 17 nil 7360 34 2 8 1144063491 1025 9488 4226 138 144 2208 nil 4288 1104 nil 5 nil nil nil 9488 nil 8 1818642288 4560 4944 101 1186 34 1 1234 #createAt:extent: 34 2 578 445 357 578 185 47 9488 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 222 0 0 0 178 0 0 0 58 1 0 0 201 0 0 0] 8 #() 1456 nil 27 1474 1824 445 1536 -59 1552 357 1568 47 410 #{UI.StaticText} 34 16 nil 7360 34 2 8 1140850944 1 9760 nil nil nil 5 nil nil nil 9760 nil 8 1819237552 2610 nil nil nil 1186 34 2 1234 #createAt:extent: 34 2 578 65 367 578 371 41 9760 1234 #text: 34 1 8 '&High-level wrapper methods:' 9760 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 0 0 0 183 0 0 0 217 0 0 0 203 0 0 0] 8 #() 1456 nil 27 1474 1824 65 2848 371 1552 367 1568 41 410 #{UI.TextEdit} 34 16 nil 7360 34 2 8 1140916224 262145 10064 nil 1104 nil 5 nil nil nil 10064 nil 8 1819025648 2610 nil nil 1 1186 34 2 1234 #createAt:extent: 34 2 578 291 73 578 335 41 10064 1234 #setMarginWidths: 34 1 8 #(3 3) 10064 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 36 0 0 0 56 1 0 0 56 0 0 0] 8 #() 1456 nil 27 1474 1824 291 1536 -63 1552 73 1568 41 410 #{UI.CheckBox} 34 16 nil 7360 34 2 8 1140927747 1 10368 7538 nil nil 7584 false nil nil 517 nil nil nil 10368 nil 8 1819032944 2610 nil nil nil 1186 34 2 1234 #createAt:extent: 34 2 578 67 133 578 201 41 10368 1234 #text: 34 1 8 'Typelib &variable:' 10368 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 33 0 0 0 66 0 0 0 133 0 0 0 86 0 0 0] 8 #() 1456 nil 27 1474 1824 67 2848 201 1552 133 1568 41 410 #{UI.StaticText} 34 16 nil 7360 34 2 8 1140916480 262145 10688 7538 nil false 9232 nil 1104 nil 5 nil nil nil 10688 nil 8 1819237552 2610 nil nil nil 1186 34 1 1234 #createAt:extent: 34 2 578 291 13 578 335 41 10688 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 6 0 0 0 56 1 0 0 26 0 0 0] 8 #() 1456 nil 27 1474 1824 291 1536 -63 1552 13 1568 41 410 #{UI.StaticText} 34 16 nil 7360 34 2 8 1140850944 65 10960 nil nil nil 5 nil nil nil 10960 nil 8 1819237552 2610 nil nil nil 1186 34 2 1234 #createAt:extent: 34 2 578 65 307 578 281 41 10960 1234 #text: 34 1 8 '&Class Comments:' 10960 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 0 0 0 153 0 0 0 172 0 0 0 173 0 0 0] 8 #() 1456 nil 27 1474 1824 65 2848 281 1552 307 1568 41 410 #{UI.CheckBox} 34 16 nil 7360 34 2 8 1140924451 1 11264 7538 nil nil 7584 false nil nil 5 nil nil nil 11264 nil 8 1819032944 2610 nil nil nil 1186 34 2 1234 #createAt:extent: 34 2 578 61 541 578 411 61 11264 1234 #text: 34 1 8 'Define Method &Protocols:' 11264 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 14 1 0 0 235 0 0 0 44 1 0 0] 8 #() 1456 nil 27 1474 1824 61 2848 411 1552 541 1568 61 410 #{UI.CheckBox} 34 16 nil 7360 34 2 8 1140928291 1 11584 7538 nil nil 7584 false nil nil 5 nil nil nil 11584 nil 8 1819032944 2610 nil nil nil 1186 34 2 1234 #createAt:extent: 34 2 578 415 459 578 211 41 11584 1234 #text: 34 1 8 'Verbose?' 11584 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 207 0 0 0 229 0 0 0 56 1 0 0 249 0 0 0] 8 #() 1456 nil 27 1474 1824 415 2848 211 1552 459 1568 41 410 #{UI.GroupBox} 34 14 nil 7360 34 2 8 1140850695 65 11904 nil nil nil 5 nil nil nil 11904 nil 8 1819032944 1186 34 2 1234 #createAt:extent: 34 2 578 35 419 578 631 111 11904 1234 #text: 34 1 8 '&Tracing:' 11904 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 209 0 0 0 76 1 0 0 8 1 0 0] 8 #() 1456 nil 27 1474 1824 35 2848 631 1552 419 1568 111 410 #{UI.CheckBox} 34 16 nil 7360 34 2 8 1140924451 1 12192 7538 nil nil 7584 false nil nil 5 nil nil nil 12192 nil 8 1819032944 2610 nil nil nil 1186 34 2 1234 #createAt:extent: 34 2 578 61 591 578 411 51 12192 1234 #text: 34 1 8 'Generate #&defineFunctions:' 12192 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 39 1 0 0 235 0 0 0 64 1 0 0] 8 #() 1456 nil 27 1474 1824 61 2848 411 1552 591 1568 51 410 #{UI.TextEdit} 34 16 nil 7360 34 2 8 1140916224 262145 12512 nil 1104 nil 5 nil nil nil 12512 nil 8 1819025648 2610 nil nil 1 1186 34 2 1234 #createAt:extent: 34 2 578 291 191 578 335 41 12512 1234 #setMarginWidths: 34 1 8 #(3 3) 12512 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 95 0 0 0 56 1 0 0 115 0 0 0] 8 #() 1456 nil 27 1474 1824 291 2848 335 1552 191 1568 41 410 #{UI.StaticText} 34 16 nil 7360 34 2 8 1140850946 1 12816 nil nil nil 5 nil nil nil 12816 nil 8 1819237552 2610 nil nil nil 1186 34 2 1234 #createAt:extent: 34 2 578 85 197 578 181 41 12816 1234 #text: 34 1 8 'C&onstants Pool:
' 12816 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 42 0 0 0 98 0 0 0 132 0 0 0 118 0 0 0] 8 #() 1456 nil 27 1474 1824 85 2848 181 1552 197 1568 41 410 #{UI.GroupBox} 34 14 nil 7360 34 2 8 1140850695 65 13120 nil nil nil 5 nil nil nil 13120 nil 8 1819032944 1186 34 2 1234 #createAt:extent: 34 2 578 5 257 578 671 441 13120 1234 #text: 34 1 8 'Ad&vanced' 13120 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 128 0 0 0 81 1 0 0 92 1 0 0] 8 #() 1456 nil 27 1474 1824 5 1536 -13 1552 257 1568 441 410 #{UI.ComboBox} 34 17 nil 7360 34 2 8 1144063491 1025 13408 4226 138 144 2208 nil 4288 1104 nil 5 nil nil nil 13408 nil 8 1818642288 4560 4944 151 1186 34 1 1234 #createAt:extent: 34 2 578 445 297 578 185 47 13408 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 222 0 0 0 148 0 0 0 58 1 0 0 171 0 0 0] 8 #() 1456 nil 27 1474 1824 445 1536 -59 1552 297 1568 47 410 #{UI.StaticText} 34 16 nil 7360 34 2 8 1140916480 262145 13680 nil nil nil 5 nil nil nil 13680 nil 8 1819237552 2610 nil nil nil 1186 34 1 1234 #createAt:extent: 34 2 578 291 133 578 335 41 13680 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 66 0 0 0 56 1 0 0 86 0 0 0] 8 #() 1456 nil 27 1474 1824 291 1536 -63 1552 133 1568 41 170 192 34 24 11584 8 'verboseTrace' 12512 8 'constantsPoolName' 11264 8 'defineProtocols' 7472 8 'lowercaseKeywords' 9488 8 'highLevelWrappers' 10064 8 'packageName' 8864 8 'tracing' 13408 8 'commentGeneration' 10688 8 'namespace' 13680 8 'typelibVariableName' 10368 8 'generateTypelib' 12192 8 'defineFunctions' nil 1186 34 2 1234 #createAt:extent: 34 2 578 1 1 578 689 723 7360 1234 #text: 34 1 8 'Generation Parameters' 7360 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 21 9136 10688 8144 7840 10064 8512 10960 13408 9760 9488 11904 8864 11584 12192 11264 7472 13120 13680 10368 12816 12512 1456 nil 27 170 192 2208 nil 1186 34 2 1234 #createAt:extent: 34 2 578 1 1 578 689 803 5664 1234 #text: 34 1 8 'Step 2' 5664 1394 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 7360 5744 1456 nil 27 770 8 '3' 410 #{UI.ContainerView} 34 15 nil 640 34 2 8 1140850688 131073 14592 nil nil nil 5 nil nil nil 14592 610 1 1 nil 410 #{UI.ContainerView} 34 15 nil 14592 34 2 8 1140850688 131073 14672 nil nil nil 5 nil nil nil 14672 962 170 176 34 8 410 #{UI.PushButton} 34 20 nil 14672 34 2 8 1140924416 1 14784 nil 1104 nil 5 nil nil nil 14784 nil 8 1819032944 1138 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1186 34 3 1234 #createAt:extent: 34 2 578 539 31 578 151 51 14784 1234 #isEnabled: 8 #(false) 14784 1234 #text: 34 1 8 'Cancel' 14784 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 1456 nil 29 1474 1520 -149 1536 1 1552 31 1568 51 410 #{UI.PushButton} 34 20 nil 14672 34 2 8 1140924416 1 15136 nil 1104 nil 5 nil nil nil 15136 nil 8 1819032944 1138 #finish 8 '&Finish' 1 1 nil nil false nil nil nil 1186 34 3 1234 #createAt:extent: 34 2 578 385 31 578 141 51 15136 1234 #isEnabled: 8 #(false) 15136 1234 #text: 34 1 8 '&Finish' 15136 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1456 nil 29 1474 1520 -139 1536 -163 1552 31 1568 51 410 #{UI.StaticRectangle} 34 14 nil 14672 34 2 8 1140916487 262145 15488 nil 1104 nil 5 nil nil nil 15488 nil 8 1819237552 1186 34 1 1234 #createAt:extent: 34 2 578 1 1 578 689 5 15488 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1456 nil 27 1474 1824 1 1536 1 1552 1 1568 5 410 #{UI.PushButton} 34 20 nil 14672 34 2 8 1140924416 1 15728 nil 1104 nil 5 nil nil nil 15728 nil 8 1819032944 1138 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 1186 34 3 1234 #createAt:extent: 34 2 578 245 31 578 141 51 15728 1234 #isEnabled: 8 #(false) 15728 1234 #text: 34 1 8 '< &Back' 15728 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 1456 nil 29 1474 1520 -139 1536 -303 1552 31 1568 51 170 192 2208 nil 1186 34 2 1234 #createAt:extent: 34 2 578 1 723 578 689 81 14672 1234 #text: 34 1 8 'Buttons' 14672 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 4 15728 15136 14784 15488 1456 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 14592 34 2 8 1140850688 131073 16288 nil nil nil 5 nil nil nil 16288 962 170 176 34 4 410 #{UI.ListView} 34 45 nil 16288 34 2 8 1140920393 1025 16400 4226 138 144 2208 nil 4288 1104 nil 5 4306 nil true 34 9 4354 1 1138 #selectAll 8 'Select &All' 1 1 nil nil nil 4354 1 1138 #selectInstalled 8 'Select &Installed' 1 1 nil nil nil 4354 1 1138 #selectUninstalled 8 'Select &Uninstalled' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 4354 1 1138 #browseTypeClass 8 'Browse &Class' 1 1 nil nil nil 4354 1 1138 #browseTypesIDL 8 '&Browse IDL' 1 1 nil nil nil 4354 1 1138 #inspectType 8 'I&nspect' 1 1 nil nil nil 16674 4097 4354 1 1138 #toggleStandardTypes 8 'Show &Standard Types' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 16400 nil 8 1819093264 4560 4546 #iconImageIndex 4576 4608 nil 4546 #helpstring 8 #() nil 578 65 65 nil nil 138 144 34 3 4658 8 'Name' 437 #left 4560 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] #name 17088 7 513 nil nil nil 16400 16944 3 nil nil 4658 8 '' 41 #left nil 17074 0 nil 17106 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 17216 7 513 nil 17074 0 nil 17106 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:each | each isInstalled]' 8 #[30 105 17 158 106] #isInstalled 17296 7 257 nil nil 16400 17074 0 nil 17106 4 1 17072 8 'doIt' 8 '[:each | (each ?? Graphics.NullIcon) iconImageIndex]' 8 #[32 105 17 45 177 160 106] 1442886 2 #{Kernel.VariableBinding} #NullIcon #{Graphics.NullIcon} #{Graphics} 1 #?? #iconImageIndex 17376 7 257 nil 1 nil nil 4658 8 'Type' 201 #left 4560 4546 #<= 8 #() 17074 0 nil 17106 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:each | each idlKeyword]' 8 #[30 105 17 158 106] #idlKeyword 17552 7 257 nil nil 16400 nil 1 nil nil #report 4944 nil 133157 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 1186 34 3 1234 #createAt:extent: 34 2 578 1 1 578 685 617 16400 1234 #text: 34 1 8 'Name' 16400 1234 #columnOrder: 34 1 8 #(2 1 3) 16400 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 52 1 0 0] 8 #() 1456 nil 35 1474 1824 1 1536 -3 1552 1 2880 -105 410 #{UI.PushButton} 34 20 nil 16288 34 2 8 1140924416 1 17888 nil 1104 nil 5 nil nil nil 17888 nil 8 1819032944 1138 #generate 8 '&Generate' 1 1 nil nil true nil nil nil 1186 34 3 1234 #createAt:extent: 34 2 578 535 647 578 141 51 17888 1234 #isEnabled: 8 #(false) 17888 1234 #text: 34 1 8 '&Generate' 17888 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 67 1 0 0 81 1 0 0 92 1 0 0] 8 #() 1456 nil 29 1474 1520 -139 1536 -13 2864 -49 2880 -25 170 192 34 2 16400 8 'types' nil 1186 34 1 1234 #createAt:extent: 34 2 578 1 1 578 689 723 16288 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 2 16400 17888 1456 nil 27 170 192 34 2 16288 8 'Classes' nil 1186 34 2 1234 #createAt:extent: 34 2 578 1 1 578 689 803 14592 1234 #text: 34 1 8 'Step 3' 14592 1394 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 16288 14672 1456 nil 27 816 nil nil nil 170 192 2208 nil 1186 34 1 1234 #createAt:extent: 34 2 578 21 21 578 689 803 640 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 155 1 0 0] 34 3 816 5664 14592 1456 nil 27 170 192 34 2 640 8 'cards' 1180166 #{Graphics.Rectangle} 578 21 21 578 21 21 nil nil nil nil 1 nil nil nil 578 681 901 1 nil nil 1186 34 2 1234 #createAt:extent: 34 2 578 6143 21 578 761 921 416 1234 #text: 34 1 8 'COM Component Wizard' 416 1394 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 214 1 0 0] 34 1 640 1456 nil 27)!

toolsFolderHelpId
	^10604! !
!Tools.AXComponentWizard class categoriesForMethods!
defaultAdditionalAccelerators!constants!private! !
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!options!public! !
registerServer!operations!public! !
resource_Default_view!public!resources-views! !
toolsFolderHelpId!public! !
!

