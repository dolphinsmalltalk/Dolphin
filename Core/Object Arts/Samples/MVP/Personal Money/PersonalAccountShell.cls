"Filed out from Dolphin Smalltalk"!

Shell subclass: #PersonalAccountShell
	instanceVariableNames: 'namePresenter accountNumberPresenter initialBalancePresenter transactionsPresenter currentBalancePresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PersonalAccountShell guid: (GUID fromString: '{87b4c69d-026e-11d3-9fd7-00a0cc3e4a32}')!

PersonalAccountShell comment: 'PersonalAccountShell is a <topPresenter> for displaying and editing a <PersonalAccount> model. It displays the list of <PersonalAccountTransaction>s currently held by the account together with the initial and current balances. The ability to create, delete and modify existing transactions is provided.

Example of an PersonalAccountShell operating on a new account:
PersonalAccountShell show

Instance Variables:
	namePresenter		<TextPresenter> holding the account name.
	accountNumberPresenter	<TextPresenter> holding the account number.
	initialBalancePresenter	<NumberPresenter> holding the initial balance.
	transactionsPresenter		<ListPresenter> holding a list of <PersonalAccountTransaction>s.
	currentBalancePresenter	<NumberPresenter> displaying the current balance.



'!

!PersonalAccountShell categoriesForClass!MVP-Presenters!Samples! !

!PersonalAccountShell methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	namePresenter := self add: TextPresenter new name: 'name'.
	accountNumberPresenter := self add: TextPresenter new name: 'accountNumber'.
	initialBalancePresenter := self add: NumberPresenter new name: 'initialBalance'.
	transactionsPresenter := self add: ListPresenter new name: 'transactions'.
	currentBalancePresenter := self add: NumberPresenter new name: 'currentBalance'.


!

createSchematicWiring
	"Create the trigger wiring for the receiver"
	
	super createSchematicWiring.
	transactionsPresenter when: #actionPerformed send: #editTransaction to: self.
	!

editTransaction
	"Edit the selected transaction"

	| transaction |
	transaction := self selectedTransactionOrNil.
	transaction notNil ifTrue: [
		self model removeTransaction: transaction.
		PersonalAccountTransactionDialog showModalOn: transaction.
		self model addTransaction: transaction.
		self selectedTransactionOrNil: transaction ]
	!

hasSelectedTransaction
	"Answer true it there is a currently selected transaction in the receiver"

	^transactionsPresenter hasSelection!

