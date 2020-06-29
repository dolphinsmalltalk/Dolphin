"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SUnitAbsModel
	instanceVariableNames: 'configuration listItems selectedItems builder browser state'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'defaultConfiguration'
	classConstants: {}!
SUnitAbsModel guid: (GUID fromString: '{c2a17045-af69-4225-bd7d-54001f456f8f}')!
SUnitAbsModel comment: ''!
!SUnitAbsModel categoriesForClass!Unclassified! !
!SUnitAbsModel methodsFor!

basicSelectedItems

	^selectedItems!

browser

	^browser!

browser: anUI
	"set the browser you want callbacks to be sent to"

	browser := anUI!

builder

	^builder!

builder: aListBuilder

	builder := aListBuilder!

canInspect

	^self hasSelectedItems!

canRemove

	^self hasSelectedItems!

colorSymbolFor: aTest

	^self state colorSymbolFor: aTest!

configuration

	^configuration!

configuration: aConfiguration

	configuration := aConfiguration!

configurationClass

	^self class configurationClass!

detailState

	^self state detailState!

hasBrowser

	^self browser notNil!

hasSelectedItems

	^self basicSelectedItems notNil and: [self basicSelectedItems notEmpty]!

iconSymbolFor: aTest

	^self state iconSymbolFor: aTest!

initialize

	super initialize.

	self
		configuration: self class defaultConfiguration deepCopy;
		state: (self stateClass newOn: self);
		selectedItems: OrderedCollection new;
		listItems: OrderedCollection new!

isOneBrowsableItemSelected

	^self isOneItemSelected and: [self selectedItem canBrowse]!

isOneItemSelected

	^self basicSelectedItems size = 1!

listItems

	^listItems!

listItems: aCollection

	listItems := aCollection!

nameSortBlock

	^[:a :b | a name <= b name]!

removeListItems: aCollection

	self listItems sunitbRemoveAll: aCollection.
	self basicSelectedItems sunitbRemoveAll: aCollection.

	self signalResetList!

removeSelectedInList

	| selected |

	selected := self basicSelectedItems.
	selected isEmpty
		ifTrue: [^self].

	self removeListItems: selected!

reset

	self buildList!

resultStateColorSymbol

	^self state resultStateColorSymbol!

selectedItem

	| items |

	items := self selectedItems.
	^items isEmpty
		ifTrue: [nil]
		ifFalse: [items first]!

selectedItems

	^self basicSelectedItems asSortedCollection: self nameSortBlock!

selectedItems: aCollection

	selectedItems := aCollection asOrderedCollection!

selectItems: aCollection

	self
		selectedItems: aCollection;
		signalSelectedItems: aCollection!

showBackgroundColors

	^self configuration showBackgroundColors!

showBackgroundColors: aBoolean

	self configuration showBackgroundColors: aBoolean!

showIcons

	^self configuration showIcons!

showIcons: aBoolean

	self configuration showIcons: aBoolean!

showToolbar

	^self configuration showToolbar!

showToolbar: aBoolean

	self configuration showToolbar: aBoolean!

signalResetList

	self hasBrowser
		ifFalse: [^self].

	self browser callbackResetList!

signalSelectedItems: aCollection

	self hasBrowser
		ifFalse: [^self].

	self browser callbackSelectedItems: aCollection!

signalToggledShowBackgroundColors

	self hasBrowser
		ifFalse: [^self].

	self browser callbackToggledShowBackgroundColors!

signalToggledShowIcons

	self hasBrowser
		ifFalse: [^self].

	self browser callbackToggledShowIcons!

signalToggledShowToolbar

	self hasBrowser
		ifFalse: [^self].

	self browser callbackToggledShowToolbar!

signalToggledUseDisplayNames

	self hasBrowser
		ifFalse: [^self].

	self browser callbackToggledUseDisplayNames!

state

	^state!

state: anSunitBrowserUIState

	state := anSunitBrowserUIState!

stateClass

	^self class stateClass!

