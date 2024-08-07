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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13107200 65536) 32 nil 6 #{Graphics.Color} #face3d 518 #{Graphics.Point} 871 771 133 nil nil nil 32 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 10 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140920320 1025 208 nil 98 #default nil 5 nil nil nil 208 nil nil 518 #{UI.NullConverter} nil nil 1 #focusLost nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[142 0 0 0 58 0 0 0 146 1 0 0 83 0 0 0] 193 240 nil 208 3 8 #() 130 193 193 nil 45 8 'accountNumber' 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1149239552 1025 544 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 8 '' nil nil 5 nil nil nil 544 nil nil 1094 1 #{UI.NumberToText} nil 8 '' 326 1 #{Core.Locale} #userDefault nil nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[51 1 0 0 2 1 0 0 151 1 0 0 27 1 0 0] 193 576 nil 544 3 8 #() 130 193 193 nil 27 8 'currentBalance' 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140920320 1025 928 nil 272 nil 5 nil nil nil 928 nil nil 690 nil 8 '' 752 nil 1 #focusLost nil nil nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[142 0 0 0 93 0 0 0 146 1 0 0 118 0 0 0] 193 960 nil 928 3 8 #() 130 193 193 nil 45 8 'initialBalance' 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140920320 1025 1184 nil 272 nil 5 nil nil nil 1184 nil nil 290 nil nil 1 #focusLost nil nil nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[142 0 0 0 23 0 0 0 146 1 0 0 48 0 0 0] 193 1216 nil 1184 3 8 #() 130 193 193 nil 45 8 'name' 18 #{UI.ListBox} 50 17 nil 32 50 2 8 1144062209 1025 1424 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 272 nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #newTransaction 8 'New…' 1 1 nil nil nil 1634 1 1666 #editTransaction 8 'Edit…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1634 1 1666 #removeTransaction 8 'Delete' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1424 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() false 322 50 2 370 #createWindow: 50 1 418 450 8 #[17 0 0 0 158 0 0 0 156 1 0 0 253 0 0 0] 193 1456 8 '' 1424 370 #contextMenu: 50 1 1600 1424 3 8 #() 130 193 193 nil 27 8 'transactions' nil 2886 4 #{UI.MenuBar} nil true 50 1 1586 nil true 50 5 1634 1 1666 #newTransaction 8 '&New…' 1 1 nil nil nil 1634 1 1666 #editTransaction 8 '&Edit Transaction…' 1 1 nil nil nil 1634 1 1666 #removeTransaction 8 '&Delete Transaction' 1 1 nil nil nil 1762 4097 1634 1 1666 #close 8 'E&xit' 1 1 nil nil nil 8 '&Transaction' nil 1 nil nil nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil nil nil 193 322 50 1 370 #createWindow: 50 1 418 518 #{Graphics.Rectangle} 130 7679 21 130 8549 791 193 80 8 'Personal Account Details' 32 1 50 15 1184 208 928 1424 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2624 610 nil nil 656 8 'Account Name:' nil nil 5 nil nil nil 2624 nil nil 290 nil nil nil 322 50 2 370 #createWindow: 50 1 418 450 8 #[27 0 0 0 23 0 0 0 127 0 0 0 48 0 0 0] 193 2656 nil 2624 370 #text: 50 1 8 'Account Name:' 2624 3 8 #() 130 193 193 nil 27 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2928 610 nil nil 656 8 'Account Number:' nil nil 5 nil nil nil 2928 nil nil 290 nil nil nil 322 50 2 370 #createWindow: 50 1 418 450 8 #[27 0 0 0 58 0 0 0 137 0 0 0 83 0 0 0] 193 2960 nil 2928 370 #text: 50 1 8 'Account Number:' 2928 3 8 #() 130 193 193 nil 27 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 3232 610 nil nil 656 8 'Initial Balance:' nil nil 5 nil nil nil 3232 nil nil 290 nil nil nil 322 50 2 370 #createWindow: 50 1 418 450 8 #[27 0 0 0 93 0 0 0 127 0 0 0 118 0 0 0] 193 3264 nil 3232 370 #text: 50 1 8 'Initial Balance:' 3232 3 8 #() 130 193 193 nil 27 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 3536 610 nil nil 656 8 'Transactions' nil nil 5 nil nil nil 3536 nil nil 290 nil nil nil 322 50 2 370 #createWindow: 50 1 418 450 8 #[17 0 0 0 138 0 0 0 117 0 0 0 158 0 0 0] 193 3568 nil 3536 370 #text: 50 1 8 'Transactions' 3536 3 8 #() 130 193 193 nil 27 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 3840 610 nil nil 656 8 'Balance:' nil nil 5 nil nil nil 3840 nil nil 290 nil nil nil 322 50 2 370 #createWindow: 50 1 418 450 8 #[242 0 0 0 7 1 0 0 46 1 0 0 27 1 0 0] 193 3872 nil 3840 370 #text: 50 1 8 'Balance:' 3840 3 8 #() 130 193 193 nil 27 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 4144 nil 272 nil 5 nil nil nil 4144 nil nil 1666 #newTransaction 8 '&New' 1 1 nil nil false nil nil nil 322 50 2 370 #createWindow: 50 1 418 450 8 #[22 0 0 0 38 1 0 0 97 0 0 0 63 1 0 0] 193 4176 8 '&New' 4144 370 #isEnabled: 8 #(false) 4144 3 8 #() 130 193 193 nil 29 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 4432 nil 272 nil 5 nil nil nil 4432 nil nil 1666 #editTransaction 8 '&Edit' 1 1 nil nil true nil nil nil 322 50 2 370 #createWindow: 50 1 418 450 8 #[122 0 0 0 38 1 0 0 197 0 0 0 63 1 0 0] 193 4464 8 '&Edit' 4432 370 #isEnabled: 8 #(false) 4432 3 8 #() 130 193 193 nil 29 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 4720 nil 272 nil 5 nil nil nil 4720 nil nil 1666 #removeTransaction 8 '&Delete' 1 1 nil nil false nil nil nil 322 50 2 370 #createWindow: 50 1 418 450 8 #[227 0 0 0 38 1 0 0 46 1 0 0 63 1 0 0] 193 4752 8 '&Delete' 4720 370 #isEnabled: 8 #(false) 4720 3 8 #() 130 193 193 nil 29 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 5008 nil 272 nil 5 nil nil nil 5008 nil nil 1666 #exit 8 'E&xit' 1 1 nil nil false nil nil nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[71 1 0 0 38 1 0 0 146 1 0 0 63 1 0 0] 193 5040 8 'E&xit' 5008 3 8 #() 130 193 193 nil 29 18 #{UI.GroupBox} 50 14 nil 32 50 2 8 1140850695 65 5264 nil 272 nil 5 nil nil nil 5264 nil nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[17 0 0 0 8 0 0 0 156 1 0 0 128 0 0 0] 193 5296 8 '' 5264 3 8 #() 130 193 193 nil 27 544 130 193 193 nil 27)! !

!UI.Examples.PersonalAccountShell class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

