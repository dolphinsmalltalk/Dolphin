"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'UI.Examples.PersonalAccountTransactionDialog'
	instanceVariableNames: 'datePresenter amountPresenter descriptionPresenter isDebitPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.PersonalAccountTransactionDialog guid: (Core.GUID fromString: '{87b4c6a3-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.Examples.PersonalAccountTransactionDialog comment: 'PersonalAccountTransactionDialog is a <dialogPresenter> used to edit the contents of an <PersonalAccountTransaction> model.

To see an example operating on a new transaction evaluate:

PersonalAccountTransactionDialog showModal

Instance Variables:
	datePresenter		<DatePresenter> for the #date aspect.
	amountPresenter		<NumberPresenter> for the #amount aspect.
	descriptionPresenter		<TextPresenter> for the #description aspect.
	isDebitPresenter		<BooleanPresenter> for the #isDebit aspect.

'!

!UI.Examples.PersonalAccountTransactionDialog categoriesForClass!MVP-Presenters!Samples! !

!UI.Examples.PersonalAccountTransactionDialog methodsFor!

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

!UI.Examples.PersonalAccountTransactionDialog categoriesForMethods!
createComponents!initializing!public! !
model:!accessing!public! !
!

!UI.Examples.PersonalAccountTransactionDialog class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^PersonalAccountTransaction new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13107200 65536) 32 nil 6 #{Graphics.Color} #default 518 #{Graphics.Point} 861 571 133 nil nil nil 32 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 8 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140920320 1025 208 nil 112 nil 5 nil nil nil 208 nil nil 1094 1 #{UI.NumberToText} nil 8 '' 326 1 #{Core.Locale} #userDefault nil 1 #focusLost nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 130 215 267 130 201 51 208 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 133 0 0 0 207 0 0 0 158 0 0 0] 8 #() 130 193 193 nil 45 8 'amount' 18 #{UI.DateTimePicker} 50 16 nil 32 50 2 8 1140916228 1025 576 1094 2 #{UI.ValueHolder} nil nil 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 706 #hash 8 #() nil 112 nil 5 nil nil nil 576 nil nil 518 #{UI.NullConverter} nil nil nil 354 50 2 402 #createAt:extent: 50 2 130 215 57 130 601 51 576 402 #range: 50 1 50 2 262 #{OS.SYSTEMTIME} 8 #[216 6 9 0 4 0 14 0 0 0 0 0 0 0 0 0] nil 576 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 28 0 0 0 151 1 0 0 53 0 0 0] 8 #() 544 nil 27 8 'date' 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140920320 1025 1072 nil 112 nil 5 nil nil nil 1072 nil nil 786 nil nil 1 #focusLost nil nil nil 354 50 1 402 #createAt:extent: 50 2 130 215 127 130 601 121 1072 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 63 0 0 0 151 1 0 0 123 0 0 0] 8 #() 544 nil 45 8 'description' 18 #{UI.CheckBox} 50 16 nil 32 50 2 8 1140924451 1 1312 642 nil nil 6 #{Kernel.NeverSearchPolicy} false 112 nil 5 nil nil nil 1312 nil nil 786 nil nil nil 354 50 2 402 #createAt:extent: 50 2 130 25 347 130 221 61 1312 402 #text: 50 1 8 'Debit:' 1312 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 173 0 0 0 122 0 0 0 203 0 0 0] 8 #() 544 nil 27 8 'isDebit' 518 #{Graphics.Rectangle} 130 1 1 130 1 1 nil nil nil nil 1 nil nil nil nil 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 354 50 2 402 #createAt:extent: 50 2 130 6143 21 130 861 571 32 402 #text: 50 1 8 'Transaction Details' 32 482 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 173 13 0 0 39 1 0 0] 50 9 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 1936 642 nil nil 1408 8 'Amount:' nil nil 5 nil nil nil 1936 nil nil 786 nil nil nil 354 50 2 402 #createAt:extent: 50 2 130 25 277 130 171 51 1936 402 #text: 50 1 8 'Amount:' 1936 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 138 0 0 0 97 0 0 0 163 0 0 0] 8 #() 544 nil 27 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2240 642 nil nil 1408 8 'Description:' nil nil 5 nil nil nil 2240 nil nil 786 nil nil nil 354 50 2 402 #createAt:extent: 50 2 130 25 137 130 171 51 2240 402 #text: 50 1 8 'Description:' 2240 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 68 0 0 0 97 0 0 0 93 0 0 0] 8 #() 544 nil 27 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2544 642 nil nil 1408 8 'Date:' nil nil 5 nil nil nil 2544 nil nil 786 nil nil nil 354 50 2 402 #createAt:extent: 50 2 130 25 57 130 171 51 2544 402 #text: 50 1 8 'Date:' 2544 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 28 0 0 0 97 0 0 0 53 0 0 0] 8 #() 544 nil 27 1072 208 1312 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 2848 nil 112 nil 5 nil nil nil 2848 nil nil 1350 4 #{UI.CommandDescription} #ok 8 '&Ok' 1 1 nil nil true nil nil nil 354 50 3 402 #createAt:extent: 50 2 130 215 427 130 201 51 2848 402 #isEnabled: 8 #(false) 2848 402 #text: 50 1 8 '&Ok' 2848 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 213 0 0 0 207 0 0 0 238 0 0 0] 8 #() 544 nil 29 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 3184 nil 112 nil 5 nil nil nil 3184 nil nil 2914 #cancel 8 '&Cancel' 1 1 nil nil false nil nil nil 354 50 2 402 #createAt:extent: 50 2 130 615 427 130 201 51 3184 402 #text: 50 1 8 '&Cancel' 3184 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 213 0 0 0 151 1 0 0 238 0 0 0] 8 #() 544 nil 29 576 544 nil 27)! !

!UI.Examples.PersonalAccountTransactionDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

