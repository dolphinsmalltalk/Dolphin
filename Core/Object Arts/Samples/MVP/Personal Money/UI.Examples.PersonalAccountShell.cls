"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'UI.Examples.PersonalAccountShell'
	instanceVariableNames: 'namePresenter accountNumberPresenter initialBalancePresenter transactionsPresenter currentBalancePresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.PersonalAccountShell guid: (Core.GUID fromString: '{87b4c69d-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.Examples.PersonalAccountShell comment: 'PersonalAccountShell is a <topPresenter> for displaying and editing a <PersonalAccount> model. It displays the list of <PersonalAccountTransaction>s currently held by the account together with the initial and current balances. The ability to create, delete and modify existing transactions is provided.

Example of an PersonalAccountShell operating on a new account:
PersonalAccountShell show

Instance Variables:
	namePresenter		<TextPresenter> holding the account name.
	accountNumberPresenter	<TextPresenter> holding the account number.
	initialBalancePresenter	<NumberPresenter> holding the initial balance.
	transactionsPresenter		<ListPresenter> holding a list of <PersonalAccountTransaction>s.
	currentBalancePresenter	<NumberPresenter> displaying the current balance.



'!
!UI.Examples.PersonalAccountShell categoriesForClass!MVP-Presenters!Samples! !
!UI.Examples.PersonalAccountShell methodsFor!

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
	transaction notNil
		ifTrue: 
			[self model removeTransaction: transaction.
			PersonalAccountTransactionDialog showModalOn: transaction.
			self model addTransaction: transaction.
			self selectedTransactionOrNil: transaction]!

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
	(newTransaction := PersonalAccountTransactionDialog showModal) notNil
		ifTrue: 
			[self model addTransaction: newTransaction.
			self selectedTransactionOrNil: newTransaction]!

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
!UI.Examples.PersonalAccountShell categoriesForMethods!
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

!UI.Examples.PersonalAccountShell class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^PersonalAccount new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13107200 65536) 416 nil 917510 #{Graphics.Color} #face3d 918022 #{Graphics.Point} 871 771 167 nil nil nil 416 nil 170 192 34 10 410 #{UI.ListBox} 34 17 nil 416 34 2 8 1144062209 1025 560 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 466 #default nil 7 461638 4 #{UI.Menu} nil true 34 4 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #newTransaction 8 'New…' 1 1 nil nil nil 786 1 818 #editTransaction 8 'Edit…' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 786 1 818 #removeTransaction 8 'Delete' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 560 nil 8 1814640640 786950 #{Core.Message} #displayString 672 8 #() false 1310982 #{Core.MessageSequence} 34 3 1049350 #{Core.MessageSend} #createAt:extent: 34 2 498 35 317 498 791 191 560 1122 #contextMenu: 34 1 752 560 1122 #horizontalExtent: 8 #(0) 560 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 158 0 0 0 156 1 0 0 253 0 0 0] 8 #() 498 193 193 nil 27 8 'transactions' 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1149239552 1025 1360 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} 8 '' nil nil 7 nil nil nil 1360 nil 8 1815137184 984134 1 #{UI.NumberToText} nil 8 '' 721222 1 #{Core.Locale} #userDefault nil nil 1074 34 1 1122 #createAt:extent: 34 2 498 615 517 498 201 51 1360 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 2 1 0 0 151 1 0 0 27 1 0 0] 8 #() 1328 nil 27 8 'currentBalance' 410 #{UI.TextEdit} 34 16 nil 416 34 2 8 1140920320 1025 1760 nil 720 nil 7 nil nil nil 1760 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 1 1074 34 1 1122 #createAt:extent: 34 2 498 285 117 498 521 51 1760 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 142 0 0 0 58 0 0 0 146 1 0 0 83 0 0 0] 8 #() 1328 nil 27 8 'accountNumber' 410 #{UI.TextEdit} 34 16 nil 416 34 2 8 1140920320 1025 2032 nil 720 nil 7 nil nil nil 2032 nil 8 1815092992 1522 nil 8 '' 1584 nil 1 1074 34 1 1122 #createAt:extent: 34 2 498 285 187 498 521 51 2032 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 142 0 0 0 93 0 0 0 146 1 0 0 118 0 0 0] 8 #() 1328 nil 27 8 'initialBalance' 410 #{UI.TextEdit} 34 16 nil 416 34 2 8 1140920320 1025 2304 nil 720 nil 7 nil nil nil 2304 nil 8 1815092992 1842 nil nil 1 1074 34 1 1122 #createAt:extent: 34 2 498 285 47 498 521 51 2304 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 142 0 0 0 23 0 0 0 146 1 0 0 48 0 0 0] 8 #() 1328 nil 27 8 'name' 1180166 #{Graphics.Rectangle} 498 1 1 498 1 1 658246 4 #{UI.MenuBar} nil true 34 1 738 nil true 34 5 786 1 818 #newTransaction 8 '&New…' 1 1 nil nil nil 786 1 818 #editTransaction 8 '&Edit Transaction…' 1 1 nil nil nil 786 1 818 #removeTransaction 8 '&Delete Transaction' 1 1 nil nil nil 914 4097 786 1 818 #close 8 'E&xit' 1 1 nil nil nil 8 '&Transaction' nil 1 nil nil 10095 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 42343 nil nil nil nil 1 nil nil 1074 34 2 1122 #createAt:extent: 34 2 498 12287 21 498 871 771 416 1122 #text: 34 1 8 'Personal Account Details' 416 1266 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 178 25 0 0 139 1 0 0] 34 15 2304 1760 2032 560 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 3136 1426 nil nil 1472 8 'Account Name:' nil nil 7 nil nil nil 3136 nil 8 1815137184 1842 nil nil nil 1074 34 2 1122 #createAt:extent: 34 2 498 55 47 498 201 51 3136 1122 #text: 34 1 8 'Account Name:' 3136 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 23 0 0 0 127 0 0 0 48 0 0 0] 8 #() 1328 nil 27 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 3456 1426 nil nil 1472 8 'Account Number:' nil nil 7 nil nil nil 3456 nil 8 1815137184 1842 nil nil nil 1074 34 2 1122 #createAt:extent: 34 2 498 55 117 498 221 51 3456 1122 #text: 34 1 8 'Account Number:' 3456 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 58 0 0 0 137 0 0 0 83 0 0 0] 8 #() 1328 nil 27 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 3776 1426 nil nil 1472 8 'Initial Balance:' nil nil 7 nil nil nil 3776 nil 8 1815137184 1842 nil nil nil 1074 34 2 1122 #createAt:extent: 34 2 498 55 187 498 201 51 3776 1122 #text: 34 1 8 'Initial Balance:' 3776 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 93 0 0 0 127 0 0 0 118 0 0 0] 8 #() 1328 nil 27 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 4096 1426 nil nil 1472 8 'Transactions' nil nil 7 nil nil nil 4096 nil 8 1815137184 1842 nil nil nil 1074 34 2 1122 #createAt:extent: 34 2 498 35 277 498 201 41 4096 1122 #text: 34 1 8 'Transactions' 4096 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 138 0 0 0 117 0 0 0 158 0 0 0] 8 #() 1328 nil 27 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 4416 1426 nil nil 1472 8 'Balance:' nil nil 7 nil nil nil 4416 nil 8 1815137184 1842 nil nil nil 1074 34 2 1122 #createAt:extent: 34 2 498 485 527 498 121 41 4416 1122 #text: 34 1 8 'Balance:' 4416 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 242 0 0 0 7 1 0 0 46 1 0 0 27 1 0 0] 8 #() 1328 nil 27 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140924416 1 4736 nil 720 nil 7 nil nil nil 4736 nil 8 1815097472 818 #newTransaction 8 '&New' 1 1 nil nil false nil nil nil 1074 34 3 1122 #createAt:extent: 34 2 498 45 589 498 151 51 4736 1122 #isEnabled: 8 #(false) 4736 1122 #text: 34 1 8 '&New' 4736 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 22 0 0 0 38 1 0 0 97 0 0 0 63 1 0 0] 8 #() 1328 nil 29 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140924416 1 5072 nil 720 nil 7 nil nil nil 5072 nil 8 1815097472 818 #editTransaction 8 '&Edit' 1 1 nil nil true nil nil nil 1074 34 3 1122 #createAt:extent: 34 2 498 245 589 498 151 51 5072 1122 #isEnabled: 8 #(false) 5072 1122 #text: 34 1 8 '&Edit' 5072 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 38 1 0 0 197 0 0 0 63 1 0 0] 8 #() 1328 nil 29 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140924416 1 5408 nil 720 nil 7 nil nil nil 5408 nil 8 1815097472 818 #removeTransaction 8 '&Delete' 1 1 nil nil false nil nil nil 1074 34 3 1122 #createAt:extent: 34 2 498 455 589 498 151 51 5408 1122 #isEnabled: 8 #(false) 5408 1122 #text: 34 1 8 '&Delete' 5408 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 227 0 0 0 38 1 0 0 46 1 0 0 63 1 0 0] 8 #() 1328 nil 29 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140924416 1 5744 nil 720 nil 7 nil nil nil 5744 nil 8 1815097472 818 #exit 8 'E&xit' 1 1 nil nil false nil nil nil 1074 34 2 1122 #createAt:extent: 34 2 498 655 589 498 151 51 5744 1122 #text: 34 1 8 'E&xit' 5744 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 71 1 0 0 38 1 0 0 146 1 0 0 63 1 0 0] 8 #() 1328 nil 29 410 #{UI.GroupBox} 34 14 nil 416 34 2 8 1140850695 65 6048 nil 720 nil 7 nil nil nil 6048 nil 8 1815097472 1074 34 1 1122 #createAt:extent: 34 2 498 35 17 498 791 241 6048 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 8 0 0 0 156 1 0 0 128 0 0 0] 8 #() 1328 nil 27 1360 1328 nil 27)! !
!UI.Examples.PersonalAccountShell class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

