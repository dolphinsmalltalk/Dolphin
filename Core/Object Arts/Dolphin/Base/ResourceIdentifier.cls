"Filed out from Dolphin Smalltalk"!

Object subclass: #ResourceIdentifier
	instanceVariableNames: 'owningClass selector'
	classVariableNames: 'SelectorPrefix'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ResourceIdentifier guid: (GUID fromString: '{6235654d-3f88-48c0-80d9-90230e9ede77}')!

ResourceIdentifier comment: ''!

!ResourceIdentifier categoriesForClass!MVP-Resources! !

!ResourceIdentifier methodsFor!

<= aResourceIdentifier
	"Answer whether the receiver is 'less than' aResourceIdentifier.
	By implementing this method, we enable ResourceIdentifier objects to be stored
	in a SortedCollection with the default sort block."

	^(self owningClass = aResourceIdentifier owningClass) 
		ifTrue: [self name <= aResourceIdentifier name]
		ifFalse: [self owningClass <= aResourceIdentifier owningClass].!

= aResourceIdentifier
	"Answer true if aResourceIdentifier is equal to (represents the same resource as) the receiver."

	^self species == aResourceIdentifier species and: [ 
		self owningClass == aResourceIdentifier owningClass and: [
			self name = aResourceIdentifier name]]!

compiledMethod
	^self owningClass class compiledMethodAt: self selector ifAbsent: []!

copy
	"Answer a new instance like the receiver."

	^self class class: owningClass name: self name!

editExpression
	"Private - Answer a String that can be evaluated to edit an emitted resource"

	^'ViewComposer openOn: (ResourceIdentifier class: self selector: <1p>)' expandMacrosWith: self selector!

emitMethodHeaderFor: aSymbol on: stream 
	stream
		nextPutAll: aSymbol;
		cr;
		nextPutAll: (self resourceMethodComment expandMacrosWith: self name with: self editExpression);
		cr;
		cr!

exists
	^(self owningClass class includesSelector: self selector)!

exportedFileName
	"Private - Answer the receiver's default file name for file outs."

	| package path |
	package := self owningPackage.
	path := package isNil ifTrue: [''] ifFalse: [package path].
	^File 
		composePath: path
		stem: self displayString
		extension: self class exportFileExtension!

hash
	"Answer the SmallInteger hash value for the receiver."

	^owningClass hash bitXor: self name hash!

