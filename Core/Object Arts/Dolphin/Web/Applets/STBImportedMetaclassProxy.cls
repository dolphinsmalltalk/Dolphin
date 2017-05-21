"Filed out from Dolphin Smalltalk 7"!

STBProxy subclass: #STBImportedMetaclassProxy
	instanceVariableNames: 'instanceClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBImportedMetaclassProxy guid: (GUID fromString: '{87b4c6ef-026e-11d3-9fd7-00a0cc3e4a32}')!
STBImportedMetaclassProxy comment: 'An STBImportedMetaclassProxy is used to represent a metaclass that is binary filed out onto an STB stream. When a metaclass is exported in this way (as opposed to with a standard STBMetaclassProxy) it takes with it all of its code so that it can later be imported into another Dolphin image. This can be used as a way of transferring behaviour in a binary fashion from one image to another. Typically, this mode of transportation is used by Dolphin Web Start applets.'!
!STBImportedMetaclassProxy categoriesForClass!System-Binary class loading! !
!STBImportedMetaclassProxy methodsFor!

instanceClass: aClass 
	"Private - Initialize the receiver from aClass."

	instanceClass := aClass!

stbFixup: inFiler at: anInteger
	"Answer the object that this one represents."

	self oneWayBecome: self value.!

value
	"Answer a the receiver's instanceClass inst var's class."

	^instanceClass class! !
!STBImportedMetaclassProxy categoriesFor: #instanceClass:!accessing!private! !
!STBImportedMetaclassProxy categoriesFor: #stbFixup:at:!converting!public! !
!STBImportedMetaclassProxy categoriesFor: #value!converting!public! !

!STBImportedMetaclassProxy class methodsFor!

for: aMetaclass 
	#deprecated.
	^self forClass: aMetaclass!

forClass: aMetaclass
	"Answer a new instance of the receiver representing aMetaclass."

	^self basicNew
		instanceClass: aMetaclass class;
		yourself! !
!STBImportedMetaclassProxy class categoriesFor: #for:!instance creation!public! !
!STBImportedMetaclassProxy class categoriesFor: #forClass:!instance creation!public! !

