"Filed out from Dolphin Smalltalk"!

ListPresenter subclass: #ResourceToolboxPresenter
	instanceVariableNames: 'categoriesPresenter resourcesPresenter iconMap'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ResourceToolboxPresenter guid: (GUID fromString: '{9b3e71d1-8684-48c9-b045-890f2cd430e6}')!

ResourceToolboxPresenter comment: ''!

!ResourceToolboxPresenter categoriesForClass!MVP-Resources-IDE Tools! !

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

invalidatePreview
	resourcesPresenter invalidatePreview!

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
	(aCompilationResult method selector beginsWith: ResourceIdentifier.SelectorPrefix)
		ifTrue: [self addResourceIdentifierFor: aCompilationResult method]!

onMethodRemoved: aCompiledMethod
	(aCompiledMethod selector beginsWith: ResourceIdentifier.SelectorPrefix)
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

!ResourceToolboxPresenter categoriesForMethods!
add:toCategory:!operations!private! !
addResourceIdentifierFor:!helpers!private! !
caption!accessing!public! !
categoriesPresenter!accessing!private! !
categorizeResource!commands!public! !
configureColumns!helpers!private! !
createComponents!initializing!private! !
createSchematicWiring!initializing!private! !
imageForCategory:!helpers!private! !
initialize!initializing!private! !
invalidatePreview!public!updating! !
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

!ResourceToolboxPresenter class methodsFor!

defaultModel
	"Private - Answer a default model to be assigned to the receiver when it
	is initialized."

	^ListModel on: Smalltalk developmentSystem allResourceIdentifiers searchPolicy: SearchPolicy equality!

icon
	"Answers an Icon that can be used to represent this class"

	^ResourceBrowser icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 1029 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140937032 1089 512 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 21 nil nil nil 512 nil 8 1759068368 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579403299 8 #[30 105 226 0 106] #iconImageIndex 752 7 257 nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 328198 ##(Smalltalk.Point) 65 65 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Column 1' 201 #left 690 #displayString 8 #() 690 #<= 976 nil nil 512 nil 3 nil nil #largeIcons 8 #() 850 145 145 2081 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 220 0 0 0 204 1 0 0] 193 544 8 'Column 1' 512 3 8 #() 850 193 193 nil 35 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 393217 1280 nil nil nil 5 nil nil nil 1280 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.ResourceListPresenter) #resource_Default_view nil 1042 138 144 34 1 1106 #createWindow: 34 1 1154 1186 8 #[220 0 0 0 0 0 0 0 244 1 0 0 204 1 0 0] 193 1312 8 '' 1280 3 624 850 193 193 nil 27 170 192 34 4 1280 8 'resources' 512 8 'categories' nil 1042 138 144 34 1 1106 #createWindow: 34 1 1154 1186 8 #[191 13 0 0 10 0 0 0 179 15 0 0 214 1 0 0] 193 448 8 '' 416 1 34 2 512 1280 850 193 193 nil 27 )!

resourceManager
	^SessionManager current resourceManager! !

!ResourceToolboxPresenter class categoriesForMethods!
defaultModel!models!private! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
resourceManager!constants!public! !
!

