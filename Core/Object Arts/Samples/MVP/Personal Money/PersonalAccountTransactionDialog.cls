"Filed out from Dolphin Smalltalk"!

Dialog subclass: #PersonalAccountTransactionDialog
	instanceVariableNames: 'datePresenter amountPresenter descriptionPresenter isDebitPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PersonalAccountTransactionDialog guid: (GUID fromString: '{87b4c6a3-026e-11d3-9fd7-00a0cc3e4a32}')!

PersonalAccountTransactionDialog comment: 'PersonalAccountTransactionDialog is a <dialogPresenter> used to edit the contents of an <PersonalAccountTransaction> model.

To see an example operating on a new transaction evaluate:

PersonalAccountTransactionDialog showModal

Instance Variables:
	datePresenter		<DatePresenter> for the #date aspect.
	amountPresenter		<NumberPresenter> for the #amount aspect.
	descriptionPresenter		<TextPresenter> for the #description aspect.
	isDebitPresenter		<BooleanPresenter> for the #isDebit aspect.

'!

!PersonalAccountTransactionDialog categoriesForClass!MVP-Presenters!Samples! !

!PersonalAccountTransactionDialog methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	datePresenter := self add: DatePresenter new name: 'date'.
	amountPresenter := self add: NumberPresenter new name: 'amount'.
	descriptionPresenter := self add: TextPresenter new name: 'description'.
	isDebitPresenter := self add: BooleanPresenter new name: 'isDebit'.

!

model: aPersonalAccountTransaction
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: aPersonalAccountTransaction.

	aspectBuffer := self model.
	datePresenter model: (aspectBuffer aspectValue: #date).
	amountPresenter model: (aspectBuffer aspectValue: #amount).
	descriptionPresenter model: (aspectBuffer aspectValue: #description).
	isDebitPresenter model: (aspectBuffer aspectValue: #isDebit).
! !

!PersonalAccountTransactionDialog categoriesForMethods!
createComponents!initializing!public! !
model:!accessing!public! !
!

!PersonalAccountTransactionDialog class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^PersonalAccountTransaction new
!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13107200 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 861 571 133 nil nil nil 416 nil 170 192 34 8 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 560 nil 480 nil 7 nil nil nil 560 nil 8 1795700448 787206 ##(Smalltalk.NumberToText) nil 8 '' nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[107 0 0 0 133 0 0 0 207 0 0 0 158 0 0 0] 193 592 nil 560 3 8 #() 498 193 193 nil 27 8 'amount' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 928 nil 480 nil 7 nil nil nil 928 nil 8 1795700448 852486 ##(Smalltalk.NullConverter) nil nil 1 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[107 0 0 0 63 0 0 0 151 1 0 0 123 0 0 0] 193 960 nil 928 3 8 #() 498 193 193 nil 27 8 'description' 410 ##(Smalltalk.CheckBox) 34 16 nil 416 34 2 8 1140924451 1 1216 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false 480 nil 7 nil nil nil 1216 nil 8 1795707744 1010 nil nil nil 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[12 0 0 0 173 0 0 0 122 0 0 0 203 0 0 0] 193 1248 8 'Debit:' 1216 3 8 #() 498 193 193 nil 27 8 'isDebit' 410 ##(Smalltalk.DateTimePicker) 34 16 nil 416 34 2 8 1140916228 1025 1568 1282 nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 1682 #hash 8 #() nil 480 nil 7 nil nil nil 1568 nil 8 1796435648 1010 nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[107 0 0 0 28 0 0 0 151 1 0 0 53 0 0 0] 193 1600 8 '27 August 2024' 1568 754 #range: 34 1 34 2 655622 ##(Smalltalk.SYSTEMTIME) 8 #[216 6 9 0 4 0 14 0 0 0 0 0 0 0 0 0] nil 1568 3 8 #() 498 193 193 nil 27 8 'date' nil nil nil nil nil 3 nil nil nil nil 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2001703808 nil nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 590342 ##(Smalltalk.Rectangle) 498 7679 21 498 8539 591 193 416 754 #setWindowText: 34 1 8 'Transaction Details' 416 1 34 9 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2368 1282 nil nil 1328 8 'Amount:' nil nil 7 nil nil nil 2368 nil 8 1795912768 1010 nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[12 0 0 0 138 0 0 0 97 0 0 0 163 0 0 0] 193 2400 nil 2368 754 #text: 34 1 8 'Amount:' 2368 3 8 #() 498 193 193 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2704 1282 nil nil 1328 8 'Description:' nil nil 7 nil nil nil 2704 nil 8 1795912768 1010 nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[12 0 0 0 68 0 0 0 97 0 0 0 93 0 0 0] 193 2736 nil 2704 754 #text: 34 1 8 'Description:' 2704 3 8 #() 498 193 193 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3040 1282 nil nil 1328 8 'Date:' nil nil 7 nil nil nil 3040 nil 8 1795912768 1010 nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[12 0 0 0 28 0 0 0 97 0 0 0 53 0 0 0] 193 3072 nil 3040 754 #text: 34 1 8 'Date:' 3040 3 8 #() 498 193 193 nil 27 928 560 1216 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 3376 nil 480 nil 7 nil nil nil 3376 nil 8 1795707744 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 '&Ok' 1 1 nil nil false nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[107 0 0 0 213 0 0 0 207 0 0 0 238 0 0 0] 193 3408 8 '&Ok' 3376 754 #isEnabled: 8 #(false) 3376 3 8 #() 498 193 193 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 3712 nil 480 nil 7 nil nil nil 3712 nil 8 1795707744 3458 #cancel 8 '&Cancel' 1 1 nil nil false nil nil nil 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[51 1 0 0 213 0 0 0 151 1 0 0 238 0 0 0] 193 3744 8 '&Cancel' 3712 3 8 #() 498 193 193 nil 29 1568 498 193 193 nil 29 )! !

!PersonalAccountTransactionDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

