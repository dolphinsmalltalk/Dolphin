"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell
	subclass: #'Tools.AXComponentWizard'
	instanceVariableNames: 'typeLibs types description guid namespaceName packageName forcePackage cards libraryName libraryPath buffer generateTypelib typelibVariableName constantsPoolName highLevelWrappers classComments tracing defineProtocols defineFunctionTables lowercaseIdentifiers verboseTracing showStandard includeHidden'
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
				typeConverter: ((PluggableTypeConverter leftToRight: [:bindingRef | bindingRef valueOrNil]
						rightToLeft: [:class | class fullyQualifiedReference])
						leftNullValue: namespaceName model value;
						yourself).
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
	includeHidden := self add: BooleanPresenter new name: 'includeHidden'.

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
		to: self.
	includeHidden
		when: #valueChanged
		send: #refreshTypesList
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
	self includeHidden ifFalse: [generatable := generatable reject: [:each | each isHidden]].
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

includeHidden
	^includeHidden value!

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
	typeLibs setFocus.
	self updateTypelibVariable!

parametersNextCard
	"The user has configured the generation parameters is desirous of moving to the next card."

	self apply.
	^cards nextCard!

queryToggleStandardTypes: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: showStandard!

refresh
	"Refresh the list of current AXTypeLibraryAnalyzers in the image"

	<acceleratorKey: 'F5'>
	typeLibs
		list: (TypeLibraryAnalyzer allOpenableTypeLibs asSortedCollection: [:x :y | x name < y name])!

