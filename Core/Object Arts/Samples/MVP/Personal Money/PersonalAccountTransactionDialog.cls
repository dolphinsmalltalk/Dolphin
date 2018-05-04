"Filed out from Dolphin Smalltalk 7"!

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

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(DialogView)  98 30 0 0 98 2 26214401 131073 416 0 524550 ##(ColorRef)  8 4278190080 328198 ##(Point)  861 571 133 0 0 0 416 0 234 256 98 8 410 8 ##(CheckBox)  98 16 0 416 98 2 8 1140924451 1 592 721990 2 ##(ValueHolder)  0 0 1114638 ##(STBSingletonProxy)  8 ##(SearchPolicy)  8 #never 32 482 512 0 5 0 0 0 592 0 8 4294906781 852486 ##(NullConverter)  0 0 0 983302 ##(MessageSequence)  202 208 98 2 721670 ##(MessageSend)  8 #createAt:extent: 98 2 530 25 347 530 221 61 592 898 8 #text: 98 1 8 'Debit:' 592 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 173 0 0 0 122 0 0 0 203 0 0 0] 98 0 530 193 193 0 27 8 'isDebit' 410 8 ##(TextEdit)  98 16 0 416 98 2 8 1140920320 1025 1152 0 482 512 0 5 0 0 0 1152 0 8 4294906635 802 0 0 1 834 202 208 98 3 898 928 98 2 530 215 127 530 601 121 1152 898 8 #selectionRange: 98 1 525062 ##(Interval)  3 1 3 1152 898 8 #isTextModified: 98 1 32 1152 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 63 0 0 0 151 1 0 0 123 0 0 0] 98 0 1120 0 27 8 'description' 410 8 ##(DateTimePicker)  98 16 0 416 98 2 8 1140916228 1025 1584 674 0 0 1376774 ##(PluggableSearchPolicy)  459270 ##(Message)  8 #= 98 0 1714 8 #hash 98 0 0 482 512 0 5 0 0 0 1584 0 8 4294907103 802 0 0 0 834 202 208 98 3 898 928 98 2 530 215 57 530 601 51 1584 898 1008 98 1 8 '26 May 2005' 1584 898 8 #range: 98 1 98 2 655622 ##(SYSTEMTIME)  8 #[216 6 9 0 0 0 14 0 0 0 0 0 0 0 0 0] 0 1584 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 28 0 0 0 151 1 0 0 53 0 0 0] 98 0 1120 0 27 8 'date' 410 1168 98 16 0 416 98 2 8 1140920320 1025 2208 0 482 512 0 5 0 0 0 2208 0 8 4294906635 787206 ##(NumberToText)  0 8 '' 0 1 834 202 208 98 3 898 928 98 2 530 215 267 530 201 51 2208 898 1408 98 1 1442 3 1 3 2208 898 1488 98 1 32 2208 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 133 0 0 0 207 0 0 0 158 0 0 0] 98 0 1120 0 27 8 'amount' 590342 ##(Rectangle)  530 1 1 530 1 1 0 0 0 0 3 0 0 0 0 1 0 0 590598 ##(Semaphore)  0 0 1 0 8 2010572111 834 202 208 98 3 898 928 98 2 530 1171 915 530 861 571 416 898 1008 98 1 8 'Transaction Details' 416 898 8 #menuBar: 98 1 0 416 1058 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 73 2 0 0 201 1 0 0 247 3 0 0 230 2 0 0] 98 9 410 8 ##(StaticText)  98 16 0 416 98 2 8 1140850944 1 2976 674 0 0 720 8 'Amount:' 0 0 5 0 0 0 2976 0 8 4294906439 802 0 0 0 834 202 208 98 2 898 928 98 2 530 25 277 530 171 51 2976 898 1008 98 1 8 'Amount:' 2976 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 138 0 0 0 97 0 0 0 163 0 0 0] 98 0 1120 0 27 410 2992 98 16 0 416 98 2 8 1140850944 1 3328 674 0 0 720 8 'Description:' 0 0 5 0 0 0 3328 0 8 4294906439 802 0 0 0 834 202 208 98 2 898 928 98 2 530 25 137 530 171 51 3328 898 1008 98 1 8 'Description:' 3328 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 68 0 0 0 97 0 0 0 93 0 0 0] 98 0 1120 0 27 410 2992 98 16 0 416 98 2 8 1140850944 1 3664 674 0 0 720 8 'Date:' 0 0 5 0 0 0 3664 0 8 4294906439 802 0 0 0 834 202 208 98 2 898 928 98 2 530 25 57 530 171 51 3664 898 1008 98 1 8 'Date:' 3664 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 28 0 0 0 97 0 0 0 53 0 0 0] 98 0 1120 0 27 1152 2208 592 410 8 ##(PushButton)  98 17 0 416 98 2 8 1140924416 1 4000 0 482 512 0 5 0 0 0 4000 0 8 4294906781 1180998 4 ##(CommandDescription)  8 #ok 8 '&Ok' 1 1 0 0 32 834 202 208 98 2 898 928 98 2 530 215 427 530 201 71 4000 898 1008 98 1 8 '&Ok' 4000 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 107 0 0 0 213 0 0 0 207 0 0 0 248 0 0 0] 98 0 1120 0 27 410 4016 98 17 0 416 98 2 8 1140924416 1 4384 0 482 512 0 5 0 0 0 4384 0 8 4294906781 4114 8 #cancel 8 '&Cancel' 1 1 0 0 32 834 202 208 98 2 898 928 98 2 530 615 427 530 201 71 4384 898 1008 98 1 8 '&Cancel' 4384 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 213 0 0 0 151 1 0 0 248 0 0 0] 98 0 1120 0 27 1584 1120 0 27 )! !
!PersonalAccountTransactionDialog class categoriesFor: #defaultModel!models!public! !
!PersonalAccountTransactionDialog class categoriesFor: #resource_Default_view!public!resources-views! !