toggleShowBackgroundColors

	self configuration toggleShowBackgroundColors.
	self signalToggledShowBackgroundColors!

toggleShowIcons

	self configuration toggleShowIcons.
	self signalToggledShowIcons!

toggleShowToolbar

	self configuration toggleShowToolbar.
	self signalToggledShowToolbar!

toggleUseDisplayNames

	self configuration toggleUseDisplayNames.
	self signalToggledUseDisplayNames!

useDisplayNames

	^self configuration useDisplayNames!

useDisplayNames: aBoolean

	self configuration useDisplayNames: aBoolean! !
!SUnitAbsModel categoriesFor: #basicSelectedItems!accessing!private! !
!SUnitAbsModel categoriesFor: #browser!accessing!private! !
!SUnitAbsModel categoriesFor: #browser:!accessing!private! !
!SUnitAbsModel categoriesFor: #builder!accessing!public! !
!SUnitAbsModel categoriesFor: #builder:!accessing!public! !
!SUnitAbsModel categoriesFor: #canInspect!public!querying! !
!SUnitAbsModel categoriesFor: #canRemove!public!querying! !
!SUnitAbsModel categoriesFor: #colorSymbolFor:!displaying!public! !
!SUnitAbsModel categoriesFor: #configuration!accessing!private! !
!SUnitAbsModel categoriesFor: #configuration:!accessing!private! !
!SUnitAbsModel categoriesFor: #configurationClass!accessing!private! !
!SUnitAbsModel categoriesFor: #detailState!displaying!public! !
!SUnitAbsModel categoriesFor: #hasBrowser!private!querying! !
!SUnitAbsModel categoriesFor: #hasSelectedItems!private!querying! !
!SUnitAbsModel categoriesFor: #iconSymbolFor:!displaying!public! !
!SUnitAbsModel categoriesFor: #initialize!initializing!private! !
!SUnitAbsModel categoriesFor: #isOneBrowsableItemSelected!public!querying! !
!SUnitAbsModel categoriesFor: #isOneItemSelected!private!querying! !
!SUnitAbsModel categoriesFor: #listItems!accessing!public! !
!SUnitAbsModel categoriesFor: #listItems:!accessing!private! !
!SUnitAbsModel categoriesFor: #nameSortBlock!private!running! !
!SUnitAbsModel categoriesFor: #removeListItems:!actions!private! !
!SUnitAbsModel categoriesFor: #removeSelectedInList!actions!public! !
!SUnitAbsModel categoriesFor: #reset!actions!public! !
!SUnitAbsModel categoriesFor: #resultStateColorSymbol!displaying!public! !
!SUnitAbsModel categoriesFor: #selectedItem!accessing!public! !
!SUnitAbsModel categoriesFor: #selectedItems!accessing!public! !
!SUnitAbsModel categoriesFor: #selectedItems:!accessing!private! !
!SUnitAbsModel categoriesFor: #selectItems:!actions!public! !
!SUnitAbsModel categoriesFor: #showBackgroundColors!configuring!public! !
!SUnitAbsModel categoriesFor: #showBackgroundColors:!configuring!public! !
!SUnitAbsModel categoriesFor: #showIcons!configuring!public! !
!SUnitAbsModel categoriesFor: #showIcons:!configuring!public! !
!SUnitAbsModel categoriesFor: #showToolbar!configuring!public! !
!SUnitAbsModel categoriesFor: #showToolbar:!configuring!public! !
!SUnitAbsModel categoriesFor: #signalResetList!private!signalling! !
!SUnitAbsModel categoriesFor: #signalSelectedItems:!private!signalling! !
!SUnitAbsModel categoriesFor: #signalToggledShowBackgroundColors!private!signalling! !
!SUnitAbsModel categoriesFor: #signalToggledShowIcons!private!signalling! !
!SUnitAbsModel categoriesFor: #signalToggledShowToolbar!private!signalling! !
!SUnitAbsModel categoriesFor: #signalToggledUseDisplayNames!private!signalling! !
!SUnitAbsModel categoriesFor: #state!accessing!public! !
!SUnitAbsModel categoriesFor: #state:!accessing!private! !
!SUnitAbsModel categoriesFor: #stateClass!accessing!private! !
!SUnitAbsModel categoriesFor: #toggleShowBackgroundColors!configuring!public! !
!SUnitAbsModel categoriesFor: #toggleShowIcons!configuring!public! !
!SUnitAbsModel categoriesFor: #toggleShowToolbar!configuring!public! !
!SUnitAbsModel categoriesFor: #toggleUseDisplayNames!configuring!public! !
!SUnitAbsModel categoriesFor: #useDisplayNames!configuring!public! !
!SUnitAbsModel categoriesFor: #useDisplayNames:!configuring!public! !

