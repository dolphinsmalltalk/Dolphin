"Filed out from Dolphin Smalltalk 7"!

External.DynamicLinkLibrary subclass: #'External.ResourceLibrary'
	instanceVariableNames: 'fileName loadFlags'
	classVariableNames: 'Libraries'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ResourceLibrary guid: (Core.GUID fromString: '{87b4c57f-026e-11d3-9fd7-00a0cc3e4a32}')!
External.ResourceLibrary comment: 'ExternalResourceLibrary is a generic type of <ExternalLibrary>, instance of which can be used to access resources (e.g. icons, bitmaps, strings) from arbitrary modules (DLLs and EXES). A registry of open resource libraries is maintained so that each module is represented by a single instance, and aliasing of the library names is supported to map old Dolphin resources to new libraries should the latter be renamed.'!
!External.ResourceLibrary categoriesForClass!External-Libraries! !
!External.ResourceLibrary methodsFor!

attemptToOpen: aString
	^
	[self basicOpen: aString.
	true] on: Win32Error do: [:ex | false]!

fileName
	"Answer the host system file name for the external library the 
	receiver represents."

	^fileName!

loadFlags
	^loadFlags!

loadFlags: anInteger
	loadFlags := anInteger!

open: aString
	"Private - Open the external library with the external file name, aString,
	as the library referenced by the receiver. Answer the receiver.
	Implementation Note: Any errors are suppressed, although a notification
	is written to the log device. If the resource library cannot be found at
	the specified path, then a number of attempts are made to open the
	lib in the order - working directory, image relative, install relative."

	| name |
	fileName := aString.
	name := self class aliasFor: aString.
	[self basicOpen: name] on: Win32Error
		do: 
			[:e1 |
			| filename |
			"Supplied path didn't work"
			((File splitPathFrom: name) notEmpty and: 
					["previously pathed, so try stem only"
					self attemptToOpen: (File splitStemFrom: name)])
				ifTrue: [^self].
			filename := File splitFilenameFrom: name.
			"Try the current image path"
			(self attemptToOpen: (FileLocator imageRelative localFileSpecFor: filename)) ifTrue: [^self].
			"Finally try the installation path"
			(self attemptToOpen: (FileLocator installRelative localFileSpecFor: filename)) ifTrue: [^self].
			"No luck, report the original error as a notification"
			Notification
				signal: 'Resource library ' , fileName , ' could not be opened (' , e1 description , ')'].
	^self!

stbSaveOn: anSTBOutFiler
	"Save out a binary representation of the receiver to anSTBOutFiler.
	Use a special proxy in order to share a common instance on reload."

	anSTBOutFiler saveObject: self as: (STBExternalResourceLibraryProxy forLibrary: self)! !
!External.ResourceLibrary categoriesFor: #attemptToOpen:!helpers!instance creation!private! !
!External.ResourceLibrary categoriesFor: #fileName!accessing!public! !
!External.ResourceLibrary categoriesFor: #loadFlags!constants!private! !
!External.ResourceLibrary categoriesFor: #loadFlags:!accessing!private! !
!External.ResourceLibrary categoriesFor: #open:!helpers!private! !
!External.ResourceLibrary categoriesFor: #stbSaveOn:!binary filing!instance creation!public! !

!External.ResourceLibrary class methodsFor!

aliasFor: libraryNameString
	"Answer the name of the resource file which should actually be opened in place
	of the named library. Generally the argument will be answered, but on occassion, e.g
	after a product upgrade, the resource file name has changed and so we can use
	this facility to remap old resources to the new resource file."

	| libName |
	libName := libraryNameString asLowercase.
	^(Libraries at: (File splitStemFrom: libName) ifAbsent: [^libName]) fileName!

defaultLoadFlags
	"Private - Answer the default LoadLibraryEx() flags to be used when loading
	instances of the receiver.
	Note: There appears to be a bug in Windows that results in a GPF in User32.dll if 
	one attempts to use a dialog template from a DLL loaded as a data file, therefore
	the development resources (for example) must be loaded without these flags."

	^##(LOAD_LIBRARY_AS_DATAFILE|DONT_RESOLVE_DLL_REFERENCES)
!

initialize
	"Private - Initialize the receiver's class variables, &c.
		ResourceLibrary initialize
	"

	Libraries := WeakLookupTable new!

onPreStripImage
	"Private - The image is about to be stripped, close down defaults to allow unused
	subclasses to be stripped."

	self initialize!

open: aString
	"Answer an instance of the receiver which references the external
	library with the <readableString> external file path argument."

	^self open: aString withAliases: #()!

open: pathString withAlias: aliasString
	"Register the <readableString>, aliasString, as an alias for the external resource
	library with the <readableString> path, pathString. Answer the aliased external
	resource library instance.
	N.B. The register of instances is weak. If the library instance is not referenced
	from elsewhere, then the alias will be lost and will need to be re-registered."

	^self open: pathString withAliases: {aliasString}!

open: aString withAliases: aCollection
	"Register the <collection> of <readableString>s, aCollection, as aliases for the 
	external resource library with the <readableString> path, aString. Answer the 
	new (or existing) external resource library instance.
	N.B. The register of instances is weak. If the library instance is not referenced
	from elsewhere, then the alias will be lost and will need to be re-registered."

	^self 
		open: aString
		withAliases: aCollection
		flags: self defaultLoadFlags!

open: aString withAliases: aCollection flags: anInteger
	"Register the <collection> of <readableString>s, aCollection, as aliases for the 
	external resource library with the <readableString> path, aString, using the
	LoadLibraryEx() flags in the <integer> argument if a new library needs to be
	opened. Answer the new (or existing) external resource library instance.
	N.B. The register of instances is weak. If the library instance is not referenced
	from elsewhere, then the alias will be lost and will need to be re-registered."

	| lib path |
	path := File default: aString asLowercase extension: 'dll'.
	lib := Libraries at: path
				ifAbsentPutClean: 
					[self new
						loadFlags: anInteger;
						open: path;
						initialize;
						yourself].
	aCollection do: [:alias | Libraries at: (File default: alias extension: 'dll') put: lib].
	^lib!

stbConvertFrom: anSTBClassFormat 
	"Convert from version 1 ExternalResourceLibrary (adds loadFlags inst. var)"

	^
	[:data | 
	| newInstance |
	newInstance := self basicNew.
	1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
	newInstance loadFlags: 0.
	newInstance]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1! !
!External.ResourceLibrary class categoriesFor: #aliasFor:!enquiries!public! !
!External.ResourceLibrary class categoriesFor: #defaultLoadFlags!constants!private! !
!External.ResourceLibrary class categoriesFor: #initialize!development!private! !
!External.ResourceLibrary class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!External.ResourceLibrary class categoriesFor: #open:!instance creation!public! !
!External.ResourceLibrary class categoriesFor: #open:withAlias:!instance creation!public! !
!External.ResourceLibrary class categoriesFor: #open:withAliases:!instance creation!public! !
!External.ResourceLibrary class categoriesFor: #open:withAliases:flags:!instance creation!public! !
!External.ResourceLibrary class categoriesFor: #stbConvertFrom:!binary filing!public! !
!External.ResourceLibrary class categoriesFor: #stbVersion!binary filing!public! !

