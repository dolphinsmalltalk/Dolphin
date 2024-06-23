"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter
	subclass: #'UI.ChoicePresenter'
	instanceVariableNames: 'choicesModel nilChoice'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ChoicePresenter guid: (Core.GUID fromString: '{87b4c6cc-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.ChoicePresenter comment: 'ChoicePresenter is a <valuePresenter> which allows a value to be chosen from a list of alternatives. The range of choices may be supplied as any <sequencedCollection> by using the #choices: method once the ChoicePresenter has been instantiated. The initial selection in the visible list will match the initial value in the ChoicePresenter''s <valueModel>. As different selections are made in list they are transferred directly into the associated model.

By default, a ChoicePresenter allows single selection choices to be made. It is also possible, however, to allow multiple selections by attaching an appropriate <listView> supporting the <multipleSelectableItems> protocol. In this case, the value held by the model will be an <Array> of the chosen items.

It is also sometimes useful to specify one of the supplied choices as being able to represent a nil value in the model. This can be done by using the #nilChoice: method. Note that when in multi-select mode, the nilChoice is equivalent to the empty selection.

Examples:

"Single Selection"
model := 2 asValue.
(ChoicePresenter showOn: model) choices: #[0 1 2 3]; nilChoice: 0.
model value "Display it"

"Multiple Selection"
model := (Array with: 2) asValue.
(ChoicePresenter show: ''Multi-selection list box'' on: model) choices: #[0 1 2 3]; nilChoice: (Array with: 0).
model value "Display it"

Instance Variables:
	choicesModel	<listModel> containing the value choices.
	nilChoice		<Object> specifying the object in list that can be used to represent a nil. value.

'!

!UI.ChoicePresenter categoriesForClass!MVP-Presenters!MVP-Resources-Lists! !

!UI.ChoicePresenter methodsFor!

choices: aSequenceableCollection 
	"Sets the choice list to choose from to be aSequenceableCollection"

	| oldSelections |
	oldSelections := self view selections.
	self noEventsDo: 
			[choicesModel list: aSequenceableCollection.
			self updateChoice].
	(self view selections noDifference: oldSelections) ifFalse: [self onChoiceChanged]!

createSchematicWiring
	"Create the trigger wiring for the receiver. At this stage the initialization
	is complete and the view is open"

	super createSchematicWiring.
	self when: #selectionChanged send: #onChoiceChanged to: self!

getValue
	^self isMultiChoice 
		ifTrue: 
			[| choices |
			choices := view selections.
			choices = self nilChoice ifTrue: [#()] ifFalse: [choices]]
		ifFalse: 
			[| choice |
			choice := view selectionOrNil.
			choice = nilChoice ifFalse: [choice]]!

initialize
	"Private - Initialize the receiver"

	super initialize.
	choicesModel := ListModel newEquality!

isMultiChoice
	^self view isMultiSelect!

model: aValueModel 
	"Set the model of the receiver to be aValueModel."

	self noEventsDo: [super model: aValueModel].
	self updateChoice!

nilChoice
	"Answer the default choice, if any."

	^nilChoice ifNil: [self isMultiChoice ifTrue: [#()]]!

nilChoice: anObject 
	"Set the choice that will be used to represent nil in the receiver to be anObject."

	nilChoice := anObject.
	"#1484. Reverted because breaks common usage of setting nil choice before choices."
	"self updateChoice"!

onChoiceChanged
	"Private - Handler for a choice change in the receiver's view"

	self value: self getValue!

onSelectionChanged
	"Private - Handler for a selection change in the receiver's view"

	self view onSelectionChanged!

onSelectionChanging: aSelectionChangingEvent
	"Private - Handler to indicate that the receiver's selection is about to change.
	To prevent the proposed change under certain circumstances a handler
	can set the value of aValueHolder to false."

	self view onSelectionChanging: aSelectionChangingEvent!

onValueChanged
	"The receiver's value has changed. Ensure that we update the list selection to match"

	self updateChoice.
	super onValueChanged
	!

updateChoice
	"Private - The value has been changed in the receiver's model.
	Transfer the value to the list view's selection."

	| choice |
	self isOpen ifFalse: [^self].
	choice := self value.
	self isMultiChoice 
		ifTrue: 
			[self view 
				selections: ((choice isNil or: [choice isEmpty]) ifTrue: [self nilChoice] ifFalse: [choice])
				ifAbsent: []]
		ifFalse: 
			[choice isNil ifTrue: [choice := self nilChoice].
			choice isNil ifTrue: [self view resetSelection] ifFalse: [self view selection: choice ifAbsent: []]]!

view: aView
	"Set the view for the receiver to aView. This should be overidden for composites
	to also connect up any sub-views"

	super view: aView.

	"Transfer the choice selection across to the associated list. Beware though;
	under some circumstances the choices model may not yet have been filled."
	choicesModel notEmpty ifTrue: [
		self updateChoice ]!

viewModel
	"Private - Answer the model that is to be connected to the view. It is actually
	connected to the receiver's choicesModel - not the receiver's value model"

	^choicesModel! !

!UI.ChoicePresenter categoriesForMethods!
choices:!accessing!public! !
createSchematicWiring!initializing!public! !
getValue!helpers!private! !
initialize!initializing!private! !
isMultiChoice!private!testing! !
model:!accessing!public! !
nilChoice!accessing!public! !
nilChoice:!initializing!public! !
onChoiceChanged!event handling!private! !
onSelectionChanged!event handling!private! !
onSelectionChanging:!event handling!private! !
onValueChanged!event handling!public! !
updateChoice!accessing!private! !
view:!accessing!public! !
viewModel!accessing!private! !
!

!UI.ChoicePresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^nil asValue comparisonPolicy: SearchPolicy equality!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ListBox} 38 #{Core.Array} 17 nil nil 50 2 8 1412497665 1025 32 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 32 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() false 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 402 501 501 32 354 #horizontalExtent: 8 #(0) 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 249 12 0 0 4 1 0 0] 8 #() 402 193 193 nil 27)!

resource_Drop_down_list
	"Answer the literal data from which the 'Drop down list' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Drop_down_list)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ComboBox} 38 #{Core.Array} 17 nil nil 50 2 8 1412498947 1025 32 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 32 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() 401 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 402 251 51 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 124 12 0 0 35 0 0 0] 8 #() 402 193 193 nil 27)!

resource_Enhanced_list_view
	"Answer the literal data from which the 'Enhanced list view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Enhanced_list_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ListView} 38 #{Core.Array} 45 nil nil 50 2 8 1409355853 1025 32 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 32 nil nil 518 #{Core.Message} #displayString 8 #() 242 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 146 1 3142 5 #{UI.ListViewColumn} 8 'Column 1' 201 #left 242 #displayString 272 242 #<= 8 #() nil nil 32 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 578 491 311 32 530 #text: 50 1 8 'Column 1' 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 244 12 0 0 165 0 0 0] 8 #() 578 193 193 nil 35)! !

!UI.ChoicePresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
resource_Drop_down_list!public!resources-views! !
resource_Enhanced_list_view!public!resources-views! !
!

