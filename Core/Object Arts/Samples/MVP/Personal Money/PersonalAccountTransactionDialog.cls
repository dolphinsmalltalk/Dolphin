"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #PersonalAccountTransactionDialog
	instanceVariableNames: 'datePresenter amountPresenter descriptionPresenter isDebitPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!PersonalAccountTransactionDialog categoriesFor: #createComponents!initializing!public! !
!PersonalAccountTransactionDialog categoriesFor: #model:!accessing!public! !

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 861 571 165 nil nil nil 416 nil 170 192 34 8 410 ##(Smalltalk.DateTimePicker) 34 16 nil 416 34 2 8 1140916228 1025 560 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 690 #hash 8 #() nil 480 nil 7 nil nil nil 560 nil 8 1904605520 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 215 57 498 601 51 560 882 #text: 34 1 8 '23 September 2019' 560 882 #range: 34 1 34 2 655622 ##(Smalltalk.SYSTEMTIME) 8 #[216 6 9 0 4 0 14 0 0 0 0 0 0 0 0 0] nil 560 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 28 0 0 0 151 1 0 0 53 0 0 0] 8 #() 498 193 193 nil 27 8 'date' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 1200 nil 480 nil 7 nil nil nil 1200 nil 8 1903872368 786 nil nil 1 818 138 144 34 1 882 #createAt:extent: 34 2 498 215 127 498 601 121 1200 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 63 0 0 0 151 1 0 0 123 0 0 0] 8 #() 1168 nil 27 8 'description' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 1472 nil 480 nil 7 nil nil nil 1472 nil 8 1903872368 787206 ##(Smalltalk.NumberToText) nil 8 '' nil 1 818 138 144 34 1 882 #createAt:extent: 34 2 498 215 267 498 201 51 1472 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 133 0 0 0 207 0 0 0 158 0 0 0] 8 #() 1168 nil 27 8 'amount' 410 ##(Smalltalk.CheckBox) 34 16 nil 416 34 2 8 1140924451 1 1776 626 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false 480 nil 7 nil nil nil 1776 nil 8 1903885040 786 nil nil nil 818 138 144 34 2 882 #createAt:extent: 34 2 498 25 347 498 221 61 1776 882 #text: 34 1 8 'Debit:' 1776 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 173 0 0 0 122 0 0 0 203 0 0 0] 8 #() 1168 nil 27 8 'isDebit' 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 nil nil nil nil 3 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 1998684880 818 138 144 34 3 882 #createAt:extent: 34 2 498 3839 21 498 861 571 416 882 #text: 34 1 8 'Transaction Details' 416 882 #updateMenuBar 8 #() 416 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 45 9 0 0 39 1 0 0] 34 9 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2496 626 nil nil 1872 8 'Amount:' nil nil 7 nil nil nil 2496 nil 8 1903849936 786 nil nil nil 818 138 144 34 2 882 #createAt:extent: 34 2 498 25 277 498 171 51 2496 882 #text: 34 1 8 'Amount:' 2496 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 138 0 0 0 97 0 0 0 163 0 0 0] 8 #() 1168 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2832 626 nil nil 1872 8 'Description:' nil nil 7 nil nil nil 2832 nil 8 1903849936 786 nil nil nil 818 138 144 34 2 882 #createAt:extent: 34 2 498 25 137 498 171 51 2832 882 #text: 34 1 8 'Description:' 2832 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 68 0 0 0 97 0 0 0 93 0 0 0] 8 #() 1168 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3168 626 nil nil 1872 8 'Date:' nil nil 7 nil nil nil 3168 nil 8 1903849936 786 nil nil nil 818 138 144 34 2 882 #createAt:extent: 34 2 498 25 57 498 171 51 3168 882 #text: 34 1 8 'Date:' 3168 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 28 0 0 0 97 0 0 0 53 0 0 0] 8 #() 1168 nil 27 1200 1472 1776 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 3504 nil 480 nil 7 nil nil nil 3504 nil 8 1903885040 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 '&Ok' 1 1 nil nil false nil nil nil 818 138 144 34 3 882 #createAt:extent: 34 2 498 215 427 498 201 51 3504 882 #isEnabled: 8 #(false) 3504 882 #text: 34 1 8 '&Ok' 3504 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 213 0 0 0 207 0 0 0 238 0 0 0] 8 #() 1168 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 3872 nil 480 nil 7 nil nil nil 3872 nil 8 1903885040 3586 #cancel 8 '&Cancel' 1 1 nil nil false nil nil nil 818 138 144 34 2 882 #createAt:extent: 34 2 498 615 427 498 201 51 3872 882 #text: 34 1 8 '&Cancel' 3872 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 213 0 0 0 151 1 0 0 238 0 0 0] 8 #() 1168 nil 29 560 1168 nil 27 )! !
!PersonalAccountTransactionDialog class categoriesFor: #defaultModel!models!public! !
!PersonalAccountTransactionDialog class categoriesFor: #resource_Default_view!public!resources-views! !

