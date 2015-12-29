"Filed out from Dolphin Smalltalk X6"!

IdeClassBrowserExtensions subclass: #IdeMethodHistoryExtension
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdeMethodHistoryExtension guid: (GUID fromString: '{49CC6C1D-FE2E-4B9E-86CF-7AC07AD2E67E}')!
IdeMethodHistoryExtension comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!IdeMethodHistoryExtension categoriesForClass!IDB Goodies! !
!IdeMethodHistoryExtension class methodsFor!

extendMenuIn: aBrowser 
	| menu |
	menu := (aBrowser view menuBar find: 'Class') find: 'Browse'.
	"menu 
		insertItem: (CommandMenuItem commandDescription: (ClosedCommandDescription 
						command: #browseMethodHistoryForClass
						description: 'Method History'
						queryBlock: 
							[:query | 
							query isEnabled: aBrowser hasClassSelected.
							true]
						receiver: aBrowser))
		after: #browseChangedMethods.
	menu := (aBrowser view menuBar find: 'Method') find: 'Browse'.
	menu addCommandDescription: (ClosedCommandDescription 
				command: #browseMethodHistory
				description: 'Method History'
				queryBlock: 
					[:query | 
					query isEnabled: aBrowser hasMethodSelected.
					true]
				receiver: aBrowser)"!

isExtension
	^true! !
!IdeMethodHistoryExtension class categoriesFor: #extendMenuIn:!operations!public! !
!IdeMethodHistoryExtension class categoriesFor: #isExtension!constants!public! !

