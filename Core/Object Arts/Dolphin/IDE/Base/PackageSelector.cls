"Filed out from Dolphin Smalltalk 7"!

SelectableItemsPresenter subclass: #PackageSelector
	instanceVariableNames: 'filterPresenter packagesPresenter autoSelect'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'commandQueryHandlers'!
PackageSelector guid: (GUID fromString: '{D41AF949-F919-4F5F-986D-A50606BA68E9}')!
PackageSelector comment: 'A PackageSelector is used to choose a Package from the complete set of packages available in the development system. It presents two panes; a hierarchical display of the folders in which the packages reside and a list of available packages. The folder display can be used as a filter to refine which packages are displayed in the list. When a folder is selected, only packages in the hierarchy beneath it are visible.

Instance Variables:
	filterPresenter		<treePresenter> showing the folders in which packages reside
	packagesPresenter		<listPresenter> showing the packages filtered by the selected folder

'!
!PackageSelector categoriesForClass!Development!MVP-Presenters!MVP-Resources-Misc! !
!PackageSelector methodsFor!

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

addGlobal
	"Request an available global object to add the receivers current package. Only
	globals which are not currently owned by any other package are shown."

	| globalNames pack pacman |
	pack := self singlePackage.
	globalNames := pack environment keys.
	pacman := self packageManager.
	globalNames
		removeAll: (pack environment allClasses collect: [:aClass | aClass name]);
		removeAll: pacman allPackagedGlobalNames.
	globalNames isEmpty 
		ifTrue: [MessageBox notify: 'All Global objects are currently owned by packages']
		ifFalse: 
			[| globals |
			globals := ChoicePrompter multipleChoices: globalNames asSortedCollection
						caption: 'Add global objects to ' , pack name , ' package'.
			globals notNil ifTrue: [globals do: [:each | pacman addGlobalNamed: each to: pack]]]!

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
	[self systemModel browseFolder: folder] on: Win32Error
		do: [:ex | MessageBox errorMsg: ex messageText caption: ('Unable to browse <1p>...' expandMacrosWith: folder)]!

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
		caption: ('Unimplemented Selectors in <1d> (and prerequisites)' expandMacrosWith: sendingEnvironment)
		environment: implementingEnvironment!

checkCanUninstall: package
	"Private - Uninstallation of the <Package>, package, has been initiated. Verify that it can be uninstalled
	and if not inform the user accordingly and abort the operation."

	| err |
	[package okToUninstall] on: Error do: [:ex | err := ex].
	err notNil ifTrue: [
		MessageBox errorMsg: err description.
		^self operationAbortedSignal signalWith: package]!

clearSelection
	"Private - Remove the selected object from the system"

	self perform: self deleteItCommand!

commonFolder: aCollectionOfPackages 
	| commonPrefix |
	commonPrefix := nil.
	aCollectionOfPackages do: 
			[:each | 
			commonPrefix := commonPrefix 
						ifNil: [File splitPathFrom: each packagePathname]
						ifNotNil: [File commonPrefixOf: commonPrefix and: each packagePathname]].
	^(commonPrefix notNil and: [commonPrefix notEmpty]) 
		ifTrue: [self folderClass pathname: (File appendPathDelimiter: commonPrefix)]!

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
	(self filterPresenter)
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
	(self packagesPresenter)
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
	(Package manager)
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

	^aPackage ~= self packageManager systemPackage 
		or: [Smalltalk developmentSystem isOAD]!

model: aPackageHierarchyModel 
	super model: aPackageHierarchyModel.
	filterPresenter model: aPackageHierarchyModel!

