"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #ELVDemoPerson
	instanceVariableNames: 'name dateOfBirth gender isMarried address'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ELVDemoPerson guid: (GUID fromString: '{C8BC1041-CE4F-4B05-B5B2-6C5A35472382}')!
ELVDemoPerson comment: ''!
!ELVDemoPerson categoriesForClass!Unclassified! !
!ELVDemoPerson methodsFor!

address
	^address!

address: anObject
	address := anObject!

dateOfBirth
	^dateOfBirth!

dateOfBirth: anObject
	dateOfBirth := anObject!

gender
	^gender!

gender: anObject
	gender := anObject!

isMarried
	^isMarried!

isMarried: anObject
	isMarried := anObject!

name
	^name!

name: anObject
	name := anObject! !
!ELVDemoPerson categoriesFor: #address!accessing!private! !
!ELVDemoPerson categoriesFor: #address:!accessing!private! !
!ELVDemoPerson categoriesFor: #dateOfBirth!accessing!private! !
!ELVDemoPerson categoriesFor: #dateOfBirth:!accessing!private! !
!ELVDemoPerson categoriesFor: #gender!accessing!private! !
!ELVDemoPerson categoriesFor: #gender:!accessing!private! !
!ELVDemoPerson categoriesFor: #isMarried!accessing!private! !
!ELVDemoPerson categoriesFor: #isMarried:!accessing!private! !
!ELVDemoPerson categoriesFor: #name!accessing!private! !
!ELVDemoPerson categoriesFor: #name:!accessing!private! !

!ELVDemoPerson class methodsFor!

new

	^super new
		isMarried: false;
		gender: '<not known>';
		yourself! !
!ELVDemoPerson class categoriesFor: #new!public! !

