"Filed out from Dolphin Smalltalk"!

Object subclass: #ResourceAccessor
	instanceVariableNames: 'flags'
	classVariableNames: 'ChangedMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ResourceAccessor guid: (GUID fromString: '{87b4c4b0-026e-11d3-9fd7-00a0cc3e4a32}')!

ResourceAccessor comment: ''!

!ResourceAccessor categoriesForClass!MVP-Resources! !

!ResourceAccessor methodsFor!

asInternalAccessor
	"Private - Answer the receiver or a new resource accessor whose resources data is
	held entirely within the image."

	^self!

canSave
	"Answer whether the receiver is capable of saving a resource."

	^true!

hiddenObjects
	"Private - Answers a <Set> of all the <Object>s that are referenced by or contained in the 
	receiver's resource but that cannot be guaranteed to be present in the image at the current time."

	^Set new!

initialize
	"Private - Initialize the receiver."

	flags := 0!

isChanged
	"Answer whether the receiver has been modified since its Changed flag was last reset."

	^flags anyMask: ChangedMask!

isChanged: aBoolean
	"Private - Set the receiver's Changed flag to aBoolean."

	flags := flags mask: ChangedMask set: aBoolean!

isInternalAccessor
	"Answer true if the receiver denotes a resource that is held internal to the image"

	^true!

loadWithContext: anObject forEdit: isLoadingForEdit 
	"Answer an instance of the resource held represented by the receiver.
	The new instance requires a context in which to live, this is provided by context."

	^self subclassResponsibility!

makeByteArrayClass: aResourceClass usingContext: context 
	"Private - Mutate the receiver to a ResourceSTBByteArrayAccessor using the context to load
	the resource (if required), and the resources class aResourceClass to resave it."

	| byteArrayAccessor |
	byteArrayAccessor := ResourceSTBByteArrayAccessor new.
	byteArrayAccessor save: (self loadWithContext: context forEdit: false) as: aResourceClass.
	self become: byteArrayAccessor!

makeFile: aString class: aResourceClass usingContext: context 
	"Private - Mutate the receiver to a ResourceSTBFileAccessor using the context to load
	the resource (if required), and the resources class aResourceClass to resave it into
	an STB file named aString."

	| fileAccessor |
	fileAccessor := ResourceSTBFileAccessor onFileName: aString.
	fileAccessor save: (self loadWithContext: context forEdit: false) as: aResourceClass.
	self become: fileAccessor!

save: anObject as: aResourceClass
	"Save out anObject in the format dictated by aResourceClass."

	^self subclassResponsibility! !

!ResourceAccessor categoriesForMethods!
asInternalAccessor!converting!private! !
canSave!public!testing! !
hiddenObjects!image stripping!private! !
initialize!operations!private! !
isChanged!public!testing! !
isChanged:!accessing!private! !
isInternalAccessor!public!testing! !
loadWithContext:forEdit:!operations!public! !
makeByteArrayClass:usingContext:!converting!private! !
makeFile:class:usingContext:!converting!private! !
save:as:!operations!public! !
!

!ResourceAccessor class methodsFor!

ensureAccessorsAreInternal
	"Private - Convert all the accessor instances so that the resource data is held within
	the image rather than as separate files, etc."

	ResourceAccessor allSubinstances do: [:aResourceAccessor |
		aResourceAccessor become: aResourceAccessor asInternalAccessor]!

icon
	"Answers an Icon that can be used to represent this class"

	^Resource icon!

initialize
	"Private - Initialize the receiver."

	ChangedMask := 16r01.!

new
	"Answer a new initialized instance of the receiver."

	^super new
		initialize;
		yourself!

stbConvertFrom: anSTBClassFormat 
	"Answer a block to convert the given data array to the current version."

	anSTBClassFormat version > self stbVersion 
		ifTrue: [^super stbConvertFrom: anSTBClassFormat].
	^
	[:data | 
	| newInstance array |
	array := data.
	anSTBClassFormat version to: self stbVersion - 1
		do: 
			[:version | 
			| selector |
			selector := ('stbConvertFromVersion' , version displayString , ':') asSymbol.
			array := self perform: selector with: array].
	newInstance := self basicNew.
	1 to: self instSize do: [:i | newInstance instVarAt: i put: (array at: i)].
	newInstance]!

stbConvertFromVersion0: version0Array
	"Private - Convert from version 0 to version 1.

	instVarAt:	Version 1		Version 0
	----------	---------		---------
		1		flags		whatever...
		2		whatever..."

	^(WriteStream on: Array new)
		nextPut: 0;
		nextPutAll: version0Array;
		contents
! !

!ResourceAccessor class categoriesForMethods!
ensureAccessorsAreInternal!operations!private! !
icon!constants!development!public! !
initialize!development!initializing!private! !
new!instance creation!public! !
stbConvertFrom:!binary filing!public! !
stbConvertFromVersion0:!binary filing!private! !
!

