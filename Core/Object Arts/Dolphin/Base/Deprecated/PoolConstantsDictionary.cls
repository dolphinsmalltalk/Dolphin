"Filed out from Dolphin Smalltalk"!

Kernel.PoolDictionary
	variableSubclass: #PoolConstantsDictionary
	instanceVariableNames: 'name'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
PoolConstantsDictionary guid: (Core.GUID fromString: '{87b4c52e-026e-11d3-9fd7-00a0cc3e4a32}')!
PoolConstantsDictionary comment: 'Prior to Dolphin 8, `PoolConstantDictionary` instances were used as shared constants pools, the canonical example being `Win32Constants`.  From Dolphin 8 constants pools are `Namespace` classes specialised to hold immutable bindings, and are created as subclasses of `SharedPool`. 

`PoolConstantDictionary` definitions stored in older packages will be automatically converted to `SharedPool` subclasses at package load time, so this class is only required for loading such packages, and also resaving in the legacy format. It is not expected to have instances at other times.'!
!PoolConstantsDictionary categoriesForClass!Deprecated! !
!PoolConstantsDictionary methodsFor!

add: anAssociation
	"Add the key/value pair provided in the <Association> argument to the receiver.
	The actual <Association> is not added as there are many constraints so it is safe to add a newly formed constant VariableBinding."

	self at: anAssociation key put: anAssociation value.
	^anAssociation!

canFileOut
	"Answer true if the receiver can be filed out. At this stage we just check to ensure that
	the file out file is writeable"

	^File isWriteable: self  fileOutName!

classesReferencing
	^Smalltalk allClasses select: [:c | c allSharedPools includes: self]!

environment
	"Answer the receiver's <Namespace> scope."

	^Smalltalk!

fileOut
	"File out the receiver to <name>.st"

	self class sourceManager fileOut: self.
	self isChanged: false!

fileOutName
	"Answer the receiver's default file name for file outs (<name>.st)."

	| path package |
	path := File composeStem: self name extension: 'st'.
	package := Package manager packageOfVariableNamed: self name asQualifiedReference.
	package notNil ifTrue: [path := File replacePath: path with: package path].
	^path!

fileOutOn: aSourceFiler
	aSourceFiler fileOutPoolDictionary: self!

fullName
	"Answer the <String> fully qualified name of the receiver, which is a dot-separated path that binds to the receiver from the global namespace, Root."

	^self environment fullNameFor: self unqualifiedName!

fullNameFor: aString
	"Private - Answer the full name  of a variable with the specified local identifier, assumed to be in this namespace. This will be a (potentially) dot-separated path string that is bindable from any top-level namespace, including Smalltalk."

	| stream |
	stream := String writeStream: 32.
	self environment printFullNameOn: stream.
	stream
		nextPut: $.;
		nextPutAll: self unqualifiedName;
		nextPut: $.;
		nextPutAll: aString.
	^stream contents!

fullPath
	^$. split: self fullName!

isChanged
	"Answer true if the receiver or any of it's contents have been changed since
	their changed flag was last reset."

	^self propertyAt: #isChanged ifAbsent: false!

isChanged: aBoolean
	"Flag the receiver as changed or not changed, according to the value 
	of the <Boolean> argument. If the receiver is marked as changed, then
	its owning package (if any) is also so marked."

	"Note that we don't test the existing value of the change flag here, because
	 we want to inform the package regardless (in case it isn't currently changed
	 for some reason)"

	aBoolean
		ifTrue: 
			[| package |
			self propertyAt: #isChanged put: true.
			(package := self owningPackage) notNil ifTrue: [package isChanged: true]]
		ifFalse: [self removePropertyAt: #isChanged ifAbsent: nil]!

isValidKey: aString
	^SharedPool isValidKey: aString!

keyString: anObject
	| answer |
	answer := anObject asString.
	(self isValidKey: answer) ifFalse: [^self error: ('Invalid key: <1p>' expandMacrosWith: answer)].
	^answer!

name
	"Answer the receiver's name."

	^name ifNil: [self environment keyAtValue: self ifAbsent: [self anonymousName]]!

name: aSymbol 
	name := aSymbol asSymbol!

newAssociation: keyObject value: valueObject
	^(super newAssociation: keyObject value: valueObject)
		beImmutableObject;
		yourself!

owningPackage
	"Answers the package that owns the receiver or nil if it is not yet owned by any package"

	| n |
	n := self name.
	^n = 'Anon' ifFalse: [Package manager packageOfVariableNamed: n asQualifiedReference]!

preResize: newMe 
	"Private - This message is sent by the receiver when resizing, before the
	receiver's elements are added to newMe. We must assign across the
	search policy."

	name isNil ifFalse: [newMe name: name]!

shortNameFor: aString
	"Private - Answer the short name for the receiver's variable named, aString. The short name is the shortest name that binds to variable starting from the Smalltalk namespace. This may be unqualified, partially qualified, or fully-qualified."

	^Smalltalk shortNameFor: aString in: self!

sourceFilerClass
	^LegacyChunkSourceFiler! !
!PoolConstantsDictionary categoriesForMethods!
add:!adding!public! !
canFileOut!public!source filing! !
classesReferencing!development!private! !
environment!accessing!public! !
fileOut!public!source filing! !
fileOutName!public!source filing! !
fileOutOn:!public!source filing! !
fullName!accessing!public! !
fullNameFor:!helpers!private! !
fullPath!accessing!namespaces!private! !
isChanged!public!source filing! !
isChanged:!public!source filing! !
isValidKey:!adding!development!private! !
keyString:!adding!development!private! !
name!accessing!public! !
name:!accessing!private! !
newAssociation:value:!helpers!private! !
owningPackage!public!source filing! !
preResize:!adding!private! !
shortNameFor:!enquiries!private! !
sourceFilerClass!public!source filing! !
!

PoolConstantsDictionary methodProtocol: #sourceObject attributes: #(#readOnly) selectors: #(#canFileOut #fileOut #fileOutName #isChanged #isChanged: #owningPackage #sourceFilerClass)!

