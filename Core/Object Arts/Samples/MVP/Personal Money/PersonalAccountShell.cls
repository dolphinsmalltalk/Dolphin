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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13107200 65536) 416 nil 721158 ##(Smalltalk.SystemColor) 31 328198 ##(Smalltalk.Point) 871 771 165 nil nil nil 416 nil 170 192 34 10 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 560 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 7 nil nil nil 560 nil 8 1915280032 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 285 47 498 521 51 560 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 142 0 0 0 23 0 0 0 146 1 0 0 48 0 0 0] 8 #() 498 193 193 nil 27 8 'name' 410 ##(Smalltalk.ListBox) 34 17 nil 416 34 2 8 1144062209 1025 960 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 640 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #newTransaction 8 'New...' 1 1 nil nil nil 1170 1 1202 #editTransaction 8 'Edit...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1170 1 1202 #removeTransaction 8 'Delete' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 960 nil 8 1914995680 ##(Smalltalk.BasicListAbstract) 1072 false 722 138 144 34 3 786 #createAt:extent: 34 2 498 35 317 498 791 191 960 786 #contextMenu: 34 1 1136 960 786 #horizontalExtent: 8 #(0) 960 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 158 0 0 0 156 1 0 0 253 0 0 0] 8 #() 928 nil 27 8 'transactions' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 1648 nil 640 nil 7 nil nil nil 1648 nil 8 1915280032 690 nil nil 1 722 138 144 34 1 786 #createAt:extent: 34 2 498 285 117 498 521 51 1648 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 142 0 0 0 58 0 0 0 146 1 0 0 83 0 0 0] 8 #() 928 nil 27 8 'accountNumber' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 1920 nil 640 nil 7 nil nil nil 1920 nil 8 1915280032 787206 ##(Smalltalk.NumberToText) nil 8 '' nil 1 722 138 144 34 1 786 #createAt:extent: 34 2 498 285 187 498 521 51 1920 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 142 0 0 0 93 0 0 0 146 1 0 0 118 0 0 0] 8 #() 928 nil 27 8 'initialBalance' 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1149239552 1025 2224 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 8 '' nil nil 7 nil nil nil 2224 nil 8 1915124368 2002 nil 8 '' nil nil 722 138 144 34 1 786 #createAt:extent: 34 2 498 615 517 498 201 51 2224 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 2 1 0 0 151 1 0 0 27 1 0 0] 8 #() 928 nil 27 8 'currentBalance' 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 461638 4 ##(Smalltalk.MenuBar) nil true 34 1 1122 nil true 34 5 1170 1 1202 #newTransaction 8 '&New...' 1 1 nil nil nil 1170 1 1202 #editTransaction 8 '&Edit Transaction...' 1 1 nil nil nil 1170 1 1202 #removeTransaction 8 '&Delete Transaction' 1 1 nil nil nil 1298 4097 1170 1 1202 #close 8 'E&xit' 1 1 nil nil nil 8 '&Transaction' nil 1 nil nil 8567 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 10483 nil nil nil nil 1 nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 498 3839 21 498 871 771 416 786 #text: 34 1 8 'Personal Account Details' 416 786 #updateMenuBar 1072 416 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 50 9 0 0 139 1 0 0] 34 15 560 1648 1920 960 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3200 2290 nil nil 2336 8 'Account Name:' nil nil 7 nil nil nil 3200 nil 8 1915124368 690 nil nil nil 722 138 144 34 2 786 #createAt:extent: 34 2 498 55 47 498 201 51 3200 786 #text: 34 1 8 'Account Name:' 3200 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 23 0 0 0 127 0 0 0 48 0 0 0] 8 #() 928 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3536 2290 nil nil 2336 8 'Account Number:' nil nil 7 nil nil nil 3536 nil 8 1915124368 690 nil nil nil 722 138 144 34 2 786 #createAt:extent: 34 2 498 55 117 498 221 51 3536 786 #text: 34 1 8 'Account Number:' 3536 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 58 0 0 0 137 0 0 0 83 0 0 0] 8 #() 928 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3872 2290 nil nil 2336 8 'Initial Balance:' nil nil 7 nil nil nil 3872 nil 8 1915124368 690 nil nil nil 722 138 144 34 2 786 #createAt:extent: 34 2 498 55 187 498 201 51 3872 786 #text: 34 1 8 'Initial Balance:' 3872 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 93 0 0 0 127 0 0 0 118 0 0 0] 8 #() 928 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 4208 2290 nil nil 2336 8 'Transactions' nil nil 7 nil nil nil 4208 nil 8 1915124368 690 nil nil nil 722 138 144 34 2 786 #createAt:extent: 34 2 498 35 277 498 201 41 4208 786 #text: 34 1 8 'Transactions' 4208 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 138 0 0 0 117 0 0 0 158 0 0 0] 8 #() 928 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 4544 2290 nil nil 2336 8 'Balance:' nil nil 7 nil nil nil 4544 nil 8 1915124368 690 nil nil nil 722 138 144 34 2 786 #createAt:extent: 34 2 498 485 527 498 121 41 4544 786 #text: 34 1 8 'Balance:' 4544 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 242 0 0 0 7 1 0 0 46 1 0 0 27 1 0 0] 8 #() 928 nil 27 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 4880 nil 640 nil 7 nil nil nil 4880 nil 8 1915188384 1202 #newTransaction 8 '&New' 1 1 nil nil false nil nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 498 45 589 498 151 51 4880 786 #isEnabled: 8 #(false) 4880 786 #text: 34 1 8 '&New' 4880 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 22 0 0 0 38 1 0 0 97 0 0 0 63 1 0 0] 8 #() 928 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 5232 nil 640 nil 7 nil nil nil 5232 nil 8 1915188384 1202 #editTransaction 8 '&Edit' 1 1 nil nil true nil nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 498 245 589 498 151 51 5232 786 #isEnabled: 8 #(false) 5232 786 #text: 34 1 8 '&Edit' 5232 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 38 1 0 0 197 0 0 0 63 1 0 0] 8 #() 928 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 5584 nil 640 nil 7 nil nil nil 5584 nil 8 1915188384 1202 #removeTransaction 8 '&Delete' 1 1 nil nil false nil nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 498 455 589 498 151 51 5584 786 #isEnabled: 8 #(false) 5584 786 #text: 34 1 8 '&Delete' 5584 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 227 0 0 0 38 1 0 0 46 1 0 0 63 1 0 0] 8 #() 928 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 5936 nil 640 nil 7 nil nil nil 5936 nil 8 1915188384 1202 #exit 8 'E&xit' 1 1 nil nil false nil nil nil 722 138 144 34 2 786 #createAt:extent: 34 2 498 655 589 498 151 51 5936 786 #text: 34 1 8 'E&xit' 5936 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 71 1 0 0 38 1 0 0 146 1 0 0 63 1 0 0] 8 #() 928 nil 29 410 ##(Smalltalk.GroupBox) 34 14 nil 416 34 2 8 1140850695 65 6256 nil 640 nil 7 nil nil nil 6256 nil 8 1915188384 722 138 144 34 1 786 #createAt:extent: 34 2 498 35 17 498 791 241 6256 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 8 0 0 0 156 1 0 0 128 0 0 0] 8 #() 928 nil 27 2224 928 nil 27 )! !
!PersonalAccountShell class categoriesFor: #defaultModel!models!public! !
!PersonalAccountShell class categoriesFor: #resource_Default_view!public!resources-views! !

