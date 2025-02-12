﻿"Filed out from Dolphin Smalltalk"!

Core.SequenceableCollection
	subclass: #'ADODB.ADOCollection'
	instanceVariableNames: 'interface'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

ADODB.ADOCollection guid: (Core.GUID fromString: '{34245405-a032-4a2a-95c0-96cc6854b57b}')!

ADODB.ADOCollection comment: 'ADOCollection is a <sequencedReadableCollection> wrapper around the ADODB <ADO_Collection> interfaces. Its purpose is to make all the power of Smalltalk sequenceable collections available on the much more limited ADO interfaces, and to provide seamless integration into the Smalltalk development environment (i.e. so that the ADO collections print, inspect, and generally act like arrays). 
All ADO interface methods that return a collection of some sort have been modified to return a subinstance of this class.

Instance Variables:
	interface		<ADO_Collection> subinstance.'!

!ADODB.ADOCollection methodsFor!

add: newElement
	"ADOCollections are not extensible."

	^self shouldNotImplement!

at: aStringOrInteger 
	"Answer the element of the receiver with the specified subscript. The subscript could be the
	one-based <integer> index of the element in the collection, or the <readableString> name of
	an element."

	"Implementation Note: Assume the underlying collection uses zero based indices."

	^interface 
		item: (aStringOrInteger isInteger ifTrue: [aStringOrInteger - 1] ifFalse: [aStringOrInteger])!

at: subscript put: newElement 
	"ADOCollections are mutated by modifying the elements themselves, rather than 
	overwriting the elements."

	^self shouldNotImplement!

basicFree
	"Private - Release any external resources held by the receiver."

	interface free!

copyingClass
	"Private - Answer the class of object expected when the receiver is copied in whole or in part."

	^Array!

free
	"Release an external resources held by the receiver."

	interface notNil ifTrue: [
		self basicFree.
		interface := nil]!

interface
	"Answer the underling ADO_Collection subinstance."

	^interface!

interface: anADOCollection
	"Private - "

	interface := anADOCollection.
	^self!

item: keyObject 
	Notification deprecated.	"6.0: Use #at:"
	^interface item: keyObject!

reset  
	"Reset the position of iterator."

	interface Reset
!

size
	"Answer the number of elements in the receiver."

	^interface count
!

species
	"Answer the preferred class of the receiver - not always the same as the answer to #class (although this implementation uses the class primitive, which should not fail). Normally used when comparing two objects to determine if they are of the comparable types."

	^Array!

uncheckedFrom: startInteger to: stopInteger keysAndValuesDo: aDyadicValuable
	"Private - Evaluate the <dyadicValuable> argument for each element of the receiver in the
	specified inclusive range, with the element and its index as respectively the second and
	first arguments. No bounds checks need be performed since the caller has established that
	the start and stop indices are in bounds."

	"Implementation Note: Override for improved performance (to avoid repeated instantation of
	VARIANT objects."

	| subscript |
	subscript := 0 asVariant.
	startInteger to: stopInteger
		do: 
			[:i |
			subscript int32: i - 1.
			aDyadicValuable value: i value: (interface item: subscript)]! !

!ADODB.ADOCollection categoriesForMethods!
add:!adding!public! !
at:!accessing!public! !
at:put:!accessing!public! !
basicFree!private!realizing/unrealizing! !
copyingClass!copying!private! !
free!public!realizing/unrealizing! !
interface!accessing!public! !
interface:!accessing!private! !
item:!accessing!public! !
reset!methods!public! !
size!accessing!public! !
species!accessing!public! !
uncheckedFrom:to:keysAndValuesDo:!enumerating!private! !
!

!ADODB.ADOCollection class methodsFor!

on: anADO_Collection
	"Answer a new instance of the receiver which implements the entire
	<sequencedReadableCollection> on the specified ADO collection list."

	^self new
		interface: anADO_Collection

	! !

!ADODB.ADOCollection class categoriesForMethods!
on:!instance creation!public! !
!

