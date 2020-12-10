"Filed out from Dolphin Smalltalk 7"!

UI.SelectableItemsPresenter subclass: #'Tools.PackageSelector'
	instanceVariableNames: 'filterPresenter packagesPresenter autoSelect'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: 'commandQueryHandlers'
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
		caption: ('Add Classes to package ''<1d>''...' expandMacrosWith: package))
			ifNotNil: [:chosen | chosen do: [:each | pacman addClass: each to: package]]!

addSharedVariable
	"Request an available shared variable to add the receivers current package. Only	variables which are not currently owned by any other package are shown."

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
	^self systemModel systemEnvironment forPackages: closure!

autoSelect
	^autoSelect!

autoSelect: aBoolean
	autoSelect := aBoolean!

browseFolder
	| folder |
	folder := self selectedFolder.
	[self systemModel browseFolder: folder] on: OS.Win32Error
		do: 
			[:ex |
			MessageBox errorMsg: ex messageText caption: ('Unable to browse <1p>...' expandMacrosWith: folder)]!

browseIt
	"Browse the selected item in the pane with focus."

	self perform: self browseItCommand!

browseItCommand
	"Private - Answer the command that the context-sensitive 'Browse-It' command would be linked
	to if sent to the receiver at this moment."

	filterPresenter hasFocus ifTrue: [^#browseFolder].
	packagesPresenter hasFocus ifTrue: [^nil].
	^nil!

browsePackages
	self systemModel browsePackages: self packages!

browseUnimplemented
	"Open a method browser on all methods in the selected packages that themselves send a
	message which is not apparently implemented in any of those packages or their
	prerequisites."

	| sendingEnvironment implementingEnvironment unimplemented |
	sendingEnvironment := self selectionEnvironment.
	implementingEnvironment := self applicationEnvironment.
	unimplemented := self systemModel unimplementedSelectorsIn: implementingEnvironment.
	self systemModel
		browseSelectors: unimplemented asSortedCollection
		caption: ('Unimplemented Selectors in <1p> (and prerequisites)' expandMacrosWith: sendingEnvironment)
		environment: implementingEnvironment!

checkCanUninstall: package
	"Private - Uninstallation of the <Package>, package, has been initiated. Verify that it can be uninstalled
	and if not inform the user accordingly and abort the operation."

	| err |
	[package okToUninstall] on: Error do: [:ex | err := ex].
	err notNil
		ifTrue: 
			[MessageBox errorMsg: err description.
			^self operationAbortedSignal signalWith: package]!

clearSelection
	"Private - Remove the selected object from the system"

	self perform: self deleteItCommand!

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

	| deps msg prompt max mb |
	self promptToSavePackageChanges: aPackage.
	Cursor wait showWhile: [deps := aPackage allDependentPackages].
	prompt := 'Uninstalling <1p> package...' expandMacrosWith: aPackage name.
	deps isEmpty
		ifTrue: 
			[msg := 'Do you really want to uninstall the <1p> package and remove all its owned objects from the system?'
						expandMacrosWith: aPackage name.
			mb := MessageBox new.
			mb
				caption: prompt;
				beTaskModal.
			(mb confirm: msg) ifFalse: [^self operationAbortedSignal signalWith: aPackage].
			^self].
	msg := String writeStream.
	msg
		nextPutAll: 'The following packages depend on ';
		print: aPackage name;
		nextPutAll: ' as a prerequisite, and will also be uninstalled:';
		cr;
		cr.
	max := 30.
	(deps collect: [:e | e name]) asSortedCollection
		from: 1
		to: (deps size min: max)
		do: 
			[:each |
			msg
				tab;
				nextPutAll: each;
				cr].
	deps size > max
		ifTrue: 
			[msg
				tab;
				nextPutAll: '... and ';
				print: deps size - max;
				nextPutAll: ' other packages ...';
				cr].
	msg
		cr;
		nextPutAll: 'Are you sure that you like to proceed?'.
	mb := MessageBox new.
	mb
		caption: prompt;
		buttonStyle: #yesNo;
		beTaskModal.
	(mb warning: msg contents) == #no ifTrue: [^self operationAbortedSignal signalWith: aPackage].
	deps do: [:e | self promptToSavePackageChanges: e]!

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
	^nil!

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
					searchPrefix := (File appendPathDelimiter: filter) asLowercase.
					allPackages select: [:each | each packagePathname asLowercase beginsWith: searchPrefix]]]!

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

	^aPackage ~= self packageManager systemPackage or: [Smalltalk developmentSystem isOAD]!

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
	dialog := UI.FileSaveDialog new
				initialDirectory: directory;
				fileTypes: {self systemModel pacFileDialogType};
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
	[^aPackage okToSaveOrDeploy] on: Package unsaveableSignal do: [:ex | err := ex].
	mb := MessageBox new.
	mb iconStyle: #warning.
	mb caption: 'Cannot save package ' , aPackage name printString.
	(mb confirm: err description
				, '

The package will NOT load if saved in this form so the package file has not been saved.

Would you like to browse the packages prerequisites in order to track down the problem?')
		ifTrue: [self systemModel showPrerequisitesForPackage: aPackage].
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
	stream locale: SmalltalkLocale.Hex.
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
	"Private - A filter directory has been selected. Refresh the packages list to include only
	those withing the filter directory hierarchy"

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
	fileDialog := UI.FileOpenDialog new.
	fileDialog fileTypes: self systemModel packageOpenFileDialogTypes.
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
	packages := self systemModel installPackage: aString.
	packages notEmpty 
		ifTrue: 
			[self packages: packages.
			packages last about]!

operationAbortedSignal
	"Private - Answer the signal raised when the user aborts some operation in the receiver."

	^OperationAborted!

packageManager
	"Private - Answer the current PackageManager."

	^self systemModel packageManager

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
	package isChanged ifFalse: [^self].
	mb := MessageBox new.
	mb beTaskModal.
	resp := mb
				confirmOrCancel: ('The <1p> package has unsaved changes.<n>Would you like to save it before uninstalling it?'
						expandMacrosWith: package name).
	resp == #no
		ifFalse: 
			[resp == #yes
				ifTrue: [(Cursor wait showWhile: [self savePackageChanges: {package}]) ifTrue: [^self]].
			self operationAbortedSignal signalWith: package]!

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

	self packages do: 
			[:each |
			[self uninstall: each] on: self operationAbortedSignal
				do: 
					[:e |
					e tag ~~ each
						ifTrue: 
							[MessageBox
								warning: ('Uninstallation of <1p> was aborted, but some dependent packages may have been removed'
										expandMacrosWith: each name)]]]!

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

	^{self systemModel pacFileDialogType. self systemModel paxFileDialogType}!

savePackageAs
	"Save the selected package to a user set pathname."

	| pathname package |
	package := self singlePackage.
	(self okToSavePackage: package) ifFalse: [^self].
	pathname := UI.FileSaveDialog new
				fileTypes: self saveFileDialogTypes;
				defaultExtension: Package packageExtension;
				value: (File removeExtension: package packageFileName);
				caption: ('Save Package <1p> As...' expandMacrosWith: package name);
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
	(aCollection asSortedCollection: Package defaultSortBlock) do: 
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
	^Refactory.Browser.BrowserEnvironment new forPackages: self selections!

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

sourceControl
	^Package manager sourceControl!

synchronizeFilter
	| packages |
	packages := self selections.
	self resetForItems: packages.
	self selections: packages!

systemModel
	"Private - Answer the development system model."

	^Smalltalk developmentSystem!

testBrowserClass
	^self systemModel testBrowserClass!

toggleUsingPAX
	"Toggles the use of PAX mode."

	^self packages do: [:each | each toggleUsingPAX]!

uninstall: package
	"Private - Uninstall the <Package>, package, prompting the user to first save changes (if any),
	and to remove dependent packages (if any)."

	| currentFolder |
	package isInstalled ifFalse: [^self].
	self checkCanUninstall: package.
	self confirmUninstall: package.
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
						confirm: ('<1s><n><n>Would you like to remove the class anyway?' expandMacrosWith: e description))]
		on: Notification
		do: 
			[:ex |
			self systemModel sourceManager logComment: ex description.
			ex resume].

	"Select nearest available folder in filter hierarchy"
	[currentFolder notNil and: [(self filterPresenter selection: currentFolder ifAbsent: []) isNil]]
		whileTrue: [currentFolder := currentFolder parent]! !
