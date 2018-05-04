"Filed out from Dolphin Smalltalk 7"!

Color subclass: #SystemColor
	instanceVariableNames: 'id'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SystemColor guid: (GUID fromString: '{87b4c53c-026e-11d3-9fd7-00a0cc3e4a32}')!
SystemColor comment: 'SystemColor instances represent the logical colours defined by the current Windows colour scheme, for example the colour of dialog backgrounds, window captions, etc.'!
!SystemColor categoriesForClass!Drawing! !
!SystemColor methodsFor!

= aSystemColor
	"Answer true if aSystemColor is equal to (has the same id as) the receiver."

	^self species == aSystemColor species and: [self id == aSystemColor id]!

asIndexedColor
	"Answer the receiver as an IndexedColour."

	^IndexedColor fromInteger: self asParameter!

asParameter
	"Answer the receiver in a form suitable for an API call."

	^UserLibrary default getSysColor: self id!

asRGB
	"Answer the receiver as an RGB"

	^RGB fromInteger: self asParameter!

brushClass
	"Private - Answer the class of Brush to be used in conjunction with the receiver."

	^SysColorBrush!

hash
	"Answer the SmallInteger hash value for the receiver."

	^self id hash!

id
	"Private - Answer the system id of the receiver"

	^id!

idName
	"Private - Answer the Win32Constants name of the receiver"

	^((Win32Constants select: [:each | each=self id ]) keys asArray
		select: [:key | 'COLOR_*' match: key asString ]) 
			at: 1 ifAbsent: [self id displayString ].!

printOn: aStream
	"Put an ASCII representation of receiver onto aStream."

	aStream
		nextPut: $(;
		display: self class;
		display: ' fromId: ';
		display: self idName;
		nextPut: $)!

setId: anInteger
	"Private - Set the system id of the receiver"

	id := anInteger! !
!SystemColor categoriesFor: #=!comparing!public! !
!SystemColor categoriesFor: #asIndexedColor!converting!public! !
!SystemColor categoriesFor: #asParameter!converting!public! !
!SystemColor categoriesFor: #asRGB!converting!public! !
!SystemColor categoriesFor: #brushClass!constants!private! !
!SystemColor categoriesFor: #hash!comparing!public! !
!SystemColor categoriesFor: #id!accessing!private! !
!SystemColor categoriesFor: #idName!accessing!development!private! !
!SystemColor categoriesFor: #printOn:!development!printing!public! !
!SystemColor categoriesFor: #setId:!accessing!private! !

!SystemColor class methodsFor!

fromId: anInteger
	"Answers an instance of the receiver from anInteger system id"

	^self basicNew
		setId: anInteger! !
!SystemColor class categoriesFor: #fromId:!instance creation!public! !

