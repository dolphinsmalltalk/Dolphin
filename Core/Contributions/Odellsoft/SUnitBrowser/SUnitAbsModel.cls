"Filed out from Dolphin Smalltalk"!

Object subclass: #SUnitAbsModel
	instanceVariableNames: 'configuration listItems selectedItems builder browser state'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'defaultConfiguration'!
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
!SUnitAbsModel categoriesForMethods!
basicSelectedItems!accessing!private! !
browser!accessing!private! !
browser:!accessing!private! !
builder!accessing!public! !
builder:!accessing!public! !
canInspect!public!querying! !
canRemove!public!querying! !
colorSymbolFor:!displaying!public! !
configuration!accessing!private! !
configuration:!accessing!private! !
configurationClass!accessing!private! !
detailState!displaying!public! !
hasBrowser!private!querying! !
hasSelectedItems!private!querying! !
iconSymbolFor:!displaying!public! !
initialize!initializing!private! !
isOneBrowsableItemSelected!public!querying! !
isOneItemSelected!private!querying! !
listItems!accessing!public! !
listItems:!accessing!private! !
nameSortBlock!private!running! !
removeListItems:!actions!private! !
removeSelectedInList!actions!public! !
reset!actions!public! !
resultStateColorSymbol!displaying!public! !
selectedItem!accessing!public! !
selectedItems!accessing!public! !
selectedItems:!accessing!private! !
selectItems:!actions!public! !
showBackgroundColors!configuring!public! !
showBackgroundColors:!configuring!public! !
showIcons!configuring!public! !
showIcons:!configuring!public! !
showToolbar!configuring!public! !
showToolbar:!configuring!public! !
signalResetList!private!signalling! !
signalSelectedItems:!private!signalling! !
signalToggledShowBackgroundColors!private!signalling! !
signalToggledShowIcons!private!signalling! !
signalToggledShowToolbar!private!signalling! !
signalToggledUseDisplayNames!private!signalling! !
state!accessing!public! !
state:!accessing!private! !
stateClass!accessing!private! !
toggleShowBackgroundColors!configuring!public! !
toggleShowIcons!configuring!public! !
toggleShowToolbar!configuring!public! !
toggleUseDisplayNames!configuring!public! !
useDisplayNames!configuring!public! !
useDisplayNames:!configuring!public! !
!

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
!SUnitAbsModel class categoriesForMethods!
basicDefaultConfiguration!configuring!public! !
configurationClass!constants!public! !
defaultConfiguration!configuring!public! !
defaultConfiguration:!configuring!public! !
initializeDefaultConfiguration!initializing!public! !
new!instantiating!public! !
newForUI:!instantiating!public! !
newForUI:builder:!instantiating!public! !
releaseDefaultConfiguration!initializing!public! !
showBackgroundColors!configuring!public! !
showBackgroundColors:!configuring!public! !
showIcons!configuring!public! !
showIcons:!configuring!public! !
showToolbar!configuring!public! !
showToolbar:!configuring!public! !
useDisplayNames!configuring!public! !
useDisplayNames:!configuring!public! !
!

