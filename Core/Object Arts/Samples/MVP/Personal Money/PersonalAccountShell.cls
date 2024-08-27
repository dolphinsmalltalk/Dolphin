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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13107200 65536) 416 nil 327686 ##(Smalltalk.Color) #face3d 328198 ##(Smalltalk.Point) 871 771 133 nil nil nil 416 nil 170 192 34 10 410 ##(Smalltalk.ListBox) 34 17 nil 416 34 2 8 1144062209 1025 560 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 #default nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #newTransaction 8 'New...' 1 1 nil nil nil 786 1 818 #editTransaction 8 'Edit...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 786 1 818 #removeTransaction 8 'Delete' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 560 nil 8 1795568448 ##(Smalltalk.BasicListAbstract) 8 #() false 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[17 0 0 0 158 0 0 0 156 1 0 0 253 0 0 0] 193 592 8 '' 560 1106 #contextMenu: 34 1 752 560 3 8 #() 498 193 193 nil 27 8 'transactions' 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1149239552 1025 1328 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 8 '' nil nil 7 nil nil nil 1328 nil 8 1795912768 787206 ##(Smalltalk.NumberToText) nil 8 '' nil nil 1042 138 144 34 2 1106 #createWindow: 34 1 1154 1186 8 #[51 1 0 0 2 1 0 0 151 1 0 0 27 1 0 0] 193 1360 nil 1328 1106 #text: 34 1 8 '' 1328 3 8 #() 498 193 193 nil 27 8 'currentBalance' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 1760 nil 720 nil 7 nil nil nil 1760 nil 8 1795700448 1490 nil 8 '' nil 1 1042 138 144 34 1 1106 #createWindow: 34 1 1154 1186 8 #[142 0 0 0 93 0 0 0 146 1 0 0 118 0 0 0] 193 1792 nil 1760 3 8 #() 498 193 193 nil 27 8 'initialBalance' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 2048 nil 720 nil 7 nil nil nil 2048 nil 8 1795700448 852486 ##(Smalltalk.NullConverter) nil nil 1 1042 138 144 34 1 1106 #createWindow: 34 1 1154 1186 8 #[142 0 0 0 23 0 0 0 146 1 0 0 48 0 0 0] 193 2080 nil 2048 3 8 #() 498 193 193 nil 27 8 'name' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 2336 nil 720 nil 7 nil nil nil 2336 nil 8 1795700448 2130 nil nil 1 1042 138 144 34 1 1106 #createWindow: 34 1 1154 1186 8 #[142 0 0 0 58 0 0 0 146 1 0 0 83 0 0 0] 193 2368 nil 2336 3 8 #() 498 193 193 nil 27 8 'accountNumber' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 1 738 nil true 34 5 786 1 818 #newTransaction 8 '&New...' 1 1 nil nil nil 786 1 818 #editTransaction 8 '&Edit Transaction...' 1 1 nil nil nil 786 1 818 #removeTransaction 8 '&Delete Transaction' 1 1 nil nil nil 914 4097 786 1 818 #close 8 'E&xit' 1 1 nil nil nil 8 '&Transaction' nil 1 nil nil 11131 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 8807 nil nil nil nil 1 nil 193 1042 138 144 34 1 1106 #createWindow: 34 1 1154 590342 ##(Smalltalk.Rectangle) 498 6143 21 498 7013 791 193 448 8 'Personal Account Details' 416 1 34 15 2048 2336 1760 560 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3120 1394 nil nil 1440 8 'Account Name:' nil nil 7 nil nil nil 3120 nil 8 1795912768 2130 nil nil nil 1042 138 144 34 2 1106 #createWindow: 34 1 1154 1186 8 #[27 0 0 0 23 0 0 0 127 0 0 0 48 0 0 0] 193 3152 nil 3120 1106 #text: 34 1 8 'Account Name:' 3120 3 8 #() 498 193 193 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3456 1394 nil nil 1440 8 'Account Number:' nil nil 7 nil nil nil 3456 nil 8 1795912768 2130 nil nil nil 1042 138 144 34 2 1106 #createWindow: 34 1 1154 1186 8 #[27 0 0 0 58 0 0 0 137 0 0 0 83 0 0 0] 193 3488 nil 3456 1106 #text: 34 1 8 'Account Number:' 3456 3 8 #() 498 193 193 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3792 1394 nil nil 1440 8 'Initial Balance:' nil nil 7 nil nil nil 3792 nil 8 1795912768 2130 nil nil nil 1042 138 144 34 2 1106 #createWindow: 34 1 1154 1186 8 #[27 0 0 0 93 0 0 0 127 0 0 0 118 0 0 0] 193 3824 nil 3792 1106 #text: 34 1 8 'Initial Balance:' 3792 3 8 #() 498 193 193 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 4128 1394 nil nil 1440 8 'Transactions' nil nil 7 nil nil nil 4128 nil 8 1795912768 2130 nil nil nil 1042 138 144 34 2 1106 #createWindow: 34 1 1154 1186 8 #[17 0 0 0 138 0 0 0 117 0 0 0 158 0 0 0] 193 4160 nil 4128 1106 #text: 34 1 8 'Transactions' 4128 3 8 #() 498 193 193 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 4464 1394 nil nil 1440 8 'Balance:' nil nil 7 nil nil nil 4464 nil 8 1795912768 2130 nil nil nil 1042 138 144 34 2 1106 #createWindow: 34 1 1154 1186 8 #[242 0 0 0 7 1 0 0 46 1 0 0 27 1 0 0] 193 4496 nil 4464 1106 #text: 34 1 8 'Balance:' 4464 3 8 #() 498 193 193 nil 27 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 4800 nil 720 nil 7 nil nil nil 4800 nil 8 1795707744 818 #newTransaction 8 '&New' 1 1 nil nil false nil nil nil 1042 138 144 34 2 1106 #createWindow: 34 1 1154 1186 8 #[22 0 0 0 38 1 0 0 97 0 0 0 63 1 0 0] 193 4832 8 '&New' 4800 1106 #isEnabled: 8 #(false) 4800 3 8 #() 498 193 193 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 5120 nil 720 nil 7 nil nil nil 5120 nil 8 1795707744 818 #editTransaction 8 '&Edit' 1 1 nil nil true nil nil nil 1042 138 144 34 2 1106 #createWindow: 34 1 1154 1186 8 #[122 0 0 0 38 1 0 0 197 0 0 0 63 1 0 0] 193 5152 8 '&Edit' 5120 1106 #isEnabled: 8 #(false) 5120 3 8 #() 498 193 193 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 5440 nil 720 nil 7 nil nil nil 5440 nil 8 1795707744 818 #removeTransaction 8 '&Delete' 1 1 nil nil false nil nil nil 1042 138 144 34 2 1106 #createWindow: 34 1 1154 1186 8 #[227 0 0 0 38 1 0 0 46 1 0 0 63 1 0 0] 193 5472 8 '&Delete' 5440 1106 #isEnabled: 8 #(false) 5440 3 8 #() 498 193 193 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 5760 nil 720 nil 7 nil nil nil 5760 nil 8 1795707744 818 #exit 8 'E&xit' 1 1 nil nil false nil nil nil 1042 138 144 34 1 1106 #createWindow: 34 1 1154 1186 8 #[71 1 0 0 38 1 0 0 146 1 0 0 63 1 0 0] 193 5792 8 'E&xit' 5760 3 8 #() 498 193 193 nil 29 410 ##(Smalltalk.GroupBox) 34 14 nil 416 34 2 8 1140850695 65 6048 nil 720 nil 7 nil nil nil 6048 nil 8 1795707744 1042 138 144 34 1 1106 #createWindow: 34 1 1154 1186 8 #[17 0 0 0 8 0 0 0 156 1 0 0 128 0 0 0] 193 6080 8 '' 6048 3 8 #() 498 193 193 nil 27 1328 498 193 193 nil 27 )! !

!PersonalAccountShell class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

