"Filed out from Dolphin Smalltalk"!

UI.ListPresenter
	subclass: #'Tools.ResourceToolboxPresenter'
	instanceVariableNames: 'categoriesPresenter resourcesPresenter iconMap'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ResourceToolboxPresenter guid: (Core.GUID fromString: '{9b3e71d1-8684-48c9-b045-890f2cd430e6}')!
Tools.ResourceToolboxPresenter comment: ''!
!Tools.ResourceToolboxPresenter categoriesForClass!MVP-Resources-IDE Tools! !
!Tools.ResourceToolboxPresenter methodsFor!

add: aResourceIdentifier toCategory: aString 
	(ClassCategory name: self resourceCategoryPrefix , aString) 
		addClass: aResourceIdentifier owningClass!

addResourceIdentifierFor: method 
	| rid |
	rid := ResourceIdentifier forMethod: method.
	(self model includes: rid) 
		ifFalse: 
			[self model add: rid.
			self refreshResourceList]!

caption
	^''!

categoriesPresenter
	^categoriesPresenter!

categorizeResource
	"Invokes a dialog to categorize the current resource identifier"

	| chosenCategories originalCategories categories resourceIdentifier |
	resourceIdentifier := self selection.
	originalCategories := self localResourceCategoriesOf: resourceIdentifier owningClass.
	categories := self resourceCategories.
	chosenCategories := (ChoicePrompter 
				create: 'Extensible multi-selection choice prompter'
				on: originalCategories
				multipleChoices: categories
				caption: 'Categorize ' , resourceIdentifier displayString)
				newBlock: [:aString | aString];
				showModal.
	(chosenCategories notNil and: [(chosenCategories symmetricDifference: originalCategories) notEmpty]) 
		ifTrue: 
			[self move: resourceIdentifier toCategory: chosenCategories first.
			chosenCategories allButFirst do: [:each | self move: resourceIdentifier toCategory: each].
			self refresh.
			self selection: resourceIdentifier]!

configureColumns
	| listView |
	((listView := categoriesPresenter view) isKindOf: ListView) ifFalse: [^self].
	listView getImageBlock: [:ctx | self imageForCategory: ctx]!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	categoriesPresenter := self
				add: ListPresenter new
				name: 'categories'
				helpId: 10848.
	categoriesPresenter model searchPolicy: SearchPolicy equality.
	resourcesPresenter := self
				add: ResourceListPresenter new
				name: 'resources'
				helpId: 10849!

createSchematicWiring
	"Private - Create the trigger wiring for the receiver"

	super createSchematicWiring.
	categoriesPresenter
		when: #selectionChanged
			send: #onCategorySelected
			to: self;
		when: #dragOver:
			send: #onDragOverCategory:
			to: self;
		when: #drop:
			send: #onDropOverCategory:
			to: self.
	(self developmentSystem)
		when: #methodAdded:
			send: #onMethodAdded:
			to: self;
		when: #methodRemoved:
			send: #onMethodRemoved:
			to: self!

developmentSystem
	^SmalltalkSystem current!

imageForCategory: aString 
	^(iconMap at: aString ifAbsent: [^nil]) imageIndex!

initialize
	super initialize.
	self resetIconMap!

localResourceCategoriesOf: aClass 
	| categories |
	categories := (aClass categories 
				select: [:each | each name beginsWith: self resourceCategoryPrefix]) 
					collect: [:each | each localName].
	categories do: [:each | iconMap at: each put: aClass icon].
	^categories!

move: aResourceIdentifier toCategory: aString 
	(self localResourceCategoriesOf: aResourceIdentifier owningClass) 
		do: [:each | self remove: aResourceIdentifier fromCategory: each].
	self add: aResourceIdentifier toCategory: aString!

onCategorySelected
	self refreshResourceList.
	resourcesPresenter list size = 1 ifTrue: [resourcesPresenter selectionByIndex: 1]!

