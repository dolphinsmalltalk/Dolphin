"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #StsImportProxy
	instanceVariableNames: 'name developer timestamp comment version'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsImportProxy guid: (GUID fromString: '{8A5988DA-7277-445A-8CDF-0DAF93C945F2}')!
StsImportProxy comment: ''!
!StsImportProxy categoriesForClass!Unclassified! !
!StsImportProxy methodsFor!

comment
	^comment!

comment: aString 
	comment := aString!

developer
	^developer!

developer: aString 
	developer := aString!

isChanged
	^true!

name
	^name!

name: aString 
	name := aString!

possibleBlessingLevels
	"Answer a collection of blessing level symbols ordered from the lowest blessing level to the highest."

	^StsEdition possibleBlessingLevels!

timestamp
	^timestamp!

timestamp: aTimestamp 
	timestamp := aTimestamp!

version
	^version!

version: aString 
	version := aString! !
!StsImportProxy categoriesFor: #comment!public! !
!StsImportProxy categoriesFor: #comment:!public! !
!StsImportProxy categoriesFor: #developer!public! !
!StsImportProxy categoriesFor: #developer:!public! !
!StsImportProxy categoriesFor: #isChanged!public! !
!StsImportProxy categoriesFor: #name!public! !
!StsImportProxy categoriesFor: #name:!public! !
!StsImportProxy categoriesFor: #possibleBlessingLevels!public! !
!StsImportProxy categoriesFor: #timestamp!public! !
!StsImportProxy categoriesFor: #timestamp:!public! !
!StsImportProxy categoriesFor: #version!public! !
!StsImportProxy categoriesFor: #version:!public! !

