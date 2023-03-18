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
!UI.Examples.PersonalMoneyShell categoriesForMethods!
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13238272 65536) 416 nil 917510 #{Graphics.Color} #face3d 918022 #{Graphics.Point} 831 581 167 nil nil nil 416 nil 170 192 34 4 410 #{UI.ListBox} 34 17 nil 416 34 2 8 1144062209 1025 560 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 466 #default nil 7 461638 4 #{UI.Menu} nil true 34 4 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #newAccount 8 'New…' 1 1 nil nil nil 786 1 818 #editAccount 8 'Edit…' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 786 1 818 #removeAccount 8 'Delete' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 560 nil 8 1814640640 786950 #{Core.Message} #displayString 672 8 #() false 1310982 #{Core.MessageSequence} 34 3 1049350 #{Core.MessageSend} #createAt:extent: 34 2 498 35 177 498 751 191 560 1122 #contextMenu: 34 1 752 560 1122 #horizontalExtent: 8 #(0) 560 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 88 0 0 0 136 1 0 0 183 0 0 0] 8 #() 498 193 193 nil 27 8 'accounts' 410 #{UI.TextEdit} 34 16 nil 416 34 2 8 1140920320 1025 1360 nil 720 nil 7 nil nil nil 1360 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 1 1074 34 1 1122 #createAt:extent: 34 2 498 175 47 498 611 51 1360 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 87 0 0 0 23 0 0 0 136 1 0 0 48 0 0 0] 8 #() 1328 nil 27 8 'owner' 1180166 #{Graphics.Rectangle} 498 1 1 498 1 1 658246 4 #{UI.MenuBar} nil true 34 2 738 nil true 34 5 786 1 818 #fileOpen 8 '&Open…' 9375 1 nil nil nil 786 1 818 #fileSave 8 '&Save' 9383 1 nil nil nil 786 1 818 #fileSaveAs 8 'Save &as…' 1 1 nil nil nil 914 4097 786 1 818 #exit 8 'E&xit' 1 1 nil nil nil 8 '&File' nil 1 nil nil 13261 nil nil 738 nil true 34 5 786 1 818 #newAccount 8 '&New…' 9373 1 nil nil nil 786 1 818 #editAccount 8 '&Edit Account…' 1 1 nil nil nil 786 1 818 #removeAccount 8 '&Delete Account' 1 1 nil nil nil 914 4097 786 1 818 #close 8 'E&xit' 1 1 nil nil nil 8 '&Account' nil 1 nil nil 13271 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 43383 nil nil nil nil 1 nil nil 1074 34 2 1122 #createAt:extent: 34 2 498 12287 21 498 831 571 416 1122 #text: 34 1 8 'Personal Money Application' 416 1266 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 158 25 0 0 39 1 0 0] 34 8 1360 560 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 2464 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} 8 'Owner:' nil nil 7 nil nil nil 2464 nil 8 1815137184 1442 nil nil nil 1074 34 2 1122 #createAt:extent: 34 2 498 35 47 498 131 51 2464 1122 #text: 34 1 8 'Owner:' 2464 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 23 0 0 0 82 0 0 0 48 0 0 0] 8 #() 1328 nil 27 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 2832 2530 nil nil 2576 8 'Accounts ' nil nil 7 nil nil nil 2832 nil 8 1815137184 1442 nil nil nil 1074 34 2 1122 #createAt:extent: 34 2 498 35 137 498 201 41 2832 1122 #text: 34 1 8 'Accounts ' 2832 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 68 0 0 0 117 0 0 0 88 0 0 0] 8 #() 1328 nil 27 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140924416 1 3152 nil 720 nil 7 nil nil nil 3152 nil 8 1815097472 818 #newAccount 8 '&New' 1 1 nil nil false nil nil nil 1074 34 3 1122 #createAt:extent: 34 2 498 35 391 498 151 51 3152 1122 #isEnabled: 8 #(false) 3152 1122 #text: 34 1 8 '&New' 3152 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 195 0 0 0 92 0 0 0 220 0 0 0] 8 #() 1328 nil 29 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140924416 1 3488 nil 720 nil 7 nil nil nil 3488 nil 8 1815097472 818 #editAccount 8 '&Edit' 1 1 nil nil true nil nil nil 1074 34 3 1122 #createAt:extent: 34 2 498 235 391 498 151 51 3488 1122 #isEnabled: 8 #(false) 3488 1122 #text: 34 1 8 '&Edit' 3488 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 117 0 0 0 195 0 0 0 192 0 0 0 220 0 0 0] 8 #() 1328 nil 29 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140924416 1 3824 nil 720 nil 7 nil nil nil 3824 nil 8 1815097472 818 #removeAccount 8 '&Delete' 1 1 nil nil false nil nil nil 1074 34 3 1122 #createAt:extent: 34 2 498 435 391 498 151 51 3824 1122 #isEnabled: 8 #(false) 3824 1122 #text: 34 1 8 '&Delete' 3824 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 217 0 0 0 195 0 0 0 36 1 0 0 220 0 0 0] 8 #() 1328 nil 29 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140924416 1 4160 nil 720 nil 7 nil nil nil 4160 nil 8 1815097472 818 #exit 8 'E&xit' 1 1 nil nil false nil nil nil 1074 34 2 1122 #createAt:extent: 34 2 498 635 391 498 151 51 4160 1122 #text: 34 1 8 'E&xit' 4160 1266 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 1 0 0 195 0 0 0 136 1 0 0 220 0 0 0] 8 #() 1328 nil 29 1328 nil 27)! !
!UI.Examples.PersonalMoneyShell class categoriesForMethods!
defaultFileExtension!constants!public! !
defaultModel!constants!public! !
fileTypes!constants!public! !
resource_Default_view!public!resources-views! !
!

