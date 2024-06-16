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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13107200 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 861 571 133 nil nil nil 416 nil 170 192 34 8 410 ##(Smalltalk.DateTimePicker) 34 16 nil 416 34 2 8 1140916228 1025 560 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 690 #hash 8 #() nil 480 nil 5 nil nil nil 560 nil 8 1759735488 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[107 0 0 0 28 0 0 0 151 1 0 0 53 0 0 0] 193 592 8 '15 June 2024' 560 882 #range: 34 1 34 2 655622 ##(Smalltalk.SYSTEMTIME) 8 #[216 6 9 0 4 0 14 0 0 0 0 0 0 0 0 0] nil 560 3 8 #() 498 193 193 nil 27 8 'date' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 1168 nil 480 nil 5 nil nil nil 1168 nil 8 1759000288 786 nil nil 1 818 138 144 34 1 882 #createWindow: 34 1 930 962 8 #[107 0 0 0 63 0 0 0 151 1 0 0 123 0 0 0] 193 1200 nil 1168 3 8 #() 498 193 193 nil 27 8 'description' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 1440 nil 480 nil 5 nil nil nil 1440 nil 8 1759000288 787206 ##(Smalltalk.NumberToText) nil 8 '' nil 1 818 138 144 34 1 882 #createWindow: 34 1 930 962 8 #[107 0 0 0 133 0 0 0 207 0 0 0 158 0 0 0] 193 1472 nil 1440 3 8 #() 498 193 193 nil 27 8 'amount' 410 ##(Smalltalk.CheckBox) 34 16 nil 416 34 2 8 1140924451 1 1744 626 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false 480 nil 5 nil nil nil 1744 nil 8 1759007584 786 nil nil nil 818 138 144 34 1 882 #createWindow: 34 1 930 962 8 #[12 0 0 0 173 0 0 0 122 0 0 0 203 0 0 0] 193 1776 8 'Debit:' 1744 3 8 #() 498 193 193 nil 27 8 'isDebit' 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 nil nil nil nil 3 nil nil nil nil 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 818 138 144 34 2 882 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 2082 498 1 1 498 861 571 193 416 882 #setWindowText: 34 1 8 'Transaction Details' 416 1 34 9 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2416 626 nil nil 1840 8 'Amount:' nil nil 5 nil nil nil 2416 nil 8 1759212608 786 nil nil nil 818 138 144 34 2 882 #createWindow: 34 1 930 962 8 #[12 0 0 0 138 0 0 0 97 0 0 0 163 0 0 0] 193 2448 nil 2416 882 #text: 34 1 8 'Amount:' 2416 3 8 #() 498 193 193 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2752 626 nil nil 1840 8 'Description:' nil nil 5 nil nil nil 2752 nil 8 1759212608 786 nil nil nil 818 138 144 34 2 882 #createWindow: 34 1 930 962 8 #[12 0 0 0 68 0 0 0 97 0 0 0 93 0 0 0] 193 2784 nil 2752 882 #text: 34 1 8 'Description:' 2752 3 8 #() 498 193 193 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3088 626 nil nil 1840 8 'Date:' nil nil 5 nil nil nil 3088 nil 8 1759212608 786 nil nil nil 818 138 144 34 2 882 #createWindow: 34 1 930 962 8 #[12 0 0 0 28 0 0 0 97 0 0 0 53 0 0 0] 193 3120 nil 3088 882 #text: 34 1 8 'Date:' 3088 3 8 #() 498 193 193 nil 27 1168 1440 1744 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 3424 nil 480 nil 5 nil nil nil 3424 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 '&Ok' 1 1 nil nil false nil nil nil 818 138 144 34 2 882 #createWindow: 34 1 930 962 8 #[107 0 0 0 213 0 0 0 207 0 0 0 238 0 0 0] 193 3456 8 '&Ok' 3424 882 #isEnabled: 8 #(false) 3424 3 8 #() 498 193 193 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 3760 nil 480 nil 5 nil nil nil 3760 nil 8 1759007584 3506 #cancel 8 '&Cancel' 1 1 nil nil false nil nil nil 818 138 144 34 1 882 #createWindow: 34 1 930 962 8 #[51 1 0 0 213 0 0 0 151 1 0 0 238 0 0 0] 193 3792 8 '&Cancel' 3760 3 8 #() 498 193 193 nil 29 560 498 193 193 nil 29 )! !

!PersonalAccountTransactionDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

