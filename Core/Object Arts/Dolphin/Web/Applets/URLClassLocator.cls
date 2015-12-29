"Filed out from Dolphin Smalltalk X6"!

ClassLocator subclass: #URLClassLocator
	instanceVariableNames: 'transport'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
URLClassLocator guid: (GUID fromString: '{710058D4-73F5-11D3-97BD-0080C8D59432}')!
URLClassLocator comment: 'A URLClassLocator is used to indicate the location of an external binary class that is part of a BinaryPackage file that resides at a particular URL.  This type of locator requests, usually via an associated NPApplet instance, that the package file be downloaded from the URL to a local file location. From here the BinaryPackage can be loaded into the image and the appropriate class located within it. 

Instance Variables:
	transport	<NPApplet> to which requests to obtain the local class file can be directed.

'!
!URLClassLocator categoriesForClass!System-Binary class loading! !
!URLClassLocator methodsFor!

copyWithCodeBase
	"Private - Answer a instance of the same class as the receiver with the same codeBase.
	This allows both the codeBase and the mechanism for using it to be propagated."

	^super copyWithCodeBase transport: self transport
!

getSrcURLSynchronous: url
	"Private - The class stored at url is required to be downloaded onto the local machine."

	^self getURLSynchronous: url


	!

getURLSynchronous: url
	"Private - Answer the local file name after the url has been copied or nil if the process failed."

	^URLMonLibrary default urlDownloadToCacheFile: url!

initialize
	"Private - Initialize the receiver's identity instance variables."

	super initialize.
	transport := self!

localFileSpecFor: aStringFilename
	"Answer a filespec for aStringFilename."

	| url |
	url := self class canonicalizeURL: (self codeBase , aStringFilename).
	^self transport getSrcURLSynchronous: url.

!

relativePathTo: aURL
	"Answer a minimal <readableString> relative path to the resource with the 
	specified <readableString> path, which the receiver can map back to a full
	path via its #localFileSpecFor: method when required."

	^aURL!

transport
	"Answer the transport which will produce a local file name on request."

	transport isNil ifTrue: [ transport := self ].
	^transport!

transport: aTransport
	"Private - Set the transport for use by the receiver"

	transport := aTransport! !
!URLClassLocator categoriesFor: #copyWithCodeBase!copying!private! !
!URLClassLocator categoriesFor: #getSrcURLSynchronous:!accessing!private! !
!URLClassLocator categoriesFor: #getURLSynchronous:!operations!private! !
!URLClassLocator categoriesFor: #initialize!initializing!private! !
!URLClassLocator categoriesFor: #localFileSpecFor:!accessing!public! !
!URLClassLocator categoriesFor: #relativePathTo:!accessing!public! !
!URLClassLocator categoriesFor: #transport!accessing!public! !
!URLClassLocator categoriesFor: #transport:!initializing!private! !

!URLClassLocator class methodsFor!

canonicalizeURL: url
	"Answer the canonicalized <readableString> equivalent of the 
	<readableString> uniform resource locator. "

	| canon |
	canon := url copyReplacing: $\ withObject: $/.
	^canon last == $/ 
		ifTrue: [canon copyFrom: 1 to: canon size - 1]
		ifFalse: [canon]! !
!URLClassLocator class categoriesFor: #canonicalizeURL:!helpers!public! !