newPackage
	"Request the name of a new Package to add to the PackageManager."

	| pathname dialog directory |
	directory := File fullPathOf: self filter relativeTo: SessionManager current imageBase.
	[File createDirectoryPath: directory] on: Win32Error
		do: 
			[:ex | 
			"User probably doesn't have access rights"
			].
	dialog := (FileSaveDialog new)
				initialDirectory: directory;
				fileTypes: (Array with: self systemModel pacFileDialogType);
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
					self packages: (Array with: package)] 
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
			[#(#CompiledMethod #Class #ResourceIdentifier #GlobalSymbol) 
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
	targetPackage isNil ifTrue: [ Sound errorBeep. ^false ].

	packageManager := Package manager.

	Cursor wait showWhile: [
		session dragObjects do: [:each |
			"See if the drop is a CompiledMethod"
			(each isFormatAvailable: #CompiledMethod) ifTrue: [ | method |
				method := each format: #CompiledMethod.
				packageManager addMethod: method to: targetPackage ].
	
			(each isFormatAvailable: #ResourceIdentifier) ifTrue: [ | resource |
				resource := each format: #ResourceIdentifier.
				packageManager addResourceIdentifier: resource to: targetPackage ].

			(each isFormatAvailable: #GlobalSymbol) ifTrue: [ | global |
				global := each format: #GlobalSymbol.
				packageManager addGlobalNamed: global to: targetPackage ].

			(each isFormatAvailable: #Class) ifTrue: [ | class |
				class := each format: #Class.
				packageManager addClass: class to: targetPackage ]]].
	
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
	fileDialog := FileOpenDialog new.
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
				ifTrue: [(Cursor wait showWhile: [self savePackageChanges: (Array with: package)]) ifTrue: [^self]].
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
	(#(#addClass #addGlobal #savePackageAs #addMenu) identityIncludes: selector) 
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
			[aCommandQuery isEnabled: (self hasPackages and: [self packages allSatisfy: [:each | self isSaveablePackage: each]]).
			^true].
	selector == #savePackageChanges
		ifTrue: 
			[aCommandQuery isEnabled: (self hasChangedPackages and: [self packages allSatisfy: [:each | self isSaveablePackage: each]]).
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
			aCommandQuery 
				isEnabled: (packages notEmpty and: [(self commonFolder: packages) ~= self filter]).
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
			[filterPresenter selection: (self commonFolder: aCollectionOfPackages).
			self selections: aCollectionOfPackages]!

rootFolder
	^self folderClass root!

saveFileDialogTypes
	"Private - Answer a file types array for use with a FileDialog to save packages."

	^Array with: self systemModel pacFileDialogType with: self systemModel paxFileDialogType!

savePackageAs
	"Save the selected package to a user set pathname."

	| pathname package |
	package := self singlePackage.
	(self okToSavePackage: package) ifFalse: [^self].
	pathname := (FileSaveDialog new)
				fileTypes: self saveFileDialogTypes;
				defaultExtension: Package packageExtension;
				value: (File removeExtension: package packageFileName);
				caption: ('Save Package <1p> As...' expandMacrosWith: package name);
				showModal.
	pathname notNil 
		ifTrue: 
			[package saveAs: pathname.
			self packages: (Array with: package)]!

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
	self resetForItems: self selections!

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
!PackageSelector categoriesFor: #aboutPackage!commands!public! !
!PackageSelector categoriesFor: #addClass!commands!public! !
!PackageSelector categoriesFor: #addGlobal!commands!public! !
!PackageSelector categoriesFor: #applicationEnvironment!public! !
!PackageSelector categoriesFor: #autoSelect!accessing!public! !
!PackageSelector categoriesFor: #autoSelect:!accessing!public! !
!PackageSelector categoriesFor: #browseFolder!commands!public! !
!PackageSelector categoriesFor: #browseIt!commands!public! !
!PackageSelector categoriesFor: #browseItCommand!helpers!private! !
!PackageSelector categoriesFor: #browsePackages!commands!public! !
!PackageSelector categoriesFor: #browseUnimplemented!public! !
!PackageSelector categoriesFor: #checkCanUninstall:!helpers!private! !
!PackageSelector categoriesFor: #clearSelection!commands!private! !
!PackageSelector categoriesFor: #commonFolder:!operations!private! !
!PackageSelector categoriesFor: #confirmUninstall:!helpers!private! !
!PackageSelector categoriesFor: #createComponents!initializing!private! !
!PackageSelector categoriesFor: #createSchematicWiring!initializing!private! !
!PackageSelector categoriesFor: #deleteItCommand!helpers!private! !
!PackageSelector categoriesFor: #filter!accessing!public! !
!PackageSelector categoriesFor: #filteredPackages!helpers!private! !
!PackageSelector categoriesFor: #filterPresenter!accessing!private! !
!PackageSelector categoriesFor: #folder!accessing!public! !
!PackageSelector categoriesFor: #folderClass!constants!private! !
!PackageSelector categoriesFor: #hasChangedPackages!private!testing! !
!PackageSelector categoriesFor: #hasPackages!private!testing! !
!PackageSelector categoriesFor: #hasSinglePackage!private!testing! !
!PackageSelector categoriesFor: #initialize!initializing!private! !
!PackageSelector categoriesFor: #inspectIt!commands!public! !
!PackageSelector categoriesFor: #inspectPackage!commands!public! !
!PackageSelector categoriesFor: #isEnabled:!accessing!public! !
!PackageSelector categoriesFor: #isSaveablePackage:!private!testing! !
!PackageSelector categoriesFor: #model:!public! !
!PackageSelector categoriesFor: #newPackage!commands!public! !
!PackageSelector categoriesFor: #okToSavePackage:!helpers!private! !
!PackageSelector categoriesFor: #onDragOverFolder:!drag & drop!event handling!private! !
!PackageSelector categoriesFor: #onDragOverPackage:!drag & drop!event handling!private! !
!PackageSelector categoriesFor: #onDragPackages:!drag & drop!event handling!private! !
!PackageSelector categoriesFor: #onDropOverFolder:!drag & drop!event handling!private! !
!PackageSelector categoriesFor: #onDropOverPackage:!drag & drop!event handling!private! !
!PackageSelector categoriesFor: #onFilterSelected!event handling!private! !
!PackageSelector categoriesFor: #onPackageChanged:!event handling!private! !
!PackageSelector categoriesFor: #onPackageChosen!event handling!private! !
!PackageSelector categoriesFor: #onPackagesChanged!event handling!private! !
!PackageSelector categoriesFor: #onSelectionChanged!event handling!private! !
!PackageSelector categoriesFor: #onSelectionChanging:!private! !
!PackageSelector categoriesFor: #onTipTextRequired:!event handling!private! !
!PackageSelector categoriesFor: #onViewOpened!event handling!public! !
!PackageSelector categoriesFor: #openPackage!commands!public! !
!PackageSelector categoriesFor: #openPackageFile:!commands!private! !
!PackageSelector categoriesFor: #operationAbortedSignal!constants!private! !
!PackageSelector categoriesFor: #packageManager!constants!private! !
!PackageSelector categoriesFor: #packages!accessing!private! !
!PackageSelector categoriesFor: #packages:!accessing!private! !
!PackageSelector categoriesFor: #packagesPresenter!accessing!private! !
!PackageSelector categoriesFor: #promptToSavePackageChanges:!helpers!private! !
!PackageSelector categoriesFor: #queryCommand:!commands!private! !
!PackageSelector categoriesFor: #refresh!private!updating! !
!PackageSelector categoriesFor: #removePackage!commands!public! !
!PackageSelector categoriesFor: #resetChangeFlags!commands!public! !
!PackageSelector categoriesFor: #resetForItem:!event handling!private! !
!PackageSelector categoriesFor: #resetForItems:!operations!private! !
!PackageSelector categoriesFor: #rootFolder!accessing!private! !
!PackageSelector categoriesFor: #saveFileDialogTypes!constants!private! !
!PackageSelector categoriesFor: #savePackageAs!commands!public! !
!PackageSelector categoriesFor: #savePackageChanges!commands!public! !
!PackageSelector categoriesFor: #savePackageChanges:!commands!public! !
!PackageSelector categoriesFor: #savePackages!commands!public! !
!PackageSelector categoriesFor: #savePackages:!commands!public! !
!PackageSelector categoriesFor: #savePackages:toFolder:!helpers!private! !
!PackageSelector categoriesFor: #selectableItems!accessing!private! !
!PackageSelector categoriesFor: #selectedFolder!commands!public! !
!PackageSelector categoriesFor: #selectedSourceObjects!accessing!private! !
!PackageSelector categoriesFor: #selectionEnvironment!accessing!private! !
!PackageSelector categoriesFor: #selectNoFolder!public! !
!PackageSelector categoriesFor: #selectRootFolder!public! !
!PackageSelector categoriesFor: #setAsDefaultPackage!commands!private! !
!PackageSelector categoriesFor: #singlePackage!accessing!private! !
!PackageSelector categoriesFor: #synchronizeFilter!commands!private! !
!PackageSelector categoriesFor: #systemModel!accessing!private! !
!PackageSelector categoriesFor: #testBrowserClass!constants!private! !
!PackageSelector categoriesFor: #toggleUsingPAX!commands!public! !
!PackageSelector categoriesFor: #uninstall:!commands!private! !

!PackageSelector class methodsFor!

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Choice_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 4 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140920397 1025 608 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  498 528 0 21 265030 4 ##(Smalltalk.Menu)  0 16 98 9 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #synchronizeFilter 8 '&Goto Folder' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 850 1 882 8 #newPackage 8 '&New Package...' 1 1 0 0 0 850 1 882 8 #savePackages 8 '&Save' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'FileSave.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 850 1 882 8 #savePackageAs 8 'Save &As...' 1 1 0 0 0 802 0 16 98 10 850 1 882 8 #toggleUsingPAX 8 'Use PA&X Source Format' 1 1 0 0 0 850 1 882 8 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 0 0 0 946 4097 850 1 882 8 #checkOut 8 'Check Out &All' 1 1 0 0 0 850 1 882 8 #checkOutChanges 8 'Check &Out Changes' 1 1 0 0 0 850 1 882 8 #checkIn 8 'Check &In' 1 1 0 0 0 946 4097 850 2097153 882 8 #savePackageChanges 8 'Save &Changes' 1 1 0 0 0 946 4097 850 1 882 8 #resetChangeFlags 8 'Clear Change &Markers' 1 1 0 0 0 8 'Sou&rce Control' 8 #sourceControlMenu 1 0 0 0 0 0 946 4097 850 1 882 8 #inspectPackage 8 '&Properties' 1 1 1106 0 16 1152 8 'SMALLTALKOPTIONSFOLDER.ICO' 1200 0 0 850 1 882 8 #aboutPackage 8 'Abou&t this Package...' 1 1 0 0 0 8 '&Package' 0 134217729 0 0 0 0 0 0 0 608 0 8 4294903801 459270 ##(Smalltalk.Message)  8 #name 98 0 8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  5 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:ctx | 
ctx item isDefaultPackage ifTrue: [
	ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] 8 #item 8 #isDefaultPackage 8 #font 8 #beBold 2192 7 257 0 0 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn)  8 '' 41 8 #left 0 2178 0 0 2210 3 1 2240 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] 8 #not 8 #& 2464 7 513 0 2066 8 #isChanged 98 0 0 608 2178 0 0 2210 4 1 2240 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 721414 ##(Smalltalk.Association)  8 #Package 8 ##(Smalltalk.Package)  8 #changedIcon 8 #imageIndex 2624 7 257 0 1 0 0 2402 8 'Packages' 689 2448 8 ##(Smalltalk.BasicListAbstract)  2178 0 0 2210 2 1 2240 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] 2096 2848 7 513 0 0 0 608 2128 3 0 2178 0 0 2210 5 1 2240 8 'doIt' 8 '[:ctx | 
ctx item isDefaultPackage ifTrue: [
	ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] 2304 2320 2336 2352 2928 7 257 0 8 #report 736 0 133221 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 237 3154 737 229 608 3090 8 #contextMenu: 98 1 816 608 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 118 0 0 0 112 1 0 0 232 0 0 0] 98 0 3154 193 193 0 27 3 410 8 ##(Smalltalk.TreeView)  98 27 0 416 98 2 8 1140916259 1025 3328 590918 3 ##(Smalltalk.TreeModel)  0 768 525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 736 498 528 0 5 802 0 16 98 1 850 1 882 1008 8 '&New Package...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 3328 0 8 4294903619 2832 2128 2160 0 0 0 0 0 234 240 736 17 8 #smallIcons 1 0 3026 202 208 98 2 3090 3120 98 2 3154 1 1 3154 737 227 3328 3090 3216 98 1 3504 3328 3250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 1 0 0 113 0 0 0] 98 0 3312 0 27 3 16 234 256 98 4 608 8 'packages' 3328 8 'filter' 0 3026 202 208 98 1 3090 3120 98 2 3154 2799 21 3154 737 465 416 3250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 231 6 0 0 242 0 0 0] 98 3 3328 410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 4064 0 498 528 0 517 0 0 0 4064 3026 202 208 98 1 3090 3120 98 2 3154 1 227 3154 737 11 4064 3250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 113 0 0 0 112 1 0 0 118 0 0 0] 98 0 3312 0 27 608 3312 0 27 )!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 21 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 4 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140920393 1 608 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  498 528 0 29 265030 4 ##(Smalltalk.Menu)  0 16 98 24 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #newPackage 8 '&New Package...' 1 1 0 0 0 850 1 882 8 #openPackage 8 '&Install Package...' 1 1 0 0 0 850 1 882 8 #removePackage 8 '&Uninstall Package' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 802 0 16 98 2 850 2097153 882 8 #addClass 8 '&Class...' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'Class.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 850 1 882 8 #addGlobal 8 '&Global...' 1 1 0 0 0 8 'Add Unco&mmitted' 8 #addMenu 134217729 0 0 0 0 0 850 1 882 8 #setAsDefaultPackage 8 'Set as De&fault Package' 1 1 0 0 0 850 1 882 8 #synchronizeFilter 8 '&Goto Folder' 1 1 0 0 0 1074 4097 850 1 882 8 #savePackages 8 '&Save Package' 1 1 1202 0 16 1248 8 'FileSave.ico' 1296 0 0 850 1 882 8 #savePackageChanges 8 'Save Package C&hanges' 1 1 0 0 0 850 1 882 8 #savePackageAs 8 'Save Package &As...' 1 1 0 0 0 1074 4097 850 1 882 8 #toggleUsingPAX 8 'Use PA&X Source Format' 1 1 0 0 0 850 1 882 8 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 0 0 0 1074 4097 850 1 882 8 #loadPackageFromRepository 8 'Load Edition...' 1 1 0 0 0 850 1 882 8 #importPackageFromFile 8 'Import to Repository...' 1 5 0 0 0 850 1 882 8 #versionPackage 8 'Version...' 1 1 0 0 0 850 1 882 8 #browsePackageEditions 8 'Browse Editions' 1 1 0 0 0 850 1 882 8 #compareWithAnotherEdition 8 'Compare with...' 1 1 0 0 0 1074 4097 802 0 16 98 4 850 2097153 882 8 #deploy 8 '&Deploy Executable...' 13445 1 0 0 0 850 1 882 8 #browseDeployed 8 'Bro&wse Executable Manifest' 1 1 0 0 0 1074 4097 850 1 882 8 #saveBinaryPackage 8 'Deploy &Binary Package...' 1 1 0 0 0 8 '&Deployment' 0 134217729 1202 0 16 1248 8 'ApplicationDeploymentWizard.ico' 1296 0 0 0 0 1074 4097 850 1 882 8 #inspectPackage 8 'P&roperties' 1 1 1202 0 16 1248 8 'SMALLTALKOPTIONSFOLDER.ICO' 1296 0 0 8 '&Package' 0 134217729 0 0 0 0 0 0 0 608 0 8 4294902131 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  5 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:ctx | 
ctx item isDefaultPackage ifTrue: [
	ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] 8 #item 8 #isDefaultPackage 8 #font 8 #beBold 2800 7 257 0 328198 ##(Smalltalk.Point)  65 65 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn)  8 'Packages' 669 8 #left 2720 2786 0 0 2818 2 1 2848 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] 8 #name 3104 7 513 0 0 0 608 2736 3 0 2786 0 0 2818 5 1 2848 8 'doIt' 8 '[:ctx | 
ctx item isDefaultPackage ifTrue: [
	ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] 2912 2928 2944 2960 3200 7 257 0 3042 8 '' 33 3088 2786 0 0 2818 3 1 2848 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 3312 7 257 0 2786 0 0 2818 3 1 2848 8 'doIt' 8 '[:x : y | x & y not]' 8 #[31 105 233 1 158 177 106] 8 #not 8 #& 3424 7 513 0 459270 ##(Smalltalk.Message)  8 #isChanged 98 0 0 608 2786 0 0 2818 6 1 2848 8 'doIt' 8 '[:x | (x ifTrue: [Package changedIcon] ifFalse: [Icon blank]) imageIndex]' 8 #[34 105 17 120 45 159 111 47 161 162 106] 721414 ##(Smalltalk.Association)  8 #Package 8 ##(Smalltalk.Package)  8 #changedIcon 3682 8 #Icon 1200 8 #blank 8 #imageIndex 3600 7 257 0 1 0 0 8 #report 736 0 133221 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 4 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 2978 1 221 2978 701 281 608 3906 8 #contextMenu: 98 1 816 608 3906 8 #text: 98 1 8 'Packages' 608 3906 8 #columnOrder: 98 1 98 2 5 3 608 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 110 0 0 0 94 1 0 0 250 0 0 0] 98 0 2978 193 193 0 27 9 410 8 ##(Smalltalk.TreeView)  98 27 0 416 98 2 8 1140916259 1 4256 590918 3 ##(Smalltalk.TreeModel)  0 768 525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 736 498 528 0 29 802 0 16 98 2 850 1 882 8 #browseFolder 8 '&Browse Folder' 1 1 0 0 0 850 1 882 912 8 '&New Package...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 4256 0 8 4294902319 2720 2736 2768 0 0 0 0 0 234 240 736 17 8 #smallIcons 1 0 3842 202 208 98 2 3906 3936 98 2 2978 1 1 2978 701 211 4256 3906 4016 98 1 4432 4256 4178 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 105 0 0 0] 98 0 4240 0 27 7 16 234 256 98 4 608 8 'packages' 4256 8 'filter' 0 3842 202 208 98 1 3906 3936 98 2 2978 3839 21 2978 701 501 416 4178 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 98 3 4256 410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 5056 0 498 528 0 517 0 0 0 5056 3842 202 208 98 1 3906 3936 98 2 2978 1 211 2978 701 11 5056 4178 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 0 0 0 94 1 0 0 110 0 0 0] 98 0 4240 0 27 608 4240 0 27 )!

resource_Single_package_selector
	"Answer the literal data from which the 'Single package selector' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Single_package_selector)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 21 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 4 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140920397 1025 608 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  498 528 0 21 265030 4 ##(Smalltalk.Menu)  0 16 98 19 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #synchronizeFilter 8 '&Goto Folder' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 850 1 882 8 #setAsDefaultPackage 8 'Set as De&fault Package' 1 1 0 0 0 802 0 16 98 2 850 2097153 882 8 #addClass 8 '&Class...' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'Class.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 850 1 882 8 #addGlobal 8 '&Global...' 1 1 0 0 0 8 'Add Unco&mmitted' 8 #addMenu 134217729 0 0 0 0 0 946 4097 850 1 882 8 #newPackage 8 '&New Package...' 1 1 0 0 0 850 1 882 8 #openPackage 8 '&Install Package...' 1 1 0 0 0 850 1 882 8 #removePackage 8 '&Uninstall' 1 1 0 0 0 946 4097 850 1 882 8 #savePackages 8 '&Save' 1 1 1138 0 16 1184 8 'FileSave.ico' 1232 0 0 850 1 882 8 #savePackageAs 8 'Save &As...' 1 1 0 0 0 946 4097 802 0 16 98 10 850 1 882 8 #toggleUsingPAX 8 'Use PA&X Source Format' 1 1 0 0 0 850 2097153 882 8 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 0 0 0 946 4097 850 1 882 8 #checkOut 8 'Check Out &All' 1 1 0 0 0 850 1 882 8 #checkOutChanges 8 'Check &Out Changes' 1 1 0 0 0 850 1 882 8 #checkIn 8 'Check &In' 1 1 0 0 0 946 4097 850 1 882 8 #savePackageChanges 8 'Save &Changes' 1 1 0 0 0 946 4097 850 1 882 8 #resetChangeFlags 8 'Clear Change &Markers' 1 1 0 0 0 8 'Sou&rce Control' 8 #sourceControlMenu 1 0 0 0 0 0 946 4097 850 1 882 8 #deploy 8 '&Deploy Executable...' 1 1 0 0 0 850 1 882 8 #saveBinaryPackage 8 'Deploy &Binary Package...' 1 1 0 0 0 946 4097 850 1 882 8 #inspectPackage 8 '&Properties' 1 1 1138 0 16 1184 8 'SMALLTALKOPTIONSFOLDER.ICO' 1232 0 0 850 1 882 8 #aboutPackage 8 'Abou&t this Package...' 1 1 0 0 0 8 '&Package' 0 134217729 0 0 0 0 0 0 0 608 0 8 4294903801 459270 ##(Smalltalk.Message)  8 #name 98 0 8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  5 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] 8 #item 8 #isDefaultPackage 8 #font 8 #beBold 2800 7 257 0 0 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn)  8 '' 41 8 #left 0 2786 0 0 2818 3 1 2848 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] 8 #not 8 #& 3072 7 513 0 2674 8 #isChanged 98 0 0 608 2786 0 0 2818 4 1 2848 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 721414 ##(Smalltalk.Association)  8 #Package 8 ##(Smalltalk.Package)  8 #changedIcon 8 #imageIndex 3232 7 257 0 1 0 0 3010 8 'Packages' 653 3056 8 ##(Smalltalk.BasicListAbstract)  2786 0 0 2818 2 1 2848 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] 2704 3456 7 513 0 0 0 608 2736 3 0 2786 0 0 2818 5 1 2848 8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] 2912 2928 2944 2960 3536 7 257 0 8 #report 736 0 133221 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 173 3762 701 329 608 3698 8 #contextMenu: 98 1 816 608 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 86 0 0 0 94 1 0 0 250 0 0 0] 98 0 3762 193 193 0 27 5 410 8 ##(Smalltalk.TreeView)  98 27 0 416 98 2 8 1140916259 1025 3936 590918 3 ##(Smalltalk.TreeModel)  0 768 525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 736 498 528 0 5 802 0 16 98 1 850 1 882 1408 8 '&New Package...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 3936 0 8 4294903619 3440 2736 2768 0 0 0 0 0 234 240 736 17 8 #smallIcons 1 0 3634 202 208 98 2 3698 3728 98 2 3762 1 1 3762 701 163 3936 3698 3824 98 1 4112 3936 3858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 81 0 0 0] 98 0 3920 0 27 3 16 234 256 98 4 608 8 'packages' 3936 8 'filter' 0 3634 202 208 98 1 3698 3728 98 2 3762 2799 21 3762 701 501 416 3858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 213 6 0 0 4 1 0 0] 98 3 3936 410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 4672 0 498 528 0 517 0 0 0 4672 3634 202 208 98 1 3698 3728 98 2 3762 1 163 3762 701 11 4672 3858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 81 0 0 0 94 1 0 0 86 0 0 0] 98 0 3920 0 27 608 3920 0 27 )!

setCommandQueryHandlers: anArray 
	commandQueryHandlers := anArray! !
!PackageSelector class categoriesFor: #defaultModel!models!public! !
!PackageSelector class categoriesFor: #getCommandQueryHandlers!accessing!private! !
!PackageSelector class categoriesFor: #resource_Choice_view!public!resources-views! !
!PackageSelector class categoriesFor: #resource_Default_view!public!resources-views! !
!PackageSelector class categoriesFor: #resource_Single_package_selector!public!resources-views! !
!PackageSelector class categoriesFor: #setCommandQueryHandlers:!accessing!private! !