onDragOverCategory: session 
	session operation: nil.
	session isTargetSameAsSource ifTrue: [^self].
	(session isFormatAvailable: #ResourceIdentifier) 
		ifTrue: 
			[session operation: session intendedOperation.
			^self]!

onDropOverCategory: session 
	"Private - The drag operation described by the <DragDropSession>, session,
	would like to do a drop."

	| category |
	(category := session suggestedTarget) notNil 
		ifFalse: 
			[session resetOperation.
			Sound errorBeep.
			^self].
	session dragObjects do: 
			[:dropObject | 
			(dropObject isFormatAvailable: #ResourceIdentifier) 
				ifTrue: 
					[| rid |
					rid := dropObject format: #ResourceIdentifier.
					session isCopy ifTrue: [self add: rid toCategory: category].
					session isMove ifTrue: [self move: rid toCategory: category].
					session isLink ifTrue: [self remove: rid fromCategory: category]].
			self refreshResourceList]!

onMethodAdded: aCompilationResult
	aCompilationResult method isResourceMethod
		ifTrue: [self addResourceIdentifierFor: aCompilationResult method]!

onMethodRemoved: aCompiledMethod
	aCompiledMethod isResourceMethod ifTrue: [self removeResourceIdentifierFor: aCompiledMethod]!

onViewOpened
	super onViewOpened.
	self configureColumns.
	self refresh.
!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery> argument."

	| selector |
	selector := aCommandQuery commandSymbol.
	#categorizeResource == selector 
		ifTrue: 
			[aCommandQuery isEnabled: self selections size = 1.
			^true].
	^super queryCommand: aCommandQuery!

refresh
	self resetIconMap.
	categoriesPresenter list: self resourceCategories.
	resourcesPresenter filterBlock: [:x | false]!

refreshResourceList
	| classes |
	classes := self resourceClassesWithCategories: categoriesPresenter selections.
	resourcesPresenter filterBlock: [:x | classes includes: x owningClass]!

remove: aResourceIdentifier fromCategory: aString 
	(ClassCategory name: self resourceCategoryPrefix , aString) 
		removeClass: aResourceIdentifier owningClass.
	^true!

removeResourceIdentifierFor: method 
	| rid |
	rid := ResourceIdentifier forMethod: method.
	rid isNil ifTrue: [^self].
	(self model includes: rid) 
		ifTrue: 
			[self model remove: rid.
			self refreshResourceList]!

resetForItem: aResourceIdentifier 
	"Private - Try to ensure that the receiver is set to display anObject if possible"

	self selectCategory: (self resourceCategoriesOf: aResourceIdentifier owningClass) first!

resetIconMap
	iconMap := LookupTable new!

resourceCategories
	| categories |
	categories := Set new.
	self resourceClasses do: 
			[:each | 
			| category |
			category := self resourceCategoriesOf: each.
			categories addAll: category].
	^categories asSortedCollection!

resourceCategoriesOf: aClassOrNil
	| categories |
	aClassOrNil isNil ifTrue: [^#('Misc')].
	#{XProgramming.SUnit.TestCase} valueOrNil
		ifNotNil: [:testCase | (aClassOrNil inheritsFrom: testCase) ifTrue: [^#()]].
	categories := self localResourceCategoriesOf: aClassOrNil.
	categories notEmpty ifTrue: [^categories].
	^self resourceCategoriesOf: aClassOrNil superclass!

resourceCategoryPrefix
	^'MVP-Resources-'!

resourceClasses
	^(self resourceIdentifiers collect: [:each | each owningClass]) asSet asSortedCollection !

resourceClassesWithCategories: anArrayOfCategories 
	^self resourceClasses 
		select: [:each | (anArrayOfCategories intersection: (self resourceCategoriesOf: each)) notEmpty]!

resourceIdentifiers
	^self model list!

resourcesPresenter
	^resourcesPresenter!

selectableItems
	"Private - Answer the name of the <selectableItems> component that actually handles the selectable items in the receiver"
	
	^resourcesPresenter!

selectCategory: aStringOrNil
	^categoriesPresenter selections: {aStringOrNil}!

systemModel
	^self parentPresenter systemModel! !
!Tools.ResourceToolboxPresenter categoriesForMethods!
add:toCategory:!operations!private! !
addResourceIdentifierFor:!helpers!private! !
caption!accessing!public! !
categoriesPresenter!accessing!private! !
categorizeResource!commands!public! !
configureColumns!helpers!private! !
createComponents!initializing!private! !
createSchematicWiring!initializing!private! !
developmentSystem!commands!private! !
imageForCategory:!helpers!private! !
initialize!initializing!private! !
localResourceCategoriesOf:!helpers!private! !
move:toCategory:!operations!private! !
onCategorySelected!private! !
onDragOverCategory:!private! !
onDropOverCategory:!private! !
onMethodAdded:!private! !
onMethodRemoved:!private! !
onViewOpened!private! !
queryCommand:!commands!private! !
refresh!private!updating! !
refreshResourceList!private!updating! !
remove:fromCategory:!operations!private! !
removeResourceIdentifierFor:!helpers!private! !
resetForItem:!event handling!private! !
resetIconMap!helpers!private! !
resourceCategories!accessing!public! !
resourceCategoriesOf:!helpers!private! !
resourceCategoryPrefix!constants!private! !
resourceClasses!accessing!public! !
resourceClassesWithCategories:!helpers!public! !
resourceIdentifiers!accessing!public! !
resourcesPresenter!accessing!private! !
selectableItems!accessing!private! !
selectCategory:!accessing!public! !
systemModel!commands!private! !
!

!Tools.ResourceToolboxPresenter class methodsFor!

defaultModel
	"Private - Answer a default model to be assigned to the receiver when it
	is initialized."

	^ListModel on: SmalltalkSystem current allResourceIdentifiers searchPolicy: SearchPolicy equality!

icon
	"Answers an Icon that can be used to represent this class"

	^ResourceBrowser icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 1029 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 nil nil nil 410 #{UI.ListView} 34 45 nil 416 34 2 8 1140937032 1089 512 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} nil nil 21 nil nil nil 512 nil 8 1815049392 786950 #{Core.Message} #displayString 8 #() 690 #iconImageIndex 624 1639750 1 #{Graphics.IconImageManager} nil nil nil 918022 #{Graphics.Point} 65 65 nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 'Column 1' 201 #left 690 #displayString 8 #() 690 #<= 912 nil nil 512 nil 3 nil nil #largeIcons 8 #() 786 145 145 2081 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 786 1 1 786 441 921 512 1026 #text: 34 1 8 'Column 1' 512 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 220 0 0 0 204 1 0 0] 8 #() 786 193 193 nil 35 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 393217 1232 nil nil nil 5 nil nil nil 1232 1376838 1 #{UI.ResourceIdentifier} #{Tools.ResourceListPresenter} #resource_Default_view nil 978 34 1 1026 #createAt:extent: 34 2 786 441 1 786 561 921 1232 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 0 0 0 0 244 1 0 0 204 1 0 0] 624 1216 nil 27 170 192 34 4 1232 8 'resources' 512 8 'categories' nil 978 34 1 1026 #createAt:extent: 34 2 786 12287 21 786 1001 921 416 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 243 25 0 0 214 1 0 0] 34 2 512 1232 1216 nil 27)!

resourceManager
	^SessionManager current resourceManager! !
!Tools.ResourceToolboxPresenter class categoriesForMethods!
defaultModel!models!private! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
resourceManager!constants!public! !
!

