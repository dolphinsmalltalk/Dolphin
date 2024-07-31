"Filed out from Dolphin Smalltalk"!

Tools.ClassSelector
	subclass: #'Tools.PackagedClassSelector'
	instanceVariableNames: 'packagesPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.PackagedClassSelector guid: (Core.GUID fromString: '{c9705c73-6294-416d-94db-d626938a441e}')!

Tools.PackagedClassSelector comment: 'PackagedClassSelector is an specialized <ClassSelector> that can be used to filter available classes by owning package. In order to facilitate this it employs a <PackageSelector> to display a tree representing the package folder hierarchy from which a single folder can be selected. Based on this selection the <PackageSelector> populates a list to show all packages at or below that point in the hierarchy. When packages are selected from the list, the class selection panes are updated to show the classes owned by the selected package(s).

PackagedClassSelector is the component used to implement class selection in the System Browser.

Instance Variables:
	packagesPresenter		<PackageSelector>

'!

!Tools.PackagedClassSelector categoriesForClass!MVP-Resources-IDE Tools! !

!Tools.PackagedClassSelector methodsFor!

autoSelectPackages
	^packagesPresenter autoSelect!

autoSelectPackages: aBoolean
	packagesPresenter autoSelect: aBoolean!

browseItCommand
	"Private - Answer the command that the context-sensitive 'Browse-It' command would be linked
	to if sent to the receiver at this moment."

	packagesPresenter packagesPresenter hasFocus ifTrue: [^#browsePackages].
	^super browseItCommand!

browsePackages
	<commandQuery: #hasPackages>
	packagesPresenter browsePackages!

classesPresenter
	^classesPresenter!

classHierarchyPresenter
	^classesPresenter classHierarchyPresenter!

classNamesSelector: aSymbol
	classesPresenter classNamesSelector: aSymbol!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	packagesPresenter := self add: PackageSelector new name: 'packages'.
	classesPresenter := self add: ClassListSelector new name: 'classes'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	packagesPresenter
		when: #selectionChanged
			send: #onPackageSelected
			to: self;
		when: #actionPerformed
			send: #onPackageChosen
			to: self!

flags
	^classesPresenter flags!

flags: anInteger
	classesPresenter flags: anInteger!

gotoDefinition
	"Sets the receiver to be displaying the currently selected class with it's own package selected"

	<commandQuery: #hasSelection>
	| gotoClass |
	gotoClass := self selection.
	self resetForItem: gotoClass.
	self selection: gotoClass!

hasPackages
	^packagesPresenter hasPackages!

newClass
	"Create a new subclass of the selected class (or a subclass of Object if no class is actually selected)."

	<commandQuery: #queryNewClass:>
	| aClass package |
	aClass := self selectionOrNil.
	package := self packagesPresenter singlePackage
				ifNil: [aClass isNil ifFalse: [aClass owningPackage]].
	(self developmentSystem createSubclassOf: aClass ?? Object inPackage: package)
		ifNotNil: 
			[:newClass |
			self updateClasses.
			self actualClass: newClass]!

onPackageChosen
	^self browsePackages!

onPackageSelected
	"Private - A package has been selected. Update the receiver's display
	to show the package contents."

	self updateClasses.
	self trigger: #packageSelected.!

packages
	"Answer the packages selected in the receiver"

	^self packagesPresenter selections!

packages: aPackageCollection
	"Set the selected packages."

	packagesPresenter
		selections: aPackageCollection;
		ensureSelectionVisible;
		synchronizeFilter!

packagesPresenter
	^packagesPresenter!

resetForItem: aClass
	"Private - Try to ensure that the receiver is set to display aClass if possible"

	| owningPackage |
	(owningPackage := aClass owningPackage) notNil
		ifTrue: 
			[self packagesPresenter
				resetForItem: owningPackage;
				selections: {owningPackage};
				ensureSelectionVisible]!

selectPackageRoot
	"Select the root of the package hierarchy."

	packagesPresenter selectRootFolder!

setInitialFocus
	self classesPresenter view tabFirst!

updateClasses
	"Private - Update the classes list for this package. Try and maintain the existing selection if possible."

	classesPresenter browserEnvironment: packagesPresenter selectionEnvironment! !

!Tools.PackagedClassSelector categoriesForMethods!
autoSelectPackages!accessing!private!selection! !
autoSelectPackages:!accessing!private!selection! !
browseItCommand!helpers!private! !
browsePackages!commands-actions!public! !
classesPresenter!accessing!public! !
classHierarchyPresenter!accessing!private! !
classNamesSelector:!accessing!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
flags!accessing!private! !
flags:!accessing!private! !
gotoDefinition!commands-actions!public! !
hasPackages!private!testing! !
newClass!commands-actions!public! !
onPackageChosen!event handling!public! !
onPackageSelected!event handling!private!selection! !
packages!accessing!public!selection! !
packages:!accessing!public!selection! !
packagesPresenter!accessing!private! !
resetForItem:!event handling!private! !
selectPackageRoot!public!selection! !
setInitialFocus!operations!public! !
updateClasses!public!updating! !
!

!Tools.PackagedClassSelector class methodsFor!

defaultModel
	"Private - Answer a default model to be assigned to the receiver when it
	is initialized."

	^ListModel new!

defaultView
	"Private - Answer a default view for the receiver"

	^'Choice view'!

resource_Choice_view
	"Answer the literal data from which the 'Choice view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Choice_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.LookupTable} 50 1 518 #{Core.Association} 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 224 nil nil nil 5 nil nil nil 224 114 146 #{Core.LookupTable} 50 2 194 18 #{UI.TreeView} 50 35 nil 224 50 2 8 1140916771 1025 352 1094 3 #{UI.TreeModel} nil 6 #{Kernel.IdentitySearchPolicy} 774 #{UI.TreeNode} nil nil nil 550 #{Core.IdentityDictionary} 0 6 #{Graphics.Color} #default nil 5 2886 4 #{UI.Menu} nil true 50 1 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #browseFolder 8 '&Browse Folder' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 352 nil nil 518 #{Core.Message} #displayString 8 #() 722 #iconImageIndex 752 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil 550 #{Core.LookupTable} 0 nil #smallIcons 1 514 0 1 262 #{UI.TreeViewDynamicUpdateMode} 352 nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 203 0 0 0 131 0 0 0] 193 384 8 '' 352 946 #contextMenu: 50 1 592 352 3 8 #() 518 #{Graphics.Point} 193 193 nil 29 7 194 18 #{UI.ListView} 50 45 nil 224 50 2 8 1140920393 1025 1184 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 464 560 nil 21 578 nil true 50 3 626 2097153 658 #synchronizeFilter 8 '&Goto Folder' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 626 1 658 #browsePackages 8 '&Browse' 1 1 nil nil nil 8 '&Package' nil 1 nil nil nil nil nil nil nil 1184 nil nil 736 768 800 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 1504 7 257 nil 1138 65 65 nil nil 1282 2 3142 5 #{UI.ListViewColumn} 8 'Packages' 359 #left 736 1490 0 nil 1522 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 1680 7 513 nil nil nil 1184 768 3 nil 1490 0 nil 1522 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 1760 7 257 nil 1634 8 '' 41 #left 1490 0 nil 1522 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 1872 7 257 nil 1490 0 nil 1522 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x : y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 1984 7 513 nil 722 #isChanged 8 #() nil 1184 1490 0 nil 1522 5 1 1488 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]] ' 8 #[32 105 17 121 45 159 160 106 60 106] 1094 2 #{Kernel.VariableBinding} #Package #{Kernel.Package} #{Kernel} 1 #changedIcon #imageIndex 2096 #ifTrue: 7 257 nil 1 nil nil #report 8 #() nil 133221 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 1184 nil nil nil nil nil nil nil nil nil 898 50 3 946 #createWindow: 50 1 994 1026 8 #[0 0 0 0 136 0 0 0 203 0 0 0 55 1 0 0] 193 1216 8 'Packages' 1184 946 #contextMenu: 50 1 1312 1184 946 #columnOrder: 50 1 8 #(2 1) 1184 3 8 #() 1138 193 193 nil 35 9 true 518 #{Kernel.STBIdentityDictionaryProxy} 512 50 4 352 8 'filter' 1184 8 'packages' nil 898 50 1 946 #createWindow: 50 1 994 1026 8 #[0 0 0 0 0 0 0 0 203 0 0 0 55 1 0 0] 193 256 8 '' 224 3 50 3 352 18 #{UI.Splitter} 50 12 nil 224 50 2 8 1140850688 1 2720 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2720 nil 1 #left nil nil nil 1138 1 1 1138 9 9 nil 2816 nil 898 50 1 946 #createWindow: 50 1 994 1026 8 #[0 0 0 0 131 0 0 0 203 0 0 0 136 0 0 0] 193 2752 8 '' 2720 3 8 #() 1138 193 193 nil 27 1184 1138 193 193 nil 27 3 false 2498 512 50 4 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 3056 nil nil nil 29 nil nil nil 3056 582 1 #{UI.ResourceIdentifier} #{Tools.ClassListSelector} #resource_Default_view nil 898 50 1 946 #createWindow: 50 1 994 1026 8 #[208 0 0 0 0 0 0 0 156 1 0 0 55 1 0 0] 193 3088 8 '' 3056 3 8 #() 1138 193 193 nil 27 8 'classes' 224 8 'packages' nil 898 50 1 946 #createWindow: 50 1 994 1026 8 #[255 14 0 0 10 0 0 0 155 16 0 0 65 1 0 0] 193 80 8 '' 32 1 50 3 224 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 3488 nil nil nil 517 nil nil nil 2786 3488 nil 1 #left nil nil nil 2816 2832 nil 2816 nil 898 50 1 946 #createWindow: 50 1 994 1026 8 #[203 0 0 0 0 0 0 0 208 0 0 0 55 1 0 0] 193 3520 8 '' 3488 3 8 #() 1138 193 193 nil 27 3056 1138 193 193 nil 27)! !

!Tools.PackagedClassSelector class categoriesForMethods!
defaultModel!models!private! !
defaultView!models!private! !
resource_Choice_view!public!resources-views! !
!

