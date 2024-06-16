"Filed out from Dolphin Smalltalk"!

AbstractDocumentShell subclass: #PersonalMoneyShell
	instanceVariableNames: 'ownerPresenter accountsPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PersonalMoneyShell guid: (GUID fromString: '{87b4c6b9-026e-11d3-9fd7-00a0cc3e4a32}')!

PersonalMoneyShell comment: 'PersonalMoneyShell is a <documentPresenter> providing the main user interface for the Personal Money sample system. The interface is displayed in a top level shell window. The model data on which the PersonalMoneyShell operates is an instance of <PersonalMoney>. Since the class conforms to <documentPresenter> it automatically has the ability to save and load the PersonalMoney data to/from disk.

To create a new Personal Money system evaluate:

PersonalMoneyShell show.

Instance Variables:
	ownerPresenter	<TextPresenter> holding the owners name.
	accountsPresenter	<ListPresenter> holding a list of <PersonalAccount>s.

'!

!PersonalMoneyShell categoriesForClass!MVP-Presenters!Samples! !

!PersonalMoneyShell methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	ownerPresenter := self add: TextPresenter new name: 'owner'.
	accountsPresenter := self add: ListPresenter new name: 'accounts'.
!

createSchematicWiring
	"Create the trigger wiring for the receiver"
	
	super createSchematicWiring.
	accountsPresenter when: #actionPerformed send: #editAccount to: self.
	!

editAccount
	"Edit the selected account"

	self hasSelectedAccount 
		ifTrue: 
			[| account shell |
			account := self selectedAccountOrNil.
			shell := PersonalAccountShell showOn: account.
			shell 
				when: #viewClosed
				send: #updateAccount:
				to: self
				with: account]!

hasSelectedAccount
	"Answer true it there is a currently selected account in the receiver"

	^accountsPresenter hasSelection!

