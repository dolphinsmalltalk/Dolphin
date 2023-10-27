"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary
	subclass: #'External.ResourceLibrary'
	instanceVariableNames: 'fileName loadFlags'
	classVariableNames: 'Libraries'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ResourceLibrary guid: (Core.GUID fromString: '{87b4c57f-026e-11d3-9fd7-00a0cc3e4a32}')!
External.ResourceLibrary comment: 'ExternalResourceLibrary is a generic type of <ExternalLibrary>, instance of which can be used to access resources (e.g. icons, bitmaps, strings) from arbitrary modules (DLLs and EXES). A registry of open resource libraries is maintained so that each module is represented by a single instance, and aliasing of the library names is supported to map old Dolphin resources to new libraries should the latter be renamed.'!
!External.ResourceLibrary categoriesForClass!External-Libraries! !
!External.ResourceLibrary methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent.
	Two DynamicLinkLibrary instances are considered equal if they are of the same species, and have (or would have if opened) the same module handle."

	^self == anObject or: 
			[self species == anObject species and: 
					[(self isOpen and: [anObject isOpen])
						ifTrue: [handle = anObject handle]
						ifFalse: 
							["Filenames should be compared using an ordinal case-insensitive comparison"
							(fileName compareOrdinals: anObject fileName ignoringCase: true) == 0]]]!

attemptToOpen: aString
	^
	[self basicOpen: aString.
	true] on: Win32Error do: [:ex | false]!

fileName
	"Answer the host system file name for the external library the 
	receiver represents."

	^fileName!

fileName: aString 
	fileName := aString!

hash
	"Answer whether the receiver and anObject are equivalent."

	^fileName hashOrdinalsIgnoringCase!

isSelfEvaluating
	^true!

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

printOn: aWriteStream
	aWriteStream
		nextPut: $(;
		print: self class;
		space;
		display: #open:;
		space;
		print: self fileName;
		nextPut: $)! !
!External.ResourceLibrary categoriesForMethods!
=!comparing!public! !
attemptToOpen:!helpers!instance creation!private! !
fileName!accessing!public! !
fileName:!public! !
hash!comparing!public! !
isSelfEvaluating!public!testing! !
loadFlags!constants!private! !
loadFlags:!accessing!private! !
open:!helpers!private! !
printOn:!public! !
!

!External.ResourceLibrary class methodsFor!

aliasFor: libraryNameString
	"Answer the name of the resource file which should actually be opened in place
	of the named library. Generally the argument will be answered, but on occasion, e.g
	after a product upgrade, the resource file name has changed and so we can use
	this facility to remap old resources to the new resource file."

	| libName |
	libName := libraryNameString asLowercase.
	^(Libraries at: (File splitStemFrom: libName) ifAbsent: [^libName]) fileName!

defaultLoadFlags
	"Private - Answer the default LoadLibraryEx() flags to be used when loading	instances of the receiver."

	^##(LOAD_LIBRARY_AS_IMAGE_RESOURCE bitOr: LOAD_LIBRARY_AS_DATAFILE)!

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

	| lib path aliases |
	path := File default: aString asLowercase extension: 'dll'.
	aliases := aCollection.
	lib := (Libraries lookup: path)
				ifNil: 
					[| newLib fullPath |
					newLib := self new
								loadFlags: anInteger;
								open: path;
								yourself.
					fullPath := newLib moduleFileName asLowercase.
					"When a DLL loaded as as a resource image, GetModuleFilename will not return a path for it"
					fullPath isEmpty
						ifTrue: [Libraries at: path put: newLib]
						ifFalse: 
							[(Libraries lookup: fullPath)
								ifNil: 
									[Libraries
										at: path put: newLib;
										at: fullPath put: newLib]
								ifNotNil: 
									[:existing |
									newLib close.
									Libraries at: path put: existing]]].
	aliases do: [:alias | Libraries at: (File default: alias extension: 'dll') put: lib].
	^lib! !
!External.ResourceLibrary class categoriesForMethods!
aliasFor:!enquiries!public! !
defaultLoadFlags!constants!private! !
initialize!development!private! !
onPreStripImage!class hierarchy-removing!private! !
open:!instance creation!public! !
open:withAlias:!instance creation!public! !
open:withAliases:!instance creation!public! !
open:withAliases:flags:!instance creation!public! !
!