!Tools.PackageSelector categoriesFor: #aboutPackage!commands!public! !
!Tools.PackageSelector categoriesFor: #addClass!commands!public! !
!Tools.PackageSelector categoriesFor: #addSharedVariable!commands!public! !
!Tools.PackageSelector categoriesFor: #applicationEnvironment!public! !
!Tools.PackageSelector categoriesFor: #autoSelect!accessing!public! !
!Tools.PackageSelector categoriesFor: #autoSelect:!accessing!public! !
!Tools.PackageSelector categoriesFor: #browseFolder!commands!public! !
!Tools.PackageSelector categoriesFor: #browseIt!commands!public! !
!Tools.PackageSelector categoriesFor: #browseItCommand!helpers!private! !
!Tools.PackageSelector categoriesFor: #browsePackages!commands!public! !
!Tools.PackageSelector categoriesFor: #browseUnimplemented!public! !
!Tools.PackageSelector categoriesFor: #checkCanUninstall:!helpers!private! !
!Tools.PackageSelector categoriesFor: #clearSelection!commands!private! !
!Tools.PackageSelector categoriesFor: #commonFolder:!operations!private! !
!Tools.PackageSelector categoriesFor: #confirmUninstall:!helpers!private! !
!Tools.PackageSelector categoriesFor: #createComponents!initializing!private! !
!Tools.PackageSelector categoriesFor: #createSchematicWiring!initializing!private! !
!Tools.PackageSelector categoriesFor: #deleteItCommand!helpers!private! !
!Tools.PackageSelector categoriesFor: #filter!accessing!public! !
!Tools.PackageSelector categoriesFor: #filteredPackages!helpers!private! !
!Tools.PackageSelector categoriesFor: #filterPresenter!accessing!private! !
!Tools.PackageSelector categoriesFor: #folder!accessing!public! !
!Tools.PackageSelector categoriesFor: #folderClass!constants!private! !
!Tools.PackageSelector categoriesFor: #hasChangedPackages!private!testing! !
!Tools.PackageSelector categoriesFor: #hasPackages!private!testing! !
!Tools.PackageSelector categoriesFor: #hasSinglePackage!private!testing! !
!Tools.PackageSelector categoriesFor: #initialize!initializing!private! !
!Tools.PackageSelector categoriesFor: #inspectIt!commands!public! !
!Tools.PackageSelector categoriesFor: #inspectPackage!commands!public! !
!Tools.PackageSelector categoriesFor: #isEnabled:!accessing!public! !
!Tools.PackageSelector categoriesFor: #isSaveablePackage:!private!testing! !
!Tools.PackageSelector categoriesFor: #model:!public! !
!Tools.PackageSelector categoriesFor: #newPackage!commands!public! !
!Tools.PackageSelector categoriesFor: #okToSavePackage:!helpers!private! !
!Tools.PackageSelector categoriesFor: #onDragOverFolder:!drag & drop!event handling!private! !
!Tools.PackageSelector categoriesFor: #onDragOverPackage:!drag & drop!event handling!private! !
!Tools.PackageSelector categoriesFor: #onDragPackages:!drag & drop!event handling!private! !
!Tools.PackageSelector categoriesFor: #onDropOverFolder:!drag & drop!event handling!private! !
!Tools.PackageSelector categoriesFor: #onDropOverPackage:!drag & drop!event handling!private! !
!Tools.PackageSelector categoriesFor: #onFilterSelected!event handling!private! !
!Tools.PackageSelector categoriesFor: #onPackageChanged:!event handling!private! !
!Tools.PackageSelector categoriesFor: #onPackageChosen!event handling!private! !
!Tools.PackageSelector categoriesFor: #onPackagesChanged!event handling!private! !
!Tools.PackageSelector categoriesFor: #onSelectionChanged!event handling!private! !
!Tools.PackageSelector categoriesFor: #onSelectionChanging:!private! !
!Tools.PackageSelector categoriesFor: #onTipTextRequired:!event handling!private! !
!Tools.PackageSelector categoriesFor: #onViewOpened!event handling!public! !
!Tools.PackageSelector categoriesFor: #openPackage!commands!public! !
!Tools.PackageSelector categoriesFor: #openPackageFile:!commands!private! !
!Tools.PackageSelector categoriesFor: #operationAbortedSignal!constants!private! !
!Tools.PackageSelector categoriesFor: #packageManager!constants!private! !
!Tools.PackageSelector categoriesFor: #packages!accessing!private! !
!Tools.PackageSelector categoriesFor: #packages:!accessing!private! !
!Tools.PackageSelector categoriesFor: #packagesPresenter!accessing!private! !
!Tools.PackageSelector categoriesFor: #promptToSavePackageChanges:!helpers!private! !
!Tools.PackageSelector categoriesFor: #queryCommand:!commands!private! !
!Tools.PackageSelector categoriesFor: #refresh!private!updating! !
!Tools.PackageSelector categoriesFor: #removePackage!commands!public! !
!Tools.PackageSelector categoriesFor: #resetChangeFlags!commands!public! !
!Tools.PackageSelector categoriesFor: #resetForItem:!event handling!private! !
!Tools.PackageSelector categoriesFor: #resetForItems:!operations!private! !
!Tools.PackageSelector categoriesFor: #rootFolder!accessing!private! !
!Tools.PackageSelector categoriesFor: #saveFileDialogTypes!constants!private! !
!Tools.PackageSelector categoriesFor: #savePackageAs!commands!public! !
!Tools.PackageSelector categoriesFor: #savePackageChanges!commands!public! !
!Tools.PackageSelector categoriesFor: #savePackageChanges:!commands!public! !
!Tools.PackageSelector categoriesFor: #savePackages!commands!public! !
!Tools.PackageSelector categoriesFor: #savePackages:!commands!public! !
!Tools.PackageSelector categoriesFor: #savePackages:toFolder:!helpers!private! !
!Tools.PackageSelector categoriesFor: #selectableItems!accessing!private! !
!Tools.PackageSelector categoriesFor: #selectedFolder!commands!public! !
!Tools.PackageSelector categoriesFor: #selectedSourceObjects!accessing!private! !
!Tools.PackageSelector categoriesFor: #selectionEnvironment!accessing!private! !
!Tools.PackageSelector categoriesFor: #selectNoFolder!public! !
!Tools.PackageSelector categoriesFor: #selectRootFolder!public! !
!Tools.PackageSelector categoriesFor: #setAsDefaultPackage!commands!private! !
!Tools.PackageSelector categoriesFor: #singlePackage!accessing!private! !
!Tools.PackageSelector categoriesFor: #sourceControl!accessing!private! !
!Tools.PackageSelector categoriesFor: #synchronizeFilter!commands!private! !
!Tools.PackageSelector categoriesFor: #systemModel!accessing!private! !
!Tools.PackageSelector categoriesFor: #testBrowserClass!constants!private! !
!Tools.PackageSelector categoriesFor: #toggleUsingPAX!commands!public! !
!Tools.PackageSelector categoriesFor: #uninstall:!commands!private! !

