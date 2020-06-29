"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Sound
	instanceVariableNames: 'name location type fileLocator'
	classVariableNames: 'Registry'
	poolDictionaries: 'MessageBoxConstants Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
Sound guid: (GUID fromString: '{87b4c4bc-026e-11d3-9fd7-00a0cc3e4a32}')!
Sound comment: 'Sound is the class of objects that represent wave audio resources (.wav files).

Instance Variables:
	name		<String> identifier (e.g. filename or resource identifier)
	location		<ExternalHandle> of the module containing the wave resource, or nil if a .wav file.
	type		<SmallInteger> flags.
	fileLocator	<FileLocator>

Class Variables:
	Registry		<IdentityDictionary>. Registry of standard named sounds.

"test"'!
!Sound categoriesForClass!Multimedia! !
!Sound methodsFor!

fileLocator: aFileLocator	
	"Private - Set the file locator used to locate the receiver's WAV file.
	Answers nil for non-file based sounds."

	fileLocator := aFileLocator!

location: anObject
	"Private - Set the 'location' of the receiver's wave resource"

	location := anObject!

name: id
	"Private - Set the 'name' of the receiver's wave resource"

	name := id!

play: anInteger
	"Private - Play the receiver with the specified flags. Answer whether it succeeded."

	| soundName |
	soundName := fileLocator ifNotNil: [fileLocator localFileSpecFor: name] ifNil: [name].
	^WinMMLibrary default
		playSound: soundName asResourceId
		hmod: location asParameter
		fdwSound: anInteger!

type
	"Answer the type of the receiver (flags specifying whether it is asynchronous, etc)"

	^type!

type: anInteger 
	"Private - Set the 'type' of the receiver's wave resource"

	type := anInteger!

woof
	"Play the receiver, but do not wait for the woof to finish. Subsequent woofs may terminate this one."

	self play: type!

woofAndWait
	"Play the receiver, waiting for the woof to finish"

	| flags |
	flags := (type bitAnd: ##(SND_ASYNC bitInvert)) bitOr: SND_SYNC.
	self play: flags! !
!Sound categoriesFor: #fileLocator:!accessing!private! !
!Sound categoriesFor: #location:!accessing!private! !
!Sound categoriesFor: #name:!accessing!private! !
!Sound categoriesFor: #play:!private!woofing! !
!Sound categoriesFor: #type!accessing!public! !
!Sound categoriesFor: #type:!initializing!private! !
!Sound categoriesFor: #woof!public!woofing! !
!Sound categoriesFor: #woofAndWait!public!woofing! !

!Sound class methodsFor!

beep
	"Generate the standard system parp."

	self beep: 0!

beep: anInteger
	"Generate a parp of the specified type (see Win32 documentation) from the system speaker."

	UserLibrary default messageBeep: anInteger!

beep: freqInteger duration: durationInteger
	"Generate a parp of the specified frequency and duration from the system speaker."

	KernelLibrary default beep: freqInteger dwDuration: durationInteger!

bell
	"Generate a very short parp using the computer speaker - useful for debugging.
	Implementation Note: Annoyingly MessageBeep(-1) does not have the desired effect on
	NT4.0 because it doesn't actually use the speaker if a Sound card is present."

	self beep: 750 duration: 15!

clearRegistry
	"Create the standard sound registry"

	Registry := IdentityDictionary new.
!

defaultBeep
	"Generate the default system beep."

	self beep: 0!

errorBeep
	"Generate the standard system error parp."

	self beep: MB_ICONERROR!

for: aSymbol ifAbsent: aBlock
	"Answers a standard sound from our own registry"

	^Registry at: aSymbol ifAbsent: aBlock.!

for: aSymbol put: aSound
	"Sets a standard sound into our own registry"

	^Registry at: aSymbol put: aSound.!

fromAlias: aString
	"Answer a new instance of the receiver from the alias aString (stored in the windows registry 
	and configurable from the control panel)"

	^self new
		name: aString;
		type: SND_ALIAS | SND_ASYNC;
		yourself!

fromFile: aString
	"Answer a new instance of the receiver from the wave file named aString."

	^self fromFile: aString usingLocator: FileLocator default!

fromFile: aString usingLocator: aFileLocator
	"Answer a new instance of the receiver from the wave file named aString
	using aFileLocator."

	^self new
		name: (aFileLocator relativePathTo: aString);
		fileLocator: aFileLocator;
		type: SND_FILENAME | SND_ASYNC;
		yourself!

fromId: anIntegerOrStringId in: anExternalHandle
	"Answer a new instance of the receiver from the resource identified by
	aResourceId in the external module identified by anExternalHandle"

	^self new
		name: anIntegerOrStringId;
		location: anExternalHandle;
		type: SND_RESOURCE | SND_ASYNC;
		yourself!

informationBeep
	"Generate the standard system information parp."

	self beep: MB_ICONINFORMATION!

initialize
	"Private - Initialize the receiver"

	self clearRegistry!

promptBeep
	"Generate the standard system prompt (question) parp."

	self beep: MB_ICONQUESTION!

warningBeep
	"Generate the standard system warning parp."

	self beep: MB_ICONWARNING!

woofAndWaitFor: aSymbol
	"Woofs standard sound from our own registry"

	self woofAndWaitFor: aSymbol ifAbsent: []!

woofAndWaitFor: aSymbol ifAbsent: exceptionBlock
	"Woofs standard sound from our own registry"

	| sound |
	sound := Registry lookup: aSymbol.
	sound notNil ifTrue: [sound woofAndWait] ifFalse: [exceptionBlock value]!

woofFor: aSymbol
	"Woofs standard sound from our own registry"

	self woofFor: aSymbol ifAbsent: []!

woofFor: aSymbol ifAbsent: exceptionBlock
	"Woofs standard sound from our own registry"

	| sound |
	sound := Registry lookup: aSymbol.
	sound notNil ifTrue: [sound woof] ifFalse: [exceptionBlock value]! !
!Sound class categoriesFor: #beep!parping!public! !
!Sound class categoriesFor: #beep:!not an aspect!parping!public! !
!Sound class categoriesFor: #beep:duration:!parping!public! !
!Sound class categoriesFor: #bell!parping!public! !
!Sound class categoriesFor: #clearRegistry!development!initializing!public! !
!Sound class categoriesFor: #defaultBeep!parping!public! !
!Sound class categoriesFor: #errorBeep!parping!public! !
!Sound class categoriesFor: #for:ifAbsent:!accessing!public! !
!Sound class categoriesFor: #for:put:!accessing!public! !
!Sound class categoriesFor: #fromAlias:!instance creation!public! !
!Sound class categoriesFor: #fromFile:!instance creation!public! !
!Sound class categoriesFor: #fromFile:usingLocator:!instance creation!public! !
!Sound class categoriesFor: #fromId:in:!instance creation!public! !
!Sound class categoriesFor: #informationBeep!parping!public! !
!Sound class categoriesFor: #initialize!development!initializing!private! !
!Sound class categoriesFor: #promptBeep!parping!public! !
!Sound class categoriesFor: #warningBeep!parping!public! !
!Sound class categoriesFor: #woofAndWaitFor:!public!woofing! !
!Sound class categoriesFor: #woofAndWaitFor:ifAbsent:!public!woofing! !
!Sound class categoriesFor: #woofFor:!public!woofing! !
!Sound class categoriesFor: #woofFor:ifAbsent:!public!woofing! !

