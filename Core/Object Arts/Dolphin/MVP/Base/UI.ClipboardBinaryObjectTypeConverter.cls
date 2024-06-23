"Filed out from Dolphin Smalltalk"!

UI.TypeConverter
	subclass: #'UI.ClipboardBinaryObjectTypeConverter'
	instanceVariableNames: 'classLocator'
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ClipboardBinaryObjectTypeConverter guid: (Core.GUID fromString: '{62288e60-a337-4d21-b14d-615407c58023}')!

UI.ClipboardBinaryObjectTypeConverter comment: ''!

!UI.ClipboardBinaryObjectTypeConverter methodsFor!

beUnrestricted
	classLocator := ClassLocator new!

classLocator
	"Answer the <ClassLocator> used for resolving classes in the serialized data stream being copied from the clipboard. Usually this will be an instance of <RestrictedClassLocator>, allowing selective enablement/disablement of copy & paste of particular classes of object to/from the clipboard. In a development environment this will be a standard <ClassLocator>, in which case any type of object can be transferred through the clipboard. Note that there are security implications to this since this allows arbitrary code to be transferred and executed."

	^classLocator!

classLocator: aClassLocator
	"Set the <ClassLocator> used for resolving classes in the serialized data stream being copied from the clipboard.
	For security reasons, a restricted class locator should be used that in some way limits the types of objects that can be instantiated. See ValidatingClassLocator and RestrictedClassLocator.
	In order to be secure by default, a RestrictedClassLocator is used that excludes all but a few basic types (see the #initialize method for details). This will mean that very little data in Object format can be pasted from the clipboard unless at least some relevant classes are explicitly included."

	classLocator := aClassLocator!

initialize
	"Private - Initialize the receiver
		self current initialize
	"

	classLocator := RestrictedClassLocator new.
	"Restricted class locators exclude all classes by default except UndefinedObject, SmallInteger, True and False. Everything else must be explicitly added, even basic types like Array, String, Symbol, etc"
	classLocator
		includeClasses: #(#{Kernel.STBClassProxy} #{Core.Utf8String} #{Core.Array} #{Core.OrderedCollection} #{Core.Symbol} #{Core.LargeInteger} #{Core.Float} #{Core.ScaledDecimal} #{Core.Fraction} #{Core.True} #{Core.False} #{Core.SmallInteger} #{Core.UndefinedObject})!

leftToRight: anObject
	"Private - Answers a Windows global memory handle that can be put on the clipboard, and which contains an STB serialised representation of the <Object> argument."

	^External.Memory copyBytesToGlobalHeap: anObject binaryStoreBytes!

register
	Clipboard current
		addRegisteredFormat: #Object
			id: (User32 registerClipboardFormat: 'Smalltalk Object Format')
			converter: self;
		addRegisteredFormat: #ObjectClass
			id: (User32 registerClipboardFormat: 'Smalltalk Object Class Format')
			converter: self!

rightToLeft: aHandle
	"Private - Answers an <Object> reconstituted from the STB serialised data in the specified global memory block, e.g. from the Clipboard."

	^(STBValidatingInFiler on: (ByteArray fromGlobalHandle: aHandle) readStream
		classLocator: classLocator) next! !

!UI.ClipboardBinaryObjectTypeConverter categoriesForMethods!
beUnrestricted!modes!public! !
classLocator!accessing!public! !
classLocator:!accessing!public! !
initialize!initializing!private! !
leftToRight:!operations!private! !
register!initializing!private! !
rightToLeft:!operations!private! !
!

!UI.ClipboardBinaryObjectTypeConverter class methodsFor!

current
	^Current ifNil: [Current := self new]!

onPreStripImage
	"Private -  Assist in the image stripping process by clearing down any
	lazily initialized variables held by the receiver."

	Current := nil!

onStartup
	self current register! !

!UI.ClipboardBinaryObjectTypeConverter class categoriesForMethods!
current!public! !
onPreStripImage!class hierarchy-removing!private! !
onStartup!public! !
!

