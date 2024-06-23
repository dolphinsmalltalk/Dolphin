"Filed out from Dolphin Smalltalk"!

Kernel.STLOutFiler
	subclass: #'Kernel.STLLegacyOutFiler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.STLLegacyOutFiler guid: (Core.GUID fromString: '{fdca489e-4b8f-4f76-ac69-5b66f7d59fe6}')!

Kernel.STLLegacyOutFiler isNonInstantiable: true!

Kernel.STLLegacyOutFiler comment: '`STBLegacyOutFiler` is the abstract class of  `STLOutFiler`s for writing object graphs in previous STL formats.

Note that although the old formats can be written with complete fidelity, this does not guarantee that the data will be deserializable in an older version of Dolphin because it may contain classes that are not present in the older image, or which have a different layout. It is generally better to avoid resaving old object streams that you might want to load in a downlevel version of Dolphin.
'!

!Kernel.STLLegacyOutFiler categoriesForClass!System-Binary storage! !

!Kernel.STLLegacyOutFiler methodsFor!

lastPredefined
	"Private - Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^LastPredefinedClassRef!

saveCollection: aCollection
	self saveObject: aCollection as: (STBCollectionProxy forCollection: aCollection)!

saveLookupTable: aLookupTable
	"Serialize a <LookupTable> to the object stream."

	"STL 3, 4 and 5 used collection proxies"

	self saveObject: aLookupTable as: (STBIdentityDictionaryProxy forCollection: aLookupTable)!

saveResourceLibrary: aResourceLibrary
	self saveObject: aResourceLibrary
		as: (STBExternalResourceLibraryProxy forLibrary: aResourceLibrary)!

saveSet: aSet elements: aCollection
	"Save a <Set> with elements in the 2nd argument to the object stream. In the case of a <Set> the first and second arguments are typically identical. In the case of a Dictionary, the 2nd argument should be the associations."

	"In STL 3/4, Sets were proxied. The elements were not sorted, so the resulting source representation could be unstable."

	self saveObject: aSet as: (STBCollectionProxy class: aSet basicClass array: aCollection asArray)!

saveStatic: aBindingReference for: anObject
	"Serialize a static variable reference into the stream."

	"Requires <BindingReference>s, which did not exist at the time of STB 3, but Processor and Transcript are special cases we need to support."

	anObject == Processor
		ifTrue: [stream nextPut: aBindingReference value]
		ifFalse: 
			[anObject == #{Transcript} value
				ifTrue: [self saveObject: anObject as: (STBSingletonProxy forClass: #{UI.TranscriptShell} value)]
				ifFalse: [self errorStaticVarRefsNotSupported]]! !

!Kernel.STLLegacyOutFiler categoriesForMethods!
lastPredefined!constants!private! !
saveCollection:!operations!public! !
saveLookupTable:!operations!public! !
saveResourceLibrary:!binary filing!public! !
saveSet:elements:!public!serializing! !
saveStatic:for:!public!serializing! !
!

