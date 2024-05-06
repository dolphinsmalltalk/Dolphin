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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13107200 65536) 416 nil 327686 ##(Smalltalk.Color) #face3d 328198 ##(Smalltalk.Point) 871 771 165 nil nil nil 416 nil 170 192 34 10 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 560 nil 466 #default nil 7 nil nil nil 560 nil 8 1903872368 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 285 117 498 521 51 560 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 142 0 0 0 58 0 0 0 146 1 0 0 83 0 0 0] 8 #() 498 193 193 nil 27 8 'accountNumber' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 928 nil 624 nil 7 nil nil nil 928 nil 8 1903872368 658 nil nil 1 690 138 144 34 1 754 #createAt:extent: 34 2 498 285 47 498 521 51 928 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 142 0 0 0 23 0 0 0 146 1 0 0 48 0 0 0] 8 #() 896 nil 27 8 'name' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 1200 nil 624 nil 7 nil nil nil 1200 nil 8 1903872368 787206 ##(Smalltalk.NumberToText) nil 8 '' nil 1 690 138 144 34 1 754 #createAt:extent: 34 2 498 285 187 498 521 51 1200 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 142 0 0 0 93 0 0 0 146 1 0 0 118 0 0 0] 8 #() 896 nil 27 8 'initialBalance' 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1149239552 1025 1504 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 8 '' nil nil 7 nil nil nil 1504 nil 8 1903849936 1282 nil 8 '' nil nil 690 138 144 34 1 754 #createAt:extent: 34 2 498 615 517 498 201 51 1504 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 2 1 0 0 151 1 0 0 27 1 0 0] 8 #() 896 nil 27 8 'currentBalance' 410 ##(Smalltalk.ListBox) 34 17 nil 416 34 2 8 1144062209 1025 1872 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 624 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #newTransaction 8 'New...' 1 1 nil nil nil 2082 1 2114 #editTransaction 8 'Edit...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2082 1 2114 #removeTransaction 8 'Delete' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1872 nil 8 1903732064 ##(Smalltalk.BasicListAbstract) 1984 false 690 138 144 34 3 754 #createAt:extent: 34 2 498 35 317 498 791 191 1872 754 #contextMenu: 34 1 2048 1872 754 #horizontalExtent: 8 #(0) 1872 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 158 0 0 0 156 1 0 0 253 0 0 0] 8 #() 896 nil 27 8 'transactions' 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 461638 4 ##(Smalltalk.MenuBar) nil true 34 1 2034 nil true 34 5 2082 1 2114 #newTransaction 8 '&New...' 1 1 nil nil nil 2082 1 2114 #editTransaction 8 '&Edit Transaction...' 1 1 nil nil nil 2082 1 2114 #removeTransaction 8 '&Delete Transaction' 1 1 nil nil nil 2210 4097 2082 1 2114 #close 8 'E&xit' 1 1 nil nil nil 8 '&Transaction' nil 1 nil nil 10857 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 49153 nil nil nil nil 1 nil nil 690 138 144 34 3 754 #createAt:extent: 34 2 498 3839 21 498 871 771 416 754 #text: 34 1 8 'Personal Account Details' 416 754 #updateMenuBar 1984 416 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 50 9 0 0 139 1 0 0] 34 15 928 560 1200 1872 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3168 1570 nil nil 1616 8 'Account Name:' nil nil 7 nil nil nil 3168 nil 8 1903849936 658 nil nil nil 690 138 144 34 2 754 #createAt:extent: 34 2 498 55 47 498 201 51 3168 754 #text: 34 1 8 'Account Name:' 3168 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 23 0 0 0 127 0 0 0 48 0 0 0] 8 #() 896 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3504 1570 nil nil 1616 8 'Account Number:' nil nil 7 nil nil nil 3504 nil 8 1903849936 658 nil nil nil 690 138 144 34 2 754 #createAt:extent: 34 2 498 55 117 498 221 51 3504 754 #text: 34 1 8 'Account Number:' 3504 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 58 0 0 0 137 0 0 0 83 0 0 0] 8 #() 896 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3840 1570 nil nil 1616 8 'Initial Balance:' nil nil 7 nil nil nil 3840 nil 8 1903849936 658 nil nil nil 690 138 144 34 2 754 #createAt:extent: 34 2 498 55 187 498 201 51 3840 754 #text: 34 1 8 'Initial Balance:' 3840 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 93 0 0 0 127 0 0 0 118 0 0 0] 8 #() 896 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 4176 1570 nil nil 1616 8 'Transactions' nil nil 7 nil nil nil 4176 nil 8 1903849936 658 nil nil nil 690 138 144 34 2 754 #createAt:extent: 34 2 498 35 277 498 201 41 4176 754 #text: 34 1 8 'Transactions' 4176 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 138 0 0 0 117 0 0 0 158 0 0 0] 8 #() 896 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 4512 1570 nil nil 1616 8 'Balance:' nil nil 7 nil nil nil 4512 nil 8 1903849936 658 nil nil nil 690 138 144 34 2 754 #createAt:extent: 34 2 498 485 527 498 121 41 4512 754 #text: 34 1 8 'Balance:' 4512 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 242 0 0 0 7 1 0 0 46 1 0 0 27 1 0 0] 8 #() 896 nil 27 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 4848 nil 624 nil 7 nil nil nil 4848 nil 8 1903885040 2114 #newTransaction 8 '&New' 1 1 nil nil false nil nil nil 690 138 144 34 3 754 #createAt:extent: 34 2 498 45 589 498 151 51 4848 754 #isEnabled: 8 #(false) 4848 754 #text: 34 1 8 '&New' 4848 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 22 0 0 0 38 1 0 0 97 0 0 0 63 1 0 0] 8 #() 896 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 5200 nil 624 nil 7 nil nil nil 5200 nil 8 1903885040 2114 #editTransaction 8 '&Edit' 1 1 nil nil true nil nil nil 690 138 144 34 3 754 #createAt:extent: 34 2 498 245 589 498 151 51 5200 754 #isEnabled: 8 #(false) 5200 754 #text: 34 1 8 '&Edit' 5200 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 38 1 0 0 197 0 0 0 63 1 0 0] 8 #() 896 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 5552 nil 624 nil 7 nil nil nil 5552 nil 8 1903885040 2114 #removeTransaction 8 '&Delete' 1 1 nil nil false nil nil nil 690 138 144 34 3 754 #createAt:extent: 34 2 498 455 589 498 151 51 5552 754 #isEnabled: 8 #(false) 5552 754 #text: 34 1 8 '&Delete' 5552 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 227 0 0 0 38 1 0 0 46 1 0 0 63 1 0 0] 8 #() 896 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 5904 nil 624 nil 7 nil nil nil 5904 nil 8 1903885040 2114 #exit 8 'E&xit' 1 1 nil nil false nil nil nil 690 138 144 34 2 754 #createAt:extent: 34 2 498 655 589 498 151 51 5904 754 #text: 34 1 8 'E&xit' 5904 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 71 1 0 0 38 1 0 0 146 1 0 0 63 1 0 0] 8 #() 896 nil 29 410 ##(Smalltalk.GroupBox) 34 14 nil 416 34 2 8 1140850695 65 6224 nil 624 nil 7 nil nil nil 6224 nil 8 1903885040 690 138 144 34 1 754 #createAt:extent: 34 2 498 35 17 498 791 241 6224 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 8 0 0 0 156 1 0 0 128 0 0 0] 8 #() 896 nil 27 1504 896 nil 27 )! !

!PersonalAccountShell class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

