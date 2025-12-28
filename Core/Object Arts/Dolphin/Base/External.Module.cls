"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'External.Module'
	instanceVariableNames: 'handle'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants private} #{OS.Win32Errors private} #{Kernel._PrimitiveFailureCode private})
	classInstanceVariableNames: ''
	classConstants: {}!

External.Module guid: (Core.GUID fromString: '{000ee3ff-9110-4b77-b1c5-1d766d45c3a9}')!

External.Module comment: ''!

!External.Module methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent.
	Two Modules are considered equal if they are of the same species, and have (or would have if opened) the same module handle."

	^self == anObject or: 
			[self species == anObject species and: 
					[(self isOpen and: [anObject isOpen])
						ifTrue: [handle = anObject handle]
						ifFalse: 
							["Filenames should be compared using an ordinal case-insensitive comparison"
							(self comparisonName compareOrdinals: anObject comparisonName ignoringCase: true) == 0]]]!

asParameter
	"Answer the receiver in a form appropriate for passing to an DynamicLinkLibrary procedure."

	handle isNull ifTrue: [self open].
	^handle!

basicFree
	^Kernel32 freeLibrary: handle!

basicOpen: aString
	"Private - Open the external module with the external file name, aString, as the module referenced by the receiver. Answer the receiver.
	The module is NOT initialized."

	handle := nil.
	self handle: (self class load: aString flags: self loadFlags).
	self beFinalizable!

clear
	"Private - Reinitialize this module instance, e.g. on startup."

	handle := nil!

close
	"Release the reference the receiver has to the external module it represents. This may not cause the module to be unloaded, so it may still function. Answer whether the module was successfully closed."

	| success |
	self beUnfinalizable.
	success := handle notNull and: [self basicFree].
	handle := nil.
	^success!

comparisonName
	^self fileName!

defaultFileName
	^''!

fileName
	"Answer the host system file name for the external module the receiver represents."

	^handle isNull ifTrue: [self defaultFileName] ifFalse: [self moduleFileName]!

formatMessage: anIntegerId with: arguments
	"Answer a message formatted from the Win32 format string with the specified id in the receiver's external module, with substitutions from the collection, arguments."

	^String
		formatMessage: anIntegerId
		in: self asParameter
		withArguments: arguments!

free
	self close!

handle
	^handle!

handle: aHandle
	"Private - Set the handle of the external module which the receiver represents. Answer the receiver."

	handle := aHandle ifNotNil: [aHandle asExternalHandle]!

hash
	^self comparisonName hashOrdinalsIgnoringCase!

isOpen
	"Answer whether the external module represented by the receiver has been opened."

	^handle isNull not!

loadFlags
	"Private - Flags passed to [LoadLibraryEx](https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-loadlibraryexw)."

	^LOAD_LIBRARY_SEARCH_DEFAULT_DIRS!

loadString: anIntegerId
	"Answer the string with the specified id from the receiver's resources."

	^String fromId: anIntegerId in: self!

moduleFileName
	"Private - Answer the file name of the receiver's loaded module."

	^self class moduleFileName: self!

open
	"Private - Open the external module referenced by the receiver. Answer the receiver. The module is NOT initialized."

	self open: self fileName!

open: aString
	"Private - Open the external module with the file name, aString, as the module referenced by the receiver. Answer the receiver. The module is initialized."

	(self basicOpen: aString) initialize!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		nextPutAll: (handle isNil ifTrue: ['NULL'] ifFalse: [handle asInteger printStringRadix: 16]);
		nextPutAll: ' - ';
		print: self fileName;
		nextPut: $)!

versionFormatString
	"Private - Answer a String containing the version format used by the receiver.
	The arguments than can be inserted into the string are:
		1) Product name
		2) Product major high word
		3) Product major low word
		4) Product minor high word
		5) Product minor low word
	"

	^'%2!!d!!.%3!!d!! build %4!!d!!'!

versionInfo
	"Answer a <VersionInfo> containing the version details from the receiver's external module."

	^VersionInfo forPath: self moduleFileName!

versionString
	"Answer a version number String in the format used by the receiver, (typically N.N Build N, but see #versionFormatString)."

	^self versionInfo formatVersionString: self versionFormatString! !

!External.Module categoriesForMethods!
=!comparing!public! !
asParameter!converting!public! !
basicFree!private!realizing/unrealizing! !
basicOpen:!private!realizing/unrealizing! !
clear!private!realizing/unrealizing! !
close!public!realizing/unrealizing! !
comparisonName!comparing!private! !
defaultFileName!constants!private! !
fileName!accessing!public! !
formatMessage:with:!accessing!public! !
free!finalizing!public! !
handle!accessing!private! !
handle:!accessing!private! !
hash!comparing!public! !
isOpen!public!testing! !
loadFlags!constants!private! !
loadString:!accessing!public! !
moduleFileName!accessing!private! !
open!private!realizing/unrealizing! !
open:!private!realizing/unrealizing! !
printOn:!printing!public! !
versionFormatString!constants!private! !
versionInfo!accessing-version!public! !
versionString!accessing-version!public! !
!

!External.Module class methodsFor!

fromHandle: aHandle
	"Answers an instance of the receiver attached to aHandle."

	^self new handle: aHandle!

load: aString flags: anInteger
	"Private - Open the external library module with file name, aString, and answer the module handle."

	| hLibrary |
	hLibrary := Kernel32
				loadLibraryEx: aString
				hFile: nil
				dwFlags: anInteger.
	^hLibrary ifNil: [Win32Error signal]!

moduleFileName: aLibOrHandle
	"Private - Answer the `Utf16String` file name of the receiver's loaded module."

	^Kernel32 getModuleFilename: aLibOrHandle!

open: aString
	"Answer an instance of the receiver which references the external module with the file name, aString. The instance is initialized (most Modules don't need any initializing, but you get the option)."

	^self new open: aString! !

!External.Module class categoriesForMethods!
fromHandle:!instance creation!public! !
load:flags:!private!realizing/unrealizing! !
moduleFileName:!helpers!private! !
open:!instance creation!public! !
!

