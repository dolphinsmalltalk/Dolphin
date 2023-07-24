"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.ResourceIdentifier'
	instanceVariableNames: 'owningClass selector'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'SelectorPrefix' -> 'resource_' }!
UI.ResourceIdentifier guid: (Core.GUID fromString: '{6235654d-3f88-48c0-80d9-90230e9ede77}')!
UI.ResourceIdentifier comment: ''!
!UI.ResourceIdentifier categoriesForClass!MVP-Resources! !
!UI.ResourceIdentifier methodsFor!

<= aResourceIdentifier
	"Answer whether the receiver is 'less than' aResourceIdentifier.
	By implementing this method, we enable ResourceIdentifier objects to be stored
	in a SortedCollection with the default sort block."

	^(self owningClass = aResourceIdentifier owningClass) 
		ifTrue: [self name <= aResourceIdentifier name]
		ifFalse: [self owningClass <= aResourceIdentifier owningClass].!

= aResourceIdentifier
	"Answer true if aResourceIdentifier is equal to (represents the same resource as) the receiver."

	^self species == aResourceIdentifier species and: 
			[self owningClass == aResourceIdentifier owningClass and: [selector = aResourceIdentifier selector]]!

compiledMethod
	^self owningClass class compiledMethodAt: self selector ifAbsent: nil!

copy
	"Answer a new instance like the receiver."

	^self class class: owningClass selector: selector!

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

icon: anIcon
	anIcon isNil
		ifTrue: [self removePropertyAt: #icon ifAbsent: nil]
		ifFalse: [self propertyAt: #_icon put: anIcon]!

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
		store: self class;
		nextPutAll: ' class: ';
		store: self owningClass;
		nextPutAll: ' name: ';
		print: self name;
		nextPut: $)! !
!UI.ResourceIdentifier categoriesForMethods!
<=!comparing!public! !
=!comparing!public! !
compiledMethod!accessing!public! !
copy!copying!public! !
exists!public!testing! !
exportedFileName!accessing!development!private! !
hash!comparing!public! !
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
resourceOrNil!accessing!public! !
selector!accessing!public! !
selector:!initializing!public! !
storeOn:!printing!public! !
!

!UI.ResourceIdentifier class methodsFor!

allResourceIdentifiers
	| rids |
	rids := OrderedCollection new: 512.
	self allResourceIdentifiersDo: [:rid | rids addLast: rid].
	^rids!

allResourceIdentifiersDo: aMonadicValuable
	Smalltalk allClassesDo: [:each | each resourceIdentifiersDo: aMonadicValuable]!

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
	^self newClass: aClass selector: aSymbol!

exportFileExtension
	"Answer the file extension associated with resources of this type when
	stored in files."

	^'vu'!

forMethod: aCompiledMethod 
	| thisName |
	thisName := self nameFromSelector: aCompiledMethod selector.
	thisName isNil ifTrue: [^nil].
	^self class: aCompiledMethod methodClass instanceClass name: thisName!

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

newClass: aClass selector: aSymbol
	<primitive: 157>
	^self new
		owningClass: aClass;
		selector: aSymbol;
		yourself!

onPreStripImage
	"Private -  Allow the receiver to be stripped by clearing lazy initialized class variable
	which holds an instance of the receiver."

	self allResourceIdentifiersDo: [:each | each icon: nil]!

removeResource: aResourceIdentifier 
	^aResourceIdentifier owningClass class removeSelector: aResourceIdentifier selector ifAbsent: nil!

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
				ifFalse: [('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' includes: each) ifTrue: [selector nextPut: each]]].
	^selector contents asSymbol!

value: a value: b
	"Private - The receiver acts as the default sort block for its instances."

	^a owningClass == b owningClass
		ifTrue: [a name <= b name]
		ifFalse: [a owningClass name asString <= b owningClass name asString]
!

viewResourceCategoryName
	^'resources-views'! !
!UI.ResourceIdentifier class categoriesForMethods!
allResourceIdentifiers!accessing!public! !
allResourceIdentifiersDo:!accessing!enumerating!public! !
class:!instance creation!public! !
class:name:!instance creation!public! !
class:selector:!instance creation!public! !
exportFileExtension!constants!public! !
forMethod:!instance creation!public! !
nameFromSelector:!helpers!public! !
newClass:selector:!instance creation!private! !
onPreStripImage!class hierarchy-removing!private! !
removeResource:!public!removing! !
selectorFromName:!helpers!public! !
value:value:!helpers!private! !
viewResourceCategoryName!constants!private! !
!