refreshTypesList
	self typeLib ifNil: [types clear] ifNotNil: [:typeLib | self updateTypesList: typeLib]!

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
	self refreshTypesList!

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
includeHidden!accessing!public! !
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
refreshTypesList!commands-actions!private! !
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 5 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.WizardCardContainer} 50 15 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 1350 1 #{UI.CardLayout} 550 #{Core.OrderedCollection} 3 518 #{Core.Association} 8 '1' 18 #{UI.ContainerView} 50 15 nil 240 50 2 8 1140850688 131073 416 nil nil nil 5 nil nil nil 416 210 1 1 nil 18 #{UI.ContainerView} 50 15 nil 416 50 2 8 1140850688 131073 496 nil nil nil 5 nil nil nil 496 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 6 18 #{UI.StaticRectangle} 50 14 nil 496 50 2 8 1140916487 262145 640 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 640 nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 193 672 8 '' 640 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 1 1010 #fixedParentRight 1 1010 #fixedParentTop 1 1010 #fixedViewTop 5 18 #{UI.PushButton} 50 20 nil 496 50 2 8 1140924416 1 1088 nil 720 nil 5 nil nil nil 1088 nil nil 1350 4 #{UI.CommandDescription} #libraryListNextCard 8 '&Next >' 1 1 nil nil false nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 193 1120 8 '&Next >' 1088 786 #isEnabled: 8 #(false) 1088 3 8 #() 946 193 193 nil 29 978 1010 #fixedViewRight -139 1040 -163 1056 31 1072 51 18 #{UI.PushButton} 50 20 nil 496 50 2 8 1140924416 1 1424 nil 720 nil 5 nil nil nil 1424 nil nil 1154 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[16 1 0 0 15 0 0 0 86 1 0 0 40 0 0 0] 193 1456 8 'Cancel' 1424 786 #isEnabled: 8 #(false) 1424 3 8 #() 946 193 193 nil 29 978 1408 -139 1040 -3 1056 31 1072 51 550 #{Core.IdentityDictionary} 0 nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 193 528 8 'Buttons' 496 3 50 3 1088 1424 640 946 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 416 50 2 8 1140850688 131073 1920 nil nil nil 5 nil nil nil 1920 562 594 #{Core.LookupTable} 50 12 18 #{UI.ListView} 50 45 nil 1920 50 2 8 1140953165 1025 2032 838 2 #{UI.ListModel} 338 0 nil 6 #{Kernel.IdentitySearchPolicy} 720 nil 5 2886 4 #{UI.Menu} nil true 50 3 1094 2 #{UI.CommandMenuItem} 1 1154 #browseIDL 8 '&Browse IDL' 1 1 nil nil nil 2226 1 1154 #inspectLibrary 8 '&Inspect' 1 1 nil nil nil 2226 1 1154 #typeLibHelp 8 '&Help' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2032 nil nil 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 338 3 3142 5 #{UI.ListViewColumn} 8 'Library' 251 #left 2416 2402 #<= 8 #() 2402 #name 8 #() nil 2032 nil 1 nil nil 2498 8 'Version' 101 #left 2402 #versionString 8 #() 2402 #<= 8 #() nil nil 2032 nil 1 nil nil 2498 8 'Description' 327 #left 2416 2402 #<= 8 #() 2402 #helpstring 2656 nil 2032 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 2032 nil nil nil nil nil nil nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 193 2064 8 'Library' 2032 786 #contextMenu: 50 1 2192 2032 3 8 #() 946 193 193 nil 35 978 1024 1 1040 -3 1056 1 1010 #fixedParentBottom -235 18 #{UI.PushButton} 50 20 nil 1920 50 2 8 1140924416 1 3056 nil 720 nil 5 nil nil nil 3056 nil nil 1154 #loadTypeLib 8 'Bro&wse…' 1 1 nil nil false nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 193 3088 8 'Bro&wse…' 3056 786 #isEnabled: 8 #(false) 3056 3 8 #() 946 193 193 nil 29 978 1408 -139 1040 -13 1010 #fixedViewBottom -49 3040 -165 18 #{UI.StaticText} 50 16 nil 1920 50 2 8 1140850946 1 3376 nil nil nil 5 nil nil nil 3376 nil nil 518 #{UI.NullConverter} nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 193 3408 nil 3376 786 #text: 50 1 8 '&Location:' 3376 3 8 #() 946 193 193 nil 27 978 1024 1 1010 #fixedViewLeft 111 3360 -49 3040 -95 18 #{UI.StaticText} 50 16 nil 1920 50 2 8 1140850944 1 3696 nil nil nil 5 nil nil nil 3696 nil nil 3442 nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[65 0 0 0 32 1 0 0 78 1 0 0 62 1 0 0] 193 3728 nil 3696 786 #text: 50 1 8 'Path of selected library here…
on two lines if necessary.' 3696 3 8 #() 946 193 193 nil 27 978 1024 131 1040 -19 3360 -59 3040 -85 18 #{UI.StaticText} 50 16 nil 1920 50 2 8 1140850946 1 3984 nil nil nil 5 nil nil nil 3984 nil nil 3442 nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 193 4016 nil 3984 786 #text: 50 1 8 '&GUID:' 3984 3 8 #() 946 193 193 nil 27 978 1024 1 3680 111 3360 -39 3040 -25 18 #{UI.StaticText} 50 16 nil 1920 50 2 8 1140850944 1 4272 nil nil nil 5 nil nil nil 4272 nil nil 3442 nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[65 0 0 0 72 1 0 0 78 1 0 0 92 1 0 0] 193 4304 nil 4272 786 #text: 50 1 8 'GUID of selected library here…' 4272 3 8 #() 946 193 193 nil 27 978 1024 131 1040 -19 3360 -39 3040 -25 594 1728 50 6 4272 8 'guid' 3696 8 'libraryPath' 2032 8 'typeLibs' nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 193 1952 8 '' 1920 3 50 6 2032 3056 3376 3696 3984 4272 946 193 193 nil 27 594 1728 50 2 1920 8 'Libraries' nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 193 448 8 'Step 1' 416 3 50 2 1920 496 946 193 193 nil 27 370 8 '2' 18 #{UI.ContainerView} 50 15 nil 240 50 2 8 1140850688 131073 5040 nil nil nil 5 nil nil nil 5040 210 1 1 nil 18 #{UI.ContainerView} 50 15 nil 5040 50 2 8 1140850688 131073 5120 nil nil nil 5 nil nil nil 5120 562 594 #{Core.LookupTable} 50 8 18 #{UI.StaticRectangle} 50 14 nil 5120 50 2 8 1140916487 262145 5232 nil 720 nil 5 nil nil nil 5232 nil nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 193 5264 8 '' 5232 3 8 #() 946 193 193 nil 27 978 1024 1 1040 1 1056 1 1072 5 18 #{UI.PushButton} 50 20 nil 5120 50 2 8 1140924416 1 5472 nil 720 nil 5 nil nil nil 5472 nil nil 1154 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 193 5504 8 '< &Back' 5472 786 #isEnabled: 8 #(false) 5472 3 8 #() 946 193 193 nil 29 978 1408 -139 1040 -303 1056 31 1072 51 18 #{UI.PushButton} 50 20 nil 5120 50 2 8 1140924416 1 5776 nil 720 nil 5 nil nil nil 5776 nil nil 1154 #parametersNextCard 8 '&Next >' 1 1 nil nil false nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 193 5808 8 '&Next >' 5776 786 #isEnabled: 8 #(false) 5776 3 8 #() 946 193 193 nil 29 978 1408 -139 1040 -163 1056 31 1072 51 18 #{UI.PushButton} 50 20 nil 5120 50 2 8 1140924416 1 6080 nil 720 nil 5 nil nil nil 6080 nil nil 1154 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[18 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 193 6112 8 'Cancel' 6080 786 #isEnabled: 8 #(false) 6080 3 8 #() 946 193 193 nil 29 978 1408 -139 1040 1 1056 31 1072 51 1730 0 nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 193 5152 8 'Buttons' 5120 3 50 4 5472 5776 6080 5232 946 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 5040 50 2 8 1140850688 131073 6560 nil nil nil 5 nil nil nil 6560 562 594 #{Core.LookupTable} 50 42 18 #{UI.PushButton} 50 20 nil 6560 50 2 8 1140924416 1 6672 nil 720 nil 5 nil nil nil 6672 nil nil 1154 #chooseNamespace 8 '…' 1 1 nil nil false nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[66 1 0 0 5 0 0 0 86 1 0 0 25 0 0 0] 193 6704 8 '…' 6672 786 #isEnabled: 8 #(false) 6672 3 8 #() 946 193 193 nil 29 978 1408 -39 1040 -3 1010 #fixedPreviousTop -1 1072 41 18 #{UI.StaticText} 50 16 nil 6560 50 2 8 1140916480 1 6992 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 5 nil nil nil 6992 nil nil 3442 nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[23 0 0 0 6 0 0 0 120 0 0 0 26 0 0 0] 193 7024 nil 6992 786 #text: 50 1 8 '&Namespace:' 6992 3 8 #() 946 193 193 nil 27 978 1024 47 3680 195 1056 13 1072 41 18 #{UI.StaticText} 50 16 nil 6560 50 2 8 1140916480 262145 7344 7058 nil false 7104 nil 720 nil 5 nil nil nil 7344 nil nil 3442 nil nil nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[130 0 0 0 6 0 0 0 56 1 0 0 26 0 0 0] 193 7376 nil 7344 3 8 #() 946 193 193 nil 27 978 1010 #fixedPreviousRight 21 3680 365 6976 1 1010 #fixedPreviousBottom 1 18 #{UI.StaticText} 50 16 nil 6560 50 2 8 1140850944 1 7632 nil nil nil 5 nil nil nil 7632 nil nil 3442 nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[23 0 0 0 36 0 0 0 120 0 0 0 56 0 0 0] 193 7664 nil 7632 786 #text: 50 1 8 'Default &Package:' 7632 3 8 #() 946 193 193 nil 27 978 1024 47 3680 195 1056 73 1072 41 18 #{UI.TextEdit} 50 20 nil 6560 50 2 8 1140916224 262145 7920 nil 720 nil 5 nil nil nil 7920 nil nil 3442 nil nil 1 #focusLost nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[130 0 0 0 36 0 0 0 56 1 0 0 56 0 0 0] 193 7952 nil 7920 786 #setMarginWidths: 50 1 8 #(3 3) 7920 3 8 #() 946 193 193 nil 45 978 7600 21 3680 365 6976 1 7616 1 18 #{UI.PushButton} 50 20 nil 6560 50 2 8 1140924416 1 8208 nil 720 nil 5 nil nil nil 8208 nil nil 1154 #choosePackage 8 '…' 1 1 nil nil false nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[66 1 0 0 36 0 0 0 86 1 0 0 56 0 0 0] 193 8240 8 '…' 8208 786 #isEnabled: 8 #(false) 8208 3 8 #() 946 193 193 nil 29 978 1408 -39 1040 -3 6976 1 1072 41 18 #{UI.CheckBox} 50 16 nil 6560 50 2 8 1140927747 1 8512 7058 nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 517 nil nil nil 8512 nil nil 3442 nil nil nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[7 0 0 0 66 0 0 0 120 0 0 0 86 0 0 0] 193 8544 8 'Typelib &variable:' 8512 3 8 #() 946 193 193 nil 27 978 1024 15 3680 227 1056 133 1072 41 18 #{UI.StaticText} 50 16 nil 6560 50 2 8 1140916480 262145 8816 nil nil nil 5 nil nil nil 8816 nil nil 3442 nil nil nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[130 0 0 0 66 0 0 0 56 1 0 0 86 0 0 0] 193 8848 nil 8816 3 8 #() 946 193 193 nil 27 978 7600 21 3680 365 6976 1 7616 1 18 #{UI.StaticText} 50 16 nil 6560 50 2 8 1140850944 1 9056 nil nil nil 5 nil nil nil 9056 nil nil 3442 nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[23 0 0 0 95 0 0 0 120 0 0 0 115 0 0 0] 193 9088 nil 9056 786 #text: 50 1 8 'C&onstants Pool:
' 9056 3 8 #() 946 193 193 nil 27 978 1024 47 3680 195 1056 191 1072 41 18 #{UI.TextEdit} 50 20 nil 6560 50 2 8 1140916224 262145 9344 nil 720 nil 5 nil nil nil 9344 nil nil 3442 nil nil 1 #focusLost nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[130 0 0 0 95 0 0 0 56 1 0 0 115 0 0 0] 193 9376 nil 9344 786 #setMarginWidths: 50 1 8 #(3 3) 9344 3 8 #() 946 193 193 nil 45 978 7600 21 3680 365 6976 1 7616 1 18 #{UI.GroupBox} 50 14 nil 6560 50 2 8 1140850695 65 9632 nil nil nil 5 nil nil nil 9632 nil nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[2 0 0 0 128 0 0 0 81 1 0 0 92 1 0 0] 193 9664 8 'Ad&vanced' 9632 3 8 #() 946 193 193 nil 27 978 1024 5 1040 -13 1056 257 1072 441 18 #{UI.ComboBox} 50 17 nil 6560 50 2 8 1144063491 1025 9872 2098 338 0 nil 2160 720 nil 5 nil nil nil 9872 nil nil 2416 2784 151 738 50 1 786 #createWindow: 50 1 834 866 8 #[222 0 0 0 148 0 0 0 58 1 0 0 247 0 0 0] 193 9904 8 '' 9872 3 8 #() 946 193 193 nil 27 978 1024 445 1040 -59 1056 297 1072 47 18 #{UI.StaticText} 50 16 nil 6560 50 2 8 1140850944 65 10144 nil nil nil 5 nil nil nil 10144 nil nil 3442 nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[32 0 0 0 153 0 0 0 172 0 0 0 173 0 0 0] 193 10176 nil 10144 786 #text: 50 1 8 '&Class Comments:' 10144 3 8 #() 946 193 193 nil 27 978 1024 65 3680 281 1056 307 1072 41 18 #{UI.ComboBox} 50 17 nil 6560 50 2 8 1144063491 1025 10432 2098 338 0 nil 2160 720 nil 5 nil nil nil 10432 nil nil 2416 2784 101 738 50 1 786 #createWindow: 50 1 834 866 8 #[222 0 0 0 178 0 0 0 58 1 0 0 252 0 0 0] 193 10464 8 '' 10432 3 8 #() 946 193 193 nil 27 978 1024 445 1040 -59 1056 357 1072 47 18 #{UI.StaticText} 50 16 nil 6560 50 2 8 1140850944 1 10704 nil nil nil 5 nil nil nil 10704 nil nil 3442 nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[32 0 0 0 183 0 0 0 217 0 0 0 203 0 0 0] 193 10736 nil 10704 786 #text: 50 1 8 '&High-level wrapper methods:' 10704 3 8 #() 946 193 193 nil 27 978 1024 65 3680 371 1056 367 1072 41 18 #{UI.GroupBox} 50 14 nil 6560 50 2 8 1140850695 65 10992 nil nil nil 5 nil nil nil 10992 nil nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[17 0 0 0 209 0 0 0 76 1 0 0 8 1 0 0] 193 11024 8 '&Tracing:' 10992 3 8 #() 946 193 193 nil 27 978 1024 35 3680 631 1056 419 1072 111 18 #{UI.ComboBox} 50 17 nil 6560 50 2 8 1144063491 1025 11232 2098 338 0 nil 2160 720 nil 5 nil nil nil 11232 nil nil 2416 2784 401 738 50 1 786 #createWindow: 50 1 834 866 8 #[27 0 0 0 229 0 0 0 119 0 0 0 197 1 0 0] 193 11264 8 '' 11232 3 8 #() 946 193 193 nil 27 978 1024 55 1040 -449 1056 459 1072 47 18 #{UI.CheckBox} 50 16 nil 6560 50 2 8 1140928291 1 11504 7058 nil nil 8608 false nil nil 5 nil nil nil 11504 nil nil 3442 nil nil nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[207 0 0 0 229 0 0 0 56 1 0 0 249 0 0 0] 193 11536 8 'Verbose?' 11504 3 8 #() 946 193 193 nil 27 978 1024 415 3680 211 1056 459 1072 41 18 #{UI.CheckBox} 50 16 nil 6560 50 2 8 1140924451 1 11776 7058 nil nil 8608 false nil nil 5 nil nil nil 11776 nil nil 3442 nil nil nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[30 0 0 0 14 1 0 0 235 0 0 0 44 1 0 0] 193 11808 8 'Define Method &Protocols:' 11776 3 8 #() 946 193 193 nil 27 978 1024 61 3680 411 1056 541 1072 61 18 #{UI.CheckBox} 50 16 nil 6560 50 2 8 1140924451 1 12048 7058 nil nil 8608 false nil nil 5 nil nil nil 12048 nil nil 3442 nil nil nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[30 0 0 0 39 1 0 0 235 0 0 0 64 1 0 0] 193 12080 8 'Generate #&defineFunctions:' 12048 3 8 #() 946 193 193 nil 27 978 1024 61 3680 411 1056 591 1072 51 18 #{UI.CheckBox} 50 16 nil 6560 50 2 8 1140924451 1 12320 7058 nil nil 8608 false nil nil 5 nil nil nil 12320 nil nil 3442 nil nil nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[30 0 0 0 59 1 0 0 235 0 0 0 89 1 0 0] 193 12352 8 '&Lowercase secondary keywords' 12320 3 8 #() 946 193 193 nil 27 978 1024 61 3680 411 1056 631 1072 61 594 1728 50 24 9872 8 'commentGeneration' 9344 8 'constantsPoolName' 12048 8 'defineFunctions' 11776 8 'defineProtocols' 8512 8 'generateTypelib' 10432 8 'highLevelWrappers' 12320 8 'lowercaseKeywords' 7344 8 'namespace' 7920 8 'packageName' 11232 8 'tracing' 8816 8 'typelibVariableName' 11504 8 'verboseTrace' nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 193 6592 8 'Generation Parameters' 6560 3 50 21 6992 7344 6672 7632 7920 8208 8512 8816 9056 9344 9632 10144 9872 10704 10432 10992 11232 11504 11776 12048 12320 946 193 193 nil 27 1730 0 nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 193 5072 8 'Step 2' 5040 1 50 2 6560 5120 946 193 193 nil 27 370 8 '3' 18 #{UI.ContainerView} 50 15 nil 240 50 2 8 1140850688 131073 13184 nil nil nil 5 nil nil nil 13184 210 1 1 nil 18 #{UI.ContainerView} 50 15 nil 13184 50 2 8 1140850688 131073 13264 nil nil nil 5 nil nil nil 13264 562 594 #{Core.LookupTable} 50 8 18 #{UI.StaticRectangle} 50 14 nil 13264 50 2 8 1140916487 262145 13376 nil 720 nil 5 nil nil nil 13376 nil nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 193 13408 8 '' 13376 3 8 #() 946 193 193 nil 27 978 1024 1 1040 1 1056 1 1072 5 18 #{UI.PushButton} 50 20 nil 13264 50 2 8 1140924416 1 13616 nil 720 nil 5 nil nil nil 13616 nil nil 1154 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 193 13648 8 '< &Back' 13616 786 #isEnabled: 8 #(false) 13616 3 8 #() 946 193 193 nil 29 978 1408 -139 1040 -303 1056 31 1072 51 18 #{UI.PushButton} 50 20 nil 13264 50 2 8 1140924416 1 13920 nil 720 nil 5 nil nil nil 13920 nil nil 1154 #finish 8 '&Finish' 1 1 nil nil false nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 193 13952 8 '&Finish' 13920 786 #isEnabled: 8 #(false) 13920 3 8 #() 946 193 193 nil 29 978 1408 -139 1040 -163 1056 31 1072 51 18 #{UI.PushButton} 50 20 nil 13264 50 2 8 1140924416 1 14224 nil 720 nil 5 nil nil nil 14224 nil nil 1154 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[13 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 193 14256 8 'Cancel' 14224 786 #isEnabled: 8 #(false) 14224 3 8 #() 946 193 193 nil 29 978 1408 -149 1040 1 1056 31 1072 51 1730 0 nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 193 13296 8 'Buttons' 13264 3 50 4 13616 13920 14224 13376 946 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 13184 50 2 8 1140850688 131073 14704 nil nil nil 5 nil nil nil 14704 562 594 #{Core.LookupTable} 50 6 18 #{UI.ListView} 50 45 nil 14704 50 2 8 1140920393 1025 14816 2098 338 0 nil 2160 720 nil 5 2178 nil true 50 9 2226 1 1154 #selectAll 8 'Select &All' 1 1 nil nil nil 2226 1 1154 #selectInstalled 8 'Select &Installed' 1 1 nil nil nil 2226 1 1154 #selectUninstalled 8 'Select &Uninstalled' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 2226 1 1154 #browseTypeClass 8 'Browse &Class' 1 1 nil nil nil 2226 1 1154 #browseTypesIDL 8 '&Browse IDL' 1 1 nil nil nil 2226 1 1154 #inspectType 8 'I&nspect' 1 1 nil nil nil 15090 4097 2226 1 1154 #toggleStandardTypes 8 'Show &Standard Types' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 14816 nil nil 2416 2402 #iconImageIndex 2432 2464 nil 2402 #helpstring 8 #() nil 946 65 65 nil nil 338 3 2498 8 'Name' 437 #left 2416 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] #name 15472 7 513 nil nil nil 14816 15344 3 nil nil 2498 8 '' 41 #left nil 15458 0 nil 15490 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 15600 7 513 nil 15458 0 nil 15490 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:each | each isInstalled]' 8 #[30 105 17 158 106] #isInstalled 15680 7 257 nil nil 14816 15458 0 nil 15490 4 1 15456 8 'doIt' 8 '[:each | (each ?? Graphics.NullIcon) iconImageIndex]' 8 #[32 105 17 45 177 160 106] 1094 2 #{Kernel.VariableBinding} #NullIcon #{Graphics.NullIcon} #{Graphics} 1 #?? #iconImageIndex 15760 7 257 nil 1 nil nil 2498 8 'Type' 201 #left 2416 2402 #<= 8 #() 15458 0 nil 15490 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:each | each idlKeyword]' 8 #[30 105 17 158 106] #idlKeyword 15936 7 257 nil nil 14816 nil 1 nil nil #report 2784 nil 133157 nil 1 nil nil nil nil 1 2802 14816 nil nil nil nil nil nil nil nil nil 738 50 3 786 #createWindow: 50 1 834 866 8 #[0 0 0 0 0 0 0 0 86 1 0 0 52 1 0 0] 193 14848 8 'Name' 14816 786 #contextMenu: 50 1 14912 14816 786 #columnOrder: 50 1 8 #(2 1 3) 14816 3 8 #() 946 193 193 nil 35 978 1024 1 1040 -3 1056 1 3040 -105 18 #{UI.PushButton} 50 20 nil 14704 50 2 8 1140924416 1 16288 nil 720 nil 5 nil nil nil 16288 nil nil 1154 #generate 8 '&Generate' 1 1 nil nil true nil nil nil 738 50 2 786 #createWindow: 50 1 834 866 8 #[11 1 0 0 67 1 0 0 81 1 0 0 92 1 0 0] 193 16320 8 '&Generate' 16288 786 #isEnabled: 8 #(false) 16288 3 8 #() 946 193 193 nil 29 978 1408 -139 1040 -13 3360 -49 3040 -25 18 #{UI.CheckBox} 50 16 nil 14704 50 2 8 1409363203 1 16592 7058 nil nil 8608 false nil nil 517 nil nil nil 16592 nil nil 3442 nil nil nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[5 0 0 0 69 1 0 0 118 0 0 0 90 1 0 0] 193 16624 8 'Include &Hidden?' 16592 3 8 #() 946 193 193 nil 27 978 1024 11 3680 227 3360 -41 3040 -29 594 1728 50 4 16592 8 'includeHidden' 14816 8 'types' nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 193 14736 8 '' 14704 3 50 3 14816 16288 16592 946 193 193 nil 27 594 1728 50 2 14704 8 'Classes' nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 193 13216 8 'Step 3' 13184 1 50 2 14704 13264 946 193 193 nil 27 416 nil nil nil 1730 0 nil 738 50 1 786 #createWindow: 50 1 834 866 8 #[10 0 0 0 10 0 0 0 98 1 0 0 155 1 0 0] 193 272 8 '' 240 3 50 3 416 5040 13184 946 193 193 nil 27 594 1728 50 2 240 8 'cards' 518 #{Graphics.Rectangle} 946 21 21 946 21 21 nil nil nil nil 1 nil nil nil 946 681 901 nil nil 193 738 50 1 786 #createWindow: 50 1 834 17522 946 5119 21 946 5879 941 193 80 8 'COM Component Wizard' 32 1 50 1 240 946 193 193 nil 27)!

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

