"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'OS.RegistryDeserializer'
	instanceVariableNames: 'currentKey instVarMaps safeClasses objects validationBlock substitute'
	classVariableNames: ''
	imports: #(#{OS private})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.RegistryDeserializer guid: (Core.GUID fromString: '{708a38d5-e001-4ad8-bdfb-331745b41cfb}')!
OS.RegistryDeserializer comment: '`OS.RegistryDeserializer` is the deserializer for reading object graphs serialized to the Windows Registry using `OS.RegistrySerializer`.

See the class comment of `OS.RegistrySerializer` for a description of the serialization format and other details.'!
!OS.RegistryDeserializer categoriesForClass!Kernel-Objects! !
!OS.RegistryDeserializer methodsFor!

addSafeClass: aClass
	"Add the <Class> argument to the set of classes that are considered safe to load from the registry by the receiver."

	safeClasses isImmutable ifTrue: [safeClasses := safeClasses copy].
	safeClasses at: aClass shortName put: aClass asQualifiedReference!

allowUnknownClasses
	"Configure the receiver so that it will deserialise any class of object. This is insecure and should be used with care."

	validationBlock := [:ref | true]!

defaultSafeClassReferences
	"Answer an <abstractDictionary>, mapping from <readableString> class names to a <BindingReference> that resolves to the named class, for the default set of classes that are considered safe to load from the Registry. The basic value types that are representable as registry value types, e.g. SmallInteger, String, ByteArray, etc, are always considered safe and do not need to be in the map.
	An example of a potentially unsafe class is SortedCollection, although it is safe if the default sort algorithm is used. Any pluggable sort algorithm that contains a code block is potentially unsafe, but will normally be blocked because code objects (BlockClosures, CompiledMethods) are not safe without further validation of the deserialised instance and so are not included in the default safe list. The returned collection is shared, so if you want to use it as a basis and add some further classes, you'll need to make a copy of it (i.e. send it #copy)."

	^##((LookupTable withAll: {'Array' -> #{Core.Array}.
				'Association' -> #{Core.Association}.
				'Bag' -> #{Core.Bag}.
				'Character' -> #{Core.Character}.
				'DateAndTime' -> #{Core.DateAndTime}.
				'Dictionary' -> #{Core.Dictionary}.
				'Duration' -> #{Core.Duration}.
				'False' -> #{Core.False}.
				'Float' -> #{Core.Float}.
				'Fraction' -> #{Core.Fraction}.
				'GUID' -> #{Core.GUID}.
				'IdentityDictionary' -> #{Core.IdentityDictionary}.
				'Interval' -> #{Core.Interval}.
				'LargeInteger' -> #{Core.LargeInteger}.
				'Locale' -> #{Core.Locale}.
				'LookupTable' -> #{Core.LookupTable}.
				'Metaclass' -> #{Core.Metaclass}.
				'OrderedCollection' -> #{Core.OrderedCollection}.
				'ScaledDecimal' -> #{Core.ScaledDecimal}.
				'Set' -> #{Core.Set}.
				'SortedCollection' -> #{Core.SortedCollection}.
				'Symbol' -> #{Core.Symbol}.
				'True' -> #{Core.True}.
				'UInt32Bytes' -> #{External.UInt32Bytes}.
				'UInt64Bytes' -> #{External.UInt64Bytes}.
				'Color' -> #{Graphics.Color}.
				'ColorAlpha' -> #{Graphics.ColorAlpha}.
				'Font' -> #{Graphics.Font}.
				'Point' -> #{Graphics.Point}.
				'DefaultSortAlgorithm' -> #{Kernel.DefaultSortAlgorithm}.
				'VariableBinding' -> #{Kernel.VariableBinding}.
				'CLSID' -> #{OS.COM.CLSID}.
				'IID' -> #{OS.COM.IID}.
				'LOGFONTW' -> #{OS.LOGFONTW}.
				'WINDOWPLACEMENT' -> #{OS.WINDOWPLACEMENT}.
				'UI.Scintilla.IndicatorStyle' -> #{UI.Scintilla.IndicatorStyle}.
				'UI.Scintilla.KeyBinding' -> #{UI.Scintilla.KeyBinding}.
				'UI.Scintilla.Margin' -> #{UI.Scintilla.Margin}.
				'UI.Scintilla.MarkerDefinition' -> #{UI.Scintilla.MarkerDefinition}.
				'UI.Scintilla.TextStyle' -> #{UI.Scintilla.TextStyle}})
		isImmutable: true;
		yourself)!

