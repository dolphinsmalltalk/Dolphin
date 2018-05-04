"Filed out from Dolphin Smalltalk 7"!

DocumentShell subclass: #PersonalMoneyShell
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

updateAccount: aPersonalAccount
	"Update aPersonalAccount in the accounts list"

	self model accounts refresh: aPersonalAccount! !
!PersonalMoneyShell categoriesFor: #createComponents!initializing!public! !
!PersonalMoneyShell categoriesFor: #createSchematicWiring!initializing!public! !
!PersonalMoneyShell categoriesFor: #editAccount!commands!public! !
!PersonalMoneyShell categoriesFor: #hasSelectedAccount!public!testing! !
!PersonalMoneyShell categoriesFor: #model:!accessing!public! !
!PersonalMoneyShell categoriesFor: #newAccount!commands!public! !
!PersonalMoneyShell categoriesFor: #queryCommand:!commands!private! !
!PersonalMoneyShell categoriesFor: #removeAccount!commands!public! !
!PersonalMoneyShell categoriesFor: #selectedAccountOrNil!accessing!public! !
!PersonalMoneyShell categoriesFor: #selectedAccountOrNil:!accessing!public! !
!PersonalMoneyShell categoriesFor: #updateAccount:!operations!public! !

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

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ShellView)  98 27 0 0 98 2 26476545 131073 416 0 721158 ##(SystemColor)  31 328198 ##(Point)  831 581 133 0 0 0 416 0 234 256 98 4 410 8 ##(TextEdit)  98 16 0 416 98 2 8 1140920320 1025 576 0 524550 ##(ColorRef)  8 4278190080 0 5 0 0 0 576 0 8 4294906635 852486 ##(NullConverter)  0 0 1 983302 ##(MessageSequence)  202 208 98 3 721670 ##(MessageSend)  8 #createAt:extent: 98 2 514 175 47 514 611 51 576 818 8 #selectionRange: 98 1 525062 ##(Interval)  3 1 3 576 818 8 #isTextModified: 98 1 32 576 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 87 0 0 0 23 0 0 0 136 1 0 0 48 0 0 0] 98 0 514 193 193 0 27 8 'owner' 410 8 ##(ListBox)  98 17 0 416 98 2 8 1144062209 1025 1136 590662 2 ##(ListModel)  202 208 98 0 0 1114638 ##(STBSingletonProxy)  8 ##(SearchPolicy)  8 #identity 658 688 0 5 265030 4 ##(Menu)  0 16 98 4 984134 2 ##(CommandMenuItem)  1 1180998 4 ##(CommandDescription)  8 #newAccount 8 'New...' 1 1 0 0 0 1410 1 1442 8 #editAccount 8 'Edit...' 1 1 0 0 0 983366 1 ##(DividerMenuItem)  4097 1410 1 1442 8 #removeAccount 8 'Delete' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 1136 0 8 4294903705 8 ##(BasicListAbstract)  1264 32 754 202 208 98 3 818 848 98 2 514 35 187 514 751 191 1136 818 8 #contextMenu: 98 1 1376 1136 818 8 #horizontalExtent: 98 1 1 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 93 0 0 0 136 1 0 0 188 0 0 0] 98 0 1104 0 27 8 'accounts' 590342 ##(Rectangle)  514 1 1 514 1 1 461638 4 ##(MenuBar)  0 16 98 2 1362 0 16 98 5 1410 1 1442 8 #fileOpen 8 '&Open...' 9375 1 0 0 0 1410 1 1442 8 #fileSave 8 '&Save' 9383 1 0 0 0 1410 1 1442 8 #fileSaveAs 8 'Save &as...' 1 1 0 0 0 1570 4097 1410 1 1442 8 #exit 8 'E&xit' 1 1 0 0 0 8 '&File' 0 1 0 0 36173 0 0 1362 0 16 98 5 1410 1 1442 1472 8 '&New...' 9373 1 0 0 0 1410 1 1442 1536 8 '&Edit Account...' 1 1 0 0 0 1410 1 1442 1632 8 '&Delete Account' 1 1 0 0 0 1570 4097 1410 1 1442 8 #close 8 'E&xit' 1 1 0 0 0 8 '&Account' 0 1 0 0 36183 0 0 8 '' 0 1 0 0 0 0 0 0 1049350 ##(AcceleratorTable)  0 16 98 3 721414 ##(Association)  9375 2144 2754 9383 2208 2754 9373 2464 0 13643 0 0 0 0 1 0 0 754 202 208 98 3 818 848 98 2 514 1185 915 514 831 571 416 818 8 #text: 98 1 8 'Personal Money Application' 416 818 8 #menuBar: 98 1 2064 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 2 0 0 201 1 0 0 239 3 0 0 230 2 0 0] 98 8 576 1136 410 8 ##(StaticText)  98 16 0 416 98 2 8 1140850944 1 3088 721990 2 ##(ValueHolder)  0 0 1290 1312 8 #never 8 'Owner:' 0 0 5 0 0 0 3088 0 8 4294906439 722 0 0 0 754 202 208 98 2 818 848 98 2 514 35 47 514 131 51 3088 818 2944 98 1 8 'Owner:' 3088 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 23 0 0 0 82 0 0 0 48 0 0 0] 98 0 1104 0 27 410 3104 98 16 0 416 98 2 8 1140850944 1 3488 3170 0 0 3200 8 'Accounts ' 0 0 5 0 0 0 3488 0 8 4294906439 722 0 0 0 754 202 208 98 2 818 848 98 2 514 35 147 514 201 41 3488 818 2944 98 1 8 'Accounts ' 3488 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 73 0 0 0 117 0 0 0 93 0 0 0] 98 0 1104 0 27 410 8 ##(PushButton)  98 17 0 416 98 2 8 1140924416 1 3824 0 658 688 0 5 0 0 0 3824 0 8 4294906781 1442 1472 8 '&New' 1 1 0 0 32 754 202 208 98 2 818 848 98 2 514 35 397 514 151 61 3824 818 2944 98 1 8 '&New' 3824 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 198 0 0 0 92 0 0 0 228 0 0 0] 98 0 1104 0 27 410 3840 98 17 0 416 98 2 8 1140924416 1 4176 0 658 688 0 5 0 0 0 4176 0 8 4294906781 1442 1536 8 '&Edit' 1 1 0 0 16 754 202 208 98 2 818 848 98 2 514 235 397 514 151 61 4176 818 2944 98 1 8 '&Edit' 4176 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 117 0 0 0 198 0 0 0 192 0 0 0 228 0 0 0] 98 0 1104 0 27 410 3840 98 17 0 416 98 2 8 1140924416 1 4512 0 658 688 0 5 0 0 0 4512 0 8 4294906781 1442 1632 8 '&Delete' 1 1 0 0 32 754 202 208 98 2 818 848 98 2 514 435 397 514 151 61 4512 818 2944 98 1 8 '&Delete' 4512 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 217 0 0 0 198 0 0 0 36 1 0 0 228 0 0 0] 98 0 1104 0 27 410 3840 98 17 0 416 98 2 8 1140924416 1 4848 0 658 688 0 5 0 0 0 4848 0 8 4294906781 1442 2368 8 'E&xit' 1 1 0 0 32 754 202 208 98 2 818 848 98 2 514 635 397 514 151 61 4848 818 2944 98 1 8 'E&xit' 4848 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 1 0 0 198 0 0 0 136 1 0 0 228 0 0 0] 98 0 1104 0 27 1104 0 27 )! !
!PersonalMoneyShell class categoriesFor: #defaultFileExtension!constants!public! !
!PersonalMoneyShell class categoriesFor: #defaultModel!constants!public! !
!PersonalMoneyShell class categoriesFor: #fileTypes!constants!public! !
!PersonalMoneyShell class categoriesFor: #resource_Default_view!public!resources-views! !

