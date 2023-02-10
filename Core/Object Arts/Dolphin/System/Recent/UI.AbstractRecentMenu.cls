"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.AbstractRecentMenu'
	instanceVariableNames: 'openSelector recentMenuName isFullPathAlwaysRequired'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.AbstractRecentMenu guid: (Core.GUID fromString: '{ab893c67-84d1-4718-9d83-44266284c927}')!
UI.AbstractRecentMenu isNonInstantiable: true!
UI.AbstractRecentMenu comment: ''!
!UI.AbstractRecentMenu categoriesForClass!Kernel-Objects! !
!UI.AbstractRecentMenu methodsFor!

addToRecentList: aRecentString
	"Adds aFilenameString to the <orderedCollection> of recently accessed files"

	| recentList |
	recentList := self getRecentList.
	recentList := recentList reject: [:each | (each compareOrdinals: aRecentString ignoringCase: true) == 0].
	recentList addFirst: aRecentString.
	self setRecentList: recentList!

clearRecentList
	self setRecentList: OrderedCollection new!

getRecentList
	"Private - Answers the current <orderedCollection> of recently opened files."

	self subclassResponsibility!

initialize
	super initialize.
	openSelector := #openOn:.
	recentMenuName := #fileOpenRecentMenu.
	isFullPathAlwaysRequired := true!

isFullPathAlwaysRequired
	^isFullPathAlwaysRequired!

isFullPathAlwaysRequired: aBoolean 
	isFullPathAlwaysRequired := aBoolean!

notEmpty
	^self getRecentList notEmpty!

onAboutToDisplayMenu: recentMenu
	"Private - The system is about to display the <Menu>, recentMenu popup, this is our chance
	to fiddle with it and display the recent files list if appropriate."

	| recentList basePath |
	recentMenu name == self recentMenuName ifFalse: [^self].
	recentMenu clear.
	recentList := self getRecentList.
	basePath := File splitPathFrom: recentList first.
	recentList do: 
			[:each |
			| nameToDisplay |
			nameToDisplay := ($, split: each) first.
			nameToDisplay := self isFullPathAlwaysRequired
						ifTrue: [nameToDisplay]
						ifFalse: [(FolderRelativeFileLocator basePath: basePath) relativePathTo: nameToDisplay].
			recentMenu addCommand: (Message selector: self openSelector argument: each)
				description: nameToDisplay].
	recentMenu
		addSeparator;
		addCommand: (MessageSend receiver: self selector: #clearRecentList)
			description: 'Clear Recent List'!

openSelector
	^openSelector!

openSelector: aSymbol 
	openSelector := aSymbol!

recentMenuName
	^recentMenuName!

recentMenuName: aSymbol 
	recentMenuName := aSymbol!

setRecentList: anOrderedCollectionOfFilenameStrings 
	"Private - Save anOrderedCollectionOfFilenameStrings as the list of recently opened files."

	self subclassResponsibility! !
!UI.AbstractRecentMenu categoriesForMethods!
addToRecentList:!public! !
clearRecentList!public! !
getRecentList!helpers!private! !
initialize!initializing!private! !
isFullPathAlwaysRequired!accessing!private! !
isFullPathAlwaysRequired:!accessing!private! !
notEmpty!public! !
onAboutToDisplayMenu:!event handling!private! !
openSelector!accessing!private! !
openSelector:!accessing!private! !
recentMenuName!accessing!private! !
recentMenuName:!accessing!private! !
setRecentList:!helpers!private! !
!

!UI.AbstractRecentMenu class methodsFor!

new
	^super new initialize! !
!UI.AbstractRecentMenu class categoriesForMethods!
new!instance creation!public! !
!