!Tools.PackageSelector class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^PackageHierarchyModel new!

getCommandQueryHandlers
	^commandQueryHandlers!

resource_Choice_view
	"Answer the literal data from which the 'Choice view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Choice_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1376774 ##(UI.ProportionalLayout) 170 176 34 4 410 ##(UI.ListView) 34 45 nil 416 34 2 8 1140920397 1025 544 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1769478 ##(Kernel.IdentitySearchPolicy) 917510 ##(Graphics.Color) #default nil 21 461638 4 ##(UI.Menu) nil true 34 9 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #synchronizeFilter 8 '&Goto Folder' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 786 1 818 #newPackage 8 '&New Package...' 1 1 nil nil nil 786 1 818 #savePackages 8 '&Save' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'FileSave.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 786 1 818 #savePackageAs 8 'Save &As...' 1 1 nil nil nil 738 nil true 34 10 786 1 818 #toggleUsingPAX 8 'Use PA&X Source Format' 1 1 nil nil nil 786 1 818 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 866 4097 786 1 818 #checkOut 8 'Check Out &All' 1 1 nil nil nil 786 1 818 #checkOutChanges 8 'Check &Out Changes' 1 1 nil nil nil 786 1 818 #checkIn 8 'Check &In' 1 1 nil nil nil 866 4097 786 2097153 818 #savePackageChanges 8 'Save &Changes' 1 1 nil nil nil 866 4097 786 1 818 #resetChangeFlags 8 'Clear Change &Markers' 1 1 nil nil nil 8 'Sou&rce Control' #sourceControlMenu 1 nil nil nil nil nil 866 4097 786 1 818 #inspectPackage 8 '&Properties' 1 1 994 nil true 1040 8 'SMALLTALKOPTIONSFOLDER.ICO' 1088 nil nil 786 1 818 #aboutPackage 8 'Abou&t this Package...' 1 1 nil nil nil 8 '&Package' nil 134217729 nil nil nil nil nil nil nil 544 nil 8 1801282304 786950 ##(Core.Message) #name 8 #() ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | 