findClass: typeOrRef
	^(safeClasses lookup: typeOrRef)
		ifNil: 
			[| candidate |
			candidate := typeOrRef asQualifiedReference.
			(validationBlock value: candidate)
				ifTrue: 
					[safeClasses isImmutable ifTrue: [safeClasses := safeClasses copy].
					safeClasses at: typeOrRef put: candidate.
					candidate valueOrNil]]
		ifNotNil: [:ref | ref valueOrNil]!

ignoreUnknownClasses
	"Configure the receiver so that it will only deserialise instances of the classes pre-configured into the receiver's known classes collection, e.g. using #safeClassReferences: or #addSafeClass:,
	References to class objects themselves (i.e. metaclass references) are generally allowed as these will resolve to the class by direct name lookup. Any other objects will skipped over and appear as the substitute object (nil, by default) in the deserialized object graph. This is the default option because is safe."

	validationBlock := [:ref | ref isMeta]!

instVarMapFor: aClass
	^(instVarMaps lookup: aClass)
		ifNil: 
			[| map size |
			size := aClass instSize.
			size == 0
				ifTrue: [map := ##(LookupTable new)]
				ifFalse: 
					[map := LookupTable new: size.
					aClass allInstanceVariableNames keysAndValuesDo: [:eachKey :eachValue | map at: eachValue put: eachKey]].
			instVarMaps at: aClass put: map]!

lookupReferencedObject: aString
	| subKey |
	subKey := PathCch
				pathCombine: currentKey pathFromRoot
				pszMore: aString
				dwFlags: PATHCCH_NONE.
	^objects at: subKey
		ifAbsentPutClean: 
			["Forward reference - this happens because the Registry API enumerates sub-keys in an arbitrary order, and we don't impose one"
			RegistryDeserializerStub new]!

namesAndObjectsDo: aDyadicValuable
	| parentKey |
	currentKey keyInfo valueCount > 1
		ifTrue: 
			[currentKey subValueNamesAndValuesDo: 
					[:eachName :each |
					"The default value is used for metadata, not sub-objects, so is skipped."
					eachName isEmpty ifFalse: [aDyadicValuable value: eachName value: each]]].
	parentKey := currentKey.
	parentKey keysAndValuesDo: 
			[:eachName :eachRegKey |
			currentKey := eachRegKey.
			aDyadicValuable value: eachName value: self readObject].
	currentKey := parentKey!

objectAt: aString
	| parentKey object |
	^(currentKey lookup: aString)
		ifNil: [currentKey valueAt: aString ifAbsent: nil]
		ifNotNil: 
			[:subkey |
			parentKey := currentKey.
			currentKey := subkey.
			object := self readObject.
			currentKey := parentKey.
			subkey free.
			object]!

objectForReference: aString
	| colon |
	colon := aString identityIndexOf: $:.
	^colon == 0
		ifTrue: [self lookupReferencedObject: aString]
		ifFalse: 
			[| object instVar index |
			object := self lookupReferencedObject: (aString copyFrom: 1 to: colon - 1).
			instVar := aString copyFrom: colon + 1 to: aString size.
			index := Shlwapi strToInt: instVar.
			index == 0
				ifTrue: [object instVarAt: ((self instVarMapFor: object class) at: instVar)]
				ifFalse: [object basicAt: index]]!

readInstVarsOf: anObject
	"Read the named and indexable instance variables of the <Object> argument from the current class key."

	| instVars |
	"Record the deserialized object before reading any of its vars, in case it is self-referential"
	self registerCurrentObject: anObject.
	instVars := self instVarMapFor: anObject class.
	self namesAndObjectsDo: 
			[:instVar :value |
			| i |
			i := Shlwapi strToInt: instVar.
			i == 0
				ifTrue: [(instVars lookup: instVar) ifNotNil: [:index | anObject instVarAt: index put: value]]
				ifFalse: [anObject basicAt: i put: value]]!

readObject
	| needsFree object |
	needsFree := currentKey realize.
	currentKey value
		ifNotNil: 
			[:params |
			| typeOrRef |
			typeOrRef := params at: 1.
			(typeOrRef at: 1) == $@
				ifTrue: [object := self objectForReference: (typeOrRef copyFrom: 2 to: typeOrRef size)]
				ifFalse: 
					[(self findClass: typeOrRef)
						ifNil: 
							[Notification signal: currentKey pathFromRoot , ' stores a ' , typeOrRef
										, ' which is not a known and/or safe class, and will be substituted'.
							self skipObject: params]
						ifNotNil: [:class | object := class readFromRegistry: self params: params]]].
	needsFree ifTrue: [currentKey free].
	^object!

readObjectOfClass: aClass params: anArray
	| object |
	object := (anArray lookup: 2)
				ifNil: [aClass basicNew]
				ifNotNil: [:size | aClass basicNew: (Shlwapi strToInt: size)].
	aClass isPointers
		ifTrue: [self readInstVarsOf: object]
		ifFalse: 
			[self registerCurrentObject: object.
			currentKey readValueAt: 'bytes' into: object].
	^object!

registerCurrentObject: anObject
	| obj |
	(obj := objects at: currentKey pathFromRoot ifAbsentPutClean: [anObject]) == anObject
		ifTrue: [^self].
	obj class == OS.RegistryDeserializerStub
		ifTrue: 
			["Resolve forward reference - slow, but relatively rare"
			obj oneWayBecome: anObject]
		ifFalse: [self error: 'Object already registered for ' , currentKey displayString]!

safeClassReferences: aCollection
	"Set the <abstractDictionary> of <BindingReference>s that resolve to classes pre-recognised as safe to be deserialised by the receiver. These will not be presented to the validationBlock."

	safeClasses := LookupTable new: aCollection size.
	aCollection do: [:each | safeClasses at: each value shortName put: each]!

setRegKey: aRegKey
	currentKey := aRegKey.
	instVarMaps := IdentityDictionary new: 8.
	safeClasses :=self defaultSafeClassReferences.
	objects := LookupTable new: 16.
	self ignoreUnknownClasses!

skipObject: anArray
	"Private - Skip over an object that is not know to be safe, replacing it in the object graph with the substitute object. We need to read all the sub-objects of the substituted object as the serializer may have created refs to these, if shared."

	self registerCurrentObject: substitute.
	self namesAndObjectsDo: [:instVar :value | ]!

substitute
	"The object to be substituted in place of objects in the deserialization graph that are not of classes passed by the validation block (i.e. objects that are not known to be safe)."

	^substitute!

substitute: anObject
	substitute := anObject!

valueAt: aString 
	^currentKey valueAt: aString! !
!OS.RegistryDeserializer categoriesForMethods!
addSafeClass:!initializing!public! !
allowUnknownClasses!initializing!public! !
defaultSafeClassReferences!constants!public! !
findClass:!helpers!private! !
ignoreUnknownClasses!initializing!public! !
instVarMapFor:!helpers!private! !
lookupReferencedObject:!helpers!private! !
namesAndObjectsDo:!deserializing!public! !
objectAt:!public! !
objectForReference:!helpers!private! !
readInstVarsOf:!deserializing!public! !
readObject!deserializing!public! !
readObjectOfClass:params:!deserializing!public! !
registerCurrentObject:!deserializing!public! !
safeClassReferences:!initializing!public! !
setRegKey:!initializing!private! !
skipObject:!private! !
substitute!public! !
substitute:!public! !
valueAt:!accessing!public! !
!

!OS.RegistryDeserializer class methodsFor!

icon
	^RegKeyAbstract icon!

readFrom: aRegKey
	^(self regKey: aRegKey) readObject!

regKey: aRegKey
	^self new
		setRegKey: aRegKey;
		yourself! !
!OS.RegistryDeserializer class categoriesForMethods!
icon!constants!public! !
readFrom:!instance creation!public! !
regKey:!public! !
!

