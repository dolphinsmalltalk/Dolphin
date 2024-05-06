"Filed out from Dolphin Smalltalk"!

AbstractRecentMenu subclass: #RegistryRecentMenu
	instanceVariableNames: 'productRegistryKey recentRegistryKey'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!RegistryRecentMenu categoriesForMethods!
getRecentList!helpers!private! !
initialize!initializing!private! !
productRegistryAt:!accessing!private!product! !
productRegistryAt:put:!accessing!private!product! !
productRegistryKey!accessing!public! !
recentRegistryKey!accessing!public! !
recentRegistryKey:!accessing!public! !
setProductRegistryKey:!initializing!private! !
setRecentList:!helpers!private! !
!

!RegistryRecentMenu class methodsFor!

withProductKey: aKeyString 
	^(super new)
		setProductRegistryKey: aKeyString;
		yourself! !

!RegistryRecentMenu class categoriesForMethods!
withProductKey:!instance creation!public! !
!

