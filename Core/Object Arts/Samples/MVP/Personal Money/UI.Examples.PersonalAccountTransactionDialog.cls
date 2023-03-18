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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13107200 65536) 416 nil 917510 #{Graphics.Color} #default 918022 #{Graphics.Point} 861 571 167 nil nil nil 416 nil 170 192 34 8 410 #{UI.TextEdit} 34 16 nil 416 34 2 8 1140920320 1025 560 nil 480 nil 7 nil nil nil 560 nil 8 1815092992 984134 1 #{UI.NumberToText} nil 8 '' 721222 1 #{Core.Locale} #userDefault nil 1 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 498 215 267 498 201 51 560 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 133 0 0 0 207 0 0 0 158 0 0 0] 8 #() 498 193 193 nil 27 8 'amount' 410 #{UI.TextEdit} 34 16 nil 416 34 2 8 1140920320 1025 944 nil 480 nil 7 nil nil nil 944 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 1 722 34 1 770 #createAt:extent: 34 2 498 215 127 498 601 121 944 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 63 0 0 0 151 1 0 0 123 0 0 0] 8 #() 912 nil 27 8 'description' 410 #{UI.DateTimePicker} 34 16 nil 416 34 2 8 1140916228 1025 1216 918598 2 #{UI.ValueHolder} nil nil 1835526 #{Kernel.PluggableSearchPolicy} 786950 #{Core.Message} #= 8 #() 1346 #hash 8 #() nil 480 nil 7 nil nil nil 1216 nil 8 1815752800 1026 nil nil nil 722 34 3 770 #createAt:extent: 34 2 498 215 57 498 601 51 1216 770 #text: 34 1 8 '15 January 2022' 1216 770 #range: 34 1 34 2 852230 #{OS.SYSTEMTIME} 8 #[216 6 9 0 4 0 14 0 0 0 0 0 0 0 0 0] nil 1216 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 28 0 0 0 151 1 0 0 53 0 0 0] 8 #() 912 nil 27 8 'date' 410 #{UI.CheckBox} 34 16 nil 416 34 2 8 1140924451 1 1760 1282 nil nil 1572870 #{Kernel.NeverSearchPolicy} false 480 nil 7 nil nil nil 1760 nil 8 1815097472 1026 nil nil nil 722 34 2 770 #createAt:extent: 34 2 498 25 347 498 221 61 1760 770 #text: 34 1 8 'Debit:' 1760 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 173 0 0 0 122 0 0 0 203 0 0 0] 8 #() 912 nil 27 8 'isDebit' 1180166 #{Graphics.Rectangle} 498 1 1 498 1 1 nil nil nil nil 65717 nil nil nil nil 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 722 34 2 770 #createAt:extent: 34 2 498 12287 21 498 861 571 416 770 #text: 34 1 8 'Transaction Details' 416 850 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 173 25 0 0 39 1 0 0] 34 9 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 2416 1282 nil nil 1856 8 'Amount:' nil nil 7 nil nil nil 2416 nil 8 1815137184 1026 nil nil nil 722 34 2 770 #createAt:extent: 34 2 498 25 277 498 171 51 2416 770 #text: 34 1 8 'Amount:' 2416 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 138 0 0 0 97 0 0 0 163 0 0 0] 8 #() 912 nil 27 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 2736 1282 nil nil 1856 8 'Description:' nil nil 7 nil nil nil 2736 nil 8 1815137184 1026 nil nil nil 722 34 2 770 #createAt:extent: 34 2 498 25 137 498 171 51 2736 770 #text: 34 1 8 'Description:' 2736 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 68 0 0 0 97 0 0 0 93 0 0 0] 8 #() 912 nil 27 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 3056 1282 nil nil 1856 8 'Date:' nil nil 7 nil nil nil 3056 nil 8 1815137184 1026 nil nil nil 722 34 2 770 #createAt:extent: 34 2 498 25 57 498 171 51 3056 770 #text: 34 1 8 'Date:' 3056 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 28 0 0 0 97 0 0 0 53 0 0 0] 8 #() 912 nil 27 944 560 1760 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140924416 1 3376 nil 480 nil 7 nil nil nil 3376 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #ok 8 '&Ok' 1 1 nil nil true nil nil nil 722 34 3 770 #createAt:extent: 34 2 498 215 427 498 201 51 3376 770 #isEnabled: 8 #(false) 3376 770 #text: 34 1 8 '&Ok' 3376 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 213 0 0 0 207 0 0 0 238 0 0 0] 8 #() 912 nil 29 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140924416 1 3728 nil 480 nil 7 nil nil nil 3728 nil 8 1815097472 3458 #cancel 8 '&Cancel' 1 1 nil nil false nil nil nil 722 34 2 770 #createAt:extent: 34 2 498 615 427 498 201 51 3728 770 #text: 34 1 8 '&Cancel' 3728 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 213 0 0 0 151 1 0 0 238 0 0 0] 8 #() 912 nil 29 1216 912 nil 27)! !
!UI.Examples.PersonalAccountTransactionDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