ctx item isDefaultPackage ifTrue: [
	ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 1872 7 257 nil nil nil nil 138 144 34 2 1117254 5 ##(UI.ListViewColumn) 8 '' 41 #left nil 1858 0 nil 1890 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 2048 7 513 nil 1778 #isChanged 8 #() nil 544 1858 0 nil 1890 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 1049094 ##(Core.Association) #Package ##(Kernel.Package) #changedIcon #imageIndex 2160 7 257 nil 1 nil nil 2002 8 'Packages' 689 #left ##(UI.BasicListAbstract) 1858 0 nil 1890 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 2304 7 513 nil nil nil 544 ##(UI.IconicListAbstract) 3 nil 1858 0 nil 1890 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | 
ctx item isDefaultPackage ifTrue: [
	ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 2384 7 257 nil #report 8 #() nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 1 237 2594 737 229 544 2546 #contextMenu: 34 1 752 544 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 118 0 0 0 112 1 0 0 232 0 0 0] 8 #() 2594 193 193 nil 35 3 410 ##(UI.TreeView) 34 27 nil 416 34 2 8 1140916771 1025 2752 787526 3 ##(UI.TreeModel) nil 688 721670 ##(UI.TreeNode) nil nil nil 170 192 656 720 nil 5 738 nil true 34 1 786 1 818 #newPackage 8 '&New Package...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2752 nil 8 1801125840 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 1840 nil nil nil nil nil 170 176 656 nil #smallIcons 1 170 192 656 2482 138 144 34 2 2546 #createAt:extent: 34 2 2594 1 1 2594 737 227 2752 2546 #contextMenu: 34 1 2896 2752 2674 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 1 0 0 113 0 0 0] 8 #() 2736 nil 27 3 true 170 192 34 4 544 8 'packages' 2752 8 'filter' nil 2482 138 144 34 1 2546 #createAt:extent: 34 2 2594 6143 21 2594 737 465 416 2674 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 111 13 0 0 242 0 0 0] 34 3 2752 410 ##(UI.Splitter) 34 12 nil 416 34 2 8 1140850688 1 3456 nil nil nil 517 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 3456 nil 1 #left nil nil nil 2594 1 1 2594 9 9 nil 3552 nil 2482 138 144 34 1 2546 #createAt:extent: 34 2 2594 1 227 2594 737 11 3456 2674 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 113 0 0 0 112 1 0 0 118 0 0 0] 8 #() 2736 nil 27 544 2736 nil 27 )!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 21 nil nil nil 416 1376774 ##(UI.ProportionalLayout) 170 176 34 4 410 ##(UI.ListView) 34 45 nil 416 34 2 8 1140920393 1025 544 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1769478 ##(Kernel.IdentitySearchPolicy) 917510 ##(Graphics.Color) #default nil 29 461638 4 ##(UI.Menu) nil true 34 18 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #newPackage 8 '&New Package...' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'NewPackage.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 786 1 818 #openPackage 8 '&Install Package...' 1 1 866 nil true 912 8 'FileOpen.ico' 960 nil nil 786 1 818 #removePackage 8 '&Uninstall Package' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 738 nil true 34 2 786 2097153 818 #addClass 8 '&Class...' 1 1 866 nil true 912 8 'Behavior.ico' 960 nil nil 786 1 818 #addSharedVariable 8 '&Global...' 1 1 nil nil nil 8 'Add Unco&mmitted' #addMenu 134217729 nil nil nil nil nil 786 1 818 #setAsDefaultPackage 8 'Set as De&fault Package' 1 1 nil nil nil 786 1 818 #synchronizeFilter 8 '&Goto Folder' 1 1 nil nil nil 1122 4097 786 1 818 #savePackages 8 '&Save Package' 1 1 866 nil true 912 8 'FileSave.ico' 960 nil nil 786 1 818 #savePackageChanges 8 'Save Package C&hanges' 1 1 nil nil nil 786 1 818 #savePackageAs 8 'Save Package &As...' 1 1 nil nil nil 1122 4097 786 1 818 #toggleUsingPAX 8 'Use PA&X Source Format' 1 1 nil nil nil 786 1 818 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 1122 4097 738 nil true 34 4 786 2097153 818 #deploy 8 '&Deploy Executable...' 13445 1 nil nil nil 786 1 818 #browseDeployed 8 'Bro&wse Executable Manifest' 1 1 nil nil nil 1122 4097 786 1 818 #saveBinaryPackage 8 'Deploy &Binary Package...' 1 1 nil nil nil 8 '&Deployment' nil 134217729 866 nil true 912 8 'ApplicationDeploymentWizard.ico' 960 nil nil nil nil 1122 4097 786 1 818 #inspectPackage 8 'P&roperties' 1 1 866 nil true 912 8 'BasicInspector.ico' 960 nil nil 8 '&Package' nil 134217729 nil nil nil nil nil nil nil 544 nil 8 1801282304 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | 
ctx item isDefaultPackage ifTrue: [
	ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 2160 7 257 nil 918022 ##(Graphics.Point) 65 65 nil nil 138 144 34 2 1117254 5 ##(UI.ListViewColumn) 8 'Packages' 669 #left ##(UI.BasicListAbstract) 2146 0 nil 2178 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 2368 7 513 nil nil nil 544 ##(UI.IconicListAbstract) 3 nil 2146 0 nil 2178 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | 
ctx item isDefaultPackage ifTrue: [
	ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 2448 7 257 nil 2322 8 '' 33 #left 2146 0 nil 2178 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 2560 7 257 nil 2146 0 nil 2178 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 2672 7 513 nil 786950 ##(Core.Message) #isChanged 8 #() nil 544 2146 0 nil 2178 6 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | (x ifTrue: [Package changedIcon] ifFalse: [Icon blank]) imageIndex]' 8 #[34 105 17 120 45 159 111 47 161 162 106] 1049094 ##(Core.Association) #Package ##(Kernel.Package) #changedIcon 2882 #Icon 864 #blank #imageIndex 2800 7 257 nil 1 nil nil #report 8 #() nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 4 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 2258 1 221 2258 701 281 544 3010 #contextMenu: 34 1 752 544 3010 #text: 34 1 8 'Packages' 544 3010 #columnOrder: 34 1 8 #(2 1) 544 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 110 0 0 0 94 1 0 0 250 0 0 0] 8 #() 2258 193 193 nil 35 9 410 ##(UI.TreeView) 34 27 nil 416 34 2 8 1140916771 1025 3296 787526 3 ##(UI.TreeModel) nil 688 721670 ##(UI.TreeNode) nil nil nil 170 192 656 720 nil 29 738 nil true 34 2 786 1 818 #browseFolder 8 '&Browse Folder' 1 1 nil nil nil 786 1 818 #newPackage 8 '&New Package...' 1 1 866 nil true 912 8 'NewPackage.ico' 960 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3296 nil 8 1801125840 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 2128 nil nil nil nil nil 170 176 656 nil #smallIcons 1 170 192 656 2946 138 144 34 2 3010 #createAt:extent: 34 2 2258 1 1 2258 701 211 3296 3010 #contextMenu: 34 1 3440 3296 3218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 105 0 0 0] 8 #() 3280 nil 27 7 true 170 192 34 4 544 8 'packages' 3296 8 'filter' nil 2946 138 144 34 1 3010 #createAt:extent: 34 2 2258 6143 21 2258 701 501 416 3218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 93 13 0 0 4 1 0 0] 34 3 3296 410 ##(UI.Splitter) 34 12 nil 416 34 2 8 1140850688 1 4080 nil nil nil 517 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 4080 nil 1 #left nil nil nil 2258 1 1 2258 9 9 nil 4176 nil 2946 138 144 34 1 3010 #createAt:extent: 34 2 2258 1 211 2258 701 11 4080 3218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 0 0 0 94 1 0 0 110 0 0 0] 8 #() 3280 nil 27 544 3280 nil 27 )!

resource_Single_package_selector
	"Answer the literal data from which the 'Single package selector' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Single_package_selector)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 21 nil nil nil 416 1376774 ##(UI.ProportionalLayout) 170 176 34 4 410 ##(UI.ListView) 34 45 nil 416 34 2 8 1140920397 1025 544 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1769478 ##(Kernel.IdentitySearchPolicy) 917510 ##(Graphics.Color) #default nil 21 461638 4 ##(UI.Menu) nil true 34 19 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #synchronizeFilter 8 '&Goto Folder' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 786 1 818 #setAsDefaultPackage 8 'Set as De&fault Package' 1 1 nil nil nil 738 nil true 34 2 786 2097153 818 #addClass 8 '&Class...' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'Class.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 786 1 818 #addSharedVariable 8 '&Global...' 1 1 nil nil nil 8 'Add Unco&mmitted' #addMenu 134217729 nil nil nil nil nil 866 4097 786 1 818 #newPackage 8 '&New Package...' 1 1 nil nil nil 786 1 818 #openPackage 8 '&Install Package...' 1 1 nil nil nil 786 1 818 #removePackage 8 '&Uninstall' 1 1 nil nil nil 866 4097 786 1 818 #savePackages 8 '&Save' 1 1 1026 nil true 1072 8 'FileSave.ico' 1120 nil nil 786 1 818 #savePackageAs 8 'Save &As...' 1 1 nil nil nil 866 4097 738 nil true 34 10 786 1 818 #toggleUsingPAX 8 'Use PA&X Source Format' 1 1 nil nil nil 786 2097153 818 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 866 4097 786 1 818 #checkOut 8 'Check Out &All' 1 1 nil nil nil 786 1 818 #checkOutChanges 8 'Check &Out Changes' 1 1 nil nil nil 786 1 818 #checkIn 8 'Check &In' 1 1 nil nil nil 866 4097 786 1 818 #savePackageChanges 8 'Save &Changes' 1 1 nil nil nil 866 4097 786 1 818 #resetChangeFlags 8 'Clear Change &Markers' 1 1 nil nil nil 8 'Sou&rce Control' #sourceControlMenu 1 nil nil nil nil nil 866 4097 786 1 818 #deploy 8 '&Deploy Executable...' 1 1 nil nil nil 786 1 818 #saveBinaryPackage 8 'Deploy &Binary Package...' 1 1 nil nil nil 866 4097 786 1 818 #inspectPackage 8 '&Properties' 1 1 1026 nil true 1072 8 'SMALLTALKOPTIONSFOLDER.ICO' 1120 nil nil 786 1 818 #aboutPackage 8 'Abou&t this Package...' 1 1 nil nil nil 8 '&Package' nil 134217729 nil nil nil nil nil nil nil 544 nil 8 1801282304 786950 ##(Core.Message) #name 8 #() ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 2352 7 257 nil nil nil nil 138 144 34 2 1117254 5 ##(UI.ListViewColumn) 8 '' 41 #left nil 2338 0 nil 2370 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] #not #& 2528 7 513 nil 2258 #isChanged 8 #() nil 544 2338 0 nil 2370 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 1049094 ##(Core.Association) #Package ##(Kernel.Package) #changedIcon #imageIndex 2640 7 257 nil 1 nil nil 2482 8 'Packages' 653 #left ##(UI.BasicListAbstract) 2338 0 nil 2370 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 2784 7 513 nil nil nil 544 ##(UI.IconicListAbstract) 3 nil 2338 0 nil 2370 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 2864 7 257 nil #report 8 #() nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 1 221 3074 701 281 544 3026 #contextMenu: 34 1 752 544 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 110 0 0 0 94 1 0 0 250 0 0 0] 8 #() 3074 193 193 nil 35 9 410 ##(UI.TreeView) 34 27 nil 416 34 2 8 1140916771 1025 3232 787526 3 ##(UI.TreeModel) nil 688 721670 ##(UI.TreeNode) nil nil nil 170 192 656 720 nil 5 738 nil true 34 1 786 1 818 #newPackage 8 '&New Package...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3232 nil 8 1801125840 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 2320 nil nil nil nil nil 170 176 656 nil #smallIcons 1 170 192 656 2962 138 144 34 2 3026 #createAt:extent: 34 2 3074 1 1 3074 701 211 3232 3026 #contextMenu: 34 1 3376 3232 3154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 105 0 0 0] 8 #() 3216 nil 27 7 true 170 192 34 4 544 8 'packages' 3232 8 'filter' nil 2962 138 144 34 1 3026 #createAt:extent: 34 2 3074 6143 21 3074 701 501 416 3154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 93 13 0 0 4 1 0 0] 34 3 3232 410 ##(UI.Splitter) 34 12 nil 416 34 2 8 1140850688 1 3936 nil nil nil 517 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 3936 nil 1 #left nil nil nil 3074 1 1 3074 9 9 nil 4032 nil 2962 138 144 34 1 3026 #createAt:extent: 34 2 3074 1 211 3074 701 11 3936 3154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 0 0 0 94 1 0 0 110 0 0 0] 8 #() 3216 nil 27 544 3216 nil 27 )!

setCommandQueryHandlers: anArray 
	commandQueryHandlers := anArray! !
!Tools.PackageSelector class categoriesFor: #defaultModel!models!public! !
!Tools.PackageSelector class categoriesFor: #getCommandQueryHandlers!accessing!private! !
!Tools.PackageSelector class categoriesFor: #resource_Choice_view!public!resources-views! !
!Tools.PackageSelector class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.PackageSelector class categoriesFor: #resource_Single_package_selector!public!resources-views! !
!Tools.PackageSelector class categoriesFor: #setCommandQueryHandlers:!accessing!private! !