!SUnitAbsModel class methodsFor!

basicDefaultConfiguration

	^defaultConfiguration!

configurationClass

	self subclassResponsibility!

defaultConfiguration

	self basicDefaultConfiguration isNil
		ifTrue: [self initializeDefaultConfiguration].

	^self basicDefaultConfiguration!

defaultConfiguration: aConfiguration

	defaultConfiguration := aConfiguration!

initializeDefaultConfiguration

	self defaultConfiguration: self configurationClass new.
	self defaultConfiguration
		showBackgroundColors: false;
		showIcons: true;
		showToolbar: true;
		useDisplayNames: false!

new

	^super new
		initialize;
		yourself!

newForUI: aBrowser

	^self
		newForUI: aBrowser
		builder: self builderClass!

newForUI: aBrowser builder: aTestSuiteBuilder

	^self new
		browser: aBrowser;
		builder: aTestSuiteBuilder;
		reset;
		yourself!

releaseDefaultConfiguration

	self defaultConfiguration: nil
!

showBackgroundColors

	^self defaultConfiguration showBackgroundColors!

showBackgroundColors: aBoolean

	^self defaultConfiguration showBackgroundColors: aBoolean!

showIcons

	^self defaultConfiguration showIcons!

showIcons: aBoolean

	self defaultConfiguration showIcons: aBoolean!

showToolbar

	^self defaultConfiguration showToolbar!

showToolbar: aBoolean

	self defaultConfiguration showToolbar: aBoolean!

useDisplayNames

	^self defaultConfiguration useDisplayNames!

useDisplayNames: aBoolean

	self defaultConfiguration useDisplayNames: aBoolean! !
!SUnitAbsModel class categoriesFor: #basicDefaultConfiguration!configuring!public! !
!SUnitAbsModel class categoriesFor: #configurationClass!constants!public! !
!SUnitAbsModel class categoriesFor: #defaultConfiguration!configuring!public! !
!SUnitAbsModel class categoriesFor: #defaultConfiguration:!configuring!public! !
!SUnitAbsModel class categoriesFor: #initializeDefaultConfiguration!initializing!public! !
!SUnitAbsModel class categoriesFor: #new!instantiating!public! !
!SUnitAbsModel class categoriesFor: #newForUI:!instantiating!public! !
!SUnitAbsModel class categoriesFor: #newForUI:builder:!instantiating!public! !
!SUnitAbsModel class categoriesFor: #releaseDefaultConfiguration!initializing!public! !
!SUnitAbsModel class categoriesFor: #showBackgroundColors!configuring!public! !
!SUnitAbsModel class categoriesFor: #showBackgroundColors:!configuring!public! !
!SUnitAbsModel class categoriesFor: #showIcons!configuring!public! !
!SUnitAbsModel class categoriesFor: #showIcons:!configuring!public! !
!SUnitAbsModel class categoriesFor: #showToolbar!configuring!public! !
!SUnitAbsModel class categoriesFor: #showToolbar:!configuring!public! !
!SUnitAbsModel class categoriesFor: #useDisplayNames!configuring!public! !
!SUnitAbsModel class categoriesFor: #useDisplayNames:!configuring!public! !