model: aPersonalMoney
	"Set the model associated with the receiver."

	super model: aPersonalMoney.
	ownerPresenter model: (aPersonalMoney aspectValue: #owner).
	accountsPresenter model: (aPersonalMoney accounts).

!

newAccount
	"Prompt for a new account and add it to the receiver's model"

	| newAccount |
	newAccount := self model addAccount: PersonalAccount new.
	self selectedAccountOrNil: newAccount.
	self editAccount
	!

queryCommand: aCommandQuery
	"Private - Enters details about a potential command for the receiver into aCommandQuery"

	super queryCommand: aCommandQuery.
	(#(editAccount removeAccount) includes: aCommandQuery command) ifTrue: [
		aCommandQuery isEnabled: self hasSelectedAccount ]!

removeAccount
	"Removes the current account from the receiver's model"

	self hasSelectedAccount ifTrue: [
		self model removeAccount: self selectedAccountOrNil ]
	!

selectedAccountOrNil
	"Answer the currently selected account or nil if there is none"

	^accountsPresenter selectionOrNil!

selectedAccountOrNil: aPersonalAccountOrNil
	"Sets the currently selected account to aPersonalAccountOrNil.
	If nil if there will be no selection"

	^accountsPresenter selectionOrNil: aPersonalAccountOrNil!

streamIn: aStream
	"Private - Stream the receiver's model contents in from aStream"

	self setDocumentData: (Object binaryReadFrom: aStream)!

streamOut: aStream
	"Private - Stream the receiver's model out to aStream"

	self getDocumentData binaryStoreOn: aStream!

updateAccount: aPersonalAccount
	"Update aPersonalAccount in the accounts list"

	self model accounts refresh: aPersonalAccount! !

!PersonalMoneyShell categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
editAccount!commands!public! !
hasSelectedAccount!public!testing! !
model:!accessing!public! !
newAccount!commands!public! !
queryCommand:!commands!private! !
removeAccount!commands!public! !
selectedAccountOrNil!accessing!public! !
selectedAccountOrNil:!accessing!public! !
streamIn:!private!streaming! !
streamOut:!private!streaming! !
updateAccount:!operations!public! !
!

!PersonalMoneyShell class methodsFor!

defaultFileExtension
	"Answer a default extension that will be used for files saved from
	the receiver"

	^'pm'!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^PersonalMoney new
!

fileTypes
	"Answer an Array of file types that can be associated with this
	class of document."

	^#(	('Personal Money files (*.pm)' '*.pm') 
		('All Files (*.*)' '*.*') )!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13238272 65536) 416 nil 327686 ##(Smalltalk.Color) #face3d 328198 ##(Smalltalk.Point) 831 581 133 nil nil nil 416 nil 170 192 34 4 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140920320 1025 560 nil 466 #default nil 5 nil nil nil 560 nil 8 1759000288 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[87 0 0 0 23 0 0 0 136 1 0 0 48 0 0 0] 193 592 nil 560 3 8 #() 498 193 193 nil 27 8 'owner' 410 ##(Smalltalk.ListBox) 34 17 nil 416 34 2 8 1144062209 1025 928 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 624 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #newAccount 8 'New...' 1 1 nil nil nil 1138 1 1170 #editAccount 8 'Edit...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1138 1 1170 #removeAccount 8 'Delete' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 928 nil 8 1758868288 ##(Smalltalk.BasicListAbstract) 8 #() false 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[17 0 0 0 88 0 0 0 136 1 0 0 183 0 0 0] 193 960 8 '' 928 754 #contextMenu: 34 1 1104 928 3 8 #() 498 193 193 nil 27 8 'accounts' 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 461638 4 ##(Smalltalk.MenuBar) nil true 34 2 1090 nil true 34 5 1138 1 1170 #fileOpen 8 '&Open...' 9375 1 nil nil nil 1138 1 1170 #fileSave 8 '&Save' 9383 1 nil nil nil 1138 1 1170 #fileSaveAs 8 'Save &as...' 1 1 nil nil nil 1266 4097 1138 1 1170 #exit 8 'E&xit' 1 1 nil nil nil 8 '&File' nil 1 nil nil 14301 nil nil 1090 nil true 34 5 1138 1 1170 #newAccount 8 '&New...' 9373 1 nil nil nil 1138 1 1170 #editAccount 8 '&Edit Account...' 1 1 nil nil nil 1138 1 1170 #removeAccount 8 '&Delete Account' 1 1 nil nil nil 1266 4097 1138 1 1170 #close 8 'E&xit' 1 1 nil nil nil 8 '&Account' nil 1 nil nil 14311 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 12179 nil nil nil nil 1 nil 193 690 138 144 34 1 754 #createWindow: 34 1 802 1618 498 1 1 498 831 571 193 448 8 'Personal Money Application' 416 1 34 8 560 928 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2432 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 8 'Owner:' nil nil 5 nil nil nil 2432 nil 8 1759212608 658 nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[17 0 0 0 23 0 0 0 82 0 0 0 48 0 0 0] 193 2464 nil 2432 754 #text: 34 1 8 'Owner:' 2432 3 8 #() 498 193 193 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2816 2498 nil nil 2544 8 'Accounts ' nil nil 5 nil nil nil 2816 nil 8 1759212608 658 nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[17 0 0 0 68 0 0 0 117 0 0 0 88 0 0 0] 193 2848 nil 2816 754 #text: 34 1 8 'Accounts ' 2816 3 8 #() 498 193 193 nil 27 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 3152 nil 624 nil 5 nil nil nil 3152 nil 8 1759007584 1170 #newAccount 8 '&New' 1 1 nil nil false nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[17 0 0 0 195 0 0 0 92 0 0 0 220 0 0 0] 193 3184 8 '&New' 3152 754 #isEnabled: 8 #(false) 3152 3 8 #() 498 193 193 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 3472 nil 624 nil 5 nil nil nil 3472 nil 8 1759007584 1170 #editAccount 8 '&Edit' 1 1 nil nil true nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[117 0 0 0 195 0 0 0 192 0 0 0 220 0 0 0] 193 3504 8 '&Edit' 3472 754 #isEnabled: 8 #(false) 3472 3 8 #() 498 193 193 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 3792 nil 624 nil 5 nil nil nil 3792 nil 8 1759007584 1170 #removeAccount 8 '&Delete' 1 1 nil nil false nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[217 0 0 0 195 0 0 0 36 1 0 0 220 0 0 0] 193 3824 8 '&Delete' 3792 754 #isEnabled: 8 #(false) 3792 3 8 #() 498 193 193 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 4112 nil 624 nil 5 nil nil nil 4112 nil 8 1759007584 1170 #exit 8 'E&xit' 1 1 nil nil false nil nil nil 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[61 1 0 0 195 0 0 0 136 1 0 0 220 0 0 0] 193 4144 8 'E&xit' 4112 3 8 #() 498 193 193 nil 29 498 193 193 nil 27 )! !

!PersonalMoneyShell class categoriesForMethods!
defaultFileExtension!constants!public! !
defaultModel!constants!public! !
fileTypes!constants!public! !
resource_Default_view!public!resources-views! !
!

