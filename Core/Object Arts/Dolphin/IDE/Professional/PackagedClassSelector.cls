"Filed out from Dolphin Smalltalk 7"!

ClassSelector subclass: #PackagedClassSelector
	instanceVariableNames: 'packagesPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackagedClassSelector guid: (GUID fromString: '{c9705c73-6294-416d-94db-d626938a441e}')!
PackagedClassSelector comment: 'PackagedClassSelector is an specialized <ClassSelector> that can be used to filter available classes by owning package. In order to facilitate this it employs a <PackageSelector> to display a tree representing the package folder hierarchy from which a single folder can be selected. Based on this selection the <PackageSelector> populates a list to show all packages at or below that point in the hierarchy. When packages are selected from the list, the class selection panes are updated to show the classes owned by the selected package(s).

PackagedClassSelector is the component used to implement class selection in the System Browser.

Instance Variables:
	packagesPresenter		<PackageSelector>

'!
!PackagedClassSelector categoriesForClass!Development!MVP-Resources-IDE Tools! !
!PackagedClassSelector methodsFor!

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
	packagesPresenter browsePackages!

classesPresenter
	^classesPresenter!

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

gotoDefinition
	"Sets the receiver to be displaying the currently selected class with it's own package selected"

	| gotoClass |
	gotoClass := self selection.
	self resetForItem: gotoClass.
	self selection: gotoClass!

newClass
	"Create a new subclass of the selected class (or a subclass of Object if no class is actually selected)."

	| aClass package |
	aClass := self selectionOrNil.
	package := self packagesPresenter singlePackage 
				ifNil: [aClass isNil ifFalse: [aClass owningPackage]].
	(self systemModel createSubclassOf: (aClass ifNil: [Object]) inPackage: package) 
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

queryCommand: query 
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery>, query."

	| selector |
	selector := query commandSymbol.
	#browseIt == selector 
		ifTrue: 
			[selector := self browseItCommand.
			selector isNil 
				ifTrue: 
					[query isEnabled: false.
					^true]].
	#browsePackages == selector 
		ifTrue: 
			[query isEnabled: packagesPresenter hasPackages.
			^true].
	#gotoDefinition == selector 
		ifTrue: 
			[query isEnabled: self hasSelection.
			^true].
	^super queryCommand: query!

resetForItem: aClass 
	"Private - Try to ensure that the receiver is set to display aClass if possible"

	| owningPackage |
	(owningPackage := aClass owningPackage) notNil 
		ifTrue: 
			[(self packagesPresenter)
				resetForItem: owningPackage;
				selections: (Array with: owningPackage);
				ensureSelectionVisible]!

selectPackageRoot
	"Select the root of the package hierarchy."

	packagesPresenter selectRootFolder!

setInitialFocus
	self classesPresenter view tabFirst!

updateClasses
	"Private - Update the classes list for this package. Try and maintain the existing selection if possible."

	classesPresenter browserEnvironment: packagesPresenter selectionEnvironment! !
!PackagedClassSelector categoriesFor: #autoSelectPackages!accessing!private!selection! !
!PackagedClassSelector categoriesFor: #autoSelectPackages:!accessing!private!selection! !
!PackagedClassSelector categoriesFor: #browseItCommand!helpers!private! !
!PackagedClassSelector categoriesFor: #browsePackages!commands!public! !
!PackagedClassSelector categoriesFor: #classesPresenter!accessing!public! !
!PackagedClassSelector categoriesFor: #createComponents!initializing!public! !
!PackagedClassSelector categoriesFor: #createSchematicWiring!initializing!public! !
!PackagedClassSelector categoriesFor: #gotoDefinition!commands!public! !
!PackagedClassSelector categoriesFor: #newClass!commands!public! !
!PackagedClassSelector categoriesFor: #onPackageChosen!event handling!public! !
!PackagedClassSelector categoriesFor: #onPackageSelected!event handling!private!selection! !
!PackagedClassSelector categoriesFor: #packages!accessing!public!selection! !
!PackagedClassSelector categoriesFor: #packages:!accessing!public!selection! !
!PackagedClassSelector categoriesFor: #packagesPresenter!accessing!private! !
!PackagedClassSelector categoriesFor: #queryCommand:!commands!private! !
!PackagedClassSelector categoriesFor: #resetForItem:!event handling!private! !
!PackagedClassSelector categoriesFor: #selectPackageRoot!public!selection! !
!PackagedClassSelector categoriesFor: #setInitialFocus!operations!public! !
!PackagedClassSelector categoriesFor: #updateClasses!public!updating! !

