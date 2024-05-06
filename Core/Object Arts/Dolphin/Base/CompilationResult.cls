"Filed out from Dolphin Smalltalk"!

Object subclass: #CompilationResult
	instanceVariableNames: 'method rawTextMap rawTempsMap textMap tempsMap oldMethod package'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CompilationResult guid: (GUID fromString: '{87b4c46e-026e-11d3-9fd7-00a0cc3e4a32}')!

CompilationResult comment: ''!

!CompilationResult categoriesForClass!System-Support! !

!CompilationResult methodsFor!

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
	| sz |
	sz := rawTextMap basicSize.
	textMap := OrderedCollection new: sz // 3.
	1 to: sz
		by: 3
		do: [:i | textMap add: (rawTextMap at: i) -> ((rawTextMap at: i + 1) to: (rawTextMap at: i + 2))].
	"Discard the raw text map built by the compiler to save space"
	rawTextMap := nil!

fireSystemUpdateEvent
	self method methodClass environment 
		trigger: (self isNew ifTrue: [#methodAdded:] ifFalse: [#methodUpdated:])
		with: self!

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

	textMap isNil ifTrue: [self buildTextMap].
	^textMap! !

!CompilationResult categoriesForMethods!
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

!CompilationResult class methodsFor!

method: aCompiledMethod rawTextMap: textArray rawTempsMap: tempsArray
	<primitive: 157>
	^self new
		method: aCompiledMethod
		rawTextMap: textArray
		rawTempsMap: tempsArray! !

!CompilationResult class categoriesForMethods!
method:rawTextMap:rawTempsMap:!instance creation!public! !
!

