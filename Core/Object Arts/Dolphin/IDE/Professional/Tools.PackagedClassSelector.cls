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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 176 nil nil nil 5 nil nil nil 176 114 146 2 18 #{UI.ListView} 50 45 nil 176 50 2 8 1140920393 1025 272 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 21 2886 4 #{UI.Menu} nil true 50 3 1094 2 #{UI.CommandMenuItem} 2097153 1350 4 #{UI.CommandDescription} #synchronizeFilter 8 '&Goto Folder' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 514 1 546 #browsePackages 8 '&Browse' 1 1 nil nil nil 8 '&Package' nil 1 nil nil nil nil nil nil nil 272 nil 8 1853243664 518 #{Core.Message} #displayString 8 #() 706 #iconImageIndex 736 1350 1 #{Graphics.IconImageManager} nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 816 7 257 nil 518 #{Graphics.Point} 65 65 nil nil 370 2 3142 5 #{UI.ListViewColumn} 8 'Packages' 359 #left 720 802 0 nil 834 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 1008 7 513 nil nil nil 272 752 3 nil 802 0 nil 834 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 1088 7 257 nil 962 8 '' 41 #left 802 0 nil 834 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 1200 7 257 nil 802 0 nil 834 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x : y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 1312 7 513 nil 706 #isChanged 8 #() nil 272 802 0 nil 834 5 1 800 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]] ' 8 #[32 105 17 121 45 159 160 106 60 106] 1094 2 #{Kernel.VariableBinding} #Package #{Kernel.Package} #{Kernel} 1 #changedIcon #imageIndex 1424 #ifTrue: 7 257 nil 1 nil nil #report 8 #() nil 133221 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 3 774 #{Core.MessageSend} #createAt:extent: 50 2 914 1 273 914 407 351 272 1602 #text: 50 1 8 'Packages' 272 1602 #columnOrder: 50 1 8 #(2 1) 272 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 136 0 0 0 203 0 0 0 55 1 0 0] 8 #() 914 193 193 nil 35 9 18 #{UI.TreeView} 50 27 nil 176 50 2 8 1140916771 1025 1856 1094 3 #{UI.TreeModel} nil 416 774 #{UI.TreeNode} nil nil nil 550 #{Core.IdentityDictionary} 0 448 nil 5 466 nil true 50 1 514 1 546 #browseFolder 8 '&Browse Folder' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1856 nil 8 1852941248 720 752 784 nil nil nil nil nil 146 0 nil #smallIcons 1 1986 0 1554 50 1 1602 #createAt:extent: 50 2 914 1 1 914 407 263 1856 1778 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 0 0 0 131 0 0 0] 8 #() 1840 nil 27 7 true 1986 2 272 8 'packages' 1856 8 'filter' nil 1554 50 1 1602 #createAt:extent: 50 2 914 1 1 914 407 623 176 1778 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 0 0 0 55 1 0 0] 50 3 1856 18 #{UI.Splitter} 50 12 nil 176 50 2 8 1140850688 1 2496 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2496 nil 1 #left nil nil nil 914 1 1 914 9 9 nil 2592 nil 1554 50 1 1602 #createAt:extent: 50 2 914 1 263 914 407 11 2496 1778 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 131 0 0 0 203 0 0 0 136 0 0 0] 8 #() 1840 nil 27 272 1840 nil 27 3 false 1986 2 176 8 'packages' 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 2800 nil nil nil 29 nil nil nil 2800 582 1 #{UI.ResourceIdentifier} #{Tools.ClassListSelector} #resource_Default_view nil 1554 50 1 1602 #createAt:extent: 50 2 914 417 1 914 409 623 2800 1778 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 208 0 0 0 0 0 0 0 156 1 0 0 55 1 0 0] 8 #() 1840 nil 27 8 'classes' nil 1554 50 1 1602 #createAt:extent: 50 2 914 6143 21 914 825 623 32 1778 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 155 13 0 0 65 1 0 0] 50 3 176 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 3200 nil nil nil 517 nil nil nil 2562 3200 nil 1 #left nil nil nil 2592 2608 nil 2592 nil 1554 50 1 1602 #createAt:extent: 50 2 914 407 1 914 11 623 3200 1778 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 203 0 0 0 0 0 0 0 208 0 0 0 55 1 0 0] 8 #() 1840 nil 27 2800 1840 nil 27)! !
!Tools.PackagedClassSelector class categoriesForMethods!
defaultModel!models!private! !
defaultView!models!private! !
resource_Choice_view!public!resources-views! !
!

