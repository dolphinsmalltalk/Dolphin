"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.CompilationResult'
	instanceVariableNames: 'method rawTextMap rawTempsMap textMap tempsMap oldMethod package'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.CompilationResult guid: (Core.GUID fromString: '{87b4c46e-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.CompilationResult comment: ''!
!Kernel.CompilationResult categoriesForClass!System-Support! !
!Kernel.CompilationResult methodsFor!

affectsAnnotation: aSymbol
	"Answer whether the receiver has affect on the set of Annotations in the method class that match the specified selector. It may be that the new method adds a matching annotation, or that the original method had a matching annotation."

	^(method notNil and: [method hasAnnotation: aSymbol])
		or: [oldMethod notNil and: [oldMethod hasAnnotation: aSymbol]]!

buildTempsMap
	| stream |
	stream := Array writeStream: rawTempsMap size.
	rawTempsMap do: 
			[:each |
			| ipRange |
			ipRange := (each at: 1) to: (each at: 2).
			ipRange isEmpty ifFalse: [stream nextPut: ipRange -> (each at: 3)]].
	tempsMap := stream contents.
	"Discard the raw temps map built by the compiler to save space"
	rawTempsMap := nil!

buildTextMap
	| stream sz |
	stream := Array writeStream: (sz := rawTextMap basicSize) // 3.
	1 to: sz
		by: 3
		do: 
			[:i |
			stream nextPut: (Association key: (rawTextMap at: i)
						value: ((rawTextMap at: i + 1) to: (rawTextMap at: i + 2)))].
	textMap := stream collection.
	"Discard the raw text map built by the compiler to save space"
	rawTextMap := nil.
	^textMap!

fireSystemUpdateEvent
	"Before firing the event, let the class know if annotations may have been changed. This could be done by hooking the update event, but we want to ensure it is done as a priority before any UI response that might be triggered by the event."

	method annotations ~= (oldMethod ifNotNil: [oldMethod annotations])
		ifTrue: [method methodClass annotationsUpdated: self].
	Smalltalk trigger: (self isNew ifTrue: [#methodAdded:] ifFalse: [#methodUpdated:]) with: self!

isNew
	^oldMethod isNil!

method
	"Answer the method resulting from a compilation, or nil if the compilation failed
	or the compilation was for the purpose of syntax checking only."

	^method!

method: aCompiledMethod
	"Private - Set the method."

	method := aCompiledMethod!

method: aCompiledMethod rawTextMap: textArray rawTempsMap: tempsArray
	method := aCompiledMethod.
	rawTextMap := textArray.
	rawTempsMap := tempsArray!

oldMethod
	^oldMethod!

oldMethod: aCompiledMethod
	oldMethod := aCompiledMethod!

package
	^package!

package: aPackage
	package := aPackage!

rawTempsMap: anObject
	rawTempsMap := anObject!

rawTextMap: anObject
	rawTextMap := anObject!

tempsAtIp: anInteger
	"Private - Answer the temps map entry for the scope that most closely encloses the specified
	1-based bytecode ip."

	^self tempsMap inject: #()
		into: [:match :each | (each key includes: anInteger) ifTrue: [each value] ifFalse: [match]]!

tempsMap
	"Answer the map of ip ranges to temporaries if such was requested (if not, then nil).
	The map is an array of associations between IP positions and the temporaries which
	are in scope at that point up to the next entry in the map."

	tempsMap isNil ifTrue: [self buildTempsMap].
	^tempsMap!

textMap
	"Answer the map of ip's to source code ranges if such was requested (if not, then nil)."

	^textMap ifNil: [self buildTextMap]! !
!Kernel.CompilationResult categoriesForMethods!
affectsAnnotation:!enquiries!public! !
buildTempsMap!development!private! !
buildTextMap!development!private! !
fireSystemUpdateEvent!helpers!private! !
isNew!accessing!public! !
method!accessing!public! !
method:!accessing!private! !
method:rawTextMap:rawTempsMap:!initializing!private! !
oldMethod!accessing!public! !
oldMethod:!accessing!public! !
package!accessing!public! !
package:!accessing!public! !
rawTempsMap:!accessing!private! !
rawTextMap:!accessing!private! !
tempsAtIp:!accessing!development!private! !
tempsMap!accessing!development!public! !
textMap!accessing!development!public! !
!

!Kernel.CompilationResult class methodsFor!

method: aCompiledMethod rawTextMap: textArray rawTempsMap: tempsArray
	<primitive: 157>
	^self new
		method: aCompiledMethod
		rawTextMap: textArray
		rawTempsMap: tempsArray! !
!Kernel.CompilationResult class categoriesForMethods!
method:rawTextMap:rawTempsMap:!instance creation!public! !
!

