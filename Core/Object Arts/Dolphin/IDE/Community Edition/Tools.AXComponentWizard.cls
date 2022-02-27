"Filed out from Dolphin Smalltalk"!

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
	SmalltalkSystem current workspaceShellClass show
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
	SmalltalkSystem current workspaceShellClass show streamIn: stm!

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
		caption: 'Select Namespace…')
		allowNil: true;
		nilButtonCaption: '&Default';
		showModal!

choosePackage
	"Sets the package name from a choice of all the available packages"

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
browseIDL!commands!public! !
browseTypeClass!commands!public! !
browseTypesIDL!commands!public! !
cancel!commands!public! !
chooseNamespace!commands!private! !
choosePackage!commands!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
displayInstalledTypeLib:!private!updating! !
finish!commands!public! !
generatableEnumsInTlb:!private!updating! !
generatableInterfacesInTlb:!helpers!private! !
generatableStructsInTlb:!helpers!private! !
generate!commands!public! !
initialize!initializing!private! !
inspectIt!commands!public! !
inspectItCommand!public! !
inspectLibrary!commands!public! !
inspectType!public! !
libraryListNextCard!commands!public! !
loadTypeLib!commands!public! !
onTypeLibrarySelected!event handling!private! !
onViewOpened!event handling!public! !
parametersNextCard!commands!public! !
queryCommand:!commands!private! !
refresh!commands!public! !
selectInstalled!commands!public! !
selectUninstalled!commands!public! !
standardInterfaces!private! !
toggleStandardTypes!commands!private! !
typeLib!accessing!public! !
typeLib:!accessing!public! !
typeLibHelp!commands!public! !
updateTypelibVariable!private!updating! !
updateTypesList:!private!updating! !
!

!Tools.AXComponentWizard class methodsFor!

