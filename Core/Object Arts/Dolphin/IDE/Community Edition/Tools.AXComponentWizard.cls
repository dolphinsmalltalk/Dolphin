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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 7 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.WizardCardContainer} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 7 nil nil nil 272 1350 1 #{UI.CardLayout} 550 #{Core.OrderedCollection} 3 518 #{Core.Association} 8 '1' 18 #{UI.ContainerView} 50 15 nil 272 50 2 8 1140850688 131073 448 nil nil nil 7 nil nil nil 448 242 1 1 nil 18 #{UI.ContainerView} 50 15 nil 448 50 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 3 18 #{UI.PushButton} 50 20 nil 528 50 2 8 1140924416 1 656 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 656 nil 8 1853182784 1350 4 #{UI.CommandDescription} #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 3 774 #{Core.MessageSend} #createAt:extent: 50 2 210 545 31 210 141 51 656 866 #isEnabled: 8 #(false) 656 866 #text: 50 1 8 'Cancel' 656 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 15 0 0 0 86 1 0 0 40 0 0 0] 8 #() 210 193 193 nil 29 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedViewRight -139 1138 #fixedParentRight -3 1138 #fixedParentTop 31 1138 #fixedViewTop 51 18 #{UI.PushButton} 50 20 nil 528 50 2 8 1140924416 1 1216 nil 736 nil 7 nil nil nil 1216 nil 8 1853182784 770 #libraryListNextCard 8 '&Next >' 1 1 nil nil false nil nil nil 818 50 3 866 #createAt:extent: 50 2 210 385 31 210 141 51 1216 866 #isEnabled: 8 #(false) 1216 866 #text: 50 1 8 '&Next >' 1216 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1088 nil 29 1106 1152 -139 1168 -163 1184 31 1200 51 18 #{UI.StaticRectangle} 50 14 nil 528 50 2 8 1140916487 262145 1568 nil 736 nil 7 nil nil nil 1568 nil 8 1853387904 818 50 1 866 #createAt:extent: 50 2 210 1 1 210 689 5 1568 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1088 nil 27 1106 1138 #fixedParentLeft 1 1168 1 1184 1 1200 5 550 #{Core.IdentityDictionary} 0 nil 818 50 2 866 #createAt:extent: 50 2 210 1 723 210 689 81 528 866 #text: 50 1 8 'Buttons' 528 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 50 3 1216 656 1568 1088 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 448 50 2 8 1140850688 131073 2048 nil nil nil 7 nil nil nil 2048 594 626 6 18 #{UI.ListView} 50 45 nil 2048 50 2 8 1140953165 1025 2144 838 2 #{UI.ListModel} 370 0 nil 6 #{Kernel.IdentitySearchPolicy} 736 nil 7 2886 4 #{UI.Menu} nil true 50 3 1094 2 #{UI.CommandMenuItem} 1 770 #browseIDL 8 '&Browse IDL' 1 1 nil nil nil 2338 1 770 #inspectLibrary 8 '&Inspect' 1 1 nil nil nil 2338 1 770 #typeLibHelp 8 '&Help' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2144 nil 8 1853243664 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 370 3 3142 5 #{UI.ListViewColumn} 8 'Library' 251 #left 2544 2530 #<= 8 #() 2530 #name 8 #() nil 2144 nil 1 nil nil 2626 8 'Version' 101 #left 2530 #versionString 8 #() 2530 #<= 8 #() nil nil 2144 nil 1 nil nil 2626 8 'Description' 327 #left 2544 2530 #<= 8 #() 2530 #helpstring 2784 nil 2144 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 818 50 2 866 #createAt:extent: 50 2 210 1 1 210 685 487 2144 866 #text: 50 1 8 'Library' 2144 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 8 #() 1088 nil 35 1106 1808 1 1168 -3 1184 1 1138 #fixedParentBottom -235 18 #{UI.PushButton} 50 20 nil 2048 50 2 8 1140924416 1 3152 nil 736 nil 7 nil nil nil 3152 nil 8 1853182784 770 #loadTypeLib 8 'Bro&wse…' 1 1 nil nil false nil nil nil 818 50 3 866 #createAt:extent: 50 2 210 535 507 210 141 51 3152 866 #isEnabled: 8 #(false) 3152 866 #text: 50 1 8 'Bro&wse…' 3152 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 8 #() 1088 nil 29 1106 1152 -139 1168 -13 1138 #fixedViewBottom -49 3136 -165 18 #{UI.StaticText} 50 16 nil 2048 50 2 8 1140850946 1 3520 nil nil nil 7 nil nil nil 3520 nil 8 1853387904 518 #{UI.NullConverter} nil nil nil 818 50 2 866 #createAt:extent: 50 2 210 1 657 210 111 41 3520 866 #text: 50 1 8 '&GUID:' 3520 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 8 #() 1088 nil 27 1106 1808 1 1138 #fixedViewLeft 111 3504 -39 3136 -25 18 #{UI.StaticText} 50 16 nil 2048 50 2 8 1140850946 1 3856 nil nil nil 7 nil nil nil 3856 nil 8 1853387904 3602 nil nil nil 818 50 2 866 #createAt:extent: 50 2 210 1 577 210 111 51 3856 866 #text: 50 1 8 '&Location:' 3856 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 8 #() 1088 nil 27 1106 1808 1 3840 111 3504 -49 3136 -95 18 #{UI.StaticText} 50 16 nil 2048 50 2 8 1140850944 1 4160 nil nil nil 7 nil nil nil 4160 nil 8 1853387904 3602 nil nil nil 818 50 2 866 #createAt:extent: 50 2 210 131 657 210 539 41 4160 866 #text: 50 1 8 'GUID of selected library here…' 4160 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 72 1 0 0 78 1 0 0 92 1 0 0] 8 #() 1088 nil 27 1106 1808 131 1168 -19 3504 -39 3136 -25 18 #{UI.StaticText} 50 16 nil 2048 50 2 8 1140850944 1 4464 nil nil nil 7 nil nil nil 4464 nil 8 1853387904 3602 nil nil nil 818 50 2 866 #createAt:extent: 50 2 210 131 577 210 539 61 4464 866 #text: 50 1 8 'Path of selected library here…
on two lines if necessary.' 4464 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 32 1 0 0 78 1 0 0 62 1 0 0] 8 #() 1088 nil 27 1106 1808 131 1168 -19 3504 -59 3136 -85 1826 3 2144 8 'typeLibs' 4160 8 'guid' 4464 8 'libraryPath' nil 818 50 1 866 #createAt:extent: 50 2 210 1 1 210 689 723 2048 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 50 6 2144 3152 3856 4464 3520 4160 1088 nil 27 1826 1 2048 8 'Libraries' nil 818 50 2 866 #createAt:extent: 50 2 210 1 1 210 689 803 448 866 #text: 50 1 8 'Step 1' 448 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 50 2 2048 528 1088 nil 27 402 8 '2' 18 #{UI.ContainerView} 50 15 nil 272 50 2 8 1140850688 131073 5232 nil nil nil 5 nil nil nil 5232 242 1 1 nil 18 #{UI.ContainerView} 50 15 nil 5232 50 2 8 1140850688 131073 5312 nil nil nil 5 nil nil nil 5312 594 626 4 18 #{UI.PushButton} 50 20 nil 5312 50 2 8 1140924416 1 5408 nil 736 nil 5 nil nil nil 5408 nil 8 1853182784 770 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 818 50 3 866 #createAt:extent: 50 2 210 549 31 210 141 51 5408 866 #isEnabled: 8 #(false) 5408 866 #text: 50 1 8 'Cancel' 5408 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 1088 nil 29 1106 1152 -139 1168 1 1184 31 1200 51 18 #{UI.PushButton} 50 20 nil 5312 50 2 8 1140924416 1 5760 nil 736 nil 5 nil nil nil 5760 nil 8 1853182784 770 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 818 50 3 866 #createAt:extent: 50 2 210 245 31 210 141 51 5760 866 #isEnabled: 8 #(false) 5760 866 #text: 50 1 8 '< &Back' 5760 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 1088 nil 29 1106 1152 -139 1168 -303 1184 31 1200 51 18 #{UI.PushButton} 50 20 nil 5312 50 2 8 1140924416 1 6112 nil 736 nil 5 nil nil nil 6112 nil 8 1853182784 770 #parametersNextCard 8 '&Next >' 1 1 nil nil false nil nil nil 818 50 3 866 #createAt:extent: 50 2 210 385 31 210 141 51 6112 866 #isEnabled: 8 #(false) 6112 866 #text: 50 1 8 '&Next >' 6112 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1088 nil 29 1106 1152 -139 1168 -163 1184 31 1200 51 18 #{UI.StaticRectangle} 50 14 nil 5312 50 2 8 1140916487 262145 6464 nil 736 nil 5 nil nil nil 6464 nil 8 1853387904 818 50 1 866 #createAt:extent: 50 2 210 1 1 210 689 5 6464 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1088 nil 27 1106 1808 1 1168 1 1184 1 1200 5 1826 0 nil 818 50 2 866 #createAt:extent: 50 2 210 1 723 210 689 81 5312 866 #text: 50 1 8 'Buttons' 5312 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 50 4 5760 6112 5408 6464 1088 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 5232 50 2 8 1140850688 131073 6912 nil nil nil 5 nil nil nil 6912 594 626 21 18 #{UI.CheckBox} 50 16 nil 6912 50 2 8 1140927747 1 7008 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 517 nil nil nil 7008 nil 8 1853182784 3602 nil nil nil 818 50 2 866 #createAt:extent: 50 2 210 67 133 210 201 41 7008 866 #text: 50 1 8 'Typelib &variable:' 7008 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 33 0 0 0 66 0 0 0 133 0 0 0 86 0 0 0] 8 #() 1088 nil 27 1106 1808 67 3840 201 1184 133 1200 41 18 #{UI.CheckBox} 50 16 nil 6912 50 2 8 1140924451 1 7376 7074 nil nil 7120 false nil nil 5 nil nil nil 7376 nil 8 1853182784 3602 nil nil nil 818 50 2 866 #createAt:extent: 50 2 210 61 541 210 411 61 7376 866 #text: 50 1 8 'Define Method &Protocols:' 7376 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 14 1 0 0 235 0 0 0 44 1 0 0] 8 #() 1088 nil 27 1106 1808 61 3840 411 1184 541 1200 61 18 #{UI.CheckBox} 50 16 nil 6912 50 2 8 1140924451 1 7696 7074 nil nil 7120 false nil nil 5 nil nil nil 7696 nil 8 1853182784 3602 nil nil nil 818 50 2 866 #createAt:extent: 50 2 210 61 591 210 411 51 7696 866 #text: 50 1 8 'Generate #&defineFunctions:' 7696 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 39 1 0 0 235 0 0 0 64 1 0 0] 8 #() 1088 nil 27 1106 1808 61 3840 411 1184 591 1200 51 18 #{UI.CheckBox} 50 16 nil 6912 50 2 8 1140928291 1 8016 7074 nil nil 7120 false nil nil 5 nil nil nil 8016 nil 8 1853182784 3602 nil nil nil 818 50 2 866 #createAt:extent: 50 2 210 415 459 210 211 41 8016 866 #text: 50 1 8 'Verbose?' 8016 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 207 0 0 0 229 0 0 0 56 1 0 0 249 0 0 0] 8 #() 1088 nil 27 1106 1808 415 3840 211 1184 459 1200 41 18 #{UI.CheckBox} 50 16 nil 6912 50 2 8 1140924451 1 8336 7074 nil nil 7120 false nil nil 5 nil nil nil 8336 nil 8 1853182784 3602 nil nil nil 818 50 2 866 #createAt:extent: 50 2 210 61 631 210 411 61 8336 866 #text: 50 1 8 '&Lowercase secondary keywords' 8336 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 59 1 0 0 235 0 0 0 89 1 0 0] 8 #() 1088 nil 27 1106 1808 61 3840 411 1184 631 1200 61 18 #{UI.ComboBox} 50 17 nil 6912 50 2 8 1144063491 1025 8656 2210 370 0 nil 2272 736 nil 5 nil nil nil 8656 nil 8 1852792128 2544 2912 151 818 50 1 866 #createAt:extent: 50 2 210 445 297 210 185 47 8656 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 222 0 0 0 148 0 0 0 58 1 0 0 171 0 0 0] 8 #() 1088 nil 27 1106 1808 445 1168 -59 1184 297 1200 47 18 #{UI.ComboBox} 50 17 nil 6912 50 2 8 1144063491 1025 8928 2210 370 0 nil 2272 736 nil 5 nil nil nil 8928 nil 8 1852792128 2544 2912 401 818 50 1 866 #createAt:extent: 50 2 210 55 459 210 185 47 8928 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 229 0 0 0 119 0 0 0 252 0 0 0] 8 #() 1088 nil 27 1106 1808 55 1168 -449 1184 459 1200 47 18 #{UI.ComboBox} 50 17 nil 6912 50 2 8 1144063491 1025 9200 2210 370 0 nil 2272 736 nil 5 nil nil nil 9200 nil 8 1852792128 2544 2912 101 818 50 1 866 #createAt:extent: 50 2 210 445 357 210 185 47 9200 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 222 0 0 0 178 0 0 0 58 1 0 0 201 0 0 0] 8 #() 1088 nil 27 1106 1808 445 1168 -59 1184 357 1200 47 18 #{UI.GroupBox} 50 14 nil 6912 50 2 8 1140850695 65 9472 nil nil nil 5 nil nil nil 9472 nil 8 1853182784 818 50 2 866 #createAt:extent: 50 2 210 35 419 210 631 111 9472 866 #text: 50 1 8 '&Tracing:' 9472 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 209 0 0 0 76 1 0 0 8 1 0 0] 8 #() 1088 nil 27 1106 1808 35 3840 631 1184 419 1200 111 18 #{UI.GroupBox} 50 14 nil 6912 50 2 8 1140850695 65 9760 nil nil nil 5 nil nil nil 9760 nil 8 1853182784 818 50 2 866 #createAt:extent: 50 2 210 5 257 210 671 441 9760 866 #text: 50 1 8 'Ad&vanced' 9760 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 128 0 0 0 81 1 0 0 92 1 0 0] 8 #() 1088 nil 27 1106 1808 5 1168 -13 1184 257 1200 441 18 #{UI.PushButton} 50 20 nil 6912 50 2 8 1140924416 1 10048 nil 736 nil 5 nil nil nil 10048 nil 8 1853182784 770 #choosePackage 8 '…' 1 1 nil nil false nil nil nil 818 50 3 866 #createAt:extent: 50 2 210 645 73 210 41 41 10048 866 #isEnabled: 8 #(false) 10048 866 #text: 50 1 8 '…' 10048 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 66 1 0 0 36 0 0 0 86 1 0 0 56 0 0 0] 8 #() 1088 nil 29 1106 1152 -39 1168 -3 1138 #fixedPreviousTop 1 1200 41 18 #{UI.PushButton} 50 20 nil 6912 50 2 8 1140924416 1 10416 nil 736 nil 5 nil nil nil 10416 nil 8 1853182784 770 #chooseNamespace 8 '…' 1 1 nil nil false nil nil nil 818 50 3 866 #createAt:extent: 50 2 210 645 11 210 41 41 10416 866 #isEnabled: 8 #(false) 10416 866 #text: 50 1 8 '…' 10416 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 66 1 0 0 5 0 0 0 86 1 0 0 25 0 0 0] 8 #() 1088 nil 29 1106 1152 -39 1168 -3 10400 -1 1200 41 18 #{UI.StaticText} 50 16 nil 6912 50 2 8 1140916482 1 10768 7074 nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 5 nil nil nil 10768 nil 8 1853387904 3602 nil nil nil 818 50 2 866 #createAt:extent: 50 2 210 85 19 210 181 41 10768 866 #text: 50 1 8 '&Namespace:' 10768 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 42 0 0 0 9 0 0 0 132 0 0 0 29 0 0 0] 8 #() 1088 nil 27 1106 1808 85 3840 181 1184 19 1200 41 18 #{UI.StaticText} 50 16 nil 6912 50 2 8 1140850946 1 11120 nil nil nil 5 nil nil nil 11120 nil 8 1853387904 3602 nil nil nil 818 50 2 866 #createAt:extent: 50 2 210 85 79 210 181 41 11120 866 #text: 50 1 8 'Default &Package:' 11120 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 42 0 0 0 39 0 0 0 132 0 0 0 59 0 0 0] 8 #() 1088 nil 27 1106 1808 85 3840 181 1184 79 1200 41 18 #{UI.StaticText} 50 16 nil 6912 50 2 8 1140850944 1 11424 nil nil nil 5 nil nil nil 11424 nil 8 1853387904 3602 nil nil nil 818 50 2 866 #createAt:extent: 50 2 210 65 367 210 371 41 11424 866 #text: 50 1 8 '&High-level wrapper methods:' 11424 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 0 0 0 183 0 0 0 217 0 0 0 203 0 0 0] 8 #() 1088 nil 27 1106 1808 65 3840 371 1184 367 1200 41 18 #{UI.StaticText} 50 16 nil 6912 50 2 8 1140850946 1 11728 nil nil nil 5 nil nil nil 11728 nil 8 1853387904 3602 nil nil nil 818 50 2 866 #createAt:extent: 50 2 210 85 197 210 181 41 11728 866 #text: 50 1 8 'C&onstants Pool:
' 11728 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 42 0 0 0 98 0 0 0 132 0 0 0 118 0 0 0] 8 #() 1088 nil 27 1106 1808 85 3840 181 1184 197 1200 41 18 #{UI.StaticText} 50 16 nil 6912 50 2 8 1140916480 262145 12032 nil nil nil 5 nil nil nil 12032 nil 8 1853387904 3602 nil nil nil 818 50 1 866 #createAt:extent: 50 2 210 291 133 210 335 41 12032 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 66 0 0 0 56 1 0 0 86 0 0 0] 8 #() 1088 nil 27 1106 1808 291 1168 -63 1184 133 1200 41 18 #{UI.StaticText} 50 16 nil 6912 50 2 8 1140916480 262145 12288 7074 nil false 10864 nil 736 nil 5 nil nil nil 12288 nil 8 1853387904 3602 nil nil nil 818 50 1 866 #createAt:extent: 50 2 210 291 13 210 335 41 12288 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 6 0 0 0 56 1 0 0 26 0 0 0] 8 #() 1088 nil 27 1106 1808 291 1168 -63 1184 13 1200 41 18 #{UI.StaticText} 50 16 nil 6912 50 2 8 1140850944 65 12560 nil nil nil 5 nil nil nil 12560 nil 8 1853387904 3602 nil nil nil 818 50 2 866 #createAt:extent: 50 2 210 65 307 210 281 41 12560 866 #text: 50 1 8 '&Class Comments:' 12560 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 0 0 0 153 0 0 0 172 0 0 0 173 0 0 0] 8 #() 1088 nil 27 1106 1808 65 3840 281 1184 307 1200 41 18 #{UI.TextEdit} 50 20 nil 6912 50 2 8 1140916224 262145 12864 nil 736 nil 5 nil nil nil 12864 nil 8 1853175488 3602 nil nil 1 #focusLost nil nil nil 818 50 2 866 #createAt:extent: 50 2 210 291 73 210 335 41 12864 866 #setMarginWidths: 50 1 8 #(3 3) 12864 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 36 0 0 0 56 1 0 0 56 0 0 0] 8 #() 1088 nil 45 1106 1808 291 1168 -63 1184 73 1200 41 18 #{UI.TextEdit} 50 20 nil 6912 50 2 8 1140916224 262145 13168 nil 736 nil 5 nil nil nil 13168 nil 8 1853175488 3602 nil nil 1 #focusLost nil nil nil 818 50 2 866 #createAt:extent: 50 2 210 291 191 210 335 41 13168 866 #setMarginWidths: 50 1 8 #(3 3) 13168 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 95 0 0 0 56 1 0 0 115 0 0 0] 8 #() 1088 nil 45 1106 1808 291 3840 335 1184 191 1200 41 1826 12 7008 8 'generateTypelib' 7376 8 'defineProtocols' 7696 8 'defineFunctions' 8016 8 'verboseTrace' 8336 8 'lowercaseKeywords' 8656 8 'commentGeneration' 8928 8 'tracing' 9200 8 'highLevelWrappers' 12032 8 'typelibVariableName' 12288 8 'namespace' 12864 8 'packageName' 13168 8 'constantsPoolName' nil 818 50 2 866 #createAt:extent: 50 2 210 1 1 210 689 723 6912 866 #text: 50 1 8 'Generation Parameters' 6912 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 50 21 10768 12288 10416 11120 12864 10048 12560 8656 11424 9200 9472 8928 8016 7696 7376 8336 9760 12032 7008 11728 13168 1088 nil 27 1826 0 nil 818 50 2 866 #createAt:extent: 50 2 210 1 1 210 689 803 5232 866 #text: 50 1 8 'Step 2' 5232 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 50 2 6912 5312 1088 nil 27 402 8 '3' 18 #{UI.ContainerView} 50 15 nil 272 50 2 8 1140850688 131073 14112 nil nil nil 5 nil nil nil 14112 242 1 1 nil 18 #{UI.ContainerView} 50 15 nil 14112 50 2 8 1140850688 131073 14192 nil nil nil 5 nil nil nil 14192 594 626 4 18 #{UI.PushButton} 50 20 nil 14192 50 2 8 1140924416 1 14288 nil 736 nil 5 nil nil nil 14288 nil 8 1853182784 770 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 818 50 3 866 #createAt:extent: 50 2 210 245 31 210 141 51 14288 866 #isEnabled: 8 #(false) 14288 866 #text: 50 1 8 '< &Back' 14288 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 1088 nil 29 1106 1152 -139 1168 -303 1184 31 1200 51 18 #{UI.PushButton} 50 20 nil 14192 50 2 8 1140924416 1 14640 nil 736 nil 5 nil nil nil 14640 nil 8 1853182784 770 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 818 50 3 866 #createAt:extent: 50 2 210 539 31 210 151 51 14640 866 #isEnabled: 8 #(false) 14640 866 #text: 50 1 8 'Cancel' 14640 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 1088 nil 29 1106 1152 -149 1168 1 1184 31 1200 51 18 #{UI.PushButton} 50 20 nil 14192 50 2 8 1140924416 1 14992 nil 736 nil 5 nil nil nil 14992 nil 8 1853182784 770 #finish 8 '&Finish' 1 1 nil nil false nil nil nil 818 50 3 866 #createAt:extent: 50 2 210 385 31 210 141 51 14992 866 #isEnabled: 8 #(false) 14992 866 #text: 50 1 8 '&Finish' 14992 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1088 nil 29 1106 1152 -139 1168 -163 1184 31 1200 51 18 #{UI.StaticRectangle} 50 14 nil 14192 50 2 8 1140916487 262145 15344 nil 736 nil 5 nil nil nil 15344 nil 8 1853387904 818 50 1 866 #createAt:extent: 50 2 210 1 1 210 689 5 15344 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1088 nil 27 1106 1808 1 1168 1 1184 1 1200 5 1826 0 nil 818 50 2 866 #createAt:extent: 50 2 210 1 723 210 689 81 14192 866 #text: 50 1 8 'Buttons' 14192 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 50 4 14288 14992 14640 15344 1088 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 14112 50 2 8 1140850688 131073 15792 nil nil nil 5 nil nil nil 15792 594 626 2 18 #{UI.ListView} 50 45 nil 15792 50 2 8 1140920393 1025 15888 2210 370 0 nil 2272 736 nil 5 2290 nil true 50 9 2338 1 770 #selectAll 8 'Select &All' 1 1 nil nil nil 2338 1 770 #selectInstalled 8 'Select &Installed' 1 1 nil nil nil 2338 1 770 #selectUninstalled 8 'Select &Uninstalled' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 2338 1 770 #browseTypeClass 8 'Browse &Class' 1 1 nil nil nil 2338 1 770 #browseTypesIDL 8 '&Browse IDL' 1 1 nil nil nil 2338 1 770 #inspectType 8 'I&nspect' 1 1 nil nil nil 16162 4097 2338 1 770 #toggleStandardTypes 8 'Show &Standard Types' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 15888 nil 8 1853243664 2544 2530 #iconImageIndex 2560 2592 nil 2530 #helpstring 8 #() nil 210 65 65 nil nil 370 3 2626 8 'Name' 437 #left 2544 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] #name 16560 7 513 nil nil nil 15888 16432 3 nil nil 2626 8 '' 41 #left nil 16546 0 nil 16578 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 16688 7 513 nil 16546 0 nil 16578 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:each | each isInstalled]' 8 #[30 105 17 158 106] #isInstalled 16768 7 257 nil nil 15888 16546 0 nil 16578 4 1 16544 8 'doIt' 8 '[:each | (each ?? Graphics.NullIcon) iconImageIndex]' 8 #[32 105 17 45 177 160 106] 1094 2 #{Kernel.VariableBinding} #NullIcon #{Graphics.NullIcon} #{Graphics} 1 #?? #iconImageIndex 16848 7 257 nil 1 nil nil 2626 8 'Type' 201 #left 2544 2530 #<= 8 #() 16546 0 nil 16578 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:each | each idlKeyword]' 8 #[30 105 17 158 106] #idlKeyword 17024 7 257 nil nil 15888 nil 1 nil nil #report 2912 nil 133157 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 818 50 3 866 #createAt:extent: 50 2 210 1 1 210 685 617 15888 866 #text: 50 1 8 'Name' 15888 866 #columnOrder: 50 1 8 #(2 1 3) 15888 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 52 1 0 0] 8 #() 1088 nil 35 1106 1808 1 1168 -3 1184 1 3136 -105 18 #{UI.PushButton} 50 20 nil 15792 50 2 8 1140924416 1 17360 nil 736 nil 5 nil nil nil 17360 nil 8 1853182784 770 #generate 8 '&Generate' 1 1 nil nil true nil nil nil 818 50 3 866 #createAt:extent: 50 2 210 535 647 210 141 51 17360 866 #isEnabled: 8 #(false) 17360 866 #text: 50 1 8 '&Generate' 17360 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 67 1 0 0 81 1 0 0 92 1 0 0] 8 #() 1088 nil 29 1106 1152 -139 1168 -13 3504 -49 3136 -25 1826 1 15888 8 'types' nil 818 50 1 866 #createAt:extent: 50 2 210 1 1 210 689 723 15792 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 50 2 15888 17360 1088 nil 27 1826 1 15792 8 'Classes' nil 818 50 2 866 #createAt:extent: 50 2 210 1 1 210 689 803 14112 866 #text: 50 1 8 'Step 3' 14112 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 50 2 15792 14192 1088 nil 27 448 nil nil nil 1826 0 nil 818 50 1 866 #createAt:extent: 50 2 210 21 21 210 689 803 272 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 155 1 0 0] 50 3 448 5232 14112 1088 nil 27 1826 1 272 8 'cards' 518 #{Graphics.Rectangle} 210 21 21 210 21 21 nil nil nil nil 14327 nil nil nil 210 681 901 1 nil nil 818 50 2 866 #createAt:extent: 50 2 210 6143 21 210 761 921 32 866 #text: 50 1 8 'COM Component Wizard' 32 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 214 1 0 0] 50 1 272 1088 nil 27)!

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

