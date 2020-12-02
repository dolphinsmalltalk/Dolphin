"Filed out from Dolphin Smalltalk 7"!

ValuePresenter subclass: #ChoicePresenter
	instanceVariableNames: 'choicesModel nilChoice'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ChoicePresenter guid: (GUID fromString: '{87b4c6cc-026e-11d3-9fd7-00a0cc3e4a32}')!
ChoicePresenter comment: 'ChoicePresenter is <valuePresenter> which allows a value to be chosen from a list of alternatives. The range of choices may be supplied as any <sequencedCollection> by using the #choices: method once the ChoicePresenter has been instantiated. The initial selection in the visible list will match the initial value in the ChoicePresenter''s <valueModel>. As different selections are made in list they are transferred directly into the associated model.

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
!ChoicePresenter categoriesForClass!MVP-Presenters!MVP-Resources-Lists! !
!ChoicePresenter methodsFor!

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
!ChoicePresenter categoriesFor: #choices:!accessing!public! !
!ChoicePresenter categoriesFor: #createSchematicWiring!initializing!public! !
!ChoicePresenter categoriesFor: #getValue!helpers!private! !
!ChoicePresenter categoriesFor: #initialize!initializing!private! !
!ChoicePresenter categoriesFor: #isMultiChoice!private!testing! !
!ChoicePresenter categoriesFor: #model:!accessing!public! !
!ChoicePresenter categoriesFor: #nilChoice!accessing!public! !
!ChoicePresenter categoriesFor: #nilChoice:!initializing!public! !
!ChoicePresenter categoriesFor: #onChoiceChanged!event handling!private! !
!ChoicePresenter categoriesFor: #onSelectionChanged!event handling!private! !
!ChoicePresenter categoriesFor: #onSelectionChanging:!event handling!private! !
!ChoicePresenter categoriesFor: #onValueChanged!event handling!public! !
!ChoicePresenter categoriesFor: #updateChoice!accessing!private! !
!ChoicePresenter categoriesFor: #view:!accessing!public! !
!ChoicePresenter categoriesFor: #viewModel!accessing!private! !

!ChoicePresenter class methodsFor!

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ListBox) 34 17 nil nil 34 2 8 1412497665 1025 416 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 1903732064 459270 ##(Smalltalk.Message) #displayString 8 #() 528 false 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 786 501 501 416 738 #horizontalExtent: 8 #(0) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 121 8 0 0 4 1 0 0] 8 #() 786 193 193 nil 27 )!

resource_Drop_down_list
	"Answer the literal data from which the 'Drop down list' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Drop_down_list)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ComboBox) 34 17 nil nil 34 2 8 1412498947 1025 416 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 1903738896 459270 ##(Smalltalk.Message) #displayString 8 #() 528 401 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 786 251 51 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 252 7 0 0 35 0 0 0] 8 #() 786 193 193 nil 27 )!

resource_Enhanced_list_view
	"Answer the literal data from which the 'Enhanced list view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Enhanced_list_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ListView) 34 45 nil nil 34 2 8 1409355853 1025 416 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 1883852064 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Column 1' 201 #left 626 #displayString 656 626 #<= 8 #() nil nil 416 nil 1 nil nil #report 528 nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 7039 21 946 491 311 416 898 #text: 34 1 8 'Column 1' 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 180 14 0 0 165 0 0 0] 8 #() 946 193 193 nil 35 )! !
!ChoicePresenter class categoriesFor: #defaultModel!models!public! !
!ChoicePresenter class categoriesFor: #icon!constants!public! !
!ChoicePresenter class categoriesFor: #resource_Default_view!public!resources-views! !
!ChoicePresenter class categoriesFor: #resource_Drop_down_list!public!resources-views! !
!ChoicePresenter class categoriesFor: #resource_Enhanced_list_view!public!resources-views! !