defaultAdditionalAccelerators
	^super defaultAdditionalAccelerators 
		, #(#(#selectAll 'Ctrl+A') #(#inspectIt 'Ctrl+I'))!

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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 39 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil nil nil nil 410 #{UI.WizardCardContainer} 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 853318 1 #{UI.CardLayout} 138 144 34 3 1049094 #{Core.Association} 8 '1' 410 #{UI.ContainerView} 34 15 nil 640 34 2 8 1140850688 131073 816 nil nil nil 7 nil nil nil 816 610 1 1 nil 410 #{UI.ContainerView} 34 15 nil 816 34 2 8 1140850688 131073 896 nil nil nil 7 nil nil nil 896 1048838 #{UI.FramingLayout} 170 176 34 6 410 #{UI.StaticRectangle} 34 14 nil 896 34 2 8 1140916487 262145 1024 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 1024 nil 8 1815137184 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 1 1 578 689 5 1024 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 578 193 193 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedParentLeft 1 1378 #fixedParentRight 1 1378 #fixedParentTop 1 1378 #fixedViewTop 5 410 #{UI.PushButton} 34 20 nil 896 34 2 8 1140924416 1 1456 nil 1104 nil 7 nil nil nil 1456 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #libraryListNextCard 8 '&Next >' 1 1 nil nil false nil nil nil 1138 34 3 1186 #createAt:extent: 34 2 578 385 31 578 141 51 1456 1186 #isEnabled: 8 #(false) 1456 1186 #text: 34 1 8 '&Next >' 1456 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1328 nil 29 1346 1378 #fixedViewRight -139 1408 -163 1424 31 1440 51 410 #{UI.PushButton} 34 20 nil 896 34 2 8 1140924416 1 1840 nil 1104 nil 7 nil nil nil 1840 nil 8 1815097472 1538 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1138 34 3 1186 #createAt:extent: 34 2 578 545 31 578 141 51 1840 1186 #isEnabled: 8 #(false) 1840 1186 #text: 34 1 8 'Cancel' 1840 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 15 0 0 0 86 1 0 0 40 0 0 0] 8 #() 1328 nil 29 1346 1824 -139 1408 -3 1424 31 1440 51 170 192 8 #() nil 1138 34 2 1186 #createAt:extent: 34 2 578 1 723 578 689 81 896 1186 #text: 34 1 8 'Buttons' 896 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 3 1456 1840 1024 1328 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 816 34 2 8 1140850688 131073 2416 nil nil nil 7 nil nil nil 2416 962 170 176 34 12 410 #{UI.StaticText} 34 16 nil 2416 34 2 8 1140850944 1 2528 nil nil nil 7 nil nil nil 2528 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 1138 34 2 1186 #createAt:extent: 34 2 578 131 577 578 539 61 2528 1186 #text: 34 1 8 'Path of selected library here…
on two lines if necessary.' 2528 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 32 1 0 0 78 1 0 0 62 1 0 0] 8 #() 1328 nil 27 1346 1392 131 1408 -19 1378 #fixedViewBottom -59 1378 #fixedParentBottom -85 410 #{UI.StaticText} 34 16 nil 2416 34 2 8 1140850944 1 2880 nil nil nil 7 nil nil nil 2880 nil 8 1815137184 2610 nil nil nil 1138 34 2 1186 #createAt:extent: 34 2 578 131 657 578 539 41 2880 1186 #text: 34 1 8 'GUID of selected library here…' 2880 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 72 1 0 0 78 1 0 0 92 1 0 0] 8 #() 1328 nil 27 1346 1392 131 1408 -19 2848 -39 2864 -25 410 #{UI.ListView} 34 45 nil 2416 34 2 8 1140953165 1025 3184 787270 2 #{UI.ListModel} 138 144 2208 nil 1769478 #{Kernel.IdentitySearchPolicy} 1104 nil 7 461638 4 #{UI.Menu} nil true 34 3 1180742 2 #{UI.CommandMenuItem} 1 1538 #browseIDL 8 '&Browse IDL' 1 1 nil nil nil 3378 1 1538 #inspectLibrary 8 '&Inspect' 1 1 nil nil nil 3378 1 1538 #typeLibHelp 8 '&Help' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3184 nil 8 1815049392 786950 #{Core.Message} #displayString 2208 nil 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 3 1117254 5 #{UI.ListViewColumn} 8 'Library' 251 #left 3584 3570 #<= 8 #() 3570 #name 8 #() nil 3184 nil 1 nil nil 3666 8 'Version' 101 #left 3570 #versionString 8 #() 3570 #<= 8 #() nil nil 3184 nil 1 nil nil 3666 8 'Description' 327 #left 3584 3570 #<= 8 #() 3570 #helpstring 3824 nil 3184 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1138 34 3 1186 #createAt:extent: 34 2 578 1 1 578 685 487 3184 1186 #contextMenu: 34 1 3344 3184 1186 #text: 34 1 8 'Library' 3184 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 8 #() 1328 nil 35 1346 1392 1 1408 -3 1424 1 2864 -235 410 #{UI.PushButton} 34 20 nil 2416 34 2 8 1140924416 1 4208 nil 1104 nil 7 nil nil nil 4208 nil 8 1815097472 1538 #loadTypeLib 8 'Bro&wse…' 1 1 nil nil false nil nil nil 1138 34 3 1186 #createAt:extent: 34 2 578 535 507 578 141 51 4208 1186 #isEnabled: 8 #(false) 4208 1186 #text: 34 1 8 'Bro&wse…' 4208 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 8 #() 1328 nil 29 1346 1824 -139 1408 -13 2848 -49 2864 -165 410 #{UI.StaticText} 34 16 nil 2416 34 2 8 1140850946 1 4560 nil nil nil 7 nil nil nil 4560 nil 8 1815137184 2610 nil nil nil 1138 34 2 1186 #createAt:extent: 34 2 578 1 577 578 111 51 4560 1186 #text: 34 1 8 '&Location:' 4560 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 8 #() 1328 nil 27 1346 1392 1 1378 #fixedViewLeft 111 2848 -49 2864 -95 410 #{UI.StaticText} 34 16 nil 2416 34 2 8 1140850946 1 4880 nil nil nil 7 nil nil nil 4880 nil 8 1815137184 2610 nil nil nil 1138 34 2 1186 #createAt:extent: 34 2 578 1 657 578 111 41 4880 1186 #text: 34 1 8 '&GUID:' 4880 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 8 #() 1328 nil 27 1346 1392 1 4864 111 2848 -39 2864 -25 170 192 34 6 2528 8 'libraryPath' 2880 8 'guid' 3184 8 'typeLibs' nil 1138 34 1 1186 #createAt:extent: 34 2 578 1 1 578 689 723 2416 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 6 3184 4208 4560 2528 4880 2880 1328 nil 27 170 192 34 2 2416 8 'Libraries' nil 1138 34 2 1186 #createAt:extent: 34 2 578 1 1 578 689 803 816 1186 #text: 34 1 8 'Step 1' 816 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 2416 896 1328 nil 27 770 8 '2' 410 #{UI.ContainerView} 34 15 nil 640 34 2 8 1140850688 131073 5680 nil nil nil 5 nil nil nil 5680 610 1 1 nil 410 #{UI.ContainerView} 34 15 nil 5680 34 2 8 1140850688 131073 5760 nil nil nil 5 nil nil nil 5760 962 170 176 34 8 410 #{UI.PushButton} 34 20 nil 5760 34 2 8 1140924416 1 5872 nil 1104 nil 5 nil nil nil 5872 nil 8 1815097472 1538 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1138 34 3 1186 #createAt:extent: 34 2 578 549 31 578 141 51 5872 1186 #isEnabled: 8 #(false) 5872 1186 #text: 34 1 8 'Cancel' 5872 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 1328 nil 29 1346 1824 -139 1408 1 1424 31 1440 51 410 #{UI.StaticRectangle} 34 14 nil 5760 34 2 8 1140916487 262145 6224 nil 1104 nil 5 nil nil nil 6224 nil 8 1815137184 1138 34 1 1186 #createAt:extent: 34 2 578 1 1 578 689 5 6224 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1328 nil 27 1346 1392 1 1408 1 1424 1 1440 5 410 #{UI.PushButton} 34 20 nil 5760 34 2 8 1140924416 1 6464 nil 1104 nil 5 nil nil nil 6464 nil 8 1815097472 1538 #parametersNextCard 8 '&Next >' 1 1 nil nil false nil nil nil 1138 34 3 1186 #createAt:extent: 34 2 578 385 31 578 141 51 6464 1186 #isEnabled: 8 #(false) 6464 1186 #text: 34 1 8 '&Next >' 6464 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1328 nil 29 1346 1824 -139 1408 -163 1424 31 1440 51 410 #{UI.PushButton} 34 20 nil 5760 34 2 8 1140924416 1 6816 nil 1104 nil 5 nil nil nil 6816 nil 8 1815097472 1538 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 1138 34 3 1186 #createAt:extent: 34 2 578 245 31 578 141 51 6816 1186 #isEnabled: 8 #(false) 6816 1186 #text: 34 1 8 '< &Back' 6816 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 1328 nil 29 1346 1824 -139 1408 -303 1424 31 1440 51 170 192 2208 nil 1138 34 2 1186 #createAt:extent: 34 2 578 1 723 578 689 81 5760 1186 #text: 34 1 8 'Buttons' 5760 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 4 6816 6464 5872 6224 1328 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 5680 34 2 8 1140850688 131073 7376 nil nil nil 5 nil nil nil 7376 962 170 176 34 42 410 #{UI.StaticText} 34 16 nil 7376 34 2 8 1140850946 1 7488 nil nil nil 5 nil nil nil 7488 nil 8 1815137184 2610 nil nil nil 1138 34 2 1186 #createAt:extent: 34 2 578 85 197 578 181 41 7488 1186 #text: 34 1 8 'C&onstants Pool:
' 7488 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 42 0 0 0 98 0 0 0 132 0 0 0 118 0 0 0] 8 #() 1328 nil 27 1346 1392 85 4864 181 1424 197 1440 41 410 #{UI.GroupBox} 34 14 nil 7376 34 2 8 1140850695 65 7792 nil nil nil 5 nil nil nil 7792 nil 8 1815097472 1138 34 2 1186 #createAt:extent: 34 2 578 5 257 578 671 441 7792 1186 #text: 34 1 8 'Ad&vanced' 7792 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 128 0 0 0 81 1 0 0 92 1 0 0] 8 #() 1328 nil 27 1346 1392 5 1408 -13 1424 257 1440 441 410 #{UI.StaticText} 34 16 nil 7376 34 2 8 1140850944 65 8080 nil nil nil 5 nil nil nil 8080 nil 8 1815137184 2610 nil nil nil 1138 34 2 1186 #createAt:extent: 34 2 578 65 307 578 281 41 8080 1186 #text: 34 1 8 '&Class Comments:' 8080 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 0 0 0 153 0 0 0 172 0 0 0 173 0 0 0] 8 #() 1328 nil 27 1346 1392 65 4864 281 1424 307 1440 41 410 #{UI.GroupBox} 34 14 nil 7376 34 2 8 1140850695 65 8384 nil nil nil 5 nil nil nil 8384 nil 8 1815097472 1138 34 2 1186 #createAt:extent: 34 2 578 35 419 578 631 111 8384 1186 #text: 34 1 8 '&Tracing:' 8384 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 209 0 0 0 76 1 0 0 8 1 0 0] 8 #() 1328 nil 27 1346 1392 35 4864 631 1424 419 1440 111 410 #{UI.CheckBox} 34 16 nil 7376 34 2 8 1140924451 1 8672 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 8672 nil 8 1815097472 2610 nil nil nil 1138 34 2 1186 #createAt:extent: 34 2 578 61 631 578 411 61 8672 1186 #text: 34 1 8 '&Lowercase secondary keywords' 8672 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 59 1 0 0 235 0 0 0 89 1 0 0] 8 #() 1328 nil 27 1346 1392 61 4864 411 1424 631 1440 61 410 #{UI.ComboBox} 34 17 nil 7376 34 2 8 1144063491 1025 9040 3250 138 144 2208 nil 3312 1104 nil 5 nil nil nil 9040 nil 8 1814646992 3584 3952 151 1138 34 1 1186 #createAt:extent: 34 2 578 445 297 578 185 47 9040 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 222 0 0 0 148 0 0 0 58 1 0 0 171 0 0 0] 8 #() 1328 nil 27 1346 1392 445 1408 -59 1424 297 1440 47 410 #{UI.StaticText} 34 16 nil 7376 34 2 8 1140850946 1 9312 nil nil nil 5 nil nil nil 9312 nil 8 1815137184 2610 nil nil nil 1138 34 2 1186 #createAt:extent: 34 2 578 85 79 578 181 41 9312 1186 #text: 34 1 8 'Default &Package:' 9312 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 42 0 0 0 39 0 0 0 132 0 0 0 59 0 0 0] 8 #() 1328 nil 27 1346 1392 85 4864 181 1424 79 1440 41 410 #{UI.ComboBox} 34 17 nil 7376 34 2 8 1144063491 1025 9616 3250 138 144 2208 nil 3312 1104 nil 5 nil nil nil 9616 nil 8 1814646992 3584 3952 101 1138 34 1 1186 #createAt:extent: 34 2 578 445 357 578 185 47 9616 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 222 0 0 0 178 0 0 0 58 1 0 0 201 0 0 0] 8 #() 1328 nil 27 1346 1392 445 1408 -59 1424 357 1440 47 410 #{UI.CheckBox} 34 16 nil 7376 34 2 8 1140924451 1 9888 8738 nil nil 8784 false nil nil 5 nil nil nil 9888 nil 8 1815097472 2610 nil nil nil 1138 34 2 1186 #createAt:extent: 34 2 578 61 591 578 411 51 9888 1186 #text: 34 1 8 'Generate #&defineFunctions:' 9888 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 39 1 0 0 235 0 0 0 64 1 0 0] 8 #() 1328 nil 27 1346 1392 61 4864 411 1424 591 1440 51 410 #{UI.TextEdit} 34 16 nil 7376 34 2 8 1140916224 262145 10208 nil 1104 nil 5 nil nil nil 10208 nil 8 1815092992 2610 nil nil 1 1138 34 2 1186 #createAt:extent: 34 2 578 291 73 578 335 41 10208 1186 #setMarginWidths: 34 1 8 #(3 3) 10208 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 36 0 0 0 56 1 0 0 56 0 0 0] 8 #() 1328 nil 27 1346 1392 291 1408 -63 1424 73 1440 41 410 #{UI.StaticText} 34 16 nil 7376 34 2 8 1140916480 262145 10512 nil nil nil 5 nil nil nil 10512 nil 8 1815137184 2610 nil nil nil 1138 34 1 1186 #createAt:extent: 34 2 578 291 133 578 335 41 10512 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 66 0 0 0 56 1 0 0 86 0 0 0] 8 #() 1328 nil 27 1346 1392 291 1408 -63 1424 133 1440 41 410 #{UI.PushButton} 34 20 nil 7376 34 2 8 1140924416 1 10768 nil 1104 nil 5 nil nil nil 10768 nil 8 1815097472 1538 #choosePackage 8 '…' 1 1 nil nil false nil nil nil 1138 34 3 1186 #createAt:extent: 34 2 578 645 73 578 41 41 10768 1186 #isEnabled: 8 #(false) 10768 1186 #text: 34 1 8 '…' 10768 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 66 1 0 0 36 0 0 0 86 1 0 0 56 0 0 0] 8 #() 1328 nil 29 1346 1824 -39 1408 -3 1378 #fixedPreviousTop 1 1440 41 410 #{UI.StaticText} 34 16 nil 7376 34 2 8 1140850944 1 11136 nil nil nil 5 nil nil nil 11136 nil 8 1815137184 2610 nil nil nil 1138 34 2 1186 #createAt:extent: 34 2 578 65 367 578 371 41 11136 1186 #text: 34 1 8 '&High-level wrapper methods:' 11136 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 0 0 0 183 0 0 0 217 0 0 0 203 0 0 0] 8 #() 1328 nil 27 1346 1392 65 4864 371 1424 367 1440 41 410 #{UI.ComboBox} 34 17 nil 7376 34 2 8 1144063491 1025 11440 3250 138 144 2208 nil 3312 1104 nil 5 nil nil nil 11440 nil 8 1814646992 3584 3952 401 1138 34 1 1186 #createAt:extent: 34 2 578 55 459 578 185 47 11440 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 229 0 0 0 119 0 0 0 252 0 0 0] 8 #() 1328 nil 27 1346 1392 55 1408 -449 1424 459 1440 47 410 #{UI.CheckBox} 34 16 nil 7376 34 2 8 1140924451 1 11712 8738 nil nil 8784 false nil nil 5 nil nil nil 11712 nil 8 1815097472 2610 nil nil nil 1138 34 2 1186 #createAt:extent: 34 2 578 61 541 578 411 61 11712 1186 #text: 34 1 8 'Define Method &Protocols:' 11712 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 14 1 0 0 235 0 0 0 44 1 0 0] 8 #() 1328 nil 27 1346 1392 61 4864 411 1424 541 1440 61 410 #{UI.StaticText} 34 16 nil 7376 34 2 8 1140916480 262145 12032 8738 nil false 1769478 #{Kernel.EqualitySearchPolicy} nil 1104 nil 5 nil nil nil 12032 nil 8 1815137184 2610 nil nil nil 1138 34 1 1186 #createAt:extent: 34 2 578 291 13 578 335 41 12032 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 6 0 0 0 56 1 0 0 26 0 0 0] 8 #() 1328 nil 27 1346 1392 291 1408 -63 1424 13 1440 41 410 #{UI.CheckBox} 34 16 nil 7376 34 2 8 1140928291 1 12336 8738 nil nil 8784 false nil nil 5 nil nil nil 12336 nil 8 1815097472 2610 nil nil nil 1138 34 2 1186 #createAt:extent: 34 2 578 415 459 578 211 41 12336 1186 #text: 34 1 8 'Verbose?' 12336 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 207 0 0 0 229 0 0 0 56 1 0 0 249 0 0 0] 8 #() 1328 nil 27 1346 1392 415 4864 211 1424 459 1440 41 410 #{UI.CheckBox} 34 16 nil 7376 34 2 8 1140927747 1 12656 8738 nil nil 8784 false nil nil 517 nil nil nil 12656 nil 8 1815097472 2610 nil nil nil 1138 34 2 1186 #createAt:extent: 34 2 578 67 133 578 201 41 12656 1186 #text: 34 1 8 'Typelib &variable:' 12656 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 33 0 0 0 66 0 0 0 133 0 0 0 86 0 0 0] 8 #() 1328 nil 27 1346 1392 67 4864 201 1424 133 1440 41 410 #{UI.TextEdit} 34 16 nil 7376 34 2 8 1140916224 262145 12976 nil 1104 nil 5 nil nil nil 12976 nil 8 1815092992 2610 nil nil 1 1138 34 2 1186 #createAt:extent: 34 2 578 291 191 578 335 41 12976 1186 #setMarginWidths: 34 1 8 #(3 3) 12976 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 95 0 0 0 56 1 0 0 115 0 0 0] 8 #() 1328 nil 27 1346 1392 291 4864 335 1424 191 1440 41 410 #{UI.StaticText} 34 16 nil 7376 34 2 8 1140916482 1 13280 8738 nil false 12128 nil nil nil 5 nil nil nil 13280 nil 8 1815137184 2610 nil nil nil 1138 34 2 1186 #createAt:extent: 34 2 578 85 19 578 181 41 13280 1186 #text: 34 1 8 '&Namespace:' 13280 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 42 0 0 0 9 0 0 0 132 0 0 0 29 0 0 0] 8 #() 1328 nil 27 1346 1392 85 4864 181 1424 19 1440 41 410 #{UI.PushButton} 34 20 nil 7376 34 2 8 1140924416 1 13600 nil 1104 nil 5 nil nil nil 13600 nil 8 1815097472 1538 #chooseNamespace 8 '…' 1 1 nil nil false nil nil nil 1138 34 3 1186 #createAt:extent: 34 2 578 645 11 578 41 41 13600 1186 #isEnabled: 8 #(false) 13600 1186 #text: 34 1 8 '…' 13600 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 66 1 0 0 5 0 0 0 86 1 0 0 25 0 0 0] 8 #() 1328 nil 29 1346 1824 -39 1408 -3 11120 -1 1440 41 170 192 34 24 9888 8 'defineFunctions' 12976 8 'constantsPoolName' 12032 8 'namespace' 9616 8 'highLevelWrappers' 11440 8 'tracing' 9040 8 'commentGeneration' 10512 8 'typelibVariableName' 8672 8 'lowercaseKeywords' 10208 8 'packageName' 12656 8 'generateTypelib' 12336 8 'verboseTrace' 11712 8 'defineProtocols' nil 1138 34 2 1186 #createAt:extent: 34 2 578 1 1 578 689 723 7376 1186 #text: 34 1 8 'Generation Parameters' 7376 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 21 13280 12032 13600 9312 10208 10768 8080 9040 11136 9616 8384 11440 12336 9888 11712 8672 7792 10512 12656 7488 12976 1328 nil 27 170 192 2208 nil 1138 34 2 1186 #createAt:extent: 34 2 578 1 1 578 689 803 5680 1186 #text: 34 1 8 'Step 2' 5680 1266 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 7376 5760 1328 nil 27 770 8 '3' 410 #{UI.ContainerView} 34 15 nil 640 34 2 8 1140850688 131073 14608 nil nil nil 5 nil nil nil 14608 610 1 1 nil 410 #{UI.ContainerView} 34 15 nil 14608 34 2 8 1140850688 131073 14688 nil nil nil 5 nil nil nil 14688 962 170 176 34 8 410 #{UI.StaticRectangle} 34 14 nil 14688 34 2 8 1140916487 262145 14800 nil 1104 nil 5 nil nil nil 14800 nil 8 1815137184 1138 34 1 1186 #createAt:extent: 34 2 578 1 1 578 689 5 14800 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 2 0 0 0] 8 #() 1328 nil 27 1346 1392 1 1408 1 1424 1 1440 5 410 #{UI.PushButton} 34 20 nil 14688 34 2 8 1140924416 1 15040 nil 1104 nil 5 nil nil nil 15040 nil 8 1815097472 1538 #finish 8 '&Finish' 1 1 nil nil false nil nil nil 1138 34 3 1186 #createAt:extent: 34 2 578 385 31 578 141 51 15040 1186 #isEnabled: 8 #(false) 15040 1186 #text: 34 1 8 '&Finish' 15040 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 15 0 0 0 6 1 0 0 40 0 0 0] 8 #() 1328 nil 29 1346 1824 -139 1408 -163 1424 31 1440 51 410 #{UI.PushButton} 34 20 nil 14688 34 2 8 1140924416 1 15392 nil 1104 nil 5 nil nil nil 15392 nil 8 1815097472 1538 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 1138 34 3 1186 #createAt:extent: 34 2 578 245 31 578 141 51 15392 1186 #isEnabled: 8 #(false) 15392 1186 #text: 34 1 8 '< &Back' 15392 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 15 0 0 0 192 0 0 0 40 0 0 0] 8 #() 1328 nil 29 1346 1824 -139 1408 -303 1424 31 1440 51 410 #{UI.PushButton} 34 20 nil 14688 34 2 8 1140924416 1 15744 nil 1104 nil 5 nil nil nil 15744 nil 8 1815097472 1538 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1138 34 3 1186 #createAt:extent: 34 2 578 539 31 578 151 51 15744 1186 #isEnabled: 8 #(false) 15744 1186 #text: 34 1 8 'Cancel' 15744 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 1 0 0 15 0 0 0 88 1 0 0 40 0 0 0] 8 #() 1328 nil 29 1346 1824 -149 1408 1 1424 31 1440 51 170 192 2208 nil 1138 34 2 1186 #createAt:extent: 34 2 578 1 723 578 689 81 14688 1186 #text: 34 1 8 'Buttons' 14688 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 88 1 0 0 145 1 0 0] 34 4 15392 15040 15744 14800 1328 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 14608 34 2 8 1140850688 131073 16304 nil nil nil 5 nil nil nil 16304 962 170 176 34 4 410 #{UI.ListView} 34 45 nil 16304 34 2 8 1140920393 1025 16416 3250 138 144 2208 nil 3312 1104 nil 5 3330 nil true 34 8 3378 1 1538 #selectAll 8 'Select &All' 1 1 nil nil nil 3378 1 1538 #selectInstalled 8 'Select &Installed' 1 1 nil nil nil 3378 1 1538 #selectUninstalled 8 'Select &Uninstalled' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 3378 1 1538 #browseTypeClass 8 'Browse &Class' 1 1 nil nil nil 3378 1 1538 #browseTypesIDL 8 '&Browse IDL' 1 1 nil nil nil 16690 4097 3378 1 1538 #toggleStandardTypes 8 'Show &Standard Types' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 16416 nil 8 1815049392 3584 3570 #iconImageIndex 2208 3616 nil 3570 #helpstring 8 #() nil 578 65 65 nil nil 138 144 34 3 3666 8 'Name' 437 #left 3584 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] #name 17056 7 513 nil nil nil 16416 16912 3 nil nil 3666 8 '' 41 #left nil 17042 0 nil 17074 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 17184 7 513 nil 17042 0 nil 17074 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:each | each isInstalled]' 8 #[30 105 17 158 106] #isInstalled 17264 7 257 nil nil 16416 17042 0 nil 17074 4 1 17040 8 'doIt' 8 '[:each | (each ?? Graphics.NullIcon) iconImageIndex]' 8 #[32 105 17 45 177 160 106] 1442886 2 #{Kernel.VariableBinding} #NullIcon #{Graphics.NullIcon} #{Graphics} 1 #?? #iconImageIndex 17344 7 257 nil 1 nil nil 3666 8 'Type' 201 #left 3584 3570 #<= 8 #() 17042 0 nil 17074 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:each | each idlKeyword]' 8 #[30 105 17 158 106] #idlKeyword 17520 7 257 nil nil 16416 nil 1 nil nil #report 3952 nil 133157 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1138 34 4 1186 #createAt:extent: 34 2 578 1 1 578 685 617 16416 1186 #contextMenu: 34 1 16512 16416 1186 #text: 34 1 8 'Name' 16416 1186 #columnOrder: 34 1 8 #(2 1 3) 16416 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 52 1 0 0] 8 #() 1328 nil 35 1346 1392 1 1408 -3 1424 1 2864 -105 410 #{UI.PushButton} 34 20 nil 16304 34 2 8 1140924416 1 17888 nil 1104 nil 5 nil nil nil 17888 nil 8 1815097472 1538 #generate 8 '&Generate' 1 1 nil nil true nil nil nil 1138 34 3 1186 #createAt:extent: 34 2 578 535 647 578 141 51 17888 1186 #isEnabled: 8 #(false) 17888 1186 #text: 34 1 8 '&Generate' 17888 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 67 1 0 0 81 1 0 0 92 1 0 0] 8 #() 1328 nil 29 1346 1824 -139 1408 -13 2848 -49 2864 -25 170 192 34 2 16416 8 'types' nil 1138 34 1 1186 #createAt:extent: 34 2 578 1 1 578 689 723 16304 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 105 1 0 0] 34 2 16416 17888 1328 nil 27 170 192 34 2 16304 8 'Classes' nil 1138 34 2 1186 #createAt:extent: 34 2 578 1 1 578 689 803 14608 1186 #text: 34 1 8 'Step 3' 14608 1266 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 145 1 0 0] 34 2 16304 14688 1328 nil 27 816 nil nil nil 170 192 2208 nil 1138 34 1 1186 #createAt:extent: 34 2 578 21 21 578 689 803 640 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 155 1 0 0] 34 3 816 5680 14608 1328 nil 27 170 192 34 2 640 8 'cards' 1180166 #{Graphics.Rectangle} 578 21 21 578 21 21 nil nil nil nil 1 nil nil nil 578 681 901 1 nil nil 1138 34 2 1186 #createAt:extent: 34 2 578 12287 21 578 761 921 416 1186 #text: 34 1 8 'COM Component Wizard' 416 1266 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 123 25 0 0 214 1 0 0] 34 1 640 1328 nil 27)!

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

