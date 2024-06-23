"Filed out from Dolphin Smalltalk"!

Graphics.GraphicsTool
	subclass: #'Graphics.Gdiplus.GdiplusBase'
	instanceVariableNames: 'initializer'
	classVariableNames: ''
	imports: #(#{Graphics.Gdiplus.GdiplusGUIDs})
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.GdiplusBase guid: (Core.GUID fromString: '{9368410d-787c-4331-994e-9bc2c3f0fe46}')!

Graphics.Gdiplus.GdiplusBase isNonInstantiable: true!

Graphics.Gdiplus.GdiplusBase comment: 'GdiplusBase is an abstract class that represents the Win32 GDI+ GdiplusBase class.  Instances of this class contain a reference to an initializer which creates the Win32 object - see #createHandle.  In most cases, the initializer can also recreate the instance, though not all can (see #isPersistent), and recreation of an instance does not guarantee the instance will be at the same state as when it was freed.

Since instances of this hierarchy have no (or few) instance variables, most state information is accessed directly through calls to Win32 GDI+ functions.  In some cases, calls are made to the initializer which, as mentioned, does reference instance variables.

Win32 constants, enumerations, and GUIDs are contained in the pool dictionaries GdiplusConstants and GdiplusGUIDs.  GdiplusBase class has helper methods that answer the subsets of constants for a particular Win32 type of constant (e.g., #enumsStringFormatFlags and #guidsEncoder).'!

!Graphics.Gdiplus.GdiplusBase methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	"SW - What does it mean for Gdiplus objects to be equal? 
	  -This tests whether the objects are constructed equal, however that can change during the lifetime of the objects.
		-Do we need a #equalityDirty flag?"

	self == anObject ifTrue: [^true].
	^self class == anObject class and: [self initializer = anObject initializer]!

basicFree
	"Private - Free up external resources held by the receiver.  Ignore any errors which might arise."

	self initializerClass freeHandle: handle!

buildInitializer
	^self initializerClass fromHandle: handle!

clone
	| gpHandle |
	gpHandle := self initializerClass cloneHandle: self handle.
	^self class fromOwnedHandle: gpHandle!

copy
	^self class fromInitializer: self initializer copy!

createHandle
	"Private - Create and answer an external resource handle associated with the receiver."

	^initializer createHandle!

debugPrintOn: aStream
	self basicPrintOn: aStream!

evaluationClass
	^self class!

hash
	^self initializer hash!

initializer
	^initializer ifNil: [initializer := self buildInitializer]!

initializer: aGdiplusInitializer
	initializer := aGdiplusInitializer!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^self subclassResponsibility!

isPersistent
	"Private - Answer true if the receiver holds sufficient information such that
		it can recreate itself 
	 - ask the receiver's initializer"

	^self initializer isPersistent!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^initializer notNil and: [initializer isSelfEvaluating]!

onPreSaveImage
	handle ifNotNil: [self initializer onPreSaveImage: self]!

printOn: aStream
	"Append a developer friendly textual representation of the receiver to aStream."

	self initializer printGdiplusObject: self on: aStream!

setInitializer: aGdiplusInitializer
	self initialize.
	initializer := aGdiplusInitializer.
	^self! !

!Graphics.Gdiplus.GdiplusBase categoriesForMethods!
=!comparing!public! !
basicFree!private!realizing/unrealizing! !
buildInitializer!private!realizing/unrealizing! !
clone!copying!public! !
copy!copying!public! !
createHandle!private!realizing/unrealizing! !
debugPrintOn:!printing!public! !
evaluationClass!constants!private! !
hash!comparing!public! !
initializer!accessing!public! !
initializer:!accessing!public! !
initializerClass!private!realizing/unrealizing! !
isPersistent!private!testing! !
isSelfEvaluating!public!testing! !
onPreSaveImage!event handling!public! !
printOn:!printing!public! !
setInitializer:!initializing!private! !
!

!Graphics.Gdiplus.GdiplusBase class methodsFor!

fromInitializer: aGdiplusInitializer
	"Answer an instance of the receiver based on aspects of aGdiplusInitializer.  The instance holds
	a reference to the initializer which is expected to hold enough information to create the instance."

	^self basicNew setInitializer: aGdiplusInitializer!

fromOwnedHandle: aHandle
	"Answers an instance of the receiver with aHandle. The handle is owned by the instance and
	will therefore be freed by it."

	^self basicNew
		initialize;
		ownedHandle: aHandle;
		yourself!

guidNamesWithPrefix: aString
	"Private - Answer a GUID collection of Win32 types that begin with aString.

		self guidNamesWithPrefix: 'Encoder'
	"

	^GdiplusGUIDs keys select: [:e | e beginsWith: aString]!

guidsEncoder
	"Answer a key-value collection of Win32 Encoder GUID constants."

	^self guidsWithPrefix: 'Encoder'!

guidsFrameDimension
	"Answer a key-value collection of Win32 FrameDimension GUID string constants."

	^self guidsWithPrefix: 'FrameDimension'!

guidsWithPrefix: aString
	"Private - Answer a key-value collection of Win32 GUIDs that begin with aString.

		self guidsWithPrefix: 'Encoder'
	"

	^((self guidNamesWithPrefix: aString) collect: [:e | e -> (GdiplusGUIDs at: e)])
		asSortedArray: [:a :b | a key < b key]!

initialize	
	SessionManager current
		when: #imageSaveStarting
			send: #onPreSaveImage
			to: self!

onPreSaveImage
	self primAllSubinstances do: [:each | each onPreSaveImage]! !

!Graphics.Gdiplus.GdiplusBase class categoriesForMethods!
fromInitializer:!instance creation!public! !
fromOwnedHandle:!instance creation!public! !
guidNamesWithPrefix:!constants!private! !
guidsEncoder!constants!public! !
guidsFrameDimension!constants!public! !
guidsWithPrefix:!constants!private! !
initialize!constants!public! !
onPreSaveImage!event handling!public! !
!

