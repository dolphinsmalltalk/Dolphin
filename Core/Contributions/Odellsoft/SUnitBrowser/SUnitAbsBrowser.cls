"Filed out from Dolphin Smalltalk"!

SmalltalkToolShell subclass: #SUnitAbsBrowser
	instanceVariableNames: 'listModel labelTextPresenter listPresenter statusTextPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SUnitAbsBrowser guid: (GUID fromString: '{06e4ebda-12c8-4e54-9880-e09eba8bc764}')!

SUnitAbsBrowser isAbstract: true!

SUnitAbsBrowser comment: ''!

!SUnitAbsBrowser categoriesForClass!Unclassified! !

!SUnitAbsBrowser methodsFor!

addToCommandRoute: route
	"Update the <OrderedCollection>, path, with the receiver's contribution to the 
	command path held by the <CommandPolicy>, route. Answer self to have the command 
	policy decide where to go next. 

	Implementation Note: We want to include the development system if it is present." 

	super addToCommandRoute: route.

	route appendTarget: Smalltalk developmentSystem




!

callbackResetList

	self 
		resetListFromModel;
		setResultDisplay!

callbackSelectedItems: aCollection!

callbackToggledUseDisplayNames

	self refreshList!

canSaveState
	"Private - Answer true if the receiver can successfully have it's state saved by #saveStateOn:. Some
	tools may not be able to save their state and therefore will not be able to be exported as
	part of a IdeaSpace save operation"

	^true!

createComponents
	"Create the presenters contained by the receiver. At this stage
	the receiver has not yet been initialized."

	super createComponents.

	self labelTextPresenter: (
		self 
			add: TextPresenter new 
			name: 'label').

	self listPresenter: (
		self 
			add: ListPresenter new 
			name: 'list').

	self statusTextPresenter: (
		self 
			add: TextPresenter new 
			name: 'status')

!

createSchematicWiring
	"Create the trigger wiring for the receiver. At this stage the initialization
	is complete and the view is open"

	super createSchematicWiring.

	self listPresenter 
		when: #selectionChanged 
			send: #selectionChanged 
			to: self!

delete

	self model removeSelectedInList!

helpAbout

	MessageBox 
		notify: self helpString
		caption: 'About ', self browserName!

helpString

	^(WriteStream on: (Utf8String new: 50))
		nextPutAll: self browserName;
		nextPutAll: ' for Dolphin Smalltalk 4.0/5.0';
		cr;
		cr;
		nextPutAll: 'Version 3.1.5RC1';
		contents!

label

	^self labelTextPresenter view!

labelTextPresenter
	"Private - Answer the value of the receiver's ''labelTextPresenter'' instance variable."

	^labelTextPresenter!

labelTextPresenter: anObject
	"Private - Set the value of the receiver's ''labelTextPresenter'' instance variable to the argument, anObject."

	labelTextPresenter := anObject!

listModel

	^listModel!

listModel: anObject

	listModel := anObject!

listPresenter

	^listPresenter!

listPresenter: anObject

	listPresenter := anObject!

