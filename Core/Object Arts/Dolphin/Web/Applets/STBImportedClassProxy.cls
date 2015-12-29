"Filed out from Dolphin Smalltalk X6"!

STBProxy subclass: #STBImportedClassProxy
	instanceVariableNames: 'name superclass instanceSpec instVarString methodDictionary classPool classInstVarString classInstVarValues classMethodDictionary guid'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBImportedClassProxy guid: (GUID fromString: '{87B4C6EE-026E-11D3-9FD7-00A0CC3E4A32}')!
STBImportedClassProxy comment: 'An STBImportedClassProxy is used to represent a class that is binary filed out onto an STB stream. When a class is exported in this way (as opposed to with a standard STBClassProxy) it takes with it all of its code so that it can later be imported into another Dolphin image.  Imported classes are anonymous; that is, they do not have an entry in the global Smalltalk dictionary. This can be used as a way of transferring behaviour in a binary fashion from one image to another. Typically, this mode of transportation is used by Dolphin Web Start applets.

'!
!STBImportedClassProxy categoriesForClass!System-Binary class loading! !
!STBImportedClassProxy methodsFor!

class: aClass 
	"Private - Initialize the receiver from aClass.
	We copy the methods and the values of any class variables
	and class instance variables."

	| metaClass stdInstSize |
	name := aClass name asString.
	superclass := aClass superclass.
	instanceSpec := aClass instanceSpec.
	instVarString := aClass instanceVariableString.
	guid := aClass guid.
	metaClass := aClass class.
	classInstVarString := metaClass instanceVariableString.
	stdInstSize := self class stdInstSize.
	classInstVarValues := Array new: metaClass instSize - stdInstSize.
	1 to: classInstVarValues size
		do: [:i | classInstVarValues at: i put: (aClass instVarAt: stdInstSize + i)].
	classPool := aClass basicClassPool.
	classMethodDictionary := metaClass methodDictionary.
	methodDictionary := aClass methodDictionary.
	aClass stbModifyExportProxy: self!

classInstVarValues
	"Private - Answer the receiver's classInstVarValues Array."

	^classInstVarValues!

stbFixup: inFiler at: anInteger
	"Answer the object that this one represents."

	self oneWayBecome: self value.

!

value
	"Answer a new private class based on the receiver."

	"We used to send #youself to the superclass to force it to be dereferenced if it was a ClassStub.
	However, since D5.1, #yourself is no longer a true message send so we use #name here."

	| newClass newMetaclass stdInstSize |
	superclass name.

	"First, create a new Class/Metaclass pair."
	newClass := (ClassBuilder new)
				className: name;
				superclass: superclass;
				instanceSpec: instanceSpec;
				instanceVariableString: instVarString;
				createPrivate.
	guid notNil ifTrue: [newClass setGuid: guid].
	newMetaclass := newClass class.

	"If there are any class instance variables mutate them into the new Class instance."
	classInstVarString isEmpty 
		ifFalse: 
			[(ClassBuilder new)
				class: newMetaclass;
				superclass: newMetaclass superclass;
				instanceSpec: newMetaclass instanceSpec;
				instanceVariableString: classInstVarString;
				modifyPrivate].

	"Set the values of any class instance variables."
	stdInstSize := self class stdInstSize.
	stdInstSize + classInstVarValues size == newMetaclass instSize 
		ifFalse: [self error: 'Superclass layout changes have invalidated class ' , name].
	1 to: classInstVarValues size
		do: [:i | newClass instVarAt: stdInstSize + i put: (classInstVarValues at: i)].

	"Set up the classPool to allow ClassVariables to be inspected."
	newClass basicClassPool: classPool.

	"Add the method dictionaries."
	newMetaclass methodDictionary: classMethodDictionary.
	newClass methodDictionary: methodDictionary.
	newMetaclass methodDictionary do: [:cm | cm methodClass: newClass class ].
	^newClass! !
!STBImportedClassProxy categoriesFor: #class:!accessing!private! !
!STBImportedClassProxy categoriesFor: #classInstVarValues!accessing!private! !
!STBImportedClassProxy categoriesFor: #stbFixup:at:!converting!public! !
!STBImportedClassProxy categoriesFor: #value!converting!public! !

!STBImportedClassProxy class methodsFor!

for: aClass 
	#deprecated.
	^self forClass: aClass!

forClass: aClass
	"Answer a new instance of the receiver representing aClass.
	The recreated class will contain code only."

	^self basicNew class: aClass!

stbConvertFrom: anSTBClassFormat 
	"Convert from version 0 proxy - we have to set the resources inst var
	to an empty PoolDictionary."

	anSTBClassFormat version > self stbVersion 
		ifTrue: [^super stbConvertFrom: anSTBClassFormat].
	^
	[:data | 
	| convertedProxy |
	convertedProxy := self basicNew.
	1 to: data size do: [:i | convertedProxy instVarAt: i put: (data at: i)].
	convertedProxy yourself]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1!

stdInstSize
	"Private - Answer the instance size of a 'standard' class object - ie. one without any class instance variables."

	^Class class instSize! !
!STBImportedClassProxy class categoriesFor: #for:!instance creation!public! !
!STBImportedClassProxy class categoriesFor: #forClass:!instance creation!public! !
!STBImportedClassProxy class categoriesFor: #stbConvertFrom:!instance creation!public! !
!STBImportedClassProxy class categoriesFor: #stbVersion!instance creation!public! !
!STBImportedClassProxy class categoriesFor: #stdInstSize!calculations!private! !

