"Filed out from Dolphin Smalltalk X6"!

IdeClassBrowserExtensions subclass: #IdeMethodFilerExtension
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdeMethodFilerExtension guid: (GUID fromString: '{77BE96C8-223B-4523-8534-38683AA7D017}')!
IdeMethodFilerExtension comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!IdeMethodFilerExtension categoriesForClass!IDB Goodies! !
!IdeMethodFilerExtension class methodsFor!

extendedClasses
	^(super extendedClasses)
		add: SmalltalkSystem current methodExplorerClass;
		yourself!

extendMenuIn: aBrowser 
	| menu |
	menu := aBrowser view menuBar find: 'Method'.
	menu 
		insertItem: (CommandMenuItem commandDescription: (ClosedCommandDescription 
						command: #fileOutMethod
						description: 'File Out...'
						queryBlock: 
							[:query | 
							query isEnabled: aBrowser hasMethodSelected.
							true]
						receiver: aBrowser))
		after: #methodRefactoringsMenu.
	menu insertItem: DividerMenuItem separator before: #fileOutMethod!

isExtension
	^true! !
!IdeMethodFilerExtension class categoriesFor: #extendedClasses!accessing!public! !
!IdeMethodFilerExtension class categoriesFor: #extendMenuIn:!operations!public! !
!IdeMethodFilerExtension class categoriesFor: #isExtension!constants!public!testing! !