queryCommand: aCommandQuery
	"Enters details about a potential command for the receiver into aCommandQuery"

	super queryCommand: aCommandQuery.

	(aCommandQuery command = #delete)
		 ifTrue: [aCommandQuery isEnabled: self model canRemove].

	(aCommandQuery command = #useDisplayNames)
		 ifTrue: [aCommandQuery isChecked: self model useDisplayNames].

	(aCommandQuery command = #sbBrowseHierarchy)
		 ifTrue: [aCommandQuery isEnabled: self model isOneBrowsableItemSelected]



!

refreshItemAtIndex: anIndex 
	listModel refreshAtIndex: anIndex!

refreshList

	1 
		to: self listModel size 
		do: [:index | self refreshItemAtIndex: index].

	self view update !

refreshList: aCollection 

	self view update !

reset

	self model buildList!

saveStateOn: aWriteStream 
	"Private - Write the source of a monadic block that will configure an instance of the receiver's class
	to match the state current receiver, to aWriteStream. The block expects a fresh instance of
	the receiver's class as it's parameter"

	| builder |
	aWriteStream 
		nextPutAll: '[ :aSUnitAbsBrowser | aSUnitAbsBrowser model: 
		(aSUnitAbsBrowser class defaultModelClass newForUI: nil builder: '.
	builder := self model builder.
	builder literalStoreEvaluationOn: aWriteStream.
	aWriteStream nextPutAll: ').'.
	super saveStateOn: aWriteStream.
	aWriteStream nextPutAll: ' value: aSUnitAbsBrowser'.
	aWriteStream nextPut: $]!

sbBrowseResources

	SUnitResourceBrowser show!

selectionChanged 

	self setModelWithSelectedItems
!

setDetailState

	| wrapper |

	wrapper := 
		SUnitStatusTextWrapper 
			newOn: self model detailState
			model: self model.

	self statusTextPresenter value: wrapper  !

setResultDisplay

	self
		setLabelState;
		setDetailState!

setStatusColorsOn: aWidget

	| labelColor |

	labelColor := Color perform: self model resultStateColorSymbol.

	self model showStatusBackgroundColors
		ifTrue: [
			aWidget
				backcolor: labelColor;
				forecolor: Color white]
		ifFalse: [
			aWidget
				backcolor: Color white;
				forecolor: labelColor]!

status

	^self statusTextPresenter view!

statusTextPresenter
	"Private - Answer the value of the receiver's ''statusTextPresenter'' instance variable."

	^statusTextPresenter!

statusTextPresenter: anObject
	"Private - Set the value of the receiver's ''statusTextPresenter'' instance variable to the argument, anObject."

	statusTextPresenter := anObject!

testCaseSelectionChanged 

	self setModelWithSelectedTestCases
!

useDisplayNames

	self model toggleUseDisplayNames! !

!SUnitAbsBrowser categoriesForMethods!
addToCommandRoute:!commands!private! !
callbackResetList!model callbacks!private! !
callbackSelectedItems:!model callbacks!private! !
callbackToggledUseDisplayNames!model callbacks!private! !
canSaveState!private!saved state! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
delete!commands!private! !
helpAbout!commands!private! !
helpString!commands!private! !
label!accessing!private! !
labelTextPresenter!accessing!private! !
labelTextPresenter:!accessing!private! !
listModel!accessing!private! !
listModel:!accessing!private! !
listPresenter!accessing!private! !
listPresenter:!accessing!private! !
queryCommand:!commands!private! !
refreshItemAtIndex:!model callbacks!private! !
refreshList!model callbacks!private! !
refreshList:!private! !
reset!commands!private! !
saveStateOn:!private!saved state! !
sbBrowseResources!commands!private! !
selectionChanged!event handling!private! !
setDetailState!model callbacks!private! !
setResultDisplay!model callbacks!private! !
setStatusColorsOn:!model callbacks!private! !
status!accessing!private! !
statusTextPresenter!accessing!private! !
statusTextPresenter:!accessing!private! !
testCaseSelectionChanged!event handling!private! !
useDisplayNames!commands!private! !
!

!SUnitAbsBrowser class methodsFor!

defaultOptionFlags
	^##(ReuseIfOpenMask | CanUseIdeaSpaceMask)!

icon
	"Answers an Icon that can be used to represent this class"

	^TestRunner icon!

initializeToolClass: aClass
	Smalltalk developmentSystem
		addAdditionalToolsFolderIcon: self toolsFolderIcon;
		registerTool: aClass!

publishedAspects
	"Answer a Set of the aspects published by instances of the receiver"

	| aspects |
	aspects := super publishedAspects.
	aspects
		add: (Aspect boolean: #useDisplayNames);
		add: (Aspect boolean: #canUseIdeaSpace).
	^aspects!

toolsFolderIcon
	"Answer an instance of SmalltalkSystemIcon suitable for representing the
	receiver in the system folder."

	^SmalltalkSystemIcon 
		show: self
		description: self displayString
		helpId: self toolsFolderHelpId!

useDisplayNames

	^self  defaultModelClass useDisplayNames!

useDisplayNames: aBoolean

	^self  defaultModelClass useDisplayNames: aBoolean! !

!SUnitAbsBrowser class categoriesForMethods!
defaultOptionFlags!constants!options!private! !
icon!constants!public! !
initializeToolClass:!initializing!must strip!private! !
publishedAspects!development!public! !
toolsFolderIcon!accessing!public! !
useDisplayNames!configuring!public! !
useDisplayNames:!configuring!public! !
!

