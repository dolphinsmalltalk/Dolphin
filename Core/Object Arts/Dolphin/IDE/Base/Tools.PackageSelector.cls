"Filed out from Dolphin Smalltalk"!

UI.SelectableItemsPresenter
	subclass: #'Tools.PackageSelector'
	instanceVariableNames: 'filterPresenter packagesPresenter autoSelect'
	classVariableNames: ''
	imports: #(#{XProgramming.SUnit private} #{Refactory.Browser private})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.PackageSelector guid: (Core.GUID fromString: '{d41af949-f919-4f5f-986d-a50606ba68e9}')!
Tools.PackageSelector comment: 'A PackageSelector is used to choose a Package from the complete set of packages available in the development system. It presents two panes; a hierarchical display of the folders in which the packages reside and a list of available packages. The folder display can be used as a filter to refine which packages are displayed in the list. When a folder is selected, only packages in the hierarchy beneath it are visible.

Instance Variables:
	filterPresenter		<treePresenter> showing the folders in which packages reside
	packagesPresenter		<listPresenter> showing the packages filtered by the selected folder

'!
!Tools.PackageSelector categoriesForClass!MVP-Presenters!MVP-Resources-Misc! !
!Tools.PackageSelector methodsFor!

aboutPackage
	"Show an About box for the currently selected package"

	self selections first about!

addClass
	"Request an available class (or classes) to add to the receiver's current package from the
	user. Only classes which are not currently owned by any other package are shown in the
	choice prompter."

	| classes pacman package |
	pacman := self packageManager.
	classes := pacman unpackagedClasses asSortedCollection.
	classes isEmpty
		ifTrue: 
			[MessageBox notify: 'All Classes are currently owned by packages'.
			^self].
	package := self singlePackage.
	(ChoicePrompter
		on: classes
		multipleChoices: classes
		caption: 'Add Classes to package ''<1d>''…' << package)
			ifNotNil: [:chosen | chosen do: [:each | pacman addClass: each to: package]]!

addSharedVariable
    "Request an available shared variable to add the receiver's current package. Only variables which are not currently owned by any other package are shown."

	| variableNames package pacman |
	pacman := self packageManager.
	variableNames := pacman unpackagedVariables.
	variableNames isEmpty
		ifTrue: [MessageBox notify: 'All shared variables are currently owned by packages']
		ifFalse: 
			[| choices |
			package := self singlePackage.
			choices := ChoicePrompter multipleChoices: variableNames asSortedCollection
						caption: 'Add shared variable to ' , package name , ' package'.
			choices notNil
				ifTrue: [choices do: [:each | pacman addVariableNamed: each asQualifiedReference to: package]]]!

applicationEnvironment
	| closure |
	closure := IdentitySet new.
	self packages do: 
			[:each |
			(closure includes: each)
				ifFalse: 
					[closure add: each.
					closure addAll: each allPrerequisites]].
	^self systemModel browserEnvironment forPackages: closure!

autoSelect
	^autoSelect!

autoSelect: aBoolean
	autoSelect := aBoolean!

browseFolder
	| folder |
	folder := self selectedFolder.
	[self developmentSystem browseFolder: folder] on: OS.Win32Error
		do: 
			[:ex |
			MessageBox new
				headline: 'Unable to browse <1p>…' << folder;
				errorMsg: ex messageText]!

browseIt
	"Browse the selected item in the pane with focus."

	self perform: self browseItCommand!

