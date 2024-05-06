"Filed out from Dolphin Smalltalk"!

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

!PackagedClassSelector categoriesForClass!MVP-Resources-IDE Tools! !

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
	(self systemModel createSubclassOf: (aClass ?? Object) inPackage: package) 
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

!PackagedClassSelector categoriesForMethods!
autoSelectPackages!accessing!private!selection! !
autoSelectPackages:!accessing!private!selection! !
browseItCommand!helpers!private! !
browsePackages!commands!public! !
classesPresenter!accessing!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
gotoDefinition!commands!public! !
newClass!commands!public! !
onPackageChosen!event handling!public! !
onPackageSelected!event handling!private!selection! !
packages!accessing!public!selection! !
packages:!accessing!public!selection! !
packagesPresenter!accessing!private! !
queryCommand:!commands!private! !
resetForItem:!event handling!private! !
selectPackageRoot!public!selection! !
setInitialFocus!operations!public! !
updateClasses!public!updating! !
!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 544 nil nil nil 5 nil nil nil 544 482 170 176 34 4 410 ##(Smalltalk.ListView) 34 45 nil 544 34 2 8 1140920393 1025 656 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 21 265030 4 ##(Smalltalk.Menu) nil true 34 3 984134 2 ##(Smalltalk.CommandMenuItem) 2097153 1180998 4 ##(Smalltalk.CommandDescription) #synchronizeFilter 8 '&Goto Folder' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 898 1 930 #browsePackages 8 '&Browse' 1 1 nil nil nil 8 '&Package' nil 1 nil nil nil nil nil nil nil 656 nil 8 1883852064 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 1136 7 257 nil 328198 ##(Smalltalk.Point) 65 65 nil nil 138 144 34 2 920646 5 ##(Smalltalk.ListViewColumn) 8 'Packages' 359 #left ##(Smalltalk.BasicListAbstract) 1122 0 nil 1154 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 1344 7 513 nil nil nil 656 ##(Smalltalk.IconicListAbstract) 3 nil 1122 0 nil 1154 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] #item #isDefaultPackage #font #beBold 1424 7 257 nil 1298 8 '' 41 #left 1122 0 nil 1154 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 1536 7 257 nil 1122 0 nil 1154 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x : y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 1648 7 513 nil 459270 ##(Smalltalk.Message) #isChanged 8 #() nil 656 1122 0 nil 1154 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 721414 ##(Smalltalk.Association) #Package ##(Smalltalk.Package) #changedIcon #imageIndex 1776 7 257 nil 1 nil nil #report 768 nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 4 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 1234 1 273 1234 407 351 656 1954 #contextMenu: 34 1 864 656 1954 #text: 34 1 8 'Packages' 656 1954 #columnOrder: 34 1 8 #(2 1) 656 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 136 0 0 0 203 0 0 0 55 1 0 0] 8 #() 1234 193 193 nil 35 9 410 ##(Smalltalk.TreeView) 34 27 nil 544 34 2 8 1140916771 1025 2240 590918 3 ##(Smalltalk.TreeModel) nil 800 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 768 832 nil 5 850 nil true 34 1 898 1 930 #browseFolder 8 '&Browse Folder' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2240 nil 8 1883652128 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1104 nil nil nil nil nil 170 176 768 nil #smallIcons 1 170 ##(Smalltalk.PluggableLookupTable) 768 1890 138 144 34 2 1954 #createAt:extent: 34 2 1234 1 1 1234 407 263 2240 1954 #contextMenu: 34 1 2384 2240 2162 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 0 0 0 131 0 0 0] 8 #() 2224 nil 27 7 true 170 192 34 4 656 8 'packages' 2240 8 'filter' nil 1890 138 144 34 1 1954 #createAt:extent: 34 2 1234 1 1 1234 407 623 544 2162 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 0 0 0 55 1 0 0] 34 3 2240 410 ##(Smalltalk.Splitter) 34 12 nil 544 34 2 8 1140850688 1 2944 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2944 nil 1 #left nil nil nil 1234 1 1 1234 9 9 nil 3040 nil 1890 138 144 34 1 1954 #createAt:extent: 34 2 1234 1 263 1234 407 11 2944 2162 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 131 0 0 0 203 0 0 0 136 0 0 0] 8 #() 2224 nil 27 656 2224 nil 27 3 false 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 3264 nil nil nil 29 nil nil nil 3264 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.ClassListSelector) #resource_Default_view nil 1890 138 144 34 1 1954 #createAt:extent: 34 2 1234 417 1 1234 409 623 3264 2162 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 208 0 0 0 0 0 0 0 156 1 0 0 55 1 0 0] 768 2224 nil 27 8 'classes' 544 8 'packages' nil 1890 138 144 34 1 1954 #createAt:extent: 34 2 1234 7039 21 1234 825 623 416 2162 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 91 15 0 0 65 1 0 0] 34 3 544 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 3696 nil nil nil 517 nil nil nil 3010 3696 nil 1 #left nil nil nil 3040 3056 nil 3040 nil 1890 138 144 34 1 1954 #createAt:extent: 34 2 1234 407 1 1234 11 623 3696 2162 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 203 0 0 0 0 0 0 0 208 0 0 0 55 1 0 0] 8 #() 2224 nil 27 3264 2224 nil 27 )! !

!PackagedClassSelector class categoriesForMethods!
defaultModel!models!private! !
defaultView!models!private! !
resource_Choice_view!public!resources-views! !
!

