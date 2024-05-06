"Filed out from Dolphin Smalltalk"!

Object subclass: #STBFiler
	instanceVariableNames: 'stream context version'
	classVariableNames: 'MaxPredefinedRef'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

STBFiler guid: (GUID fromString: '{87b4c4c1-026e-11d3-9fd7-00a0cc3e4a32}')!

STBFiler isAbstract: true!

STBFiler addClassConstant: 'MaxPredefinedRef' value: 16r18!

STBFiler comment: ''!

!STBFiler categoriesForClass!System-Binary storage! !

!STBFiler methodsFor!

atEnd
	"Answer true if the receiver is positioned at end of its stream."

	^stream atEnd

!

context
	"Answers the context for objects read by the receiver"

	^context!

context: anObject
	"Sets the context for objects read by the receiver to anObject. This may be,
	for example, the parent window of a window being read."

	context := anObject!

initialize
	version isNil ifTrue: [version := self class version].
	self reset.
	^self!

position: anInteger
	"Position the receiver's stream to anInteger, read/write a header at this
	place and prepare it for a new input or output session."

	stream position: anInteger.
	self reset.!

register: anObject 
	"Register an object has having been seen before in the STB stream. Answer the unique object reference."

	^self subclassResponsibility!

registerPredefinedClasses
	self class fixedClasses do: [:each | self register: each].
	self setRefOffset: MaxPredefinedRef!

registerPredefinedObjects
	self
		register: true;
		register: false;
		register: Smalltalk;
		register: Processor.
	version > 0 ifFalse: [^self].
	self registerPredefinedClasses!

reset
	"Private - Reset the instance. We pre-register objects that must never be recreated - note
	that if the 'fixed' list of pre-registered objects is changed, then the STB version must be
	changed and the old versions handled appropriately."

	self registerPredefinedObjects!

setRefOffset: anInteger
	^self subclassResponsibility!

stream
	"Answer the stream to which the receiver is attached."

	^stream!

stream: aStream
	"Set stream to aStream."

	stream := aStream!

version
	^version!

version: anInteger
	version := anInteger! !

!STBFiler categoriesForMethods!
atEnd!public!testing! !
context!accessing!public! !
context:!accessing!public! !
initialize!initializing!private! !
position:!operations!public! !
register:!helpers!public! !
registerPredefinedClasses!initializing!private! !
registerPredefinedObjects!initializing!private! !
reset!initializing!private! !
setRefOffset:!initializing!private! !
stream!accessing!public! !
stream:!accessing!public! !
version!accessing!public! !
version:!accessing!public! !
!

!STBFiler class methodsFor!

errorInconsistentSTB: anObject 
	"Private - Signal an STBError indicating that the stream being
	read contains inconsistent STB data."

	STBError signal: ('<2s> input stream is inconsistent (object <1p> referenced but not yet defined)' 
				expandMacrosWith: anObject
				with: self signature)!

errorUnrecognisedClass: aClass version: version 
	"Private - Signal an STBError indicating that the STB data contains
	instances of aClass of version that we don't know how to convert."

	STBError 
		signal: self signature , ' contains a version ' , version displayString , ' instance of ' 
				, aClass name , ' and is unable to convert it.'!

fixedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB
	file. These make it possible to binary file the classes STBClassProxy and String. Also these
	clases are almost always needed, so we can save space pre-registering them so that they
	don't need to be written into the filer."

	"Note that pre-registering classes does not inflate the size of the binary file, it just
	pre-allocates a range of indices for fixed uses. Changing the order of these (or deleting
	registrations) will break existing binary files. Lastly a consequence of pre-registering
	these classes is that normal STB versioning will have no effect - the #stbVersion is only
	checked when a class is first read from the file. In order to version these classes it is
	necessary to increment the global STB version number."

	^##({AnsiString.
		Array.
		ByteArray.
		LargeInteger.
		STBClassProxy.
		STBMetaclassProxy.
		Symbol.
		STBCollectionProxy.
		OrderedCollection.
		STBIdentityDictionaryProxy.
		LookupTable.
		IdentityDictionary.
		Utf8String.
		Utf16String})!

on: aStream
	"Answer a new instance attached to the binary stream aStream."

	^self new
		stream: aStream;
		initialize!

signature
	"Private - Answer the signature that identifies the data as
	being in Smalltalk Binary (STB) format."

	^##('!!STB ' asByteArray)
!

version
	"Private - Answer the version number of the format produced by the receiver.
		Version 1 - Preregisters certain commonly occurring classes
		Version 2 - Delegates save/load to class, format changed for certain pre-registered classes.
		Version 3 - Only writes basicSize for objects of variable classes."

	^4
! !

!STBFiler class categoriesForMethods!
errorInconsistentSTB:!exceptions!private! !
errorUnrecognisedClass:version:!exceptions!private! !
fixedClasses!constants!public! !
on:!instance creation!public! !
signature!constants!private! !
version!constants!private! !
!