browseItCommand
	"Private - Answer the command that the context-sensitive 'Browse-It' command would be linked
	to if sent to the receiver at this moment."

	filterPresenter hasFocus ifTrue: [^#browseFolder].
	^nil!

browsePackages
	self developmentSystem browsePackages: self packages!

browseUnimplemented
	"Open a method browser on all methods in the selected packages that themselves send a
	message which is not apparently implemented in any of those packages or their
	prerequisites."

	| sendingEnvironment implementingEnvironment unimplemented |
	sendingEnvironment := self selectionEnvironment.
	implementingEnvironment := self applicationEnvironment.
	unimplemented := implementingEnvironment unimplementedSelectors.
	self developmentSystem
		browseSelectors: unimplemented asSortedCollection
		caption: ('Unimplemented Selectors in <1p> (and prerequisites)' expandMacrosWith: sendingEnvironment)
		environment: implementingEnvironment!

canRefactor
	^self developmentSystem canRefactor and: [self hasPackages]!

checkCanUninstall: package
	"Private - Uninstallation of the <Package>, package, has been initiated. Verify that it can be uninstalled
	and if not inform the user accordingly and abort the operation."

	| err |
	[package okToUninstall] on: Error do: [:ex | err := ex].
	err notNil
		ifTrue: 
			[MessageBox new
				headline: 'Unable to uninstall the package <1p>' << package name;
				errorMsg: err description.
			^self operationAbortedSignal signalWith: package]!

commonFolder: aCollectionOfPackages
	| commonPrefix |
	aCollectionOfPackages isEmpty ifTrue: [^nil].
	commonPrefix := aCollectionOfPackages inject: nil
				into: 
					[:prefix :each |
					prefix
						ifNil: [File splitPathFrom: each packagePathname]
						ifNotNil: [File commonPrefixOf: prefix and: each packagePathname]].
	^commonPrefix isEmpty
		ifTrue: [self folderClass root]
		ifFalse: [self folderClass pathname: (File appendPathDelimiter: commonPrefix)]!

confirmUninstall: aPackage
	"Private - If the <Package> argument has any dependents, then prompt the user to confirm
	that they should also be uninstalled, if not then double check that the package should be
	uninstalled anyway. If this method returns then all dependent packages were successfully
	uninstalled, and uninstallation of the package may proceed."

	| deps details max mb response prompted |
	prompted := self promptToSavePackageChanges: aPackage.
	Cursor wait showWhile: [deps := aPackage allDependentPackages].
	mb := MessageBox new.
	mb
		headline: 'Uninstall package <1p>?' << aPackage name;
		beTaskModal;
		customButtons: #(#(#yes '&Uninstall') #(#no '&Don''t Uninstall')).
	deps isEmpty
		ifTrue: 
			[prompted ifTrue: [^true].
			response := mb
						confirmOrCancel: 'Do you really want to uninstall the package and remove all its owned objects from the system?'.
			^response == #cancel
				ifTrue: [self operationAbortedSignal signalWith: aPackage]
				ifFalse: [response == #yes]].
	details := String writeStream.
	details
		nextPutAll: 'The following packages depend on ';
		print: aPackage name;
		nextPut: $:;
		cr;
		cr.
	max := 30.
	(deps collect: [:e | e name]) asSortedCollection
		from: 1
		to: (deps size min: max)
		do: 
			[:each |
			details
				tab;
				nextPutAll: each;
				cr].
	deps size > max
		ifTrue: 
			[details
				tab;
				nextPutAll: '… and ';
				print: deps size - max;
				nextPutAll: ' other packages …';
				cr].
	mb detailsText: details contents.
	mb iconStyle: #warning.
	response := mb
				confirmOrCancel: '<1d> package<2?s:> depend on <3p> as a prerequisite, and will also be uninstalled should you choose to proceed.'
						<< {deps size. deps size > 1. aPackage name}.
	^response == #cancel
		ifTrue: [self operationAbortedSignal signalWith: aPackage]
		ifFalse: 
			[response == #yes and: 
					[deps do: [:e | self promptToSavePackageChanges: e].
					true]]!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	filterPresenter := self add: TreePresenter new name: 'filter'.
	packagesPresenter := self add: ListPresenter new name: 'packages'!

createSchematicWiring
	"Private - Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self filterPresenter
		when: #drop:
			send: #onDropOverFolder:
			to: self;
		when: #dragEnter:
			send: #onDragOverFolder:
			to: self;
		when: #dragOver:
			send: #onDragOverFolder:
			to: self;
		when: #selectionChanging:
			send: #onSelectionChanging:
			to: self;
		when: #selectionChanged
			send: #onFilterSelected
			to: self.
	self packagesPresenter
		when: #selectionChanged
			send: #onSelectionChanged
			to: self;
		when: #selectionChanging:
			send: #onSelectionChanging:
			to: self;
		when: #actionPerformed
			send: #onPackageChosen
			to: self;
		when: #drag:
			send: #onDragPackages:
			to: self;
		when: #drop:
			send: #onDropOverPackage:
			to: self;
		when: #dragEnter:
			send: #onDragOverPackage:
			to: self;
		when: #dragOver:
			send: #onDragOverPackage:
			to: self.
	Package manager
		when: #loadedChanged
			send: #onPackagesChanged
			to: self;
		when: #packageChanged:
			send: #onPackageChanged:
			to: self!

deleteItCommand
	"Private - Answer the command that the context-sensitive 'Browse-It' command would be linked
	to if sent to the receiver at this moment."

	filterPresenter hasFocus ifTrue: [^nil].
	packagesPresenter hasFocus ifTrue: [^#removePackage].
	^super deleteItCommand!

developmentSystem
	^SmalltalkSystem current!

filter
	"Answer the current value of the filter. This is nil if there is no directory node selected,
	and the empty string if the root ($) folder is selected."

	^self folder ifNotNil: [:folder | folder pathname]!

filteredPackages
	"Private - Answer a collection of the Packages that match the selection in the directory tree."

	| allPackages |
	"Because the pluggable collection used by the package manager is a bit slow for selects, we convert to an array first"
	allPackages := Package manager packages asArray.
	^self filter
		ifNil: [allPackages]
		ifNotNil: 
			[:filter |
			filter isEmpty
				ifTrue: [allPackages select: [:each | File isRelativePath: each packagePathname]]
				ifFalse: 
					[| searchPrefix |
					searchPrefix := File appendPathDelimiter: filter.
					allPackages select: [:each | each packagePathname beginsWith: searchPrefix ignoreCase: true]]]!

filterPresenter
	^filterPresenter!

folder
	^self filterPresenter selectionOrNil!

folderClass
	^PackageFolder!

hasChangedPackages
	"Private - Answer whether any changed packages are currently selected."

	^self packages anySatisfy: [:each | each isChanged].
!

hasPackages
	"Private - Answer whether one or more packages are currently selected."

	^self packages notEmpty!

hasSinglePackage
	"Private - Answer whether a single package is currently selected."

	^self singlePackage notNil!

initialize
	"Private - Initialize the receiver."

	super initialize.
	self autoSelect: true!

inspectIt
	"Open an inspector on the currently selected class."

	| packages |
	packages := self packages.
	(packages size = 1 ifTrue: [packages first] ifFalse: [packages]) inspect!

inspectPackage
	"Open an AccessorInspector on the currently selected package(s)."

	| caption pkgs |
	pkgs := ListModel on: self packages.
	caption := pkgs size = 1 ifTrue: [pkgs first name , ' package'] ifFalse: ['Multiple Packages'].
	(TwinLevelInspector shellOn: pkgs caption: 'Inspecting ' , caption) selectionOrNil: pkgs first!

isEnabled: aBoolean
 	filterPresenter view isEnabled: aBoolean.
 	packagesPresenter view isEnabled: aBoolean!

isSaveablePackage: aPackage
	"Private - Answer whether aPackage can be saved."

	^aPackage ~= self packageManager systemPackage or: [SmalltalkSystem current isOAD]!

model: aPackageHierarchyModel 
	super model: aPackageHierarchyModel.
	filterPresenter model: aPackageHierarchyModel!

newPackage
	"Request the name of a new Package to add to the PackageManager."

	| pathname dialog directory |
	directory := File fullPathOf: self filter relativeTo: SessionManager current imageBase.
	[File createDirectoryPath: directory] on: OS.Win32Error
		do: 
			[:ex |
			"User probably doesn't have access rights"
			].
	dialog := FileSaveDialog new
				initialDirectory: directory;
				fileTypes: {self developmentSystem pacFileDialogType};
				defaultExtension: Package packageExtension;
				caption: 'New Package'.
	pathname := dialog showModal.
	pathname notNil
		ifTrue: 
			[| packageName |
			packageName := File splitStemFrom: pathname.
			packageName notEmpty
				ifTrue: 
					[| packMan |
					packMan := self packageManager.
					
					[| package |
					package := packMan newPackage: pathname.
					self packages: {package}]
							on: packMan duplicatePackageSignal
							do: [:e | e okCancel]]]!

okToSavePackage: aPackage
	"Private - Verify that the <Package>, aPackage, is in a fit state to save (i.e. that it is reloadable),
	and answer whether it is>"

	| err mb |
	err := 
			[aPackage okToSaveOrDeploy.
			nil] on: Package unsaveableSignal do: [:ex | err := ex].
	err ifNil: [^true].
	mb := MessageBox new.
	mb
		iconStyle: #error;
		caption: 'Cannot save package ' , aPackage name printString;
		headline: err messageText;
		text: 'The package will NOT load if saved in this form so the package file has not been saved.';
		checkboxText: 'Browse packages prerequisites?';
		isChecked: true;
		open.
	mb isChecked ifTrue: [self developmentSystem showPrerequisitesForPackage: aPackage].
	^false!

onDragOverFolder: aDragDropSession
	| folder |
	aDragDropSession operation: nil.
	folder := aDragDropSession suggestedTarget.
	(folder notNil and: 
			[aDragDropSession dragObjects anySatisfy: 
					[:each |
					(each isFormatAvailable: #Package)
						and: [((each format: #Package) packageFolder sameAs: folder pathname) not]]])
		ifTrue: [aDragDropSession operation: #move]!

onDragOverPackage: aDragDropSession
	"Private - A drag session is passing over the receiver's package list pane.
	Update the <DragDropSession>, session, with the drop operation supported
	(if any)."

	aDragDropSession operation: nil.
	(aDragDropSession suggestedTarget notNil and: 
			[#(#CompiledMethod #Class #ResourceIdentifier #VariableName)
				anySatisfy: [:each | aDragDropSession isFormatAvailable: each]])
		ifTrue: [aDragDropSession operation: #move]!

onDragPackages: aDragDropSession
	| objects stream filer |
	objects := OrderedCollection new.
	stream := String writeStream.
	filer := ChunkSourceFiler on: stream.
	self packages do: 
			[:each |
			each fileOutOn: filer.
			objects add: ((aDragDropSession newDragObject: each)
						format: #Package data: each;
						format: #String data: each name;
						format: #Chunk data: stream contents;
						yourself)]
		separatedBy: [stream reset].
	aDragDropSession dragObjects: objects!

onDropOverFolder: aDragDropSession
	"Private - Handle a drop of over the package folder tree."

	| packages folder |
	packages := OrderedCollection new.
	folder := aDragDropSession suggestedTarget.
	aDragDropSession dragObjects do: 
			[:each |
			(each format: #Package ifAbsent: [])
				ifNotNil: [:pkg | (pkg packageFolder sameAs: folder pathname) ifFalse: [packages add: pkg]]].
	self savePackages: packages toFolder: folder!

onDropOverPackage: session
	"Private - The drag operation described by session would like to do a drop.
	Override this method to accept the dragObject(s)."

	| targetPackage packageManager |
	targetPackage := session suggestedTarget.
	targetPackage isNil
		ifTrue: 
			[Sound errorBeep.
			^false].
	packageManager := Package manager.
	Cursor wait showWhile: 
			[session dragObjects do: 
					[:each |
					"See if the drop is a CompiledMethod"
					(each isFormatAvailable: #CompiledMethod)
						ifTrue: 
							[| method |
							method := each format: #CompiledMethod.
							packageManager addMethod: method to: targetPackage].
					(each isFormatAvailable: #ResourceIdentifier)
						ifTrue: 
							[| resource |
							resource := each format: #ResourceIdentifier.
							packageManager addResourceIdentifier: resource to: targetPackage].
					(each isFormatAvailable: #VariableName)
						ifTrue: 
							[| name |
							name := each format: #VariableName.
							packageManager addVariableNamed: name to: targetPackage].
					(each isFormatAvailable: #Class)
						ifTrue: 
							[| class |
							class := each format: #Class.
							packageManager addClass: class to: targetPackage]]].

	"Operation must never be #move to avoid methods being removed"
	session operation: #copy.
	^true!

onFilterSelected
	"Private - A filter directory has been selected. Refresh the packages list to include only those within the filter directory hierarchy"

	self refresh!

onPackageChanged: aPackage
	"Private - The development system has marked aPackage as being changed,
	update the package list to show any change in the appearance of the package."

	self packagesPresenter view updateAll!

onPackageChosen
	"Private - The user has double clicked a package."

	self trigger: #actionPerformed!

onPackagesChanged
	"Private - The set of loaded packages has changed. Refresh the receiver appropriately"

	self refresh.
	self filterPresenter expand: self rootFolder!

onSelectionChanged
	"Private - Sent by #onSelChange when the receiver's selection has changed.
	The default is to trigger an #selectionChanged event off the presenter"

	self trigger: #selectionChanged!

onSelectionChanging: aSelectionChangingEvent 
	self trigger: #selectionChanging: with: aSelectionChangingEvent!

onTipTextRequired: tool
	"Private - Tool tip text is required for the <ToolbarItem>, tool."

	| cmd |
	cmd := tool command asSymbol.
	cmd == #clearSelection ifTrue: [^'Uninstall <1p>' expandMacrosWith: self singlePackage name].
	^super onTipTextRequired: tool!

onViewOpened
	"Received when the receiver's view is been connected. "

	super onViewOpened.
	self filterPresenter expand: self rootFolder!

openPackage
	"Request the file name of an existing package to load."

	| pathname fileDialog |
	fileDialog := FileOpenDialog new.
	fileDialog fileTypes: self developmentSystem packageOpenFileDialogTypes.
	self filter
		ifNotNil: [:filter | fileDialog initialDirectory: (FileLocator imageRelative localFileSpecFor: filter)].
	fileDialog caption: 'Install Package'.
	pathname := fileDialog showModal.
	pathname isNil ifTrue: [^self].
	"As loading a package is a lengthy operation, we repaint the package browser first"
	self view update.
	Cursor wait showWhile: [self openPackageFile: pathname]!

openPackageFile: aString 
	| packages |
	packages := self developmentSystem installPackage: aString.
	packages notEmpty 
		ifTrue: 
			[self packages: packages.
			packages last about]!

operationAbortedSignal
	"Private - Answer the signal raised when the user aborts some operation in the receiver."

	^OperationAborted!

packageManager
	"Private - Answer the current PackageManager."

	^Package manager

!

packages
	"Private - Answer the collection of currently selected packages"

	^self selections
!

packages: aPackageCollection 
	"Private - Set the selected packages."

	self
		selections: aPackageCollection;
		ensureSelectionVisible;
		synchronizeFilter!

packagesPresenter
	"Private - Answer the name of the <selectableItems> component that actually handles the selectable items in the receiver"
	
	^packagesPresenter!

promptToSavePackageChanges: package
	"Private - Uninstallation of the <Package>, package, has been initiated. Prompt the user to save
	any changes."

	| resp mb |
	package isChanged ifFalse: [^false].
	mb := MessageBox new.
	mb beTaskModal.
	resp := mb
				headline: 'Save <1p> before uninstallation?' << package name;
				iconStyle: #warning;
				customButtons: #(#(#yes '&Save && Uninstall') #(#no '&Uninstall'));
				confirmOrCancel: 'The package has unsaved changes that will be discarded if the package is uninstalled.'.
	resp == #no
		ifFalse: 
			[resp == #yes
				ifTrue: [(Cursor wait showWhile: [self savePackageChanges: {package}]) ifTrue: [^true]].
			self operationAbortedSignal signalWith: package].
	^true!

queryCommand: aCommandQuery
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>, query"

	| selector |
	selector := aCommandQuery commandSymbol.
	#browseIt == selector
		ifTrue: 
			[selector := self browseItCommand.
			selector isNil
				ifTrue: 
					[aCommandQuery isEnabled: false.
					^true]].
	#clearSelection == selector
		ifTrue: 
			[selector := self deleteItCommand.
			selector isNil
				ifTrue: 
					[aCommandQuery isEnabled: false.
					^true]].
	#aboutPackage == selector
		ifTrue: 
			[aCommandQuery
				isEnabled: (self singlePackage ifNil: [false] ifNotNil: [:package | package canShowAbout]).
			^true].
	(#(#inspectPackage #browsePackages #browseSources #browsePackageSources #browseUnimplemented)
		identityIncludes: selector)
			ifTrue: 
				[aCommandQuery isEnabled: self hasPackages.
				^true].
	(#(#checkOut #checkIn) identityIncludes: selector)
		ifTrue: 
			[aCommandQuery isEnabled: ((self respondsTo: selector) and: [self hasPackages]).
			^true].
	#deploy == selector
		ifTrue: 
			[aCommandQuery isEnabled: (self hasSinglePackage and: [self respondsTo: selector]).
			^true].
	#browseDeployed == selector
		ifTrue: 
			[aCommandQuery
				isEnabled: ((self respondsTo: selector) and: 
							[self singlePackage
								ifNil: [false]
								ifNotNil: [:package | package hasImageStripper and: [File exists: package imageStripper logFileName]]]).
			^true].
	#setAsDefaultPackage == selector
		ifTrue: 
			[self singlePackage
				ifNil: [aCommandQuery isEnabled: false]
				ifNotNil: 
					[:package |
					aCommandQuery
						isEnabled: true;
						isChecked: package isDefaultPackage].
			^true].
	(#(#addClass #addSharedVariable #savePackageAs #addMenu) identityIncludes: selector)
		ifTrue: 
			[aCommandQuery isEnabled: self hasSinglePackage.
			^true].
	selector == #saveBinaryPackage
		ifTrue: 
			[aCommandQuery isEnabled: ((self respondsTo: #saveBinaryPackage) and: [self hasSinglePackage]).
			^true].
	(#(#removePackage #sourceControlMenu #inspectIt) identityIncludes: selector)
		ifTrue: 
			[aCommandQuery isEnabled: self hasPackages.
			^true].
	selector == #savePackages
		ifTrue: 
			[aCommandQuery
				isEnabled: (self hasPackages and: [self packages allSatisfy: [:each | self isSaveablePackage: each]]).
			^true].
	selector == #savePackageChanges
		ifTrue: 
			[aCommandQuery isEnabled: (self hasChangedPackages
						and: [self packages allSatisfy: [:each | self isSaveablePackage: each]]).
			^true].
	selector == #resetChangeFlags
		ifTrue: 
			[aCommandQuery isEnabled: self hasChangedPackages.
			^true].
	(#(#checkOutChanges) identityIncludes: selector)
		ifTrue: 
			[aCommandQuery isEnabled: (self hasChangedPackages and: [self respondsTo: selector]).
			^true].
	(#(#browseFolder) identityIncludes: selector)
		ifTrue: 
			[aCommandQuery
				isEnabled: (self selectedFolder ifNil: [false] ifNotNil: [:folder | File isDirectory: folder]).
			^true].
	#synchronizeFilter == selector
		ifTrue: 
			[| packages |
			packages := self packages.
			aCommandQuery isEnabled: (packages notEmpty and: [(self commonFolder: packages) ~= self filter]).
			^true].
	selector == #toggleUsingPAX
		ifTrue: 
			[| syspkg first enable usingPax |
			syspkg := self packageManager systemPackage.
			enable := false.
			first := true.
			usingPax := false.
			self packages do: 
					[:each |
					each == syspkg ifTrue: [enable := false].
					first
						ifTrue: 
							[enable := true.
							usingPax := each isUsingPAX.
							first := false]
						ifFalse: [each isUsingPAX ~~ usingPax ifTrue: [enable := false]]].
			aCommandQuery
				isEnabled: enable;
				isChecked: usingPax.
			^true].
	selector == #toggleLegacySourceFormat
		ifTrue: 
			[| first enable legacyFormat |
			enable := false.
			first := true.
			legacyFormat := false.
			self packages do: 
					[:each |
					first
						ifTrue: 
							[enable := true.
							legacyFormat := each isLegacySourceFormat.
							first := false]
						ifFalse: [each isLegacySourceFormat ~~ legacyFormat ifTrue: [enable := false]]].
			aCommandQuery
				isEnabled: enable;
				isChecked: legacyFormat.
			^true].
	^super queryCommand: aCommandQuery!

refresh
	"Private - Refresh the contents of the receiver."

	| packages newSelections oldSelections |
	packages := self filteredPackages asSortedCollection: [:a :b | a name < b name].
	oldSelections := self selections.
	newSelections := self autoSelect ifTrue: [packages] ifFalse: [oldSelections intersection: packages].
	"Deliberately suppress the selection change event caused by resetting the list to avoid
	 generating two selection change events"
	self packagesPresenter noEventsDo: 
			[self packagesPresenter list: packages.
			self selections: newSelections reverse].
	(newSelections symmetricDifference: oldSelections) notEmpty 
		ifTrue: [self packagesPresenter onSelectionChanged]!

removePackage
	"Prompt for confirmation and, if given, uninstall the selected packages."

	| before |
	before := Package manager packages keys.
	[self packages do: [:each | self uninstall: each]] on: self operationAbortedSignal
		do: 
			[:e |
			| removed |
			removed := before difference: Package manager packages keys.
			removed isEmpty
				ifFalse: 
					[| msg |
					msg := String writeStream.
					msg nextPutAll: 'Package uninstallation was aborted, but the following packages were removed:'; cr.
					removed asSortedCollection do: 
							[:each |
							msg
								crtab;
								nextPutAll: each].
					MessageBox warning: msg contents]]!

resetChangeFlags
	"Reset the change flags for the selected packages"

	self packages do: [:each | each resetChangeFlags]!

resetForItem: aPackage 
	"Private - Try to ensure that the filter is set to display aPackage if possible"

	self filterPresenter selectionOrNil: (self folderClass forPackage: aPackage)!

resetForItems: aCollectionOfPackages 
	aCollectionOfPackages notEmpty 
		ifTrue: 
			[filterPresenter selection: (self commonFolder: aCollectionOfPackages)]!

rootFolder
	^self folderClass root!

saveFileDialogTypes
	"Private - Answer a file types array for use with a FileDialog to save packages."

	^{self developmentSystem pacFileDialogType. self developmentSystem paxFileDialogType}!

savePackageAs
	"Save the selected package to a user set pathname."

	| pathname package |
	package := self singlePackage.
	(self okToSavePackage: package) ifFalse: [^self].
	pathname := FileSaveDialog new
				fileTypes: self saveFileDialogTypes;
				defaultExtension: Package packageExtension;
				value: (File removeExtension: package packageFileName);
				caption: 'Save Package <1p> As…' << package name;
				showModal.
	pathname notNil
		ifTrue: 
			[package saveAs: pathname.
			self packages: {package}]!

savePackageChanges
	"Save out the selected package (if changed) and its changed owned objects."

	self savePackageChanges: self packages!

savePackageChanges: aPackageCollection 
	"Save out the packages in aPackageCollection having first checked that they are in a reloadable state.
	Answer whether the packages were saved."

	| ok |
	ok := true.
	(aPackageCollection 
		select: [:each | each isChanged and: [self isSaveablePackage: each]]) do: 
				[:each | 
				(self okToSavePackage: each) 
					ifTrue: [each saveChanges]
					ifFalse: [ok := false]].
	^ok!

savePackages
	"Save out the selected packages"

	self savePackages: self packages!

savePackages: aPackageCollection 
	"Save out the packages in aPackageCollection having first checked that they are in a reloadable state.
	Answer whether the package was saved."

	| ok |
	ok := true.
	(aPackageCollection select: [:each | self isSaveablePackage: each]) 
		do: [:each | (self okToSavePackage: each) ifTrue: [each save] ifFalse: [ok := false]].
	^ok!

savePackages: aCollection toFolder: aPackageFolder
	| msg dir mb |
	msg := String writeStream.
	msg
		nextPutAll: 'The following packages will be moved to the folder ';
		print: aPackageFolder folderName;
		nextPut: $:;
		cr.
	(aCollection asSortedArray: Package defaultSortBlock) do: 
			[:each |
			msg
				crtab;
				display: each].
	msg
		cr;
		cr;
		nextPutAll: 'Are you sure that you would like to proceed?'.
	mb := MessageBox new.
	mb beTaskModal.
	mb headline: 'Move packages to <1p>?' << aPackageFolder folderName.
	(mb confirm: msg contents) ifFalse: [^self].
	dir := File fullPathOf: aPackageFolder pathname relativeTo: SessionManager current imageBase.
	aCollection do: [:each | each saveAs: (File composePath: dir subPath: each name)]!

selectableItems
	"Private - Answer the name of the <selectableItems> component that actually handles the selectable items in the receiver"
	
	^self packagesPresenter!

selectedFolder
	^self filterPresenter selectionOrNil
		ifNotNil: [:folder | FileLocator imageRelative localFileSpecFor: folder pathname]!

selectedSourceObjects
	"Private - Answer a collection of all the source objects from the selected packages"

	| answer |
	answer := OrderedCollection new.
	self packages 
		do: [:eachPackage | eachPackage allSourceObjectsDo: [:each | answer addLast: each]].
	^answer!

selectionEnvironment
	^BrowserEnvironment new forPackages: self selections!

selectNoFolder
	"Select nothing in the folder hierachy."

	filterPresenter selectionOrNil: nil!

selectRootFolder
	"Select the first root of the package hierarchy."

	filterPresenter selection: self rootFolder!

setAsDefaultPackage
	| package oldDefault pkgList |
	oldDefault := self packageManager defaultPackage.
	package := self singlePackage.
	self packageManager defaultPackage: (package isDefaultPackage ifFalse: [package]).
	pkgList := self selectableItems model.
	pkgList refresh: package.
	oldDefault notNil ifTrue: [pkgList refresh: oldDefault]!

singlePackage
	"Private - Answer the selected package iff a single package is selected, otherwise nil."

	| packages |
	packages := self packages.
	^packages size == 1 ifTrue: [packages first]!

synchronizeFilter
	| packages |
	packages := self selections.
	self resetForItems: packages.
	self selections: packages!

systemModel
	"Private - Answer the development system model."

	^SmalltalkSystem current!

testBrowserClass
	^self developmentSystem testBrowserClass!

toggleLegacySourceFormat
	"Private - Toggles the use of legacy source format; either pre-namespaces (legacy), or with namespaces (current)."

	^self packages do: [:each | each toggleLegacySourceFormat]!

toggleUsingPAX
	"Toggles the use of PAX mode."

	^self packages do: [:each | each toggleUsingPAX]!

uninstall: package
	"Private - Uninstall the <Package>, package, prompting the user to first save changes (if any),
	and to remove dependent packages (if any)."

	| currentFolder |
	package isInstalled ifFalse: [^self].
	self checkCanUninstall: package.
	(self confirmUninstall: package) ifFalse: [^self].
	currentFolder := self filterPresenter selectionOrNil.
	"Remove selection first to avoid losing objects required to maintain display"
	self packages: (self packages copyWithout: package).
	[self packageManager uninstall: package]
		on: ClassBuilder invalidRemoveError
		do: 
			[:e |
			| mb |
			mb := MessageBox new.
			mb beTaskModal.
			e resume: (mb
						headline: 'Continue with class removal?';
						confirm: ('<1s><n><n>Would you like to remove the class anyway?' expandMacrosWith: e description))]
		on: Notification
		do: 
			[:ex |
			self developmentSystem sourceManager logComment: ex description.
			ex resume].

	"Select nearest available folder in filter hierarchy"
	[currentFolder notNil and: [(self filterPresenter selection: currentFolder ifAbsent: []) isNil]]
		whileTrue: [currentFolder := currentFolder parent]! !
!Tools.PackageSelector categoriesForMethods!
aboutPackage!commands!public! !
addClass!commands!public! !
addSharedVariable!commands!public! !
applicationEnvironment!public! !
autoSelect!accessing!public! !
autoSelect:!accessing!public! !
browseFolder!commands!public! !
browseIt!commands!public! !
browseItCommand!helpers!private! !
browsePackages!commands!public! !
browseUnimplemented!public! !
canRefactor!commands!private!refactoring! !
checkCanUninstall:!helpers!private! !
commonFolder:!operations!private! !
confirmUninstall:!helpers!private! !
createComponents!initializing!private! !
createSchematicWiring!initializing!private! !
deleteItCommand!helpers!private! !
developmentSystem!commands!private! !
filter!accessing!public! !
filteredPackages!helpers!private! !
filterPresenter!accessing!private! !
folder!accessing!public! !
folderClass!constants!private! !
hasChangedPackages!private!testing! !
hasPackages!private!testing! !
hasSinglePackage!private!testing! !
initialize!initializing!private! !
inspectIt!commands!public! !
inspectPackage!commands!public! !
isEnabled:!accessing!public! !
isSaveablePackage:!private!testing! !
model:!public! !
newPackage!commands!public! !
okToSavePackage:!helpers!private! !
onDragOverFolder:!drag & drop!event handling!private! !
onDragOverPackage:!drag & drop!event handling!private! !
onDragPackages:!drag & drop!event handling!private! !
onDropOverFolder:!drag & drop!event handling!private! !
onDropOverPackage:!drag & drop!event handling!private! !
onFilterSelected!event handling!private! !
onPackageChanged:!event handling!private! !
onPackageChosen!event handling!private! !
onPackagesChanged!event handling!private! !
onSelectionChanged!event handling!private! !
onSelectionChanging:!private! !
onTipTextRequired:!event handling!private! !
onViewOpened!event handling!public! !
openPackage!commands!public! !
openPackageFile:!commands!private! !
operationAbortedSignal!constants!private! !
packageManager!constants!private! !
packages!accessing!private! !
packages:!accessing!private! !
packagesPresenter!accessing!private! !
promptToSavePackageChanges:!helpers!private! !
queryCommand:!commands!private! !
refresh!private!updating! !
removePackage!commands!public! !
resetChangeFlags!commands!public! !
resetForItem:!event handling!private! !
resetForItems:!operations!private! !
rootFolder!accessing!private! !
saveFileDialogTypes!constants!private! !
savePackageAs!commands!public! !
savePackageChanges!commands!public! !
savePackageChanges:!commands!public! !
savePackages!commands!public! !
savePackages:!commands!public! !
savePackages:toFolder:!helpers!private! !
selectableItems!accessing!private! !
selectedFolder!commands!public! !
selectedSourceObjects!accessing!private! !
selectionEnvironment!accessing!private! !
selectNoFolder!public! !
selectRootFolder!public! !
setAsDefaultPackage!commands!private! !
singlePackage!accessing!private! !
synchronizeFilter!commands!private! !
systemModel!accessing!private! !
testBrowserClass!constants!private! !
toggleLegacySourceFormat!commands!private! !
toggleUsingPAX!commands!public! !
uninstall:!commands!private! !
!

!Tools.PackageSelector class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^PackageHierarchyModel new!

resource_Choice_view
	"Answer the literal data from which the 'Choice view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Choice_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.LookupTable} 50 2 518 #{Core.Association} 18 #{UI.TreeView} 50 27 nil 32 50 2 8 1140916771 1025 224 1094 3 #{UI.TreeModel} nil 6 #{Kernel.IdentitySearchPolicy} 774 #{UI.TreeNode} nil nil nil 550 #{Core.IdentityDictionary} 0 6 #{Graphics.Color} #default nil 5 2886 4 #{UI.Menu} nil true 50 1 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #newPackage 8 '&New Package…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 224 nil nil 518 #{Core.Message} #displayString 8 #() 594 #iconImageIndex 624 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil 550 #{Core.LookupTable} 0 nil #smallIcons 1 386 0 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1 1 834 737 227 224 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 1 0 0 113 0 0 0] 8 #() 834 193 193 nil 27 3 194 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140920397 1025 976 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 336 432 nil 21 450 nil true 50 9 498 1 530 #synchronizeFilter 8 '&Goto Folder' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 498 1 530 #newPackage 8 '&New Package…' 1 1 nil nil nil 498 1 530 #savePackages 8 '&Save' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'FileSave.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 498 1 530 #savePackageAs 8 'Save &As…' 1 1 nil nil nil 450 nil true 50 10 498 1 530 #toggleUsingPAX 8 'Use PA&X Source Format' 1 1 nil nil nil 498 1 530 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 1186 4097 498 1 530 #checkOut 8 'Check Out &All' 1 1 nil nil nil 498 1 530 #checkOutChanges 8 'Check &Out Changes' 1 1 nil nil nil 498 1 530 #checkIn 8 'Check &In' 1 1 nil nil nil 1186 4097 498 2097153 530 #savePackageChanges 8 'Save &Changes' 1 1 nil nil nil 1186 4097 498 1 530 #resetChangeFlags 8 'Clear Change &Markers' 1 1 nil nil nil 8 'Sou&rce Control' #sourceControlMenu 1 nil nil nil nil nil 1186 4097 498 1 530 #inspectPackage 8 '&Properties' 1 1 1314 nil true 1346 8 'SMALLTALKOPTIONSFOLDER.ICO' 1408 65541 nil nil nil 498 1 530 #aboutPackage 8 'Abou&t this Package…' 1 1 nil nil nil 8 '&Package' nil 134217729 nil nil nil nil nil nil nil 976 nil nil 594 #name 8 #() 640 672 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | 
ctx item isDefaultPackage ifTrue: [
	ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 2144 7 257 nil nil nil nil 1074 2 3142 5 #{UI.ListViewColumn} 8 '' 41 #left nil 2130 0 nil 2162 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 2304 7 513 nil 594 #isChanged 8 #() nil 976 2130 0 nil 2162 5 1 2128 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]] ' 8 #[32 105 17 121 45 159 160 106 60 106] 1094 2 #{Kernel.VariableBinding} #Package #{Kernel.Package} #{Kernel} 1 #changedIcon #imageIndex 2416 #ifTrue: 7 257 nil 1 nil nil 2258 8 'Packages' 689 #left 608 2130 0 nil 2162 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 2560 7 513 nil nil nil 976 640 3 nil 2130 0 nil 2162 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | 
ctx item isDefaultPackage ifTrue: [
	ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 2640 7 257 nil #report 8 #() nil 133221 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 738 50 1 786 #createAt:extent: 50 2 834 1 237 834 737 229 976 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 118 0 0 0 112 1 0 0 232 0 0 0] 8 #() 944 nil 35 3 true 518 #{Kernel.STBIdentityDictionaryProxy} 384 50 4 224 8 'filter' 976 8 'packages' nil 738 50 1 786 #createAt:extent: 50 2 834 6143 21 834 737 465 32 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 111 13 0 0 242 0 0 0] 50 3 224 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 3104 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 3104 nil 1 #left nil nil nil 834 1 1 834 9 9 nil 3200 nil 738 50 1 786 #createAt:extent: 50 2 834 1 227 834 737 11 3104 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 113 0 0 0 112 1 0 0 118 0 0 0] 8 #() 944 nil 27 976 944 nil 27)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 21 nil nil nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.LookupTable} 50 2 518 #{Core.Association} 18 #{UI.TreeView} 50 27 nil 32 50 2 8 1140916771 1025 224 1094 3 #{UI.TreeModel} nil 6 #{Kernel.IdentitySearchPolicy} 774 #{UI.TreeNode} nil nil nil 550 #{Core.IdentityDictionary} 0 6 #{Graphics.Color} #default nil 29 2886 4 #{UI.Menu} nil true 50 2 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #browseFolder 8 '&Browse Folder' 1 1 nil nil nil 498 1 530 #newPackage 8 '&New Package…' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'NewPackage.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 224 nil nil 518 #{Core.Message} #displayString 8 #() 770 #iconImageIndex 800 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil 550 #{Core.LookupTable} 0 nil #smallIcons 1 386 0 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1 1 1010 701 211 224 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 105 0 0 0] 8 #() 1010 193 193 nil 27 7 194 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140920393 1025 1152 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 336 432 nil 29 450 nil true 50 19 498 1 530 #newPackage 8 '&New Package…' 1 1 626 nil true 658 8 'NewPackage.ico' 720 65541 nil nil nil 498 1 530 #openPackage 8 '&Install Package…' 1 1 626 nil true 658 8 'FileOpen.ico' 720 65541 nil nil nil 498 1 530 #removePackage 8 '&Uninstall Package' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 450 nil true 50 2 498 2097153 530 #addClass 8 '&Class…' 1 1 626 nil true 658 8 'Behavior.ico' 720 65541 nil nil nil 498 1 530 #addSharedVariable 8 '&Global…' 1 1 nil nil nil 8 'Add Unco&mmitted' #addMenu 134217729 nil nil nil nil nil 498 1 530 #setAsDefaultPackage 8 'Set as De&fault Package' 1 1 nil nil nil 498 1 530 #synchronizeFilter 8 '&Goto Folder' 1 1 nil nil nil 1554 4097 498 1 530 #savePackages 8 '&Save Package' 1 1 626 nil true 658 8 'FileSave.ico' 720 65541 nil nil nil 498 1 530 #savePackageChanges 8 'Save Package C&hanges' 1 1 nil nil nil 498 1 530 #savePackageAs 8 'Save Package &As…' 1 1 nil nil nil 1554 4097 498 1 530 #toggleUsingPAX 8 'Use PA&X Source Format' 1 1 nil nil nil 498 1 530 #toggleLegacySourceFormat 8 '&Pre-Namespace Source Format' 1 1 nil nil nil 498 1 530 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 1554 4097 450 nil true 50 4 498 2097153 530 #deploy 8 '&Deploy Executable…' 13445 1 nil nil nil 498 1 530 #browseDeployed 8 'Bro&wse Executable Manifest' 1 1 nil nil nil 1554 4097 498 1 530 #saveBinaryPackage 8 'Deploy &Binary Package…' 1 1 nil nil nil 8 '&Deployment' nil 134217729 626 nil true 658 8 'ApplicationDeploymentWizard.ico' 720 65541 nil nil nil nil nil 1554 4097 498 1 530 #inspectPackage 8 'P&roperties' 1 1 626 nil true 658 8 'BasicInspector.ico' 720 65541 nil nil nil 8 '&Package' nil 134217729 nil nil nil nil nil nil nil 1152 nil nil 784 816 848 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | 
ctx item isDefaultPackage ifTrue: [
	ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 2656 7 257 nil 1010 65 65 nil nil 1250 2 3142 5 #{UI.ListViewColumn} 8 'Packages' 669 #left 784 2642 0 nil 2674 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 2832 7 513 nil nil nil 1152 816 3 nil 2642 0 nil 2674 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | 
ctx item isDefaultPackage ifTrue: [
	ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 2912 7 257 nil 2786 8 '' 33 #left 2642 0 nil 2674 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 3024 7 257 nil 2642 0 nil 2674 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x : y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 3136 7 513 nil 770 #isChanged 8 #() nil 1152 2642 0 nil 2674 7 1 2640 8 'doIt' 8 '[:x | (x ifTrue: [Package changedIcon] ifFalse: [Graphics.Icon blank]) imageIndex] ' 8 #[34 105 17 120 45 159 111 47 161 162 106] 1094 2 #{Kernel.VariableBinding} #Package #{Kernel.Package} #{Kernel} 1 #changedIcon 3330 #Icon 624 #{Graphics} 1 #blank #imageIndex 3248 #ifTrue:ifFalse: 7 257 nil 1 nil nil #report 8 #() nil 133221 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 914 50 3 962 #createAt:extent: 50 2 1010 1 221 1010 701 281 1152 962 #text: 50 1 8 'Packages' 1152 962 #columnOrder: 50 1 8 #(2 1) 1152 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 110 0 0 0 94 1 0 0 250 0 0 0] 8 #() 1120 nil 35 9 true 518 #{Kernel.STBIdentityDictionaryProxy} 384 50 4 224 8 'filter' 1152 8 'packages' nil 914 50 1 962 #createAt:extent: 50 2 1010 6143 21 1010 701 501 32 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 93 13 0 0 4 1 0 0] 50 3 224 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 3856 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 3856 nil 1 #left nil nil nil 1010 1 1 1010 9 9 nil 3952 nil 914 50 1 962 #createAt:extent: 50 2 1010 1 211 1010 701 11 3856 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 0 0 0 94 1 0 0 110 0 0 0] 8 #() 1120 nil 27 1152 1120 nil 27)!

resource_Single_package_selector
	"Answer the literal data from which the 'Single package selector' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Single_package_selector)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 21 nil nil nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.LookupTable} 50 2 518 #{Core.Association} 18 #{UI.TreeView} 50 27 nil 32 50 2 8 1140916771 1025 224 1094 3 #{UI.TreeModel} nil 6 #{Kernel.IdentitySearchPolicy} 774 #{UI.TreeNode} nil nil nil 550 #{Core.IdentityDictionary} 0 6 #{Graphics.Color} #default nil 5 2886 4 #{UI.Menu} nil true 50 1 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #newPackage 8 '&New Package…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 224 nil nil 518 #{Core.Message} #displayString 8 #() 594 #iconImageIndex 624 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil 550 #{Core.LookupTable} 0 nil #smallIcons 1 386 0 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1 1 834 701 211 224 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 105 0 0 0] 8 #() 834 193 193 nil 27 7 194 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140920397 1025 976 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 336 432 nil 21 450 nil true 50 19 498 1 530 #synchronizeFilter 8 '&Goto Folder' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 498 1 530 #setAsDefaultPackage 8 'Set as De&fault Package' 1 1 nil nil nil 450 nil true 50 2 498 2097153 530 #addClass 8 '&Class…' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'Class.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 498 1 530 #addSharedVariable 8 '&Global…' 1 1 nil nil nil 8 'Add Unco&mmitted' #addMenu 134217729 nil nil nil nil nil 1186 4097 498 1 530 #newPackage 8 '&New Package…' 1 1 nil nil nil 498 1 530 #openPackage 8 '&Install Package…' 1 1 nil nil nil 498 1 530 #removePackage 8 '&Uninstall' 1 1 nil nil nil 1186 4097 498 1 530 #savePackages 8 '&Save' 1 1 1346 nil true 1378 8 'FileSave.ico' 1440 65541 nil nil nil 498 1 530 #savePackageAs 8 'Save &As…' 1 1 nil nil nil 1186 4097 450 nil true 50 10 498 1 530 #toggleUsingPAX 8 'Use PA&X Source Format' 1 1 nil nil nil 498 2097153 530 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 1186 4097 498 1 530 #checkOut 8 'Check Out &All' 1 1 nil nil nil 498 1 530 #checkOutChanges 8 'Check &Out Changes' 1 1 nil nil nil 498 1 530 #checkIn 8 'Check &In' 1 1 nil nil nil 1186 4097 498 1 530 #savePackageChanges 8 'Save &Changes' 1 1 nil nil nil 1186 4097 498 1 530 #resetChangeFlags 8 'Clear Change &Markers' 1 1 nil nil nil 8 'Sou&rce Control' #sourceControlMenu 1 nil nil nil nil nil 1186 4097 498 1 530 #deploy 8 '&Deploy Executable…' 1 1 nil nil nil 498 1 530 #saveBinaryPackage 8 'Deploy &Binary Package…' 1 1 nil nil nil 1186 4097 498 1 530 #inspectPackage 8 '&Properties' 1 1 1346 nil true 1378 8 'SMALLTALKOPTIONSFOLDER.ICO' 1440 65541 nil nil nil 498 1 530 #aboutPackage 8 'Abou&t this Package…' 1 1 nil nil nil 8 '&Package' nil 134217729 nil nil nil nil nil nil nil 976 nil nil 594 #name 8 #() 640 672 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 2640 7 257 nil nil nil nil 1074 2 3142 5 #{UI.ListViewColumn} 8 '' 41 #left nil 2626 0 nil 2658 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 2800 7 513 nil 594 #isChanged 8 #() nil 976 2626 0 nil 2658 5 1 2624 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]] ' 8 #[32 105 17 121 45 159 160 106 60 106] 1094 2 #{Kernel.VariableBinding} #Package #{Kernel.Package} #{Kernel} 1 #changedIcon #imageIndex 2912 #ifTrue: 7 257 nil 1 nil nil 2754 8 'Packages' 653 #left 608 2626 0 nil 2658 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 3056 7 513 nil nil nil 976 640 3 nil 2626 0 nil 2658 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 3136 7 257 nil #report 8 #() nil 133221 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 738 50 1 786 #createAt:extent: 50 2 834 1 221 834 701 281 976 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 110 0 0 0 94 1 0 0 250 0 0 0] 8 #() 944 nil 35 9 true 518 #{Kernel.STBIdentityDictionaryProxy} 384 50 4 224 8 'filter' 976 8 'packages' nil 738 50 1 786 #createAt:extent: 50 2 834 6143 21 834 701 501 32 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 93 13 0 0 4 1 0 0] 50 3 224 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 3600 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 3600 nil 1 #left nil nil nil 834 1 1 834 9 9 nil 3696 nil 738 50 1 786 #createAt:extent: 50 2 834 1 211 834 701 11 3600 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 0 0 0 94 1 0 0 110 0 0 0] 8 #() 944 nil 27 976 944 nil 27)! !
!Tools.PackageSelector class categoriesForMethods!
defaultModel!models!public! !
resource_Choice_view!public!resources-views! !
resource_Default_view!public!resources-views! !
resource_Single_package_selector!public!resources-views! !
!