hiddenObjects
	"Private - Answers a <collection> of the <Object>s that are contained in the receiver's resource
	Implementation note. This is not particularly fast since it loads the resource
	classes it needs into the image. View resources will not be realized as windows however."

	(Smalltalk lookup: #STLInFiler)
		ifNotNil: 
			[:stlInFilerClass |
			self resource
				ifNil: [self error: 'Resource [' , owningClass name , '>>#' , selector , '] does not exist']
				ifNotNil: 
					[:resource |
					^(stlInFilerClass on: resource readStream)
						basicNext;
						readMap]].
	^#()!

icon: anIcon
	anIcon isNil ifTrue: [self removePropertyAt: #icon ifAbsent: []] ifFalse: [self propertyAt: #_icon put: anIcon]!

isChanged
	^false!

isChanged: aBoolean 
	self shouldNotImplement!

legacyStlVersion
	^4!

load
	"Load and answer the resource represented by the receiver."

	^self shouldNotImplement!

name
	"Answer the name of the resource represented by the receiver."

	^self class nameFromSelector: selector!

name: aStringOrNil 
	"Set the name of the resource represented by the receiver."

	selector := self class selectorFromName: aStringOrNil!

owningClass
	"Answer the class that owns the resource represented by the receiver."

	^owningClass!

owningClass: aClass
	"Set the class that owns the resource represented by the receiver."

	owningClass := aClass!

owningPackage
	^(self compiledMethod ifNil: [self owningClass]) owningPackage!

owningPackage: aPackage 
	"Set the receiver's <Package> to be the argument. Any current package association is lost."

	self compiledMethod owningPackage: aPackage!

printOn: aStream 
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	owningClass printOn: aStream.
	aStream nextPut: $..
	(self name notNil ifTrue: [self name] ifFalse: ['untitled']) displayOn: aStream!

resource
	"Answer the literal resource data represented by the receiver. "

	(self owningClass respondsTo: selector) ifFalse: [^nil].
	^self owningClass perform: self selector!

resourceMethodComment
	^'	"Answer the literal data from which the ''<1s>'' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	<2s>
	"'!

resourceOrNil
	"Answer the resource represented by the receiver or nil if none exists"

	(self owningClass class includesSelector: self selector) ifFalse: [^nil].
	^self resource!

selector
	^selector!

selector: aSymbol
	selector := aSymbol!

storeOn: aStream
	"Append to the <puttableStream> argument, target, an expression which when 
	evaluated will answer a collection similar to the receiver."

	aStream
		nextPut: $(;
		print: self class;
		nextPutAll: ' class: ';
		print: self owningClass;
		nextPutAll: ' name: ';
		print: self name;
		nextPut: $)! !

!ResourceIdentifier categoriesForMethods!
<=!comparing!public! !
=!comparing!public! !
compiledMethod!accessing!public! !
copy!copying!public! !
editExpression!helpers!private! !
emitMethodHeaderFor:on:!accessing!private! !
exists!public!testing! !
exportedFileName!accessing!development!private! !
hash!comparing!public! !
hiddenObjects!accessing!private! !
icon:!accessing!public! !
isChanged!development!public!source filing!testing! !
isChanged:!development!public!source filing! !
legacyStlVersion!private! !
load!operations!public! !
name!accessing!public! !
name:!accessing!public! !
owningClass!accessing!public! !
owningClass:!initializing!public! !
owningPackage!accessing!public! !
owningPackage:!accessing!development!public! !
printOn:!printing!public! !
resource!accessing!public! !
resourceMethodComment!accessing!constants!private! !
resourceOrNil!accessing!public! !
selector!accessing!public! !
selector:!initializing!public! !
storeOn:!printing!public! !
!

!ResourceIdentifier class methodsFor!

allResourceIdentifiers
	| rids |
	rids := OrderedCollection new: 512.
	self allResourceIdentifiersDo: [:rid | rids addLast: rid].
	^rids!

allResourceIdentifiersDo: aMonadicValuable
	Class allClassesDo: [:each | each resourceIdentifiersDo: aMonadicValuable]!

class: aClass 
	^self class: aClass name: 'Default view'!

class: aClass name: aString 
	"Answer a new instance of the receiver identifying a Resource with name aString
	belonging to aClass."

	^(super new)
		owningClass: aClass;
		name: aString;
		yourself!

class: aClass selector: aSymbol
	(aSymbol beginsWith: SelectorPrefix)
		ifFalse: [self error: 'Invalid resource selector ' , aSymbol printString].
	^super new
		owningClass: aClass;
		selector: aSymbol;
		yourself!

exportFileExtension
	"Answer the file extension associated with resources of this type when
	stored in files."

	^'vu'!

forMethod: aCompiledMethod 
	| thisName |
	thisName := self nameFromSelector: aCompiledMethod selector.
	thisName isNil ifTrue: [^nil].
	^self class: aCompiledMethod methodClass instanceClass name: thisName!

initialize
	SelectorPrefix := 'resource_' asUtf8String
				isImmutable: true;
				yourself!

nameFromSelector: aSymbol
	| resname prefixSize nameSize |
	aSymbol isNil ifTrue: [^nil].
	(aSymbol beginsWith: SelectorPrefix) ifFalse: [^nil].
	prefixSize := SelectorPrefix size.
	resname := String new: (nameSize := aSymbol size - prefixSize).
	1 to: nameSize
		do: 
			[:i |
			| ch |
			ch := aSymbol at: i + prefixSize.
			resname at: i put: (ch == $_ ifTrue: [$\x20] ifFalse: [ch])].
	^resname!

onPreStripImage
	"Private -  Allow the receiver to be stripped by clearing lazy initialized class variable
	which holds an instance of the receiver."

	self allResourceIdentifiersDo: [:each | each icon: nil]!

removeResource: aResourceIdentifier 
	^aResourceIdentifier owningClass class removeSelector: aResourceIdentifier selector ifAbsent: []!

selectorFromName: aString
	| selector prefix |
	aString isNil ifTrue: [^nil].
	prefix := SelectorPrefix.
	selector := WriteStream on: (aString copyEmpty: prefix size + aString size).
	selector nextPutAll: prefix.
	aString do: 
			[:each |
			each == $\x20
				ifTrue: [selector nextPut: $_]
				ifFalse: [each isAlphaNumeric ifTrue: [selector nextPut: each]]].
	^selector contents asSymbol!

stbConvertFrom: anSTBClassFormat
	"Convert from previous version resource. 
	Version Changes:
		1) removes stores a selector as the resource name rather than a string name (this change was made an age ago, and not properly converted)
	"

	anSTBClassFormat version == 0
		ifTrue: 
			[^
			[:data |
			data becomeA: self.
			data selector isSymbol ifFalse: [data name: data selector].
			data]].
	^super stbConvertFrom: anSTBClassFormat!

stbVersion
	^1!

value: a value: b
	"Private - The receiver acts as the default sort block for its instances."

	^a owningClass == b owningClass
		ifTrue: [a name <= b name]
		ifFalse: [a owningClass name asString <= b owningClass name asString]
!

viewResourceCategoryName
	^'resources-views'! !

!ResourceIdentifier class categoriesForMethods!
allResourceIdentifiers!accessing!public! !
allResourceIdentifiersDo:!accessing!enumerating!public! !
class:!instance creation!public! !
class:name:!instance creation!public! !
class:selector:!instance creation!public! !
exportFileExtension!constants!public! !
forMethod:!instance creation!public! !
initialize!class initialization!public! !
nameFromSelector:!helpers!public! !
onPreStripImage!class hierarchy-removing!private! !
removeResource:!public!removing! !
selectorFromName:!helpers!public! !
stbConvertFrom:!binary filing!private! !
stbVersion!binary filing!public! !
value:value:!helpers!private! !
viewResourceCategoryName!constants!private! !
!

