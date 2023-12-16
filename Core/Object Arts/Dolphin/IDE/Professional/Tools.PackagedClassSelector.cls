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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1376774 #{UI.ProportionalLayout} 170 176 34 2 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 544 nil nil nil 5 nil nil nil 544 482 170 176 34 4 410 #{UI.ListView} 34 45 nil 544 34 2 8 1140920393 1025 656 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 21 461638 4 #{UI.Menu} nil true 34 3 1180742 2 #{UI.CommandMenuItem} 2097153 1377606 4 #{UI.CommandDescription} #synchronizeFilter 8 '&Goto Folder' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 898 1 930 #browsePackages 8 '&Browse' 1 1 nil nil nil 8 '&Package' nil 1 nil nil nil nil nil nil nil 656 nil 8 1815049392 786950 #{Core.Message} #displayString 8 #() 1090 #iconImageIndex 1120 1639750 1 #{Graphics.IconImageManager} nil nil 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 1200 7 257 nil 918022 #{Graphics.Point} 65 65 nil nil 138 144 34 2 1117254 5 #{UI.ListViewColumn} 8 'Packages' 359 #left 1104 1186 0 nil 1218 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 1408 7 513 nil nil nil 656 1136 3 nil 1186 0 nil 1218 5 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 1488 7 257 nil 1362 8 '' 41 #left 1186 0 nil 1218 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 1600 7 257 nil 1186 0 nil 1218 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x : y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 1712 7 513 nil 1090 #isChanged 8 #() nil 656 1186 0 nil 1218 5 1 1184 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]] ' 8 #[32 105 17 121 45 159 160 106 60 106] 1442886 2 #{Kernel.VariableBinding} #Package #{Kernel.Package} #{Kernel} 1 #changedIcon #imageIndex 1824 #ifTrue: 7 257 nil 1 nil nil #report 8 #() nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 4 1049350 #{Core.MessageSend} #createAt:extent: 34 2 1298 1 273 1298 407 351 656 2002 #contextMenu: 34 1 864 656 2002 #text: 34 1 8 'Packages' 656 2002 #columnOrder: 34 1 8 #(2 1) 656 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 136 0 0 0 203 0 0 0 55 1 0 0] 8 #() 1298 193 193 nil 35 9 410 #{UI.TreeView} 34 27 nil 544 34 2 8 1140916771 1025 2288 787526 3 #{UI.TreeModel} nil 800 721670 #{UI.TreeNode} nil nil nil 170 192 768 832 nil 5 850 nil true 34 1 898 1 930 #browseFolder 8 '&Browse Folder' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2288 nil 8 1814826960 1104 1136 1168 nil nil nil nil nil 170 176 768 nil #smallIcons 1 170 192 768 1954 34 2 2002 #createAt:extent: 34 2 1298 1 1 1298 407 263 2288 2002 #contextMenu: 34 1 2432 2288 2210 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 0 0 0 131 0 0 0] 8 #() 2272 nil 27 7 true 170 192 34 4 656 8 'packages' 2288 8 'filter' nil 1954 34 1 2002 #createAt:extent: 34 2 1298 1 1 1298 407 623 544 2210 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 0 0 0 55 1 0 0] 34 3 2288 410 #{UI.Splitter} 34 12 nil 544 34 2 8 1140850688 1 2960 nil nil nil 517 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 2960 nil 1 #left nil nil nil 1298 1 1 1298 9 9 nil 3056 nil 1954 34 1 2002 #createAt:extent: 34 2 1298 1 263 1298 407 11 2960 2210 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 131 0 0 0 203 0 0 0 136 0 0 0] 8 #() 2272 nil 27 656 2272 nil 27 3 false 170 192 34 4 544 8 'packages' 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 3280 nil nil nil 29 nil nil nil 3280 1376838 1 #{UI.ResourceIdentifier} #{Tools.ClassListSelector} #resource_Default_view nil 1954 34 1 2002 #createAt:extent: 34 2 1298 417 1 1298 409 623 3280 2210 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 208 0 0 0 0 0 0 0 156 1 0 0 55 1 0 0] 768 2272 nil 27 8 'classes' nil 1954 34 1 2002 #createAt:extent: 34 2 1298 12287 21 1298 825 623 416 2210 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 155 25 0 0 65 1 0 0] 34 3 544 410 #{UI.Splitter} 34 12 nil 416 34 2 8 1140850688 1 3664 nil nil nil 517 nil nil nil 3026 3664 nil 1 #left nil nil nil 3056 3072 nil 3056 nil 1954 34 1 2002 #createAt:extent: 34 2 1298 407 1 1298 11 623 3664 2210 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 203 0 0 0 0 0 0 0 208 0 0 0 55 1 0 0] 8 #() 2272 nil 27 3280 2272 nil 27)! !
!Tools.PackagedClassSelector class categoriesForMethods!
defaultModel!models!private! !
defaultView!models!private! !
resource_Choice_view!public!resources-views! !
!

