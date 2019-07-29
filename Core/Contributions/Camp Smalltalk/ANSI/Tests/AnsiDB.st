"======================================================================
|
|   ANSI Protocols database
|
|   This file is in the public domain.
|
 ======================================================================"

(ProtocolSpec newProtocolNamed: #'abstractDictionary'
	conformsToProtocolNames: #(#'collection')
	) protocolDescription: '
Provides protocol for accessing, adding, removing, and iterating over the elements of an unordered collection whose elements are accessed using an explicitly assigned external key.
Glossary Entries
'
!

ProtocolSpec newMessagePattern: 'addAll: dictionary'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Store the elements of dictionary in the receiver at the corresponding keys from dictionary.
'
	definedIn: 'abstractDictionary'
	definition: 'This message is equivalent to repeatedly sending the #at:put: message to the receiver with each of the keys and elements in dictionary in turn. If a key in dictionary is key equivalent to a key in the receiver, the associated element in dictionary replaces the element in the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('dictionary' 'abstractDictionary' #'unspecified') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'at: key'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Answer the element at key in the receiver.
'
	definedIn: 'abstractDictionary'
	definition: 'This message defines element lookup based on a key. Answer the element stored at key.
Lookup is successful if an element has been previously stored in the receiver at a key that is key equivalent to key. This element is answered. Specifically, the following expression must return true for all appropriate bindings of dictionary, key, and value:
dictionary at: key put: value.
^(dictionary at: key) == value
The result is undefined if the receiver does not contain an element keyed by key or if the key is nil.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('key' 'Object' #'uncaptured') )
	returnValues: #( #( 'Object' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'at: key ifAbsent: operation'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Answer the element at key in the receiver. If key lookup for key fails, then answer the result of evaluating operation.
'
	definedIn: 'abstractDictionary'
	definition: 'Answer the element stored at the specified key if key lookup is successful. If the key lookup fails, answer the result of evaluating operation with no parameters.
The result is undefined if the key is nil.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('key' 'Object' #'uncaptured') #('operation' 'niladicValuable' #'uncaptured') )
	returnValues: #( #( 'ANY' #'unspecified') #( 'Object' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'at: key ifAbsentPut: operation'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Answer the element at key in the receiver. If key lookup for key fails, then store and return the result of evaluating operation.
'
	definedIn: 'abstractDictionary'
	definition: 'This message is the same as the #at: message if key lookup is successful. If the key lookup fails, the result of evaluating operation with no parameters is added at key and answered.
The result is undefined  if the key is nil.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('key' 'Object' #'unspecified') #('operation' 'niladicValuable' #'uncaptured') )
	returnValues: #( #( 'Object' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'at: newElement put: key'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Store newElement at key in the receiver. Answer newElement.
'
	definedIn: 'abstractDictionary'
	definition: 'If lookup succeeds for key, then newElement replaces the element previously stored at key. Otherwise, the newElement is stored at the new key. In either case, subsequent successful lookups for key will answer newElement.  Answer newElement.
The result is undefined if the key is nil.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElement' 'Object' #'captured') #('key' 'Object' #'unspecified') )
	returnValues: #( #( 'Object' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'collect: transformer'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Answer a new collection constructed by gathering the results of evaluating transformer with each element of the receiver.
'
	definedIn: 'collection'
	definition: 'For each element of the receiver, transformer is evaluated with the element as the parameter. The results of these evaluations are collected into a new collection.
The elements are traversed in the order specified by the #do: message for the receiver.
Unless specifically refined, this message is defined to answer an object conforming to the same protocol as the receiver.
'
	refinedIn: 'abstractDictionary'
	refinement: 'Answer a new instance of the receiver''s type with the same keys. For each key of the answer, a new element is obtained by evaluating transformer with the corresponding element of the receiver as the parameter.
'
	parameters: #( #('transformer' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'abstractDictionary' #'new') )
	errors: 'If the elements of the receiver are inappropriate for use as arguments to transformer.
If the result of evaluating the transformer does not conform to any element type restrictions of the collection to be returned.
'
!

ProtocolSpec newMessagePattern: 'includesKey: key'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Answer true if the receiver contains an element stored at key. Answer false otherwise.
'
	definedIn: 'abstractDictionary'
	definition: 'Answer true if the key lookup for the key succeeds. Answer false otherwise.
The result is undefined if the key is nil.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('key' 'Object' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'keyAtValue: value'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Answer a key such that the element stored at this key is equal to value. Answer nil if no such key is found.
'
	definedIn: 'abstractDictionary'
	definition: 'Answer an object such that key lookup with this object will answer an element in the receiver equivalent to value. Note that if there are multiple elements in the receiver that are equivalent to value, then the one whose key is answered is arbitrary.
The result is undefined if the receiver does not contain an element equivalent to value.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('value' 'Object' #'uncaptured') )
	returnValues: #( #( 'Object' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'keyAtValue: operation ifAbsent: value'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Answer a key such that the element stored at this key is equivalent to value. Answer the result of evaluating operation if no such key is found.
'
	definedIn: 'abstractDictionary'
	definition: 'Answer an object such that key lookup with this object will answer an element in the receiver equivalent to value. If no element equivalent to value is found, then the result of evaluating operation with no parameters is answered.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('value' 'Object' #'uncaptured') #('operation' 'niladicValuable' #'uncaptured') )
	returnValues: #( #( 'ANY' #'unspecified') #( 'Object' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'keys'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Answer a collection of keys at which there is an element stored in the receiver.
'
	definedIn: 'abstractDictionary'
	definition: 'Answer a collection of all the keys in the receiver.  The size of the result is equal to the size of the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'collection' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'keysAndValuesDo: operation'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Iteratively evaluate operation with each of the receiver''s keys and values.
'
	definedIn: 'abstractDictionary'
	definition: 'For each element in the receiver, operation is evaluated with the corresponding key as the first argument and the element as the second argument.
The order in which the elements are traversed is not specified. Each key is visited exactly once.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operation' 'dyadicValuable' #'uncaptured') )
	returnValues: #()
	errors: 'If any of the keys or values are not appropriate as an argument to operation.
'
!

ProtocolSpec newMessagePattern: 'keysDo: operation'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Iteratively evaluate operation with each of the receiver''s keys at which there are elements stored.
'
	definedIn: 'abstractDictionary'
	definition: 'For each key in the receiver, operation is evaluated with the key used as the parameter.
The order in which the elements are traversed is not specified. Each key is visited exactly once.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operation' 'monadicValuable' #'uncaptured') )
	returnValues: #()
	errors: 'If any of the keys are not appropriate as an argument to operation.
'
!

ProtocolSpec newMessagePattern: 'reject: discriminator'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Answer a new collection which excludes the elements in the receiver which cause discriminator to evaluate to true.
'
	definedIn: 'collection'
	definition: 'For each element of the receiver, discriminator is evaluated with the element as the parameter. Each element which causes discriminator to evaluate to false is added to the new collection.
The elements are traversed in the order specified by the #do: message for the receiver.
Unless specifically refined, this message is defined to answer an object conforming to the same protocol as the receiver.
'
	refinedIn: 'abstractDictionary'
	refinement: 'For each key of the receiver, discriminator is evaluated with the corresponding element as the parameter. If the element causes discriminator to evaluate to false, the key is added to the answer with the element as its corresponding value.
'
	parameters: #( #('discriminator' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'abstractDictionary' #'new') )
	errors: 'If the elements of the receiver are inappropriate for use as arguments to discriminator.
If discriminator evaluates to an object that does not conform to the protocol <boolean> for any element of the receiver.
'
!

ProtocolSpec newMessagePattern: 'removeAllKeys: keys'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Remove any elements from the receiver which are stored at the keys specified in keys.
'
	definedIn: 'abstractDictionary'
	definition: 'This message has the same effect on the receiver as repeatedly sending the #removeKey: message for each element in keys.
The result is undefined if duplicate keys, as defined by key equivalence, are in the keys or if any element in keys is not a valid key of the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('keys' 'collection' #'uncaptured') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'removeAllKeys: operation ifAbsent: keys'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Remove any elements from the receiver which are stored at the keys specified in keys. For any element in keys which is not a valid key of the receiver, evaluate operation with that element as the argument, but do not stop the enumeration.
'
	definedIn: 'abstractDictionary'
	definition: 'This message has the same effect on the receiver as repeatedly sending the #removeKey:ifAbsent: message for each element in keys. If any element in keys is not a valid key of the receiver, evaluate operation with that element as the parameter and continue the enumeration.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('keys' 'collection' #'uncaptured') #('operation' 'monadicValuable' #'uncaptured') )
	returnValues: #()
	errors: 'If any element of keys is not a valid key of the receiver and inappropriate for use as an argument to the operation.
'
!

ProtocolSpec newMessagePattern: 'removeKey: key'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Remove the element which is stored at key in the receiver. Answer the removed element.
'
	definedIn: 'abstractDictionary'
	definition: 'This message defines removal of a key from the receiver. If key lookup for key is successful, then both key and its corresponding element are removed. Answer the removed element.
The result is undefined if the receiver does not contain an element keyed by key.
The result is undefined if the key is nil.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('key' 'Object' #'uncaptured') )
	returnValues: #( #( 'Object' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'removeKey: operation ifAbsent: key'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Remove the element which is stored at key in the receiver and answer the removed element. Answer the result of evaluating operation if no such key is found in the receiver.
'
	definedIn: 'abstractDictionary'
	definition: 'If key lookup for key is successful, then both key and its corresponding element are removed. Answer the removed element.
If the key lookup fails, the result of evaluating operation with no parameters is answered.
The result is undefined if the key is nil.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operation' 'niladicValuable' #'uncaptured') #('key' 'Object' #'uncaptured') )
	returnValues: #( #( 'ANY' #'unspecified') #( 'Object' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'select: discriminator'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Answer a new collection which contains the elements in the receiver which cause discriminator to evaluate to true.
'
	definedIn: 'collection'
	definition: 'For each element of the receiver, discriminator is evaluated with the element as the parameter. Each element which causes discriminator to evaluate to true is added to the new collection.
The elements are traversed in the order specified by the #do: message for the receiver.
Unless specifically refined, this message is defined to answer an object conforming to the same protocol as the receiver.
'
	refinedIn: 'abstractDictionary'
	refinement: 'For each key of the receiver, discriminator is evaluated with the element as the parameter. If element causes discriminator to evaluate to true, the key is added to the answer with value element.
If discriminator evaluates to an object that does not conform to the protocol <boolean> for any element of the receiver.
'
	parameters: #( #('discriminator' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'abstractDictionary' #'new') )
	errors: 'If the elements of the receiver are inappropriate for use as arguments to discriminator.
'
!

ProtocolSpec newMessagePattern: 'values'
	forProtocolNamed: #'abstractDictionary'
	synopsis: 'Answer a collection of the receiver''s elements.
'
	definedIn: 'abstractDictionary'
	definition: 'Answer a collection of the receiver''s elements.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'sequencedReadableCollection' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Array'
	conformsToProtocolNames: #(#'sequencedCollection')
	) protocolDescription: '
Represents a keyed collection of objects which can be accessed externally using sequential integer keys. The index of the first element is one (1).
'
!

(ProtocolSpec newProtocolNamed: #'Array factory'
	conformsToProtocolNames: #(#'initializableCollection factory')
	) protocolDescription: '
This protocol defines the behavior of objects that can be used to create objects that conform to <Array>.  These objects are created with a specified size.  If element values are not explicitly provided they default to nil.
Standard Globals
Array	Conforms to the protocol <Array factory>. Its language element type is unspecified. This is a factory and discriminator for collections that conform to <Array>.
'
!

ProtocolSpec newMessagePattern: 'new'
	forProtocolNamed: #'Array factory'
	synopsis: 'Create a new object.
'
	definedIn: 'instantiator'
	definition: 'Return a newly created object initialized to a standard initial state.
'
	refinedIn: 'Array factory'
	refinement: 'Create a new  <Array> that contains no elements.
'
	parameters: #()
	returnValues: #( #( 'Array' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'new: count'
	forProtocolNamed: #'Array factory'
	synopsis: 'Create a new collection. The parameter count constrains the number of elements in the result.
'
	definedIn: 'collection factory'
	definition: 'Return a new collection that has space for at least count elements.
Conforming protocols may refine this message. In particular, the effect of the parameter count should be specified in refinements. It can be used to specify the exact number of elements, the minimum number, or in some cases can even be interpreted as a hint from the programmer, with no guarantee that the requested number of instance variables will actually be allocated.
Unless otherwise stated the initial values of elements of the new instance of the receiver are unspecified.
'
	refinedIn: 'Array factory'
	refinement: 'The parameter count specifies the size of the receiver. The initial value of each element of the new instance of the receiver is nil. The new collections conforms to the protocol <Array>.
'
	parameters: #( #('count' 'integer' #'unspecified') )
	returnValues: #( #( 'Array' #'new') )
	errors: 'count<0

'
!

ProtocolSpec newMessagePattern: 'with: element1'
	forProtocolNamed: #'Array factory'
	synopsis: 'Create a collection initially containing the argument element.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing one element.
Conforming protocols may impose restrictions on the value of the argument and hence the element type.
'
	refinedIn: 'Array factory'
	refinement: 'The first argument is at index position 1
'
	parameters: #( #('element1' 'Object' #'captured') )
	returnValues: #( #( 'Array' #'new') )
	errors: 'If the argument does not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element1 with: element2'
	forProtocolNamed: #'Array factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing two of elements. The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'Array factory'
	refinement: 'The first argument is at index position 1, the second argument is at index position 2.
'
	parameters: #( #('element1' 'Object' #'captured') #('element2' 'Object' #'captured') )
	returnValues: #( #( 'Array' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element1 with: element2 with: element3'
	forProtocolNamed: #'Array factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing three elements. The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'Array factory'
	refinement: 'The first argument is at index position 1, the second argument is at index position 2, and so on...
'
	parameters: #( #('element1' 'Object' #'captured') #('element2' 'Object' #'captured') #('element3' 'Object' #'captured') )
	returnValues: #( #( 'Array' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element4 with: element1 with: element3 with: element2'
	forProtocolNamed: #'Array factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing four elements. The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'Array factory'
	refinement: 'The first argument is at index position 1, the second argument is at index position 2, and so on...
'
	parameters: #( #('element3' 'Object' #'captured') #('element2' 'Object' #'captured') #('element4' 'Object' #'captured') #('element1' 'Object' #'captured') )
	returnValues: #( #( 'Array' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'withAll: newElements'
	forProtocolNamed: #'Array factory'
	synopsis: 'Create a collection containing only the elements of newElements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection whose elements are the elements of newElements.
Conforming protocols may impose restrictions on the values of newElements.
'
	refinedIn: 'Array factory'
	refinement: 'If the elements of newElements are ordered then their ordering establishing their index positions in the new collection.
'
	parameters: #( #('newElements' 'collection' #'unspecified') )
	returnValues: #( #( 'Array' #'new') )
	errors: 'If any of the elements of newElements do not meet the element type constraints of the result object

'
!

(ProtocolSpec newProtocolNamed: #'Bag'
	conformsToProtocolNames: #(#'extensibleCollection')
	) protocolDescription: '
Represents an unordered, variable sized collection whose elements can be added or removed, but cannot be individually accessed by external keys. A bag is similar to a set but can contain duplicate elements. Elements are duplicates if they are equivalent.
'
!

ProtocolSpec newMessagePattern: 'add: newElement'
	forProtocolNamed: #'Bag'
	synopsis: 'Add newElement to the receiver''s elements.
'
	definedIn: 'extensibleCollection'
	definition: 'This message adds a newElement to the receiver. Unless specifically refined, the position of the newElement in the element traversal order is unspecified.
Conformant protocols may place restrictions on the type of objects that are valid elements. Unless otherwise specified, any object is acceptable.
'
	refinedIn: 'Bag'
	refinement: 'The result is undefined if newElement is nil.
'
	parameters: #( #('newElement' 'Object' #'captured') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'add: newElement withOccurrences: count'
	forProtocolNamed: #'Bag'
	synopsis: 'Add newElement count times to the receiver''s elements.
'
	definedIn: 'Bag'
	definition: 'This message adds an element to the receiver multiple times. The operation is equivalent to adding newElement to the receiver count times using the #add: message with newElement as the parameter.
The result is undefined if newElement is nil.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElement' 'Object' #'captured') #('count' 'integer' #'unspecified') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'addAll: newElements'
	forProtocolNamed: #'Bag'
	synopsis: 'Add each element of newElements to the receiver''s elements.
'
	definedIn: 'extensibleCollection'
	definition: 'This message adds each element of newElements to the receiver.
The operation is equivalent to adding each element of newElements to the receiver using the #add: message with the element as the parameter. The newElements are traversed in the order specified by the #do: message for newElements.
'
	refinedIn: 'Bag'
	refinement: 'The result is undefined if newElements contains nil.
The traversal order is unspecified.
'
	parameters: #( #('newElements' 'collection' #'uncaptured') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'collect: transformer'
	forProtocolNamed: #'Bag'
	synopsis: 'Answer a new collection constructed by gathering the results of evaluating transformer with each element of the receiver.
'
	definedIn: 'collection'
	definition: 'For each element of the receiver, transformer is evaluated with the element as the parameter. The results of these evaluations are collected into a new collection.
The elements are traversed in the order specified by the #do: message for the receiver.
Unless specifically refined, this message is defined to answer an objects conforming to the same protocol as the receiver.
'
	refinedIn: 'Bag'
	refinement: 'The result is undefined if transformer evaluates to nil for any element of the receiver.
'
	parameters: #( #('transformer' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'Bag' #'new') )
	errors: 'If the elements of the receiver are inappropriate for use as arguments to transformer.
If the result of evaluating the transformer does not conform to any element type restrictions of the collection to be returned.







'
!

(ProtocolSpec newProtocolNamed: #'Bag factory'
	conformsToProtocolNames: #(#'initializableCollection factory')
	) protocolDescription: '
This protocol defines the behavior of objects that can be used to create objects that conform to the protocol <Bag>.
Standard Globals
Bag	Conforms to the protocol <Bag factory>. Its language element type is unspecified. This is a factory and discriminator for collections that conform to <Bag>.
'
!

ProtocolSpec newMessagePattern: 'new'
	forProtocolNamed: #'Bag factory'
	synopsis: 'Create a new object.
'
	definedIn: 'instantiator'
	definition: 'Return a newly created object initialized to a standard initial state.
'
	refinedIn: 'Bag factory'
	refinement: 'Return a new <Bag> that is optimized to store an implementation defined number of elements. The new collection initially contains no elements.
'
	parameters: #()
	returnValues: #( #( 'Bag' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'new: count'
	forProtocolNamed: #'Bag factory'
	synopsis: 'Create a new collection. The parameter count constrains the number of elements in the result.
'
	definedIn: 'collection factory'
	definition: 'Return a new collection that has space for at least count elements.
Conforming protocols may refine this message. In particular, the effect of the parameter count should be specified in refinements. It can be used to specify the exact number of elements, the minimum number, or in some cases can even be interpreted as a hint from the programmer, with no guarantee that the requested number of instance variables will actually be allocated.
Unless otherwise stated the initial values of elements of the new instance of the receiver are unspecified.
'
	refinedIn: 'Bag factory'
	refinement: 'The parameter count represents a hint to the implementation as to the likely number of elements that may be added to the new collection. The new collection initially contains no elements.
The new collections conforms to the protocol <Bag>.
'
	parameters: #( #('count' 'integer' #'unspecified') )
	returnValues: #( #( 'Bag' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'with: element1'
	forProtocolNamed: #'Bag factory'
	synopsis: 'Create a collection initially containing one element.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing one element. The collection contains the argument as its element.
Conforming protocols may impose restrictions on the values of the argument and hence the element type.
'
	refinedIn: 'Bag factory'
	refinement: 'The result is undefined if the argument is nil.
'
	parameters: #( #('element1' 'Object' #'captured') )
	returnValues: #( #( 'Bag' #'new') )
	errors: 'If the argument does not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element2 with: element1'
	forProtocolNamed: #'Bag factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing two elements. The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'Bag factory'
	refinement: 'The result is undefined if any of the arguments are nil.
'
	parameters: #( #('element2' 'Object' #'captured') #('element1' 'Object' #'captured') )
	returnValues: #( #( 'Bag' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element1 with: element2 with: element3'
	forProtocolNamed: #'Bag factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing three elements. The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'Bag factory'
	refinement: 'The result is undefined if any of the arguments are nil.
'
	parameters: #( #('element1' 'Object' #'captured') #('element2' 'Object' #'captured') #('element3' 'Object' #'captured') )
	returnValues: #( #( 'Bag' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element2 with: element4 with: element1 with: element3'
	forProtocolNamed: #'Bag factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing four elements.  The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'Bag factory'
	refinement: 'The result is undefined if any of the arguments are nil.
'
	parameters: #( #('element1' 'Object' #'captured') #('element3' 'Object' #'captured') #('element2' 'Object' #'captured') #('element4' 'Object' #'captured') )
	returnValues: #( #( 'Bag' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'withAll: newElements'
	forProtocolNamed: #'Bag factory'
	synopsis: 'Create a collection containing only the elements of newElements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection whose elements are the elements of newElements.
Conforming protocols may impose restrictions on the values of newElements.
'
	refinedIn: 'Bag factory'
	refinement: 'The result is unspecified if newElements contains nil.
'
	parameters: #( #('newElements' 'collection' #'unspecified') )
	returnValues: #( #( 'Bag' #'new') )
	errors: 'If any of the elements of newElements do not meet the element type constraints of the result object










'
!

(ProtocolSpec newProtocolNamed: #'boolean'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
This protocol describes the behavior of the objects that are the values of the reserved identifiers "true" and "false".  These objects are identity objects.
Several message specifications include a truth table describing the result of the binary operation implemented by that message. In each table, the value of the receiver is used to locate a row and the value of the argument is used to locate a column, the result being located at the intersection of the row and column.
'
!

ProtocolSpec newMessagePattern: '& operand'
	forProtocolNamed: #'boolean'
	synopsis: 'Logical and - Boolean conjunction.
'
	definedIn: 'boolean'
	definition: 'Return the Boolean conjunction of the receiver and operand. The value returned is determined by the following truth table:
&
true
false
true
true
false
false
false
false
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'boolean' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'and: operand'
	forProtocolNamed: #'boolean'
	synopsis: '"Short circuit" logical and.
'
	definedIn: 'boolean'
	definition: 'If the receiver is false, return false. Otherwise, return the <boolean> result of sending the message #value to operand.
The result is undefined if the result of sending #value to operand is not a <boolean>.
Rationale
Some existing implementations do not require that the operand must evaluate to a <boolean>. The message #ifTrue: should be used to conditionally evaluate a block that does not return a <boolean>.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'niladicBlock' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'eqv: operand'
	forProtocolNamed: #'boolean'
	synopsis: 'Boolean equivalence.
'
	definedIn: 'boolean'
	definition: 'Return the Boolean disjunction of the receiver and operand. The value returned is determined by the following truth table:

eqv:
true
false
true
true
false
false
false
true
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'boolean' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'ifFalse: operand'
	forProtocolNamed: #'boolean'
	synopsis: 'Evaluate the argument if receiver is false.
'
	definedIn: 'boolean'
	definition: 'If the receiver is false return the result of sending the message #value to operand.
The return value is unspecified if the receiver is true.
Rationale
Most existing implementations define the return value to be nil if the receiver is true. This definition is less precise and potentially allows for implementation specific optimization.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'niladicBlock' #'uncaptured') )
	returnValues: #( #( 'ANY' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'ifFalse: trueOperand ifTrue: falseOperand'
	forProtocolNamed: #'boolean'
	synopsis: 'Selectively evaluate one of the arguments.
'
	definedIn: 'boolean'
	definition: 'If the receiver is false return the result return the result as if the message #value was sent to falseOperand, otherwise return the result as if the message #value was sent to trueOperand.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('falseOperand' 'niladicBlock' #'uncaptured') #('trueOperand' 'niladicBlock' #'uncaptured') )
	returnValues: #( #( 'ANY' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'ifTrue: operand'
	forProtocolNamed: #'boolean'
	synopsis: 'Evaluate the argument if the receiver is true.
'
	definedIn: 'boolean'
	definition: 'If the receiver is true, return the result of sending the message #value to operand.
The return value is unspecified if the receiver is false.
Rationale
Most existing implementations define the return value to be nil if the receiver is false. This definition is less precise and potentially allows for implementation specific optimization.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'niladicBlock' #'uncaptured') )
	returnValues: #( #( 'ANY' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'ifTrue: trueOperand ifFalse: falseOperand'
	forProtocolNamed: #'boolean'
	synopsis: 'Selectively evaluate one of the arguments.
'
	definedIn: 'boolean'
	definition: 'If the receiver is true return the result of sending the message #value to trueOperand, otherwise return the result of sending #value to the falseOperand.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('trueOperand' 'niladicBlock' #'uncaptured') #('falseOperand' 'niladicBlock' #'uncaptured') )
	returnValues: #( #( 'ANY' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'not'
	forProtocolNamed: #'boolean'
	synopsis: 'Logical not - Boolean negation.
'
	definedIn: 'boolean'
	definition: 'Return the Boolean negation of the receiver.
If the receiver is true the return value is false, if the receiver is false the return value is true.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'or: operand'
	forProtocolNamed: #'boolean'
	synopsis: '"Short circuit" logical or.
'
	definedIn: 'boolean'
	definition: 'If the receiver is true, return true. Otherwise, return the Boolean result of sending the message #value to operand.
The result is undefined if the result of sending #value to operand is not a <boolean>.
Rationale
Some existing implementations do not require that the operand must evaluate to a <boolean>. The message #ifFalse: should be used to conditionally evaluate a block that does not return a Boolean.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'niladicValuable' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'printString'
	forProtocolNamed: #'boolean'
	synopsis: 'Return a string that describes the receiver.
'
	definedIn: 'Object'
	definition: 'A string consisting of a sequence of characters that describe the receiver are returned as the result.
The exact sequence of characters that describe an object are implementation defined.
'
	refinedIn: 'boolean'
	refinement: 'If the receiver is true, return a string with the same characters as the string ''true'', otherwise return a string with the same characters as the string ''false''.
'
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'xor: operand'
	forProtocolNamed: #'boolean'
	synopsis: 'Boolean exclusive or.
'
	definedIn: 'boolean'
	definition: 'Return the Boolean exclusive or of the receiver and operand. The value returned is determined by the following truth table:

xor:
true
false
true
false
true
false
true
false
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'boolean' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: '| operand'
	forProtocolNamed: #'boolean'
	synopsis: 'Logical or - Boolean disjunction.
'
	definedIn: 'boolean'
	definition: 'Return the Boolean disjunction of the receiver and operand. The value returned is determined by the following truth table:
|
true
false
true
true
true
false
true
false
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'boolean' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'ByteArray'
	conformsToProtocolNames: #(#'sequencedCollection')
	) protocolDescription: '
Represents a keyed collection whose element type is <integer> and is limited to the range 0 to 255, inclusive. The elements can be accessed externally using sequential integer keys. The index of the first element is one (1).
'
!

(ProtocolSpec newProtocolNamed: #'ByteArray factory'
	conformsToProtocolNames: #(#'initializableCollection factory')
	) protocolDescription: '
This protocol defines the behavior of objects that can be used to create objects that conform to <ByteArray>.  These objects are created with a specified size.  If the element values are not explicitly provided, they default to 0.
Standard Globals
ByteArray	Conforms to the protocol <ByteArray factory>. Its language element type is unspecified. This is a factory and discriminator for collections that conform to <ByteArray>.
'
!

ProtocolSpec newMessagePattern: 'new'
	forProtocolNamed: #'ByteArray factory'
	synopsis: 'Create a new object.
'
	definedIn: 'instantiator'
	definition: 'Return a newly created object initialized to a standard initial state.
'
	refinedIn: 'ByteArray factory'
	refinement: 'Create a new  <ByteArray> that contains no elements.
'
	parameters: #()
	returnValues: #( #( 'ByteArray' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'new: count'
	forProtocolNamed: #'ByteArray factory'
	synopsis: 'Create a new collection. The parameter count constrains the number of elements in the result.

'
	definedIn: 'collection factory'
	definition: 'Return a new collection that has space for at least count elements.
Conforming protocols may refine this message. In particular, the effect of the parameter count should be specified in refinements. It can be used to specify the exact number of elements, the minimum number, or in some cases can even be interpreted as a hint from the programmer, with no guarantee that the requested number of instance variables will actually be allocated.
Unless otherwise stated the initial values of elements of the new instance of the receiver are unspecified.
'
	refinedIn: 'ByteArray factory'
	refinement: 'The parameter count specifies the size of the receiver. The initial value of each element of the new instance of the receiver is 0. The new collections conforms to the protocol <ByteArray>.
'
	parameters: #( #('count' 'integer' #'unspecified') )
	returnValues: #( #( 'ByteArray' #'new') )
	errors: 'count<0

'
!

ProtocolSpec newMessagePattern: 'with: element1'
	forProtocolNamed: #'ByteArray factory'
	synopsis: 'Create a collection initially containing the argument element.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing one element.  The collection contains the argument as its elements.
Conforming protocols may impose restrictions on the value of the argument and hence the element type.
'
	refinedIn: 'ByteArray factory'
	refinement: 'The argument is at index position 1.
'
	parameters: #( #('element1' 'integer' #'captured') )
	returnValues: #( #( 'ByteArray' #'new') )
	errors: 'If the argument does not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element1 with: element2'
	forProtocolNamed: #'ByteArray factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing two elements. he collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'ByteArray factory'
	refinement: 'The first argument is at index position 1, the second argument is at index position 2.
'
	parameters: #( #('element1' 'integer' #'captured') #('element2' 'integer' #'captured') )
	returnValues: #( #( 'ByteArray' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element1 with: element3 with: element2'
	forProtocolNamed: #'ByteArray factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing three elements.  The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'ByteArray factory'
	refinement: 'The first argument is at index position 1, the second argument is at index position 2, and so on...
'
	parameters: #( #('element1' 'integer' #'captured') #('element3' 'integer' #'captured') #('element2' 'integer' #'captured') )
	returnValues: #( #( 'ByteArray' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element4 with: element2 with: element1 with: element3'
	forProtocolNamed: #'ByteArray factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing four elements.  The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'ByteArray factory'
	refinement: 'The first argument is at index position 1, the second argument is at index position 2, and so on...
'
	parameters: #( #('element1' 'integer' #'captured') #('element3' 'integer' #'captured') #('element4' 'integer' #'captured') #('element2' 'integer' #'captured') )
	returnValues: #( #( 'ByteArray' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'withAll: newElements'
	forProtocolNamed: #'ByteArray factory'
	synopsis: 'Create a collection containing only the elements of newElements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection whose elements are the elements of newElements.
Conforming protocols may impose restrictions on the values of newElements.
'
	refinedIn: 'ByteArray factory'
	refinement: 'If the elements of newElements are ordered then their ordering establishing their index positions in the new collection.
'
	parameters: #( #('newElements' 'collection' #'unspecified') )
	returnValues: #( #( 'ByteArray' #'new') )
	errors: 'If any of the elements of newElements do not meet the element type constraints of the result object







'
!

(ProtocolSpec newProtocolNamed: #'Character'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
This protocol describes the behavior that is common to character objects. Character objects serve as the element value for Smalltalk strings. The Smalltalk language provides a literal syntax for character objects. Character objects represent individual elements of an implementation defined execution character set whose individual elements are identified by integer values. These integers are called code points.  Each character object has an associated code point.
It is unspecified whether or not each code point is uniquely associated with a unique character object.
The execution character set is the character set used by an implementation during execution of a Smalltalk program.  It need not be the same as the character set used by that implementation to encode the definition of Smalltalk programs.
'
!

ProtocolSpec newMessagePattern: '= comparand'
	forProtocolNamed: #'Character'
	synopsis: 'Object equivalence test.
'
	definedIn: 'Object'
	definition: 'This message tests whether the receiver and the comparand are equivalent objects at the time the message is processed. Return true if the receiver is equivalent to comparand. Otherwise return false.
The meaning of "equivalent" cannot be precisely defined but the intent is that two objects are considered equivalent if they can be used interchangeably. Conforming protocols may choose to more precisely define the meaning of "equivalent".
The value of
receiver = comparand
is true if and only if the value of
comparand = receiver
would also be true. If the value of
receiver = comparand
is true then the receiver and comparand must have equivalent hash values. Or more formally:
receiver = comparand ?
receiver hash = comparand hash
The equivalence of objects need not be temporally invariant. Two independent invocations of #= with the same receiver and operand objects may not always yield the same results. Note that a collection that uses #= to discriminate objects may only reliably store objects whose hash values do not change while the objects are contained in the collection.
'
	refinedIn: 'Character'
	refinement: 'Two characters are considered equivalent if they have the same code point. In other words
character1 = character2
is true if and only if
character1 codePoint = character2 codePoint
is also true.
'
	parameters: #( #('comparand' 'Character' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asLowercase'
	forProtocolNamed: #'Character'
	synopsis: 'Return a character which is equivalent to the lowercase representation of the receiver.
'
	definedIn: 'Character'
	definition: 'If the receiver is equal to the value of a character literal in the "receiver" row of the following table, the result object must be equal to the value of the corresponding character literal in the "result" row.

receiver
$A
$B
$C
$D
$E
$F
$G
$H
$I
$J
$K
$L
$M
$N
$O
$P
$Q
$R
$S
$T
$U
$V
$W
$X
$Y
$Z
result
$a
$b
$c
$d
$e
$f
$g
$h
$i
$j
$k
$l
$m
$n
$o
$p
$q
$r
$s
$t
$u
$v
$w
$x
$y
$z

An implemention may define other #asLowercase mappings. If the receiver does not correspond to a character in the "receiver" row of the table and does not have an implementation defined mapping the receiver is returned as the result.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Character' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asString'
	forProtocolNamed: #'Character'
	synopsis: 'Return a new string whose sole element is equivalent to the receiver.
'
	definedIn: 'Character'
	definition: 'Return a new string of size one (1) whose sole element is equivalent to the receiver. The new string is created using the same constraints as defined by the #new: message defined in <String factory>. It is unspecified whether the resulting string captures a reference to the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'String' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asUppercase'
	forProtocolNamed: #'Character'
	synopsis: 'Return a character equivalent to the uppercase representation of the receiver.
'
	definedIn: 'Character'
	definition: 'If the receiver is equal to the value of a character literal in the "receiver" row of the following table, the result object must be equal to the value of the corresponding character literal in the "result" row.

receiver
$a
$b
$c
$d
$e
$f
$g
$h
$i
$j
$k
$l
$m
$n
$o
$p
$q
$r
$s
$t
$u
$v
$w
$x
$y
$z
result
$A
$B
$C
$D
$E
$F
$G
$H
$I
$J
$K
$L
$M
$N
$O
$P
$Q
$R
$S
$T
$U
$V
$W
$X
$Y
$Z

An implemention may define other #asUppercase mappings. If the receiver does not correspond to a character in the "receiver" row of the table and does not have an implementation defined mapping the receiver is returned as the result.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Character' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'codePoint'
	forProtocolNamed: #'Character'
	synopsis: 'Return the encoding value of the receiver.
'
	definedIn: 'Character'
	definition: 'Return the encoding value of the receiver in the implementation defined execution character set.
The following invariant must hold:
(charFactory codePoint: x) codePoint = x
where charFactory is an object that implements <Character factory> and x is an <integer>.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'isAlphaNumeric'
	forProtocolNamed: #'Character'
	synopsis: 'Test whether the receiver is a letter or digit.
'
	definedIn: 'Character'
	definition: 'Return true if the receiver is either a letter or digit. Otherwise return false. In other words
character isAlphaNumeric
is true if and only if either
character isLetter
is true or
character isDigit
is true.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'isDigit'
	forProtocolNamed: #'Character'
	synopsis: 'Test whether the receiver is a digit.
'
	definedIn: 'Character'
	definition: 'Return true if the receiver represents a digit. Otherwise return false. The receiver is a digit if it is equal to the value of one of the following character literals:
$0 $1 $2 $3 $4 $5 $6 $7 $8 $9
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'isLetter'
	forProtocolNamed: #'Character'
	synopsis: 'Test whether the receiver is a letter.
'
	definedIn: 'Character'
	definition: 'Return true if the receiver corresponds to an alphabetic character, ignoring case. Otherwise return false. The receiver is an alphabetic character if it is equal to the value of one of the following character literals:
$A $B $C $D $E $F $G $H $I $J $K $L $M
$N $O $P $Q $R $S $T $U $V $W $X $Y $Z
$a $b $c $d $e $f $g $h $i $j $k $l $m
$n $o $p $q $r $s $t $u $v $w $x $y $z
Implementations may define other characters to be alphabetic characters. Any such characters will return true when set this message.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'isLowercase'
	forProtocolNamed: #'Character'
	synopsis: 'Test whether the receiver is a lowercase letter.
'
	definedIn: 'Character'
	definition: 'Return true if the receiver corresponds to a lowercase letter. Otherwise return false. The receiver is an lowercase letter if it is equal to the value of one of the following character literals:
$a $b $c $d $e $f $g $h $i $j $k $l $m
$n $o $p $q $r $s $t $u $v $w $x $y $z
Implementations may define other characters to be lowercase characters. Any such characters will return true when set this message.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'isUppercase'
	forProtocolNamed: #'Character'
	synopsis: 'Test whether the receiver is an uppercase letter.
'
	definedIn: 'Character'
	definition: 'Return true if the receiver corresponds to a uppercase letter. Otherwise return false. The receiver is an uppercase letter if it is equal to the value of one of the following character literals:
$A $B $C $D $E $F $G $H $I $J $K $L $M
$N $O $P $Q $R $S $T $U $V $W $X $Y $Z
Implementations may define other characters to be lowercase characters. Any such characters will return true when set this message.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Character factory'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
This protocol describes the behavior for accessing character objects.
Standard Globals
Character	Conforms to the protocol <Object>. Its language element type is unspecified. This global is a factory for for creating or accessing objects that conform to <Character>.
'
!

ProtocolSpec newMessagePattern: 'codePoint: integer'
	forProtocolNamed: #'Character factory'
	synopsis: 'Return a character whose encoding value is integer.
'
	definedIn: 'Character factory'
	definition: 'Return a character whose encoding value in the implementation defined execution character set is integer.
The result is undefined if the encoding value is not a valid encoding value in the implementation defined character set.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('integer' 'integer' #'unspecified') )
	returnValues: #( #( 'Character' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'cr'
	forProtocolNamed: #'Character factory'
	synopsis: 'Return a character representing a carriage-return.
'
	definedIn: 'Character factory'
	definition: 'Return a character representing a carriage-return. The code point of the resulting character is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Character' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'lf'
	forProtocolNamed: #'Character factory'
	synopsis: 'Return a character representing a line feed.
'
	definedIn: 'Character factory'
	definition: 'Return a character representing a line feed. The code point of the resulting character is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Character' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'space'
	forProtocolNamed: #'Character factory'
	synopsis: 'Return a character representing a space.
'
	definedIn: 'Character factory'
	definition: 'Return a character representing a space. The code point of the resulting character is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Character' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'tab'
	forProtocolNamed: #'Character factory'
	synopsis: 'Return a character representing a tab.
'
	definedIn: 'Character factory'
	definition: 'Return a character representing a tab. The code point of the resulting character is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Character' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'classDescription'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
This protocol describes the behavior of class objects. It provides messages for identifying and locating class objects within the class hierarchy.
'
!

ProtocolSpec newMessagePattern: 'allSubclasses'
	forProtocolNamed: #'classDescription'
	synopsis: 'Return all subclasses of a class.
'
	definedIn: 'classDescription'
	definition: 'If the receiver is a class object, return a collection containing all of the class objects whose class definitions inherit either directly or indirectly from the class definition of the receiver.
If the receiver is not a class object, the result is unspecified.
Each element of the result collection supports the protocol <classDescription>. The order of class objects within the collection is unspecified.
<collection>	unspecified
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'allSuperclasses'
	forProtocolNamed: #'classDescription'
	synopsis: 'Return all superclasses of a class.
'
	definedIn: 'classDescription'
	definition: 'If the receiver is a class object, return a collection containing all of the class objects defined by the class definitions from which the class definition of the receiver inherits, either directly or indirectly. If the class definition of the receiver has no superclasses, return an empty collection.
If the receiver is not a class object, the result is unspecified.
Each element of the result collection supports the protocol <classDescription>. The order of class objects within the collection is unspecified.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'collection' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'name'
	forProtocolNamed: #'classDescription'
	synopsis: 'Return the name of a class.
'
	definedIn: 'classDescription'
	definition: 'Return a string containing the global name of the receiver. The global name of a class object is the global identifier that is bound to the class object.
Rationale
Some existing implementations may return a symbol as the result of this message. The specification of the return value should be whatever protocol is general enough to be either a string or a symbol.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'subclasses'
	forProtocolNamed: #'classDescription'
	synopsis: 'Return direct subclasses of a class.
'
	definedIn: 'classDescription'
	definition: 'If the receiver is a class object, return a collection containing all of the class objects whose class definitions inherit directly from the class definition of the receiver. If there are no class definitions that inherit from the class definition of the receiver, return an empty collection.
If the receiver is not a class object, the result is unspecified.
Each element of the result collection supports the protocol <classDescription>. The order of class objects within the collection is unspecified.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'collection' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'superclass'
	forProtocolNamed: #'classDescription'
	synopsis: 'Return the immediate superclass of a class.
'
	definedIn: 'classDescription'
	definition: 'If the receiver is a class object, return the class objects defined by the class definitions from which the class definition of the receiver directly inherits. If the class definition of the receiver has no superclasses, return nil.
If the receiver is not a class object, the result is unspecified.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'classDescription' #'unspecified') #( 'nil' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'collection'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
Provides protocol for manipulating and operating on a collection of objects, called elements, either individually or as a whole. A collection can be fixed or variable sized, ordered or unordered, and its elements may or may not be accessible by external keys.
Some implementations of collections may choose to use the hash values, as defined by either the message #hash or the message #identityHash, of either the elements of the collection or the keys by which those elements are accessed (if there are any). If the hash values of such objects are modified, the behavior of any message sent to such a collection is undefined until the message #rehash has been sent to the collection in order to restore the consistency of the collection.
Rationale
#rehash message was moved to Collection to avoid any pre-existing implementation assumptions about its use in the implementation of collection. Any collection concievable might use hashing and hence could need to be rehashed.
'
!

ProtocolSpec newMessagePattern: 'allSatisfy: discriminator'
	forProtocolNamed: #'collection'
	synopsis: 'Return true if the discriminator evaluates to true for every element of the receiver. Otherwise return false.
'
	definedIn: 'collection'
	definition: 'Return true if the discriminator evaluates to true for every element of the receiver. Return true if the receiver is empty. Otherwise return false.
It is unspecified whether the discriminator will be evaluated with every element of the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('discriminator' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: 'If the elements of the receiver are inappropriate for use as arguments to discriminator.
If discriminator evaluates to an object that does not conform to the protocol <boolean> for each element of the receiver.
'
!

ProtocolSpec newMessagePattern: 'anySatisfy: discriminator'
	forProtocolNamed: #'collection'
	synopsis: 'Return true if the discriminator evaluates to true for any element of the receiver. Otherwise return false.
'
	definedIn: 'collection'
	definition: 'Return true if the discriminator evaluates to true for any element of the receiver. Otherwise return false. Return false if the receiver is empty.
It is unspecified whether the discriminator will be evaluated with every element of the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('discriminator' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: 'If the elements of the receiver are inappropriate for use as arguments to discriminator.
If discriminator evaluates to an object that does not conform to the protocol <boolean> for any element of the receiver.
'
!

ProtocolSpec newMessagePattern: 'asArray'
	forProtocolNamed: #'collection'
	synopsis: 'Answer an array whose elements are the elements of the receiver.
'
	definedIn: 'collection'
	definition: 'Answer an array with the same elements as the receiver. The result has the same size as the receiver, as defined by the #size message.
If the receiver maintains an ordering for its elements, the order of those elements will be preserved in the result.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Array' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asBag'
	forProtocolNamed: #'collection'
	synopsis: 'Answer a bag with the same elements as the receiver.
'
	definedIn: 'collection'
	definition: 'Answer a bag with the same elements as the receiver.
The result is unspecified if the receiver contains nil.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Bag' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asByteArray'
	forProtocolNamed: #'collection'
	synopsis: 'Answer a byte array whose elements are the elements of the receiver.
'
	definedIn: 'collection'
	definition: 'Answer a byte array with the same elements as the receiver. The result has the same size as the receiver, as defined by the #size message.
If the receiver maintains an ordering for its elements, the order of those elements will be preserved in the result.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'ByteArray' #'unspecified') )
	errors: 'If any elements in the receiver are not integers with values between 0 and 255.
'
!

ProtocolSpec newMessagePattern: 'asOrderedCollection'
	forProtocolNamed: #'collection'
	synopsis: 'Answer an ordered collection whose elements are the elements of the receiver.
'
	definedIn: 'collection'
	definition: 'Answer a ordered collection with the same elements as the receiver. The result has the same size as the receiver, as defined by the #size message.
If the receiver maintains an ordering for its elements, the order of those elements will be preserved in the result.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'OrderedCollection' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asSet'
	forProtocolNamed: #'collection'
	synopsis: 'Answer a set with the same elements as the receiver.
'
	definedIn: 'collection'
	definition: 'Answer a set with the same elements as the receiver. Since sets do not store duplicate elements, the result may have fewer elements than the receiver.
The result is undefined if the receiver contains nil.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Set' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asSortedCollection'
	forProtocolNamed: #'collection'
	synopsis: 'Answer a sorted collection with the same elements as the receiver.
'
	definedIn: 'collection'
	definition: 'Answer a sorted collection with the same elements as the receiver. The default sort block is used.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'SortedCollection' #'unspecified') )
	errors: 'If any element of the receiver is not appropriate as a parameter to the default sort block.
'
!

ProtocolSpec newMessagePattern: 'asSortedCollection: sortBlock'
	forProtocolNamed: #'collection'
	synopsis: 'Answer a sorted collection with the same elements as the receiver. The parameter sortBlock is used as the sort block.
'
	definedIn: 'collection'
	definition: 'Answer a sorted collection with the same elements as the receiver. The parameter sortBlock is used as the sort block and must meet the requirements of a sort block as specified by <SortedCollection>.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('sortBlock' 'dyadicValuable' #'captured') )
	returnValues: #( #( 'SortedCollection' #'unspecified') )
	errors: 'If sortBlock does not meet the requirements for a sort block as specified by <SortedCollection>.
If any element of the receiver is not appropriate as a parameter to the sortBlock.
'
!

ProtocolSpec newMessagePattern: 'collect: transformer'
	forProtocolNamed: #'collection'
	synopsis: 'Answer a new collection constructed by gathering the results of evaluating transformer with each element of the receiver.
'
	definedIn: 'collection'
	definition: 'For each element of the receiver, transformer is evaluated with the element as the parameter. The results of these evaluations are collected into a new collection.
The elements are traversed in the same order as they would be if the message #do: had been sent to the receiver.
Unless specifically refined, this message is defined to answer an object conforming to the same protocol as the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('transformer' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'collection' #'new') )
	errors: 'If any element of the receiver is inappropriate for use as arguments to transformer.
If the result of evaluating the transformer does not conform to any element type restrictions of the collection to be returned.
'
!

ProtocolSpec newMessagePattern: 'detect: discriminator'
	forProtocolNamed: #'collection'
	synopsis: 'Return the first element of the receiver which causes discriminator to evaluate to true when the element is used as the argument.
'
	definedIn: 'collection'
	definition: 'Return the first element of the receiver for which the discriminator evaluates to true when given that element as an argument. The discriminator will only be evaluated until such an object is found or until all of the elements of the collection have been used as arguments. That is, there may be elements of the receiver that are never used as arguments to the discriminator.
The elements are traversed in the same order as they would be if the message #do: had been sent to the receiver.
The result is undefined if discriminator does not evaluate to true for any element.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('discriminator' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'Object' #'state') )
	errors: 'If the elements of the receiver are inappropriate for use as arguments to discriminator.
If discriminator evaluates to an object that does not conform to the protocol <boolean> for any element of the receiver.
'
!

ProtocolSpec newMessagePattern: 'detect: discriminator ifNone: exceptionHandler'
	forProtocolNamed: #'collection'
	synopsis: 'Return the first element of the receiver which causes discriminator to evaluate to true when used as the argument to the evaluation. Answer the result of evaluating exceptionHandler if no such element is found.
'
	definedIn: 'collection'
	definition: 'Return the first element of the receiver for which the discriminator evaluates to true when given that element as an argument. The discriminator will only be evaluated until such an object is found or until all of the elements of the collection have been used as arguments. That is, there may be elements of the receiver that are never used as arguments to the discriminator.
The elements are traversed in the same order as they would be if the message #do: had been sent to the receiver.
If no element causes discriminator to evaluate to true, answer the result of exceptionHandler value.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('exceptionHandler' 'niladicValuable' #'uncaptured') #('discriminator' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'Object' #'state') #( 'Object' #'unspecified') )
	errors: 'If the elements of the receiver are inappropriate for use as arguments to discriminator.
If discriminator evaluates to an object that does not conform to the protocol <boolean> for any element of the receiver.
'
!

ProtocolSpec newMessagePattern: 'do: operation'
	forProtocolNamed: #'collection'
	synopsis: 'Evaluate operation with each element of the receiver.
'
	definedIn: 'collection'
	definition: 'For each element of the receiver, operation is evaluated with the element as the parameter.
Unless specifically refined, the elements are not traversed in a particular order. Each element is visited exactly once. Conformant protocols may refine this message to specify a particular ordering.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operation' 'monadicValuable' #'uncaptured') )
	returnValues: #()
	errors: 'If the elements of the receiver are inappropriate for use as arguments to operation.
'
!

ProtocolSpec newMessagePattern: 'do: separator separatedBy: operation'
	forProtocolNamed: #'collection'
	synopsis: 'Evaluate operation with each element of the receiver interspersed by evaluation of separator.
'
	definedIn: 'collection'
	definition: 'For each element of the receiver, operation is evaluated with the element as the parameter. Before evaluating operation the second and subsequent times evaluate separator. Separator is not evaluated if there are less than two elements nor after the last element.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('separator' 'niladicValuable' #'uncaptured') #('operation' 'monadicValuable' #'uncaptured') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'includes: target'
	forProtocolNamed: #'collection'
	synopsis: 'Answer true if an element of the receiver is equivalent to target. Answer false otherwise.
'
	definedIn: 'collection'
	definition: 'This message is used to test an object for inclusion among the receiver''s elements. Answer true if at least one of the receiver''s elements is equivalent to target. Answer false otherwise.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('target' 'Object' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'inject: operation into: initialValue'
	forProtocolNamed: #'collection'
	synopsis: 'Answer the final result of evaluating operation using each element of the receiver and the previous evaluation result as the parameters.
'
	definedIn: 'collection'
	definition: 'The first evaluation of operation is performed with initialValue as the first parameter, and the first element of the receiver as the second parameter. Subsequent evaluations are done with the result of the previous evaluation as the first parameter, and the next element as the second parameter. The result of the last evaluation is answered.
The elements are traversed in the same order as they would be if the message #do: had been sent to the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('initialValue' 'Object' #'uncaptured') #('operation' 'dyadicValuable' #'uncaptured') )
	returnValues: #( #( 'Object' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'isEmpty'
	forProtocolNamed: #'collection'
	synopsis: 'Return true if the receiver contains no elements. Return false otherwise.
'
	definedIn: 'collection'
	definition: 'Return true if and only if
receiver size = 0
is true. Otherwise return false.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'notEmpty'
	forProtocolNamed: #'collection'
	synopsis: 'Return true if the receiver contains elements. Return false otherwise.
'
	definedIn: 'collection'
	definition: 'Return true if the receiver contains elements.  Return false otherwise.  This is equivalent to
receiver isEmpty not
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'occurrencesOf: target'
	forProtocolNamed: #'collection'
	synopsis: 'Answer the number of elements of the receiver which are equivalent to target.
'
	definedIn: 'collection'
	definition: 'Answer the number of elements of the receiver which are equivalent to target.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('target' 'Object' #'uncaptured') )
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'rehash'
	forProtocolNamed: #'collection'
	synopsis: 'Re-establish hash invariants, if any.
'
	definedIn: 'collection'
	definition: 'Re-establish any hash invariants of the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'reject: discriminator'
	forProtocolNamed: #'collection'
	synopsis: 'Answer a new collection which includes only the elements in the receiver which cause discriminator to evaluate to false.
'
	definedIn: 'collection'
	definition: 'For each element of the receiver, discriminator is evaluated with the element as the parameter. Each element which causes discriminator to evaluate to false is included in the new collection.
The elements are traversed in the same order as they would be if the message #do: had been sent to the receiver.
Unless specifically refined, this message is defined to answer an object conforming to the same protocol as the receiver. If both the receiver and the result maintain an ordering of their elements, the elements of the result will be in the same relative order as the elements of the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('discriminator' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'collection' #'new') )
	errors: 'If the elements of the receiver are inappropriate for use as arguments to discriminator.
If discriminator evaluates to an object that does not conform to the protocol <boolean> for any element of the receiver.
'
!

ProtocolSpec newMessagePattern: 'select: discriminator'
	forProtocolNamed: #'collection'
	synopsis: 'Answer a new collection which contains only the elements in the receiver which cause discriminator to evaluate to true.
'
	definedIn: 'collection'
	definition: 'For each element of the receiver, discriminator is evaluated with the element as the parameter. Each element which causes discriminator to evaluate to true is included in the new collection.
The elements are traversed in the same order as they would be if the message #do: had been sent to the receiver.
Unless specifically refined, this message is defined to answer an object conforming to the same protocol as the receiver. If both the receiver and the result maintain an ordering of their elements, the elements of the result will be in the same relative order as the elements of the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('discriminator' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'collection' #'new') )
	errors: 'If the elements of the receiver are inappropriate for use as arguments to discriminator.
If discriminator evaluates to an object that does not conform to the protocol <boolean> for any element of the receiver.
'
!

ProtocolSpec newMessagePattern: 'size'
	forProtocolNamed: #'collection'
	synopsis: 'Answer the number of elements in the receiver.
'
	definedIn: 'collection'
	definition: 'Answer the number of elements in the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'collection factory'
	conformsToProtocolNames: #(#'instantiator')
	) protocolDescription: '
Provides protocol for creating a collection of objects. A collection can be fixed or variable sized, ordered or unordered, and its elements may or may not be accessible by external keys.
'
!

ProtocolSpec newMessagePattern: 'new'
	forProtocolNamed: #'collection factory'
	synopsis: 'Create a new object.
'
	definedIn: 'instantiator'
	definition: 'Return a newly created object initialized to a standard initial state.
'
	refinedIn: 'collection factory'
	refinement: 'This message has the same effect as sending the message #new: with the argument 0.
'
	parameters: #()
	returnValues: #( #( 'collection' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'new: count'
	forProtocolNamed: #'collection factory'
	synopsis: 'Create a new collection. The parameter count constrains the number of elements in the result.
'
	definedIn: 'collection factory'
	definition: 'Return a new collection that has space for at least count elements.
Conforming protocols may refine this message. In particular, the effect of the parameter count should be specified in refinements. It can be used to specify the exact number of elements, the minimum number, or in some cases can even be interpreted as a hint from the programmer, with no guarantee that the requested number of instance variables will actually be allocated.
Unless otherwise stated the initial values of elements, if any, of the new collection are unspecified.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('count' 'integer' #'unspecified') )
	returnValues: #( #( 'collection' #'new') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'collectionStream'
	conformsToProtocolNames: #(#'sequencedStream')
	) protocolDescription: '
An object conforming to <collectionStream> has a <sequencedReadableCollection> as its stream backing store.
'
!

ProtocolSpec newMessagePattern: 'contents'
	forProtocolNamed: #'collectionStream'
	synopsis: 'Returns a collection containing the complete contents of the stream.
'
	definedIn: 'sequencedStream'
	definition: 'Returns a collection that contains the receiver''s past and future sequence values, in order. The size of the collection is the sum of the sizes of the past and future sequence values. 
'
	refinedIn: 'collectionStream'
	refinement: 'It is unspecified whether or not the returned collection is the same object as the backing store collection. However, if the returned collection is not the same object as the stream backing store collection then the class of the returned collection is the same class as would be returned if the message #select: was sent to the backing store collection. 
'
	parameters: #()
	returnValues: #( #( 'sequencedReadableCollection' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'DateAndTime'
	conformsToProtocolNames: #(#'magnitude')
	) protocolDescription: '
This protocol describes the behavior that is common to date time objects. Date time objects represent individual points in Coordinated Universal Time (UTC) as represented in an implementation defined local time.  
The exact properties of local times are unspecified. Local times may differ in their offset from UTC.  A given local time may have different offsets from UTC at different points in time.
All dates and times in the UTC local time are in the Gregorian calendar. Date times prior to the adoption of the Gregorian calendar are given in the retrospective astronomical Gregorian calendar. The year 1 B.C. is astronomical Gregorian year 0. The year 2 B.C. is astronomical Gregorian year -1. The year 1 A.D. is astronomical Gregorian year 1. The offset of the UTC local time is zero.
'
!

ProtocolSpec newMessagePattern: '+ operand'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the result of adding operand to the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer a <DateAndTime> that represents the UTC time that is operand after the receiver and whose local time is the same as the receiver''s. If operand is less than <Duration factory> #zero, the result is the <DateAndTime> that is that is the absolute value of operand before the receiver. 
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'Duration' #'uncaptured') )
	returnValues: #( #( 'DateAndTime' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: '- operand'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the result of adding operand to the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'If operand is a <DateAndTime>, answer a <Duration> whose value is the period of time between the operand and the receiver. If operand is a <DateAndTime> prior to the receiver then the result is a <Duration> less than <Duration factory> #zero. 
If operand is a <Duration>, answer a new <DateAndTime> which represents the UTC time that is operand before the receiver and whose local time is the same as the receiver''s. If operand is a duration less than <Duration factory> #zero then the result is a <DateAndTime> that is the absolute value of operand after the receiver. 
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'Duration DateAndTime' #'uncaptured') )
	returnValues: #( #( 'Duration' #'unspecified') #( 'DateAndTime' #'unspecified') )
	errors: 'none.
'
!

ProtocolSpec newMessagePattern: '< operand'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer true if the receiver is less than operand. Answer false otherwise.
'
	definedIn: 'magnitude'
	definition: 'Answer true if the receiver is less than operand with respect to the ordering defined for them. Answer false otherwise.
It is erroneous if the receiver and operand are not comparable.
The semantics of the natural ordering must be defined by refinement, which may also restrict the type of operand. 
'
	refinedIn: 'DateAndTime'
	refinement: 'Answer true if the UTC time represented by operand follows the UTC time represented by the receiver. Answer false otherwise.
If the offsets of the receiver and operand are the same then their order is determined by their lexical order in the sequence #year, #month, #day, #hour24, #minute, #second. If their offsets differ then result is the same as if receiver asUTC < operand asUTC were evaluated.
'
	parameters: #( #('operand' 'DateAndTime' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: '= comparand'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Object equivalence test.
'
	definedIn: 'Object'
	definition: 'This message tests whether the receiver and the comparand are equivalent objects at the time the message is processed. Return true if the receiver is equivalent to comparand. Otherwise return false.
The meaning of "equivalent" cannot be precisely defined but the intent is that two objects are considered equivalent if they can be used interchangeably. Conforming protocols may choose to more precisely define the meaning of "equivalent".
The value of
receiver = comparand
is true if and only if the value of
comparand = receiver
would also be true. If the value of
receiver = comparand
is true then the receiver and comparand must have equivalent hash values. Or more formally:
receiver = comparand ?
receiver hash = comparand hash
The equivalence of objects need not be temporally invariant. Two independent invocations of #= with the same receiver and operand objects may not always yield the same results. Note that a collection that uses #= to discriminate objects may only reliably store objects whose hash values do not change while the objects are contained in the collection.
'
	refinedIn: 'DateAndTime'
	refinement: 'Answer true if the comparand conforms to <DateAndTime> and if it represents the same UTC time as the receiver. Answer false otherwise.  The local times of the receiver and operand are ignored.
'
	parameters: #( #('comparand' 'Object' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: '> operand'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer true if the receiver is greater than operand. Answer false otherwise.
'
	definedIn: 'magnitude'
	definition: 'Answer true if the receiver is greater than operand with respect to the natural ordering. Answer false otherwise.
It is erroneous if the receiver and operand are not comparable.
The semantics of the natural ordering must be defined by refinement, which may also restrict the type of operand. 
'
	refinedIn: 'DateAndTime'
	refinement: 'Answer true if the UTC time represented by operand precedes the UTC time represented by the receiver. Answer false otherwise. 
If the offsets of the receiver and operand are the same then their order is determined by their lexical order in the sequence #year, #month, #day, #hour24, #minute, #second. If their offsets differ then result is the same as if receiver asUTC > operand asUTC were evaluated.
'
	parameters: #( #('operand' 'DateAndTime' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asLocal'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer a <DateAndTime> that represents the same UTC time as the receiver but in the local time specified by the implementation. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer a <DateAndTime> that represents the same UTC time as the receiver but in the local time specified by the implementation. 
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'DateAndTime' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asUTC'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer a <DateAndTime> that represents the same absolute time as the receiver but in the local time UTC. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer a <DateAndTime> that represents the same absolute time as the receiver but in the local time UTC.  The exact meaning of UTC local time is specified by the implementation. The UTC local time must use the Gregorian calendar. <DateAndTimes> representing UTC times prior to the adoption of the Gregorian calendar must use the retrospective astronomical Gregorian calendar. It is an invariant that 
	<DateAndTime> asUTC offset = Duration zero.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'DateAndTime' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'dayOfMonth'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the number of the day in the month in the local time of the receiver which includes the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer an <integer> between 1 and 31 inclusive representing the number of the day in the month, in the local time of the receiver, which includes the receiver. 
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'dayOfWeek'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the number of the day in the week, in the local time of the receiver, which includes the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer an <integer> between 1 and 7 inclusive representing the number of the day in the week, in the local time of the receiver, which includes the receiver. Sunday is 1, Monday is 2, and so on.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'dayOfWeekAbbreviation'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the abbreviation of the name, in the local time of the receiver, of the day of the week which includes the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer an <readableString>  which is the abbreviation of the name, in the local time of the receiver, of the day of the week which includes the receiver. 
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'dayOfWeekName'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the name, in the local time of the receiver, of the day of the week which includes the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer an <readableString> which is the name, in the local time of the receiver, of the day of the week which includes the receiver. 
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'dayOfYear'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the number of the day in the year, in the local time of the receiver, which includes the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer an <integer> between 1 and 366 inclusive representing the number of the day in the year, in the local time of the receiver, which includes the receiver. 
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'hour'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the number of the hour in the day, in the local time of the receiver, which includes the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer an <integer> between 0 and 23 inclusive representing the number of the hour in the day, in the local time of the receiver, which includes the receiver. It is implementation defined whether a given local time uses the 12-hour clock or the 24-hour clock, except that the UTC local time must use the 24-hour clock.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'hour12'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the hour in the day in the 12-hour clock of the local time of the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer an <integer> between 1 and 12 inclusive representing the hour in the day in the 12-hour clock of the local time of the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'hour24'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the hour in the day in the 24-hour clock of the local time of the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer an <integer> between 0 and 23 inclusive representing the hour in the day in the 24-hour clock of the local time of the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'isLeapYear'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Test for leap year. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer true if the year, which includes the receiver, in the local time of the receiver is a leap year, false otherwise. 
Two <DateAndTime> objects that are equal can give different results for #isLeapYear. Equality depends on their UTC time whereas #isLeapYear depends on their local time.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'meridianAbbreviation'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the abbreviation, in the local time of the receiver, of the name of the half of the day, which includes the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer a <readableString> that is the abbreviation, in the local time of the receiver, of the name of the half of the day, which includes the receiver. 
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'minute'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the minute of the hour in the local time of the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer an <integer> between 0 and 59 inclusive representing the minute of hour in the local time of the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'month'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the number of the month in the year, in the local time of the receiver, which includes the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer an <integer> between 1 and 12 inclusive representing the number of the month in the year, in the local time of the receiver, which includes the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'monthAbbreviation'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the abbreviation of the name of the month, in the local time of the receiver, which includes the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer a <readableString> that is the abbreviation of the name of the month, in the local time of the receiver, which includes the receiver. 
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'monthName'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the name of the month, in the local time of the receiver, which includes the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer a <readableString> that is the name of the month, in the local time of the receiver, which includes the receiver. 
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'offset'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the difference between the local time of the receiver and UTC at the time of the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer a <Duration> representing the difference between the local time of the receiver and UTC at the time of the receiver. 
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Duration' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'offset: offset'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer a <DateAndTime> equivalent to the receiver but with its local time being offset from UTC by offset. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer a <DateAndTime> equivalent to the receiver but with its local time being offset from UTC by offset.  The impact of this on any other local time property is unspecified.
Implementations may define a limit to the range of offset, but it must be at least
-12:00:00 to 12:00:00 inclusive.

It is an invariant that if x is a <Duration> in range then
	(<DateAndTime> offset: x) offset = x

'
	refinedIn: ''
	refinement: ''
	parameters: #( #('offset' 'Duration' #'unspecified') )
	returnValues: #( #( 'DateAndTime' #'unspecified') )
	errors: 'offset out of range
'
!

ProtocolSpec newMessagePattern: 'printString'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Return a string that describes the receiver.
'
	definedIn: 'Object'
	definition: 'A string consisting of a sequence of characters that describe the receiver are returned as the result.
The exact sequence of characters that describe an object are implementation defined. 
'
	refinedIn: 'DateAndTime'
	refinement: 'The returned string will represent the UTC time of the receiver offset from UTC by the offset of the receiver. All dates are in the astronomical Gregorian calendar. The result will be formatted as
-YYYY-MM-DDThh:mm:ss.s+ZZ:zz:z where
-	is the <Character> $- if the year is less than 0 otherwise it is the <Character> that is returned from the message #space sent to the standard global Character,
YYYY	is the year left zero filled to four places,
-	is the <Character> $-,
MM	is the month of the year left zero filled to two places,
-	is the <Character> $-,
DD	is the day of the month left zero filled to two places,
T	is the <Character> $T,
hh	is the hour in the 24-hour clock left zero filled to two places,
:	is the <Character> $:,
mm	is the minute left zero filled to two places,
:	is the <Character> $:,
ss	is the second left zero filled to two places,
.	is the <Character> $. and is present only if the fraction of a second is non-zero,
s	is the fraction of a second and is present only if non-zero,
+	is the <Character> $+ if the offset is greater than or equal to <Duration factory> #zero and the <Character> $- if it is less,
ZZ	is the hours of the offset left zero filled to two places, and
:	is the <Character> $:,
zz	is the minutes of the offset left zero filled to two places,
:	is the <Character> $: and is present only if the seconds of the offset is non-zero,
z	is the seconds of the offset including any fractional part and is present only if non-zero.
This format is based on ISO 8601 sections 5.3.3 and 5.4.1. 

Example: 8:33:14.321 PM EST January 5, 1200 B.C. 
	''-1199-01-05T20:33:14.321-05:00''
Example: 12 midnight UTC January 1,  2001 A.D. 
	'' 2001-01-01T00:00:00+00:00''
'
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'second'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the second of the minute of the local time of the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer a <number> greater than or equal to 0 and strictly less than 60 representing the second of the minute of the local time of the receiver. 
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'number' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'timeZoneAbbreviation'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the abbreviation of the name, in the local time of the receiver, of the time zone of the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer a  <readableString> that is the abbreviation of the name, in the local time of the receiver, of the time zone of the receiver. 
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'timeZoneName'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the name in the local time of the receiver of the time zone of the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer a  <readableString> that is the name in the local time of the receiver of the time zone of the receiver. 
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'year'
	forProtocolNamed: #'DateAndTime'
	synopsis: 'Answer the number of the year in the local time of the receiver which includes the receiver. 
'
	definedIn: 'DateAndTime'
	definition: 'Answer an<integer> the number of the year which includes the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'DateAndTime factory'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
Represents protocol for creating an abstraction for a particular day of the year.
Standard Globals
DateTime	Conforms to the protocol <DateAndTime factory>. Its language element type is unspecified.
'
!

ProtocolSpec newMessagePattern: 'clockPrecision'
	forProtocolNamed: #'DateAndTime factory'
	synopsis: 'Answer a <Duration> such that after that period of time passes, #now is guaranteed to give a different result. 
'
	definedIn: 'DateAndTime factory'
	definition: 'Answer a <Duration> such that after that period of time passes, #now is guaranteed to give a different result. Ideally implementations should answer the least such duration.
Return Value:
<Duration> unspecified
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'now'
	forProtocolNamed: #'DateAndTime factory'
	synopsis: 'Answer a <DateAndTime> representing the current date and time. 
'
	definedIn: 'DateAndTime factory'
	definition: 'Answer a <DateAndTime> representing the current date and time in the local time specified by the implementation. 
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'DateAndTime' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'year: hour day: dayOfYear hour: minute minute: second second: year'
	forProtocolNamed: #'DateAndTime factory'
	synopsis: 'Answer a <DateAndTime> which is the second second of the minute minute of the hour hour of the day dayOfYear of the year year of the astronomical Gregorian calendar in local time. 
'
	definedIn: 'DateAndTime factory'
	definition: 'Answer the least <DateAndTime> which is the second second of the minute minute of the hour hour of the day dayOfYear of the year year of the astronomical Gregorian calendar in the local time specified by the implementation. The second must be a <number> greater than or equal to 0 and strictly less than 60. The minute must be an <integer> between 0 and 59 inclusive. The hour must be an <integer> between 0 and 23 inclusive. The day must be an <integer> between 1 and 366 inclusive. An implementation may not impose any limits on the year other than those imposed on <integer> constants.

It is possible that the time specified does not exist in the local time specified by the implementation. If there is a time change such that the local time is set forward and the time specified is in the interregnum, then that time does not exist in the local time. For example if at 02:00 in California on April 26, 1997 there is a time change that sets local time forward one hour, then the local time 02:30  in California does not exist. Conversely if there is a time change that sets the locale time back there are times which are ambiguous. For example if instead of setting the local time forward from 02:00 to 03:00 it is set back to 01:00 the the local time 01:30 in California is ambiguious. The result is the least <DateAndTime> that conforms to the given parameters.

It is worth noting that the year 1 B.C. is year 0 in the astronomical Gregorian calendar. Similarly the year 2 B.C. is year -1 in the astronomical Gregorian calendar and so on. The year 1 A.D. is year 1 in the astronomical Gregorian calendar.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('year' 'integer' #'unspecified') #('dayOfYear' 'integer' #'unspecified') #('hour' 'integer' #'unspecified') #('minute' 'integer' #'unspecified') #('second' 'number' #'unspecified') )
	returnValues: #( #( 'DateAndTime' #'new') )
	errors: 'month is not between 1 and 12 inclusive.
dayOfYear greater than the number of days in the year year of the astronomical Gregorian calendar.
hour is not between 0 and 23 inclusive.
minute is not between 0 and 59 inclusive.
second is not greater than or equal to 0 and strictly less than 60.
the time specified does not exist.
'
!

ProtocolSpec newMessagePattern: 'year: minute day: hour hour: second minute: dayOfYear second: year offset: offset'
	forProtocolNamed: #'DateAndTime factory'
	synopsis: 'Answer a <DateAndTime> which is the second second of the minute minute of the hour hour of the day dayOfYear of the year year of the astronomical Gregorian calendar offset from UTC by offset. 
'
	definedIn: 'DateAndTime factory'
	definition: 'Answer the least <DateAndTime> which is the second second of the minute minute of the hour hour of the day dayOfYear of the year year of the astronomical Gregorian calendar in the local time of the locale locale. The second must be a <number> greater than or equal to 0 and strictly less than 60. The minute must be an <integer> between 0 and 59 inclusive. The hour must be an <integer> between 0 and 23 inclusive. The day must be an <integer> between 1 and 366 inclusive. An implementation may not impose any limits on the year other than those imposed on <integer> constants.

It is possible that the time specified does not exist in the local time defined by the implementation. If there is a time change such that the local time is set forward and the time specified is in the interregnum, then that time does not exist in the local time. For example if at 02:00 in California on April 26, 1997 there is a time change that sets local time forward one hour, then the local time 02:30  in California does not exist. Conversely if there is a time change that sets the locale time back there are times which are ambiguous. For example if instead of setting the local time forward from 02:00 to 03:00 it is set back to 01:00 the the local time 01:30 in California is ambiguious. The result is the least <DateAndTime> that conforms to the given parameters.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('second' 'number' #'unspecified') #('hour' 'integer' #'unspecified') #('offset' 'Duration' #'unspecified') #('year' 'integer' #'unspecified') #('dayOfYear' 'integer' #'unspecified') #('minute' 'integer' #'unspecified') )
	returnValues: #( #( 'DateAndTime' #'new') )
	errors: 'month is not between 1 and 12 inclusive.
dayOfYear greater than the number of days in the year year of the astronomical Gregorian calendar.
hour is not between 0 and 23 inclusive.
minute is not between 0 and 59 inclusive.
second is not greater than or equal to 0 and strictly less than the number of seconds in the minute specified.
'
!

ProtocolSpec newMessagePattern: 'year: hour month: second day: dayOfMonth hour: year minute: month second: minute'
	forProtocolNamed: #'DateAndTime factory'
	synopsis: 'Answer a <DateAndTime> which is the second second of the minute minute of the hour hour of the day dayOfMonth of the month month of the year year of the astronomical Gregorian calendar in local time. 
'
	definedIn: 'DateAndTime factory'
	definition: 'Answer the least <DateAndTime> which is the second second of the minute minute of the hour hour of the day dayOfMonth of the month month of the year year of the astronomical Gregorian calendar in the local time specified by the implementation. The second must be a <number> greater than or equal to 0 and strictly less than 60. The minute must be an <integer> between 0 and 59 inclusive. The hour must be an <integer> between 0 and 23 inclusive. The day must be an <integer> between 1 and 31 inclusive. The month must be an <integer> between 1 and 12 inclusive.  An implementation may not impose any limits on the year other than those imposed on <integer> constants.

It is possible that the time specified does not exist in the local time defined by the implementation. If there is a time change such that the local time is set forward and the time specified is in the interregnum, then that time does not exist in the local time. For example if at 02:00 in California on April 26, 1997 there is a time change that sets local time forward one hour, then the local time 02:30  in California does not exist. Conversely if there is a time change that sets the locale time back there are times which are ambiguous. For example if instead of setting the local time forward from 02:00 to 03:00 it is set back to 01:00 the the local time 01:30 in California is ambiguious. The result is the least <DateAndTime> that conforms to the given parameters.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('hour' 'integer' #'unspecified') #('second' 'number' #'unspecified') #('minute' 'integer' #'unspecified') #('month' 'integer' #'unspecified') #('dayOfMonth' 'integer' #'unspecified') #('year' 'integer' #'unspecified') )
	returnValues: #( #( 'DateAndTime' #'new') )
	errors: 'month is not between 1 and 12 inclusive.
dayOfMonth greater than the number of days in the month month of year year of the astronomical Gregorian calendar.
hour is not between 0 and 23 inclusive.
minute is not between 0 and 59 inclusive.
second is not greater than or equal to 0 and strictly less than 60.
the time specified does not exist.
'
!

ProtocolSpec newMessagePattern: 'year: hour month: minute day: month hour: second minute: offset second: dayOfMonth offset: year'
	forProtocolNamed: #'DateAndTime factory'
	synopsis: 'Answer a <DateAndTime> which is the second second of the minute minute of the hour hour of the day dayOfMonth of the month month of the year year of the astronomical Gregorian calendar offset from UTC by offset. 
'
	definedIn: 'DateAndTime factory'
	definition: 'Answer the least <DateAndTime> which is the second second of the minute minute of the hour hour of the day dayOfMonth of the month month of the year year of the astronomical Gregorian calendar offset from UTC by offset. The second must be a <number> greater than or equal to 0 and strictly less than 60. The minute must be an <integer> between 0 and 59 inclusive. The hour must be an <integer> between 0 and 23 inclusive. The day must be an <integer> between 1 and 31 inclusive. The month must be an <integer> between 1 and 12 inclusive. An implementation may not impose any limits on the year other than those imposed on <integer> constants.

It is possible that the time specified does not exist in the local time defined by the implementation. If there is a time change such that the local time is set forward and the time specified is in the interregnum, then that time does not exist in the local time. For example if at 02:00 in California on April 26, 1997 there is a time change that sets local time forward one hour, then the local time 02:30  in California does not exist. Conversely if there is a time change that sets the locale time back there are times which are ambiguous. For example if instead of setting the local time forward from 02:00 to 03:00 it is set back to 01:00 the the local time 01:30 in California is ambiguious. The result is the least <DateAndTime> that conforms to the given parameters.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('minute' 'integer' #'unspecified') #('hour' 'integer' #'unspecified') #('month' 'integer' #'unspecified') #('second' 'number' #'unspecified') #('offset' 'Duration' #'unspecified') #('dayOfMonth' 'integer' #'unspecified') #('year' 'integer' #'unspecified') )
	returnValues: #( #( 'DateAndTime' #'new') )
	errors: 'month is not between 1 and 12 inclusive.
dayOfMonth greater than the number of days in the month month of year year of the astronomical Gregorian calendar.
hour is not between 0 and 23 inclusive.
minute is not between 0 and 59 inclusive.
second is not greater than or equal to 0 and strictly less than 60.
'
!

(ProtocolSpec newProtocolNamed: #'Dictionary'
	conformsToProtocolNames: #(#'abstractDictionary')
	) protocolDescription: '
Represents an unordered collection whose elements can be accessed using an explicitly assigned external key. Key equivalence is defined as sending the #= message.
'
!

(ProtocolSpec newProtocolNamed: #'Dictionary factory'
	conformsToProtocolNames: #(#'collection factory')
	) protocolDescription: '
This protocol defines the behavior of objects that can be used to create objects that conform to the protocol <Dictionary>.
Standard Globals
Dictionary	Conforms to the protocol <Dictionary factory>. Its language element type is unspecified. This is a factory and discriminator for collections that conform to <Dictionary>.
'
!

ProtocolSpec newMessagePattern: 'new'
	forProtocolNamed: #'Dictionary factory'
	synopsis: 'Create a new object.
'
	definedIn: 'instantiator'
	definition: 'Return a newly created object initialized to a standard initial state.
'
	refinedIn: 'Dictionary factory'
	refinement: 'Return a new <Dictionary> that is optimized to store an implementation defined number of elements. The new collection initially contains no elements.
'
	parameters: #()
	returnValues: #( #( 'Dictionary' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'new: count'
	forProtocolNamed: #'Dictionary factory'
	synopsis: 'Create a new collection. The parameter count constrains the number of elements in the result.
'
	definedIn: 'collection factory'
	definition: 'Return a new collection that has space for at least count elements.
Conforming protocols may refine this message. In particular, the effect of the parameter count should be specified in refinements. It can be used to specify the exact number of elements, the minimum number, or in some cases can even be interpreted as a hint from the programmer, with no guarantee that the requested number of instance variables will actually be allocated.
Unless otherwise stated the initial values of elements of the new instance of the receiver are unspecified.
'
	refinedIn: 'Dictionary factory'
	refinement: 'The parameter count represents a hint for space allocation. The new collection is to optimized to contain count elements. The new collection initially contains no elements.
The new collection conforms to the protocol <Dictionary>.
'
	parameters: #( #('count' 'integer' #'unspecified') )
	returnValues: #( #( 'Dictionary' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'withAll: newElements'
	forProtocolNamed: #'Dictionary factory'
	synopsis: 'Create a collection containing all the elements of newElements.
'
	definedIn: 'Dictionary factory'
	definition: 'Return a new collection whose elements are the elements of newElements. The effect is the same as evaluating Dictionary new addAll: newElements; yourself.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElements' 'abstractDictionary' #'unspecified') )
	returnValues: #( #( 'Dictionary' #'new') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Duration'
	conformsToProtocolNames: #(#'magnitude')
	) protocolDescription: '
Represents a length of time.
'
!

ProtocolSpec newMessagePattern: '* operand'
	forProtocolNamed: #'Duration'
	synopsis: 'Answer the result of multiplying the receiver by operand.
'
	definedIn: 'Duration'
	definition: 'Answer a <Duration> that is the result of multiplying the receiver by operand.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'number' #'unspecified') )
	returnValues: #( #( 'Duration' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: '+ operand'
	forProtocolNamed: #'Duration'
	synopsis: 'Answer the result of adding operand to the receiver. 
'
	definedIn: 'Duration'
	definition: 'Answer a <Duration> whose value is the result of adding the receiver and operand. 
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'Duration' #'unspecified') )
	returnValues: #( #( 'Duration' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: '- operand'
	forProtocolNamed: #'Duration'
	synopsis: 'Answer the result of subtracting the operand from the receiver.
'
	definedIn: 'Duration'
	definition: 'Answer a <Duration> whose value is the result of subtracting operand from the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'Duration' #'unspecified') )
	returnValues: #( #( 'Duration' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: '/ operand'
	forProtocolNamed: #'Duration'
	synopsis: 'Answer the result of dividing the receiver by operand. 
'
	definedIn: 'Duration'
	definition: 'If operand is a <number> answer a new <Duration> whose value is the result of dividing the receiver by operand. If operand equals zero the ZeroDivide exception is signaled.

If operand is a <Duration> answer a <number> whose value is the result of dividing the receiver by operand. If operand is <Duration factory> #zero the ZeroDivide exception is signaled.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'Duration number' #'unspecified') )
	returnValues: #( #( 'number' #'unspecified') #( 'Duration' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: '< operand'
	forProtocolNamed: #'Duration'
	synopsis: 'Answer true if the receiver is less than operand. Answer false otherwise.
'
	definedIn: 'magnitude'
	definition: 'Answer true if the receiver is less than operand with respect to the ordering defined for them. Answer false otherwise.
It is erroneous if the receiver and operand are not comparable.
The semantics of the natural ordering must be defined by refinement, which may also restrict the type of operand. 
'
	refinedIn: 'Duration'
	refinement: 'Answer true if operand represents a <Duration> that is larger than the receiver. Answer false otherwise. 
'
	parameters: #( #('operand' 'Duration' #'unspecified') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: '= comparand'
	forProtocolNamed: #'Duration'
	synopsis: 'Object equivalence test.
'
	definedIn: 'Object'
	definition: 'This message tests whether the receiver and the comparand are equivalent objects at the time the message is processed. Return true if the receiver is equivalent to comparand. Otherwise return false.
The meaning of "equivalent" cannot be precisely defined but the intent is that two objects are considered equivalent if they can be used interchangeably. Conforming protocols may choose to more precisely define the meaning of "equivalent".
The value of
receiver = comparand
is true if and only if the value of
comparand = receiver
would also be true. If the value of
receiver = comparand
is true then the receiver and comparand must have equivalent hash values. Or more formally:
receiver = comparand ?
receiver hash = comparand hash
The equivalence of objects need not be temporally invariant. Two independent invocations of #= with the same receiver and operand objects may not always yield the same results. Note that a collection that uses #= to discriminate objects may only reliably store objects whose hash values do not change while the objects are contained in the collection.
'
	refinedIn: 'Duration'
	refinement: 'Answer true if the comparand is a <Duration> representing the same length of time as the receiver. Answer false otherwise. 
'
	parameters: #( #('comparand' 'Object' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: '> operand'
	forProtocolNamed: #'Duration'
	synopsis: 'Answer true if the receiver is greater than operand. Answer false otherwise.
'
	definedIn: 'magnitude'
	definition: 'Answer true if the receiver is greater than operand with respect to the natural ordering. Answer false otherwise.
It is erroneous if the receiver and operand are not comparable.
The semantics of the natural ordering must be defined by refinement, which may also restrict the type of operand. 
'
	refinedIn: 'Duration'
	refinement: 'Answer true if operand represents a <Duration> which is smaller than the receiver. Answer false otherwise. 
'
	parameters: #( #('operand' 'Duration' #'unspecified') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'abs'
	forProtocolNamed: #'Duration'
	synopsis: 'Answer the absolute value of the receiver. 
'
	definedIn: 'Duration'
	definition: 'If the receiver is greater than or equal to <Duration Factory> #zero answer a <Duration> which is equal to the receiver. Otherwise answer a <Duration> which has the same magnitude as the receiver but the opposite sign.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Duration' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asSeconds'
	forProtocolNamed: #'Duration'
	synopsis: 'Answer the total number of seconds in the length of time represented by the receiver. 
'
	definedIn: 'Duration'
	definition: 'Answer the total number of seconds in the length of time represented by the receiver including any fractional part of a second.  If the receiver is less than <Duration factory> #zero then the result will be less than 0.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'number' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'days'
	forProtocolNamed: #'Duration'
	synopsis: 'Answer the number of complete days in the receiver. 
'
	definedIn: 'Duration'
	definition: 'Answer the number of complete days in the receiver. If the receiver is less than <Duration factory> #zero then the result will be less than or equal to 0.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'hours'
	forProtocolNamed: #'Duration'
	synopsis: 'Answer the number of complete hours in the receiver. 
'
	definedIn: 'Duration'
	definition: 'Answer an <integer> between -23 and 23 inclusive that represents the number of complete hours in the receiver, after the number of complete days has been removed. If the receiver is less than <Duration factory> #zero then the result will be less than or equal to 0.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'minutes'
	forProtocolNamed: #'Duration'
	synopsis: 'Answer the number of complete minutes in the receiver. 
'
	definedIn: 'Duration'
	definition: 'Answer an <integer> between -59 and 59 inclusive that represents the number of complete minutes in the receiver, after the number of complete days and hours have been removed. If the receiver is less than <Duration factory> #zero then the result will be less than or equal to 0.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'negated'
	forProtocolNamed: #'Duration'
	synopsis: 'Answer the negation of the receiver. 
'
	definedIn: 'Duration'
	definition: 'Answer a <Duration> which is of the same magnitude but opposite sign as the receiver. 
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Duration' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'negative'
	forProtocolNamed: #'Duration'
	synopsis: 'Answer true if the receiver is less than <Duration factory> #zero.
'
	definedIn: 'Duration'
	definition: 'Answer true if the receiver is less than <Duration factory> #zero, false otherwise.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'positive'
	forProtocolNamed: #'Duration'
	synopsis: 'Answer true if the receiver is greater than or equal to <Duration factory> #zero.
'
	definedIn: 'Duration'
	definition: 'Answer true if the receiver is greater than or equal to the <Duration factory> #zero, false otherwise.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'printString'
	forProtocolNamed: #'Duration'
	synopsis: 'Return a string that describes the receiver.
'
	definedIn: 'Object'
	definition: 'A string consisting of a sequence of characters that describe the receiver are returned as the result.
The exact sequence of characters that describe an object is implementation defined.
'
	refinedIn: 'Duration'
	refinement: 'Answer a description of the receiver that is formatted as 
[-]D:HH:MM:SS[.S] where
 - 	is a minus sign if the receiver represents a length of time going from the future into the past,
D	is the number of complete days with leading zeros to fill one place,
HH	is the number of complete hours with leading zeros to fill two places,
MM	is the number of complete minutes with leading zeros to fill two places,
SS	is. the number of complete seconds with leading zeros to fill two places, and
.S	is the fractional part of the number of seconds, if any.
'
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'seconds'
	forProtocolNamed: #'Duration'
	synopsis: 'Answer the number of seconds in the receiver. 
'
	definedIn: 'Duration'
	definition: 'Answer a <number> strictly greater than -60 and strictly less than 60 that represents the number of seconds in the receiver, after the complete days, hours, and minutes have been removed. If the receiver is less than <Duration factory> #zero then the result will be less than or equal to 0.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'number' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Duration factory'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
Represents protocol for creating a particular length of time.
Standard Globals
Duration	Conforms to the protocol <Duration factory>. Its language element type is unspecified.
'
!

ProtocolSpec newMessagePattern: 'days: seconds hours: hours minutes: minutes seconds: days'
	forProtocolNamed: #'Duration factory'
	synopsis: 'Answer a <Duration> of the number of days, hours, minutes, and seconds. 
'
	definedIn: 'Duration factory'
	definition: 'Answer a <Duration> of the number of days, hours, minutes, and seconds. If any of the operands are negative, the result is smaller by that number of days, hours, minutes, or seconds as appropriate.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('days' 'integer' #'unspecified') #('seconds' 'number' #'unspecified') #('hours' 'integer' #'unspecified') #('minutes' 'integer' #'unspecified') )
	returnValues: #( #( 'Duration' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'seconds: seconds'
	forProtocolNamed: #'Duration factory'
	synopsis: 'Answer a <Duration> which is seconds in length 
'
	definedIn: 'Duration factory'
	definition: 'If seconds is negative, answer a <Duration> that is abs (seconds) less than <Duration factory> #zero. 
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('seconds' 'number' #'unspecified') )
	returnValues: #( #( 'Duration' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'zero'
	forProtocolNamed: #'Duration factory'
	synopsis: 'Answer a <Duration> of zero length. 
'
	definedIn: 'Duration factory'
	definition: 'Answer a <Duration> representing a length of no time. 
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Duration' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'dyadicValuable'
	conformsToProtocolNames: #(#'valuable')
	) protocolDescription: '
This protocol describes the behavior for objects supporting the #value:value: selector.
'
!

ProtocolSpec newMessagePattern: 'argumentCount'
	forProtocolNamed: #'dyadicValuable'
	synopsis: 'Answers the number of arguments needed to evaluate the receiver.
'
	definedIn: 'valuable'
	definition: 'The number of arguments needed to evaluate the receiver is returned.
'
	refinedIn: 'dyadicValuable'
	refinement: 'Returns 2.
'
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'value: argument1 value: argument2'
	forProtocolNamed: #'dyadicValuable'
	synopsis: 'Answers the value of the receiver when applied to the arguments.
'
	definedIn: 'dyadicValuable'
	definition: 'The receiver is evaluated as defined by the receiver.
Note that in the case that the receiver is a block, that the evaluation is defined by the language with argument1 bound to the block''s first argument, and argument2 bound to the block''s second argument.
The result is as defined by the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('argument1' 'ANY' #'unspecified') #('argument2' 'ANY' #'unspecified') )
	returnValues: #( #( 'ANY' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Error'
	conformsToProtocolNames: #(#'Exception')
	) protocolDescription: '
This protocol describes the behavior of instances of class Error. These are used to represent error conditions that prevent the normal continuation of processing. Actual error exceptions used by an application may be subclasses of this class.
As Error is explicitly specified  to be subclassable, conforming implementations must implement its behavior in a non-fragile manner.
'
!

ProtocolSpec newMessagePattern: 'defaultAction'
	forProtocolNamed: #'Error'
	synopsis: ''
	definedIn: 'exceptionDescription'
	definition: 'If the exception described by the receiver is signaled and the current exception environment does not contain a handler for the exception this method will be executed.
The exact behavior and result of this method is implementation defined.
'
	refinedIn: 'Error'
	refinement: 'The current computation is terminated. The cause of the error should be logged or reported to the user. If the program is operating in an interactive debugging environment the computation should be suspended and the debugger activated.
'
	parameters: #()
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'isResumable'
	forProtocolNamed: #'Error'
	synopsis: 'Determine whether an exception is resumable.
'
	definedIn: 'exceptionDescription'
	definition: 'This message is used to determine whether the receiver is a resumable exception. Answer true if the receiver is resumable. Answer false if the receiver is not resumable.
'
	refinedIn: 'Error'
	refinement: 'Answer false. Error exceptions by default are assumed to not be resumable. Subclasses may over-ride this definition for situations where it is appropriate for an error to be resumable.
'
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Error class'
	conformsToProtocolNames: #(#'Exception class')
	) protocolDescription: '
This protocol describe the behavior of the global Error. The value of the standard global Error is a class object that conforms to this protocol. The class Error is explicitly specified  to be subclassable in a standard conforming program. Conforming implementations must implement its behaviors in a non-fragile manner.
The signaled exceptions generated by this type of object conform to the protocol <Error>.
Standard Globals
Error	A class name. Conforms to the protocol <Error class>. Error must inherit (possibly indirectly) from the class Exception.  Instances of this class conform to the protocol <Error>.
'
!

ProtocolSpec newMessagePattern: 'new'
	forProtocolNamed: #'Error class'
	synopsis: ''
	definedIn: 'instantiator'
	definition: 'Return a newly created object initialized to a standard initial state.
'
	refinedIn: 'Error class'
	refinement: 'The object returned conforms to <Error>
'
	parameters: #()
	returnValues: #( #( 'Error' #'new') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Exception'
	conformsToProtocolNames: #(#'exceptionBuilder' #'signaledException')
	) protocolDescription: '
This protocol describes the behavior of instances of class Exception. Typically, actual exceptions used by an application will be either direct or indirect subclasses of this class. Exception combines the behavior of <exceptionBuilder> and <signaledException>.  Instances are used to both supplied inform before an exception is signaled and to pass the information to an exception handler.
As Exception is explicitly specified  to be subclassable, conforming implementations must implement its behavior in a non-fragile manner.
Rationale
Exception is an abstract class. It is the only true abstract class specified by the standard. It is included so as to provide a mechanism for the protable definition of new exception. Exceptions defined as subclasses of Exception will be portable to any conforming implementation..
'
!

(ProtocolSpec newProtocolNamed: #'Exception class'
	conformsToProtocolNames: #(#'exceptionInstantiator' #'classDescription')
	) protocolDescription: '
This protocol describe the behavior of class objects that are used to create, signal, and select exceptions that exist within a specialization hierarchy.
The value of the standard global Exception is a class object that conforms to this protocol. The class Exception is explicitly specified  to be subclassable. Conforming implementations must implement its behaviors in a non-fragile manner.
Standard Globals
Exception	A class name. Conforms to the protocol <Exception class>. Instances of this class conform to the protocol <Exception>.
'
!

ProtocolSpec newMessagePattern: 'handles: exception'
	forProtocolNamed: #'Exception class'
	synopsis: ''
	definedIn: 'exceptionSelector'
	definition: 'This message determines whether the exception handler associated with the receiver may be used to process the argument. Answer true if an associated handler should be used to process exception. Answer false if an associated handler may not be used to process the exception.
'
	refinedIn: 'Exception class'
	refinement: 'Return true if the class of exception is the receiver or a general subclass of the receiver.
This definition implies that subclasses of an exception class are considered to be subexceptions of the type of exception defined by their superclass. An exception handler that handles an exception class will also handle any exceptions that are instances of the exception class''s subclasses.
'
	parameters: #( #('exception' 'exceptionDescription' #'unspecified') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'new'
	forProtocolNamed: #'Exception class'
	synopsis: ''
	definedIn: 'instantiator'
	definition: 'Return a newly created object initialized to a standard initial state.
'
	refinedIn: 'Exception class'
	refinement: 'The object returned conforms to <Exception>
'
	parameters: #()
	returnValues: #( #( 'Exception' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'signal'
	forProtocolNamed: #'Exception class'
	synopsis: ''
	definedIn: 'exceptionSignaler'
	definition: 'Associated with the receiver is an <exceptionDescription> called the signaled exception. The current exception environment is searched for an exception handler whose exception selector matches the signaled exception. The search proceeds from the most recently created exception handler to the oldest exception handler.
A matching handler is defined to be one which would return true if the message #handles: was sent to its exception selector with the signaled exception as the argument.
If a matching handler is found, the exception action of the handler is evaluated in the exception environment that was current when the handler was created and the state of the current exception environment is preserved as the signaling environment.
The exception action is evaluated as if the message #value: were sent to it with a <signaledException> passed as its argument. The <signaledException> is derived from the signaled exception in an implementation dependent manner.
If the evaluation of the exception action returns normally (as if it had returned from the #value: message), the handler environment is restored and the value returned from the exception action is returned as the value of the #on:do: message that created the handler. Before returning, any active #ensure: or #ifCurtailed: termination blocks created during evaluation of the receiver of the #on:do: message are evaluated.
If a matching handler is not found when the exception environment is searched, the default action for the signaled exception is performed. This is accomplished as if the message #defaultAction were sent to the <signaledException>  object derived from the signaled exception. The #defaultAction method is executed in the context of the signaling environment. If the signaled exception is resumable the value returned from the #defaultAction method is returned as the value of the #signal message. If the signaled exception is not resumable the action taken upon completion of the #defaultAction method is implementation defined.
'
	refinedIn: 'Exception class'
	refinement: 'The exception signaled conforms to <Exception> with all of its <exceptionDescription> attributes set to their default values.
'
	parameters: #()
	returnValues: #( #( 'Object' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'exceptionBuilder'
	conformsToProtocolNames: #(#'exceptionDescription' #'exceptionSignaler')
	) protocolDescription: '
This protocol describes the messages that may be used to set the information about an occurrence of an exception. This information may be retrieved using <exceptionDescription>  protocol. If an object conforming to this protocol is signaled as an exception, any information set in that object using this protocol''s messages will also be available for retrival from the signaled exception  that is passed to a handler block.
'
!

ProtocolSpec newMessagePattern: 'messageText: signalerText'
	forProtocolNamed: #'exceptionBuilder'
	synopsis: 'Set an exception''s message text.
'
	definedIn: 'exceptionBuilder'
	definition: 'Set the signaler message text of the receiver. Subsequent sends of the message #messgeText to the receiver will return this value. Subseqent sends of of the message #messgeText to a signaled exception generated by sending the message #signal to the receiver of this message will also return this value.
Return the receiver as the result of the message.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('signalerText' 'readableString' #'captured') )
	returnValues: #( #( 'exceptionBuilder' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'exceptionDescription'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
This protocol describe the messages that may be used to obtain information about an occurrence of an exception.
'
!

ProtocolSpec newMessagePattern: 'defaultAction'
	forProtocolNamed: #'exceptionDescription'
	synopsis: 'The default action taken if the exception is signaled.
'
	definedIn: 'exceptionDescription'
	definition: 'If the exception described by the receiver is signaled and the current exception environment does not contain a handler for the exception this method will be executed.
The exact behavior and result of this method is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Object' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'description'
	forProtocolNamed: #'exceptionDescription'
	synopsis: 'Return a textual description of the exception.
'
	definedIn: 'exceptionDescription'
	definition: 'Return text that describes in a human readable form an occurrence of an exception. If an explicit message text was provided by the signaler of the exception, that text should be incorporated into the description.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'isResumable'
	forProtocolNamed: #'exceptionDescription'
	synopsis: 'Determine whether an exception is resumable.
'
	definedIn: 'exceptionDescription'
	definition: 'This message is used to determine whether the receiver is a resumable exception. Answer true if the receiver is resumable. Answer false if the receiver is not resumable.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'messageText'
	forProtocolNamed: #'exceptionDescription'
	synopsis: 'Return an exception''s message text.
'
	definedIn: 'exceptionDescription'
	definition: 'Return the signaler message text of the receiver. If the signaler has not provided any message text, return nil.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') #( 'nil' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'tag'
	forProtocolNamed: #'exceptionDescription'
	synopsis: 'Return an exception''s tag value.
'
	definedIn: 'exceptionDescription'
	definition: 'Return the tag value provided by the signaler of the receiver. If the signaler has not provided a tag value, return the same value was would be returned as if #message Text was sent to the receiver of this message. If the signaler has provided neither a tag value nor a message text, return nil.
Exception tags are intended for use in situations where a particular occurrence of an exception needs to be identified and a textual description is not appropriate. For example, the message text might vary according to the locale and thus could not be used to identify the exception.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'nil' #'unspecified') #( 'Object' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'exceptionInstantiator'
	conformsToProtocolNames: #(#'exceptionSignaler' #'exceptionSelector' #'instantiator')
	) protocolDescription: '
This protocol describes the instantiation behavior of objects that can create exceptions.
'
!

ProtocolSpec newMessagePattern: 'new'
	forProtocolNamed: #'exceptionInstantiator'
	synopsis: 'Create a new object.
'
	definedIn: 'instantiator'
	definition: 'Return a newly created object initialized to a standard initial state.
'
	refinedIn: 'exceptionInstantiator'
	refinement: 'The object returned is an <exceptionBuilder> that may be used to signal an exception of the same type that would be signaled if the message #signal is sent to the receiver.
'
	parameters: #()
	returnValues: #( #( 'exceptionBuilder' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'signal'
	forProtocolNamed: #'exceptionInstantiator'
	synopsis: 'Signal the occurrence on an exceptional condition.
'
	definedIn: 'exceptionSignaler'
	definition: 'Associated with the receiver is an <exceptionDescription> called the signaled exception. The current exception environment is searched for an exception handler whose exception selector matches the signaled exception. The search proceeds from the most recently created exception handler to the oldest exception handler.
A matching handler is defined to be one which would return true if the message #handles: was sent to its exception selector with the signaled exception as the argument.
If a matching handler is found, the exception action of the handler is evaluated in the exception environment that was current when the handler was created and the state of the current exception environment is preserved as the signaling environment.
The exception action is evaluated as if the message #value: were sent to it with a <signaledException> passed as its argument. The <signaledException> is derived from the signaled exception in an implementation dependent manner.
If the evaluation of the exception action returns normally (as if it had returned from the #value: message), the handler environment is restored and the value returned from the exception action is returned as the value of the #on:do: message that created the handler. Before returning, any active #ensure: or #ifCurtailed: termination blocks created during evaluation of the receiver of the #on:do: message are evaluated.
If a matching handler is not found when the exception environment is searched, the default action for the signaled exception is performed. This is accomplished as if the message #defaultAction were sent to the <signaledException>  object derived from the signaled exception. The #defaultAction method is executed in the context of the signaling environment. If the signaled exception is resumable the value returned from the #defaultAction method is returned as the value of the #signal message. If the signaled exception is not resumable the action taken upon completion of the #defaultAction method is implementation defined.
'
	refinedIn: 'exceptionInstantiator'
	refinement: 'An exception of the type associated with the receiver is signaled. The <signaledException> is initialized to its default state.
'
	parameters: #()
	returnValues: #( #( 'Object' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'exceptionSelector'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
This protocol describe the behavior of objects that are used to select an exception handler. In particular, objects that conform to this protocol may occur as the first argument to #on:do: message sent to blocks.
'
!

ProtocolSpec newMessagePattern: ', anotherException'
	forProtocolNamed: #'exceptionSelector'
	synopsis: 'Create an exception set.
'
	definedIn: 'exceptionSelector'
	definition: 'Return an exception set that contains the receiver and the argument exception. This is commonly used to specify a set of exception selectors for an exception handler.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('anotherException' 'exceptionSelector' #'captured') )
	returnValues: #( #( 'exceptionSet' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'handles: exception'
	forProtocolNamed: #'exceptionSelector'
	synopsis: 'Determine whether an exception handler will accept a signaled exception.
'
	definedIn: 'exceptionSelector'
	definition: 'This message determines whether the exception handler associated with the receiver may be used to process the argument. Answer true if an associated handler should be used to process exception. Answer false if an associated handler may not be used to process the exception.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('exception' 'exceptionDescription' #'unspecified') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'exceptionSet'
	conformsToProtocolNames: #(#'exceptionSelector')
	) protocolDescription: '
This protocol describes the behavior of objects that may be used to group a set of <exceptionSelector> objects into a single <exceptionSelector>. This is useful for establishing a single exception handler that may deal with several different types of exceptions.
'
!

ProtocolSpec newMessagePattern: ', anotherException'
	forProtocolNamed: #'exceptionSet'
	synopsis: ''
	definedIn: 'exceptionSelector'
	definition: 'Return an exception set that contains the receiver and the argument exception. This is commonly used to specify a set of exception selectors for an exception handler.
'
	refinedIn: 'exceptionSet'
	refinement: 'In addition to anotherException the exception set that is returned contains all of theexception selectors contained in the receiver.
The returned object may or may not be the same object as the receiver.
'
	parameters: #( #('anotherException' 'exceptionSelector' #'captured') )
	returnValues: #( #( 'exceptionSet' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'exceptionSignaler'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
This protocol describes the behavior of signaling an exceptional condition, locating an exception handler, and executing an exception action.

'
!

ProtocolSpec newMessagePattern: 'signal'
	forProtocolNamed: #'exceptionSignaler'
	synopsis: 'Signal the occurrence of an exceptional condition.
'
	definedIn: 'exceptionSignaler'
	definition: 'Associated with the receiver is an <exceptionDescription> called the signaled exception. The current exception environment is searched for an exception handler whose exception selector matches the signaled exception. The search proceeds from the most recently created exception handler to the oldest exception handler.
A matching handler is defined to be one which would return true if the message #handles: was sent to its exception selector with the signaled exception as the argument.
If a matching handler is found, the exception action of the handler is evaluated in the exception environment that was current when the handler was created and the state of the current exception environment is preserved as the signaling environment.
The exception action is evaluated as if the message #value: were sent to it with a <signaledException> passed as its argument. The <signaledException> is derived from the signaled exception in an implementation dependent manner.
If the evaluation of the exception action returns normally (as if it had returned from the #value: message), the handler environment is restored and the value returned from the exception action is returned as the value of the #on:do: message that created the handler. Before returning, any active #ensure: or #ifCurtailed: termination blocks created during evaluation of the receiver of the #on:do: message are evaluated.
If a matching handler is not found when the exception environment is searched, the default action for the signaled exception is performed. This is accomplished as if the message #defaultAction were sent to the <signaledException>  object derived from the signaled exception. The #defaultAction method is executed in the context of the signaling environment. If the signaled exception is resumable the value returned from the #defaultAction method is returned as the value of the #signal message. If the signaled exception is not resumable the action taken upon completion of the #defaultAction method is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Object' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'signal: signalerText'
	forProtocolNamed: #'exceptionSignaler'
	synopsis: 'Signal the occurrence of an exceptional condition with a specified textual description.
'
	definedIn: 'exceptionSignaler'
	definition: 'Associated with the receiver is an <exceptionDescription> called the signaled exception. The message text of the signaled exception is set to the value of signalerText, and then the exception is signaled in the same manner as if the message #signal had been sent to the receiver.
Note that this message does not return in some circumstances. The situations in which it does return and the returned value, if any, are the same as specified for the #signal message.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('signalerText' 'readableString' #'unspecified') )
	returnValues: #( #( 'Object' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'extensibleCollection'
	conformsToProtocolNames: #(#'collection')
	) protocolDescription: '
Provides protocol for adding elements to and removing elements from a variable sized collection.
'
!

ProtocolSpec newMessagePattern: 'add: newElement'
	forProtocolNamed: #'extensibleCollection'
	synopsis: 'Add newElement to the receiver''s elements.
'
	definedIn: 'extensibleCollection'
	definition: 'This message adds a newElement to the receiver. Unless specifically refined, the position of the newElement in the element traversal order is unspecified.
Conformant protocols may place restrictions on the type of objects that are valid elements. Unless otherwise specified, any object is acceptable.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElement' 'Object' #'captured') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'addAll: newElements'
	forProtocolNamed: #'extensibleCollection'
	synopsis: 'Add each element of newElements to the receiver''s elements.
'
	definedIn: 'extensibleCollection'
	definition: 'This message adds each element of newElements to the receiver.
The operation is equivalent to adding each element of newElements to the receiver using the #add: message with the element as the parameter. The newElements are traversed in the order specified by the #do: message for newElements.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElements' 'collection' #'unspecified') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'remove: oldElement'
	forProtocolNamed: #'extensibleCollection'
	synopsis: 'Remove the first element of the receiver which is equivalent to oldElement and return the removed element.
'
	definedIn: 'extensibleCollection'
	definition: 'Remove the first element of the receiver which is equivalent to oldElement and return the removed element.
The elements are tested in the same order in which they would be enumerated by the message #do: for this receiver.
The behavior is undefined if an object equivalent to oldElement is not found.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('oldElement' 'Object' #'uncaptured') )
	returnValues: #( #( 'Object' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'remove: oldElement ifAbsent: exceptionHandler'
	forProtocolNamed: #'extensibleCollection'
	synopsis: 'Remove the first element of the receiver which is equivalent to oldElement. If it is not found, answer the result of evaluating exceptionHandler.
'
	definedIn: 'extensibleCollection'
	definition: 'The first element of the receiver which is equivalent to oldElement is removed from the receiver''s elements. If no such element is found, answer the result of evaluating exceptionHandler with no parameters.
The elements are tested in the same order in which they would be enumerated by the message #do: for this receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('oldElement' 'Object' #'uncaptured') #('exceptionHandler' 'niladicValuable' #'uncaptured') )
	returnValues: #( #( 'Object' #'state') #( 'Object' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'removeAll: oldElements'
	forProtocolNamed: #'extensibleCollection'
	synopsis: 'For each element in oldElements, remove the first element from the receiver which is equivalent to this element.
'
	definedIn: 'extensibleCollection'
	definition: 'This message is used to remove each element of a given collection from the receiver''s elements. The operation is defined to be equivalent to removing each element of oldElements from the receiver using the #remove: message with the element as the parameter.
The behavior is undefined if any element of oldElements is not found.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('oldElements' 'collection' #'uncaptured') )
	returnValues: #()
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'failedMessage'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
This protocol describes the behavior of objects that represent a message that was sent to an object, but was not understood by that object.
'
!

ProtocolSpec newMessagePattern: 'arguments'
	forProtocolNamed: #'failedMessage'
	synopsis: 'Answer the arguments of the message that could not be sent.
'
	definedIn: 'failedMessage'
	definition: 'Return a collection containing the arguments of the message that could not be sent. The elements of the collection are ordered, from the first element to the last element, in the same order as the arguments of the message, from left to right. If the message had no arguments, the collection will be empty.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'sequencedReadableCollection' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'selector'
	forProtocolNamed: #'failedMessage'
	synopsis: 'Answer the selector of the message that could not be sent.
'
	definedIn: 'failedMessage'
	definition: 'Answer the selector of the message that could not be sent.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'selector' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'FileStream'
	conformsToProtocolNames: #(#'sequencedStream')
	) protocolDescription: '
Provides protocol for streams over external files. The external file serves as the stream backing store. When objects are read or written from a file stream they must be translated from or two an external data representation. File streams have an external stream type that is specified when the stream is created. The external stream type defines the data translation and the sequence value type for the stream. External stream types are specified using <symbol> objects. The standard defines the following external stream types:
#''binary''	The external data is treated as sequence of 8-bit bytes. The sequence value type is <integer> with values restricted to the range 0 to 255.
#''text'' 	The external data is treated as a sequenced of 8-bit characters encoded using an implementation defined external character set.  The sequence value type is <Character> restricted to those specific characters that may be represented in the external character set.
Implementations may define other external stream types.

Rational
The file stream capability specified in the standard was motivated by the desire to support a useful, yet minimal set of functionality and to take as a guide (i.e. subset) the Posix standard.
There is specification only for the creation and use of readable and writeable file streams. There is not support for read/write file streams. Nor is there any specification of file or directory manipulation, as these facilities are considered by the Committee to be too platform-dependent and too implementation-dependent to standardize at this time, and it is felt that streaming is adequate.
In addition, we only support the most common subset of the Posix file stream creation modes, rather than the full set.
We also considered the tradeoffs of specifying a wide range of creation messages, but decided that one fully-functional message and one most-typical creation message for each of read and write file streams would be adequate. Implementations are not prohibited from providing more options.
'
!

ProtocolSpec newMessagePattern: 'contents'
	forProtocolNamed: #'FileStream'
	synopsis: 'Returns a collection containing the complete contents of the stream.
'
	definedIn: 'sequencedStream'
	definition: 'Returns a collection that contains the receiver''s past and future sequence values, in order. The size of the collection is the sum of the sizes of the past and future sequence values.
'
	refinedIn: 'FileStream'
	refinement: 'If the external stream type is #''binary'' the returned collection conforms to <ByteArray>. If the external stream type is #''text'' the returned collection conforms to <String>.
'
	parameters: #()
	returnValues: #( #( 'String' #'new') #( 'ByteArray' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'externalType'
	forProtocolNamed: #'FileStream'
	synopsis: 'Returns a symbol that identifies the external stream type of the receiver.
'
	definedIn: 'FileStream'
	definition: 'Return the symbol that identifies the external stream type of the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'symbol' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'isBinary'
	forProtocolNamed: #'FileStream'
	synopsis: 'Answer wthether the receiver''s data is binary.
'
	definedIn: 'FileStream'
	definition: 'Answer true if the sequence value type conforms to <integer>. Otherwise answer false.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'isText'
	forProtocolNamed: #'FileStream'
	synopsis: 'Answer whether the receiver''s data is characters.
'
	definedIn: 'FileStream'
	definition: 'Answer true if the sequence value type conforms to <Character>. Otherwise answer false.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'FileStream factory'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
<FileStream factory> provides for the creation of objects conforming to the <readFileStream> or <writeFileStream> protocols.
Standard Globals
FileStream	Conforms to the protocol <FileStream factory>. Its program element type is unspecified. This is a factory for collections that conform to <readFileStream> and <writeFileStream>.
'
!

ProtocolSpec newMessagePattern: 'read: aString'
	forProtocolNamed: #'FileStream factory'
	synopsis: 'Returns a read file stream that reads text from the file with the given name.
'
	definedIn: 'FileStream factory'
	definition: 'The result is the same as if the message #read:type: was sent to the receiver with fileId as the first argument and the symbol #''text'' as the second argument.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('aString' 'String' #'unspecified') )
	returnValues: #( #( 'readFileStream' #'new') )
	errors: 'As defined by <FileStream factory> #read:type:
'
!

ProtocolSpec newMessagePattern: 'read: fileType type: fileId'
	forProtocolNamed: #'FileStream factory'
	synopsis: 'Returns a read file stream that reads from the file with the given name.
'
	definedIn: 'FileStream factory'
	definition: 'Locate an external file that is identified by the value of fileID. The syntax of the fileID string is implementation defined.
Return an object conforming to <readFileStream> whose future sequence values initially consist of the elements of the external file and which initially has no past sequence values. The ordering of the sequence values is the same as the ordering within the external file. The external file serves as the stream backing store of the returned object. The value of fileType determines the external stream type and sequence value type of the result object.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('fileId' 'readableString' #'unspecified') #('fileType' 'symbol' #'unspecified') )
	returnValues: #( #( 'readFileStream' #'new') )
	errors: 'It is an error if the file does not exist, or if the user does not have read access to the file.
'
!

ProtocolSpec newMessagePattern: 'write: fileId'
	forProtocolNamed: #'FileStream factory'
	synopsis: 'Returns a write file stream that writes text to the file with the given name.
'
	definedIn: 'FileStream factory'
	definition: 'The result is the same as if the message #write:mode:check:type: was sent to the receiver with fileId as the first argument, #''create'' as the second argument, false as the third argument, and the symbol #''text'' as the fourth argument.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('fileId' 'readableString' #'unspecified') )
	returnValues: #( #( 'writeFileStream' #'new') )
	errors: 'As defined by <FileStream factory> #write:mode:check:type:
'
!

ProtocolSpec newMessagePattern: 'write: mode mode: fileId'
	forProtocolNamed: #'FileStream factory'
	synopsis: 'Returns a write file stream that writes text to the file with the given name.
'
	definedIn: 'FileStream factory'
	definition: 'The result is the same as if the message #write:mode:check:type: was sent to the receiver with fileId as the first argument, mode as the second argument, false as the third argument, and the symbol #''text'' as the fourth argument.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('mode' 'symbol' #'unspecified') #('fileId' 'readableString' #'unspecified') )
	returnValues: #( #( 'writeFileStream' #'new') )
	errors: 'As defined by <FileStream factory> #write:mode:check:type:
'
!

ProtocolSpec newMessagePattern: 'write: fileType mode: fileID check: mode type: check'
	forProtocolNamed: #'FileStream factory'
	synopsis: 'Returns a write file stream that writes to the file with the given name.
'
	definedIn: 'FileStream factory'
	definition: 'Depending upon the values of check and mode, either create a new external file or locate an existing external file that is identified by the value of fileID. The syntax of the fileID string is implementation defined.
Return an object conforming to <writeFileStream>. The external file serves as the stream backing store of the returned object. The returned object is a write-back stream. The value of fileType determines the external stream type and sequence value type of the result object. 
Valid values for mode are: #''create'', #''append'', and #''truncate''. The meaning of these values are:
#''create'' 		create a new file, with initial position at the beginning
#''append''		use an existing file, with initial position at its end
#''truncate''		use an existing file, initially truncating it.
The value of mode determines the initial state of the past sequence values and future sequence values of the result object. If mode is #''create'' or #''truncate'' the past sequence values and future sequence values are both initially empty. If mode is #''append'' the past sequence values initially consist of the elements of the external file and future sequence values is initially empty. The ordering of the sequence values is the same as the ordering within the external file.
The check flag determines whether the file specified by fileID must exist or not exist.
If mode = #''create'' and check = false and the file exists, then the existing file is used.
If mode = #''append'' and check = false and the file does not exist, then it is created.
If mode = #''truncate'' and check = false and the file does not exist, then it is created. 
This operation is undefined if a value other than #''create'', #''append'' or #''truncate'' is used as the mode argument.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('mode' 'symbol' #'unspecified') #('check' 'boolean' #'unspecified') #('fileID' 'readableString' #'unspecified') #('fileType' 'symbol' #'unspecified') )
	returnValues: #( #( 'writeFileStream' #'new') )
	errors: 'If mode = #create and check = true and the file exists.
If mode = #append and check = true and the file does not exist.
If mode = #truncate and check = true and the file does not exist.
If the user does not have write permissions for the file.
If the user does not have creation permissions for a file that is to be created.





	
'
!

(ProtocolSpec newProtocolNamed: #'Float'
	conformsToProtocolNames: #(#'number')
	) protocolDescription: '
Represents a floating point representation for real numbers, whose value may be approximate. Provides protocol for performing trigonometry, exponentiation, and conversion on numerical quantities. 
Operations can produce results that are outside the set of representable numbers, or that are mathematically undefined. It is implementation defined whether errors are raised when results are not representable or if unrepresentable results are wrapped in implementation-defined continuation values or their equivalent. The effect of underflow and overflow is therefore implementation defined. It is erroneous if the result of an operation is mathematically undefined.
'
!

ProtocolSpec newMessagePattern: '= comparand'
	forProtocolNamed: #'Float'
	synopsis: 'Object equivalence test.
'
	definedIn: 'Object'
	definition: 'This message tests whether the receiver and the comparand are equivalent objects at the time the message is processed. Return true if the receiver is equivalent to comparand. Otherwise return false.
The meaning of "equivalent" cannot be precisely defined but the intent is that two objects are considered equivalent if they can be used interchangeably. Conforming protocols may choose to more precisely define the meaning of "equivalent".
The value of
receiver = comparand
is true if and only if the value of
comparand = receiver
would also be true. If the value of
receiver = comparand
is true then the receiver and comparand must have equivalent hash values. Or more formally:
receiver = comparand ?
receiver hash = comparand hash
The equivalence of objects need not be temporally invariant. Two independent invocations of #= with the same receiver and operand objects may not always yield the same results. Note that a collection that uses #= to discriminate objects may only reliably store objects whose hash values do not change while the objects are contained in the collection.
'
	refinedIn: 'Float'
	refinement: 'Answer true if the operand is a number which represents the same floating point number as the receiver, as specified by the ISO/IEC 10967 operation eqf. If the comparand and the receiver do not conform to the same protocol, they are converted according to the Default Conversion Table.
'
	parameters: #( #('comparand' 'Object' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'arcCos'
	forProtocolNamed: #'Float'
	synopsis: '
Answer the inverse cosine of the receiver in radians.
'
	definedIn: 'Float'
	definition: 'Answer the inverse cosine of the receiver in radians, as specified by the ISO/IEC 10967 trigonometric operation arccosf. Within the limits of precision, the following invariant holds:
receiver arcCos cos = receiver
It is erroneous if the absolute value of the receiver is greater than 1.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: '|receiver|  > 1
'
!

ProtocolSpec newMessagePattern: 'arcSin'
	forProtocolNamed: #'Float'
	synopsis: 'Answer the inverse sine of the receiver in radians.
'
	definedIn: 'Float'
	definition: 'Answer the inverse sine of the receiver in radians, as specified by the ISO/IEC 10967 trigonometric operation arcsinf. Within the limits of precision, the following invariant holds:
receiver arcSin sin = receiver
It is erroneous if the absolute value of the receiver is greater than 1.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: '|receiver|  > 1
'
!

ProtocolSpec newMessagePattern: 'arcTan'
	forProtocolNamed: #'Float'
	synopsis: 'Answer the inverse tangent of the receiver in radians.
'
	definedIn: 'Float'
	definition: 'Answer the inverse tangent of the receiver in radians, as specified by the ISO/IEC 10967 trigonometric operation arctanf. Within the limits of precision, the following invariant holds:
receiver arcTan tan = receiver
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'cos'
	forProtocolNamed: #'Float'
	synopsis: 'Answer the cosine of the receiver in radians.
'
	definedIn: 'Float'
	definition: 'Answer a <Float> equal to the cosine of the receiver in radians, as specified by the ISO/IEC 10967 trigonometric operation cosf.
The effect of underflow is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'degreesToRadians'
	forProtocolNamed: #'Float'
	synopsis: 'Answer the receiver converted from degrees to radians.
'
	definedIn: 'Float'
	definition: 'Answer a floating-point number representing the receiver converted from degrees to radians. The result is equivalent to multiplying the receiver by (Pi / 180).
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'exp'
	forProtocolNamed: #'Float'
	synopsis: 'Answer the natural exponential of the receiver. This is the inverse of #ln.
'
	definedIn: 'Float'
	definition: 'Answer a floating-point number representing the irrational number e (= 2.718281...) raised to the power of the receiver, as specified by the ISO/IEC 10967 operation expf. This is the inverse of the #ln message.
The effect of underflow and overflow is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'floorLog: operand'
	forProtocolNamed: #'Float'
	synopsis: 'Answer the largest integer less than or equal to the logarithm to the base operand of the receiver.
'
	definedIn: 'Float'
	definition: 'Answer the largest integer less than or equal to the power to which the operand must be raised to obtain the receiver (that is, the logarithm base operand of the receiver).
The result is undefined if the receiver is less than or equal to zero, or if the operand is less than or equal to 1.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'number' #'uncaptured') )
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'ln'
	forProtocolNamed: #'Float'
	synopsis: 'Answer the natural logarithm of the receiver.
'
	definedIn: 'Float'
	definition: 'Answer the natural logarithm of the receiver, as specified by the ISO/IEC 10967 operation lnf., which is a floating-point number representing the power to which the irrational number e (= 2.718281...) must be raised to obtain the receiver. This is the inverse of the #exp message.
The result is undefined if the receiver is less than or equal to zero.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'log: operand'
	forProtocolNamed: #'Float'
	synopsis: 'Answer the logarithm to the base operand of the receiver.
'
	definedIn: 'Float'
	definition: 'Answer the logarithm to the base operand of the receiver, as specified by the ISO/IEC 10967 operation logff, which is a floating-point number representing the power to which operand must be raised to obtain the receiver. The receiver must be positive, and operand must be greater than one. This is the inverse of the #raisedTo: message.
The result is undefined if operand equals 1, if operand is less than or equal to zero, or if the receiver is less than or equal to zero. The effect of underflow and overflow is implementation defined.

'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'number' #'uncaptured') )
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'printString'
	forProtocolNamed: #'Float'
	synopsis: 'Return a string that describes the receiver.
'
	definedIn: 'Object'
	definition: 'A string consisting of a sequence of characters that describe the receiver are returned as the result.
The exact sequence of characters that describe an object are implementation defined.
'
	refinedIn: 'Float'
	refinement: 'Answer a string which is a valid Smalltalk literal representation approximately equal to the receiver. An exponent literal form is produced if the value of the exponent is greater than the precision of the receiver.
'
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'radiansToDegrees'
	forProtocolNamed: #'Float'
	synopsis: 'Answer the receiver converted from radians to degrees.
'
	definedIn: 'Float'
	definition: 'Answer a floating-point number representing the receiver converted from radians to degrees. The result is equivalent to multiplying the receiver by (180 / Pi).
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'sin'
	forProtocolNamed: #'Float'
	synopsis: 'Answer the sine of the receiver.
'
	definedIn: 'Float'
	definition: 'Answer a floating-point number equal to the sine of the receiver in radians, as specified by the ISO/IEC 10967 trigonometric operation sinF.
The effect of underflow is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'tan'
	forProtocolNamed: #'Float'
	synopsis: 'Answer the tangent of the receiver.
'
	definedIn: 'Float'
	definition: 'Answer a floating-point number equal to the tangent of the receiver in radians, as specified by the ISO/IEC 10967 trigonometric root operation tanf.
The effect of underflow and overflow is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'floatCharacterization'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
Objects supporting this protocol characterize a floating point representation for real numbers. These characterizations are required by ISO/IEC 10967 for each precision of floating point numbers provided by an implementation.
Standard Globals
Float	Conforms to the protocol <floatCharacterization>. Its language element type is implementation defined. The value of this global is equivalent to the value of one of the globals: FloatE, FloatE, or FloatE.
FloatE	Conforms to the protocol <floatCharacterization>. Its language element type is implementation defined. This global characterizes the floating point representation corresponding to the ''e'' floating point literal syntax.
FloatD	Conforms to the protocol <floatCharacterization>. Its language element type is implementation defined. This global characterizes the floating point representation corresponding to the ''d'' floating point literal syntax.
FloatQ	Conforms to the protocol <floatCharacterization>. Its language element type is implementation defined. This global characterizes the floating point representation corresponding to the ''q'' floating point literal syntax.
'
!

ProtocolSpec newMessagePattern: 'denormalized'
	forProtocolNamed: #'floatCharacterization'
	synopsis: 'Indication of whether the characterized floating point object representation allows denormalized values.
'
	definedIn: 'floatCharacterization'
	definition: 'Report a boolean indicating whether the characterized floating point object representation contains denormalized values. This satisfies the ISO/IEC 10967 floating point characterization requirement denorm.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'e'
	forProtocolNamed: #'floatCharacterization'
	synopsis: 'The closest floating point approximation of the irrational number e.
'
	definedIn: 'floatCharacterization'
	definition: 'Return the closest floating point approximation of the irrational number e for the characterized floating point object representation.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'emax'
	forProtocolNamed: #'floatCharacterization'
	synopsis: 'The largest exponent of the characterized floating point object representation.
'
	definedIn: 'floatCharacterization'
	definition: 'Report the largest exponent allowed by the characterized floating point object representation, providing the upper bound of the range of representable floating point numbers. This satisfies the ISO/IEC 10967 floating point characterization requirement emax.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'emin'
	forProtocolNamed: #'floatCharacterization'
	synopsis: 'The smallest exponent of the characterized floating point object representation.
'
	definedIn: 'floatCharacterization'
	definition: 'Report the smallest exponent allowed by the characterized floating point object representation, providing the lower bound of the range of representable floating point numbers. This satisfies the ISO/IEC 10967 floating point characterization requirement emin.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'epsilon'
	forProtocolNamed: #'floatCharacterization'
	synopsis: 'The maximum relative spacing in the characterized floating point object representation.
'
	definedIn: 'floatCharacterization'
	definition: 'Report the maximum relative spacing in the characterized floating point object representation, satisfying the ISO/IEC 10967 floating point characterization requirement epsilon. The return value is equal to
self radix raisedTo: (1 - self precision)
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'fmax'
	forProtocolNamed: #'floatCharacterization'
	synopsis: 'The largest value allowed by the characterized floating point object representation.
'
	definedIn: 'floatCharacterization'
	definition: 'Report the largest value allowed by the characterized floating point object representation. This satisfies the ISO/IEC 10967 floating point characterization requirement fmax, and is equal to
(1 - (self radix raisedTo: self precision negated)) * self radix raisedTo: self emax
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'fmin'
	forProtocolNamed: #'floatCharacterization'
	synopsis: 'The minimum value allowed by the characterized floating point object representation.
'
	definedIn: 'floatCharacterization'
	definition: 'Report the minimum value allowed by the characterized floating point object representation. This satisfies the ISO/IEC 10967 floating point characterization requirement fmin. If the described representation contains normalized values, then the result is equal to the result of sending #fminNormalized to the receiver, otherwise the result is equal to the result of sending #fminDenormalized to the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'fminDenormalized'
	forProtocolNamed: #'floatCharacterization'
	synopsis: 'The minimum denormalized value allowed by the characterized floating point object representation.
'
	definedIn: 'floatCharacterization'
	definition: 'Report the minimum denormalized value allowed by the characterized floating point object representation. This satisfies the ISO/IEC 10967 floating point characterization requirement fminD, and is equal to
self radix raisedTo: (self emin - self precision)
The result is unspecified if denormalized values are not allowed by the characterized representation.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'fminNormalized'
	forProtocolNamed: #'floatCharacterization'
	synopsis: 'The minimum normalized value allowed by the characterized floating point object representation.
'
	definedIn: 'floatCharacterization'
	definition: 'Report the minimum normalized value allowed by the characterized floating point object representation. This satisfies the ISO/IEC 10967 floating point characterization requirement fminN, and is equal to
self radix raisedTo: (self emin - 1).
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'pi'
	forProtocolNamed: #'floatCharacterization'
	synopsis: 'The closest floating point approximation to Pi.
'
	definedIn: 'floatCharacterization'
	definition: 'Return the closest floating point approximation to Pi for the characterized floating point object representation.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'precision'
	forProtocolNamed: #'floatCharacterization'
	synopsis: 'The precision of the characterized floating point object representation.
'
	definedIn: 'floatCharacterization'
	definition: 'Report the precision, the number of radix digits, of floating point objects of the characterized floating point object representation. This satisfies the ISO/IEC 10967 floating point characterization requirement p. The result must be greater than or equal to two.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'radix'
	forProtocolNamed: #'floatCharacterization'
	synopsis: 'The radix of the characterized floating point object representation.
'
	definedIn: 'floatCharacterization'
	definition: 'Report the base, or radix, of the characterized floating point object representation. This satisfies the ISO/IEC 10967 floating point characterization requirement r. The result must be an even number greater than or equal to two.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Fraction'
	conformsToProtocolNames: #(#'rational')
	) protocolDescription: '
An exact representation for rational numbers. It is unspecific whether the rational number are maintain in a reduced form but messages that reveal the numerator and denominator answer values as if the fraction was reduced.
'
!

ProtocolSpec newMessagePattern: 'denominator'
	forProtocolNamed: #'Fraction'
	synopsis: 'Answer the denominator of the receiver.
'
	definedIn: 'rational'
	definition: 'Treating the receiver as a fraction, answer the lowest common denominator of the recevier.
'
	refinedIn: 'Fraction'
	refinement: 'Answer the integer smallest integer denominator of the receiver.
'
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'numerator'
	forProtocolNamed: #'Fraction'
	synopsis: 'Answer the numerator of the receiver.
'
	definedIn: 'rational'
	definition: 'Treating the receiver as a fraction, answer the integer numerator.
'
	refinedIn: 'Fraction'
	refinement: 'Answer the integer numerator of the receiver  reduced to  its lowest denominator.
'
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'printString'
	forProtocolNamed: #'Fraction'
	synopsis: ''
	definedIn: 'Object'
	definition: 'A string consisting of a sequence of characters that describe the receiver are returned as the result.
The exact sequence of characters that describe an object are implementation defined.
'
	refinedIn: 'Fraction'
	refinement: 'Answer a string consisting of the numerator and denominator for a reduced fraction, equivalent to the receiver . The numerator and denominator are separated by the character ''/'' as follows:
numerator/denominator
'
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Fraction factory'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
Represents protocol for creating an exact representation for rational numbers.
Standard Globals
Fraction	Conforms to the protocol <Fraction factory>. Its language element type is implementation defined.
'
!

ProtocolSpec newMessagePattern: 'numerator: bottom denominator: top'
	forProtocolNamed: #'Fraction factory'
	synopsis: 'Answer a new fraction whose numerator is top, and whose denominator is bottom.
'
	definedIn: 'Fraction factory'
	definition: 'Answer a new fraction whose numerator is top, and whose denominator is bottom. It is unspecified whether the result is reduced to the smallest possible denominator. If (top = bottom) or ( |bottom = 1) the result conforms to <integer> otherwise it conforms to <Fraction>. If bottom = 0 a ZeroDivide  exception is signaled.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('bottom' 'integer' #'unspecified') #('top' 'integer' #'unspecified') )
	returnValues: #( #( 'Fraction' #'unspecified') #( 'integer' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'gettableStream'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
An object conforming to <gettableStream> can read objects from its future sequence values.
'
!

ProtocolSpec newMessagePattern: 'atEnd'
	forProtocolNamed: #'gettableStream'
	synopsis: 'Returns a Boolean indicating whether the receiver is at the end of its values.
'
	definedIn: 'gettableStream'
	definition: 'Return true if the receiver has no future sequence values available for reading. Return false otherwise.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'do: operation'
	forProtocolNamed: #'gettableStream'
	synopsis: 'Evaluates the argument with each receiver future sequence value, terminating evaluation when there are no more future sequence values.
'
	definedIn: 'gettableStream'
	definition: 'Each member of the receiver''s future sequence values is, in turn, removed from the future sequence values; appended to the past sequence values; and, passed as the argument to an evaluation of operand. The argument, operation, is evaluated as if sent the message #value:. The number of evaluations is equal to the initial size of the receiver''s future sequence values. If there initially are no future sequence values, operation is not evaluated. The future sequence values are used as arguments in their sequence order. The result is undefined if any evaluation of operand changes the receiver''s future sequence values
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operation' 'monadicValuable' #'uncaptured') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'next'
	forProtocolNamed: #'gettableStream'
	synopsis: 'Return the next object in the receiver.
'
	definedIn: 'gettableStream'
	definition: 'The first object is removed from the receiver''s future sequence values and appended to the end of the receiver''s past sequence values. That object is returned as the value of the message. The returned object must conform to the receiver''s sequence value type.
The result is undefined if there the receiver has no future sequence values.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Object' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'next: amount'
	forProtocolNamed: #'gettableStream'
	synopsis: 'Returns a collection of the next amount objects in the stream.
'
	definedIn: 'gettableStream'
	definition: 'A number of objects equal to amount are removed from the receiver''s future sequence values and appended, in order, to the end of the receiver''s past sequence values. A collection whose elements consist of those objects, in the same order, is returned. If amount is equal to 0 an empty collection is returned. 
The result is undefined if amount is larger than the number of objects in the receiver''s future sequence values. 
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('amount' 'integer' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: 'amount < 0
'
!

ProtocolSpec newMessagePattern: 'nextLine'
	forProtocolNamed: #'gettableStream'
	synopsis: 'Reads the next line from the stream.
'
	definedIn: 'gettableStream'
	definition: 'Each object in the receiver''s future sequence values up to and including the first occurrence of the objects that constitute an implementation defined end-of-line sequence is removed from the future sequence values and appended to the receiver''s past sequence values. All of the transfered objects, except the end-of-line sequence objects, are collected, in order, as the elements of a string that is the return value. The result is undefined if there are no future sequence values in the receiver or if the future-sequence values do not include the end-of-line sequence.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'readableString' #'new') )
	errors: 'If any of the future sequence values to be returned do not conform to the protocol <Character>.
'
!

ProtocolSpec newMessagePattern: 'nextMatchFor: anObject'
	forProtocolNamed: #'gettableStream'
	synopsis: 'Reads the next object from the stream and returns true if the object is equivalent to the argument and false if not.
'
	definedIn: 'gettableStream'
	definition: 'The first object is removed from the receiver''s future sequence value and appended to the end of the receiver''s past sequence values. The value that would result from sending #= to the object with anObject as the argument is returned.
The results are undefined if there are no future sequence values in the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('anObject' 'Object' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'peek'
	forProtocolNamed: #'gettableStream'
	synopsis: 'Returns the next object in the receiver''s future sequence values without advancing the receiver''s position. Returns nil if the receiver is at end of stream.
'
	definedIn: 'gettableStream'
	definition: 'Returns the first object in the receiver''s future sequence values. The object is not removed from the future sequence values. The returned object must conform to the receiver''s sequence value type.
Returns nil if the receiver has no future sequence values. The return value will also be nil if the first future sequence object is nil.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Object' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'peekFor: anObject'
	forProtocolNamed: #'gettableStream'
	synopsis: 'Peeks at the next object in the stream and returns true if it matches the argument, and false if not.
'
	definedIn: 'gettableStream'
	definition: 'Returns the result of sending #= to the first object in the receiver''s future sequence values with anObject as the argument. Returns false if the receiver has no future sequence values.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('anObject' 'Object' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'skip: amount'
	forProtocolNamed: #'gettableStream'
	synopsis: 'Skips the next amount objects in the receiver''s future sequence values.
'
	definedIn: 'gettableStream'
	definition: 'A number of objects equal to the lesser of amount and the size of the receiver''s future sequence values are removed from the receiver''s future sequence values and appended, in order, to the end of the receiver''s past sequence values.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('amount' 'integer' #'uncaptured') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'skipTo: anObject'
	forProtocolNamed: #'gettableStream'
	synopsis: 'Sets the stream to read the object just after the next occurrence of the argument and returns true. If the argument is not found before the end of the stream is encountered, false is returned.
'
	definedIn: 'gettableStream'
	definition: 'Each object in the receiver''s future sequence values up to and including the first occurrence of an object that is equivalent to anObject is removed from the future sequence values and appended to the receiver''s past sequence values. If an object that is equivalent to anObject is not found in the receiver''s future sequence values, all of the objects in future sequence values are removed from future sequence values and appended to past sequence values. If an object equivalent to anObject is not found false is returned. Otherwise return true.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('anObject' 'Object' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'upTo: anObject'
	forProtocolNamed: #'gettableStream'
	synopsis: 'Returns a collection of all of the objects in the receiver up to, but not including, the next occurrence of the argument. Sets the stream to read the object just after the next occurrence of the argument. If the argument is not found and the end of the stream is encountered, an ordered collection of the objects read is returned.
'
	definedIn: 'gettableStream'
	definition: 'Each object in the receiver''s future sequence values up to and including the first occurrence of an object that is equivalent to anObject is removed from the future sequence values and appended to the receiver''s past sequence values. A collection, containing, in order, all of the transferred objects except the object (if any) that is equivalent to anObject is returned. If the receiver''s future sequence values is initially empty, an empty collection is returned.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('anObject' 'Object' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'IdentityDictionary'
	conformsToProtocolNames: #(#'abstractDictionary')
	) protocolDescription: '
This protocol defines the behavior of unordered collections whose elements can be accessed using an explicitly-assigned, external key.  Key equivalence is defined as sending the #== message.
'
!

(ProtocolSpec newProtocolNamed: #'IdentityDictionary factory'
	conformsToProtocolNames: #(#'Dictionary factory')
	) protocolDescription: '
This protocol defines the behavior of objects that can be used to create objects that conform to the protocol <IdentityDictionary>.
Standard Globals
IdentityDictionary	Conforms to the protocol <IdentityDictionary factory>. Its language element type is unspecified. This is a factory and discriminator for collections that conform to <IdentityDictionary>.
'
!

ProtocolSpec newMessagePattern: 'new'
	forProtocolNamed: #'IdentityDictionary factory'
	synopsis: 'Create a new object.
'
	definedIn: 'instantiator'
	definition: 'Return a newly created object initialized to a standard initial state.
'
	refinedIn: 'IdentityDictionary factory'
	refinement: 'Return a new <IdentityDictionary> that is optimized to store an implementation defined number of elements. The new collection initially contains no elements.
'
	parameters: #()
	returnValues: #( #( 'IdentityDictionary' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'new: count'
	forProtocolNamed: #'IdentityDictionary factory'
	synopsis: 'Create a new collection. The parameter count constrains the number of elements in the result.
'
	definedIn: 'collection factory'
	definition: 'Return a new collection that has space for at least count elements.
Conforming protocols may refine this message. In particular, the effect of the parameter count should be specified in refinements. It can be used to specify the exact number of elements, the minimum number, or in some cases can even be interpreted as a hint from the programmer, with no guarantee that the requested number of instance variables will actually be allocated.
Unless otherwise stated the initial values of elements of the new instance of the receiver are unspecified.
'
	refinedIn: 'IdentityDictionary factory'
	refinement: 'The parameter count represents a hint for space allocation. The new collection is to optimized to contain count elements. The new collection initially contains no elements.
The new collection conforms to the protocol <IdentityDictionary>.
'
	parameters: #( #('count' 'integer' #'unspecified') )
	returnValues: #( #( 'IdentityDictionary' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'withAll: newElements'
	forProtocolNamed: #'IdentityDictionary factory'
	synopsis: 'Create a collection containing all the elements of newElements.
'
	definedIn: 'IdentityDictionary factory'
	definition: 'Return a new collection whose elements are the elements of newElements.  The effect is the same as evaluating IdentityDictionary new addAll: newElements; yourself.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElements' 'abstractDictionary' #'unspecified') )
	returnValues: #( #( 'IdentityDictionary' #'new') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'initializableCollection factory'
	conformsToProtocolNames: #(#'collection factory')
	) protocolDescription: '
This protocol defines the behavior of objects that can be used to create non-empty collections.
'
!

ProtocolSpec newMessagePattern: 'with: element1'
	forProtocolNamed: #'initializableCollection factory'
	synopsis: 'Create a collection initially containing the argument element
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing element1. The collection contains the argument as its element.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('element1' 'Object' #'captured') )
	returnValues: #( #( 'collection' #'new') )
	errors: 'If the argument does not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element1 with: element2'
	forProtocolNamed: #'initializableCollection factory'
	synopsis: 'Create a collection initially containing the argument elements
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing both elements. The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('element1' 'Object' #'captured') #('element2' 'Object' #'captured') )
	returnValues: #( #( 'collection' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element2 with: element1 with: element3'
	forProtocolNamed: #'initializableCollection factory'
	synopsis: 'Create a collection initially containing the argument elements
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing three of elements. The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('element2' 'Object' #'captured') #('element1' 'Object' #'captured') #('element3' 'Object' #'captured') )
	returnValues: #( #( 'collection' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element1 with: element3 with: element2 with: element4'
	forProtocolNamed: #'initializableCollection factory'
	synopsis: 'Create a collection initially containing the argument elements
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing four elements. The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('element2' 'Object' #'captured') #('element4' 'Object' #'captured') #('element1' 'Object' #'captured') #('element3' 'Object' #'captured') )
	returnValues: #( #( 'collection' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'withAll: newElements'
	forProtocolNamed: #'initializableCollection factory'
	synopsis: 'Create a collection containing all the elements of newElements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection whose elements are the elements of newElements.
Conforming protocols may impose restrictions on the values of newElements.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElements' 'collection' #'unspecified') )
	returnValues: #( #( 'collection' #'new') )
	errors: 'If any of the elements in newElements do not meet the element type constraints of the result object





'
!

(ProtocolSpec newProtocolNamed: #'instantiator'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
This protocol defines the behavior of objects that can be used to create other objects without requiring any additional information.
'
!

ProtocolSpec newMessagePattern: 'new'
	forProtocolNamed: #'instantiator'
	synopsis: 'Create a new object.
'
	definedIn: 'instantiator'
	definition: 'Return a newly created object initialized to a standard initial state.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Object' #'new') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'integer'
	conformsToProtocolNames: #(#'rational')
	) protocolDescription: '
Represents an abstraction for integer numbers whose value is exact. Representations must provide unbounded precision and range, hence the ISO/IEC 10967 integer type parameter bounded is bound to false.
'
!

ProtocolSpec newMessagePattern: 'allMask: mask'
	forProtocolNamed: #'integer'
	synopsis: 'Answer true if all of the bits that are 1 in the binary representation of mask are 1 in the binary representation of the receiver. Answer false otherwise.
'
	definedIn: 'integer'
	definition: 'Answer true if all of the bits that are 1 in the binary representation of mask are 1 in the binary representation of the receiver. Answer false otherwise. If the receiver has fewer bits than the operand, the receiver is treated as if it were extended on the left with zeros to the length of the operand.
The result is undefined if either the receiver or the operand is a negative integer.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('mask' 'integer' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'anyMask: mask'
	forProtocolNamed: #'integer'
	synopsis: 'Answer true if any of the bits that are 1 in the binary representation of mask are 1 in the binary representation of the receiver. Answer false otherwise.
'
	definedIn: 'integer'
	definition: 'Answer true if any of the bits that are 1 in the binary representation of mask are 1 in the binary representation of the receiver. Answer false otherwise. If the receiver has fewer bits than the operand, the receiver is treated as if it were extended on the left with zeros to the length of the operand.
Result is undefined if either the receiver or the operand is a negative integer.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('mask' 'integer' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asScaledDecimal: scale'
	forProtocolNamed: #'integer'
	synopsis: 'Answer a scaled decimal number, with a fractional precision of scale, approximating the receiver.
'
	definedIn: 'number'
	definition: 'This is a conversion message. Answer a scaled decimal number, with a fractional precision of scale, which minimizes the difference between the answered value and the receiver.
The effect of underflow and overflow is implementation defined.
'
	refinedIn: 'integer'
	refinement: 'The number of significant digits of the answer is the same as the number of decimal digits in the receiver. The scale of the answer is 0.
It is an error if the receiver cannot be represented within the maximum precision of the <scaledDecimal> implementation.
'
	parameters: #( #('scale' 'integer' #'unspecified') )
	returnValues: #( #( 'scaledDecimal' #'unspecified') )
	errors: 'scaled decimal overflow
'
!

ProtocolSpec newMessagePattern: 'bitAnd: operand'
	forProtocolNamed: #'integer'
	synopsis: 'Answer the bit-wise logical and of the receiver and the operand.
'
	definedIn: 'integer'
	definition: 'Answer the result of the bit-wise logical and of the binary representation of the receiver and the binary representation of operand. The shorter of the receiver or the operand is extended on the left with zeros to the length of the longer of the two.
The result is undefined if either the receiver or the operand is a negative integer.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'integer' #'uncaptured') )
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'bitAt: index'
	forProtocolNamed: #'integer'
	synopsis: 'Answer the value of the bit at index in the binary representation of the receiver.
'
	definedIn: 'integer'
	definition: 'Answer the value of the bit at index in the binary representation of the receiver. Answer an integer value of 0 or 1, depending upon the value of the bit at position index in the binary representation of the receiver. The least significant bit of the receiver is designated as bit 1, with indices increasing to the left.
The result is undefined if either the receiver is negative. It is erroneous if index is less that or equal to zero.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('index' 'integer' #'uncaptured') )
	returnValues: #( #( 'integer' #'unspecified') )
	errors: 'index less than or equal to zero
'
!

ProtocolSpec newMessagePattern: 'bitAt: index put: value'
	forProtocolNamed: #'integer'
	synopsis: 'Set the value of the bit at index in the binary representation of the receiver.
'
	definedIn: 'integer'
	definition: 'Return an integer whose binary representation is identical to the receiver with the exception that the value of the bit at position index is equal to the low order bit of value.
The least significant bit of the receiver is designated as position 1, with indices increasing to the left.
The result is undefined if either the receiver or value is a negative integer. It is erroneous if index is less that or equal to zero.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('index' 'integer' #'uncaptured') #('value' 'integer' #'uncaptured') )
	returnValues: #( #( 'integer' #'unspecified') )
	errors: 'index less than or equal to zero
'
!

ProtocolSpec newMessagePattern: 'bitOr: operand'
	forProtocolNamed: #'integer'
	synopsis: 'Answer the logical or of the receiver and operand.
'
	definedIn: 'integer'
	definition: 'Answer the result of bit-wise logical or the binary representation of the receiver and the binary representation of operand. The shorter of the receiver or the operand is extended on the left with zeros to the length of the longer of the two.
The result is undefined if either the receiver or the operand is a negative integer.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'integer' #'uncaptured') )
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'bitShift: shift'
	forProtocolNamed: #'integer'
	synopsis: 'Answer the result of logically bit-wise shifting the binary representation of the receiver by shift bits.
'
	definedIn: 'integer'
	definition: 'If shift is positive, the receiver is shifted left and zeros (0) are shifted in on the right. If shift is negative, the receiver is shifted right and low order bits are discarded.
The result is undefined if either the receiver is negative.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('shift' 'integer' #'uncaptured') )
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'bitXor: operand'
	forProtocolNamed: #'integer'
	synopsis: 'Answer bit-wise exclusive or of the receiver and the operand.
'
	definedIn: 'integer'
	definition: 'Answer the result of the bit-wise exclusive or of the binary representation of the receiver and the binary representation of operand. The shorter of the receiver or the operand is extended on the left with zeros to the length of the longer of the two.
The result is undefined if either the receiver or the operand is a negative integer.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'integer' #'uncaptured') )
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'even'
	forProtocolNamed: #'integer'
	synopsis: 'Answer true if the receiver is even.
'
	definedIn: 'integer'
	definition: 'Answer true if the receiver is divisible by 2 with no remainder.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'factorial'
	forProtocolNamed: #'integer'
	synopsis: 'Answer the factorial of the receiver.
'
	definedIn: 'integer'
	definition: 'Answer the product of all numbers between the receiver and 1 inclusive. The result is undefined if the receiver is negative.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'gcd: operand'
	forProtocolNamed: #'integer'
	synopsis: 'Answer the greatest common divisor of the receiver and operand.
'
	definedIn: 'integer'
	definition: 'Answer the largest non-negative integer that divides both the receiver and operand with no remainder. Answer 0 if the receiver and operand are zero.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'integer' #'uncaptured') )
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'highBit'
	forProtocolNamed: #'integer'
	synopsis: 'Answer the index of the most significant non-zero bit in the binary representation of the receiver.
'
	definedIn: 'integer'
	definition: 'Answer the index of the most significant non-zero bit in the binary representation of the receiver. Answer 0 if the receiver is 0. The index of the least significant bit of the receiver is 1, with indices increasing to the left.
The result is undefined if the receiver is negative.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'lcm: operand'
	forProtocolNamed: #'integer'
	synopsis: 'Answer the least common multiple of the receiver and operand.
'
	definedIn: 'integer'
	definition: 'Answer the smallest non-negative integer which is evenly divided by both the receiver and operand. Answer 0 if the receiver and operand are zero.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'integer' #'uncaptured') )
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'noMask: mask'
	forProtocolNamed: #'integer'
	synopsis: 'Answer true if none of the bits that are 1 in the binary representation of mask are 1 in the binary representation of the receiver. Answer false otherwise.
'
	definedIn: 'integer'
	definition: 'Answer true if none of the bits that are 1 in the binary representation of mask are 1 in the binary representation of the receiver. Answer false otherwise. If the receiver has fewer bits than the operand, the receiver is treated as if it were extended on the left with zeros to the length of the operand.
The result is undefined if either the receiver or the operand is a negative integer.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('mask' 'integer' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'odd'
	forProtocolNamed: #'integer'
	synopsis: 'Answer true if the receiver is odd.
'
	definedIn: 'integer'
	definition: 'Answer true if the receiver is divisible by two (2) with remainder one (1).
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'printOn: output base: flag showRadix: base'
	forProtocolNamed: #'integer'
	synopsis: 'Write a sequence of characters that describes the receiver in radix base with optional radix specifier.
'
	definedIn: 'integer'
	definition: 'Write to output a sequence of characters that describes the receiver, starting at output''s current position. If the parameter flag is true, produce a sequence of characters that are recognizable using the radixInteger production of the Smalltalk Lexical Grammar. If the flag is false, then the sequence of characters must be recognizable using the radixDigits production as if the numeric value of the radixSpecifier was base. If the receiver is negative, a minus sign (''-'') is prepended to the sequence of characters. The result is undefined if base is less than two or greater than 36.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('flag' 'boolean' #'uncaptured') #('base' 'integer' #'uncaptured') #('output' 'puttableStream' #'uncaptured') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'printStringRadix: base'
	forProtocolNamed: #'integer'
	synopsis: 'Answer a string which represents the receiver in radix base.
'
	definedIn: 'integer'
	definition: 'Return a string containing a sequence of characters that represents the numeric value of the receiver in the radix specified by the argument.  The sequence of characters must be recognizable using the radixDigits production of the Smalltalk Lexical Grammar as if the numeric value of the radixSpecifier was base. If the receiver is negative, a minus sign (''-'') is prepended to the sequence of characters. The result is undefined if base is less than two or greater than 36.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('base' 'integer' #'uncaptured') )
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Interval'
	conformsToProtocolNames: #(#'sequencedReadableCollection')
	) protocolDescription: '
Represents a collection whose elements are numbers which form an arithmetic progression. Elements cannot be accessed externally.
'
!

ProtocolSpec newMessagePattern: ', operand'
	forProtocolNamed: #'Interval'
	synopsis: 'Answer a new collection which is the concatenation of the receiver and operand.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a new collection containing all of the receiver''s elements in their original order followed by all of the elements of operand, in their original order. The size of the new collection is equal to the sum of the sizes of the receiver and operand, as defined by the #size message.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
Unless specifically refined, this message is defined to answer an instance of the same type as the receiver.
'
	refinedIn: 'Interval'
	refinement: 'Answer a collection containing the elements of operand appended to the elements of the receiver. The enumeration order defined by the #do: message is used.  The return type is generalized to <sequencedReadableCollection>.
'
	parameters: #( #('operand' 'sequencedReadableCollection' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'collect: transformer'
	forProtocolNamed: #'Interval'
	synopsis: 'Answer a new collection constructed by gathering the results of evaluating transformer with each element of the receiver.
'
	definedIn: 'collection'
	definition: 'For each element of the receiver, transformer is evaluated with the element as the parameter. The results of these evaluations are collected into a new collection.
The elements are traversed in the order specified by the #do: message for the receiver.
Unless specifically refined, this message is defined to answer an objects conforming to the same protocol as the receiver.
'
	refinedIn: 'Interval'
	refinement: 'The return type is generalized to <sequencedReadableCollection>.
'
	parameters: #( #('transformer' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: 'If the elements of the receiver are inappropriate for use as arguments to transformer.
'
!

ProtocolSpec newMessagePattern: 'copyFrom: start to: stop'
	forProtocolNamed: #'Interval'
	synopsis: 'Answer a new collection containing all of the elements of the receiver between the indices start and stop inclusive. If stop < start, the result has a size of zero.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a new collection containing the specified range of elements of the receiver in their original order. The element at index start in the receiver is at index 1 in the new collection; the element at index start+1 is at index 2, etc. If stop is less than start, then the new collection is empty. Otherwise, the size of the new collection is the maximum of (stop - start + 1) and 0.
The parameters start and stop must be positive.
Unless specifically refined, this message is defined to answer an instance of the same class as the receiver''s class.
'
	refinedIn: 'Interval'
	refinement: 'The return type is generalized to <sequencedReadableCollection>.
'
	parameters: #( #('stop' 'integer' #'uncaptured') #('start' 'integer' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: 'If start < 1 or start > self size.
If stop < 1 or stop > self size.
'
!

ProtocolSpec newMessagePattern: 'copyReplaceAll: targetElements with: replacementElements'
	forProtocolNamed: #'Interval'
	synopsis: 'Answer a new collection in which all subsequences of elements in the receiver matching targetElements are replaced in the new collection by the elements in replacementElements.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a new collection with the elements of the receiver in their original order, except where a subsequence in the receiver matches targetElements. A subsequence in the receiver is said to match the elements of targetElements if:
1. They have the same number of elements.
2. For all indices of the subsequence, the element in the subsequence at a given index is equivalent to the element in targetElements at the same index.
Where a subsequence match is found, the elements from replacementElements are placed in the new collection instead.
Unless specifically refined, this message is defined to answer an instance of the same class as the receiver.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: 'Interval'
	refinement: 'The return type is generalized to <sequencedReadableCollection>.
'
	parameters: #( #('targetElements' 'sequencedReadableCollection' #'uncaptured') #('replacementElements' 'sequencedReadableCollection' #'unspecified') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: 'If any of the elements in replacementElements is inappropriate for storage in instances of the result.
'
!

ProtocolSpec newMessagePattern: 'copyReplaceFrom: stop to: replacementElements with: start'
	forProtocolNamed: #'Interval'
	synopsis: 'Answer a new collection, containing the same elements as the receiver, but with the elements in the receiver between start and stop inclusive replaced by the elements in replacementElements.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'This message can be used to insert, append, or replace. The size of replacementElements (as defined by #size) need not be the same as the number of elements being replaced. There are three cases:
1. If stop = start - 1 , and start is less than or equal to the size of the receiver, then the replacementElements are inserted between the elements at index stop and start. None of the receiver''s elements are replaced.
2. If stop = the size of the receiver and start = stop + 1, then the operation is an append, and the replacementElements are placed at the end of the new collection.
3. Otherwise, the operation is a replacement, and the receiver''s elements in the given range are replaced by the elements from replacementElements.
In all cases, the resulting collection consists of the receiver''s elements from indices 1 to start - 1 in their original order, followed by the elements of replacementElements, followed by the remainder of the receiver''s elements from index stop + 1 in their original order. The size of the result is the receiver''s size - (stop - start + 1) + the replacementElements size.
The parameters start and stop must be positive.
Unless specifically refined, this message is defined to answer an instance of the same class as the receiver''s class.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: 'Interval'
	refinement: 'The return type is generalized to <sequencedReadableCollection>.
'
	parameters: #( #('start' 'integer' #'uncaptured') #('stop' 'integer' #'uncaptured') #('replacementElements' 'sequencedReadableCollection' #'unspecified') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: 'The elements in replacementElements are not suitable for storage in instances of the result.
'
!

ProtocolSpec newMessagePattern: 'copyReplaceFrom: replacementElement to: stop withObject: start'
	forProtocolNamed: #'Interval'
	synopsis: 'Answer a new collection conforming to the same protocols as the receiver, in which the elements of the receiver between start and stop inclusive have been replaced with replacementElement.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'This message can be used to insert, append, or replace. There are three cases:
1. If stop = start - 1 , and start is less than or equal to the size of the receiver, then replacementElement is inserted between the elements at index stop and start. None of the receiver''s elements are replaced.
2. If stop = the size of the receiver and start = stop + 1, then the operation is an append, and replacementElement is placed at the end of the new collection.
3. Otherwise, the operation is a replacement, and each of the receiver''s elements in the given range is replaced by replacementElement.
The parameters start and stop must be non-negative.
Unless specifically refined, this message is defined to answer an instance of the same class as the receiver''s class.
Collections that by definition enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: 'Interval'
	refinement: 'The return type is generalized to <sequencedReadableCollection>.
'
	parameters: #( #('replacementElement' 'Object' #'captured') #('start' 'integer' #'uncaptured') #('stop' 'integer' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'copyReplacing: replacementElement withObject: targetElement'
	forProtocolNamed: #'Interval'
	synopsis: 'Answer a new collection conforming to the same protocols as the receiver, in which any occurrences of targetElement are replaced by replacementElement.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'A new collection is created and initialized with the same elements as the receiver in the same order, except that any objects in the receiver which are equivalent to targetElement are replaced in the new collection by replacementElement.
Unless specifically refined, this message is defined to answer an instance of the same class as the receiver.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: 'Interval'
	refinement: 'The return type is generalized to <sequencedReadableCollection>.
'
	parameters: #( #('replacementElement' 'Object' #'captured') #('targetElement' 'Object' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'copyWith: newElement'
	forProtocolNamed: #'Interval'
	synopsis: 'Answer a new collection containing the same elements as the receiver, with newElement added.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a new collection with size one greater than the size of the receiver containing the elements of the receiver and newElement placed at the end.
Unless specifically refined, this message is defined to answer an instance of the same class as the receiver.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: 'Interval'
	refinement: 'The return type is generalized to <sequencedReadableCollection>.
'
	parameters: #( #('newElement' 'Object' #'captured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'copyWithout: oldElement'
	forProtocolNamed: #'Interval'
	synopsis: 'Answer a new collection, containing the same elements as the receiver in their original order omitting any elements equivalent to oldElement.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a new collection with all of the elements of the receiver that are not equivalent to oldElement, in their original order.
Unless specifically refined, this message is defined to answer an instance of the same type as the receiver.
'
	refinedIn: 'Interval'
	refinement: 'The return type is generalized to <sequencedReadableCollection>.
'
	parameters: #( #('oldElement' 'Object' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'reject: discriminator'
	forProtocolNamed: #'Interval'
	synopsis: 'Answer a new collection which excludes the elements in the receiver which cause discriminator to evaluate to true.
'
	definedIn: 'collection'
	definition: 'For each element of the receiver, discriminator is evaluated with the element as the parameter. Each element which causes discriminator to evaluate to false is added to the new collection.
The elements are traversed in the order specified by the #do: message for the receiver.
Unless specifically refined, this message is defined to answer an object conforming to the same protocol as the receiver.
'
	refinedIn: 'Interval'
	refinement: 'The return type is refined to <sequencedReadableCollection>.
'
	parameters: #( #('discriminator' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: 'If the elements of the receiver are inappropriate for use as arguments to discriminator.
If discriminator evaluates to an object that does not conform to the protocol <boolean> for any element of the receiver.
'
!

ProtocolSpec newMessagePattern: 'reverse'
	forProtocolNamed: #'Interval'
	synopsis: 'Answer a collection with the elements of the receiver arranged in reverse order.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a collection conforming to the same protocols as the receiver, but with its elements arranged in reverse order.
This operation is equivalent to:
1. Create a new collection which conforms to the same protocols as the receiver;
2. Traverse the elements of the receiver in the order specified by the #reverseDo: message, adding each element of the receiver to the new collection;
3. Answer the new collection.
'
	refinedIn: 'Interval'
	refinement: 'The return type is generalized to <sequencedReadableCollection>.
'
	parameters: #()
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'select: discriminator'
	forProtocolNamed: #'Interval'
	synopsis: 'Answer a new collection which contains the elements in the receiver which cause discriminator to evaluate to true.
'
	definedIn: 'collection'
	definition: 'For each element of the receiver, discriminator is evaluated with the element as the parameter. Each element which causes discriminator to evaluate to true is added to the new collection.
The elements are traversed in the order specified by the #do: message for the receiver.
Unless specifically refined, this message is defined to answer an objects conforming to the same protocol as the receiver.
'
	refinedIn: 'Interval'
	refinement: 'The return type is refined to <sequencedReadableCollection>.
'
	parameters: #( #('discriminator' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: 'If the elements of the receiver are inappropriate for use as arguments to discriminator.
If discriminator evaluates to an object that does not conform to the protocol <boolean> for any element of the receiver.










'
!

(ProtocolSpec newProtocolNamed: #'Interval factory'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
Represents protocol for creating a collection whose elements are numbers which form an arithmetic progression.
Standard Globals
Interval	Conforms to the protocol <Interval factory>. Its language element type is unspecified. This is a factory and discriminator for collections that conform to <Interval>.
'
!

ProtocolSpec newMessagePattern: 'from: stop to: start'
	forProtocolNamed: #'Interval factory'
	synopsis: 'Answer an interval which represents an arithmetic progression from start to stop in increments of 1.
'
	definedIn: 'Interval factory'
	definition: 'Answer an interval which represents an arithmetic progression from start to stop, using the increment 1 to compute each successive element. The elements are numbers which have the same type as start. Note that stop may not be the last element in the sequence; the last element is given by the formula
start + ((stop - start) // 1)
The interval answered will be empty (it will answer 0 to the #size message) if start > stop
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('start' 'number' #'unspecified') #('stop' 'number' #'unspecified') )
	returnValues: #( #( 'Interval' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'from: stop to: step by: start'
	forProtocolNamed: #'Interval factory'
	synopsis: 'Answer an interval which represents an arithmetic progression from start to stop in increments of step.
'
	definedIn: 'Interval factory'
	definition: 'Answer an interval which represents an arithmetic progression from start to stop, using the increment step to compute each successive element. The value of step can be positive or negative, but it must be non-zero. The elements are numbers which have the most general type of start and step. Note that stop is not necessarily an element in the sequence; the last element is given by the formula
(((stop - start) // step) * step) + start
The interval answered will be empty (it will answer 0 to the #size message) if:
start < stop and step < 0, or
start > stop and step > 0.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('start' 'number' #'unspecified') #('stop' 'number' #'unspecified') #('step' 'number' #'unspecified') )
	returnValues: #( #( 'Interval' #'unspecified') )
	errors: 'step = 0





'
!

(ProtocolSpec newProtocolNamed: #'magnitude'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
Provides protocol for comparing objects which are linearly ordered with respect to some comparison operation.
'
!

ProtocolSpec newMessagePattern: '< operand'
	forProtocolNamed: #'magnitude'
	synopsis: 'Answer true if the receiver is less than operand. Answer false otherwise.
'
	definedIn: 'magnitude'
	definition: 'Answer true if the receiver is less than operand with respect to the ordering defined for them. Answer false otherwise.
It is erroneous if the receiver and operand are not comparable.
The semantics of the natural ordering must be defined by refinement, which may also restrict the type of operand.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'magnitude' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: 'Receiver and operand are not comparable
'
!

ProtocolSpec newMessagePattern: '<= operand'
	forProtocolNamed: #'magnitude'
	synopsis: 'Answer true if the receiver is less than or equal to operand. Answer false otherwise.
'
	definedIn: 'magnitude'
	definition: 'Answer true if the receiver would answer true to either the #< or #= message with operand as the parameter. Answer false otherwise.
It is erroneous if the receiver and operand are not comparable.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'magnitude' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: 'Receiver and operand are not comparable
'
!

ProtocolSpec newMessagePattern: '> operand'
	forProtocolNamed: #'magnitude'
	synopsis: 'Answer true if the receiver is greater than operand. Answer false otherwise.
'
	definedIn: 'magnitude'
	definition: 'Answer true if the receiver is greater than operand with respect to the natural ordering. Answer false otherwise.
It is erroneous if the receiver and operand are not comparable.
The semantics of the natural ordering must be defined by refinement, which may also restrict the type of operand.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'magnitude' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: 'Receiver and operand are not comparable
'
!

ProtocolSpec newMessagePattern: '>= operand'
	forProtocolNamed: #'magnitude'
	synopsis: 'Answer true if the receiver is greater than or equal to operand. Answer false otherwise.
'
	definedIn: 'magnitude'
	definition: 'Answer true if the receiver answers true to either the #> or #= message with operand as the parameter. Answer false otherwise.
It is erroneous if the receiver and operand are not comparable.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'magnitude' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: 'Receiver and operand are not comparable
'
!

ProtocolSpec newMessagePattern: 'between: max and: min'
	forProtocolNamed: #'magnitude'
	synopsis: 'Answer true if the receiver is less than or equal to max, and greater than or equal to min. Answer false otherwise.
'
	definedIn: 'magnitude'
	definition: 'Answer true if the receiver answers true to the #<= message with max as the parameter, and also answers true to the #>= message with min as the parameter. Answer false otherwise.
It is erroneous if the receiver  and min or max are not comparable.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('max' 'magnitude' #'uncaptured') #('min' 'magnitude' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: 'Receiver and operands are not comparable.
'
!

ProtocolSpec newMessagePattern: 'max: operand'
	forProtocolNamed: #'magnitude'
	synopsis: 'Answer the receiver if it is greater than operand. Answer operand otherwise.
'
	definedIn: 'magnitude'
	definition: 'Answer the receiver if the receiver answers true to the #> message with operand as the parameter. Answer operand otherwise.
It is erroneous if the receiver and operand are not comparable.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'magnitude' #'uncaptured') )
	returnValues: #( #( 'magnitude' #'unspecified') )
	errors: 'Receiver and operand are not comparable
'
!

ProtocolSpec newMessagePattern: 'min: operand'
	forProtocolNamed: #'magnitude'
	synopsis: 'Answer the receiver if it is less than operand. Answer operand otherwise.
'
	definedIn: 'magnitude'
	definition: 'Answer the receiver if the receiver answers true to the #< message with operand as the parameter. Answer operand otherwise.
It is erroneous if the receiver and operand are not comparable.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'magnitude' #'uncaptured') )
	returnValues: #( #( 'magnitude' #'unspecified') )
	errors: 'Receiver and operand are not comparable





'
!

(ProtocolSpec newProtocolNamed: #'MessageNotUnderstood'
	conformsToProtocolNames: #(#'Error')
	) protocolDescription: '
This protocol describes the behavior of exceptions that are signalled if the receiver of a message does not have a method with a matching  selector.
'
!

ProtocolSpec newMessagePattern: 'isResumable'
	forProtocolNamed: #'MessageNotUnderstood'
	synopsis: 'Determine whether an exception is resumable.
'
	definedIn: 'exceptionDescription'
	definition: 'This message is used to determine whether the receiver is a resumable exception. Answer true if the receiver is resumable. Answer false if the receiver is not resumable.
'
	refinedIn: 'MessageNotUnderstood'
	refinement: 'Answer true.
'
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'message'
	forProtocolNamed: #'MessageNotUnderstood'
	synopsis: 'Answer the selector and arguments of the message that failed.
'
	definedIn: 'MessageNotUnderstood'
	definition: 'Answer the selector and arguments of the message that failed.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'failedMessage' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'receiver'
	forProtocolNamed: #'MessageNotUnderstood'
	synopsis: 'Answer the receiver  the message that failed.
'
	definedIn: 'MessageNotUnderstood'
	definition: 'Answer the object that was the receiver of the message that failed.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Object' #'state') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'MessageNotUnderstoodSelector'
	conformsToProtocolNames: #(#'exceptionSelector')
	) protocolDescription: '
This protocol describe the behavior of the value of the global named MessageNotUnderstood. This object  is used to as an exception selector to catch failed message sends. Message not understood exceptions are resumable so any message in this protocol that signal such an exception may ultimately return to their sender.
This object is not specifed as an <exceptionSignaler> or an <exceptionInstantiator>. It as assumed that message not understood exceptions are signaled by the implemention dependent implementaton of the message <Object> #doesNotUnderstand:.
Standard Globals
MessageNotUnderstood	
Unspecified language element type. Conforms to the protocol <MessageNotUnderstoodSelector>. Used as an exception selector .
'
!

ProtocolSpec newMessagePattern: 'handles: exception'
	forProtocolNamed: #'MessageNotUnderstoodSelector'
	synopsis: 'Determine whether an exception handler will accept a signaled exception.
'
	definedIn: 'exceptionSelector'
	definition: 'This message determines whether the exception handler associated with the receiver may be used to process the argument. Answer true if an associated handler should be used to process exception. Answer false if an associated handler may not be used to process the exception.
'
	refinedIn: 'MessageNotUnderstoodSelector'
	refinement: 'Return true if exception is an exception that is the result of a failed message send.
'
	parameters: #( #('exception' 'exceptionDescription' #'unspecified') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'monadicBlock'
	conformsToProtocolNames: #(#'monadicValuable')
	) protocolDescription: '
This protocol describes the behavior for blocks with one argument.
Objects conforming to this protocol can be created only by the block constructor construct of the Smalltalk language.
'
!

(ProtocolSpec newProtocolNamed: #'monadicValuable'
	conformsToProtocolNames: #(#'valuable')
	) protocolDescription: '
This protocol describes the behavior for objects supporting the value: selector.
'
!

ProtocolSpec newMessagePattern: 'argumentCount'
	forProtocolNamed: #'monadicValuable'
	synopsis: 'Answers the number of arguments needed to evaluate the receiver.
'
	definedIn: 'valuable'
	definition: 'The number of arguments needed to evaluate the receiver is returned.
'
	refinedIn: 'monadicValuable'
	refinement: 'Returns 1.
'
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'value: argument'
	forProtocolNamed: #'monadicValuable'
	synopsis: 'Answers the value of the receiver when applied to the argument.
'
	definedIn: 'monadicValuable'
	definition: 'The receiver is evaluated as defined by the receiver.
Note that in the case that the receiver is a block, that the evaluation is defined by the language with argument bound to the block''s only argument.
The result is as defined by the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('argument' 'ANY' #'unspecified') )
	returnValues: #( #( 'ANY' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'nil'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
This protocol describes the behavior that is unique to the distinguished immutable, identity object that is the value of the reserved identifier "nil".
'
!

ProtocolSpec newMessagePattern: 'printString'
	forProtocolNamed: #'nil'
	synopsis: 'Return a string that describes the receiver.
'
	definedIn: 'Object'
	definition: 'A string consisting of a sequence of characters that describe the receiver are returned as the result.
The exact sequence of characters that describe an object are implementation defined.
'
	refinedIn: 'nil'
	refinement: 'Return a string with the same characters as the string ''nil''.
'
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'niladicBlock'
	conformsToProtocolNames: #(#'niladicValuable')
	) protocolDescription: '
This protocol describes the behavior for blocks with no arguments.
Objects conforming to this protocol can be created only by the block constructor construct of the Smalltalk language.
'
!

ProtocolSpec newMessagePattern: 'ensure: terminationBlock'
	forProtocolNamed: #'niladicBlock'
	synopsis: 'Evaluate a termination block after evaluating the receiver.
'
	definedIn: 'niladicBlock'
	definition: 'Evaluate the receiver and return its result. Immediately after successful evaluation of the receiver but before returning its result, evaluate terminationBlock. If abnormal termination of the receiver occurs, terminationBlock is evaluated. In either case, the value returned from the evaluation of terminationBlock is discarded.
Activation of an exception handler from within the receiver is not in and of itself an abnormal termination. However, if the exception handler for an exception that is not resumable results in termination of the receiver or if its handler block contains a return statement that results in abnormal termination of the receiver, then terminationBlock will be evaluated after evaluation of the exception handler.
If an abnormal termination results in the termination of multiple blocks which were evaluated using either #ensure: or #ifCurtailed: the respective terminationBlocks will be executed in the reverse of the order in which the corresponding receiver blocks were evaluated.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('terminationBlock' 'niladicBlock' #'uncaptured') )
	returnValues: #( #( 'ANY' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'ifCurtailed: terminationBlock'
	forProtocolNamed: #'niladicBlock'
	synopsis: 'Evaluating the receiver with an abnormal termination action.
'
	definedIn: 'niladicBlock'
	definition: 'Evaluate the receiver and return its result. If abnormal termination of the receiver occurs, terminationBlock is evaluated. The value returned from the evaluation of terminationBlock is discarded.
Activation of an exception handler from within the receiver is not in and of itself an abnormal termination. However, if the exception handler for an exception that is not resumable results in termination of the receiver or if its handler block contains a return statement that results in abnormal termination of the receiver, then terminationBlock will be evaluated after evaluation of the exception handler.
If an abnormal termination result in the termination of multiple blocks which were evaluated using either #ensure: or #ifCurtailed: the respective terminationBlocks will be executed in the reverse of the order in which the corresponding receiver blocks were evaluated.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('terminationBlock' 'niladicBlock' #'uncaptured') )
	returnValues: #( #( 'ANY' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'on: action do: selector'
	forProtocolNamed: #'niladicBlock'
	synopsis: 'Evaluate the receiver in the scope of an exception handler.
'
	definedIn: 'niladicBlock'
	definition: 'The receiver is evaluated such that if during its evaluation an exception corresponding to selector is signaled then action will be evaluated. The result of evaluating the receiver is returned.
Before evaluating the receiver the current state of the exception environment is captured as the handler environment. Then a new exception handler is created with selector as its exception selector and action as its handler block. The new handler is pushed onto the exception environment.
If evaluation of the receiver terminates normally then the exception environment is reset to the handler environment before returning to the sender of the #on:do: message.
If signaling of an exception results in evaluation of action the evaluation will occur in the context of the handler environment. The argument to the action will be an object that conforms to the protocol <signaledException>.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('selector' 'exceptionSelector' #'uncaptured') #('action' 'monadicBlock' #'uncaptured') )
	returnValues: #( #( 'ANY' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'niladicValuable'
	conformsToProtocolNames: #(#'valuable')
	) protocolDescription: '
This protocol describes the behavior for objects supporting the #value selector.
'
!

ProtocolSpec newMessagePattern: 'argumentCount'
	forProtocolNamed: #'niladicValuable'
	synopsis: 'Answers the number of arguments needed to evaluate the receiver.
'
	definedIn: 'valuable'
	definition: 'The number of arguments needed to evaluate the receiver is returned.
'
	refinedIn: 'niladicValuable'
	refinement: 'Returns 0.
'
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'value'
	forProtocolNamed: #'niladicValuable'
	synopsis: 'Answers the value of the receiver.
'
	definedIn: 'niladicValuable'
	definition: 'The receiver is evaluated as defined by the receiver.
The result is as defined by the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'ANY' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'whileFalse'
	forProtocolNamed: #'niladicValuable'
	synopsis: 'Evaluates the receiver until it evaluates to true.
'
	definedIn: 'niladicValuable'
	definition: 'The receiver is evaluated as defined by the receiver.
Note that in the case that the receiver is a block, the evaluation is defined by the language.
If this evaluation results in false the process repeats.
If and when the evaluation of the receiver results in true, the method terminates.
The results are undefined if the receiver is not a block which evaluates to a Boolean value.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'whileFalse: iterationBlock'
	forProtocolNamed: #'niladicValuable'
	synopsis: 'Evaluates iterationBlock zero or more times until the receiver evaluates to true.
'
	definedIn: 'niladicValuable'
	definition: 'The receiver is evaluated as defined by the receiver.
Note that in the case that the receiver is a block, that the evaluation is defined by the language.
If this evaluation results in false, the argument is evaluated and the process repeats.
If and when the evaluation of the receiver results in true, the method terminates.
The results are undefined if the receiver is not a block which evaluates to a Boolean value.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('iterationBlock' 'niladicValuable' #'uncaptured') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'whileTrue'
	forProtocolNamed: #'niladicValuable'
	synopsis: 'Evaluates the receiver until it evaluates to false.
'
	definedIn: 'niladicValuable'
	definition: 'The receiver is evaluated as defined by the receiver.
Note that in the case that the receiver is a block, that the evaluation is defined by the language.
If this evaluation results in true the process repeats.
If and when the evaluation of the receiver results in false, the method terminates.
The results are undefined if the receiver is not a block which evaluates to a Boolean value.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'whileTrue: iterationBlock'
	forProtocolNamed: #'niladicValuable'
	synopsis: 'Evaluates iterationBlock zero or more times until the receiver evaluates to false.
'
	definedIn: 'niladicValuable'
	definition: 'The receiver is evaluated as defined by the receiver.
Note that in the case that the receiver is a block, that the evaluation is defined by the language.
If this evaluation results in true, the argument is evaluated and the process repeats.
If and when the evaluation of the receiver results in false, the method terminates.
The results are undefined if the receiver is not a block which evaluates to a Boolean value.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('iterationBlock' 'niladicValuable' #'uncaptured') )
	returnValues: #()
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Notification'
	conformsToProtocolNames: #(#'Exception')
	) protocolDescription: '
This protocol describes the behavior of instances of the class Notification. These are used to represent exceptional conditions that may occur but which are not considered errors. Actual notification exceptions used by an application may be subclasses of this class.
As Notification is explicitly specified  to be subclassable, conforming implementations must implement its behavior in a non-fragile manner.
'
!

ProtocolSpec newMessagePattern: 'defaultAction'
	forProtocolNamed: #'Notification'
	synopsis: ''
	definedIn: 'exceptionDescription'
	definition: 'If the exception described by the receiver is signaled and the current exception environment does not contain a handler for the exception this method will be executed.
The exact behavior and result of this method is implementation defined.
'
	refinedIn: 'Notification'
	refinement: 'No action is taken. The value nil is returned as the value of the message that signaled the exception.
'
	parameters: #()
	returnValues: #( #( 'nil' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'isResumable'
	forProtocolNamed: #'Notification'
	synopsis: ''
	definedIn: 'exceptionDescription'
	definition: 'This message is used to determine whether the receiver is a resumable exception. Answer true if the receiver is resumable. Answer false if the receiver is not resumable.
'
	refinedIn: 'Notification'
	refinement: 'Answer true. Notification exceptions by default are specified to be resumable.
'
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Notification class'
	conformsToProtocolNames: #(#'Exception class')
	) protocolDescription: '
This protocol describe the behavior of the global Notification. The value of the standard global Notification is a class object that conforms to this protocol. The class Notification is explicitly specified  to be subclassable in a standard conforming program. Conforming implementations must implement its behaviors in a non-fragile manner.
The signaled exceptions generated by this type of object conform to the protocol <Notification>.
Standard Globals
Notification	A class name. Conforms to the protocol <Notification class>. Notification must inherit (possibly indirectly) from the class Exception.  Instances of this class conform to the protocol <Notification>.
'
!

ProtocolSpec newMessagePattern: 'new'
	forProtocolNamed: #'Notification class'
	synopsis: ''
	definedIn: 'instantiator'
	definition: 'Return a newly created object initialized to a standard initial state.
'
	refinedIn: 'Notification class'
	refinement: 'The object returned conforms to <Notification>.
'
	parameters: #()
	returnValues: #( #( 'Notification' #'new') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'number'
	conformsToProtocolNames: #(#'magnitude')
	) protocolDescription: '
Provides protocol for objects that represent  numeric  quantities and support operations performing arithmetic, arithmetic progressions, and conversion on numerical quantities. 
The descriptions of messages in this protocol reference specific arithmetic and numerical operations in the ISO/IEC 10967 standard, providing definition-by-reference for these operations.
Smalltalk provides for mixed-mode arithmetic with the receiver and argument having different numeric representations. Unless otherwise specified by an individual operation the receiver and argument are first converted to the same numeric representation according to the following table.

Default Conversion Table:

		opera|nd	<integer>		<scaledDecimal>	<Fraction>	<Float>e	<Float>d	<Float>q
	--receiver---|-------------------------------------------------------
<integer>		|	<integer>		<scaledDecimal>	<Fraction>	<Float>e	<Float>d	<Float>q
<scaledDecimal>	|	<scaledDecimal>	<scaledDecimal>	<Fraction>	<Float>e	<Float>d	<Float>q
<Fraction>		|	<Fraction>		<Fraction>		<Fraction>	<Float>e	<Float>d	<Float>q
<Float>e		|	<Float>e		<Float>e		<Float>e	<Float>e	<Float>d	<Float>q
<Float>d		|	<Float>d		<Float>d		<Float>d	<Float>d	<Float>d	<Float>q
<Float>q		|	<Float>q		<Float>q		<Float>q	<Float>q	<Float>q	<Float>q

If multiple representations of <Float> are available, the representations are ordered from smallest to largest precision. This table contains multiple entries for <Float>, designated by a subscript, one for each designation of floating point literal representation. Values that are converted to <Float> are converted to the smallest precision of Float that can represent the number of digits in the original value.
An <integer> converted to a <scaledDecimal> will have the scale of the other operand with the fractional digits set to zero.  A <scaledDecimal> converted to a <Fraction> will be a fraction having the same numeric value but having an integer numerator and a denominator which is ten raised to the power of the <scaledDecimal>''s scale factor.
The result type of most numeric opeations is based upon the operaand type.  The Default Result Type for all operand types except <Fraction> is the type to which the operands have been converted according to the Default ConversionTable. If the converted operand type is <Fraction> the Default Result Type is <rational>. In all cases where the type of the return value differs from the default result type it is noted in the operation''s description.
Operations can produce results that are outside the set of representable numbers, or mathematically undefined. It is implementation defined whether errors are raised when results are not representable or if unrepresentable results are wrapped in implementation-defined continuation values or their equivalent. The effect of underflow and overflow is therefore implementation defined.
<number> conforms to <magnitude>. All object that implement the <number> protocol or any protocol that conforms to <number> are comparable.
'
!

ProtocolSpec newMessagePattern: '* operand'
	forProtocolNamed: #'number'
	synopsis: 'Answer the result of multiplying the receiver by operand.
'
	definedIn: 'number'
	definition: 'Answer a number whose value is the result of multiplying the receiver and operand, as specified by the ISO/IEC 10967 multiplication operation mul. To perform the operation both the receiver and operand must be objects with identical numeric representations. If they have different representations  a conversion to their common numeric representation is performed, as specified by the Default Conversion Table, before applying the operation. If the common representation is <integer>, then the result value is defined by the ISO/IEC 10967 operation mulI. If the common representation is <Float>, then the result value is defined by the ISO/IEC 10967 mulF . Otherwise, the result is consistent with the mathematical definition of the ISO/IEC 10967 operation mul.
The protocol and representation of the return value is defined to be the Default Result Type. If the return value conforms to <scaledDecimal> then the scale of the result is at least the scale of the receiver after conversion if necessary.
If the result value is outside of the range of the common numeric representation, the effect of underflow or overflow is implementation defined..
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'number' #'unspecified') )
	returnRule: '[ :receiver :operand | "Default Result Type"
	ProtocolSpec
		defaultReturnProtocolNameReceiver: receiver
		operand: operand
]'
	errors: ''
!

ProtocolSpec newMessagePattern: '+ operand'
	forProtocolNamed: #'number'
	synopsis: 'Answer the result of adding operand to the receiver.
'
	definedIn: 'number'
	definition: 'Answer a number whose value is the result of adding the receiver and operand, as specified by the ISO/IEC 10967 addition operation add. To perform the operation both the receiver and operand must be objects with identical numeric representations. If they have different representations a conversion to a common numeric representation is performed, as specified by the Default Conversion Table, before applying the operation. If the resulting protocol is <integer>, then the result value is defined by the ISO/IEC 10967 operation addI. If the resulting protocol is <Float>, then the result value is defined by the ISO/IEC 10967 addF . Otherwise, the result is consistent with the mathematical definition of the ISO/IEC 10967 operation add.
The protocol and representation of the return value is defined by the Default Result Type. If the return value conforms to <scaledDecimal>  then the scale of the result is at least the scale of the receiver after conversion if necessary. If the result value is outside of the range of the common numeric representation, the effect of underflow or overflow is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'number' #'unspecified') )
	returnRule: '[ :receiver :operand | "Default Result Type"
	ProtocolSpec
		defaultReturnProtocolNameReceiver: receiver
		operand: operand
]'
	errors: ''
!

ProtocolSpec newMessagePattern: '- operand'
	forProtocolNamed: #'number'
	synopsis: 'Answer the result of subtracting operand from the receiver.
'
	definedIn: 'number'
	definition: 'Answer a number whose value is the result of subtracting the receiver and operand, as specified by the ISO/IEC 10967 subtraction operation sub. To perform the operation both the receiver and operand must be objects with identical numeric representations. If they have different representations a conversion to a common numeric representation is performed, as specified by the Default Conversion Table, before applying the operation. If the resulting protocol is <integer>, then the result value is defined by the ISO/IEC 10967 operation subI. If the resulting protocol is <Float>, then the result value is defined by the ISO/IEC 10967 subF . Otherwise, the result is consistent with the mathematical definition of the ISO/IEC 10967 operation sub.
The protocol and representation of the return value is defined by the Default Result Type. If the return value conforms to <scaledDecimal> then the scale of the result is at least the scale of the receiver after conversion if necessary. If the result value is outside of the range of the common numeric representation, the effect of underflow or overflow is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'number' #'unspecified') )
	returnRule: '[ :receiver :operand | "Default Result Type"
	ProtocolSpec
		defaultReturnProtocolNameReceiver: receiver
		operand: operand
]'
	errors: ''
!

ProtocolSpec newMessagePattern: '/ operand'
	forProtocolNamed: #'number'
	synopsis: 'Answer the result of dividing the receiver by operand.
'
	definedIn: 'number'
	definition: 'Answer a number whose value is the result of dividing the receiver by operand, as specified by the ISO/IEC 10967 flooring division operation div To perform the operation both the receiver and operand must be objects with identical numeric representations. If they have different representations a conversion to a common numeric representation is performed, as specified by the Default Conversion Table, before applying the operation. If the resulting protocol is <integer>, then the result value is a <rational> with the receiver as the numerator and the operand as the denominator.  If the resulting protocol is <Float>, then the result value is defined by the ISO/IEC 10967 divF . Otherwise, the result is consistent with the mathematical definition of the ISO/IEC 10967 operation div.
If both operands conform to <integer> the result value will conform to <rational>. Otherwise the protocol and representation of the return value are defined by the Default Result Type. If the return value conforms to <scaledDecimal> then the scale of the result is at least the scale of the receiver after conversion if necessary.
If  the result value is outside of the range of the common numeric representation,  the effect of underflow or overflow is implementation defined. If either the receiver or operand are of type <Float> and the operand has a value of zero, the result is implementation defined. The implementation must either signal the ZeroDivide exception or provide a continuation value. For all other numeric representations the ZeroDivide exception is signaled. 
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'number' #'unspecified') )
	returnRule: '[ :receiver :operand |
	| defaultRetType |
	"defaultRetType is Default Conversion Table[rec, op]"
	defaultRetType := ProtocolSpec
		defaultReturnProtocolNameReceiver: receiver
		operand: operand.
	"conformsTo:"
	defaultRetType = #''integer''
		ifTrue: [#''rational'']
		ifFalse:[defaultRetType]
]'
	errors: 'operand = 0 unless receiver or operand are of type <Float>
'
!

ProtocolSpec newMessagePattern: '// operand'
	forProtocolNamed: #'number'
	synopsis: 'Answer the truncated quotient resulting from dividing the receiver by operand. The truncation is towards negative infinity.
'
	definedIn: 'number'
	definition: 'Answer an integer whose value is the truncated result of dividing the receiver by operand, as specified by the ISO/IEC 10967 flooring division operation divf. Truncation is towards negative infinity. The sign of the result is positive if the receiver and operand have the same sign, and negative if the signs are different.
To perform the operation both the receiver and operand must be objects with identical numeric representations. If they have different representations a conversion to a common numeric representation is performed, as specified by the Default Conversion Table, before applying the operation. If the resulting protocol is <integer>, then the result value is defined by the ISO/IEC 10967 operation divf I. If the resulting protocol is <Float>, then the result value is defined by the ISO/IEC 10967 divf F . Otherwise, the result is consistent with the mathematical definition of the ISO/IEC 10967 operation divf.
If the operand has a value of zero the ZeroDivide exception is signaled.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'number' #'unspecified') )
	returnValues: #( #( 'integer' #'unspecified') )
	errors: 'operand = 0 unless receiver or operand are of type <Float>
'
!

ProtocolSpec newMessagePattern: '< operand'
	forProtocolNamed: #'number'
	synopsis: 'Answer true if the receiver is less than operand. Answer false otherwise.
'
	definedIn: 'magnitude'
	definition: 'Answer true if the receiver is less than operand with respect to the ordering defined for them. Answer false otherwise.
It is erroneous if the receiver and operand are not comparable.
The semantics of the natural ordering must be defined by refinement, which may also restrict the type of operand.
'
	refinedIn: 'number'
	refinement: 'Answer true if the operand is numerically less than the receiver, as specified by the ISO/IEC 10967 comparison operation lss. Answer false otherwise.
To perform the operation both the receiver and operand must be objects with identical numeric representations. If they have different representations a conversion to a common numeric representation is performed, as specified by the Default Conversion Table, before applying the operation. If the resulting protocol is <integer>, then the result value is defined by the ISO/IEC 10967 operation lssI. If the resulting protocol is <Float>, then the result value is defined by the ISO/IEC 10967 lssF. Otherwise, the result is consistent with the mathematical definition of the ISO/IEC 10967 operation lss. 
'
	parameters: #( #('operand' 'number' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: '= comparand'
	forProtocolNamed: #'number'
	synopsis: 'Object equivalence test.
'
	definedIn: 'Object'
	definition: 'This message tests whether the receiver and the comparand are equivalent objects at the time the message is processed. Return true if the receiver is equivalent to comparand. Otherwise return false.
The meaning of "equivalent" cannot be precisely defined but the intent is that two objects are considered equivalent if they can be used interchangeably. Conforming protocols may choose to more precisely define the meaning of "equivalent".
The value of
receiver = comparand
is true if and only if the value of
comparand = receiver
would also be true. If the value of
receiver = comparand
is true then the receiver and comparand must have equivalent hash values. Or more formally:
receiver = comparand ?
receiver hash = comparand hash
The equivalence of objects need not be temporally invariant. Two independent invocations of #= with the same receiver and operand objects may not always yield the same results. Note that a collection that uses #= to discriminate objects may only reliably store objects whose hash values do not change while the objects are contained in the collection.
'
	refinedIn: 'number'
	refinement: 'Answer true if the operand is numerically equal to the receiver, as specified by the ISO/IEC 10967 equality operation eq. Answer false if they are not numerically equal or if operand is not a number.
To perform the operation both the receiver and operand must be objects with identical numeric representations. If they have different representations a conversion to a common numeric representation is performed, as specified by the Default Conversion Table, before applying the operation. If the resulting protocol is <integer>, then the result value is defined by the ISO/IEC 10967 operation eqI. If the resulting protocol is <Float>, then the result value is defined by the ISO/IEC 10967 eqF. Otherwise, the result is consistent with the mathematical definition of the ISO/IEC 10967 operation eq. 
Numeric equality is defined by implementation defined conventions regarding round-off error and representation of numbers, hence behavior of this message may differ between platforms.
'
	parameters: #( #('comparand' 'Object' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: '> operand'
	forProtocolNamed: #'number'
	synopsis: 'Answer true if the receiver is greater than operand. Answer false otherwise.
'
	definedIn: 'magnitude'
	definition: 'Answer true if the receiver is greater than operand with respect to the natural ordering. Answer false otherwise.
It is erroneous if the receiver and operand are not comparable.
The semantics of the natural ordering must be defined by refinement, which may also restrict the type of operand.
'
	refinedIn: 'number'
	refinement: 'Answer true if the operand is numerically less than the receiver, as specified by the ISO/IEC 10967 comparison operation gtr. Answer false otherwise.
To perform the operation both the receiver and operand must be objects with identical numeric representations. If they have different representations a conversion to a common numeric representation is performed, as specified by the Default Conversion Table, before applying the operation. If the resulting protocol is <integer>, then the result value is defined by the ISO/IEC 10967 operation gtrI. If the resulting protocol is <Float>, then the result value is defined by the ISO/IEC 10967 gtrF. Otherwise, the result is consistent with the mathematical definition of the ISO/IEC 10967 operation gtr. 
'
	parameters: #( #('operand' 'number' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: '\\ operand'
	forProtocolNamed: #'number'
	synopsis: 'Answer the remainder after integer division of the receiver by the operand.
'
	definedIn: 'number'
	definition: 'Answer the remainder of truncating integer division as specified by the ISO/IEC 10967 remainder operation remf. The remainder has the same sign as operand. To perform the operation both the receiver and operand must be objects with identical numeric representations. If they have different representations a conversion to a common numeric representation is performed, as specified by the Default Conversion Table, before applying the operation. If the resulting protocol is <integer>, then the result value is defined by the ISO/IEC 10967 operation remI. If the resulting protocol is <Float>, then the result value is defined by the ISO/IEC 10967 remF . Otherwise, the result is consistent with the mathematical definition of the ISO/IEC 10967 operation rem.
The protocol and representation of the return value is defined by the Default Result Type. If the return value conforms to <scaledDecimal> then the scale of the result is at least the scale of the receiver.
Within the limits of representation, the following invariant should hold:
(receiver // operand) * operand + (receiver \\ operand) = receiver
If the result value is outside of the range of the common numeric representation,  the effect of underflow or overflow is implementation defined. If either the receiver or operand is of type <Float> and the operand has a value of zero, the result is implementation defined. The implementation may signal the ZeroDivide exception or provide a continuation value. For all other numeric representations the ZeroDivide exception is signaled.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'number' #'unspecified') )
	returnRule: '[ :receiver :operand | "Default Result Type"
	ProtocolSpec
		defaultReturnProtocolNameReceiver: receiver
		operand: operand
]'
	errors: 'operand = 0 unless receiver or operand are of type <Float>
'
!

ProtocolSpec newMessagePattern: 'abs'
	forProtocolNamed: #'number'
	synopsis: 'Answer the absolute value of the receiver.
'
	definedIn: 'number'
	definition: 'Return the absolute value of the receiver, as specified by the ISO/IEC 10967 operation abs. If the receiver is greater than or equal to zero, answer an object equal to the receiver. Otherwise answer an object which is equal to the negation of the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'number' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asFloat'
	forProtocolNamed: #'number'
	synopsis: 'Answer a floating-point number approximating the receiver.
'
	definedIn: 'number'
	definition: 'Return the nearest floating-point number to the receiver, as specified by the ISO/IEC 10967 cvt operation.
If an implementation supports multiple representations for floating point numbers, the result is the representation with the smallest precision that will represent a number with the same number of digits as the receiver, truncating to the maximum precision of the representation with the largest precision.
The effect of underflow or overflow is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asFloatD'
	forProtocolNamed: #'number'
	synopsis: 'Answer a d precision floating-point number approximating the receiver .
'
	definedIn: 'number'
	definition: 'Return the nearest floating-point number to the receiver, as specified by the ISO/IEC 10967 cvt operation.
Use the object representation for floating point numbers that corresponds to the representation used for numeric literals with the exponent designation ''d''.
The effect of underflow and overflow is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asFloatE'
	forProtocolNamed: #'number'
	synopsis: 'Answer a floating-point number approximating the receiver.
'
	definedIn: 'number'
	definition: 'Return the nearest floating-point number to the receiver, as specified by the ISO/IEC 10967 cvt operation.
Use the object representation for floating point numbers that corresponds to the representation used for numeric literals with the exponent designation ''e''.
The effect of underflow and overflow is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asFloatQ'
	forProtocolNamed: #'number'
	synopsis: 'Answer a floating-point number approximating the receiver.
'
	definedIn: 'number'
	definition: 'Return the nearest floating-point number to the receiver, as specified by the ISO/IEC 10967 cvt operation.
Use the object representation for floating point numbers that corresponds to the representation used for numeric literals with the exponent designation ''q''.
The effect of underflow and overflow is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Float' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asFraction'
	forProtocolNamed: #'number'
	synopsis: 'Answer a fraction approximating the receiver.
'
	definedIn: 'number'
	definition: 'Answer a fraction that reasonably approximates the receiver. If the receiver is an integral value the result may be <integer>.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'rational' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asInteger'
	forProtocolNamed: #'number'
	synopsis: 'Answer an integer approximating the receiver.
'
	definedIn: 'number'
	definition: 'Answer the result of sending #rounded to the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asScaledDecimal: scale'
	forProtocolNamed: #'number'
	synopsis: 'Answer a scaled decimal number, with a fractional precision of scale, approximating the receiver.
'
	definedIn: 'number'
	definition: 'This is a conversion message. Answer a scaled decimal number, with a fractional precision of scale, which minimizes the difference between the answered value and the receiver.
The effect of underflow and overflow is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('scale' 'integer' #'unspecified') )
	returnValues: #( #( 'scaledDecimal' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'ceiling'
	forProtocolNamed: #'number'
	synopsis: 'Answer the smallest integer greater than or equal to the receiver.
'
	definedIn: 'number'
	definition: 'Answer the smallest integer greater than or equal to the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'floor'
	forProtocolNamed: #'number'
	synopsis: 'Answer the largest integer less than or equal to the receiver.
'
	definedIn: 'number'
	definition: 'Answer the largest integer less than or equal to the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'fractionPart'
	forProtocolNamed: #'number'
	synopsis: 'Answer the fractional part of the receiver.
'
	definedIn: 'number'
	definition: 'Return an object conforming to the protocol of the receiver that is equal to the fractional part of the receiver. Within the limits of representation, the following invariants should hold:
receiver integerPart + receiver fractionPart = receiver
receiver \\1 = receiver fractionPart
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'number' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'integerPart'
	forProtocolNamed: #'number'
	synopsis: 'Answer the integer part of the receiver.
'
	definedIn: 'number'
	definition: 'Return an object that is equal to the integer part of the receiver.  If the receiver is type <Fraction> return an object conforming to <integer>. Otherwise return an object conforming to the protocol of the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnRule: '[ :receiver |
	"conformsTo is Unary Conversion Table[receiver]"
	ProtocolSpec
		unaryReturnProtocolNameReceiver: receiver
]'
	errors: ''
!

ProtocolSpec newMessagePattern: 'negated'
	forProtocolNamed: #'number'
	synopsis: 'Answer the negation of the receiver.
'
	definedIn: 'number'
	definition: 'Answer an object conforming to the receiver''s protocol that is equal to the negation of the receiver (equal in magnitude to the receiver but opposite in sign), as specified by the ISO/IEC 10967 neg operation.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'number' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'negative'
	forProtocolNamed: #'number'
	synopsis: 'Answer true if the receiver is negative.
'
	definedIn: 'number'
	definition: 'Answer true if the receiver is negative. Answer false otherwise.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'positive'
	forProtocolNamed: #'number'
	synopsis: 'Answer true if the receiver is positive or zero.
'
	definedIn: 'number'
	definition: 'Answer true if the receiver is positive or zero. Answer false otherwise.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'printString'
	forProtocolNamed: #'number'
	synopsis: 'Return a string that describes the receiver.
'
	definedIn: 'Object'
	definition: 'A string consisting of a sequence of characters that describe the receiver are returned as the result.
The exact sequence of characters that describe an object are implementation defined.
'
	refinedIn: 'number'
	refinement: 'Answer a string that is a valid literal representation that approximates the numeric value of the receiver.
'
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'quo: operand'
	forProtocolNamed: #'number'
	synopsis: 'Answer the truncated integer quotient resulting from dividing the receiver by operand. Truncation is towards zero.
'
	definedIn: 'number'
	definition: 'Answer a number whose value is the result of dividing the receiver by operand, as specified by the ISO/IEC 10967 flooring division operation div To perform the operation both the receiver and operand must be objects with identical numeric representations. If they have different representations a conversion to a common numeric representation is performed, as specified by the Default Conversion Table, before applying the operation. If the resulting protocol is <integer>, then the result value is a <rational> with the receiver as the numerator and the operand as the denominator.  If the resulting protocol is <Float>, then the result value is defined by the ISO/IEC 10967 divF . Otherwise, the result is consistent with the mathematical definition of the ISO/IEC 10967 operation div.
The protocol and representation of the return value are defined by the Default Result Type. If the return value conforms to <scaledDecimal> then the scale of the result is at least the scale of the receiver after conversion if necessary.
If the result value is outside of the range of the common numeric representation, the effect of underflow or overflow is implementation defined. If either the receiver or operand are of type <Float> and the operand has a value of zero, the result is implementation defined. The implementation must either signal the ZeroDivide exception or provide a continuation value. For all other numeric representations the ZeroDivide exception is signaled. 
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'number' #'unspecified') )
	returnValues: #( #( 'integer' #'unspecified') )
	errors: 'operand = 0 unless receiver or operand are of type <Float>
Issues
Should be the same as #//.
'
!

ProtocolSpec newMessagePattern: 'raisedTo: operand'
	forProtocolNamed: #'number'
	synopsis: 'Answer the receiver raised to the power operand.
'
	definedIn: 'number'
	definition: 'If operand conforms to <integer>, answer the result of sending #raisedToInteger: with argument operand to the receiver.
Otherwise answer
(receiver asFloat ln * operand) exp.
It is erroneous if the receiver equals zero and the operand is less than or equal to zero, or if the receiver is less than zero. The effect of underflow and overflow is implementation defined.
If the numeric representation of the result has does not have unbounded precision, the effect of underflow or overflow is implementation defined. 
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'number' #'uncaptured') )
	returnValues: #( #( 'number' #'unspecified') )
	errors: 'receiver = 0 and operand <= 0
receiver < 0
'
!

ProtocolSpec newMessagePattern: 'raisedToInteger: operand'
	forProtocolNamed: #'number'
	synopsis: 'Answer the receiver raised to the power operand.
'
	definedIn: 'number'
	definition: 'Answer the receiver raised to the power operand, which must be a whole number. If the operand is a whole number greater than or equal to zero, then the result is the receiver raised to the power operand. If operand is a negative whole number then the result is equivalent to the reciprocal of the absolute value of the receiver raised to the power operand.
It is erroneous if the operand does not conform to the protocol <integer>. If the numeric representation of the result has does not have unbounded precision, the effect of underflow or overflow is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'integer' #'uncaptured') )
	returnValues: #( #( 'number' #'unspecified') )
	errors: 'Receiver is not an integer.

'
!

ProtocolSpec newMessagePattern: 'reciprocal'
	forProtocolNamed: #'number'
	synopsis: 'Answer the reciprocal of the receiver.
'
	definedIn: 'number'
	definition: 'Answer the reciprocal of the receiver, which is equal to the result of the operation (1/receiver). Signal a ZeroDivide exception if the receiver is equal to zero.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnRule: '[ :receiver |
	"conformsTo is Unary Conversion Table[receiver]"
	ProtocolSpec
		unaryReturnProtocolNameReceiver: receiver
]'
	errors: 'receiver = 0

'
!

ProtocolSpec newMessagePattern: 'rem: operand'
	forProtocolNamed: #'number'
	synopsis: 'Answer the remainder after integer division of the receiver by the operand.
'
	definedIn: 'number'
	definition: 'Answer the remainder with respect to integer division, as specified by the ISO/IEC 10967 remainder operation rem. The sign of the remainder is the same sign as the receiver. Within the limits of representation, the following invariant should hold:
(receiver quo: operand)*operand + receiver rem: operand) = receiver
To perform the operation both the receiver and operand must be objects with identical numeric representations. If they have different representations a conversion to a common numeric representation is performed, as specified by the Default Conversion Table, 
The protocol and representation of the return value is defined by the Default Result Type. If the return value conforms to <scaledDecimal> then the scale of the result is at least the scale of the receiver after conversion if necessary. If either the receiver or operand are of type <Float> and the operand has a value of zero, the result is implementation defined. The implementation may signal the ZeroDivide exception or provide a continuation value. For all other numeric representations the ZeroDivide exception is signaled. If  the result value is outside of the range of the common numeric representation,  the effect of underflow or overflow is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'number' #'unspecified') )
	returnValues: #( #( 'number' #'unspecified') )
	errors: 'operand = 0 unless receiver or operand are of type <Float>
'
!

ProtocolSpec newMessagePattern: 'roundTo: factor'
	forProtocolNamed: #'number'
	synopsis: 'Answer the number nearest the receiver that is a multiple of factor.
'
	definedIn: 'number'
	definition: 'Answer the number nearest the receiver that is a multiple of factor. The result conforms to either the receiver''s or operand''s protocol, according to the Default Conversion Table.
The result is undefined if factor equals zero. If the numeric representation of the result has does not have unbounded precision, the effect of underflow or overflow is implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('factor' 'number' #'uncaptured') )
	returnRule: '[ :receiver :operand | "Default Result Type"
	ProtocolSpec
		defaultReturnProtocolNameReceiver: receiver
		operand: operand
]'
	errors: ''
!

ProtocolSpec newMessagePattern: 'rounded'
	forProtocolNamed: #'number'
	synopsis: 'Answer the integer nearest the receiver.
'
	definedIn: 'number'
	definition: 'Answer the integer nearest the receiver according  to the following property:  
N rounded = the nearest integer I = N + (N sign * (1/2)) truncated towards zero.
For example, 0.5 rounded = 1 and -0.5 rounded = -1.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'sign'
	forProtocolNamed: #'number'
	synopsis: 'Answer the sign of the receiver.
'
	definedIn: 'number'
	definition: 'Answer 1 if the receiver is positive, 0 if the receiver equals 0, and -1 if it is negative, as specified by the ISO/IEC 10967 operation sign.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'sqrt'
	forProtocolNamed: #'number'
	synopsis: 'Answer the positive square root of the receiver.
'
	definedIn: 'number'
	definition: 'Answer a number equal to the positive square root of the receiver as specified by the ISO/IEC 10967 remainder operation sqrt. If the receiver''s protocol is <integer>, then the result value is defined by the ISO/IEC 10967 operation sqrtI. If the receiver''s protocol is <Float>, then the result value is defined by the ISO/IEC 10967 sqrtF . Otherwise, the result is consistent with the mathematical definition of the ISO/IEC 10967 operation sqrt.
The result is undefined if the receiver is less than zero.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'number' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'squared'
	forProtocolNamed: #'number'
	synopsis: 'Answer the receiver squared.
'
	definedIn: 'number'
	definition: 'Answer a number that is the receiver multiplied by itself. The answer must conform to the same protocol as the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'number' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'strictlyPositive'
	forProtocolNamed: #'number'
	synopsis: 'Answer true if the receiver is greater than zero.
'
	definedIn: 'number'
	definition: 'Answer true if the receiver is greater than zero.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'to: stop'
	forProtocolNamed: #'number'
	synopsis: 'Answer an object conforming to <interval> which represents an arithmetic progression from the receiver to stop in increments of 1.
'
	definedIn: 'number'
	definition: 'Answer an interval which represents an arithmetic progression from the receiver to stop, using the increment 1 to compute each successive element. The elements conform to the receiver''s protocol. Note that stop may not be the last element in the sequence, which is given by the formula
receiver + ((stop - receiver) // 1)
The interval answered will be empty if the receiver is greater than stop.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('stop' 'number' #'unspecified') )
	returnValues: #( #( 'Interval' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'to: step by: stop'
	forProtocolNamed: #'number'
	synopsis: 'Answer an interval which represents an arithmetic progression from receiver to stop in increments of step.
'
	definedIn: 'number'
	definition: 'Answer an interval which represents an arithmetic progression from the receiver to stop, using the increment step to compute each successive element. The value of step can be positive or negative, but it must be non-zero. The elements conform to either the receiver''s or step''s protocol, according to the Default Conversion Table.
Note that stop may not be the last element in the sequence, which is given by the formula
(((stop - receiver) // step) * step) + receiver
The interval answered will be empty if:
1. receiver < stop, and step < 0.
2. receiver > stop, and step > 0.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('stop' 'number' #'unspecified') #('step' 'number' #'unspecified') )
	returnValues: #( #( 'Interval' #'unspecified') )
	errors: 'step = 0
'
!

ProtocolSpec newMessagePattern: 'to: stop by: step do: operation'
	forProtocolNamed: #'number'
	synopsis: 'Evaluate operation for each element of an interval which represents an arithmetic progression from the receiver to stop in increments of step.
'
	definedIn: 'number'
	definition: 'Evaluate operation for each element of an interval starting at the receiver and stopping at stop where each element is step greater than the previous. The value of step can be positive or negative, but it must be non-zero. The elements must all conform to either the receiver''s or step''s protocol, according to the Default Conversion Table.
Note that stop is not necessarily an element in the sequence, which is given by the formula
(((stop - receiver) // step) * step) + receiver
No evaluation takes place if:
1. receiver < stop, and step < 0.
2. receiver > stop, and step > 0.
Implementations are not required to actually create the interval described by the receiver, stop and step. Implementations may restrict the definition of this message to specific classes.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('stop' 'number' #'unspecified') #('operation' 'monadicBlock' #'unspecified') #('step' 'number' #'unspecified') )
	returnValues: #()
	errors: 'step = 0
'
!

ProtocolSpec newMessagePattern: 'to: operation do: stop'
	forProtocolNamed: #'number'
	synopsis: 'Evaluate operation for each element of an interval which represents an arithmetic progression from receiver to stop in increments of 1.
'
	definedIn: 'number'
	definition: 'Evaluate operation for each element of an interval starting at the receiver and stopping at stop where each element is 1 greater than the previous. The elements must all conform to the receiver''s  protocol according to the Default Conversion Table.
Note that stop may not be the last element in the sequence, which is given by the formula
receiver + ((stop - receiver) // 1)
No evaluation takes place if the receiver is greater than stop.
Implementations are not required to actually create the interval described by the receiver and stop.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('stop' 'number' #'unspecified') #('operation' 'monadicBlock' #'unspecified') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'truncateTo: factor'
	forProtocolNamed: #'number'
	synopsis: 'Answer the number nearest the receiver truncated towards zero which is a multiple of factor.
'
	definedIn: 'number'
	definition: 'If the receiver is positive, answer the largest number less than or equal to the receiver which is a multiple of factor. If it is negative, answer the smallest number greater than or equal to the receiver which is a multiple of factor.
The type of the return value depends on the type of the receiver and factor, as indicated by the Default Conversion Table.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('factor' 'number' #'uncaptured') )
	returnRule: '[ :receiver :operand | "Default Result Type"
	ProtocolSpec
		defaultReturnProtocolNameReceiver: receiver
		operand: operand
]'
	errors: ''
!

ProtocolSpec newMessagePattern: 'truncated'
	forProtocolNamed: #'number'
	synopsis: 'Answer an integer equal to the receiver truncated towards zero.
'
	definedIn: 'number'
	definition: 'As specified by the ISO/IEC 10967 truncation operation trunc. If the receiver is positive, answer the largest integer less than or equal to the receiver. If it is negative, answer the smallest integer greater than or equal to the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Object'
	conformsToProtocolNames: #(#'ANY')
	) protocolDescription: '
This protocol describe the behavior that is common to all objects.
Standard Globals
Integer	Conforms to the protocol <Object>. Its language element type is unspecified. This global identifies integer objects.
Number	Conforms to the protocol <Object>. Its language element type is unspecified. This global identifies number objects. 
ScaledDecimal	Conforms to the protocol <Object>. Its language element type is unspecified. This global identifies scaled decimal objects.
Symbol	Conforms to the protocol <Object>. Its language element type is unspecified. This global identifies objects that conform to the protocol <symbol>.
'
!

ProtocolSpec newMessagePattern: '= comparand'
	forProtocolNamed: #'Object'
	synopsis: 'Object equivalence test.
'
	definedIn: 'Object'
	definition: 'This message tests whether the receiver and the comparand are equivalent objects at the time the message is processed. Return true if the receiver is equivalent to comparand. Otherwise return false.
The meaning of "equivalent" cannot be precisely defined but the intent is that two objects are considered equivalent if they can be used interchangeably. Conforming protocols may choose to more precisely define the meaning of "equivalent".
The value of
receiver = comparand
is true if and only if the value of
comparand = receiver
would also be true. If the value of
receiver = comparand
is true then the receiver and comparand must have equivalent hash values. Or more formally:
receiver = comparand ?
receiver hash = comparand hash
The equivalence of objects need not be temporally invariant. Two independent invocations of #= with the same receiver and operand objects may not always yield the same results. Note that a collection that uses #= to discriminate objects may only reliably store objects whose hash values do not change while the objects are contained in the collection.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('comparand' 'Object' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: '== comparand'
	forProtocolNamed: #'Object'
	synopsis: 'Object identity test.
'
	definedIn: 'Object'
	definition: 'This message tests whether the receiver and the comparand are the same object. Return true if the receiver is the same object as comparand. Otherwise return false.
The value of
receiver == comparand
is true if and only if the value of
comparand == receiver
would also be true. If the value of
receiver == comparand
is true then the receiver and comparand must have equivalent identity hash values. Or more formally:
receiver == comparand ?
receiver identityHash = comparand identityHash
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('comparand' 'Object' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'class'
	forProtocolNamed: #'Object'
	synopsis: 'Determine the class of the receiver.
'
	definedIn: 'Object'
	definition: 'If the receiver is an instance object, return the class object defined by the class definition that defines the behavior of the receiver. If the receiver is itself a class object, the result is unspecified except that it must conform to the protocol <classDescription>.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'classDescription' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'copy'
	forProtocolNamed: #'Object'
	synopsis: 'Return a copy of the receiver.
'
	definedIn: 'Object'
	definition: 'Return a new object that must be as similar as possible to the receiver in its initial state and behavior. Any operation that changes the state of the new object should not as a side-effect change the state or behavior of the receiver. Similarly, any change to the receiver should not as a side-effect change the new object.
If the receiver is an identity object, return the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Object' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'doesNotUnderstand: message'
	forProtocolNamed: #'Object'
	synopsis: 'A message was sent to the receiver for which the receiver has no behavior.
'
	definedIn: 'Object'
	definition: 'A message was sent to the receiver for which the receiver has no behavior. Signal a MessageNotUnderstood exception corresponding to the failed message. If the exception resumes, the resumption value is returned as the value of this message.
Conforming protocols may refine this message to perform some action other than signaling the exception.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('message' 'failedMessage' #'unspecified') )
	returnValues: #( #( 'Object' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'error: signalerText'
	forProtocolNamed: #'Object'
	synopsis: 'Announce an error
'
	definedIn: 'Object'
	definition: 'This message is used the announce the occurrence of some type of error condition. The argument should describe the nature of the error. The default behavior is to raise an Error exception as if the message #signal: had been sent to the global Error with signalerText as the argument.
Conforming protocols may refine this message to perform some action other than signaling the exception.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('signalerText' 'readableString' #'unspecified') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'hash'
	forProtocolNamed: #'Object'
	synopsis: 'Return an integer hash code that can be used in conjunction with an #= comparison.
'
	definedIn: 'Object'
	definition: 'An integer value that can be used as a hash code for the receiver is returned. The hash code is intended for use in conjunction with an #= comparison.
The range, minimum, and maximum values of the result is implementation defined.
Any two objects that are considered equivalent using the #= message must have the same hash value. More formally:
receiver = comparand ?
receiver hash = comparand hash
The hash value of an object need not be temporally invariant. Two independent invocations of #hash with the same receiver may not always yield the same results. Note that collections that use #= to discriminate objects may only reliably store objects whose  hash values do not change while the objects are contained in the collection.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'identityHash'
	forProtocolNamed: #'Object'
	synopsis: 'Return an integer hash code that can be used in conjunction with an #== (identity) comparison.
'
	definedIn: 'Object'
	definition: 'An integer value that can be used as a hash code for the receiver is returned. The hash code is intended for use in conjunction with an #== comparison.
The range, minimum, or maximum values of the result is implementation defined.
The identity hash of an object must be temporally invariant.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'isKindOf: candidateClass'
	forProtocolNamed: #'Object'
	synopsis: 'Classify an object.
'
	definedIn: 'Object'
	definition: 'Return true if the receiver is an instance of candidateClass or is an instance of a general subclass of candidateClass. Otherwise return false.
The return value is unspecified if the receiver is a class object or candidateClass is not a class object.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('candidateClass' 'Object' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'isMemberOf: candidateClass'
	forProtocolNamed: #'Object'
	synopsis: 'Determine whether the receiver is an instance of the argument.
'
	definedIn: 'Object'
	definition: 'Return true if the receiver is an instance of candidateClass. Otherwise return false.
The return value is unspecified if the receiver is a class object or candidateClass is not a class object.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('candidateClass' 'Object' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'isNil'
	forProtocolNamed: #'Object'
	synopsis: 'Determine if the receiver is the value of the reserved identifier nil.
'
	definedIn: 'Object'
	definition: 'Determine if the receiver is the same object as the value of the reserved identifier nil. Return true if it is, false if it is not.
The messages #isNil and #notNil must be implemented to produce consistent results. For a given receiver if the result of #isNil is true then the result of #notNil must be false.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'notNil'
	forProtocolNamed: #'Object'
	synopsis: 'Determine if the receiver is not the value of the reserved identifier nil.
'
	definedIn: 'Object'
	definition: 'Determine if the receiver is the same object as the value of the reserved identifier nil. Return false if it is, true if it is not.
The messages #isNil and #notNil must be implemented to produce consistent results. For a given receiver if the result of #isNil is true then the result of #notNil must be false.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'perform: selector'
	forProtocolNamed: #'Object'
	synopsis: 'Send a message using a computed message selector.
'
	definedIn: 'Object'
	definition: 'Send to the receiver a message whose selector is selector. Return the value of that message.
If the receiver does not have a method for selector normal "message not understood" processing is performed as if the computed message hand been sent using a message send expression. If this occurs, selector may be captured.
The perform messages and #respondsTo: must be implemented to produce consistent results. A message to perform a selector, selector, for a given receiver will result in a "message not understood" condition if and only if the value of
receiver respondsTo: selector
is false.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('selector' 'selector' #'unspecified') )
	returnValues: #( #( 'ANY' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'perform: argument1 with: selector'
	forProtocolNamed: #'Object'
	synopsis: 'Send a message using a computed message selector.
'
	definedIn: 'Object'
	definition: 'Send to the receiver a message whose selector is selector and whose argument is argument1. Return the value of that message.
If the receiver does not have a method for selector normal "message not understood" processing is performed as if the computed message hand been sent using a message send expression. If this occurs, selector and the arguments may be captured.
The perform messages and #respondsTo: must be implemented to produce consistent results. A message to perform a selector, selector, for a given receiver will result in a "message not understood" condition if and only if the value of
receiver respondsTo: selector
is false.
Behavior is undefined if the number of arguments does not match that implicitly required by  the syntactic form of the selector.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('argument1' 'ANY' #'unspecified') #('selector' 'selector' #'unspecified') )
	returnValues: #( #( 'ANY' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'perform: argument1 with: argument2 with: selector'
	forProtocolNamed: #'Object'
	synopsis: 'Send a message using a computed message selector.
'
	definedIn: 'Object'
	definition: 'Send to the receiver a message whose selector is selector and whose arguments are argument1, argument2. Return the value of that message.
If the receiver does not have a method for selector normal "message not understood" processing is performed as if the computed message hand been sent using a message send expression. If this occurs, selector and the arguments may be captured.
The perform messages and #respondsTo: must be implemented to produce consistent results. A message to perform a selector, selector, for a given receiver will result in a "message not understood" condition if and only if the value of
receiver respondsTo: selector
is false.
Behavior is undefined if the number of arguments does not match that implicitly required by  the syntactic form of the selector.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('selector' 'selector' #'unspecified') #('argument1' 'ANY' #'unspecified') #('argument2' 'ANY' #'unspecified') )
	returnValues: #( #( 'ANY' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'perform: argument1 with: argument2 with: selector with: argument3'
	forProtocolNamed: #'Object'
	synopsis: 'Send a message using a computed message selector.
'
	definedIn: 'Object'
	definition: 'Send to the receiver a message whose selector is selector and whose arguments are argument1, argument2, etc. Return the value of that message.
If the receiver does not have a method for selector normal "message not understood" processing is performed as if the computed message hand been sent using a message send expression. If this occurs, selector and the arguments may be captured.
The perform messages and #respondsTo: must be implemented to produce consistent results. A message to perform a selector, selector, for a given receiver will result in a "message not understood" condition if and only if the value of
receiver respondsTo: selector
is false.
Behavior is undefined if the number of arguments does not match that implicitly required by  the syntactic form of the selector.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('argument3' 'ANY' #'unspecified') #('argument1' 'ANY' #'unspecified') #('argument2' 'ANY' #'unspecified') #('selector' 'selector' #'unspecified') )
	returnValues: #( #( 'ANY' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'perform: arguments withArguments: selector'
	forProtocolNamed: #'Object'
	synopsis: 'Send a message using a computed message selector and a collection of arguments.
'
	definedIn: 'Object'
	definition: 'Send to the receiver a message whose selector is selector and whose arguments are the elements of arguments. Return the value of that message. The first element of arguments is the first argument, the second element is the second argument, and so on.
If the receiver does not have a method for the selector normal "message not understood" processing is performed as if the computed message hand been sent using a message send expression. If this occurs, selector and arguments could be captured.
The perform messages and #respondsTo: must be implemented to produce consistent results. A message to perform a selector, selector, for a given receiver will result in a "message not understood" condition if and only if the value of
receiver respondsTo: selector
is false.
Behavior is undefined if the number of elements in arguments does not match that implicitly required by  the syntactic form of the selector.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('selector' 'selector' #'unspecified') #('arguments' 'Array' #'unspecified') )
	returnValues: #( #( 'ANY' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'printOn: target'
	forProtocolNamed: #'Object'
	synopsis: 'Write a textual description of the receiver to a stream.
'
	definedIn: 'Object'
	definition: 'The string of characters that would be the result of sending the message #printString to the receiver is written to target. The characters appear on the stream as if each character was, in sequence, written to the stream using the message #nextPut:.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('target' 'puttableStream' #'uncaptured') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'printString'
	forProtocolNamed: #'Object'
	synopsis: 'Return a string that describes the receiver.
'
	definedIn: 'Object'
	definition: 'A string consisting of a sequence of characters that describe the receiver are returned as the result.
The exact sequence of characters that describe an object are implementation defined.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'respondsTo: selector'
	forProtocolNamed: #'Object'
	synopsis: 'Determine if the receiver can respond to a specific message selector.
'
	definedIn: 'Object'
	definition: 'Return true if the receiver has a method in its behavior that has the message selector selector. Otherwise return false.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('selector' 'selector' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'yourself'
	forProtocolNamed: #'Object'
	synopsis: 'No operation. Return the receiver as the result.
'
	definedIn: 'Object'
	definition: 'Return the receiver of the message.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Object' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: '~= comparand'
	forProtocolNamed: #'Object'
	synopsis: 'Object inequality test.
'
	definedIn: 'Object'
	definition: 'This message tests whether the receiver and the comparand are not equivalent objects at the time the message is processed. Return true if the receiver is not equivalent to comparand. Otherwise return false.
The meaning of "equivalent" cannot be precisely defined but the intent is that two objects are considered equivalent if they can be used interchangeably. Conforming protocols may choose to more precisely define the meaning of "equivalent".
The result must be equivalent to the Boolean negation of the result of sending the message #= to the receiver with comparand as the argument.
The value of
receiver ~= comparand
is true if and only if the value of
comparand ~= receiver
would also be true.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('comparand' 'Object' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: '~~ comparand'
	forProtocolNamed: #'Object'
	synopsis: 'Negated object identity test.
'
	definedIn: 'Object'
	definition: 'This message tests whether the receiver and the comparand are different objects. Return true if the receiver is not the same object as comparand. Otherwise return false.
The result must be equivalent to the Boolean negation of the result of sending the message #== to the receiver with comparand as the argument.
The value of
receiver ~~ comparand
is true if and only if the value of
comparand ~~ receiver
would also be true.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('comparand' 'Object' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Object class'
	conformsToProtocolNames: #(#'instantiator' #'classDescription')
	) protocolDescription: '
This protocol describes the behavior the class object whose global identifier is ''Object'', which is the traditional root of the class hierarchy.
This class must be implemented in such a way that it is not fragile. A class is said to be fragile if it is implemented in such a way that subclasses of that class can change the behavior of any standard-specified method without overriding the implementation of those methods. This can happen when a method is implemented to use an auxiliary method that is not specified in the standard, which the subclass then (possibly unintentionally) overrides. The inherited method will then invoke the subclass'' implementation of the auxiliary method rather than the expected implementation in the superclass.
One way to ensure that the implementation of a class is not fragile is to ensure that any message sent to self is either part of the specified behavior for that class or has a selector that begins with an underscore. Alternatively, an implementation may use implementation-specific means to implement these methods in a way that makes them non-fragile.
Standard Globals
Object	Conforms to the protocol <Object class>. It is a class object and the name of a class definition.
'
!

ProtocolSpec newMessagePattern: 'new'
	forProtocolNamed: #'Object class'
	synopsis: 'Create a new object.
'
	definedIn: 'instantiator'
	definition: 'Return a newly created object initialized to a standard initial state.
'
	refinedIn: 'Object class'
	refinement: 'Return a newly created instance of the receiver.
'
	parameters: #()
	returnValues: #( #( 'Object' #'new') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'OrderedCollection'
	conformsToProtocolNames: #(#'sequencedCollection' #'extensibleCollection' #'sequencedContractibleCollection')
	) protocolDescription: '
Represents an ordered, variable sized collection of objects. Elements may be added, removed or inserted, and can be accessed using external integer keys.
'
!

ProtocolSpec newMessagePattern: 'add: newElement'
	forProtocolNamed: #'OrderedCollection'
	synopsis: 'Add newElement to the receiver''s elements.
'
	definedIn: 'extensibleCollection'
	definition: 'This message adds a newElement to the receiver. Unless specifically refined, the position of the newElement in the element traversal order is unspecified.
Conformant protocols may place restrictions on the type of objects that are valid elements. Unless otherwise specified, any object is acceptable.
'
	refinedIn: 'OrderedCollection'
	refinement: 'The newElement is added to the end of the receiver''s elements so that it becomes the last element in the traversal order. This message is equivalent to #addLast: for the receiver with newElement as the parameter.
'
	parameters: #( #('newElement' 'Object' #'captured') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'add: newElement after: target'
	forProtocolNamed: #'OrderedCollection'
	synopsis: 'Add newElement to the receiver immediately following the first element which is equivalent to target.
'
	definedIn: 'OrderedCollection'
	definition: 'Add newElement to the receiver immediately following the first element which is equivalent to target. An element immediately follows another if its index is one greater than that of the other. The order used to determine which of the receiver''s elements is the first to equal target is the traversal order defined by #do: for the receiver.
If the receiver does not include target, the operation fails.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElement' 'Object' #'captured') #('target' 'Object' #'uncaptured') )
	returnValues: #( #( 'Object' #'state') )
	errors: 'If there is no element in the receiver which is equivalent to target.
'
!

ProtocolSpec newMessagePattern: 'add: newElement afterIndex: index'
	forProtocolNamed: #'OrderedCollection'
	synopsis: 'Add newElement to the receiver immediately following the element at position index.
'
	definedIn: 'OrderedCollection'
	definition: 'Add newElement to the receiver immediately following the element at position index. newElement is inserted at position index + 1. If index is equal to 0, newElement becomes the first element of the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElement' 'Object' #'captured') #('index' 'integer' #'uncaptured') )
	returnValues: #( #( 'Object' #'state') )
	errors: 'If index < 0.
If index > receiver''s size.
'
!

ProtocolSpec newMessagePattern: 'add: newElement before: target'
	forProtocolNamed: #'OrderedCollection'
	synopsis: 'Add newElement to the receiver immediately before the first element which is equivalent to target.
'
	definedIn: 'OrderedCollection'
	definition: 'Add newElement to the receiver immediately before the first element which is equivalent to target. An element immediately precedes another if its index is one less than that of the other. The order used to determine which of the receiver''s elements is the first to equal target in the traversal order defined by #do: for the receiver.
If the receiver does not include target, the operation fails.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElement' 'Object' #'captured') #('target' 'Object' #'uncaptured') )
	returnValues: #( #( 'Object' #'state') )
	errors: 'If there is no element in the receiver which is equivalent to target.
If the element which is equal to target is the last element in the receiver.
'
!

ProtocolSpec newMessagePattern: 'add: newElement beforeIndex: index'
	forProtocolNamed: #'OrderedCollection'
	synopsis: 'Add newElement to the receiver immediately before the element at position index.
'
	definedIn: 'OrderedCollection'
	definition: 'Add newElement to the receiver immediately before the element at position index in the receiver. If index equals the receiver''s size plus 1 newElement will be inserted at the end of the receiver.
The parameter index must be a positive integer less than or equal to the receiver''s size plus 1.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('index' 'integer' #'uncaptured') #('newElement' 'Object' #'captured') )
	returnValues: #( #( 'Object' #'state') )
	errors: 'If index <=0.
If index > receiver''s size + 1.
'
!

ProtocolSpec newMessagePattern: 'addAll: target after: newElements'
	forProtocolNamed: #'OrderedCollection'
	synopsis: 'Add each element of newElements to the receiver immediately after the first element in the receiver which is equivalent to target. Answer newElements.
'
	definedIn: 'OrderedCollection'
	definition: 'Add the elements of newElements to the receiver in the traversal order defined by #do: for newElements. The new elements are inserted in the receiver immediately after the first element in the receiver which is equivalent to target.
An element immediately follows another if its index is one greater than that of the other. The order used to determine which of the receiver''s elements is the first to equal target is the traversal order defined by #do: for the receiver.
If the receiver does not include target, the operation fails.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElements' 'collection' #'unspecified') #('target' 'Object' #'uncaptured') )
	returnValues: #()
	errors: 'If there is no element in the receiver which is equivalent to target.
'
!

ProtocolSpec newMessagePattern: 'addAll: index afterIndex: newElements'
	forProtocolNamed: #'OrderedCollection'
	synopsis: 'Insert the elements of newElements in the receiver immediately after the element at position index. Answer newElements.
'
	definedIn: 'OrderedCollection'
	definition: 'Add the elements of newElements to the receiver in the traversal order defined by #do: for newElements. The new elements are inserted in the receiver immediately after the element in the receiver at position index. If index is equal to 0, newElements are inserted at the beginning of the receiver.
The parameter index must be a non-negative integer less than or equal to the receiver''s size.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElements' 'collection' #'unspecified') #('index' 'integer' #'uncaptured') )
	returnValues: #()
	errors: 'If index < 0.
If index > receiver''s size.
'
!

ProtocolSpec newMessagePattern: 'addAll: target before: newElements'
	forProtocolNamed: #'OrderedCollection'
	synopsis: 'Add each element of newElements to the receiver immediately before the first element in the receiver which is equivalent to target. Answer newElements.
'
	definedIn: 'OrderedCollection'
	definition: 'Add the elements of newElements to the receiver in the traversal order defined by #do: for newElements. The new elements are inserted in the receiver immediately before the first element in the receiver which is equivalent to target.
An element immediately follows another if its index is one greater than that of the other. The order used to determine which of the receiver''s elements is the first to equal target is the traversal order defined by #do: for the receiver.
If the receiver does not include target, the operation fails.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElements' 'collection' #'unspecified') #('target' 'Object' #'uncaptured') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'addAll: index beforeIndex: newElements'
	forProtocolNamed: #'OrderedCollection'
	synopsis: 'Insert the elements of newElements in the receiver immediately before the element at position index. Answer newElements.
'
	definedIn: 'OrderedCollection'
	definition: 'Add the elements of newElements to the receiver in the traversal order defined by #do: for newElements. The new elements are inserted in the receiver immediately before the element in the receiver at position index. If index equals the receiver''s size plus 1 newElements will be inserted at the end of the receiver.
The parameter index must be a positive integer less than or equal to the receiver''s size plus 1.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('index' 'integer' #'uncaptured') #('newElements' 'collection' #'unspecified') )
	returnValues: #()
	errors: 'If index <=0.
If index > receiver''s size + 1.
'
!

ProtocolSpec newMessagePattern: 'addAllFirst: newElements'
	forProtocolNamed: #'OrderedCollection'
	synopsis: 'Add each element of newElements to the beginning of the receiver''s elements. Answer newElements.
'
	definedIn: 'OrderedCollection'
	definition: 'This message is used to iteratively add each element of a given collection to the beginning of the receiver''s elements.
The operation is equivalent to adding each successive element of newElements to the receiver using the #addFirst: message with the element as the parameter, where the newElements are traversed in the order specified by the #reverseDo: message for newElements.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElements' 'sequencedCollection' #'unspecified') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'addAllLast: newElements'
	forProtocolNamed: #'OrderedCollection'
	synopsis: 'Add each element of newElements to the end of the receiver''s elements. Answer newElements.
'
	definedIn: 'OrderedCollection'
	definition: 'This message is used to iteratively add each element of a given collection to the end of the receiver''s elements.
The operation is equivalent to adding each successive element of newElements to the receiver using the #addLast: message with the element as the parameter, where the newElements are traversed in the order specified by the #do: message for newElements.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElements' 'sequencedCollection' #'unspecified') )
	returnValues: #( #( 'sequencedCollection' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'addFirst: newElement'
	forProtocolNamed: #'OrderedCollection'
	synopsis: 'Add newElement to the beginning of the receiver''s elements. Answer newElement.
'
	definedIn: 'OrderedCollection'
	definition: 'The newElement is added to the beginning of the receiver''s elements so that it becomes the first element in the traversal order.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElement' 'Object' #'captured') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'addLast: newElement'
	forProtocolNamed: #'OrderedCollection'
	synopsis: 'Add newElement to the end of the receiver''s elements. Answer newElement.
'
	definedIn: 'OrderedCollection'
	definition: 'The newElement is added to the end of the receiver''s elements so that it becomes the last element in the traversal order.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElement' 'Object' #'captured') )
	returnValues: #()
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'OrderedCollection factory'
	conformsToProtocolNames: #(#'initializableCollection factory')
	) protocolDescription: '
This protocol defines the behavior of objects that can be used to create fixed sized ordered collections of objects which can be accessed externally using integer keys.
Standard Globals
OrderedCollection	Conforms to the protocol <OrderedCollection factory>. Its language element type is unspecified. This is a factory and discriminator for collections that conform to <OrderedCollection>.
'
!

ProtocolSpec newMessagePattern: 'new'
	forProtocolNamed: #'OrderedCollection factory'
	synopsis: 'Create a new object.
'
	definedIn: 'instantiator'
	definition: 'Return a newly created object initialized to a standard initial state.
'
	refinedIn: 'OrderedCollection factory'
	refinement: 'Create a new <OrderedCollection> that is optimized to store an implementation defined number of elements. The new collection initially contains no elements.
'
	parameters: #()
	returnValues: #( #( 'OrderedCollection' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'new: count'
	forProtocolNamed: #'OrderedCollection factory'
	synopsis: 'Create a new collection. The parameter count constrains the number of elements in the result.
'
	definedIn: 'collection factory'
	definition: 'Return a new collection that has space for at least count elements.
Conforming protocols may refine this message. In particular, the effect of the parameter count should be specified in refinements. It can be used to specify the exact number of elements, the minimum number, or in some cases can even be interpreted as a hint from the programmer, with no guarantee that the requested number of instance variables will actually be allocated.
Unless otherwise stated the initial values of elements of the new instance of the receiver are unspecified.
'
	refinedIn: 'OrderedCollection factory'
	refinement: 'The parameter count represents a hint for space allocation. The new collection is to optimized to contain count elements. The new collection initially contains no elements.
'
	parameters: #( #('count' 'integer' #'unspecified') )
	returnValues: #( #( 'OrderedCollection' #'new') )
	errors: 'count<0

'
!

ProtocolSpec newMessagePattern: 'with: element1'
	forProtocolNamed: #'OrderedCollection factory'
	synopsis: 'Create a collection initially containing the argument element.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing one element.The collection contains the argument as its element.
Conforming protocols may impose restrictions on the values of the argument and hence the element type.
'
	refinedIn: 'OrderedCollection factory'
	refinement: 'The argument is at index position 1.
'
	parameters: #( #('element1' 'Object' #'captured') )
	returnValues: #( #( 'OrderedCollection' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element1 with: element2'
	forProtocolNamed: #'OrderedCollection factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing two elements.  The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'OrderedCollection factory'
	refinement: 'The first argument is at index position 1, the second argument is at index position 2.
'
	parameters: #( #('element1' 'Object' #'captured') #('element2' 'Object' #'captured') )
	returnValues: #( #( 'OrderedCollection' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element1 with: element2 with: element3'
	forProtocolNamed: #'OrderedCollection factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing three elements.  The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'OrderedCollection factory'
	refinement: 'The first argument is at index position 1, the second argument is at index position 2, and so on.
'
	parameters: #( #('element1' 'Object' #'captured') #('element2' 'Object' #'captured') #('element3' 'Object' #'captured') )
	returnValues: #( #( 'OrderedCollection' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element3 with: element1 with: element4 with: element2'
	forProtocolNamed: #'OrderedCollection factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing four elements.  The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'OrderedCollection factory'
	refinement: 'The first argument is at index position 1, the second argument is at index position 2, and so on.
'
	parameters: #( #('element4' 'Object' #'captured') #('element2' 'Object' #'captured') #('element3' 'Object' #'captured') #('element1' 'Object' #'captured') )
	returnValues: #( #( 'OrderedCollection' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'withAll: newElements'
	forProtocolNamed: #'OrderedCollection factory'
	synopsis: 'Create a collection containing only the elements of newElements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection whose elements are the elements of newElements.
Conforming protocols may impose restrictions on the values of newElements.
'
	refinedIn: 'OrderedCollection factory'
	refinement: 'If the elements of newElements are ordered then their ordering establishing their index positions in the new collection.
'
	parameters: #( #('newElements' 'collection' #'unspecified') )
	returnValues: #( #( 'OrderedCollection' #'new') )
	errors: 'If any of the elements of newElements do not meet the element type constraints of the result object





'
!

(ProtocolSpec newProtocolNamed: #'puttableStream'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
An object conforming to <puttableStream> allows objects to be added to its past sequence values.
'
!

ProtocolSpec newMessagePattern: 'cr'
	forProtocolNamed: #'puttableStream'
	synopsis: 'Writes an end-of-line sequence to the receiver.
'
	definedIn: 'puttableStream'
	definition: 'A sequence of character objects that constitute the implementation-defined end-of-line sequence is added to the receiver in the same manner as if the message #nextPutAll: was sent to the receiver with an argument string whose elements are the sequence of characters.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #()
	errors: 'It is erroneous if any element of the end-of-line sequence is an object that does not conform to the receiver''s sequence value type.
'
!

ProtocolSpec newMessagePattern: 'flush'
	forProtocolNamed: #'puttableStream'
	synopsis: 'Update a stream''s backing store.
'
	definedIn: 'puttableStream'
	definition: 'Upon return, if the receiver is a write-back stream, the state of the stream backing store must be consistent with the current state of the receiver.
If the receiver is not a write-back stream, the effect of this message is unspecified.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'nextPut: anObject'
	forProtocolNamed: #'puttableStream'
	synopsis: 'Writes the argument to the stream.
'
	definedIn: 'puttableStream'
	definition: 'Appends anObject to the receiver''s past sequence values. If the receiver''s future sequence values is not empty, removes its first object.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('anObject' 'Object' #'captured') )
	returnValues: #()
	errors: 'It is erroneous if anObject is an object that does not conform to the receiver''s sequence value type.

'
!

ProtocolSpec newMessagePattern: 'nextPutAll: aCollection'
	forProtocolNamed: #'puttableStream'
	synopsis: 'Enumerates the argument, adding each element to the receiver
'
	definedIn: 'puttableStream'
	definition: 'Has the effect of enumerating the aCollection with the message #do: and adding each element to the receiver with #nextPut:. That is,
aCollection do: [:each | receiver nextPut: each]
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('aCollection' 'collection' #'uncaptured') )
	returnValues: #()
	errors: 'It is erroneous if any element of aCollection is an object that does not conform to the receiver''s sequence value type.
'
!

ProtocolSpec newMessagePattern: 'space'
	forProtocolNamed: #'puttableStream'
	synopsis: 'Writes a space character to the receiver.
'
	definedIn: 'puttableStream'
	definition: 'The effect is the same as sending the message #nextPut: to the receiver with an argument that is the object that is the value returned when the message #space is sent to the standard global Character.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #()
	errors: 'It is erroneous if the space character is an object that does not conform to the receiver''s sequence value type.
'
!

ProtocolSpec newMessagePattern: 'tab'
	forProtocolNamed: #'puttableStream'
	synopsis: 'Writes a tab character to the receiver.
'
	definedIn: 'puttableStream'
	definition: 'The effect is the same as sending the message #nextPut: to the receiver with an argument that is the object that is the value returned when the message #tab is sent to the standard global Character.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #()
	errors: 'It is erroneous if the tab character is an object that does not conform to the receiver''s sequence value type.





'
!

(ProtocolSpec newProtocolNamed: #'rational'
	conformsToProtocolNames: #(#'number')
	) protocolDescription: '
Rational numbers may be either integers or fractions.  An integer is logically a fraction whose denominator is one. This protocol is necessary because some integer and most fraction operations can produce results that may be either an integer or a fraction.
'
!

ProtocolSpec newMessagePattern: 'denominator'
	forProtocolNamed: #'rational'
	synopsis: 'Answer the denominator of the receiver.
'
	definedIn: 'rational'
	definition: 'Treating the receiver as a fraction, answer the lowest common denominator of the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'numerator'
	forProtocolNamed: #'rational'
	synopsis: 'Answer the numerator of the receiver.
'
	definedIn: 'rational'
	definition: 'Treating the receiver as a fraction reduced to its lowest common denominator, answer the integer numerator.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'readableString'
	conformsToProtocolNames: #(#'sequencedReadableCollection' #'magnitude')
	) protocolDescription: '
Provides protocol for string operations such as copying, comparing, replacing, converting, indexing, and matching. All objects that conform to the protocol <readableString> are comparable.
'
!

ProtocolSpec newMessagePattern: ', operand'
	forProtocolNamed: #'readableString'
	synopsis: 'Answer a new collection which is the concatenation of the receiver and operand.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a new collection containing all of the receiver''s elements in their original order followed by all of the elements of operand, in their original order. The size of the new collection is equal to the sum of the sizes of the receiver and operand, as defined by the #size message.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
Unless specifically refined, this message is defined to answer an instance of the same type as the receiver.
'
	refinedIn: 'readableString'
	refinement: 'The parameter operand must be a <readableString>.
'
	parameters: #( #('operand' 'readableString' #'uncaptured') )
	returnValues: #( #( 'readableString' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: '< operand'
	forProtocolNamed: #'readableString'
	synopsis: 'Answer true if the receiver is less than operand. Answer false otherwise.
'
	definedIn: 'magnitude'
	definition: 'Answer true if the receiver is less than operand with respect to the ordering defined for them. Answer false otherwise.
The result is undefined if the receiver and operand are not comparable.
The semantics of the natural ordering must be defined by refinement, which may also restrict the type of operand.
'
	refinedIn: 'readableString'
	refinement: 'Answer true if the receiver collates before operand, according to the implementation defined collating algorithm. Answer false otherwise.
'
	parameters: #( #('operand' 'readableString' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: '<= operand'
	forProtocolNamed: #'readableString'
	synopsis: 'Answer true if the receiver is less than or equal to operand. Answer false otherwise.
'
	definedIn: 'magnitude'
	definition: 'Answer true if the receiver would answer true to either the #< or #= message with operand as the parameter. Answer false otherwise.
The result is undefined if the receiver and operand are not comparable.
'
	refinedIn: 'readableString'
	refinement: 'Answer true if the receiver answers true to either the #< or #sameAs: messages with operand as the parameter. Answer false otherwise.
'
	parameters: #( #('operand' 'readableString' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: '> operand'
	forProtocolNamed: #'readableString'
	synopsis: 'Answer true if the receiver is greater than operand. Answer false otherwise.
'
	definedIn: 'magnitude'
	definition: 'Answer true if the receiver is greater than operand with respect to the natural ordering. Answer false otherwise.
The result is undefined if the receiver and operand are not comparable.
The semantics of the natural ordering must be defined by refinement, which may also restrict the type of operand.
'
	refinedIn: 'readableString'
	refinement: 'Answer true if the receiver collates after operand, according to the implementation defined collating algorithm. Answer false otherwise.
'
	parameters: #( #('operand' 'readableString' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: '>= operand'
	forProtocolNamed: #'readableString'
	synopsis: 'Answer true if the receiver is greater than or equal to operand. Answer false otherwise.
'
	definedIn: 'magnitude'
	definition: 'Answer true if the receiver answers true to either the #> or #= message with operand as the parameter. Answer false otherwise.
The result is undefined if the receiver and operand are not comparable.
'
	refinedIn: 'readableString'
	refinement: 'Answer true if the receiver answers true to either the #> or #sameAs: messages with operand as the parameter. Answer false otherwise.
'
	parameters: #( #('operand' 'readableString' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asLowercase'
	forProtocolNamed: #'readableString'
	synopsis: 'Answer a new string which contains all of the elements of the receiver converted to their lower case equivalents.
'
	definedIn: 'readableString'
	definition: 'Answer a new string which contains all of the elements of the receiver converted to their lower case equivalents. Individual element of the string are converted as if they were receivers of the message #asLowercase.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'readableString' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asString'
	forProtocolNamed: #'readableString'
	synopsis: 'Answer a string containing the same characters as the receiver.
'
	definedIn: 'readableString'
	definition: 'Answer a string containing the same characters as the receiver, in their original order.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asSymbol'
	forProtocolNamed: #'readableString'
	synopsis: 'Answer a symbol containing the same characters as the receiver.
'
	definedIn: 'readableString'
	definition: 'Answer a symbol containing the same characters as the receiver, in their original order.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'symbol' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asUppercase'
	forProtocolNamed: #'readableString'
	synopsis: 'Answer a new string which contains all of the elements of the receiver converted to their upper case equivalents.
'
	definedIn: 'readableString'
	definition: 'Answer a new string which contains all of the elements of the receiver converted to their upper case equivalents.  Individual element of the string are converted as if they were receivers of the message #asUppercase.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'readableString' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'copyReplaceAll: targetElements with: replacementElements'
	forProtocolNamed: #'readableString'
	synopsis: 'Answer a new collection in which all subsequences of elements in the receiver matching targetElements are replaced in the new collection by the elements in replacementElements.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a new collection with the elements of the receiver in their original order, except where a subsequence in the receiver matches targetElements. A subsequence in the receiver is said to match the elements of targetElements if:
1. They have the same number of elements.
2. For all indices of the subsequence, the element in the subsequence at a given index is equivalent to the element in targetElements at the same index.
Where a subsequence match is found, the elements from replacementElements are placed in the new collection instead.
Unless specifically refined, this message is defined to answer an instance of the same class as the receiver.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: 'readableString'
	refinement: 'The elements of targetElements and replacementElements must conform to the protocol <Character> and be valid elements for the result.
'
	parameters: #( #('replacementElements' 'sequencedReadableCollection' #'unspecified') #('targetElements' 'sequencedReadableCollection' #'uncaptured') )
	returnValues: #( #( 'readableString' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'copyReplaceFrom: stop to: replacementElements with: start'
	forProtocolNamed: #'readableString'
	synopsis: 'Answer a new collection, containing the same elements as the receiver, but with the elements in the receiver between start and stop inclusive replaced by the elements in replacementElements.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'This message can be used to insert, append, or replace. The size of replacementElements (as defined by #size) need not be the same as the number of elements being replaced. There are three cases:
1. If stop = start - 1 , and start is less than or equal to the size of the receiver, then the replacementElements are inserted between the elements at index stop and start. None of the receiver''s elements are replaced.
2. If stop = the size of the receiver and start = stop + 1, then the operation is an append, and the replacementElements are placed at the end of the new collection.
3. Otherwise, the operation is a replacement, and the receiver''s elements in the given range are replaced by the elements from replacementElements.
In all cases, the resulting collection consists of the receiver''s elements from indices 1 to start - 1 in their original order, followed by the elements of replacementElements, followed by the remainder of the receiver''s elements from index stop + 1 in their original order. The size of the result is the receiver''s size - (stop - start + 1) + the replacementElements size.
The parameters start and stop must be positive.
Unless specifically refined, this message is defined to answer an instance of the same class as the receiver''s class.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: 'readableString'
	refinement: 'The elements of replacementElements must be characters.
'
	parameters: #( #('start' 'integer' #'uncaptured') #('stop' 'integer' #'uncaptured') #('replacementElements' 'sequencedReadableCollection' #'unspecified') )
	returnValues: #( #( 'readableString' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'copyReplacing: replacementElement withObject: targetElement'
	forProtocolNamed: #'readableString'
	synopsis: 'Answer a new collection conforming to the same protocols as the receiver, in which any occurrences of targetElement are replaced by replacementElement.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'A new collection is created and initialized with the same elements as the receiver in the same order, except that any objects in the receiver which are equivalent to targetElement are replaced in the new collection by replacementElement.
Unless specifically refined, this message is defined to answer an instance of the same class as the receiver.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: 'readableString'
	refinement: 'The parameters targetElement and replacementElement must be characters.
'
	parameters: #( #('replacementElement' 'Character' #'captured') #('targetElement' 'Character' #'uncaptured') )
	returnValues: #( #( 'readableString' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'copyWith: newElement'
	forProtocolNamed: #'readableString'
	synopsis: 'Answer a new collection containing the same elements as the receiver, with newElement added.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a new collection with size one greater than the size of the receiver containing the elements of the receiver and newElement placed at the end.
Unless specifically refined, this message is defined to answer an instance of the same class as the receiver.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: 'readableString'
	refinement: 'The parameter newElement must be characters.
'
	parameters: #( #('newElement' 'Character' #'captured') )
	returnValues: #( #( 'readableString' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'sameAs: operand'
	forProtocolNamed: #'readableString'
	synopsis: 'Answer true if the receiver collates the same as operand. Answer false otherwise.
'
	definedIn: 'readableString'
	definition: 'Answer true if the receiver collates the same as operand, according to the implementation-defined collating algorithm. Answer false otherwise.
This message differs from the #= message because two strings which are not equal can collate the same, and because the receiver and operand do not need to conform to the same protocols.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'readableString' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'subStrings: separators'
	forProtocolNamed: #'readableString'
	synopsis: 'Answer an array containing the substrings in the receiver separated by the elements of separators.
'
	definedIn: 'readableString'
	definition: 'Answer an array of strings. Each element represents a group of characters separated by any of the characters in the list of separators.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('separators' 'sequencedReadableCollection' #'uncaptured') )
	returnValues: #( #( 'Array' #'unspecified') )
	errors: 'If the list of separators contains anything other than characters.










'
!

(ProtocolSpec newProtocolNamed: #'readFileStream'
	conformsToProtocolNames: #(#'gettableStream' #'FileStream')
	) protocolDescription: '
Provides protocol for traversing and reading elements in an external file. The sequence values are provided by the external file which also serves as the stream backing store. 
'
!

ProtocolSpec newMessagePattern: 'next: amount'
	forProtocolNamed: #'readFileStream'
	synopsis: 'Returns a collection of the next amount objects in the stream.
'
	definedIn: 'gettableStream'
	definition: 'A number of objects equal to amount are removed from the receiver''s future sequence values and appended, in order, to the end of the receiver''s past sequence values. A collection whose elements consist of those objects, in the same order, is returned. If amount is equal to 0 an empty collection is returned. 
The result is undefined if amount is larger than the number of objects in the receiver''s future sequence values. 
'
	refinedIn: 'readFileStream'
	refinement: 'The result collection will conform to the same protocols as the object that would result if the message #contents was sent to the receiver.
'
	parameters: #( #('amount' 'integer' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: 'amount < 0
'
!

ProtocolSpec newMessagePattern: 'upTo: anObject'
	forProtocolNamed: #'readFileStream'
	synopsis: 'Returns a collection of all of the objects in the receiver up to, but not including, the next occurrence of the argument. Sets the stream to read the object just after the next occurrence of the argument. If the argument is not found and the end of the stream is encountered, an ordered collection of the objects read is returned.
'
	definedIn: 'gettableStream'
	definition: 'Each object in the receiver''s future sequence values up to and including the first occurrence of an object that is equivalent to anObject is removed from the future sequence values and appended to the receiver''s past sequence values. A collection, containing, in order, all of the transferred objects except the object (if any) that is equivalent to anObject is returned. If the receiver''s future sequence values is initially empty, an empty collection is returned. 
'
	refinedIn: 'readFileStream'
	refinement: 'The result collection will conform to the same protocols as the object that would result if the message #contents was sent to the receiver.
'
	parameters: #( #('anObject' 'Object' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'ReadStream'
	conformsToProtocolNames: #(#'collectionStream' #'gettableStream')
	) protocolDescription: '
An object conforming to <ReadStream> has a positionable sequence of values that can be read. The sequence values are provided by a sequenced collection that serves as the stream backing store. 
'
!

ProtocolSpec newMessagePattern: 'next: amount'
	forProtocolNamed: #'ReadStream'
	synopsis: 'Returns a collection of the next amount objects in the stream.
'
	definedIn: 'gettableStream'
	definition: 'A number of objects equal to amount are removed from the receiver''s future sequence values and appended, in order, to the end of the receiver''s past sequence values. A collection whose elements consist of those objects, in the same order, is returned. If amount is equal to 0 an empty collection is returned. 
The result is undefined if amount is larger than the number of objects in the receiver''s future sequence values. 
'
	refinedIn: 'ReadStream'
	refinement: 'The result collection will conform to the same protocols as the object that would result if the message #select: was sent to the object that serves as the stream backing store.
'
	parameters: #( #('amount' 'integer' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: 'amount < 0

'
!

ProtocolSpec newMessagePattern: 'upTo: anObject'
	forProtocolNamed: #'ReadStream'
	synopsis: 'Returns a collection of all of the objects in the receiver up to, but not including, the next occurrence of the argument. Sets the stream to read the object just after the next occurrence of the argument. If the argument is not found and the end of the stream is encountered, an ordered collection of the objects read is returned.
'
	definedIn: 'gettableStream'
	definition: 'Each object in the receiver''s future sequence values up to and including the first occurrence of an object that is equivalent to anObject is removed from the future sequence values and appended to the receiver''s past sequence values. A collection, containing, in order, all of the transferred objects except the object (if any) that is equivalent to anObject is returned. If the receiver''s future sequence values is initially empty, an empty collection is returned.
'
	refinedIn: 'ReadStream'
	refinement: 'The result collection will conform to the same protocols as the object that would result if the message #select: was sent to the object that serves as the stream backing store.
'
	parameters: #( #('anObject' 'Object' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'ReadStream factory'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
<ReadStream factory> provides for the creation of objects conforming to the <ReadStream> protocol whose sequence values are supplied by a collection.
Standard Globals
ReadStream	Conforms to the protocol <ReadStream factory>. Its language element type is unspecified. This is a factory for streams that conform to <ReadStream>.
'
!

ProtocolSpec newMessagePattern: 'on: aCollection'
	forProtocolNamed: #'ReadStream factory'
	synopsis: 'Returns a stream that reads from the given collection.
'
	definedIn: 'ReadStream factory'
	definition: 'Returns an object conforming to <ReadStream> whose future sequence values initially consist of the elements of aCollection and which initially has no past sequence values. The ordering of the sequence values is the same as the ordering used by #do: when sent to aCollection. The stream backing store of the returned object is aCollection. 
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('aCollection' 'sequencedReadableCollection' #'captured') )
	returnValues: #( #( 'ReadStream' #'new') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'ReadWriteStream'
	conformsToProtocolNames: #(#'ReadStream' #'WriteStream')
	) protocolDescription: '
An object conforming to <ReadWriteStream> can read from its future sequence values or write to its past sequence values. The sequence values are provided by a collection that serves as the stream backing store. It is implementation defined whether a <ReadWriteStream> is a write-back stream. Even if a <ReadWriteStream> is not a write-back stream, its associated collection may be subject to modification in an unspecified manner as long as it is associated with the stream.

'
!

(ProtocolSpec newProtocolNamed: #'ReadWriteStream factory'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
<ReadWriteStreamfactory> provides for the creation of objects conforming to the <WriteStream> protocol whose sequence values are supplied by a collection.
Standard Globals
ReadWriteStream	Conforms to the protocol <ReadWriteStream factory>. Its language element type is unspecified. This is a factory for streams that conform to <ReadWriteStream>.
'
!

ProtocolSpec newMessagePattern: 'with: aCollection'
	forProtocolNamed: #'ReadWriteStream factory'
	synopsis: 'Returns a stream that reads the elements of the given collection and can write new elements.
'
	definedIn: 'ReadWriteStream factory'
	definition: 'Returns an object conforming to <ReadWriteStream> whose past sequence values initially consist of the elements of aCollection and which initially has no future sequence values. The ordering of the sequence values is the same as the ordering used by #do: when sent to aCollection. The stream backing store of the returned object is aCollection. The sequence value type of the write stream is the element type of aCollection. Any restrictions on objects that may be elements of aCollection also apply to the stream''s sequence elements.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('aCollection' 'sequencedCollection' #'captured') )
	returnValues: #( #( 'ReadWriteStream' #'new') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'scaledDecimal'
	conformsToProtocolNames: #(#'number')
	) protocolDescription: '
Provides a numeric representation of fixed point decimal numbers. The representation must be able to accurately represent decimal fractions. The standard recommends that the implementation of this protocol support unbounded precision, with no limit to the number of digits before and after the decimal point. If a bounded implementation is provided, then any operation which exceeds the bounds has an implementation-specified  result.
'
!

ProtocolSpec newMessagePattern: 'scale'
	forProtocolNamed: #'scaledDecimal'
	synopsis: 'Answer a integer which represents the total number of digits used to represent the fraction part of the receiver, including trailing zeroes.
'
	definedIn: 'scaledDecimal'
	definition: 'Answer a integer which represents the total number of digits used to represent the fraction part of the receiver, including trailing zeroes.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'selector'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
Defines the protocol supported by literal message selectors. No behavior is defined by this protocols but objects that conform to is can be used to perform dynamically generated message sends  using <Object> #perform: and related messages.
'
!

(ProtocolSpec newProtocolNamed: #'sequencedCollection'
	conformsToProtocolNames: #(#'sequencedReadableCollection')
	) protocolDescription: '
Provides protocol for writing to an ordered collection of objects, whose elements can be accessed using external integer keys.
'
!

ProtocolSpec newMessagePattern: 'at: newElement put: index'
	forProtocolNamed: #'sequencedCollection'
	synopsis: 'Replace the element in the receiver at index with newElement. Answer newElement.
'
	definedIn: 'sequencedCollection'
	definition: 'This message sets one of the receiver''s elements based on index. The newElement is stored at index in the receiver''s elements, replacing any previously stored object. Subsequent retrievals at this index will answer newElement.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('index' 'integer' #'uncaptured') #('newElement' 'Object' #'captured') )
	returnValues: #( #( 'Object' #'state') )
	errors: 'If index < 0.
If index > the receiver''s size.
If newElement does not conform to any element type restrictions of the receiver.
'
!

ProtocolSpec newMessagePattern: 'atAll: indices put: newElement'
	forProtocolNamed: #'sequencedCollection'
	synopsis: 'Replace the elements in the receiver specified by indices with newElement.
'
	definedIn: 'sequencedCollection'
	definition: 'The newElement is stored at each index in the receiver specified by the elements of the indices collection, replacing any previously stored objects at these indices. Subsequent retrievals at these indices will answer newElement.
This message is equivalent to storing newElement in the receiver at each index specified by indices using the #at:put: message for the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('indices' 'collection' #'uncaptured') #('newElement' 'Object' #'captured') )
	returnValues: #()
	errors: 'If any element of indices does not conform to <integer>.
If any element in indices is <= 0 or greater than the receiver''s size.
If newElement does not conform to any element type restrictions of the receiver.
'
!

ProtocolSpec newMessagePattern: 'atAllPut: newElement'
	forProtocolNamed: #'sequencedCollection'
	synopsis: 'Replace all the elements in the receiver with newElement.
'
	definedIn: 'sequencedCollection'
	definition: 'The newElement is stored at each index in the receiver, replacing any previously stored objects.
This message is equivalent to storing newElement in the receiver at each index from 1 to the receiver''s size using the #at:put: message for the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElement' 'Object' #'captured') )
	returnValues: #()
	errors: 'If newElement does not conform to any element type restrictions of the receiver.
'
!

ProtocolSpec newMessagePattern: 'replaceFrom: stop to: replacementElements with: start'
	forProtocolNamed: #'sequencedCollection'
	synopsis: 'Replace the elements of the receiver between positions start and stop inclusive, with the elements of replacementElements in their original order. Answer the receiver.
'
	definedIn: 'sequencedCollection'
	definition: 'The first element of replacementElements is stored in the receiver at position start, the second at position start + 1, etc. Any previously stored elements at these positions are replaced.
If the size of replacementElements is not equal to stop - start + 1, the result of sending this message is unspecified.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('start' 'integer' #'uncaptured') #('replacementElements' 'sequencedReadableCollection' #'unspecified') #('stop' 'integer' #'uncaptured') )
	returnValues: #()
	errors: 'If start < 1 or start > the receiver''s size.
If stop < 1 or stop > the receiver''s size.
If replacementElements size <> stop - start + 1.
'
!

ProtocolSpec newMessagePattern: 'replaceFrom: stop to: replacementElements with: replacementStart startingAt: start'
	forProtocolNamed: #'sequencedCollection'
	synopsis: 'Replace the elements of the receiver between positions start and stop inclusive with the elements of replacementElements, in their original order, starting at position replacementStart. Answer the receiver.
'
	definedIn: 'sequencedCollection'
	definition: 'The element at position replacementStart in replacementElements is stored in the receiver at position start; the element at replacementStart + 1 is stored at position start + 1; etc. Any previously stored elements at these positions in the receiver are replaced.
If the size of replacementElements is not equal to (replacementStart + stop - start), the result of sending this message is unspecified.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('stop' 'integer' #'uncaptured') #('start' 'integer' #'uncaptured') #('replacementStart' 'integer' #'uncaptured') #('replacementElements' 'sequencedReadableCollection' #'unspecified') )
	returnValues: #()
	errors: 'If start < 1 or start > the receiver''s size.
If stop < 1 or stop > the receiver''s size.
If replacementStart < 1 or replacementStart > replacementElements size.
If replacementElements size - replacementStart + 1 < stop - start + 1.
'
!

ProtocolSpec newMessagePattern: 'replaceFrom: replacementElement to: stop withObject: start'
	forProtocolNamed: #'sequencedCollection'
	synopsis: 'Replace the elements of the receiver between start and stop inclusive with replacementElement. Answer the receiver.
'
	definedIn: 'sequencedCollection'
	definition: 'Replace the elements of the receiver between start and stop inclusive with replacementElement. Answer the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('start' 'integer' #'uncaptured') #('replacementElement' 'Object' #'captured') #('stop' 'integer' #'uncaptured') )
	returnValues: #()
	errors: 'If start < 1 or start > the receiver''s size.
If stop < 1 or stop > the receiver''s size.











'
!

(ProtocolSpec newProtocolNamed: #'sequencedContractibleCollection'
	conformsToProtocolNames: #(#'collection')
	) protocolDescription: '
Provides protocol for removing elements from an ordered collection of objects, whose elements can be accessed using external integer keys.
'
!

ProtocolSpec newMessagePattern: 'removeAtIndex: index'
	forProtocolNamed: #'sequencedContractibleCollection'
	synopsis: 'Remove the element of the receiver at position index, and answer the removed element.
'
	definedIn: 'sequencedContractibleCollection'
	definition: 'The element of the receiver which is at position index is removed from the receiver''s elements. Answer the removed element.
index must be a positive integer less than or equal to the receiver''s size.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('index' 'integer' #'uncaptured') )
	returnValues: #( #( 'Object' #'unspecified') )
	errors: 'If index is 0 or negative.
If index is greater than the receiver''s size.
'
!

ProtocolSpec newMessagePattern: 'removeFirst'
	forProtocolNamed: #'sequencedContractibleCollection'
	synopsis: 'Remove and answer the first element of the receiver.
'
	definedIn: 'sequencedContractibleCollection'
	definition: 'The first element of the receiver is removed and answered. The element (if any) that was previously the second element in the traversal order now becomes the first, and the receiver has one fewer elements.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Object' #'state') )
	errors: 'The receiver is empty
'
!

ProtocolSpec newMessagePattern: 'removeLast'
	forProtocolNamed: #'sequencedContractibleCollection'
	synopsis: 'Remove and answer the last element of the receiver.
'
	definedIn: 'sequencedContractibleCollection'
	definition: 'The last element of the receiver is removed and answered. The element (if any) that was previously the second from last element in the traversal order now becomes the last, and the receiver has one fewer elements.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Object' #'state') )
	errors: 'The receiver is empty






'
!

(ProtocolSpec newProtocolNamed: #'sequencedReadableCollection'
	conformsToProtocolNames: #(#'collection')
	) protocolDescription: '
Provides protocol for reading an ordered collection of objects whose elements can be accessed using external integer keys. The keys are between one (1) and the number of elements in the collection, inclusive.
'
!

ProtocolSpec newMessagePattern: ', operand'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer a new collection which is the concatenation of the receiver and operand.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a new collection containing all of the receiver''s elements in their original order followed by all of the elements of operand, in their original order. The size of the new collection is equal to the sum of the sizes of the receiver and operand, as defined by the #size message.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operand' 'sequencedReadableCollection' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: 'If the elements of operand are not suitable for storage in instances of the receiver''s class.
'
!

ProtocolSpec newMessagePattern: '= comparand'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Object equivalence test.
'
	definedIn: 'Object'
	definition: 'This message tests whether the receiver and the comparand are equivalent objects at the time the message is processed. Answer true if the receiver is equivalent to comparand. Otherwise answer false.
The meaning of "equivalent" cannot be precisely defined but the intent is that two objects are considered equivalent if they can be used interchangeably. Conformant protocols may choose to more precisely define the meaning of "equivalent".
The value of
receiver = comparand
is true if and only if the value of
comparand = receiver
would also be true. If the value of
receiver = comparand
is true then the receiver and comparand must have equivalent hash values. Or more formally:
receiver = comparand ?
receiver hash = comparand hash
The equivalence of objects need not be temporally invariant. Two independent invocations of #= with the same receiver and operand objects may not always yield the same results. However, only objects whose implementation of #= is temporally invariant can be reliably stored within collections that use #= to discriminate objects.
'
	refinedIn: 'sequencedReadableCollection'
	refinement: 'Unless specifically refined, the receiver and operand are equivalent if all of the following are true:
1. The receiver and operand are instances of the same class.
2. They answer the same value for the #size message.
3. For all indices of the receiver, the element in the receiver at a given index is equivalent to the element in operand at the same index.
Element lookup is defined by the #at: message for the receiver and operand.
'
	parameters: #( #('comparand' 'Object' #'uncaptured') )
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'after: target'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer the object immediately following the first element which is equivalent to target in the receiver.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer the object immediately following the first element which is equivalent to target in the receiver. An element immediately follows another if its index is one greater than that of the other. The order used to determine which of the receiver''s elements is the first to be equivalent to target is the traversal order defined by #do: for the receiver.
It is an error if the first occurrence of target is the last element of the receiver, or if the receiver does not include target.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('target' 'Object' #'uncaptured') )
	returnValues: #( #( 'Object' #'state') )
	errors: 'If there is no element in the receiver which is equivalent to target.
If the element which is equal to target is the last element in the receiver.
'
!

ProtocolSpec newMessagePattern: 'at: index'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer the element at the position index in the receiver.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'This message defines element retrieval based on an index. Answer the element at the specified index. The result is undefined if the receiver has no element at position index.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('index' 'integer' #'uncaptured') )
	returnValues: #( #( 'Object' #'state') )
	errors: 'If index is <= 0.
If index is greater than the receiver''s size.
'
!

ProtocolSpec newMessagePattern: 'at: exceptionBlock ifAbsent: index'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer the element at the position index in the receiver.  If there is no position corresponding to index in the receiver, then answer the result of evaluating exceptionBlock.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'This message defines element retrieval based on an index. Answer the element at the specified index.  If there is no position corresponding to index in the receiver, then answer the result of evaluating exceptionBlock.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('index' 'integer' #'uncaptured') #('exceptionBlock' 'niladicValuable' #'uncaptured') )
	returnValues: #( #( 'ANY' #'unspecified') #( 'Object' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'before: target'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer the object immediately preceding the first element which is equivalent to target in the receiver.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer the object immediately preceding the first element which is equivalent to target in the receiver. An element immediately precedes another if its index is one less than that of the other.
It is an error if target is the first element of the receiver, or if the receiver does not include target.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('target' 'Object' #'uncaptured') )
	returnValues: #( #( 'Object' #'state') )
	errors: 'If there is no element in the receiver which is equivalent to target.
If the element which is equal to target is the first element in the receiver.
'
!

ProtocolSpec newMessagePattern: 'copyFrom: stop to: start'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer a new collection containing all of the elements of the receiver between the indices start and stop inclusive. If stop < start, the result has a size of zero.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a new collection containing the specified range of elements of the receiver in their original order. The element at index start in the receiver is at index 1 in the new collection; the element at index start+1 is at index 2, etc. If stop is less than start, then the new collection is empty. Otherwise, the size of the new collection is the maximum of (stop - start + 1) and 0.
The parameters start and stop must be positive..
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('start' 'integer' #'uncaptured') #('stop' 'integer' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: 'If stop >= start and (start < 1 or start > the receiver''s size).
If stop >= start and (stop < 1 or stop > the receiver''s size).
'
!

ProtocolSpec newMessagePattern: 'copyReplaceAll: targetElements with: replacementElements'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer a new collection in which all subsequences of elements in the receiver matching targetElements are replaced in the new collection by the elements in replacementElements.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a new collection with the elements of the receiver in their original order, except where a subsequence in the receiver matches targetElements. A subsequence in the receiver is said to match the elements of targetElements if:
1. They have the same number of elements.
2. For all indices of the subsequence, the element in the subsequence at a given index is equivalent to the element in targetElements at the same index.
Starting with the first element of the receiver and proceeding through ascending elements, each non-overlapping subsequence of the receiver matching targetElements is detected.  The result is a copy of the receiver with each detected subsequence replaced by the sequence of elements of replacementElements.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('targetElements' 'sequencedReadableCollection' #'uncaptured') #('replacementElements' 'sequencedReadableCollection' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: 'If any of the elements in replacementElements does not conform to any element type restrictions of instances of the receiver''s class.
'
!

ProtocolSpec newMessagePattern: 'copyReplaceFrom: stop to: replacementElements with: start'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer a new collection, containing the same elements as the receiver, but with the elements in the receiver between start and stop inclusive replaced by the elements in replacementElements.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'This message can be used to insert, append, or replace. The size of replacementElements (as defined by #size) need not be the same as the number of elements being replaced. There are three cases:
1. If stop = start - 1 , and start is less than or equal to the size of the receiver, then the replacementElements are inserted between the elements at index stop and start. None of the receiver''s elements are replaced.
2. If stop = the size of the receiver and start = stop + 1, then the operation is an append, and the replacementElements are placed at the end of the new collection.
3. Otherwise, the operation is a replacement, and the receiver''s elements in the given range are replaced by the elements from replacementElements.
In all cases, the resulting collection consists of the receiver''s elements from indices 1 to start - 1 in their original order, followed by the elements of replacementElements, followed by the remainder of the receiver''s elements from index stop + 1 in their original order. The size of the result is the receiver''s size - (stop - start + 1) + the replacementElements size.
The parameters start and stop must be positive.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('stop' 'integer' #'uncaptured') #('start' 'integer' #'uncaptured') #('replacementElements' 'sequencedReadableCollection' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: 'The elements in replacementElements are not suitable for storage in instances of the receiver''s class.
start > receiver''s size + 1
start < 1
stop > receiver''s size
stop < start - 1
'
!

ProtocolSpec newMessagePattern: 'copyReplaceFrom: stop to: replacementElement withObject: start'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer a new collection conforming to the same protocols as the receiver, in which the elements of the receiver between start and stop inclusive have been replaced with replacementElement.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'This message can be used to insert, append, or replace. There are three cases:
1. If stop = start - 1 , and start is less than or equal to the size of the receiver, then replacementElement is inserted between the elements at index stop and start. None of the receiver''s elements are replaced.
2. If stop = the size of the receiver and start = stop + 1, then the operation is an append, and replacementElement is placed at the end of the new collection.
3. Otherwise, the operation is a replacement, and each of the receiver''s elements in the given range is replaced by replacementElement.
The parameters start and stop must be non-negative.
Collections that by definition enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('start' 'integer' #'uncaptured') #('stop' 'integer' #'uncaptured') #('replacementElement' 'Object' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: 'The replacementElement is not suitable for storage in instances of the receiver''s class.
start > receiver''s size + 1
start < 1
stop > receiver''s size
stop < start - 1
Issues
What does this do? Are there (stop - start + 1) elements equal to the replacementElement, or are that many elements replaced by a single element?
'
!

ProtocolSpec newMessagePattern: 'copyReplacing: replacementElement withObject: targetElement'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer a new collection conforming to the same protocols as the receiver, in which any occurrences of targetElement are replaced by replacementElement.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'A new collection is created and initialized with the same elements as the receiver in the same order, except that any objects in the receiver which are equivalent to targetElement are replaced in the new collection by replacementElement.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('targetElement' 'Object' #'uncaptured') #('replacementElement' 'Object' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: 'If the replacementElement is inappropriate for storage in instances of the receiver''s class.
'
!

ProtocolSpec newMessagePattern: 'copyWith: newElement'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer a new collection containing the same elements as the receiver, with newElement added.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a new collection with size one greater than the size of the receiver containing the elements of the receiver and newElement placed at the end.
Unless specifically refined, this message is defined to answer an instance of the same class as the receiver.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('newElement' 'Object' #'captured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'copyWithout: oldElement'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer a new collection, containing the same elements as the receiver in their original order omitting any elements equivalent to oldElement.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a new collection with all of the elements of the receiver that are not equivalent to oldElement, in their original order.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('oldElement' 'Object' #'uncaptured') )
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'do: operation'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Evaluate operation with each element of the receiver.
'
	definedIn: 'collection'
	definition: 'For each element of the receiver, operation is evaluated with the element as the parameter.
Unless specifically refined, the elements are not traversed in a particular order. Each element is visited exactly once. Conformant protocols may refine this message to specify a particular ordering.
'
	refinedIn: 'sequencedReadableCollection'
	refinement: 'The operation is evaluated with each element of the receiver in indexed order starting at 1. The first element is at index 1, the second at index 2, etc. The index of the last element is equal to the receiver''s size.
'
	parameters: #( #('operation' 'monadicValuable' #'uncaptured') )
	returnValues: #()
	errors: 'If the elements of the receiver are inappropriate for use as arguments to operation.
'
!

ProtocolSpec newMessagePattern: 'findFirst: discriminator'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer the index of the first element of the receiver which causes discriminator to evaluate to true when the element is used as the parameter. Answer zero (0) if no such element is found.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'For each element of the receiver, discriminator is evaluated with the element as the parameter. Answer the index of the first element which results in an evaluation of true; no further elements are considered. If no such element exists in the receiver, answer 0.
The elements are traversed in the order specified by the #do: message for the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('discriminator' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'integer' #'unspecified') )
	errors: 'If an evaluation of discriminator results in an object that does not conform to <boolean> .
If the elements of the receiver are inappropriate for use as arguments to discriminator.
'
!

ProtocolSpec newMessagePattern: 'findLast: discriminator'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer the index of the last element of the receiver which causes discriminator to evaluate to true when the element is used as the parameter. Answer zero (0) if no such element is found.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'For each element of the receiver, in reverse order starting with the last, discriminator is evaluated with the element as the parameter. Answer the index of the first element which results in an evaluation of true; no further elements are considered. Answer 0 if no such element is found in the receiver.
The elements are traversed in the order specified by the #reverseDo: message for the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('discriminator' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'integer' #'unspecified') )
	errors: 'If an evaluation of discriminator results in an object that does not conform to <boolean> .
If the elements of the receiver are inappropriate for use as arguments to discriminator.
'
!

ProtocolSpec newMessagePattern: 'first'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer the first element of the receiver.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer the element at index 1 in the receiver. The result is undefined if the receiver is empty (answers true to the #isEmpty message).
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Object' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'from: stop to: operation do: start'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'For those elements of the receiver between positions start and stop, inclusive, evaluate operation with each element of the receiver.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'For each index in the range start to stop, the operation is evaluated with the element at that index as its argument.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('stop' 'integer' #'uncaptured') #('start' 'integer' #'uncaptured') #('operation' 'monadicValuable' #'uncaptured') )
	returnValues: #()
	errors: 'If the elements of the receiver are inappropriate for use as arguments to operation.
start < 1
stop > receiver''s size
'
!

ProtocolSpec newMessagePattern: 'from: stop to: operation keysAndValuesDo: start'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'For those elements of the receiver between positions start and stop, inclusive, evaluate operation with an element of the receiver as the first argument and the element''s position (index) as the second.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'For each index in the range start to stop, the operation is evaluated with the index as the first argument and the element at that index as the second argument.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('start' 'integer' #'uncaptured') #('stop' 'integer' #'uncaptured') #('operation' 'dyadicValuable' #'uncaptured') )
	returnValues: #()
	errors: 'If the elements of the receiver or its indices are inappropriate for use as arguments to operation.
start < 1
stop > receiver''s size
'
!

ProtocolSpec newMessagePattern: 'indexOf: target'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer the index of the first element of the receiver which is equivalent to target. Answer zero (0) if no such element is found.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer the index of the first element which is equivalent to target; no further elements are considered. Answer 0 if no such element exists in the receiver.
The elements are traversed in the order specified by the #do: message for the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('target' 'Object' #'uncaptured') )
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'indexOf: exceptionHandler ifAbsent: target'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer the index of the first element of the receiver which is equivalent to target. Answer the result of evaluating exceptionHandler with no parameters if no such element is found.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer the index of the first element which is equivalent to target; no further elements are considered. Answer exceptionHandler evaluated with no parameters if no such element is found.
The elements are traversed in the order specified by the #do: message for the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('exceptionHandler' 'niladicValuable' #'uncaptured') #('target' 'Object' #'uncaptured') )
	returnValues: #( #( 'Object' #'unspecified') #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'indexOfSubCollection: targetSequence startingAt: start'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer the index of the first element of the receiver which is the start of a subsequence which matches targetSequence. Start searching at index start in the receiver. Answer 0 if no such subsequence is found.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Each subsequence of the receiver starting at index start is checked for a match with targetSequence. To match, each element of a subsequence of the receiver must be equivalent to the corresponding element of targetSequence. Answer the index of the first element which begins a matching subsequence; no further subsequences are considered. Answer 0 if no such subsequence is found in the receiver, or if targetSequence is empty.
The elements are traversed in the order specified by the #do: message for the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('targetSequence' 'sequencedReadableCollection' #'uncaptured') #('start' 'integer' #'uncaptured') )
	returnValues: #( #( 'integer' #'unspecified') )
	errors: 'start < 1
start > the receiver''s size
'
!

ProtocolSpec newMessagePattern: 'indexOfSubCollection: exceptionHandler startingAt: targetSequence ifAbsent: start'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer the index of the first element of the receiver which is the start of a subsequence which matches targetSequence. Start searching at index start in the receiver. Answer the result of evaluating exceptionHandler with no parameters if no such subsequence is found.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Each subsequence of the receiver starting at index start is checked for a match with targetSequence. To match, each element of a subsequence of the receiver must be equivalent to the corresponding element of targetSequence. Answer the index of the first element which begins a matching subsequence; no further subsequences are considered. Answer the result of evaluating exceptionHandler with no parameters if no such subsequence is found or if targetSequence is empty.
The elements are traversed in the order specified by the #do: message for the receiver.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('targetSequence' 'sequencedReadableCollection' #'uncaptured') #('exceptionHandler' 'niladicValuable' #'uncaptured') #('start' 'integer' #'uncaptured') )
	returnValues: #( #( 'Object' #'unspecified') #( 'integer' #'unspecified') )
	errors: 'start < 1
start > the receiver''s size
'
!

ProtocolSpec newMessagePattern: 'keysAndValuesDo: operation'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Evaluate operation with the index of each element of the receiver, in order, together with the element itself.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'The operation is evaluated with the index of each element of the receiver as the first argument and the element itself as the second argument. Evaluation is in indexed order starting at 1. The first element is at index 1, the second at index 2, etc. The index of the last element is equal to the receiver''s size.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operation' 'dyadicValuable' #'uncaptured') )
	returnValues: #()
	errors: 'If the elements of the receiver are inappropriate for use as arguments to operation.
'
!

ProtocolSpec newMessagePattern: 'last'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer the last element of the receiver.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer the last element of the receiver, the element at the index equal to the receiver''s size. The result is unspecified if the receiver is empty (answers true to the #isEmpty message).
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Object' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'reverse'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Answer a collection with the elements of the receiver arranged in reverse order.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a collection conforming to the same protocols as the receiver, but with its elements arranged in reverse order.
This operation is equivalent to:
1. Create a new collection which conforms to the same protocols as the receiver;
2. Traverse the elements of the receiver in the order specified by the #reverseDo: message, adding each element of the receiver to the new collection;
3. Answer the new collection.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'reverseDo: operation'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Evaluate operation with each element of the receiver in the reverse of the receiver''s standard traversal order.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'For each element of the receiver, evaluate operation with the element as the parameter. The elements are traversed in the opposite order from the #do: message. Each element is visited exactly once.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('operation' 'monadicValuable' #'uncaptured') )
	returnValues: #()
	errors: 'If the elements of the receiver are inappropriate for use as arguments to operation.
'
!

ProtocolSpec newMessagePattern: 'with: operation do: otherCollection'
	forProtocolNamed: #'sequencedReadableCollection'
	synopsis: 'Evaluate operation with each element of the receiver and the corresponding element of otherCollection as parameters.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'For each element of the receiver and the corresponding element of otherCollection, evaluate operation with the receiver''s element as the first parameter, and the element of otherCollection as the second parameter. The receiver and otherCollection must have the same size.
The elements of the receiver and otherCollection are traversed in indexed order starting at 1. The operation is first evaluated with the elements at index 1 in the two <sequencedReadableCollection>s, then index 2, etc.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('otherCollection' 'sequencedReadableCollection' #'uncaptured') #('operation' 'dyadicValuable' #'uncaptured') )
	returnValues: #()
	errors: 'If the elements of the receiver or the elements of otherCollection are inappropriate for use as arguments to operation.
If the receiver''s size is not equal to the size of otherCollection.






'
!

(ProtocolSpec newProtocolNamed: #'sequencedStream'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
An object conforming to <sequencedStream> has a finite number of past and future sequence values. It maintains a position on its sequence values and allows the position to be altered.
'
!

ProtocolSpec newMessagePattern: 'close'
	forProtocolNamed: #'sequencedStream'
	synopsis: 'Disassociate a stream from its backing store.
'
	definedIn: 'sequencedStream'
	definition: 'If the receiver is a write-back stream update its stream backing store as if the message #flush was sent to the receiver. Then eliminate any association between the receiver and its stream backing store. Any system resources associated with the association should be released. The effect of sending any message to the receiver subsequent to this message is undefined.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'contents'
	forProtocolNamed: #'sequencedStream'
	synopsis: 'Returns a collection containing the complete contents of the stream.
'
	definedIn: 'sequencedStream'
	definition: 'Returns a collection that contains the receiver''s past and future sequence values, in order. The size of the collection is the sum of the sizes of the past and future sequence values.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'sequencedReadableCollection' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'isEmpty'
	forProtocolNamed: #'sequencedStream'
	synopsis: 'Returns a Boolean indicating whether there are any sequence values in the receiver.
'
	definedIn: 'sequencedStream'
	definition: 'Returns true if both the set of past and future sequence values of the receiver are empty. Otherwise returns false.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'position'
	forProtocolNamed: #'sequencedStream'
	synopsis: 'Returns the current position of the stream.
'
	definedIn: 'sequencedStream'
	definition: 'Returns the number of sequence values in the receiver''s past sequence values.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'position: amount'
	forProtocolNamed: #'sequencedStream'
	synopsis: 'Sets the current position in a stream of values.
'
	definedIn: 'sequencedStream'
	definition: 'If the number of sequence values in the receiver''s past sequence values is smaller than amount, move objects in sequence from the front of the receiver''s future sequence values to the back of th receiver''s past sequence values until the number of sequence values in the receiver''s past sequence values is equal to amount.
If the number of sequence values in the receiver''s past sequence values is greater than amount, move objects in sequence from the back of the receiver''s past sequence values to the front of th receiver''s future sequence values until the number of sequence values in the receiver''s past sequence values is equal to amount.
If the number of sequence values in the receiver''s past sequence values is equal to amount no action is taken.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('amount' 'integer' #'unspecified') )
	returnValues: #()
	errors: 'If amount is negative.
If the receiver has any sequence values and amount is greater than or equal to the total number of sequence values of the receiver.
'
!

ProtocolSpec newMessagePattern: 'reset'
	forProtocolNamed: #'sequencedStream'
	synopsis: 'Resets the position of the receiver to be at the beginning of the stream of values.
'
	definedIn: 'sequencedStream'
	definition: 'Sets the receiver''s future sequence values to be the current past sequence values appended with the current future sequence values. Make the receiver''s past sequence values be empty.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'setToEnd'
	forProtocolNamed: #'sequencedStream'
	synopsis: 'Set the position of the stream to its end.
'
	definedIn: 'sequencedStream'
	definition: 'All of the receiver''s future sequence values are appended, in sequence, to the receiver''s past sequence values. The receiver then has no future sequence values.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #()
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Set'
	conformsToProtocolNames: #(#'extensibleCollection')
	) protocolDescription: '
Represents an unordered, variable sized collection whose elements can be added or removed, but cannot be individually accessed by external keys. A set is similar to a bag but cannot contain duplicate elements.
'
!

ProtocolSpec newMessagePattern: 'add: newElement'
	forProtocolNamed: #'Set'
	synopsis: 'Add newElement to the receiver''s elements.
'
	definedIn: 'extensibleCollection'
	definition: 'This message adds a newElement to the receiver. Unless specifically refined, the position of the newElement in the element traversal order is unspecified.
Conformant protocols may place restrictions on the type of objects that are valid elements. Unless otherwise specified, any object is acceptable.
'
	refinedIn: 'Set'
	refinement: 'Since sets may not contain duplicates, if there is already an element in the receiver that is equivalent to newElement, this operation has no effect.
The results are undefined if newElement is nil.
The equivalence of newElement with respect to other objects should not be changed while newElement is in the collection, as this would violate the invariant under which the element was placed within the collection.
'
	parameters: #( #('newElement' 'Object' #'captured') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'addAll: newElements'
	forProtocolNamed: #'Set'
	synopsis: 'Add each element of newElements to the receiver''s elements.
'
	definedIn: 'extensibleCollection'
	definition: 'This message adds each element of newElements to the receiver.
The operation is equivalent to adding each element of newElements to the receiver using the #add: message with the element as the parameter. The newElements are traversed in the order specified by the #do: message for newElements.
'
	refinedIn: 'Set'
	refinement: 'Duplicates will not be added.
The results are undefined if newElements contains nil.
'
	parameters: #( #('newElements' 'collection' #'unspecified') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'collect: transformer'
	forProtocolNamed: #'Set'
	synopsis: 'Answer a new collection constructed by gathering the results of evaluating transformer with each element of the receiver.
'
	definedIn: 'collection'
	definition: 'For each element of the receiver, transformer is evaluated with the element as the parameter. The results of these evaluations are collected into a new collection.
The elements are traversed in the order specified by the #do: message for the receiver.
Unless specifically refined, this message is defined to answer an objects conforming to the same protocol as the receiver.
'
	refinedIn: 'Set'
	refinement: 'Duplicates will not be added.
The results are undefined if newElements contains nil.
'
	parameters: #( #('transformer' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'Set' #'new') )
	errors: 'If the elements of the receiver are inappropriate for use as arguments to transformer.
If the result of evaluating the transformer does not conform to any element type restrictions of the collection to be returned.






'
!

(ProtocolSpec newProtocolNamed: #'Set factory'
	conformsToProtocolNames: #(#'initializableCollection factory')
	) protocolDescription: '
This protocol defines the behavior of objects that can be used to create objects that conform to the protocol <Set>.
Standard Globals
Set	Conforms to the protocol <Set factory>. Its language element type is unspecified. This is a factory and discriminator for collections that conform to <Set>.
'
!

ProtocolSpec newMessagePattern: 'new'
	forProtocolNamed: #'Set factory'
	synopsis: 'Create a new object.
'
	definedIn: 'instantiator'
	definition: 'Return a newly created object initialized to a standard initial state.
'
	refinedIn: 'Set factory'
	refinement: 'Return a new <Set> that is optimized to store an arbitrary number of elements. The new collection initially contains no elements.
'
	parameters: #()
	returnValues: #( #( 'Set' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'new: count'
	forProtocolNamed: #'Set factory'
	synopsis: 'Create a new collection. The parameter count constrains the number of elements in the result.
'
	definedIn: 'collection factory'
	definition: 'Return a new collection that has space for at least count elements.
Conforming protocols may refine this message. In particular, the effect of the parameter count should be specified in refinements. It can be used to specify the exact number of elements, the minimum number, or in some cases can even be interpreted as a hint from the programmer, with no guarantee that the requested number of instance variables will actually be allocated.
Unless otherwise stated the initial values of elements of the new instance of the receiver are unspecified.
'
	refinedIn: 'Set factory'
	refinement: 'The parameter count represents a hint for space allocation. The new collection is to optimized to contain count elements. If the value of count is zero the collection should be optimize to hold an arbitrary number of elements. The new collection initially contains no elements.
The new collections conforms to the protocol <Set>.
'
	parameters: #( #('count' 'integer' #'unspecified') )
	returnValues: #( #( 'Set' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'with: element1'
	forProtocolNamed: #'Set factory'
	synopsis: 'Create a collection initially containing the argument element.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing one element.  The collection contains the argument as its element.
Conforming protocols may impose restrictions on the value of the argument and hence the element type.
'
	refinedIn: 'Set factory'
	refinement: 'The result is undefined if the argument is nil.
'
	parameters: #( #('element1' 'Object' #'captured') )
	returnValues: #( #( 'Set' #'new') )
	errors: 'If the argument does not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element1 with: element2'
	forProtocolNamed: #'Set factory'
	synopsis: 'Create a collection initially containing the argument elements
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing two elements.  The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'Set factory'
	refinement: 'The result is undefined if any of the arguments are nil.
'
	parameters: #( #('element1' 'Object' #'captured') #('element2' 'Object' #'captured') )
	returnValues: #( #( 'Set' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element1 with: element3 with: element2'
	forProtocolNamed: #'Set factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing three elements.  The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'Set factory'
	refinement: 'The result is undefined if any of the arguments are nil.
'
	parameters: #( #('element1' 'Object' #'captured') #('element3' 'Object' #'captured') #('element2' 'Object' #'captured') )
	returnValues: #( #( 'Set' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element2 with: element4 with: element1 with: element3'
	forProtocolNamed: #'Set factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing four elements.  The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'Set factory'
	refinement: 'The result is undefined if any of the arguments are nil.
'
	parameters: #( #('element1' 'Object' #'captured') #('element3' 'Object' #'captured') #('element2' 'Object' #'captured') #('element4' 'Object' #'captured') )
	returnValues: #( #( 'Set' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'withAll: newElements'
	forProtocolNamed: #'Set factory'
	synopsis: 'Create a collection containing only the elements of newElements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection whose elements are the elements of newElements.
Conforming protocols may impose restrictions on the values of newElements.
'
	refinedIn: 'Set factory'
	refinement: 'The result is unspecified if newElements contains nil.
'
	parameters: #( #('newElements' 'collection' #'unspecified') )
	returnValues: #( #( 'Set' #'new') )
	errors: 'If any of the elements of newElements do not meet the element type constraints of the result object










'
!

(ProtocolSpec newProtocolNamed: #'signaledException'
	conformsToProtocolNames: #(#'exceptionDescription')
	) protocolDescription: '
This protocol describes the messages that may be sent to the argument of a handler block. These message are used to explicitly control how execution will continue when it leaves the handler block.
'
!

ProtocolSpec newMessagePattern: 'isNested'
	forProtocolNamed: #'signaledException'
	synopsis: 'Determine whether the current exception handler is within the scope of another handler for the same exception.
'
	definedIn: 'signaledException'
	definition: 'Answer true if the handler environment for the current exception handler contains an exception handler that will handle the receiver. Answer false if it does not.
The default action for an exception is not considered to be an enclosing handler. Only the existence of a handler explicitly established using #on:do: will result in this method returning true.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'outer'
	forProtocolNamed: #'signaledException'
	synopsis: 'Evaluate the enclosing exception action for the receiver and return.
'
	definedIn: 'signaledException'
	definition: 'If the handler environment for the current exception handler contains an exception handler that will handle the receiver, evaluate that handler''s exception action with the receiver as the argument to its handler block. If there is no enclosing handler, send the message #defaultAction to the receiver. The #defaultAction method is evaluated using the current exception environment.
If the receiver is resumable and the evaluated exception action resumes then the result returned from #outer will be the resumption value of the evaluated exception action. If the receiver is not resumable or if the exception action does not resume then this message will not return.
For exceptions that are not resumable, #outer is equivalent to #pass.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'Object' #'unspecified') )
	errors: 'It is erroneous  to directly or indirectly send this message from within a <exceptionDescription>#defaultAction method to the receiver  of the #defaultAction message.
'
!

ProtocolSpec newMessagePattern: 'pass'
	forProtocolNamed: #'signaledException'
	synopsis: 'Yield control to the enclosing exception action for the receiver.
'
	definedIn: 'signaledException'
	definition: 'If the handler environment for the current exception handler contains an enclosing exception handler for the receiver, activate that handler''s exception action in place of the current exception action. If there is no enclosing handler, execute the default action for the receiver as if no handler had been found when the exception was originally signaled. The default action is evaluated in the context of the signaling environment.
Control does not return to the currently active exception handler.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #()
	errors: 'It is erroneous to directly or indirectly send this message from within a #defaultAction method  to the receiver of the #defaultAction method.
'
!

ProtocolSpec newMessagePattern: 'resignalAs: replacementException'
	forProtocolNamed: #'signaledException'
	synopsis: 'Signal an alternative exception in place of the receiver.
'
	definedIn: 'signaledException'
	definition: 'The active exception action is aborted and the exception environment and the evaluation context are restored to the same states that were in effect when the receiver was originally signaled. Restoring the evaluation context may result in the execution of #ensure: or #ifCurtailed:  termination blocks.
After the restoration, signal the replacementException and execute the exception action as determined by the restored exception environment.
This message causes the replacementException to be treated as if it had been originally signaled instead of the receiver.
If the replacementException is resumable and its exception action resumes, control will ultimately return from the message that signaled the original exception.
Control does not return from this message to the currently active exception action.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('replacementException' 'exceptionDescription' #'unspecified') )
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'resume'
	forProtocolNamed: #'signaledException'
	synopsis: 'Return from the message that signaled the receiver.
'
	definedIn: 'signaledException'
	definition: 'If the current exception action was activated as the result of sending the message #outer to the receiver, return a resumption value as the value of the #outer message.
If the receiver is a resumable exception a resumption value is returned as the value of the message that signaled the receiver. Before returning, the exception environment and the evaluation context are restored to the same states that were in effect when the receiver was originally signaled. Restoring the evaluation context may result in the execution of #ensure: or #ifCurtailed: termination blocks.
This message does not return to its point of invocation.
The resumption value is unspecified.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #()
	errors: 'It is erroneous to directly or indirectly send this message from within a #defaultAction method to the receiver of the #defaultAction method.
It is erroneous to send the message if the receiver is not resumable.
'
!

ProtocolSpec newMessagePattern: 'resume: resumptionValue'
	forProtocolNamed: #'signaledException'
	synopsis: 'Return the argument as the value of the message that signaled the receiver.
'
	definedIn: 'signaledException'
	definition: 'If the current exception action was activated as the result of sending the message #outer to the receiver, return resumptionValue as the value of the #outer message.
If the receiver is a resumable exception, the resumptionValue is returned as the value of the message that signaled the receiver. Before returning, the exception environment and the evaluation context are restored to the same states that were in effect when the receiver was originally signaled. Restoring the evaluation context may result in the execution of #ensure: or #ifCurtailed: termination blocks.
This message does not return to its point of invocation.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('resumptionValue' 'Object' #'uncaptured') )
	returnValues: #()
	errors: 'It is erroneous to directly or indirectly send this message from within a #defaultAction method  to the receiver of the #defaultAction method.
It is erroneous to send the message if the receiver is not resumable.
'
!

ProtocolSpec newMessagePattern: 'retry'
	forProtocolNamed: #'signaledException'
	synopsis: 'Abort an exception handler and re-evaluate its protected block.
'
	definedIn: 'signaledException'
	definition: 'The active exception action is aborted and the exception environment and the evaluation context are restored to the same states that were in effect when the #on:do: message that established the active handler was sent. Restoring the evaluation context may result in the execution of #ensure: or #ifCurtailed: termination blocks.
After the restoration, the #on:do: method is re-evaluated with its original receiver and arguments.
Control does not return from this message to the currently active exception action.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #()
	errors: 'It is erroneous to directly or indirectly send this message from within a #defaultAction method  to the receiver of the #defaultAction method.
'
!

ProtocolSpec newMessagePattern: 'retryUsing: alternativeBlock'
	forProtocolNamed: #'signaledException'
	synopsis: 'Abort an exception handler and evaluate a new block in place of the handler''s protected block.
'
	definedIn: 'signaledException'
	definition: 'The active exception action is aborted and the exception environment and the evaluation context are restored to the same states that were in effect when the #on:do: message that established the active handler was sent. Restoring the evaluation context may result in the execution of #ensure: or #ifCurtailed: blocks.
After the restoration, the #on:do: method is re-evaluated with alternativeBlock substituted for its original receiver. The original arguments are used for the re-evaluation.
Control does not return from this message to the currently active exception action.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('alternativeBlock' 'niladicBlock' #'captured') )
	returnValues: #()
	errors: 'It is erroneous to directly or indirectly send this message from within a #defaultAction method  to the receiver of the #defaultAction method.
'
!

ProtocolSpec newMessagePattern: 'return'
	forProtocolNamed: #'signaledException'
	synopsis: 'Return nil as the value of the block protected by the active exception handler.
'
	definedIn: 'signaledException'
	definition: 'Nil is return as the value of the protected block of the active exception handler. Before returning, the exception environment and the evaluation context are restored to the same states that were in effect when the active handler was created using #on:do:. Restoring the evaluation context may result in the execution of #ensure: or #ifCurtailed: termination blocks.
This message does not return to its point of invocation.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #()
	errors: 'It is erroneous  to directly or indirectly send this message from within a #defaultAction method  to the receiver of the #defaultAction method.
'
!

ProtocolSpec newMessagePattern: 'return: returnValue'
	forProtocolNamed: #'signaledException'
	synopsis: 'Return the argument as the value of the block protected by the active exception handler.
'
	definedIn: 'signaledException'
	definition: 'The returnValue is returned as the value of the protected block of the active exception handler. Before returning, the exception environment and the evaluation context are restored to the same states that were in effect when the active handler was created using #on:do:. Restoring the evaluation context may result in the execution of #ensure: or #ifCurtailed: termination blocks.
This message does not return to its point of invocation.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('returnValue' 'Object' #'uncaptured') )
	returnValues: #()
	errors: 'It is erroneous to directly or indirectly send this message from within a #defaultAction method  to the receiver of the #defaultAction method.





'
!

(ProtocolSpec newProtocolNamed: #'SortedCollection'
	conformsToProtocolNames: #(#'sequencedReadableCollection' #'extensibleCollection' #'sequencedContractibleCollection')
	) protocolDescription: '
Represents a variable sized collection of objects whose elements are ordered based on a sort order.  The sort order is specified by a <dyadicValuable> called the sort block. Elements may be added, removed or inserted, and can be accessed using external integer keys.
'
!

ProtocolSpec newMessagePattern: ', operand'
	forProtocolNamed: #'SortedCollection'
	synopsis: 'Answer a new collection which is the concatenation of the receiver and operand.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a new collection containing all of the receiver''s elements in their original order followed by all of the elements of operand, in their original order. The size of the new collection is equal to the sum of the sizes of the receiver and operand, as defined by the #size message.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
Unless specifically refined, this message is defined to answer an instance of the same type as the receiver.
'
	refinedIn: 'SortedCollection'
	refinement: 'Since the receiver sorts its elements, the result will also be sorted as defined by the receiver''s sort block.
'
	parameters: #( #('operand' 'sequencedReadableCollection' #'uncaptured') )
	returnValues: #( #( 'SortedCollection' #'new') )
	errors: 'If the elements of operand cannot be sorted using receiver''s sort block.
'
!

ProtocolSpec newMessagePattern: 'add: newElement'
	forProtocolNamed: #'SortedCollection'
	synopsis: 'Add newElement to the receiver''s elements.
'
	definedIn: 'extensibleCollection'
	definition: 'This message adds a newElement to the receiver. Unless specifically refined, the position of the newElement in the element traversal order is unspecified.
Conformant protocols may place restrictions on the type of objects that are valid elements. Unless otherwise specified, any object is acceptable.
'
	refinedIn: 'SortedCollection'
	refinement: 'Since the receiver maintains its elements in sorted order, the position of newElement will depend on the receiver''s sort block.
'
	parameters: #( #('newElement' 'Object' #'captured') )
	returnValues: #()
	errors: 'If newElement cannot be sorted using receiver''s sort block.
'
!

ProtocolSpec newMessagePattern: 'asSortedCollection'
	forProtocolNamed: #'SortedCollection'
	synopsis: 'Answer a sorted collection with the same elements as the receiver.
'
	definedIn: 'collection'
	definition: 'Answer a sorted collection with the same elements as the receiver. The default sort block is used unless another sort block is specified in a refinement.
'
	refinedIn: 'SortedCollection'
	refinement: 'The receiver''s sort block is used in the result.
'
	parameters: #()
	returnValues: #( #( 'SortedCollection' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'collect: transformer'
	forProtocolNamed: #'SortedCollection'
	synopsis: 'Answer a new collection constructed by gathering the results of evaluating transformer with each element of the receiver.
'
	definedIn: 'collection'
	definition: 'For each element of the receiver, transformer is evaluated with the element as the parameter. The results of these evaluations are collected into a new collection.
The elements are traversed in the order specified by the #do: message for the receiver.
Unless specifically refined, this message is defined to answer an objects conforming to the same protocol as the receiver.
'
	refinedIn: 'SortedCollection'
	refinement: 'Answer a <sequencedCollection>.
'
	parameters: #( #('transformer' 'monadicValuable' #'uncaptured') )
	returnValues: #( #( 'sequencedCollection' #'new') )
	errors: 'If the elements of the receiver are inappropriate for use as arguments to transformer.
If the result of evaluating the transformer is inappropriate for storage in the collection to be returned.
'
!

ProtocolSpec newMessagePattern: 'copyReplaceAll: targetElements with: replacementElements'
	forProtocolNamed: #'SortedCollection'
	synopsis: 'Answer a new collection in which all subsequences of elements in the receiver matching targetElements are replaced in the new collection by the elements in replacementElements.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a new collection with the elements of the receiver in their original order, except where a subsequence in the receiver matches targetElements. A subsequence in the receiver is said to match the elements of targetElements if:
1. They have the same number of elements.
2. For all indices of the subsequence, the element in the subsequence at a given index is equivalent to the element in targetElements at the same index.
Where a subsequence match is found, the elements from replacementElements are placed in the new collection instead.
Unless specifically refined, this message is defined to answer an instance of the same class as the receiver.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: 'SortedCollection'
	refinement: 'Since the receiver maintains its elements in sorted order, the positions of elements of replacementElements will depend on the receiver''s sort block.
'
	parameters: #( #('targetElements' 'sequencedReadableCollection' #'uncaptured') #('replacementElements' 'sequencedReadableCollection' #'unspecified') )
	returnValues: #( #( 'SortedCollection' #'new') )
	errors: 'If any of the elements in replacementElements does not conform to any element type restrictions of instances of the receiver''s class.
If the elements of replacementElements cannot be sorted using receiver''s sort block.
'
!

ProtocolSpec newMessagePattern: 'copyReplaceFrom: stop to: replacementElements with: start'
	forProtocolNamed: #'SortedCollection'
	synopsis: 'Answer a new collection, containing the same elements as the receiver, but with the elements in the receiver between start and stop inclusive replaced by the elements in replacementElements.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'This message can be used to insert, append, or replace. The size of replacementElements (as defined by #size) need not be the same as the number of elements being replaced. There are three cases:
1. If stop = start - 1 , and start is less than or equal to the size of the receiver, then the replacementElements are inserted between the elements at index stop and start. None of the receiver''s elements are replaced.
2. If stop = the size of the receiver and start = stop + 1, then the operation is an append, and the replacementElements are placed at the end of the new collection.
3. Otherwise, the operation is a replacement, and the receiver''s elements in the given range are replaced by the elements from replacementElements.
In all cases, the resulting collection consists of the receiver''s elements from indices 1 to start - 1 in their original order, followed by the elements of replacementElements, followed by the remainder of the receiver''s elements from index stop + 1 in their original order. The size of the result is the receiver''s size - (stop - start + 1) + the replacementElements size.
The parameters start and stop must be positive.
Unless specifically refined, this message is defined to answer an instance of the same class as the receiver''s class.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: 'SortedCollection'
	refinement: 'Since the receiver maintains its elements in sorted order, the positions of elements of replacementElements will depend on the receiver''s sort block.
'
	parameters: #( #('start' 'integer' #'uncaptured') #('stop' 'integer' #'uncaptured') #('replacementElements' 'sequencedReadableCollection' #'unspecified') )
	returnValues: #( #( 'SortedCollection' #'new') )
	errors: 'The elements in replacementElements are not suitable for storage in instances of the receiver''s class.
start > receiver''s size + 1
start < 1
stop > receiver''s size
stop < start - 1
If the elements of replacementElements cannot be sorted using receiver''s sort block.
'
!

ProtocolSpec newMessagePattern: 'copyReplaceFrom: stop to: replacementElement withObject: start'
	forProtocolNamed: #'SortedCollection'
	synopsis: 'Answer a new collection conforming to the same protocols as the receiver, in which the elements of the receiver between start and stop inclusive have been replaced with replacementElement.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'This message can be used to insert, append, or replace. There are three cases:
1. If stop = start - 1 , and start is less than or equal to the size of the receiver, then replacementElement is inserted between the elements at index stop and start. None of the receiver''s elements are replaced.
2. If stop = the size of the receiver and start = stop + 1, then the operation is an append, and replacementElement is placed at the end of the new collection.
3. Otherwise, the operation is a replacement, and each of the receiver''s elements in the given range is replaced by replacementElement.
The parameters start and stop must be non-negative.
Unless specifically refined, this message is defined to answer an instance of the same class as the receiver''s class.
Collections that by definition enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: 'SortedCollection'
	refinement: 'Since the receiver maintains its elements in sorted order, the position(s) occupied by replacementElement will depend on the receiver''s sort block.
'
	parameters: #( #('stop' 'integer' #'uncaptured') #('start' 'integer' #'uncaptured') #('replacementElement' 'Object' #'captured') )
	returnValues: #( #( 'SortedCollection' #'new') )
	errors: 'The replacementElement is not suitable for storage in instances of the receiver''s class.
start > receiver''s size + 1
start < 1
stop > receiver''s size
stop < start - 1
If replacementElement cannot be sorted using receiver''s sort block.
'
!

ProtocolSpec newMessagePattern: 'copyReplacing: replacementElement withObject: targetElement'
	forProtocolNamed: #'SortedCollection'
	synopsis: 'Answer a new collection conforming to the same protocols as the receiver, in which any occurrences of targetElement are replaced by replacementElement.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'A new collection is created and initialized with the same elements as the receiver in the same order, except that any objects in the receiver which are equivalent to targetElement are replaced in the new collection by replacementElement.
Unless specifically refined, this message is defined to answer an instance of the same class as the receiver.
Collections that enforce an ordering on their elements are permitted to refine this message to reorder the result.
'
	refinedIn: 'SortedCollection'
	refinement: 'Since the receiver maintains its elements in sorted order, the position occupied by replacementElement will depend on the receiver''s sort block.
'
	parameters: #( #('targetElement' 'Object' #'uncaptured') #('replacementElement' 'Object' #'captured') )
	returnValues: #( #( 'SortedCollection' #'new') )
	errors: 'If the replacementElement is inappropriate for storage in instances of the receiver''s class.
If replacementElement cannot be sorted using receiver''s sort block.
'
!

ProtocolSpec newMessagePattern: 'reverse'
	forProtocolNamed: #'SortedCollection'
	synopsis: 'Answer a collection with the elements of the receiver arranged in reverse order.
'
	definedIn: 'sequencedReadableCollection'
	definition: 'Answer a collection conforming to the same protocols as the receiver, but with its elements arranged in reverse order.
This operation is equivalent to:
1. Create a new collection which conforms to the same protocols as the receiver;
2. Traverse the elements of the receiver in the order specified by the #reverseDo: message, adding each element of the receiver to the new collection;
3. Answer the new collection.
'
	refinedIn: 'SortedCollection'
	refinement: 'Answer a <sequencedReadableCollection>.
'
	parameters: #()
	returnValues: #( #( 'sequencedReadableCollection' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'sortBlock'
	forProtocolNamed: #'SortedCollection'
	synopsis: 'Answer the receiver''s sort block.
'
	definedIn: 'SortedCollection'
	definition: 'Answer the receiver''s sort block. The sort block is defined by the #sortBlock: message.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'dyadicValuable' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'sortBlock: discriminator'
	forProtocolNamed: #'SortedCollection'
	synopsis: 'Set the receiver''s sort block to discriminator.
'
	definedIn: 'SortedCollection'
	definition: 'This message defines the sort block used to specify the receiver''s ordering criteria. The sortBlock is a 2-parameter <block>, which when evaluated with any two elements in the receiver, answers true if the first parameter should be ordered before the second parameter, and false otherwise. The sort block must obey the following properties:
1. Given the same 2 parameters, the sort block must answer the same result.
2. The sort block must obey transitivity. For example, if a is before b, and b is before c, then a must be before c.
The receiver''s sort block is set to discriminator, and the elements are re-sorted.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('discriminator' 'dyadicValuable' #'captured') )
	returnValues: #( #( 'SortedCollection' #'new') )
	errors: 'If the elements of the receiver cannot be sorted using the discriminator.










'
!

(ProtocolSpec newProtocolNamed: #'SortedCollection factory'
	conformsToProtocolNames: #(#'initializableCollection factory')
	) protocolDescription: '
Represents protocol for creating a variable sized collection of objects whose elements are ordered based on a sort order specified by a two parameter block called the sort block. Elements may be added, removed or inserted, and can be accessed using external integer keys.
Standard Globals
SortedCollection	Conforms to the protocol <SortedCollection factory>. Its language element type is unspecified. This is a factory and discriminator for collections that conform to <SortedCollection>.
'
!

ProtocolSpec newMessagePattern: 'new'
	forProtocolNamed: #'SortedCollection factory'
	synopsis: 'Create a new object.
'
	definedIn: 'instantiator'
	definition: 'Return a newly created object initialized to a standard initial state.
'
	refinedIn: 'SortedCollection factory'
	refinement: 'A sort block is supplied which guarantees that the elements will be sorted in ascending order as specified by the #< message for the elements. The collection''s representation should be optimized to store an arbitrary number of elements.
'
	parameters: #()
	returnValues: #()
	errors: ''
!

ProtocolSpec newMessagePattern: 'new: count'
	forProtocolNamed: #'SortedCollection factory'
	synopsis: 'Create a new collection. The parameter count constrains the number of elements in the result.
'
	definedIn: 'collection factory'
	definition: 'Return a new collection that has space for at least count elements.
Conforming protocols may refine this message. In particular, the effect of the parameter count should be specified in refinements. It can be used to specify the exact number of elements, the minimum number, or in some cases can even be interpreted as a hint from the programmer, with no guarantee that the requested number of instance variables will actually be allocated.
Unless otherwise stated the initial values of elements of the new instance of the receiver are unspecified.
'
	refinedIn: 'SortedCollection factory'
	refinement: 'The parameter count represents an estimate of the maximum number of elements in the collection. The representation may be optimized for this size.
A sort block is supplied which guarantees that the elements will be sorted in ascending order as specified by the #< message for the elements.
'
	parameters: #( #('count' 'integer' #'unspecified') )
	returnValues: #( #( 'SortedCollection' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'sortBlock: sortBlock'
	forProtocolNamed: #'SortedCollection factory'
	synopsis: 'Create a new sorted collection with sortBlock as the sort block.
'
	definedIn: 'SortedCollection factory'
	definition: 'Return a new sorted collection with sortBlock as the sort block. The sortBlock specifies the ordering criteria for the new collection and is a two-parameter valuable, which when evaluated with any two elements in the receiver, answers true if the first parameter should be ordered before the second parameter, and false otherwise. The sort block must obey the following properties:
1. Given the same two parameters, the sort block must answer the same result.
2. The sort block must obey transitivity. For example, if a is before b, and b is before c, then a must be before c.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('sortBlock' 'dyadicValuable' #'captured') )
	returnValues: #( #( 'SortedCollection' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'with: firstElement'
	forProtocolNamed: #'SortedCollection factory'
	synopsis: 'Create a collection initially containing the argument element.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing one element.  The collection contains the argument as its element.
Conforming protocols may impose restrictions on the value of the argument and hence the element type.
'
	refinedIn: 'SortedCollection factory'
	refinement: 'A sort block is supplied which guarantees that the elements will be sorted in ascending order as specified by the #< message for the elements.
'
	parameters: #( #('firstElement' 'Object' #'captured') )
	returnValues: #( #( 'SortedCollection' #'new') )
	errors: 'If the argument is not appropriate as parameter to the default sort block.

'
!

ProtocolSpec newMessagePattern: 'with: firstElement with: secondElement'
	forProtocolNamed: #'SortedCollection factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing two element.  The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'SortedCollection factory'
	refinement: 'A sort block is supplied which guarantees that the elements will be sorted in ascending order as specified by the #< message for the elements. The initial elements are ordered according to this sort block.
'
	parameters: #( #('firstElement' 'Object' #'captured') #('secondElement' 'Object' #'captured') )
	returnValues: #( #( 'SortedCollection' #'new') )
	errors: 'If any of the arguments are not appropriate as parameters to the default sort block.

'
!

ProtocolSpec newMessagePattern: 'with: thirdElement with: secondElement with: firstElement'
	forProtocolNamed: #'SortedCollection factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing three element.  The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'SortedCollection factory'
	refinement: 'A sort block is supplied which guarantees that the elements will be sorted in ascending order as specified by the #< message for the elements. The initial elements are ordered according to this sort block.
'
	parameters: #( #('thirdElement' 'Object' #'captured') #('secondElement' 'Object' #'captured') #('firstElement' 'Object' #'captured') )
	returnValues: #( #( 'SortedCollection' #'new') )
	errors: 'If any of the arguments are not appropriate as parameters to the default sort block.

'
!

ProtocolSpec newMessagePattern: 'with: thirdElement with: fourthElement with: firstElement with: secondElement'
	forProtocolNamed: #'SortedCollection factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing four elements.  The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'SortedCollection factory'
	refinement: 'A sort block is supplied which guarantees that the elements will be sorted in ascending order as specified by the #< message for the elements. The initial elements are ordered according to this sort block.
'
	parameters: #( #('thirdElement' 'Object' #'captured') #('fourthElement' 'Object' #'captured') #('firstElement' 'Object' #'captured') #('secondElement' 'Object' #'captured') )
	returnValues: #( #( 'SortedCollection' #'new') )
	errors: 'If any of the arguments are not appropriate as parameters to the default sort block.

'
!

ProtocolSpec newMessagePattern: 'withAll: newElements'
	forProtocolNamed: #'SortedCollection factory'
	synopsis: 'Create a collection containing only the elements of newElements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection whose elements are the elements of newElements.
Conforming protocols may impose restrictions on the values of newElements.
'
	refinedIn: 'SortedCollection factory'
	refinement: 'A sort block is supplied which guarantees that the elements will be sorted in ascending order as specified by the #< message for the elements. The initial elements are ordered according to this sort block. 
'
	parameters: #( #('newElements' 'collection' #'unspecified') )
	returnValues: #( #( 'SortedCollection' #'new') )
	errors: 'If any element of newElements is not appropriate as a parameter to the default sort block.






'
!

(ProtocolSpec newProtocolNamed: #'String'
	conformsToProtocolNames: #(#'sequencedCollection' #'readableString')
	) protocolDescription: '
Provides protocol for string operations such as copying, storing, comparing, replacing, converting, indexing, and matching.  The element type of <String> is <Character>.  The range of codePoints of characters that may be elements of a <String> is implementation defined.
'
!

ProtocolSpec newMessagePattern: 'asString'
	forProtocolNamed: #'String'
	synopsis: 'Answer a string containing the same characters as the receiver.
'
	definedIn: 'readableString'
	definition: 'Answer a string containing the same characters as the receiver, in their original order.
'
	refinedIn: 'String'
	refinement: 'Answer the receiver.
'
	parameters: #()
	returnValues: #( #( 'String' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'String factory'
	conformsToProtocolNames: #(#'initializableCollection factory')
	) protocolDescription: '
This protocol defines the behavior of objects that can be used to create objects that conform to <String>.  These objects are created with a specified size.
Standard Globals
String	Conforms to the protocol <String factory>. Its language element type is unspecified. This is a factory and discriminator for collections that conform to <String>.
'
!

ProtocolSpec newMessagePattern: 'new'
	forProtocolNamed: #'String factory'
	synopsis: 'Create a new object.
'
	definedIn: 'instantiator'
	definition: 'Return a newly created object initialized to a standard initial state.
'
	refinedIn: 'String factory'
	refinement: 'Create a new  <String> that contains no elements.
'
	parameters: #()
	returnValues: #( #( 'String' #'new') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'new: count'
	forProtocolNamed: #'String factory'
	synopsis: 'Create a new collection. The parameter count constrains the number of elements in the result.
'
	definedIn: 'collection factory'
	definition: 'Return a new collection that has space for at least count elements.
Conforming protocols may refine this message. In particular, the effect of the parameter count should be specified in refinements. It can be used to specify the exact number of elements, the minimum number, or in some cases can even be interpreted as a hint from the programmer, with no guarantee that the requested number of instance variables will actually be allocated.
Unless otherwise stated the initial values of elements of the new instance of the receiver are unspecified.
'
	refinedIn: 'String factory'
	refinement: 'The parameter count specifies the size of the receiver. The initial value of each element of the new instance of the receiver is unspecified. The new collections conforms to the protocol <String>.
'
	parameters: #( #('count' 'integer' #'unspecified') )
	returnValues: #( #( 'String' #'new') )
	errors: 'count<0

'
!

ProtocolSpec newMessagePattern: 'with: element1'
	forProtocolNamed: #'String factory'
	synopsis: 'Create a collection initially containing the argument element.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing one element.  The collection contains the argument as its element.
Conforming protocols may impose restrictions on the value of the argument and hence the element type.
'
	refinedIn: 'String factory'
	refinement: 'The argument is at index position 1.
'
	parameters: #( #('element1' 'Character' #'captured') )
	returnValues: #( #( 'String' #'new') )
	errors: 'If the argument does not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element1 with: element2'
	forProtocolNamed: #'String factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing two elements.  The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'String factory'
	refinement: 'The first argument is at index position 1, the second argument is at index position 2.
'
	parameters: #( #('element1' 'Character' #'captured') #('element2' 'Character' #'captured') )
	returnValues: #( #( 'String' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element2 with: element1 with: element3'
	forProtocolNamed: #'String factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing three elements. The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'String factory'
	refinement: 'The first argument is at index position 1, the second argument is at index position 2, and so on.
'
	parameters: #( #('element2' 'Character' #'captured') #('element1' 'Character' #'captured') #('element3' 'Character' #'captured') )
	returnValues: #( #( 'String' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'with: element3 with: element4 with: element2 with: element1'
	forProtocolNamed: #'String factory'
	synopsis: 'Create a collection initially containing the argument elements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection containing four elements.  The collection contains the arguments as its elements.
Conforming protocols may impose restrictions on the values of the arguments and hence the element types.
'
	refinedIn: 'String factory'
	refinement: 'The first argument is at index position 1, the second argument is at index position 2, and so on.
'
	parameters: #( #('element2' 'Character' #'captured') #('element1' 'Character' #'captured') #('element3' 'Character' #'captured') #('element4' 'Character' #'captured') )
	returnValues: #( #( 'String' #'new') )
	errors: 'If any of the arguments do not meet the element type constraints of the result object

'
!

ProtocolSpec newMessagePattern: 'withAll: newElements'
	forProtocolNamed: #'String factory'
	synopsis: 'Create a collection containing only the elements of newElements.
'
	definedIn: 'initializableCollection factory'
	definition: 'Return a new collection whose elements are the elements of newElements.
Conforming protocols may impose restrictions on the values of newElements.
'
	refinedIn: 'String factory'
	refinement: 'If the elements of newElements are ordered then their ordering establishing their index positions in the new collection.
'
	parameters: #( #('newElements' 'collection' #'unspecified') )
	returnValues: #( #( 'String' #'new') )
	errors: 'If any of the elements of newElements do not meet the element type constraints of the result object






1.8 Date and Time Protocols
The standard defines protocols for date and time objects that refer to a specific point in time, and duration objects that represent a length of time.











'
!

(ProtocolSpec newProtocolNamed: #'symbol'
	conformsToProtocolNames: #(#'readableString')
	) protocolDescription: '
Represents an ordered, variable sized and immutable collection of characters. There is a unique object conforming to this protocol for every possible sequence of characters.  Symbols are identity objects.
'
!

ProtocolSpec newMessagePattern: 'asString'
	forProtocolNamed: #'symbol'
	synopsis: 'Answer a string containing the same characters as the receiver.
'
	definedIn: 'readableString'
	definition: 'Answer a string containing the same characters as the receiver, in their original order.
'
	refinedIn: 'symbol'
	refinement: 'Answer an object that is not identical to the receiver
'
	parameters: #()
	returnValues: #( #( 'readableString' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'asSymbol'
	forProtocolNamed: #'symbol'
	synopsis: 'Answer a symbol containing the same characters as the receiver.
'
	definedIn: 'readableString'
	definition: 'Answer a symbol containing the same characters as the receiver, in their original order.
'
	refinedIn: 'symbol'
	refinement: 'Answer the receiver.
'
	parameters: #()
	returnValues: #( #( 'symbol' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Transcript'
	conformsToProtocolNames: #(#'puttableStream')
	) protocolDescription: '
An object conforming to <Transcript> is a <puttableStream> for logging status messages from Smalltalk programs. The sequence value type of <Transcript> is <Character>. There may be an implementation defined stream backing store that receives characters written to the stream in an implementatiuon defined manner.
Standard Globals
Transcript	Conforms to the protocol <Transcript>. Its language element type is unspecified. This is a <Transcript> that is always available to output textual messages in an implementtion defined manner.
'
!

(ProtocolSpec newProtocolNamed: #'valuable'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
This protocol describes the behavior for objects that can be evaluated using variants of the #value message.
Rationale
chose to use selector #ifCurtailed: because of objections to #ifTruncated: and #ifTerminated:.as to suggest of process management operations.
'
!

ProtocolSpec newMessagePattern: 'argumentCount'
	forProtocolNamed: #'valuable'
	synopsis: 'Answers the number of arguments needed to evaluate the receiver.
'
	definedIn: 'valuable'
	definition: 'The number of arguments needed to evaluate the receiver is returned.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'integer' #'unspecified') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'valueWithArguments: argumentArray'
	forProtocolNamed: #'valuable'
	synopsis: 'Answers the value of the receiver when applied to the arguments in argumentArray.
'
	definedIn: 'valuable'
	definition: 'The receiver is evaluated as defined by the receiver.
Note that in the case that the receiver is a block, that the evaluation is defined by the language with the elements of argumentArray bound in sequence to the receiver''s arguments.
The result is as defined by the receiver.
The results are undefined if the size of argumentArray does not equal the receiver''s argument count.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('argumentArray' 'sequencedReadableCollection' #'uncaptured') )
	returnValues: #( #( 'ANY' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Warning'
	conformsToProtocolNames: #(#'Notification')
	) protocolDescription: '
This protocol describes the behavior of instances of class Warning. These are used to represent exceptional conditions that might occur that are not considered errors but which should be reported to the user. Typically, the actual warning exceptions used by an application will be subclasses of this class.
As Warning is explicitly specified  to be subclassable, conforming implementations must implement its behavior in a non-fragile manner.
'
!

ProtocolSpec newMessagePattern: 'defaultAction'
	forProtocolNamed: #'Warning'
	synopsis: 'The default action taken if the exception is signaled.
'
	definedIn: 'exceptionDescription'
	definition: 'If the exception described by the receiver is signaled and the current exception environment does not contain a handler for the exception this method will be executed.
The exact behavior and result of this method is implementation defined.
'
	refinedIn: 'Warning'
	refinement: 'The user should be notified of the occurrence of an exceptional occurrence and given an option of continuing or aborting the computation. The description of the occurrence should include any text specified as the argument of the #signal: message.
'
	parameters: #()
	returnValues: #()
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'Warning class'
	conformsToProtocolNames: #(#'Notification class')
	) protocolDescription: '
This protocol describe the behavior of the global Warning. The value of the standard global Warning is a class object that conforms to this protocol. The class Warning is explicitly specified  to be subclassable in a standard conforming program.  Conforming implementations must implement its behaviors in a non-fragile manner.
The signaled exceptions generated by this type of object conform to the protocol <Warning>.
Standard Globals
Warning	A class name. Conforms to the protocol <Warning class>. Warning must inherit (possibly indirectly) from the class Notification.  Instances of this class conform to the protocol <Warning>.
'
!

ProtocolSpec newMessagePattern: 'new'
	forProtocolNamed: #'Warning class'
	synopsis: ''
	definedIn: 'instantiator'
	definition: 'Return a newly created object initialized to a standard initial state.
'
	refinedIn: 'Warning class'
	refinement: 'The object returned conforms to <Warning>
'
	parameters: #()
	returnValues: #( #( 'Warning' #'new') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'writeFileStream'
	conformsToProtocolNames: #(#'puttableStream' #'FileStream')
	) protocolDescription: '
Provides protocol for storing elements in an external file. The sequence values are provided by the external file which also serves as the stream backing store. A <writeFileStream> is a write-back stream.
'
!

(ProtocolSpec newProtocolNamed: #'WriteStream'
	conformsToProtocolNames: #(#'puttableStream' #'collectionStream')
	) protocolDescription: ' <WriteStream>
An object conforming to <WriteStream> has a positionable sequence of values to which new values may be written. The initial sequence values are provided by a collection that serves as the stream backing store. It is implementation defined whether a <WriteStream> is a write-back stream. Even if a <WriteStream> is not a write-back stream, its associated collection may be subject to modification in an unspecified manner as long as it is associated with the stream.
'
!

(ProtocolSpec newProtocolNamed: #'WriteStream factory'
	conformsToProtocolNames: #(#'Object')
	) protocolDescription: '
<WriteStream factory> provides for the creation of objects conforming to the <WriteStream> protocol whose sequence values are supplied by a collection.
Standard Globals
WriteStream	Conforms to the protocol <WriteStream factory >. Its language element type is unspecified. This is a factory for streams that conform to <WriteStream>.
'
!

ProtocolSpec newMessagePattern: 'with: aCollection'
	forProtocolNamed: #'WriteStream factory'
	synopsis: 'Returns a stream that appends to the given collection.
'
	definedIn: 'WriteStream factory'
	definition: 'Returns an object conforming to <WriteStream> whose past sequence values initially consist of the elements of aCollection and which initially has no future sequence values. The ordering of the sequence values is the same as the ordering used by #do: when sent to aCollection. The stream backing store of the returned object is aCollection. The sequence value type of the write stream is the element type of aCollection. Any restrictions on objects that may be elements of aCollection also apply to the stream''s sequence elements.
'
	refinedIn: ''
	refinement: ''
	parameters: #( #('aCollection' 'sequencedCollection' #'captured') )
	returnValues: #( #( 'WriteStream' #'new') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'ZeroDivide'
	conformsToProtocolNames: #(#'Error')
	) protocolDescription: '
This protocol describes the behavior of exceptions that are signalled when an attempt is made to divide some number (the dividend) by zero.
'
!

ProtocolSpec newMessagePattern: 'dividend'
	forProtocolNamed: #'ZeroDivide'
	synopsis: 'Answer the number that was being divided by zero.
'
	definedIn: 'ZeroDivide'
	definition: 'Answer the number that was being divided by zero.
'
	refinedIn: ''
	refinement: ''
	parameters: #()
	returnValues: #( #( 'number' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'isResumable'
	forProtocolNamed: #'ZeroDivide'
	synopsis: 'Determine whether an exception is resumable.
'
	definedIn: 'exceptionDescription'
	definition: 'This message is used to determine whether the receiver is a resumable exception. Answer true if the receiver is resumable. Answer false if the receiver is not resumable.
'
	refinedIn: 'ZeroDivide'
	refinement: 'Answer true.
'
	parameters: #()
	returnValues: #( #( 'boolean' #'unspecified') )
	errors: ''
!

(ProtocolSpec newProtocolNamed: #'ZeroDivide factory'
	conformsToProtocolNames: #(#'exceptionInstantiator')
	) protocolDescription: '
This protocol describe the behavior of the global ZeroDivide. It is used to as an exception selector to catch zero divide exceptions and can also be used to signal that a division by zero error has occured. Zero divide exceptions are resumable so any message in this protocol that signal such an exception may ultimately return to their sender. The signaled exceptions generated by this type of object conform to the protocol <ZeroDivide> 
Standard Globals
ZeroDivide	Unspecified language element type. Conforms to the protocol <ZeroDivide class>.
'
!

ProtocolSpec newMessagePattern: 'dividend: argument'
	forProtocolNamed: #'ZeroDivide factory'
	synopsis: 'Signal the occurance of a division by zero.
'
	definedIn: ''
	definition: ''
	refinedIn: 'ZeroDivide factory'
	refinement: 'Signal the occurance of a division by zero exception. Capture the number that was being divided such that it is available from the signaled exception.
If the message #dividend is subsequently sent to the <ZeroDivide> object that is the signaled exception the value of argument is returned.
'
	parameters: #( #('argument' 'number' #'captured') )
	returnValues: #( #( 'Object' #'state') )
	errors: ''
!

ProtocolSpec newMessagePattern: 'signal'
	forProtocolNamed: #'ZeroDivide factory'
	synopsis: ''
	definedIn: 'exceptionSignaler'
	definition: 'Associated with the receiver is an <exceptionDescription> called the signaled exception. The current exception environment is searched for an exception handler whose exception selector matches the signaled exception. The search proceeds from the most recently created exception handler to the oldest exception handler.
A matching handler is defined to be one which would return true if the message #handles: was sent to its exception selector with the signaled exception as the argument.
If a matching handler is found, the exception action of the handler is evaluated in the exception environment that was current when the handler was created and the state of the current exception environment is preserved as the signaling environment.
The exception action is evaluated as if the message #value: were sent to it with a <signaledException> passed as its argument. The <signaledException> is derived from the signaled exception in an implementation dependent manner.
If the evaluation of the exception action returns normally (as if it had returned from the #value: message), the handler environment is restored and the value returned from the exception action is returned as the value of the #on:do: message that created the handler. Before returning, any active #ensure: or #ifCurtailed: termination blocks created during evaluation of the receiver of the #on:do: message are evaluated.
If a matching handler is not found when the exception environment is searched, the default action for the signaled exception is performed. This is accomplished as if the message #defaultAction were sent to the <signaledException>  object derived from the signaled exception. The #defaultAction method is executed in the context of the signaling environment. If the signaled exception is resumable the value returned from the #defaultAction method is returned as the value of the #signal message. If the signaled exception is not resumable the action taken upon completion of the #defaultAction method is implementation defined.
'
	refinedIn: 'ZeroDivide factory'
	refinement: 'The signaled exception  conforms to <ZeroDivide>  and all of its <exceptionDescription> attributes set to their default values.
'
	parameters: #()
	returnValues: #( #( 'Object' #'unspecified') )
	errors: ''
!
