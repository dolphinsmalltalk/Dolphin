"Filed out from Dolphin Smalltalk 7"!

ListPresenter subclass: #ResourceToolboxPresenter
	instanceVariableNames: 'categoriesPresenter resourcesPresenter iconMap'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ResourceToolboxPresenter guid: (GUID fromString: '{9b3e71d1-8684-48c9-b045-890f2cd430e6}')!
ResourceToolboxPresenter comment: ''!
!ResourceToolboxPresenter categoriesForClass!Development!MVP-Resources-IDE Tools! !
!ResourceToolboxPresenter methodsFor!

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
	(self systemModel)
		when: #methodAdded:
			send: #onMethodAdded:
			to: self;
		when: #methodRemoved:
			send: #onMethodRemoved:
			to: self!

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
	(aCompilationResult method selector beginsWith: ResourceIdentifier selectorPrefix)
		ifTrue: [self addResourceIdentifierFor: aCompilationResult method]!

onMethodRemoved: aCompiledMethod
	(aCompiledMethod selector beginsWith: ResourceIdentifier selectorPrefix)
		ifTrue: [self removeResourceIdentifierFor: aCompiledMethod]!

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
	^categoriesPresenter selections: (Array with: aStringOrNil)!

systemModel
	"Private - Answer the development system model."

	^Smalltalk developmentSystem! !
!ResourceToolboxPresenter categoriesFor: #add:toCategory:!operations!private! !
!ResourceToolboxPresenter categoriesFor: #addResourceIdentifierFor:!helpers!private! !
!ResourceToolboxPresenter categoriesFor: #caption!accessing!public! !
!ResourceToolboxPresenter categoriesFor: #categoriesPresenter!accessing!private! !
!ResourceToolboxPresenter categoriesFor: #categorizeResource!commands!public! !
!ResourceToolboxPresenter categoriesFor: #configureColumns!helpers!private! !
!ResourceToolboxPresenter categoriesFor: #createComponents!initializing!private! !
!ResourceToolboxPresenter categoriesFor: #createSchematicWiring!initializing!private! !
!ResourceToolboxPresenter categoriesFor: #imageForCategory:!helpers!private! !
!ResourceToolboxPresenter categoriesFor: #initialize!initializing!private! !
!ResourceToolboxPresenter categoriesFor: #localResourceCategoriesOf:!helpers!private! !
!ResourceToolboxPresenter categoriesFor: #move:toCategory:!operations!private! !
!ResourceToolboxPresenter categoriesFor: #onCategorySelected!private! !
!ResourceToolboxPresenter categoriesFor: #onDragOverCategory:!private! !
!ResourceToolboxPresenter categoriesFor: #onDropOverCategory:!private! !
!ResourceToolboxPresenter categoriesFor: #onMethodAdded:!private! !
!ResourceToolboxPresenter categoriesFor: #onMethodRemoved:!private! !
!ResourceToolboxPresenter categoriesFor: #onViewOpened!private! !
!ResourceToolboxPresenter categoriesFor: #queryCommand:!commands!private! !
!ResourceToolboxPresenter categoriesFor: #refresh!private!updating! !
!ResourceToolboxPresenter categoriesFor: #refreshResourceList!private!updating! !
!ResourceToolboxPresenter categoriesFor: #remove:fromCategory:!operations!private! !
!ResourceToolboxPresenter categoriesFor: #removeResourceIdentifierFor:!helpers!private! !
!ResourceToolboxPresenter categoriesFor: #resetForItem:!event handling!private! !
!ResourceToolboxPresenter categoriesFor: #resetIconMap!helpers!private! !
!ResourceToolboxPresenter categoriesFor: #resourceCategories!accessing!public! !
!ResourceToolboxPresenter categoriesFor: #resourceCategoriesOf:!helpers!private! !
!ResourceToolboxPresenter categoriesFor: #resourceCategoryPrefix!constants!private! !
!ResourceToolboxPresenter categoriesFor: #resourceClasses!accessing!public! !
!ResourceToolboxPresenter categoriesFor: #resourceClassesWithCategories:!helpers!public! !
!ResourceToolboxPresenter categoriesFor: #resourceIdentifiers!accessing!public! !
!ResourceToolboxPresenter categoriesFor: #resourcesPresenter!accessing!private! !
!ResourceToolboxPresenter categoriesFor: #selectableItems!accessing!private! !
!ResourceToolboxPresenter categoriesFor: #selectCategory:!accessing!public! !
!ResourceToolboxPresenter categoriesFor: #systemModel!commands!private! !

!ResourceToolboxPresenter class methodsFor!

defaultModel
	"Private - Answer a default model to be assigned to the receiver when it
	is initialized."

	^ListModel on: ResourceIdentifier allResourceIdentifiers searchPolicy: SearchPolicy equality!

icon
	"Answers an Icon that can be used to represent this class"

	^ResourceBrowser icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 0 0 1029 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140937032 65 528 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  196934 1 ##(Smalltalk.RGB)  25410499 0 21 0 0 0 528 0 8 4294903801 459270 ##(Smalltalk.Message)  8 #displayString 98 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 918822 ##(Smalltalk.CompiledMethod)  2 3 8 ##(Smalltalk.IconicListAbstract)  8 #defaultGetImageBlock 579403299 8 #[30 105 226 0 106] 8 #iconImageIndex 832 7 257 0 1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 328198 ##(Smalltalk.Point)  65 65 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 'Column 1' 201 8 #left 754 784 98 0 754 8 #<= 1120 0 0 528 0 3 0 0 8 #largeIcons 656 978 125 125 2081 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 978 1 1 978 411 921 528 1266 8 #text: 98 1 8 'Column 1' 528 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 205 0 0 0 204 1 0 0] 98 0 978 193 193 0 27 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 1504 0 0 0 5 0 0 0 1504 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.ResourceListPresenter)  8 #resource_Default_view 0 1202 202 208 98 1 1266 1296 98 2 978 411 1 978 591 921 1504 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 205 0 0 0 0 0 0 0 244 1 0 0 204 1 0 0] 656 1488 0 27 234 256 98 4 1504 8 'resources' 528 8 'categories' 0 1202 202 208 98 1 1266 1296 98 2 978 2799 21 978 1001 921 416 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 107 7 0 0 214 1 0 0] 98 2 528 1504 1488 0 27 )!

resourceManager
	^SessionManager current resourceManager! !
!ResourceToolboxPresenter class categoriesFor: #defaultModel!models!private! !
!ResourceToolboxPresenter class categoriesFor: #icon!constants!public! !
!ResourceToolboxPresenter class categoriesFor: #resource_Default_view!public!resources-views! !
!ResourceToolboxPresenter class categoriesFor: #resourceManager!constants!public! !

