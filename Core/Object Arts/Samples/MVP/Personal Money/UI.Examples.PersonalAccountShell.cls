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

	<commandQuery: #hasSelectedTransaction>
	| transaction |
	transaction := self selectedTransaction.
	self model removeTransaction: transaction.
	PersonalAccountTransactionDialog showModalOn: transaction.
	self model addTransaction: transaction.
	self selectedTransaction: transaction!

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
			self selectedTransaction: newTransaction]!

removeTransaction
	"Removes the current transaction from the receiver's model"

	<commandQuery: #hasSelectedTransaction>
	self model removeTransaction: self selectedTransaction!

selectedTransaction
	"Answer the currently selected transaction or nil if there is none"

	^transactionsPresenter selection!

selectedTransaction: aPersonalAccountTransactionOrNil
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
removeTransaction!commands!public! !
selectedTransaction!public! !
selectedTransaction:!public! !
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13107200 65536) 32 nil 6 #{Graphics.Color} #face3d 518 #{Graphics.Point} 871 771 133 nil nil nil 32 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 10 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140920320 1025 208 nil 98 #default nil 5 nil nil nil 208 nil nil 518 #{UI.NullConverter} nil nil 1 #focusLost nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 130 285 117 130 521 51 208 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 142 0 0 0 58 0 0 0 146 1 0 0 83 0 0 0] 8 #() 130 193 193 nil 45 8 'accountNumber' 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1149239552 1025 544 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 8 '' nil nil 5 nil nil nil 544 nil nil 1094 1 #{UI.NumberToText} nil 8 '' 326 1 #{Core.Locale} #userDefault nil nil 322 50 1 370 #createAt:extent: 50 2 130 615 517 130 201 51 544 450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 2 1 0 0 151 1 0 0 27 1 0 0] 8 #() 512 nil 27 8 'currentBalance' 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140920320 1025 928 nil 272 nil 5 nil nil nil 928 nil nil 690 nil 8 '' 752 nil 1 #focusLost nil nil nil 322 50 1 370 #createAt:extent: 50 2 130 285 187 130 521 51 928 450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 142 0 0 0 93 0 0 0 146 1 0 0 118 0 0 0] 8 #() 512 nil 45 8 'initialBalance' 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140920320 1025 1184 nil 272 nil 5 nil nil nil 1184 nil nil 290 nil nil 1 #focusLost nil nil nil 322 50 1 370 #createAt:extent: 50 2 130 285 47 130 521 51 1184 450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 142 0 0 0 23 0 0 0 146 1 0 0 48 0 0 0] 8 #() 512 nil 45 8 'name' 18 #{UI.ListBox} 50 17 nil 32 50 2 8 1144062209 1025 1424 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 272 nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #newTransaction 8 'New…' 1 1 nil nil nil 1634 1 1666 #editTransaction 8 'Edit…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1634 1 1666 #removeTransaction 8 'Delete' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1424 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() false 322 50 2 370 #createAt:extent: 50 2 130 35 317 130 791 191 1424 370 #horizontalExtent: 8 #(0) 1424 450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 158 0 0 0 156 1 0 0 253 0 0 0] 8 #() 512 nil 27 8 'transactions' 518 #{Graphics.Rectangle} 130 1 1 130 1 1 2886 4 #{UI.MenuBar} nil true 50 1 1586 nil true 50 5 1634 1 1666 #newTransaction 8 '&New…' 1 1 nil nil nil 1634 1 1666 #editTransaction 8 '&Edit Transaction…' 1 1 nil nil nil 1634 1 1666 #removeTransaction 8 '&Delete Transaction' 1 1 nil nil nil 1762 4097 1634 1 1666 #close 8 'E&xit' 1 1 nil nil nil 8 '&Transaction' nil 1 nil nil nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 322 50 2 370 #createAt:extent: 50 2 130 6143 21 130 871 771 32 370 #text: 50 1 8 'Personal Account Details' 32 450 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 178 13 0 0 139 1 0 0] 50 15 1184 208 928 1424 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2688 610 nil nil 656 8 'Account Name:' nil nil 5 nil nil nil 2688 nil nil 290 nil nil nil 322 50 2 370 #createAt:extent: 50 2 130 55 47 130 201 51 2688 370 #text: 50 1 8 'Account Name:' 2688 450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 23 0 0 0 127 0 0 0 48 0 0 0] 8 #() 512 nil 27 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2992 610 nil nil 656 8 'Account Number:' nil nil 5 nil nil nil 2992 nil nil 290 nil nil nil 322 50 2 370 #createAt:extent: 50 2 130 55 117 130 221 51 2992 370 #text: 50 1 8 'Account Number:' 2992 450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 58 0 0 0 137 0 0 0 83 0 0 0] 8 #() 512 nil 27 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 3296 610 nil nil 656 8 'Initial Balance:' nil nil 5 nil nil nil 3296 nil nil 290 nil nil nil 322 50 2 370 #createAt:extent: 50 2 130 55 187 130 201 51 3296 370 #text: 50 1 8 'Initial Balance:' 3296 450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 93 0 0 0 127 0 0 0 118 0 0 0] 8 #() 512 nil 27 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 3600 610 nil nil 656 8 'Transactions' nil nil 5 nil nil nil 3600 nil nil 290 nil nil nil 322 50 2 370 #createAt:extent: 50 2 130 35 277 130 201 41 3600 370 #text: 50 1 8 'Transactions' 3600 450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 138 0 0 0 117 0 0 0 158 0 0 0] 8 #() 512 nil 27 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 3904 610 nil nil 656 8 'Balance:' nil nil 5 nil nil nil 3904 nil nil 290 nil nil nil 322 50 2 370 #createAt:extent: 50 2 130 485 527 130 121 41 3904 370 #text: 50 1 8 'Balance:' 3904 450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 242 0 0 0 7 1 0 0 46 1 0 0 27 1 0 0] 8 #() 512 nil 27 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 4208 nil 272 nil 5 nil nil nil 4208 nil nil 1666 #newTransaction 8 '&New' 1 1 nil nil false nil nil nil 322 50 3 370 #createAt:extent: 50 2 130 45 589 130 151 51 4208 370 #isEnabled: 8 #(false) 4208 370 #text: 50 1 8 '&New' 4208 450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 22 0 0 0 38 1 0 0 97 0 0 0 63 1 0 0] 8 #() 512 nil 29 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 4528 nil 272 nil 5 nil nil nil 4528 nil nil 1666 #editTransaction 8 '&Edit' 1 1 nil nil true nil nil nil 322 50 3 370 #createAt:extent: 50 2 130 245 589 130 151 51 4528 370 #isEnabled: 8 #(false) 4528 370 #text: 50 1 8 '&Edit' 4528 450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 0 0 0 38 1 0 0 197 0 0 0 63 1 0 0] 8 #() 512 nil 29 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 4848 nil 272 nil 5 nil nil nil 4848 nil nil 1666 #removeTransaction 8 '&Delete' 1 1 nil nil false nil nil nil 322 50 3 370 #createAt:extent: 50 2 130 455 589 130 151 51 4848 370 #isEnabled: 8 #(false) 4848 370 #text: 50 1 8 '&Delete' 4848 450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 227 0 0 0 38 1 0 0 46 1 0 0 63 1 0 0] 8 #() 512 nil 29 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 5168 nil 272 nil 5 nil nil nil 5168 nil nil 1666 #exit 8 'E&xit' 1 1 nil nil false nil nil nil 322 50 2 370 #createAt:extent: 50 2 130 655 589 130 151 51 5168 370 #text: 50 1 8 'E&xit' 5168 450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 71 1 0 0 38 1 0 0 146 1 0 0 63 1 0 0] 8 #() 512 nil 29 18 #{UI.GroupBox} 50 14 nil 32 50 2 8 1140850695 65 5456 nil 272 nil 5 nil nil nil 5456 nil nil 322 50 1 370 #createAt:extent: 50 2 130 35 17 130 791 241 5456 450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 8 0 0 0 156 1 0 0 128 0 0 0] 8 #() 512 nil 27 544 512 nil 27)! !

!UI.Examples.PersonalAccountShell class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