!PackagedClassSelector class methodsFor!

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Choice_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 0 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 2 410 432 98 15 0 416 98 2 8 1140850688 131073 560 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 560 498 234 240 98 4 410 8 ##(Smalltalk.TreeView)  98 27 0 560 98 2 8 1140916259 1025 720 590918 3 ##(Smalltalk.TreeModel)  0 1310726 ##(Smalltalk.IdentitySearchPolicy)  525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 98 0 626 656 0 5 265030 4 ##(Smalltalk.Menu)  0 16 98 1 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #browseFolder 8 '&Browse Folder' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 720 0 8 4294903619 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 234 240 912 17 8 #smallIcons 1 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 1346 407 263 720 1282 8 #contextMenu: 98 1 960 720 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 0 0 0 131 0 0 0] 98 0 1346 193 193 0 27 7 410 8 ##(Smalltalk.ListView)  98 30 0 560 98 2 8 1140920393 1025 1520 590662 2 ##(Smalltalk.ListModel)  202 208 912 0 848 626 656 0 21 946 0 16 98 3 994 2097153 1026 8 #synchronizeFilter 8 '&Goto Folder' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 994 1 1026 8 #browsePackages 8 '&Browse' 1 1 0 0 0 8 '&Package' 0 1 0 0 0 0 0 0 0 1520 0 8 4294903801 1120 1136 1168 0 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  5 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] 8 #item 8 #isDefaultPackage 8 #font 8 #beBold 1904 7 257 0 1346 65 65 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn)  8 'Packages' 359 8 #left 1120 1890 0 0 1922 2 1 1952 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] 8 #name 2192 7 513 0 0 0 1520 1136 3 0 1890 0 0 1922 5 1 1952 8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] 2016 2032 2048 2064 2288 7 257 0 2130 8 '' 41 2176 1890 0 0 1922 3 1 1952 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 2400 7 257 0 1890 0 0 1922 3 1 1952 8 'doIt' 8 '[:x : y | x & y not]' 8 #[31 105 233 1 158 177 106] 8 #not 8 #& 2512 7 513 0 459270 ##(Smalltalk.Message)  8 #isChanged 98 0 0 1520 1890 0 0 1922 4 1 1952 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 721414 ##(Smalltalk.Association)  8 #Package 8 ##(Smalltalk.Package)  8 #changedIcon 8 #imageIndex 2688 7 257 0 1 0 0 8 #report 912 0 133221 0 0 1218 202 208 98 4 1282 1312 98 2 1346 1 273 1346 407 351 1520 1282 1408 98 1 1664 1520 1282 8 #text: 98 1 8 'Packages' 1520 1282 8 #columnOrder: 98 1 98 2 5 3 1520 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 136 0 0 0 203 0 0 0 55 1 0 0] 98 0 1504 0 27 9 16 234 256 98 4 720 8 'filter' 1520 8 'packages' 0 1218 202 208 98 1 1282 1312 98 2 1346 1 1 1346 407 623 560 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 0 0 0 55 1 0 0] 98 3 720 410 8 ##(Smalltalk.Splitter)  98 12 0 560 98 2 8 1140850688 1 3424 0 626 656 0 517 0 0 0 3424 1218 202 208 98 1 1282 1312 98 2 1346 1 263 1346 407 11 3424 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 131 0 0 0 203 0 0 0 136 0 0 0] 98 0 1504 0 27 1520 1504 0 27 3 32 234 256 98 4 560 8 'packages' 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 3728 0 0 0 29 0 0 0 3728 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.ClassListSelector)  8 #resource_Default_view 0 1218 202 208 98 1 1282 1312 98 2 1346 417 1 1346 409 623 3728 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 208 0 0 0 0 0 0 0 156 1 0 0 55 1 0 0] 912 1504 0 27 8 'classes' 0 1218 202 208 98 1 1282 1312 98 2 1346 2799 21 1346 825 623 416 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 19 7 0 0 65 1 0 0] 98 3 560 410 3440 98 12 0 416 98 2 8 1140850688 1 4192 0 626 656 0 517 0 0 0 4192 1218 202 208 98 1 1282 1312 98 2 1346 407 1 1346 11 623 4192 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 203 0 0 0 0 0 0 0 208 0 0 0 55 1 0 0] 98 0 1504 0 27 3728 1504 0 27 )! !
!PackagedClassSelector class categoriesFor: #defaultModel!models!private! !
!PackagedClassSelector class categoriesFor: #defaultView!models!private! !
!PackagedClassSelector class categoriesFor: #resource_Choice_view!public!resources-views! !

