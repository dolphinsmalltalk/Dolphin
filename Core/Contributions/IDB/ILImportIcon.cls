"Filed out from Dolphin Smalltalk"!

ILImport subclass: #ILImportIcon
	instanceVariableNames: 'iconDir icons'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ILImportIcon guid: (GUID fromString: '{254d6ad6-c12b-4add-be8b-d2f0dc0682cc}')!

ILImportIcon comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ILImportIcon categoriesForClass!IDB Goodies! !

!ILImportIcon methodsFor!

hotSpotFor: anInteger
	^nil!

images
	| images |
	images := OrderedCollection new.
	icons keysAndValuesDo: 
			[:index :each | 
			| colors image |
			colors := Array writeStream.
			1 to: each height
				do: 
					[:y | 
					1 to: each width
						do: 
							[:x | 
							each useMaskBytes.
							(self colorAtPoint: x @ y in: each) = Color white 
								ifTrue: [colors nextPut: Color dolphinYellow]
								ifFalse: 
									[each useColorBytes.
									colors nextPut: (self colorAtPoint: x @ y in: each)]]].
			image := ILImage extent: each width @ each height colors: colors contents.
			(self hotSpotFor: index) notNil ifTrue: [image hotSpot: (self hotSpotFor: index) + 1].
			images add: image].
	^images!

initializeFrom: aStream
	| iconDirSize |
	aStream
		nextWORD;
		nextWORD.
	iconDirSize := aStream nextWORD * ICONDIRENTRY byteSize + ICONDIR byteSize.
	aStream reset.
	iconDir := (ICONDIR new: iconDirSize) bytes: (aStream next: iconDirSize).
	icons := OrderedCollection new.
	iconDir idEntries do: 
			[:each | 
			icons 
				add: (self getBitmapFrom: (aStream
								position: each dwImageOffset;
								next: each dwBytesInRes))]!

proxyClass
	^ILImportIconProxy! !

!ILImportIcon categoriesForMethods!
hotSpotFor:!accessing!public! !
images!operations!public! !
initializeFrom:!initializing!public! !
proxyClass!constants!public! !
!

!ILImportIcon class methodsFor!

isResponsibleFor: aStream
	^(aStream next: 3) = #[0 0 1]! !

!ILImportIcon class categoriesForMethods!
isResponsibleFor:!public!testing! !
!

