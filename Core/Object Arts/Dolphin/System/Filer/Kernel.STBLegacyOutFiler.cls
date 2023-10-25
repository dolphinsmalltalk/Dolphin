"Filed out from Dolphin Smalltalk"!

Kernel.STBOutFiler
	subclass: #'Kernel.STBLegacyOutFiler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBLegacyOutFiler guid: (Core.GUID fromString: '{de9ffce3-6ac1-4d88-a92d-8f7663a3391e}')!
Kernel.STBLegacyOutFiler isNonInstantiable: true!
Kernel.STBLegacyOutFiler comment: '`STBLegacyOutFiler` is the abstract class of  `STBOutFiler`s for previous STB versions.

Note that although the old formats can be written with complete fidelity, this does not guarantee that the data will be deserializable in an older version of Dolphin because it may contain classes that are not present in the older image, or which have a different layout.'!
!Kernel.STBLegacyOutFiler categoriesForClass!System-Binary storage! !
!Kernel.STBLegacyOutFiler methodsFor!

saveCollection: aCollection
	"Serialize a <Collection> to the object stream."

	"STB before 6 used collection proxies"

	self saveObject: aCollection as: (STBCollectionProxy forCollection: aCollection)!

saveLookupTable: aLookupTable
	"Serialize a <LookupTable> to the object stream."

	"STB before 6 used collection proxies"

	self saveObject: aLookupTable as: (STBIdentityDictionaryProxy forCollection: aLookupTable)!

saveResourceLibrary: aResourceLibrary
	self saveObject: aResourceLibrary as: (STBExternalResourceLibraryProxy forLibrary: aResourceLibrary)!

saveSet: aSet elements: aCollection
	"Save a <Set> with elements in the 2nd argument to the object stream. In the case of a <Set> the first and second arguments are typically identical. In the case of a Dictionary, the 2nd argument should be the associations."

	"In STB prior to 6, Sets were proxied."

	self saveObject: aSet as: (STBCollectionProxy class: aSet class array: aCollection asArray)! !
!Kernel.STBLegacyOutFiler categoriesForMethods!
saveCollection:!operations!public! !
saveLookupTable:!operations!public! !
saveResourceLibrary:!operations!public! !
saveSet:elements:!public!serializing! !
!

