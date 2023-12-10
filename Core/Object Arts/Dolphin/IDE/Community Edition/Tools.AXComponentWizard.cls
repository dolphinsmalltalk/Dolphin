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
	typeLibs setFocus!

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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 5 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.WizardCardContainer} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 1350 1 #{UI.CardLayout} 550 #{Core.OrderedCollection} 3 518 #{Core.Association} 8 '1' 18 #{UI.ContainerView} 50 15 nil 272 50 2 8 1140850688 131073 448 nil nil nil 5 nil nil nil 448 242 1 1 nil 18 #{UI.ContainerView} 50 15 nil 448 50 2 8 1140850688 131073 528 nil nil nil 5 nil nil nil 528 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 6 18 #{UI.StaticRectangle} 50 14 nil 528 50 2 8 1140916487 262145 672 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 672 nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 210 1 1 210 689 5 672 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 210 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 1 1010 #fixedParentRight 1 1010 #fixedParentTop 1 1010 #fixedViewTop 5 18 #{UI.PushButton} 50 20 nil 528 50 2 8 1140924416 1 1088 nil 752 nil 5 nil nil nil 1088 nil nil 1350 4 #{UI.CommandDescription} #libraryListNextCard 8 '&Next >' 1 1 nil nil false nil nil nil 770 50 3 818 #createAt:extent: 50 2 210 385 31 210 141 51 1088 818 #isEnabled: 8 #(false) 1088 818 #text: 50 1 8 '&Next >' 1088 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 960 nil 29 978 1010 #fixedViewRight -139 1040 -163 1056 31 1072 51 18 #{UI.PushButton} 50 20 nil 528 50 2 8 1140924416 1 1456 nil 752 nil 5 nil nil nil 1456 nil nil 1154 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 770 50 3 818 #createAt:extent: 50 2 210 545 31 210 141 51 1456 818 #isEnabled: 8 #(false) 1456 818 #text: 50 1 8 'Cancel' 1456 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 15 0 0 0 86 1 0 0 40 0 0 0] 8 #() 960 nil 29 978 1440 -139 1040 -3 1056 31 1072 51 550 #{Core.IdentityDictionary} 0 nil 770 50 2 818 #createAt:extent: 50 2 210 1 723 210 689 81 528 818 #text: 50 1 8 'Buttons' 528 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 50 3 1088 1456 672 960 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 448 50 2 8 1140850688 131073 2016 nil nil nil 5 nil nil nil 2016 594 626 #{Core.LookupTable} 50 12 18 #{UI.ListView} 50 45 nil 2016 50 2 8 1140953165 1025 2128 838 2 #{UI.ListModel} 370 0 nil 6 #{Kernel.IdentitySearchPolicy} 752 nil 5 2886 4 #{UI.Menu} nil true 50 3 1094 2 #{UI.CommandMenuItem} 1 1154 #browseIDL 8 '&Browse IDL' 1 1 nil nil nil 2322 1 1154 #inspectLibrary 8 '&Inspect' 1 1 nil nil nil 2322 1 1154 #typeLibHelp 8 '&Help' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2128 nil nil 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 370 3 3142 5 #{UI.ListViewColumn} 8 'Library' 251 #left 2512 2498 #<= 8 #() 2498 #name 8 #() nil 2128 nil 1 nil nil 2594 8 'Version' 101 #left 2498 #versionString 8 #() 2498 #<= 8 #() nil nil 2128 nil 1 nil nil 2594 8 'Description' 327 #left 2512 2498 #<= 8 #() 2498 #helpstring 2752 nil 2128 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 1 1 210 685 487 2128 818 #text: 50 1 8 'Library' 2128 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 8 #() 960 nil 35 978 1024 1 1040 -3 1056 1 1010 #fixedParentBottom -235 18 #{UI.PushButton} 50 20 nil 2016 50 2 8 1140924416 1 3120 nil 752 nil 5 nil nil nil 3120 nil nil 1154 #loadTypeLib 8 'Bro&wse…' 1 1 nil nil false nil nil nil 770 50 3 818 #createAt:extent: 50 2 210 535 507 210 141 51 3120 818 #isEnabled: 8 #(false) 3120 818 #text: 50 1 8 'Bro&wse…' 3120 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 8 #() 960 nil 29 978 1440 -139 1040 -13 1010 #fixedViewBottom -49 3104 -165 18 #{UI.StaticText} 50 16 nil 2016 50 2 8 1140850946 1 3472 nil nil nil 5 nil nil nil 3472 nil nil 518 #{UI.NullConverter} nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 1 577 210 111 51 3472 818 #text: 50 1 8 '&Location:' 3472 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 8 #() 960 nil 27 978 1024 1 1010 #fixedViewLeft 111 3456 -49 3104 -95 18 #{UI.StaticText} 50 16 nil 2016 50 2 8 1140850944 1 3792 nil nil nil 5 nil nil nil 3792 nil nil 3538 nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 131 577 210 539 61 3792 818 #text: 50 1 8 'Path of selected library here…
on two lines if necessary.' 3792 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 32 1 0 0 78 1 0 0 62 1 0 0] 8 #() 960 nil 27 978 1024 131 1040 -19 3456 -59 3104 -85 18 #{UI.StaticText} 50 16 nil 2016 50 2 8 1140850946 1 4080 nil nil nil 5 nil nil nil 4080 nil nil 3538 nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 1 657 210 111 41 4080 818 #text: 50 1 8 '&GUID:' 4080 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 8 #() 960 nil 27 978 1024 1 3776 111 3456 -39 3104 -25 18 #{UI.StaticText} 50 16 nil 2016 50 2 8 1140850944 1 4368 nil nil nil 5 nil nil nil 4368 nil nil 3538 nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 131 657 210 539 41 4368 818 #text: 50 1 8 'GUID of selected library here…' 4368 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 72 1 0 0 78 1 0 0 92 1 0 0] 8 #() 960 nil 27 978 1024 131 1040 -19 3456 -39 3104 -25 626 1792 50 6 4368 8 'guid' 3792 8 'libraryPath' 2128 8 'typeLibs' nil 770 50 1 818 #createAt:extent: 50 2 210 1 1 210 689 723 2016 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 50 6 2128 3120 3472 3792 4080 4368 960 nil 27 626 1792 50 2 2016 8 'Libraries' nil 770 50 2 818 #createAt:extent: 50 2 210 1 1 210 689 803 448 818 #text: 50 1 8 'Step 1' 448 898 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 50 2 2016 528 960 nil 27 402 8 '2' 18 #{UI.ContainerView} 50 15 nil 272 50 2 8 1140850688 131073 5152 nil nil nil 5 nil nil nil 5152 242 1 1 nil 18 #{UI.ContainerView} 50 15 nil 5152 50 2 8 1140850688 131073 5232 nil nil nil 5 nil nil nil 5232 594 626 #{Core.LookupTable} 50 8 18 #{UI.StaticRectangle} 50 14 nil 5232 50 2 8 1140916487 262145 5344 nil 752 nil 5 nil nil nil 5344 nil nil 770 50 1 818 #createAt:extent: 50 2 210 1 1 210 689 5 5344 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 960 nil 27 978 1024 1 1040 1 1056 1 1072 5 18 #{UI.PushButton} 50 20 nil 5232 50 2 8 1140924416 1 5568 nil 752 nil 5 nil nil nil 5568 nil nil 1154 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 245 31 210 141 51 5568 818 #text: 50 1 8 '< &Back' 5568 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 960 nil 29 978 1440 -139 1040 -303 1056 31 1072 51 18 #{UI.PushButton} 50 20 nil 5232 50 2 8 1140924416 1 5872 nil 752 nil 5 nil nil nil 5872 nil nil 1154 #parametersNextCard 8 '&Next >' 1 1 nil nil false nil nil nil 770 50 3 818 #createAt:extent: 50 2 210 385 31 210 141 51 5872 818 #isEnabled: 8 #(false) 5872 818 #text: 50 1 8 '&Next >' 5872 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 960 nil 29 978 1440 -139 1040 -163 1056 31 1072 51 18 #{UI.PushButton} 50 20 nil 5232 50 2 8 1140924416 1 6208 nil 752 nil 5 nil nil nil 6208 nil nil 1154 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 770 50 3 818 #createAt:extent: 50 2 210 549 31 210 141 51 6208 818 #isEnabled: 8 #(false) 6208 818 #text: 50 1 8 'Cancel' 6208 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 960 nil 29 978 1440 -139 1040 1 1056 31 1072 51 1794 0 nil 770 50 2 818 #createAt:extent: 50 2 210 1 723 210 689 81 5232 818 #text: 50 1 8 'Buttons' 5232 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 50 4 5568 5872 6208 5344 960 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 5152 50 2 8 1140850688 131073 6752 nil nil nil 5 nil nil nil 6752 594 626 #{Core.LookupTable} 50 42 18 #{UI.PushButton} 50 20 nil 6752 50 2 8 1140924416 1 6864 nil 752 nil 5 nil nil nil 6864 nil nil 1154 #chooseNamespace 8 '…' 1 1 nil nil false nil nil nil 770 50 3 818 #createAt:extent: 50 2 210 645 11 210 41 41 6864 818 #isEnabled: 8 #(false) 6864 818 #text: 50 1 8 '…' 6864 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 66 1 0 0 5 0 0 0 86 1 0 0 25 0 0 0] 8 #() 960 nil 29 978 1440 -39 1040 -3 1010 #fixedPreviousTop -1 1072 41 18 #{UI.StaticText} 50 16 nil 6752 50 2 8 1140916480 262145 7216 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 752 nil 5 nil nil nil 7216 nil nil 3538 nil nil nil 770 50 1 818 #createAt:extent: 50 2 210 291 13 210 335 41 7216 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 6 0 0 0 56 1 0 0 26 0 0 0] 8 #() 960 nil 27 978 1024 291 1040 -63 1056 13 1072 41 18 #{UI.StaticText} 50 16 nil 6752 50 2 8 1140916482 1 7520 7282 nil false 7328 nil nil nil 5 nil nil nil 7520 nil nil 3538 nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 85 19 210 181 41 7520 818 #text: 50 1 8 '&Namespace:' 7520 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 42 0 0 0 9 0 0 0 132 0 0 0 29 0 0 0] 8 #() 960 nil 27 978 1024 85 3776 181 1056 19 1072 41 18 #{UI.TextEdit} 50 20 nil 6752 50 2 8 1140916224 262145 7824 nil 752 nil 5 nil nil nil 7824 nil nil 3538 nil nil 1 #focusLost nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 291 73 210 335 41 7824 818 #setMarginWidths: 50 1 8 #(3 3) 7824 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 36 0 0 0 56 1 0 0 56 0 0 0] 8 #() 960 nil 45 978 1024 291 1040 -63 1056 73 1072 41 18 #{UI.PushButton} 50 20 nil 6752 50 2 8 1140924416 1 8112 nil 752 nil 5 nil nil nil 8112 nil nil 1154 #choosePackage 8 '…' 1 1 nil nil false nil nil nil 770 50 3 818 #createAt:extent: 50 2 210 645 73 210 41 41 8112 818 #isEnabled: 8 #(false) 8112 818 #text: 50 1 8 '…' 8112 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 66 1 0 0 36 0 0 0 86 1 0 0 56 0 0 0] 8 #() 960 nil 29 978 1440 -39 1040 -3 7200 1 1072 41 18 #{UI.StaticText} 50 16 nil 6752 50 2 8 1140850946 1 8448 nil nil nil 5 nil nil nil 8448 nil nil 3538 nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 85 79 210 181 41 8448 818 #text: 50 1 8 'Default &Package:' 8448 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 42 0 0 0 39 0 0 0 132 0 0 0 59 0 0 0] 8 #() 960 nil 27 978 1024 85 3776 181 1056 79 1072 41 18 #{UI.CheckBox} 50 16 nil 6752 50 2 8 1140927747 1 8736 7282 nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 517 nil nil nil 8736 nil nil 3538 nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 67 133 210 201 41 8736 818 #text: 50 1 8 'Typelib &variable:' 8736 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 33 0 0 0 66 0 0 0 133 0 0 0 86 0 0 0] 8 #() 960 nil 27 978 1024 67 3776 201 1056 133 1072 41 18 #{UI.StaticText} 50 16 nil 6752 50 2 8 1140916480 262145 9072 nil nil nil 5 nil nil nil 9072 nil nil 3538 nil nil nil 770 50 1 818 #createAt:extent: 50 2 210 291 133 210 335 41 9072 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 66 0 0 0 56 1 0 0 86 0 0 0] 8 #() 960 nil 27 978 1024 291 1040 -63 1056 133 1072 41 18 #{UI.TextEdit} 50 20 nil 6752 50 2 8 1140916224 262145 9312 nil 752 nil 5 nil nil nil 9312 nil nil 3538 nil nil 1 #focusLost nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 291 191 210 335 41 9312 818 #setMarginWidths: 50 1 8 #(3 3) 9312 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 95 0 0 0 56 1 0 0 115 0 0 0] 8 #() 960 nil 45 978 1024 291 3776 335 1056 191 1072 41 18 #{UI.StaticText} 50 16 nil 6752 50 2 8 1140850946 1 9600 nil nil nil 5 nil nil nil 9600 nil nil 3538 nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 85 197 210 181 41 9600 818 #text: 50 1 8 'C&onstants Pool:
' 9600 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 42 0 0 0 98 0 0 0 132 0 0 0 118 0 0 0] 8 #() 960 nil 27 978 1024 85 3776 181 1056 197 1072 41 18 #{UI.GroupBox} 50 14 nil 6752 50 2 8 1140850695 65 9888 nil nil nil 5 nil nil nil 9888 nil nil 770 50 2 818 #createAt:extent: 50 2 210 5 257 210 671 441 9888 818 #text: 50 1 8 'Ad&vanced' 9888 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 128 0 0 0 81 1 0 0 92 1 0 0] 8 #() 960 nil 27 978 1024 5 1040 -13 1056 257 1072 441 18 #{UI.ComboBox} 50 17 nil 6752 50 2 8 1144063491 1025 10160 2194 370 0 nil 2256 752 nil 5 nil nil nil 10160 nil nil 2512 2880 151 770 50 1 818 #createAt:extent: 50 2 210 445 297 210 185 47 10160 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 222 0 0 0 148 0 0 0 58 1 0 0 171 0 0 0] 8 #() 960 nil 27 978 1024 445 1040 -59 1056 297 1072 47 18 #{UI.StaticText} 50 16 nil 6752 50 2 8 1140850944 65 10416 nil nil nil 5 nil nil nil 10416 nil nil 3538 nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 65 307 210 281 41 10416 818 #text: 50 1 8 '&Class Comments:' 10416 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 0 0 0 153 0 0 0 172 0 0 0 173 0 0 0] 8 #() 960 nil 27 978 1024 65 3776 281 1056 307 1072 41 18 #{UI.ComboBox} 50 17 nil 6752 50 2 8 1144063491 1025 10704 2194 370 0 nil 2256 752 nil 5 nil nil nil 10704 nil nil 2512 2880 101 770 50 1 818 #createAt:extent: 50 2 210 445 357 210 185 47 10704 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 222 0 0 0 178 0 0 0 58 1 0 0 201 0 0 0] 8 #() 960 nil 27 978 1024 445 1040 -59 1056 357 1072 47 18 #{UI.StaticText} 50 16 nil 6752 50 2 8 1140850944 1 10960 nil nil nil 5 nil nil nil 10960 nil nil 3538 nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 65 367 210 371 41 10960 818 #text: 50 1 8 '&High-level wrapper methods:' 10960 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 0 0 0 183 0 0 0 217 0 0 0 203 0 0 0] 8 #() 960 nil 27 978 1024 65 3776 371 1056 367 1072 41 18 #{UI.GroupBox} 50 14 nil 6752 50 2 8 1140850695 65 11248 nil nil nil 5 nil nil nil 11248 nil nil 770 50 2 818 #createAt:extent: 50 2 210 35 419 210 631 111 11248 818 #text: 50 1 8 '&Tracing:' 11248 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 209 0 0 0 76 1 0 0 8 1 0 0] 8 #() 960 nil 27 978 1024 35 3776 631 1056 419 1072 111 18 #{UI.ComboBox} 50 17 nil 6752 50 2 8 1144063491 1025 11520 2194 370 0 nil 2256 752 nil 5 nil nil nil 11520 nil nil 2512 2880 401 770 50 1 818 #createAt:extent: 50 2 210 55 459 210 185 47 11520 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 229 0 0 0 119 0 0 0 252 0 0 0] 8 #() 960 nil 27 978 1024 55 1040 -449 1056 459 1072 47 18 #{UI.CheckBox} 50 16 nil 6752 50 2 8 1140928291 1 11776 7282 nil nil 8832 false nil nil 5 nil nil nil 11776 nil nil 3538 nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 415 459 210 211 41 11776 818 #text: 50 1 8 'Verbose?' 11776 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 207 0 0 0 229 0 0 0 56 1 0 0 249 0 0 0] 8 #() 960 nil 27 978 1024 415 3776 211 1056 459 1072 41 18 #{UI.CheckBox} 50 16 nil 6752 50 2 8 1140924451 1 12080 7282 nil nil 8832 false nil nil 5 nil nil nil 12080 nil nil 3538 nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 61 541 210 411 61 12080 818 #text: 50 1 8 'Define Method &Protocols:' 12080 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 14 1 0 0 235 0 0 0 44 1 0 0] 8 #() 960 nil 27 978 1024 61 3776 411 1056 541 1072 61 18 #{UI.CheckBox} 50 16 nil 6752 50 2 8 1140924451 1 12384 7282 nil nil 8832 false nil nil 5 nil nil nil 12384 nil nil 3538 nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 61 591 210 411 51 12384 818 #text: 50 1 8 'Generate #&defineFunctions:' 12384 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 39 1 0 0 235 0 0 0 64 1 0 0] 8 #() 960 nil 27 978 1024 61 3776 411 1056 591 1072 51 18 #{UI.CheckBox} 50 16 nil 6752 50 2 8 1140924451 1 12688 7282 nil nil 8832 false nil nil 5 nil nil nil 12688 nil nil 3538 nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 61 631 210 411 61 12688 818 #text: 50 1 8 '&Lowercase secondary keywords' 12688 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 59 1 0 0 235 0 0 0 89 1 0 0] 8 #() 960 nil 27 978 1024 61 3776 411 1056 631 1072 61 626 1792 50 24 10160 8 'commentGeneration' 9312 8 'constantsPoolName' 12384 8 'defineFunctions' 12080 8 'defineProtocols' 8736 8 'generateTypelib' 10704 8 'highLevelWrappers' 12688 8 'lowercaseKeywords' 7216 8 'namespace' 7824 8 'packageName' 11520 8 'tracing' 9072 8 'typelibVariableName' 11776 8 'verboseTrace' nil 770 50 2 818 #createAt:extent: 50 2 210 1 1 210 689 723 6752 818 #text: 50 1 8 'Generation Parameters' 6752 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 50 21 7520 7216 6864 8448 7824 8112 10416 10160 10960 10704 11248 11520 11776 12384 12080 12688 9888 9072 8736 9600 9312 960 nil 27 1794 0 nil 770 50 2 818 #createAt:extent: 50 2 210 1 1 210 689 803 5152 818 #text: 50 1 8 'Step 2' 5152 898 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 50 2 6752 5232 960 nil 27 402 8 '3' 18 #{UI.ContainerView} 50 15 nil 272 50 2 8 1140850688 131073 13648 nil nil nil 5 nil nil nil 13648 242 1 1 nil 18 #{UI.ContainerView} 50 15 nil 13648 50 2 8 1140850688 131073 13728 nil nil nil 5 nil nil nil 13728 594 626 #{Core.LookupTable} 50 8 18 #{UI.StaticRectangle} 50 14 nil 13728 50 2 8 1140916487 262145 13840 nil 752 nil 5 nil nil nil 13840 nil nil 770 50 1 818 #createAt:extent: 50 2 210 1 1 210 689 5 13840 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 960 nil 27 978 1024 1 1040 1 1056 1 1072 5 18 #{UI.PushButton} 50 20 nil 13728 50 2 8 1140924416 1 14064 nil 752 nil 5 nil nil nil 14064 nil nil 1154 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 245 31 210 141 51 14064 818 #text: 50 1 8 '< &Back' 14064 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 960 nil 29 978 1440 -139 1040 -303 1056 31 1072 51 18 #{UI.PushButton} 50 20 nil 13728 50 2 8 1140924416 1 14368 nil 752 nil 5 nil nil nil 14368 nil nil 1154 #finish 8 '&Finish' 1 1 nil nil false nil nil nil 770 50 3 818 #createAt:extent: 50 2 210 385 31 210 141 51 14368 818 #isEnabled: 8 #(false) 14368 818 #text: 50 1 8 '&Finish' 14368 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 960 nil 29 978 1440 -139 1040 -163 1056 31 1072 51 18 #{UI.PushButton} 50 20 nil 13728 50 2 8 1140924416 1 14704 nil 752 nil 5 nil nil nil 14704 nil nil 1154 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 770 50 3 818 #createAt:extent: 50 2 210 539 31 210 151 51 14704 818 #isEnabled: 8 #(false) 14704 818 #text: 50 1 8 'Cancel' 14704 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 960 nil 29 978 1440 -149 1040 1 1056 31 1072 51 1794 0 nil 770 50 2 818 #createAt:extent: 50 2 210 1 723 210 689 81 13728 818 #text: 50 1 8 'Buttons' 13728 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 50 4 14064 14368 14704 13840 960 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 13648 50 2 8 1140850688 131073 15248 nil nil nil 5 nil nil nil 15248 594 626 #{Core.LookupTable} 50 6 18 #{UI.ListView} 50 45 nil 15248 50 2 8 1140920393 1025 15360 2194 370 0 nil 2256 752 nil 5 2274 nil true 50 9 2322 1 1154 #selectAll 8 'Select &All' 1 1 nil nil nil 2322 1 1154 #selectInstalled 8 'Select &Installed' 1 1 nil nil nil 2322 1 1154 #selectUninstalled 8 'Select &Uninstalled' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 2322 1 1154 #browseTypeClass 8 'Browse &Class' 1 1 nil nil nil 2322 1 1154 #browseTypesIDL 8 '&Browse IDL' 1 1 nil nil nil 2322 1 1154 #inspectType 8 'I&nspect' 1 1 nil nil nil 15634 4097 2322 1 1154 #toggleStandardTypes 8 'Show &Standard Types' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 15360 nil nil 2512 2498 #iconImageIndex 2528 2560 nil 2498 #helpstring 8 #() nil 210 65 65 nil nil 370 3 2594 8 'Name' 437 #left 2512 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] #name 16016 7 513 nil nil nil 15360 15888 3 nil nil 2594 8 '' 41 #left nil 16002 0 nil 16034 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 16144 7 513 nil 16002 0 nil 16034 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:each | each isInstalled]' 8 #[30 105 17 158 106] #isInstalled 16224 7 257 nil nil 15360 16002 0 nil 16034 4 1 16000 8 'doIt' 8 '[:each | (each ?? Graphics.NullIcon) iconImageIndex]' 8 #[32 105 17 45 177 160 106] 1094 2 #{Kernel.VariableBinding} #NullIcon #{Graphics.NullIcon} #{Graphics} 1 #?? #iconImageIndex 16304 7 257 nil 1 nil nil 2594 8 'Type' 201 #left 2512 2498 #<= 8 #() 16002 0 nil 16034 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:each | each idlKeyword]' 8 #[30 105 17 158 106] #idlKeyword 16480 7 257 nil nil 15360 nil 1 nil nil #report 2880 nil 133157 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 770 50 3 818 #createAt:extent: 50 2 210 1 1 210 685 617 15360 818 #text: 50 1 8 'Name' 15360 818 #columnOrder: 50 1 8 #(2 1 3) 15360 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 52 1 0 0] 8 #() 960 nil 35 978 1024 1 1040 -3 1056 1 3104 -105 18 #{UI.PushButton} 50 20 nil 15248 50 2 8 1140924416 1 16816 nil 752 nil 5 nil nil nil 16816 nil nil 1154 #generate 8 '&Generate' 1 1 nil nil true nil nil nil 770 50 3 818 #createAt:extent: 50 2 210 535 647 210 141 51 16816 818 #isEnabled: 8 #(false) 16816 818 #text: 50 1 8 '&Generate' 16816 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 67 1 0 0 81 1 0 0 92 1 0 0] 8 #() 960 nil 29 978 1440 -139 1040 -13 3456 -49 3104 -25 18 #{UI.CheckBox} 50 16 nil 15248 50 2 8 1409363203 1 17152 7282 nil nil 8832 false nil nil 517 nil nil nil 17152 nil nil 3538 nil nil nil 770 50 2 818 #createAt:extent: 50 2 210 11 651 210 227 43 17152 818 #text: 50 1 8 'Include &Hidden?' 17152 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 69 1 0 0 118 0 0 0 90 1 0 0] 8 #() 960 nil 27 978 1024 11 3776 227 3456 -41 3104 -29 626 1792 50 4 17152 8 'includeHidden' 15360 8 'types' nil 770 50 1 818 #createAt:extent: 50 2 210 1 1 210 689 723 15248 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 50 3 15360 16816 17152 960 nil 27 626 1792 50 2 15248 8 'Classes' nil 770 50 2 818 #createAt:extent: 50 2 210 1 1 210 689 803 13648 818 #text: 50 1 8 'Step 3' 13648 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 50 2 15248 13728 960 nil 27 13648 nil nil nil 1794 0 nil 770 50 1 818 #createAt:extent: 50 2 210 21 21 210 689 803 272 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 155 1 0 0] 50 3 448 5152 13648 960 nil 27 626 1792 50 2 272 8 'cards' 518 #{Graphics.Rectangle} 210 21 21 210 21 21 nil nil nil nil 1 nil nil nil 210 681 901 1 nil nil 770 50 2 818 #createAt:extent: 50 2 210 6143 21 210 761 921 32 818 #text: 50 1 8 'COM Component Wizard' 32 898 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 214 1 0 0] 50 1 272 960 nil 27)!

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

