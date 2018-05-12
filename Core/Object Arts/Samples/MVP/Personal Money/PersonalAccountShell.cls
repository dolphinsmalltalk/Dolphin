"Filed out from Dolphin Smalltalk 7"!

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
!PersonalAccountShell categoriesFor: #createComponents!initializing!public! !
!PersonalAccountShell categoriesFor: #createSchematicWiring!initializing!public! !
!PersonalAccountShell categoriesFor: #editTransaction!commands!public! !
!PersonalAccountShell categoriesFor: #hasSelectedTransaction!public!testing! !
!PersonalAccountShell categoriesFor: #model:!accessing!public! !
!PersonalAccountShell categoriesFor: #newTransaction!commands!public! !
!PersonalAccountShell categoriesFor: #queryCommand:!commands!public! !
!PersonalAccountShell categoriesFor: #removeTransaction!commands!public! !
!PersonalAccountShell categoriesFor: #selectedTransactionOrNil!accessing!public! !
!PersonalAccountShell categoriesFor: #selectedTransactionOrNil:!accessing!public! !

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

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ShellView)  98 27 0 0 98 2 26214401 131073 416 0 721158 ##(SystemColor)  31 328198 ##(Point)  871 771 133 0 0 0 416 0 234 256 98 10 410 8 ##(TextEdit)  98 16 0 416 98 2 8 1140920320 1025 576 0 524550 ##(ColorRef)  8 4278190080 0 5 0 0 0 576 0 8 4294906635 787206 ##(NumberToText)  0 8 '' 0 1 983302 ##(MessageSequence)  202 208 98 3 721670 ##(MessageSend)  8 #createAt:extent: 98 2 514 285 187 514 521 51 576 834 8 #selectionRange: 98 1 525062 ##(Interval)  3 1 3 576 834 8 #isTextModified: 98 1 32 576 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 142 0 0 0 93 0 0 0 146 1 0 0 118 0 0 0] 98 0 514 193 193 0 27 8 'initialBalance' 410 8 ##(StaticText)  98 16 0 416 98 2 8 1149239552 1025 1152 721990 2 ##(ValueHolder)  0 0 1114638 ##(STBSingletonProxy)  8 ##(SearchPolicy)  8 #never 8 '' 0 0 5 0 0 0 1152 0 8 4294906439 722 0 8 '' 0 0 770 202 208 98 1 834 864 98 2 514 615 517 514 201 51 1152 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 2 1 0 0 151 1 0 0 27 1 0 0] 98 0 1120 0 27 8 'currentBalance' 410 592 98 16 0 416 98 2 8 1140920320 1025 1568 0 658 688 0 5 0 0 0 1568 0 8 4294906635 852486 ##(NullConverter)  0 0 1 770 202 208 98 3 834 864 98 2 514 285 117 514 521 51 1568 834 944 98 1 978 3 1 3 1568 834 1024 98 1 32 1568 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 142 0 0 0 58 0 0 0 146 1 0 0 83 0 0 0] 98 0 1120 0 27 8 'accountNumber' 410 8 ##(ListBox)  98 17 0 416 98 2 8 1144062209 1025 1952 590662 2 ##(ListModel)  202 208 98 0 0 1274 1296 8 #identity 658 688 0 5 265030 4 ##(Menu)  0 16 98 4 984134 2 ##(CommandMenuItem)  1 1180998 4 ##(CommandDescription)  8 #newTransaction 8 'New...' 1 1 0 0 0 2194 1 2226 8 #editTransaction 8 'Edit...' 1 1 0 0 0 983366 1 ##(DividerMenuItem)  4097 2194 1 2226 8 #removeTransaction 8 'Delete' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 1952 0 8 4294903705 8 ##(BasicListAbstract)  2080 32 770 202 208 98 3 834 864 98 2 514 35 317 514 791 191 1952 834 8 #contextMenu: 98 1 2160 1952 834 8 #horizontalExtent: 98 1 1 1952 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 158 0 0 0 156 1 0 0 253 0 0 0] 98 0 1120 0 27 8 'transactions' 410 592 98 16 0 416 98 2 8 1140920320 1025 2768 0 658 688 0 5 0 0 0 2768 0 8 4294906635 1666 0 0 1 770 202 208 98 3 834 864 98 2 514 285 47 514 521 51 2768 834 944 98 1 978 3 1 3 2768 834 1024 98 1 32 2768 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 142 0 0 0 23 0 0 0 146 1 0 0 48 0 0 0] 98 0 1120 0 27 8 'name' 590342 ##(Rectangle)  514 1 1 514 1 1 461638 4 ##(MenuBar)  0 16 98 1 2146 0 16 98 5 2194 1 2226 2256 8 '&New...' 1 1 0 0 0 2194 1 2226 2320 8 '&Edit Transaction...' 1 1 0 0 0 2194 1 2226 2416 8 '&Delete Transaction' 1 1 0 0 0 2354 4097 2194 1 2226 8 #close 8 'E&xit' 1 1 0 0 0 8 '&Transaction' 0 1 0 0 36163 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 13607 0 0 0 0 1 0 0 770 202 208 98 3 834 864 98 2 514 1165 815 514 871 771 416 834 8 #text: 98 1 8 'Personal Account Details' 416 834 8 #menuBar: 98 1 3216 416 1058 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 2 0 0 151 1 0 0 249 3 0 0 24 3 0 0] 98 15 2768 1568 576 1952 410 1168 98 16 0 416 98 2 8 1140850944 1 3808 1234 0 0 1280 8 'Account Name:' 0 0 5 0 0 0 3808 0 8 4294906439 1666 0 0 0 770 202 208 98 2 834 864 98 2 514 55 47 514 201 51 3808 834 3664 98 1 8 'Account Name:' 3808 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 23 0 0 0 127 0 0 0 48 0 0 0] 98 0 1120 0 27 410 1168 98 16 0 416 98 2 8 1140850944 1 4144 1234 0 0 1280 8 'Account Number:' 0 0 5 0 0 0 4144 0 8 4294906439 1666 0 0 0 770 202 208 98 2 834 864 98 2 514 55 117 514 221 51 4144 834 3664 98 1 8 'Account Number:' 4144 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 58 0 0 0 137 0 0 0 83 0 0 0] 98 0 1120 0 27 410 1168 98 16 0 416 98 2 8 1140850944 1 4480 1234 0 0 1280 8 'Initial Balance:' 0 0 5 0 0 0 4480 0 8 4294906439 1666 0 0 0 770 202 208 98 2 834 864 98 2 514 55 187 514 201 51 4480 834 3664 98 1 8 'Initial Balance:' 4480 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 93 0 0 0 127 0 0 0 118 0 0 0] 98 0 1120 0 27 410 1168 98 16 0 416 98 2 8 1140850944 1 4816 1234 0 0 1280 8 'Transactions' 0 0 5 0 0 0 4816 0 8 4294906439 1666 0 0 0 770 202 208 98 2 834 864 98 2 514 35 277 514 201 41 4816 834 3664 98 1 8 'Transactions' 4816 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 138 0 0 0 117 0 0 0 158 0 0 0] 98 0 1120 0 27 410 1168 98 16 0 416 98 2 8 1140850944 1 5152 1234 0 0 1280 8 'Balance:' 0 0 5 0 0 0 5152 0 8 4294906439 1666 0 0 0 770 202 208 98 2 834 864 98 2 514 485 527 514 121 41 5152 834 3664 98 1 8 'Balance:' 5152 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 242 0 0 0 7 1 0 0 46 1 0 0 27 1 0 0] 98 0 1120 0 27 410 8 ##(PushButton)  98 17 0 416 98 2 8 1140924416 1 5488 0 658 688 0 5 0 0 0 5488 0 8 4294906781 2226 2256 8 '&New' 1 1 0 0 32 770 202 208 98 2 834 864 98 2 514 45 597 514 151 61 5488 834 3664 98 1 8 '&New' 5488 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 22 0 0 0 42 1 0 0 97 0 0 0 72 1 0 0] 98 0 1120 0 27 410 5504 98 17 0 416 98 2 8 1140924416 1 5840 0 658 688 0 5 0 0 0 5840 0 8 4294906781 2226 2320 8 '&Edit' 1 1 0 0 16 770 202 208 98 2 834 864 98 2 514 245 597 514 151 61 5840 834 3664 98 1 8 '&Edit' 5840 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 42 1 0 0 197 0 0 0 72 1 0 0] 98 0 1120 0 27 410 5504 98 17 0 416 98 2 8 1140924416 1 6176 0 658 688 0 5 0 0 0 6176 0 8 4294906781 2226 2416 8 '&Delete' 1 1 0 0 32 770 202 208 98 2 834 864 98 2 514 455 597 514 151 61 6176 834 3664 98 1 8 '&Delete' 6176 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 227 0 0 0 42 1 0 0 46 1 0 0 72 1 0 0] 98 0 1120 0 27 410 5504 98 17 0 416 98 2 8 1140924416 1 6512 0 658 688 0 5 0 0 0 6512 0 8 4294906781 2226 8 #exit 8 'E&xit' 1 1 0 0 32 770 202 208 98 2 834 864 98 2 514 655 597 514 151 61 6512 834 3664 98 1 8 'E&xit' 6512 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 71 1 0 0 42 1 0 0 146 1 0 0 72 1 0 0] 98 0 1120 0 27 410 8 ##(GroupBox)  98 14 0 416 98 2 8 1140850695 65 6864 0 658 688 0 5 0 0 0 6864 0 8 4294906781 770 202 208 98 1 834 864 98 2 514 35 17 514 791 241 6864 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 8 0 0 0 156 1 0 0 128 0 0 0] 98 0 1120 0 27 1152 1120 0 27 )! !
!PersonalAccountShell class categoriesFor: #defaultModel!models!public! !
!PersonalAccountShell class categoriesFor: #resource_Default_view!public!resources-views! !

