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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13107200 65536) 32 nil 6 #{Graphics.Color} #default 518 #{Graphics.Point} 861 571 135 nil nil nil 32 nil 550 #{Core.IdentityDictionary} 4 18 #{UI.CheckBox} 50 16 nil 32 50 2 8 1140924451 1 192 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false 112 nil 7 nil nil nil 192 nil 8 1853182784 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 130 25 347 130 221 61 192 418 #text: 50 1 8 'Debit:' 192 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 173 0 0 0 122 0 0 0 203 0 0 0] 8 #() 130 193 193 nil 27 8 'isDebit' 18 #{UI.DateTimePicker} 50 16 nil 32 50 2 8 1140916228 1025 640 258 nil nil 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 754 #hash 8 #() nil 112 nil 7 nil nil nil 640 nil 8 1853911008 338 nil nil nil 370 50 3 418 #createAt:extent: 50 2 130 215 57 130 601 51 640 418 #text: 50 1 8 '10 August 2023' 640 418 #range: 50 1 50 2 262 #{OS.SYSTEMTIME} 8 #[216 6 9 0 4 0 14 0 0 0 0 0 0 0 0 0] nil 640 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 28 0 0 0 151 1 0 0 53 0 0 0] 8 #() 608 nil 27 8 'date' 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140920320 1025 1168 nil 112 nil 7 nil nil nil 1168 nil 8 1853175488 1094 1 #{UI.NumberToText} nil 8 '' 326 1 #{Core.Locale} #userDefault nil 1 #focusLost nil nil nil 370 50 1 418 #createAt:extent: 50 2 130 215 267 130 201 51 1168 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 133 0 0 0 207 0 0 0 158 0 0 0] 8 #() 608 nil 45 8 'amount' 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140920320 1025 1488 nil 112 nil 7 nil nil nil 1488 nil 8 1853175488 338 nil nil 1 #focusLost nil nil nil 370 50 1 418 #createAt:extent: 50 2 130 215 127 130 601 121 1488 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 63 0 0 0 151 1 0 0 123 0 0 0] 8 #() 608 nil 45 8 'description' 518 #{Graphics.Rectangle} 130 1 1 130 1 1 nil nil nil nil 13393 nil nil nil nil 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 370 50 2 418 #createAt:extent: 50 2 130 6143 21 130 861 571 32 418 #text: 50 1 8 'Transaction Details' 32 546 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 173 13 0 0 39 1 0 0] 50 9 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2048 258 nil nil 304 8 'Amount:' nil nil 7 nil nil nil 2048 nil 8 1853387904 338 nil nil nil 370 50 2 418 #createAt:extent: 50 2 130 25 277 130 171 51 2048 418 #text: 50 1 8 'Amount:' 2048 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 138 0 0 0 97 0 0 0 163 0 0 0] 8 #() 608 nil 27 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2368 258 nil nil 304 8 'Description:' nil nil 7 nil nil nil 2368 nil 8 1853387904 338 nil nil nil 370 50 2 418 #createAt:extent: 50 2 130 25 137 130 171 51 2368 418 #text: 50 1 8 'Description:' 2368 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 68 0 0 0 97 0 0 0 93 0 0 0] 8 #() 608 nil 27 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2688 258 nil nil 304 8 'Date:' nil nil 7 nil nil nil 2688 nil 8 1853387904 338 nil nil nil 370 50 2 418 #createAt:extent: 50 2 130 25 57 130 171 51 2688 418 #text: 50 1 8 'Date:' 2688 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 28 0 0 0 97 0 0 0 53 0 0 0] 8 #() 608 nil 27 1488 1168 192 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 3008 nil 112 nil 7 nil nil nil 3008 nil 8 1853182784 1350 4 #{UI.CommandDescription} #ok 8 '&Ok' 1 1 nil nil true nil nil nil 370 50 3 418 #createAt:extent: 50 2 130 215 427 130 201 51 3008 418 #isEnabled: 8 #(false) 3008 418 #text: 50 1 8 '&Ok' 3008 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 213 0 0 0 207 0 0 0 238 0 0 0] 8 #() 608 nil 29 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 3360 nil 112 nil 7 nil nil nil 3360 nil 8 1853182784 3090 #cancel 8 '&Cancel' 1 1 nil nil false nil nil nil 370 50 2 418 #createAt:extent: 50 2 130 615 427 130 201 51 3360 418 #text: 50 1 8 '&Cancel' 3360 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 213 0 0 0 151 1 0 0 238 0 0 0] 8 #() 608 nil 29 640 608 nil 27)! !
!UI.Examples.PersonalAccountTransactionDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

