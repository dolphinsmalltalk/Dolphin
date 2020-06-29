"Filed out from Dolphin Smalltalk 7"!

AbstractRecentMenu subclass: #RegistryRecentMenu
	instanceVariableNames: 'productRegistryKey recentRegistryKey'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RegistryRecentMenu guid: (GUID fromString: '{24a5959d-a131-48d9-a17d-b8038aea48b2}')!
RegistryRecentMenu comment: ''!
!RegistryRecentMenu categoriesForClass!Kernel-Objects! !
!RegistryRecentMenu methodsFor!

getRecentList
	"Private - Answers the current <orderedCollection> of recently opened files."

	| recentList |
	recentList := self productRegistryAt: self recentRegistryKey.
	(recentList isNil or: [recentList isEmpty]) ifTrue: [^OrderedCollection new].
	^recentList lines asOrderedCollection!

initialize
	super initialize.
	recentRegistryKey := 'Recent Files'!

productRegistryAt: key 
	^(RegKey userRoot at: self productRegistryKey ifAbsent: [^nil]) valueAt: key
		ifAbsent: [^nil]!

productRegistryAt: key put: value
	| regKey |
	regKey := RegKey userRoot createKey: self productRegistryKey.
	regKey valueAt: key put: value
!

productRegistryKey
	"Answers the <readableString> registry key of the product to which the list belongs"
	
	^productRegistryKey
!

recentRegistryKey
	^recentRegistryKey!

recentRegistryKey: aString 
	recentRegistryKey := aString!

setProductRegistryKey: aString 
	productRegistryKey := aString!

setRecentList: anOrderedCollectionOfFilenameStrings 
	"Private - Save anOrderedCollectionOfFilenameStrings as the list of recently opened files."

	| stream |
	stream := String writeStream.
	anOrderedCollectionOfFilenameStrings do: 
			[:each | 
			stream
				nextPutAll: each;
				cr].
	self productRegistryAt: self recentRegistryKey put: stream contents! !
!RegistryRecentMenu categoriesFor: #getRecentList!helpers!private! !
!RegistryRecentMenu categoriesFor: #initialize!initializing!private! !
!RegistryRecentMenu categoriesFor: #productRegistryAt:!accessing!private!product! !
!RegistryRecentMenu categoriesFor: #productRegistryAt:put:!accessing!private!product! !
!RegistryRecentMenu categoriesFor: #productRegistryKey!accessing!public! !
!RegistryRecentMenu categoriesFor: #recentRegistryKey!accessing!public! !
!RegistryRecentMenu categoriesFor: #recentRegistryKey:!accessing!public! !
!RegistryRecentMenu categoriesFor: #setProductRegistryKey:!initializing!private! !
!RegistryRecentMenu categoriesFor: #setRecentList:!helpers!private! !

!RegistryRecentMenu class methodsFor!

withProductKey: aKeyString 
	^(super new)
		setProductRegistryKey: aKeyString;
		yourself! !
!RegistryRecentMenu class categoriesFor: #withProductKey:!instance creation!public! !

