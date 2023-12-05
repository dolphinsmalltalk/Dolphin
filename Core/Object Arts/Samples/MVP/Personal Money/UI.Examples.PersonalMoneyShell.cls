"Filed out from Dolphin Smalltalk"!

UI.AbstractDocumentShell
	subclass: #'UI.Examples.PersonalMoneyShell'
	instanceVariableNames: 'ownerPresenter accountsPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.PersonalMoneyShell guid: (Core.GUID fromString: '{87b4c6b9-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.Examples.PersonalMoneyShell comment: 'PersonalMoneyShell is a <documentPresenter> providing the main user interface for the Personal Money sample system. The interface is displayed in a top level shell window. The model data on which the PersonalMoneyShell operates is an instance of <PersonalMoney>. Since the class conforms to <documentPresenter> it automatically has the ability to save and load the PersonalMoney data to/from disk.

To create a new Personal Money system evaluate:

PersonalMoneyShell show.

Instance Variables:
	ownerPresenter	<TextPresenter> holding the owners name.
	accountsPresenter	<ListPresenter> holding a list of <PersonalAccount>s.

'!
!UI.Examples.PersonalMoneyShell categoriesForClass!MVP-Presenters!Samples! !
!UI.Examples.PersonalMoneyShell methodsFor!

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

	<commandQuery: #hasSelectedAccount>
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
	self editAccount!

removeAccount
	"Removes the current account from the receiver's model"

	<commandQuery: #hasSelectedAccount>
	self model removeAccount: self selectedAccountOrNil!

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
!UI.Examples.PersonalMoneyShell categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
editAccount!commands!public! !
hasSelectedAccount!public!testing! !
model:!accessing!public! !
newAccount!commands!public! !
removeAccount!commands!public! !
selectedAccountOrNil!accessing!public! !
selectedAccountOrNil:!accessing!public! !
streamIn:!private!streaming! !
streamOut:!private!streaming! !
updateAccount:!operations!public! !
!

!UI.Examples.PersonalMoneyShell class methodsFor!

defaultFileExtension
	"Answer a default extension that will be used for files saved from
	the receiver"

	^'pm'!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^PersonalMoney new!

fileTypes
	"Answer an Array of file types that can be associated with this
	class of document."

	^#(	('Personal Money files (*.pm)' '*.pm') 
		('All Files (*.*)' '*.*') )!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13238272 65536) 32 nil 6 #{Graphics.Color} #face3d 518 #{Graphics.Point} 831 581 133 nil nil nil 32 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 18 #{UI.ListBox} 50 17 nil 32 50 2 8 1144062209 1025 208 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 98 #default nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #newAccount 8 'New…' 1 1 nil nil nil 434 1 466 #editAccount 8 'Edit…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 434 1 466 #removeAccount 8 'Delete' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 208 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() false 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 130 35 177 130 751 191 208 770 #horizontalExtent: 8 #(0) 208 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 88 0 0 0 136 1 0 0 183 0 0 0] 8 #() 130 193 193 nil 27 8 'accounts' 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140920320 1025 976 nil 368 nil 5 nil nil nil 976 nil nil 518 #{UI.NullConverter} nil nil 1 #focusLost nil nil nil 722 50 1 770 #createAt:extent: 50 2 130 175 47 130 611 51 976 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 87 0 0 0 23 0 0 0 136 1 0 0 48 0 0 0] 8 #() 944 nil 45 8 'owner' 518 #{Graphics.Rectangle} 130 1 1 130 1 1 2886 4 #{UI.MenuBar} nil true 50 2 386 nil true 50 5 434 1 466 #fileOpen 8 '&Open…' 9375 1 nil nil nil 434 1 466 #fileSave 8 '&Save' 9383 1 nil nil nil 434 1 466 #fileSaveAs 8 'Save &as…' 1 1 nil nil nil 562 4097 434 1 466 #exit 8 'E&xit' 1 1 nil nil nil 8 '&File' nil 1 nil nil nil nil nil 386 nil true 50 5 434 1 466 #newAccount 8 '&New…' 9373 1 nil nil nil 434 1 466 #editAccount 8 '&Edit Account…' 1 1 nil nil nil 434 1 466 #removeAccount 8 '&Delete Account' 1 1 nil nil nil 562 4097 434 1 466 #close 8 'E&xit' 1 1 nil nil nil 8 '&Account' nil 1 nil nil nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 722 50 2 770 #createAt:extent: 50 2 130 6143 21 130 831 571 32 770 #text: 50 1 8 'Personal Money Application' 32 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 158 13 0 0 39 1 0 0] 50 8 976 208 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2064 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 8 'Owner:' nil nil 5 nil nil nil 2064 nil nil 1042 nil nil nil 722 50 2 770 #createAt:extent: 50 2 130 35 47 130 131 51 2064 770 #text: 50 1 8 'Owner:' 2064 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 23 0 0 0 82 0 0 0 48 0 0 0] 8 #() 944 nil 27 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2416 2130 nil nil 2176 8 'Accounts ' nil nil 5 nil nil nil 2416 nil nil 1042 nil nil nil 722 50 2 770 #createAt:extent: 50 2 130 35 137 130 201 41 2416 770 #text: 50 1 8 'Accounts ' 2416 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 68 0 0 0 117 0 0 0 88 0 0 0] 8 #() 944 nil 27 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 2720 nil 368 nil 5 nil nil nil 2720 nil nil 466 #newAccount 8 '&New' 1 1 nil nil false nil nil nil 722 50 3 770 #createAt:extent: 50 2 130 35 391 130 151 51 2720 770 #isEnabled: 8 #(false) 2720 770 #text: 50 1 8 '&New' 2720 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 195 0 0 0 92 0 0 0 220 0 0 0] 8 #() 944 nil 29 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 3040 nil 368 nil 5 nil nil nil 3040 nil nil 466 #editAccount 8 '&Edit' 1 1 nil nil true nil nil nil 722 50 3 770 #createAt:extent: 50 2 130 235 391 130 151 51 3040 770 #isEnabled: 8 #(false) 3040 770 #text: 50 1 8 '&Edit' 3040 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 117 0 0 0 195 0 0 0 192 0 0 0 220 0 0 0] 8 #() 944 nil 29 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 3360 nil 368 nil 5 nil nil nil 3360 nil nil 466 #removeAccount 8 '&Delete' 1 1 nil nil false nil nil nil 722 50 3 770 #createAt:extent: 50 2 130 435 391 130 151 51 3360 770 #isEnabled: 8 #(false) 3360 770 #text: 50 1 8 '&Delete' 3360 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 217 0 0 0 195 0 0 0 36 1 0 0 220 0 0 0] 8 #() 944 nil 29 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 3680 nil 368 nil 5 nil nil nil 3680 nil nil 466 #exit 8 'E&xit' 1 1 nil nil false nil nil nil 722 50 2 770 #createAt:extent: 50 2 130 635 391 130 151 51 3680 770 #text: 50 1 8 'E&xit' 3680 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 1 0 0 195 0 0 0 136 1 0 0 220 0 0 0] 8 #() 944 nil 29 944 nil 27)! !
!UI.Examples.PersonalMoneyShell class categoriesForMethods!
defaultFileExtension!constants!public! !
defaultModel!constants!public! !
fileTypes!constants!public! !
resource_Default_view!public!resources-views! !
!