model: aPersonalAccount
	"Set the model associated with the receiver."

	super model: aPersonalAccount.
	namePresenter model: (aPersonalAccount aspectValue: #name).
	accountNumberPresenter model: (aPersonalAccount aspectValue: #accountNumber).
	initialBalancePresenter model: (aPersonalAccount aspectValue: #initialBalance).
	transactionsPresenter model: (aPersonalAccount transactions).
	currentBalancePresenter model: (aPersonalAccount aspectValue: #currentBalance).

	"Sometimes a model may trigger its own events when some aspects of it are changed. For these
	aspects we must explicitly inform the ValueAspectAdaptor that this is the case. This allows
	the adaptor to update its observers if an aspect is changed other than by going through the
	adaptor itself. In the case of a PersonalAccount, the only aspect that triggers a change in
	this way is #currentBalance. We inform our newly created aspect adaptor that its model
	triggers #currentBalanceChanged whenever the currentBalance is updated. See
	PersonalAccount>>currentBalance:."

	currentBalancePresenter model aspectTriggers: #currentBalanceChanged.

!

newTransaction
	"Prompt for a new transaction and add it to the receiver's model"

	| newTransaction |
	(newTransaction := PersonalAccountTransactionDialog showModal) notNil ifTrue: [
		self model addTransaction: newTransaction.
		self selectedTransactionOrNil: newTransaction ]
	!

queryCommand: aCommandQuery
	"Enters details about a potential command for the receiver into aCommandQuery"

	super queryCommand: aCommandQuery.
	(#(editTransaction removeTransaction) includes: aCommandQuery command) ifTrue: [
		aCommandQuery isEnabled: self hasSelectedTransaction ]
!

removeTransaction
	"Removes the current transaction from the receiver's model"

	| transaction |
	transaction := self selectedTransactionOrNil.
	transaction notNil ifTrue: [
		self model removeTransaction: transaction ]
	!

selectedTransactionOrNil
	"Answer the currently selected transaction or nil if there is none"

	^transactionsPresenter selectionOrNil!

selectedTransactionOrNil: aPersonalAccountTransactionOrNil
	"Sets the currently selected transaction to aPersonalAccountTransactionOrNil.
	If nil if there will be no selection"

	^transactionsPresenter selectionOrNil: aPersonalAccountTransactionOrNil! !

!PersonalAccountShell categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
editTransaction!commands!public! !
hasSelectedTransaction!public!testing! !
model:!accessing!public! !
newTransaction!commands!public! !
queryCommand:!commands!public! !
removeTransaction!commands!public! !
selectedTransactionOrNil!accessing!public! !
selectedTransactionOrNil:!accessing!public! !
!

!PersonalAccountShell class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^PersonalAccount new
!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13107200 65536) 416 nil 327686 ##(Smalltalk.Color) #face3d 328198 ##(Smalltalk.Point) 871 771 133 nil nil nil 416 nil 170 192 34 10 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 560 nil 466 #default nil 5 nil nil nil 560 nil 8 1759000288 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[142 0 0 0 58 0 0 0 146 1 0 0 83 0 0 0] 193 592 nil 560 3 8 #() 498 193 193 nil 27 8 'accountNumber' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 928 nil 624 nil 5 nil nil nil 928 nil 8 1759000288 658 nil nil 1 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[142 0 0 0 23 0 0 0 146 1 0 0 48 0 0 0] 193 960 nil 928 3 8 #() 498 193 193 nil 27 8 'name' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 1200 nil 624 nil 5 nil nil nil 1200 nil 8 1759000288 787206 ##(Smalltalk.NumberToText) nil 8 '' nil 1 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[142 0 0 0 93 0 0 0 146 1 0 0 118 0 0 0] 193 1232 nil 1200 3 8 #() 498 193 193 nil 27 8 'initialBalance' 410 ##(Smalltalk.ListBox) 34 17 nil 416 34 2 8 1144062209 1025 1504 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 624 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #newTransaction 8 'New...' 1 1 nil nil nil 1714 1 1746 #editTransaction 8 'Edit...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1714 1 1746 #removeTransaction 8 'Delete' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1504 nil 8 1758868288 ##(Smalltalk.BasicListAbstract) 8 #() false 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[17 0 0 0 158 0 0 0 156 1 0 0 253 0 0 0] 193 1536 8 '' 1504 754 #contextMenu: 34 1 1680 1504 3 8 #() 498 193 193 nil 27 8 'transactions' 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1149239552 1025 2192 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 8 '' nil nil 5 nil nil nil 2192 nil 8 1759212608 1282 nil 8 '' nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[51 1 0 0 2 1 0 0 151 1 0 0 27 1 0 0] 193 2224 nil 2192 754 #text: 34 1 8 '' 2192 3 8 #() 498 193 193 nil 27 8 'currentBalance' 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 461638 4 ##(Smalltalk.MenuBar) nil true 34 1 1666 nil true 34 5 1714 1 1746 #newTransaction 8 '&New...' 1 1 nil nil nil 1714 1 1746 #editTransaction 8 '&Edit Transaction...' 1 1 nil nil nil 1714 1 1746 #removeTransaction 8 '&Delete Transaction' 1 1 nil nil nil 1842 4097 1714 1 1746 #close 8 'E&xit' 1 1 nil nil nil 8 '&Transaction' nil 1 nil nil 14291 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 12143 nil nil nil nil 1 nil 193 690 138 144 34 1 754 #createWindow: 34 1 802 2610 498 1 1 498 871 771 193 448 8 'Personal Account Details' 416 1 34 15 928 560 1200 1504 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3168 2258 nil nil 2304 8 'Account Name:' nil nil 5 nil nil nil 3168 nil 8 1759212608 658 nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[27 0 0 0 23 0 0 0 127 0 0 0 48 0 0 0] 193 3200 nil 3168 754 #text: 34 1 8 'Account Name:' 3168 3 8 #() 498 193 193 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3504 2258 nil nil 2304 8 'Account Number:' nil nil 5 nil nil nil 3504 nil 8 1759212608 658 nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[27 0 0 0 58 0 0 0 137 0 0 0 83 0 0 0] 193 3536 nil 3504 754 #text: 34 1 8 'Account Number:' 3504 3 8 #() 498 193 193 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3840 2258 nil nil 2304 8 'Initial Balance:' nil nil 5 nil nil nil 3840 nil 8 1759212608 658 nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[27 0 0 0 93 0 0 0 127 0 0 0 118 0 0 0] 193 3872 nil 3840 754 #text: 34 1 8 'Initial Balance:' 3840 3 8 #() 498 193 193 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 4176 2258 nil nil 2304 8 'Transactions' nil nil 5 nil nil nil 4176 nil 8 1759212608 658 nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[17 0 0 0 138 0 0 0 117 0 0 0 158 0 0 0] 193 4208 nil 4176 754 #text: 34 1 8 'Transactions' 4176 3 8 #() 498 193 193 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 4512 2258 nil nil 2304 8 'Balance:' nil nil 5 nil nil nil 4512 nil 8 1759212608 658 nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[242 0 0 0 7 1 0 0 46 1 0 0 27 1 0 0] 193 4544 nil 4512 754 #text: 34 1 8 'Balance:' 4512 3 8 #() 498 193 193 nil 27 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 4848 nil 624 nil 5 nil nil nil 4848 nil 8 1759007584 1746 #newTransaction 8 '&New' 1 1 nil nil false nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[22 0 0 0 38 1 0 0 97 0 0 0 63 1 0 0] 193 4880 8 '&New' 4848 754 #isEnabled: 8 #(false) 4848 3 8 #() 498 193 193 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 5168 nil 624 nil 5 nil nil nil 5168 nil 8 1759007584 1746 #editTransaction 8 '&Edit' 1 1 nil nil true nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[122 0 0 0 38 1 0 0 197 0 0 0 63 1 0 0] 193 5200 8 '&Edit' 5168 754 #isEnabled: 8 #(false) 5168 3 8 #() 498 193 193 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 5488 nil 624 nil 5 nil nil nil 5488 nil 8 1759007584 1746 #removeTransaction 8 '&Delete' 1 1 nil nil false nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[227 0 0 0 38 1 0 0 46 1 0 0 63 1 0 0] 193 5520 8 '&Delete' 5488 754 #isEnabled: 8 #(false) 5488 3 8 #() 498 193 193 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 5808 nil 624 nil 5 nil nil nil 5808 nil 8 1759007584 1746 #exit 8 'E&xit' 1 1 nil nil false nil nil nil 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[71 1 0 0 38 1 0 0 146 1 0 0 63 1 0 0] 193 5840 8 'E&xit' 5808 3 8 #() 498 193 193 nil 29 410 ##(Smalltalk.GroupBox) 34 14 nil 416 34 2 8 1140850695 65 6096 nil 624 nil 5 nil nil nil 6096 nil 8 1759007584 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[17 0 0 0 8 0 0 0 156 1 0 0 128 0 0 0] 193 6128 8 '' 6096 3 8 #() 498 193 193 nil 27 2192 498 193 193 nil 27 )! !

!PersonalAccountShell class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

